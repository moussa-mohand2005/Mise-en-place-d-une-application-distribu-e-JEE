<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gestion Étudiants - Accueil</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .container {
            max-width: 1100px;
            width: 100%;
            padding: 40px 20px;
        }
        .header {
            text-align: center;
            margin-bottom: 60px;
        }
        h1 {
            color: white;
            font-size: 3em;
            margin-bottom: 15px;
            text-shadow: 3px 3px 6px rgba(0,0,0,0.3);
            animation: fadeInDown 0.8s ease;
        }
        .subtitle {
            color: rgba(255,255,255,0.95);
            font-size: 1.2em;
            line-height: 1.6;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
            animation: fadeInUp 0.8s ease;
        }
        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 35px;
            animation: fadeIn 1s ease;
        }
        .card {
            background: white;
            border-radius: 20px;
            padding: 45px 35px;
            text-align: center;
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
            cursor: pointer;
        }
        .card:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }
        .card.module:before {
            background: linear-gradient(90deg, #4facfe, #00f2fe);
        }
        .card.suivie:before {
            background: linear-gradient(90deg, #f093fb, #f5576c);
        }
        .card:hover {
            transform: translateY(-15px) scale(1.03);
            box-shadow: 0 20px 50px rgba(0,0,0,0.4);
        }
        .card-icon {
            font-size: 5em;
            margin-bottom: 25px;
            display: inline-block;
            animation: bounce 2s infinite;
        }
        .card:hover .card-icon {
            animation: pulse 0.6s ease;
        }
        .card h2 {
            color: #333;
            font-size: 1.8em;
            margin-bottom: 15px;
            font-weight: 700;
        }
        .card p {
            color: #777;
            margin-bottom: 30px;
            font-size: 1em;
            line-height: 1.5;
        }
        .card-btn {
            display: inline-block;
            padding: 14px 35px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 30px;
            font-weight: 700;
            font-size: 1.05em;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .card.module .card-btn {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        .card.suivie .card-btn {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .card-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.3);
        }
        .footer {
            text-align: center;
            margin-top: 50px;
            color: rgba(255,255,255,0.8);
            font-size: 0.95em;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
        }
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }
        @media (max-width: 768px) {
            h1 { font-size: 2em; }
            .subtitle { font-size: 1em; }
            .cards { grid-template-columns: 1fr; gap: 25px; }
            .card { padding: 35px 25px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🎓 Application de Gestion Étudiants</h1>
            <div class="subtitle">
                Université Abdelmalek Essaadi<br>
                Faculté des Sciences et Techniques de Tanger<br>
                <strong>Département Génie Informatique</strong>
            </div>
        </div>
        
        <div class="cards">
            <div class="card">
                <div class="card-icon">👥</div>
                <h2>Étudiants</h2>
                <p>Gérer les informations des étudiants, leurs coordonnées et niveaux académiques</p>
                <a href="${pageContext.request.contextPath}/etudiant?action=list" class="card-btn">📋 Accéder</a>
            </div>
            
            <div class="card module">
                <div class="card-icon">📚</div>
                <h2>Modules</h2>
                <p>Gérer les modules d'enseignement, leurs codes et descriptions</p>
                <a href="${pageContext.request.contextPath}/module?action=list" class="card-btn">📖 Accéder</a>
            </div>
            
            <div class="card suivie">
                <div class="card-icon">📊</div>
                <h2>Notes</h2>
                <p>Gérer les notes et suivies des étudiants par module</p>
                <a href="${pageContext.request.contextPath}/suivie?action=list" class="card-btn">📝 Accéder</a>
            </div>
        </div>
        
        <div class="footer">
            💻 Développé avec EJB3, JPA & Jakarta EE 10 | 🚀 Déployé sur WildFly
        </div>
    </div>
</body>
</html>
