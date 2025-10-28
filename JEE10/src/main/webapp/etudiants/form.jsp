<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title><%= request.getAttribute("etudiant") == null ? "Ajouter" : "Modifier" %> un Étudiant</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            max-width: 600px;
            width: 100%;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 40px;
        }
        h1 { 
            color: #333;
            margin-bottom: 30px;
            font-size: 1.8em;
            text-align: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .form-group { 
            margin-bottom: 25px;
        }
        label { 
            display: block;
            font-weight: 600;
            color: #555;
            margin-bottom: 8px;
            font-size: 0.95em;
        }
        input[type="text"] { 
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1em;
            transition: all 0.3s ease;
            outline: none;
        }
        input[type="text"]:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        .btn { 
            flex: 1;
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 1em;
        }
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.2);
        }
        .btn-primary { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .btn-secondary { 
            background: linear-gradient(135deg, #b8cbb8 0%, #b8cbb8 100%);
            color: #333;
        }
        @media (max-width: 768px) {
            .container { padding: 25px; }
            h1 { font-size: 1.5em; }
            .btn-group { flex-direction: column; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>📝 <%= request.getAttribute("etudiant") == null ? "Ajouter" : "Modifier" %> un Étudiant</h1>
    
    <% 
        Object etudiant = request.getAttribute("etudiant");
        String action = etudiant == null ? "insert" : "update";
        
        Long id = null;
        String cne = "";
        String nom = "";
        String prenom = "";
        String adresse = "";
        String niveau = "";
        
        if (etudiant != null) {
            id = (Long) etudiant.getClass().getMethod("getId_etudiant").invoke(etudiant);
            cne = (String) etudiant.getClass().getMethod("getCne").invoke(etudiant);
            nom = (String) etudiant.getClass().getMethod("getNom").invoke(etudiant);
            prenom = (String) etudiant.getClass().getMethod("getPrenom").invoke(etudiant);
            adresse = (String) etudiant.getClass().getMethod("getAdresse").invoke(etudiant);
            niveau = (String) etudiant.getClass().getMethod("getNiveau").invoke(etudiant);
        }
    %>
    
        <form action="${pageContext.request.contextPath}/etudiant" method="post">
            <input type="hidden" name="action" value="<%= action %>">
            <% if (id != null) { %>
            <input type="hidden" name="id" value="<%= id %>">
            <% } %>
            
            <div class="form-group">
                <label for="cne">🆔 CNE</label>
                <input type="text" id="cne" name="cne" value="<%= cne %>" required placeholder="Ex: R123456789">
            </div>
            
            <div class="form-group">
                <label for="nom">👤 Nom</label>
                <input type="text" id="nom" name="nom" value="<%= nom %>" required placeholder="Nom de famille">
            </div>
            
            <div class="form-group">
                <label for="prenom">👤 Prénom</label>
                <input type="text" id="prenom" name="prenom" value="<%= prenom %>" required placeholder="Prénom">
            </div>
            
            <div class="form-group">
                <label for="adresse">📍 Adresse</label>
                <input type="text" id="adresse" name="adresse" value="<%= adresse %>" required placeholder="Adresse complète">
            </div>
            
            <div class="form-group">
                <label for="niveau">🎓 Niveau</label>
                <input type="text" id="niveau" name="niveau" value="<%= niveau %>" required placeholder="Ex: LSI 3">
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">
                    <%= etudiant == null ? "✅ Ajouter" : "💾 Enregistrer" %>
                </button>
                <a href="${pageContext.request.contextPath}/etudiant?action=list" class="btn btn-secondary">❌ Annuler</a>
            </div>
        </form>
    </div>
</body>
</html>

