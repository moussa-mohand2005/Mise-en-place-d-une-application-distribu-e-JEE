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

@WebServlet("/etudiant")
public class EtudiantServlet extends HttpServlet {
    private Object etudiantEJB;

    @Override
    public void init() throws ServletException {
        try {
            // Local lookup (same server)
            Context context = new InitialContext();
            
            // Try multiple JNDI patterns
            String[] jndiNames = {
                "java:global/EJB/GestionEtudiantBean!ma.fstt.ejb.interfaces.GestionEtudiantRemote",
                "java:app/EJB/GestionEtudiantBean!ma.fstt.ejb.interfaces.GestionEtudiantRemote",
                "ejb:/EJB/GestionEtudiantBean!ma.fstt.ejb.interfaces.GestionEtudiantRemote"
            };
            
            Exception lastException = null;
            for (String jndiName : jndiNames) {
                try {
                    etudiantEJB = context.lookup(jndiName);
                    System.out.println("✅ EJB found at: " + jndiName);
                    return; // Success!
                } catch (Exception e) {
                    lastException = e;
                    System.out.println("❌ Not found at: " + jndiName);
                }
            }
            
            throw new ServletException("EJB not found. Last error: " + lastException.getMessage(), lastException);
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
                    listEtudiants(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteEtudiant(request, response);
                    break;
                default:
                    listEtudiants(request, response);
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
                    insertEtudiant(request, response);
                    break;
                case "update":
                    updateEtudiant(request, response);
                    break;
                default:
                    listEtudiants(request, response);
            }
        } catch (Exception e) {
            throw new ServletException("Error processing request", e);
        }
    }

    private void listEtudiants(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<?> etudiants = (List<?>) etudiantEJB.getClass().getMethod("listEtudiants").invoke(etudiantEJB);
        request.setAttribute("etudiants", etudiants);
        request.getRequestDispatcher("/etudiants/list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/etudiants/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Long id = Long.parseLong(request.getParameter("id"));
        Object etudiant = etudiantEJB.getClass().getMethod("trouverEtudiant", Long.class)
                .invoke(etudiantEJB, id);
        request.setAttribute("etudiant", etudiant);
        request.getRequestDispatcher("/etudiants/form.jsp").forward(request, response);
    }

    private void insertEtudiant(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        // Use EJB's ClassLoader to load the entity class
        ClassLoader ejbClassLoader = etudiantEJB.getClass().getClassLoader();
        Class<?> etudiantClass = ejbClassLoader.loadClass("ma.fstt.ejb.entities.Etudiant");
        Object etudiant = etudiantClass.getConstructor().newInstance();

        etudiantClass.getMethod("setCne", String.class).invoke(etudiant, request.getParameter("cne"));
        etudiantClass.getMethod("setNom", String.class).invoke(etudiant, request.getParameter("nom"));
        etudiantClass.getMethod("setPrenom", String.class).invoke(etudiant, request.getParameter("prenom"));
        etudiantClass.getMethod("setAdresse", String.class).invoke(etudiant, request.getParameter("adresse"));
        etudiantClass.getMethod("setNiveau", String.class).invoke(etudiant, request.getParameter("niveau"));

        etudiantEJB.getClass().getMethod("ajouterEtudiant", etudiantClass).invoke(etudiantEJB, etudiant);

        response.sendRedirect(request.getContextPath() + "/etudiant?action=list");
    }

    private void updateEtudiant(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Long id = Long.parseLong(request.getParameter("id"));
        
        // Use EJB's ClassLoader to load the entity class
        ClassLoader ejbClassLoader = etudiantEJB.getClass().getClassLoader();
        Class<?> etudiantClass = ejbClassLoader.loadClass("ma.fstt.ejb.entities.Etudiant");
        Object etudiant = etudiantClass.getConstructor().newInstance();

        etudiantClass.getMethod("setId_etudiant", Long.class).invoke(etudiant, id);
        etudiantClass.getMethod("setCne", String.class).invoke(etudiant, request.getParameter("cne"));
        etudiantClass.getMethod("setNom", String.class).invoke(etudiant, request.getParameter("nom"));
        etudiantClass.getMethod("setPrenom", String.class).invoke(etudiant, request.getParameter("prenom"));
        etudiantClass.getMethod("setAdresse", String.class).invoke(etudiant, request.getParameter("adresse"));
        etudiantClass.getMethod("setNiveau", String.class).invoke(etudiant, request.getParameter("niveau"));

        etudiantEJB.getClass().getMethod("modifierEtudiant", etudiantClass).invoke(etudiantEJB, etudiant);

        response.sendRedirect(request.getContextPath() + "/etudiant?action=list");
    }

    private void deleteEtudiant(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        Long id = Long.parseLong(request.getParameter("id"));
        etudiantEJB.getClass().getMethod("supprimerEtudiant", Long.class).invoke(etudiantEJB, id);
        response.sendRedirect(request.getContextPath() + "/etudiant?action=list");
    }
}

