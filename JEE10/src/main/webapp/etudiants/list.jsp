<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Liste des Étudiants</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 30px;
        }
        h1 { 
            color: #333;
            margin-bottom: 25px;
            font-size: 2em;
            text-align: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .message {
            background: #d4edda;
            color: #155724;
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #28a745;
        }
        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 15px;
        }
        .btn { 
            padding: 10px 20px;
            text-decoration: none;
            color: white;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.3);
        }
        .btn-add { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .btn-edit { 
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            padding: 6px 12px;
            font-size: 0.85em;
            margin-right: 5px;
        }
        .btn-delete { 
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            padding: 6px 12px;
            font-size: 0.85em;
        }
        .btn-home {
            background: linear-gradient(135deg, #89f7fe 0%, #66a6ff 100%);
            color: #333;
        }
        table { 
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            overflow: hidden;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        th, td { 
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #f0f0f0;
        }
        th { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85em;
            letter-spacing: 0.5px;
        }
        tbody tr {
            transition: all 0.3s ease;
        }
        tbody tr:hover { 
            background-color: #f8f9ff;
            transform: scale(1.01);
        }
        tbody tr:last-child td {
            border-bottom: none;
        }
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #999;
            font-style: italic;
        }
        @media (max-width: 768px) {
            table { font-size: 0.85em; }
            th, td { padding: 10px 5px; }
            h1 { font-size: 1.5em; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📚 Liste des Étudiants</h1>
        
        <% 
            List<?> etudiants = (List<?>) request.getAttribute("etudiants");
            String message = (String) request.getAttribute("message");
            
            if (message != null) {
                out.println("<div class='message'>" + message + "</div>");
            }
        %>
        
        <div class="toolbar">
            <a href="${pageContext.request.contextPath}/etudiant?action=add" class="btn btn-add">➕ Ajouter un étudiant</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-home">🏠 Retour à l'accueil</a>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>CNE</th>
                    <th>Nom</th>
                    <th>Prénom</th>
                    <th>Adresse</th>
                    <th>Niveau</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    if (etudiants != null && !etudiants.isEmpty()) {
                        for (Object obj : etudiants) {
                            Object id = obj.getClass().getMethod("getId_etudiant").invoke(obj);
                            Object cne = obj.getClass().getMethod("getCne").invoke(obj);
                            Object nom = obj.getClass().getMethod("getNom").invoke(obj);
                            Object prenom = obj.getClass().getMethod("getPrenom").invoke(obj);
                            Object adresse = obj.getClass().getMethod("getAdresse").invoke(obj);
                            Object niveau = obj.getClass().getMethod("getNiveau").invoke(obj);
                %>
                <tr>
                    <td><strong>#<%= id %></strong></td>
                    <td><%= cne %></td>
                    <td><%= nom %></td>
                    <td><%= prenom %></td>
                    <td><%= adresse %></td>
                    <td><span style="background: #e3f2fd; padding: 4px 10px; border-radius: 12px; font-size: 0.85em;"><%= niveau %></span></td>
                    <td style="white-space: nowrap;">
                        <a href="${pageContext.request.contextPath}/etudiant?action=edit&id=<%= id %>" class="btn btn-edit">✏️ Modifier</a>
                        <a href="${pageContext.request.contextPath}/etudiant?action=delete&id=<%= id %>" 
                           onclick="return confirm('Êtes-vous sûr de vouloir supprimer cet étudiant?');" 
                           class="btn btn-delete">🗑️ Supprimer</a>
                    </td>
                </tr>
                <% 
                        }
                    } else {
                %>
                <tr>
                    <td colspan="7" class="empty-state">📭 Aucun étudiant trouvé</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>

