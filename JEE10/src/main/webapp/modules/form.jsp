<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title><%= request.getAttribute("module") == null ? "Ajouter" : "Modifier" %> un Module</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
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
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
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
        input[type="text"], textarea { 
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1em;
            transition: all 0.3s ease;
            outline: none;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        textarea {
            min-height: 100px;
            resize: vertical;
        }
        input[type="text"]:focus, textarea:focus {
            border-color: #4facfe;
            box-shadow: 0 0 0 3px rgba(79, 172, 254, 0.1);
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
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
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
        <h1>📚 <%= request.getAttribute("module") == null ? "Ajouter" : "Modifier" %> un Module</h1>
    
    <% 
        Object module = request.getAttribute("module");
        String action = module == null ? "insert" : "update";
        
        Long id = null;
        String code = "";
        String nom = "";
        String description = "";
        
        if (module != null) {
            id = (Long) module.getClass().getMethod("getId_module").invoke(module);
            code = (String) module.getClass().getMethod("getCode").invoke(module);
            nom = (String) module.getClass().getMethod("getNom").invoke(module);
            description = (String) module.getClass().getMethod("getDescription").invoke(module);
        }
    %>
    
        <form action="${pageContext.request.contextPath}/module" method="post">
            <input type="hidden" name="action" value="<%= action %>">
            <% if (id != null) { %>
            <input type="hidden" name="id" value="<%= id %>">
            <% } %>
            
            <div class="form-group">
                <label for="code">🔢 Code Module</label>
                <input type="text" id="code" name="code" value="<%= code %>" required placeholder="Ex: INF101">
            </div>
            
            <div class="form-group">
                <label for="nom">📖 Nom du Module</label>
                <input type="text" id="nom" name="nom" value="<%= nom %>" required placeholder="Ex: Introduction à la Programmation">
            </div>
            
            <div class="form-group">
                <label for="description">📝 Description</label>
                <textarea id="description" name="description" required placeholder="Description détaillée du module..."><%= description %></textarea>
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">
                    <%= module == null ? "✅ Ajouter" : "💾 Enregistrer" %>
                </button>
                <a href="${pageContext.request.contextPath}/module?action=list" class="btn btn-secondary">❌ Annuler</a>
            </div>
        </form>
    </div>
</body>
</html>
