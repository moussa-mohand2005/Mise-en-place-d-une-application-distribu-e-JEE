package ma.fstt.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.naming.Context;
import javax.naming.InitialContext;
import java.io.IOException;
import java.util.List;
import java.util.Properties;

@WebServlet("/module")
public class ModuleServlet extends HttpServlet {
    private Object moduleEJB;

    @Override
    public void init() throws ServletException {
        try {
            Context context = new InitialContext();
            
            String[] jndiNames = {
                "java:global/EJB/GestionEtudiantBean!ma.fstt.ejb.interfaces.GestionEtudiantRemote",
                "java:app/EJB/GestionEtudiantBean!ma.fstt.ejb.interfaces.GestionEtudiantRemote",
                "ejb:/EJB/GestionEtudiantBean!ma.fstt.ejb.interfaces.GestionEtudiantRemote"
            };
            
            for (String jndiName : jndiNames) {
                try {
                    moduleEJB = context.lookup(jndiName);
                    System.out.println("✅ EJB found at: " + jndiName);
                    return;
                } catch (Exception ignored) {}
            }
            
            throw new ServletException("EJB not found");
        } catch (Exception e) {
            throw new ServletException("Failed to initialize EJB connection", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "list":
                    listModules(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteModule(request, response);
                    break;
                default:
                    listModules(request, response);
            }
        } catch (Exception e) {
            throw new ServletException("Error processing request", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "insert":
                    insertModule(request, response);
                    break;
                case "update":
                    updateModule(request, response);
                    break;
                default:
                    listModules(request, response);
            }
        } catch (Exception e) {
            throw new ServletException("Error processing request", e);
        }
    }

    private void listModules(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<?> modules = (List<?>) moduleEJB.getClass().getMethod("listModules").invoke(moduleEJB);
        request.setAttribute("modules", modules);
        request.getRequestDispatcher("/modules/list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/modules/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Long id = Long.parseLong(request.getParameter("id"));
        Object module = moduleEJB.getClass().getMethod("trouverModule", Long.class)
                .invoke(moduleEJB, id);
        request.setAttribute("module", module);
        request.getRequestDispatcher("/modules/form.jsp").forward(request, response);
    }

    private void insertModule(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        // Use EJB's ClassLoader to load the entity class
        ClassLoader ejbClassLoader = moduleEJB.getClass().getClassLoader();
        Class<?> moduleClass = ejbClassLoader.loadClass("ma.fstt.ejb.entities.Module");
        Object module = moduleClass.getConstructor().newInstance();

        moduleClass.getMethod("setCode", String.class).invoke(module, request.getParameter("code"));
        moduleClass.getMethod("setNom", String.class).invoke(module, request.getParameter("nom"));
        moduleClass.getMethod("setDescription", String.class).invoke(module, request.getParameter("description"));

        moduleEJB.getClass().getMethod("ajouterModule", moduleClass).invoke(moduleEJB, module);

        response.sendRedirect(request.getContextPath() + "/module?action=list");
    }

    private void updateModule(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Long id = Long.parseLong(request.getParameter("id"));
        
        // Use EJB's ClassLoader to load the entity class
        ClassLoader ejbClassLoader = moduleEJB.getClass().getClassLoader();
        Class<?> moduleClass = ejbClassLoader.loadClass("ma.fstt.ejb.entities.Module");
        Object module = moduleClass.getConstructor().newInstance();

        moduleClass.getMethod("setId_module", Long.class).invoke(module, id);
        moduleClass.getMethod("setCode", String.class).invoke(module, request.getParameter("code"));
        moduleClass.getMethod("setNom", String.class).invoke(module, request.getParameter("nom"));
        moduleClass.getMethod("setDescription", String.class).invoke(module, request.getParameter("description"));

        moduleEJB.getClass().getMethod("modifierModule", moduleClass).invoke(moduleEJB, module);

        response.sendRedirect(request.getContextPath() + "/module?action=list");
    }

    private void deleteModule(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Long id = Long.parseLong(request.getParameter("id"));
        moduleEJB.getClass().getMethod("supprimerModule", Long.class).invoke(moduleEJB, id);
        response.sendRedirect(request.getContextPath() + "/module?action=list");
    }
}

