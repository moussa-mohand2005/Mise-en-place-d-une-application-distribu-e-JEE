<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title><%= request.getAttribute("suivie") == null ? "Ajouter" : "Modifier" %> une Note</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
        input[type="text"], input[type="number"], input[type="date"], select { 
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1em;
            transition: all 0.3s ease;
            outline: none;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        input[type="text"]:focus, input[type="number"]:focus, input[type="date"]:focus, select:focus {
            border-color: #f093fb;
            box-shadow: 0 0 0 3px rgba(240, 147, 251, 0.1);
        }
        select {
            cursor: pointer;
            background: white;
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
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        .btn-secondary { 
            background: linear-gradient(135deg, #b8cbb8 0%, #b8cbb8 100%);
            color: #333;
        }
        .hint {
            font-size: 0.85em;
            color: #999;
            margin-top: 5px;
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
        <h1>📊 <%= request.getAttribute("suivie") == null ? "Ajouter" : "Modifier" %> une Note</h1>
    
    <% 
        Object suivie = request.getAttribute("suivie");
        List<?> etudiants = (List<?>) request.getAttribute("etudiants");
        List<?> modules = (List<?>) request.getAttribute("modules");
        String action = suivie == null ? "insert" : "update";
        
        Long id = null;
        Double note = null;
        String date = "";
        Long etudiantId = null;
        Long moduleId = null;
        
        if (suivie != null) {
            id = (Long) suivie.getClass().getMethod("getId").invoke(suivie);
            note = (Double) suivie.getClass().getMethod("getNote").invoke(suivie);
            Object dateObj = suivie.getClass().getMethod("getDate").invoke(suivie);
            if (dateObj != null) {
                date = new java.text.SimpleDateFormat("yyyy-MM-dd").format(dateObj);
            }
            Object etudiant = suivie.getClass().getMethod("getEtudiant").invoke(suivie);
            if (etudiant != null) {
                etudiantId = (Long) etudiant.getClass().getMethod("getId_etudiant").invoke(etudiant);
            }
            Object module = suivie.getClass().getMethod("getModule").invoke(suivie);
            if (module != null) {
                moduleId = (Long) module.getClass().getMethod("getId_module").invoke(module);
            }
        }
    %>
    
        <form action="${pageContext.request.contextPath}/suivie" method="post">
            <input type="hidden" name="action" value="<%= action %>">
            <% if (id != null) { %>
            <input type="hidden" name="id" value="<%= id %>">
            <% } %>
            
            <div class="form-group">
                <label for="etudiantId">👤 Étudiant</label>
                <select id="etudiantId" name="etudiantId" required>
                    <option value="">Sélectionner un étudiant</option>
                    <% 
                        if (etudiants != null) {
                            for (Object etud : etudiants) {
                                Long etudId = (Long) etud.getClass().getMethod("getId_etudiant").invoke(etud);
                                String etudNom = (String) etud.getClass().getMethod("getNom").invoke(etud);
                                String etudPrenom = (String) etud.getClass().getMethod("getPrenom").invoke(etud);
                                String etudCNE = (String) etud.getClass().getMethod("getCne").invoke(etud);
                                String selected = (etudiantId != null && etudiantId.equals(etudId)) ? "selected" : "";
                    %>
                    <option value="<%= etudId %>" <%= selected %>><%= etudNom %> <%= etudPrenom %> - <%= etudCNE %></option>
                    <% 
                            }
                        }
                    %>
                </select>
            </div>
            
            <div class="form-group">
                <label for="moduleId">📚 Module</label>
                <select id="moduleId" name="moduleId" required>
                    <option value="">Sélectionner un module</option>
                    <% 
                        if (modules != null) {
                            for (Object mod : modules) {
                                Long modId = (Long) mod.getClass().getMethod("getId_module").invoke(mod);
                                String modCode = (String) mod.getClass().getMethod("getCode").invoke(mod);
                                String modNom = (String) mod.getClass().getMethod("getNom").invoke(mod);
                                String selected = (moduleId != null && moduleId.equals(modId)) ? "selected" : "";
                    %>
                    <option value="<%= modId %>" <%= selected %>>[<%= modCode %>] <%= modNom %></option>
                    <% 
                            }
                        }
                    %>
                </select>
            </div>
            
            <div class="form-group">
                <label for="note">📝 Note</label>
                <input type="number" id="note" name="note" step="0.01" min="0" max="20" 
                       value="<%= note != null ? note : "" %>" required placeholder="Ex: 15.50">
                <div class="hint">Note sur 20 (0.00 - 20.00)</div>
            </div>
            
            <div class="form-group">
                <label for="date">📅 Date</label>
                <input type="date" id="date" name="date" value="<%= date %>" required>
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">
                    <%= suivie == null ? "✅ Ajouter" : "💾 Enregistrer" %>
                </button>
                <a href="${pageContext.request.contextPath}/suivie?action=list" class="btn btn-secondary">❌ Annuler</a>
            </div>
        </form>
    </div>
</body>
</html>
