package ma.fstt.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.naming.Context;
import javax.naming.InitialContext;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Properties;

@WebServlet("/suivie")
public class SuivieServlet extends HttpServlet {
    private Object suivieEJB;

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
                    suivieEJB = context.lookup(jndiName);
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
                    listSuivies(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteSuivie(request, response);
                    break;
                default:
                    listSuivies(request, response);
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
                    insertSuivie(request, response);
                    break;
                case "update":
                    updateSuivie(request, response);
                    break;
                default:
                    listSuivies(request, response);
            }
        } catch (Exception e) {
            throw new ServletException("Error processing request", e);
        }
    }

    private void listSuivies(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<?> suivies = (List<?>) suivieEJB.getClass().getMethod("listSuivies").invoke(suivieEJB);
        request.setAttribute("suivies", suivies);
        request.getRequestDispatcher("/suivies/list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        // Charger les étudiants et modules pour les dropdowns
        List<?> etudiants = (List<?>) suivieEJB.getClass().getMethod("listEtudiants").invoke(suivieEJB);
        List<?> modules = (List<?>) suivieEJB.getClass().getMethod("listModules").invoke(suivieEJB);
        
        request.setAttribute("etudiants", etudiants);
        request.setAttribute("modules", modules);
        request.getRequestDispatcher("/suivies/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Long id = Long.parseLong(request.getParameter("id"));
        Object suivie = suivieEJB.getClass().getMethod("trouverSuivie", Long.class)
                .invoke(suivieEJB, id);
        
        // Charger les étudiants et modules pour les dropdowns
        List<?> etudiants = (List<?>) suivieEJB.getClass().getMethod("listEtudiants").invoke(suivieEJB);
        List<?> modules = (List<?>) suivieEJB.getClass().getMethod("listModules").invoke(suivieEJB);
        
        request.setAttribute("suivie", suivie);
        request.setAttribute("etudiants", etudiants);
        request.setAttribute("modules", modules);
        request.getRequestDispatcher("/suivies/form.jsp").forward(request, response);
    }

    private void insertSuivie(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        // Use EJB's ClassLoader to load the entity classes
        ClassLoader ejbClassLoader = suivieEJB.getClass().getClassLoader();
        Class<?> suivieClass = ejbClassLoader.loadClass("ma.fstt.ejb.entities.Suivie");
        Class<?> etudiantClass = ejbClassLoader.loadClass("ma.fstt.ejb.entities.Etudiant");
        Class<?> moduleClass = ejbClassLoader.loadClass("ma.fstt.ejb.entities.Module");
        
        Object suivie = suivieClass.getConstructor().newInstance();

        // Récupérer l'étudiant et le module
        Long etudiantId = Long.parseLong(request.getParameter("etudiantId"));
        Long moduleId = Long.parseLong(request.getParameter("moduleId"));
        
        Object etudiant = suivieEJB.getClass().getMethod("trouverEtudiant", Long.class)
                .invoke(suivieEJB, etudiantId);
        Object module = suivieEJB.getClass().getMethod("trouverModule", Long.class)
                .invoke(suivieEJB, moduleId);

        // Setter les valeurs
        Double note = Double.parseDouble(request.getParameter("note"));
        String dateStr = request.getParameter("date");
        Date date = new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);

        suivieClass.getMethod("setNote", Double.class).invoke(suivie, note);
        suivieClass.getMethod("setDate", Date.class).invoke(suivie, date);
        suivieClass.getMethod("setEtudiant", etudiantClass).invoke(suivie, etudiant);
        suivieClass.getMethod("setModule", moduleClass).invoke(suivie, module);

        suivieEJB.getClass().getMethod("ajouterSuivie", suivieClass).invoke(suivieEJB, suivie);

        response.sendRedirect(request.getContextPath() + "/suivie?action=list");
    }

    private void updateSuivie(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Long id = Long.parseLong(request.getParameter("id"));
        
        // Use EJB's ClassLoader to load the entity classes
        ClassLoader ejbClassLoader = suivieEJB.getClass().getClassLoader();
        Class<?> suivieClass = ejbClassLoader.loadClass("ma.fstt.ejb.entities.Suivie");
        Class<?> etudiantClass = ejbClassLoader.loadClass("ma.fstt.ejb.entities.Etudiant");
        Class<?> moduleClass = ejbClassLoader.loadClass("ma.fstt.ejb.entities.Module");
        
        Object suivie = suivieClass.getConstructor().newInstance();

        // Récupérer l'étudiant et le module
        Long etudiantId = Long.parseLong(request.getParameter("etudiantId"));
        Long moduleId = Long.parseLong(request.getParameter("moduleId"));
        
        Object etudiant = suivieEJB.getClass().getMethod("trouverEtudiant", Long.class)
                .invoke(suivieEJB, etudiantId);
        Object module = suivieEJB.getClass().getMethod("trouverModule", Long.class)
                .invoke(suivieEJB, moduleId);

        // Setter les valeurs
        Double note = Double.parseDouble(request.getParameter("note"));
        String dateStr = request.getParameter("date");
        Date date = new SimpleDateFormat("yyyy-MM-dd").parse(dateStr);

        suivieClass.getMethod("setId", Long.class).invoke(suivie, id);
        suivieClass.getMethod("setNote", Double.class).invoke(suivie, note);
        suivieClass.getMethod("setDate", Date.class).invoke(suivie, date);
        suivieClass.getMethod("setEtudiant", etudiantClass).invoke(suivie, etudiant);
        suivieClass.getMethod("setModule", moduleClass).invoke(suivie, module);

        suivieEJB.getClass().getMethod("modifierSuivie", suivieClass).invoke(suivieEJB, suivie);

        response.sendRedirect(request.getContextPath() + "/suivie?action=list");
    }

    private void deleteSuivie(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Long id = Long.parseLong(request.getParameter("id"));
        suivieEJB.getClass().getMethod("supprimerSuivie", Long.class).invoke(suivieEJB, id);
        response.sendRedirect(request.getContextPath() + "/suivie?action=list");
    }
}

