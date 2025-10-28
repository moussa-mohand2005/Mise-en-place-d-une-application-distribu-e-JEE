# 🎓 Mise en place d'une application distribuée JEE

## 📋 Résumé

Application web de gestion des étudiants développée avec **Jakarta EE 10**, intégrant les technologies **EJB 3** (Session Beans), **JPA 3.0/Hibernate** pour la persistance, **JSP/JSTL** pour les vues, et déployée sur **WildFly** avec **Maven**. 

L'architecture suit le modèle **MVC2 distribué** : les Servlets jouent le rôle de contrôleurs, les pages JSP constituent les vues, et les entités JPA/EJB Stateless représentent le modèle métier. La couche métier est encapsulée dans un module EJB indépendant exposant des interfaces Remote, permettant l'invocation distante via JNDI depuis le module web JEE10.

---

## 🎯 Objectifs du Projet

Développer une application distribuée permettant :
- ✅ **Gestion complète des étudiants** (inscription, modification, consultation)
- ✅ **Gestion des modules d'enseignement** avec codes et descriptions
- ✅ **Suivi des notes** par étudiant et par module avec historisation des dates
- ✅ **Architecture modulaire** séparant couche métier (EJB) et présentation (Web)
- ✅ **Transactions distribuées** via JTA

---

## 🏗️ Architecture et Technologies

### Technologies Utilisées

| Technologie | Version | Utilisation |
|------------|---------|-------------|
| Jakarta EE | 10 | Framework principal |
| EJB | 3.x | Session Beans (logique métier) |
| JPA/Hibernate | 3.0 | Persistance des données |
| JSP/JSTL | 3.x | Vues et interface utilisateur |
| MySQL | 8.x | Base de données |
| WildFly | 37.x | Serveur d'applications |
| Maven | 3.x | Gestion des dépendances |

### Architecture MVC2 Distribuée

```
┌─────────────────────────────────────────────────────────┐
│                    Module JEE10 (WAR)                   │
│  ┌──────────────┐        ┌──────────────┐              │
│  │   Servlets   │  ───>  │   JSP Views  │              │
│  │ (Controllers)│        │   (JSTL)     │              │
│  └──────┬───────┘        └──────────────┘              │
│         │                                                │
│         │ JNDI Lookup (Remote Invocation)               │
└─────────┼────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────┐
│                     Module EJB (WAR)                    │
│  ┌──────────────────────────────────────────┐           │
│  │     GestionEtudiantBean (@Stateless)     │           │
│  │         (Business Logic + CRUD)          │           │
│  └────────────────┬─────────────────────────┘           │
│                   │                                      │
│                   ▼                                      │
│  ┌──────────────────────────────────────────┐           │
│  │  JPA Entities (Etudiant, Module, Suivie) │           │
│  └────────────────┬─────────────────────────┘           │
│                   │                                      │
└───────────────────┼──────────────────────────────────────┘
                    │
                    ▼
            ┌───────────────┐
            │ MySQL Database│
            │  (Getudiants) │
            └───────────────┘
```

---

## 📦 Structure du Projet

```
IdeaProjects/
├── EJB/                              # Module EJB (Couche Métier)
│   ├── src/main/java/
│   │   └── ma/fstt/ejb/
│   │       ├── beans/
│   │       │   └── GestionEtudiantBean.java      # Session Bean Stateless
│   │       ├── entities/
│   │       │   ├── Etudiant.java                 # Entité JPA
│   │       │   ├── Module.java                   # Entité JPA
│   │       │   └── Suivie.java                   # Entité JPA
│   │       └── interfaces/
│   │           └── GestionEtudiantRemote.java    # Interface Remote
│   ├── src/main/resources/
│   │   └── META-INF/
│   │       └── persistence.xml                   # Configuration JPA
│   └── pom.xml
│
├── JEE10/                            # Module Web (Couche Présentation)
│   ├── src/main/java/
│   │   └── ma/fstt/servlet/
│   │       ├── EtudiantServlet.java              # Contrôleur Étudiants
│   │       ├── ModuleServlet.java                # Contrôleur Modules
│   │       └── SuivieServlet.java                # Contrôleur Notes
│   ├── src/main/webapp/
│   │   ├── index.jsp                             # Page d'accueil
│   │   ├── etudiants/
│   │   │   ├── list.jsp                          # Liste des étudiants
│   │   │   └── form.jsp                          # Formulaire étudiant
│   │   ├── modules/
│   │   │   ├── list.jsp                          # Liste des modules
│   │   │   └── form.jsp                          # Formulaire module
│   │   └── suivies/
│   │       ├── list.jsp                          # Liste des notes
│   │       └── form.jsp                          # Formulaire note
│   └── pom.xml
│
├── deploy-all.bat                    # Script de déploiement automatique
└── README.md                         # Ce fichier
```

---

## 🗄️ Modèle de Données

### Base de données : `Getudiants`

#### Table `etudiant`
| Champ | Type | Description |
|-------|------|-------------|
| id_etudiant | BIGINT (PK) | Identifiant unique auto-incrémenté |
| cne | VARCHAR(50) | Code National Étudiant (unique) |
| nom | VARCHAR(100) | Nom de famille |
| prenom | VARCHAR(100) | Prénom |
| adresse | VARCHAR(255) | Adresse complète |
| niveau | VARCHAR(50) | Niveau académique (ex: LSI 3) |

#### Table `Module`
| Champ | Type | Description |
|-------|------|-------------|
| id_module | BIGINT (PK) | Identifiant unique |
| code | VARCHAR(20) | Code du module (ex: INF101) |
| nom | VARCHAR(150) | Nom complet du module |
| description | TEXT | Description détaillée |

#### Table `Suivie`
| Champ | Type | Description |
|-------|------|-------------|
| id | BIGINT (PK) | Identifiant unique |
| note | DOUBLE | Note sur 20 |
| date | DATE | Date d'évaluation |
| id_etudiant | BIGINT (FK) | Référence vers Etudiant |
| id_module | BIGINT (FK) | Référence vers Module |

### Relations
- **Etudiant ─┬─< Suivie** : Un étudiant possède plusieurs notes (OneToMany)
- **Module ─┬─< Suivie** : Un module est évalué par plusieurs notes (OneToMany)
- **Suivie >─┴─ Etudiant** : Chaque note appartient à un étudiant (ManyToOne)
- **Suivie >─┴─ Module** : Chaque note concerne un module (ManyToOne)

---

## ⚙️ Configuration et Installation

### Prérequis

- ✅ **JDK 17+** installé et configuré (JAVA_HOME)
- ✅ **WildFly 37.x** téléchargé et extrait
- ✅ **MySQL 8.x** en cours d'exécution
- ✅ **Maven 3.x** (ou utiliser Maven Wrapper inclus)

### 1️⃣ Configuration de la Base de Données

```sql
-- Créer la base de données
CREATE DATABASE Getudiants CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Créer un utilisateur (optionnel)
CREATE USER 'jeeuser'@'localhost' IDENTIFIED BY 'jeepassword';
GRANT ALL PRIVILEGES ON Getudiants.* TO 'jeeuser'@'localhost';
FLUSH PRIVILEGES;
```

### 2️⃣ Configuration de la DataSource sur WildFly

**Option A : Via CLI (Recommandé)**

```bash
# 1. Démarrer WildFly
cd C:\wildfly-37.0.1.Final\bin
standalone.bat

# 2. Dans un autre terminal, lancer le CLI
jboss-cli.bat --connect

# 3. Ajouter le module MySQL
module add --name=com.mysql --resources=mysql-connector-java-8.x.jar \
  --dependencies=javax.api,javax.transaction.api

# 4. Ajouter le driver
/subsystem=datasources/jdbc-driver=mysql:add(driver-name=mysql,\
  driver-module-name=com.mysql,\
  driver-class-name=com.mysql.cj.jdbc.Driver)

# 5. Créer la DataSource
data-source add --name=MySQLDS \
  --jndi-name=java:/mysql \
  --driver-name=mysql \
  --connection-url=jdbc:mysql://localhost:3306/Getudiants?useSSL=false \
  --user-name=root \
  --password=votre_password \
  --enabled=true

# 6. Tester la connexion
/subsystem=datasources/data-source=MySQLDS:test-connection-in-pool
```

**Option B : Modification manuelle de `standalone.xml`**

Ajouter dans `<datasources>` :

```xml
<datasource jndi-name="java:/mysql" pool-name="MySQLDS" enabled="true">
    <connection-url>jdbc:mysql://localhost:3306/Getudiants?useSSL=false</connection-url>
    <driver>mysql</driver>
    <security>
        <user-name>root</user-name>
        <password>votre_password</password>
    </security>
</datasource>
```

### 3️⃣ Compilation et Déploiement

**Méthode Automatique (Recommandée)**

```bash
# Exécuter le script de déploiement
deploy-all.bat
```

Le script effectue automatiquement :
1. ✅ Détection de JAVA_HOME
2. ✅ Build du module EJB (`mvnw clean install`)
3. ✅ Build du module JEE10 (`mvnw clean package`)
4. ✅ Nettoyage des anciens déploiements
5. ✅ Copie des WAR vers WildFly
6. ✅ Déploiement automatique

**Méthode Manuelle**

```bash
# 1. Compiler EJB
cd EJB
mvnw.cmd clean install

# 2. Compiler JEE10
cd ../JEE10
mvnw.cmd clean package

# 3. Copier les WAR vers WildFly
copy EJB\target\EJB.war C:\wildfly-37.0.1.Final\standalone\deployments\
copy JEE10\target\JEE10-1.0-SNAPSHOT.war C:\wildfly-37.0.1.Final\standalone\deployments\JEE10.war
```

---

## 🚀 Utilisation

### Démarrage de l'Application

1. **Démarrer WildFly** :
```bash
cd C:\wildfly-37.0.1.Final\bin
standalone.bat
```

2. **Accéder à l'application** :
```
http://localhost:8080/JEE10/
```

### Interfaces Disponibles

| URL | Description |
|-----|-------------|
| `http://localhost:8080/JEE10/` | Page d'accueil avec 3 cartes |
| `http://localhost:8080/JEE10/etudiant?action=list` | Liste des étudiants |
| `http://localhost:8080/JEE10/module?action=list` | Liste des modules |
| `http://localhost:8080/JEE10/suivie?action=list` | Liste des notes |

### Opérations CRUD

#### Étudiants
- **Lister** : Cliquer sur "Étudiants" depuis l'accueil
- **Ajouter** : Bouton "➕ Ajouter un étudiant"
- **Modifier** : Bouton "✏️ Modifier" sur chaque ligne
- **Supprimer** : Bouton "🗑️ Supprimer" avec confirmation

#### Modules
- **Lister** : Cliquer sur "Modules" depuis l'accueil
- **Ajouter** : Bouton "➕ Ajouter un module"
- **Modifier** : Bouton "✏️ Modifier" sur chaque ligne
- **Supprimer** : Bouton "🗑️ Supprimer" avec confirmation

#### Notes (Suivies)
- **Lister** : Cliquer sur "Notes" depuis l'accueil
- **Ajouter** : Bouton "➕ Ajouter une note"
  - Sélectionner un étudiant
  - Sélectionner un module
  - Saisir la note (0-20)
  - Choisir la date
- **Modifier** : Bouton "✏️ Modifier" sur chaque ligne
- **Supprimer** : Bouton "🗑️ Supprimer" avec confirmation

---

## 🎨 Fonctionnalités de l'Interface

### Design Moderne
- 🎨 **Dégradés de couleurs** distincts par section :
  - Violet (`#667eea → #764ba2`) pour Étudiants
  - Bleu (`#4facfe → #00f2fe`) pour Modules
  - Rose (`#f093fb → #f5576c`) pour Notes
- ✨ **Animations CSS3** (hover, transitions, bounce)
- 📱 **Responsive Design** compatible mobile/tablette
- 🏷️ **Badges colorés** pour les notes selon la performance :
  - Vert : ≥ 16/20 (Excellent)
  - Bleu : 14-16/20 (Bien)
  - Orange : 10-14/20 (Moyen)
  - Rouge : < 10/20 (Insuffisant)

### Validation des Données
- ✅ Champs obligatoires (HTML5 `required`)
- ✅ Format des notes (0.00 - 20.00)
- ✅ Validation des dates
- ✅ Placeholders informatifs

---

## 🔧 Aspects Techniques Avancés

### EJB et Invocation Distante

Les Servlets utilisent **JNDI** pour localiser l'EJB :

```java
Context context = new InitialContext();
String[] jndiNames = {
    "java:global/EJB/GestionEtudiantBean!ma.fstt.ejb.interfaces.GestionEtudiantRemote",
    "java:app/EJB/GestionEtudiantBean!ma.fstt.ejb.interfaces.GestionEtudiantRemote",
    "ejb:/EJB/GestionEtudiantBean!ma.fstt.ejb.interfaces.GestionEtudiantRemote"
};
```

### Réflexion Java pour le Découplage

Les Servlets utilisent la **réflexion** pour manipuler les entités sans dépendance directe :

```java
// Charger la classe via le ClassLoader de l'EJB
ClassLoader ejbClassLoader = etudiantEJB.getClass().getClassLoader();
Class<?> etudiantClass = ejbClassLoader.loadClass("ma.fstt.ejb.entities.Etudiant");

// Créer une instance et invoquer les setters
Object etudiant = etudiantClass.getConstructor().newInstance();
etudiantClass.getMethod("setNom", String.class).invoke(etudiant, nom);
```

### Gestion Transactionnelle JTA

Les EJB Session Beans bénéficient de la gestion transactionnelle automatique :

```java
@Stateless
@TransactionManagement(TransactionManagementType.CONTAINER)
public class GestionEtudiantBean implements GestionEtudiantRemote {
    @PersistenceContext(unitName="cnx")
    private EntityManager entityManager;
    
    // Toutes les méthodes sont transactionnelles par défaut
}
```

---

## 📊 Persistence Configuration

**fichier : `EJB/src/main/resources/META-INF/persistence.xml`**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<persistence version="2.0" xmlns="http://java.sun.com/xml/ns/persistence">
    <persistence-unit name="cnx" transaction-type="JTA">
        <jta-data-source>java:/mysql</jta-data-source>
        <properties>
            <property name="hibernate.dialect" value="org.hibernate.dialect.MySQLDialect"/>
            <property name="hibernate.hbm2ddl.auto" value="create"/>
            <property name="hibernate.show_sql" value="true"/>
        </properties>
    </persistence-unit>
</persistence>
```

---

## 🐛 Dépannage

### Problème : `JAVA_HOME not found`
**Solution** : Le script `deploy-all.bat` détecte automatiquement Java. Si le problème persiste :
```bash
set JAVA_HOME=C:\Program Files\Java\jdk-17
```

### Problème : `ClassNotFoundException: ma.fstt.ejb.entities.Etudiant`
**Solution** : Les Servlets utilisent maintenant le ClassLoader de l'EJB (déjà corrigé dans le code).

### Problème : DataSource introuvable
**Vérifier** :
```bash
jboss-cli.bat --connect
/subsystem=datasources/data-source=MySQLDS:test-connection-in-pool
```

### Problème : Port 8080 déjà utilisé
**Modifier le port** dans `standalone.xml` :
```xml
<socket-binding name="http" port="${jboss.http.port:9090}"/>
```

---

## 📚 Documentation Complémentaire

- [Jakarta EE 10 Documentation](https://jakarta.ee/specifications/platform/10/)
- [WildFly Documentation](https://docs.wildfly.org/)
- [JPA 3.0 Specification](https://jakarta.ee/specifications/persistence/3.0/)
- [EJB 4.0 Specification](https://jakarta.ee/specifications/enterprise-beans/4.0/)

---

## 👥 Auteur

**Projet Universitaire**  
Université Abdelmalek Essaadi  
Faculté des Sciences et Techniques de Tanger  
Département Génie Informatique  
Cycle Ingénieur : LSI  
Module : Applications Distribuées

---

## 📄 Licence

Ce projet est développé à des fins pédagogiques dans le cadre du module "Applications Distribuées".

---

## 🎯 Évolutions Futures

- [ ] Authentification et autorisation (JAAS)
- [ ] Gestion des rôles (ADMIN, ENSEIGNANT, ETUDIANT)
- [ ] Calcul automatique des moyennes
- [ ] Export des données (PDF, Excel)
- [ ] API RESTful (JAX-RS)
- [ ] Interface d'administration avancée
- [ ] Statistiques et graphiques
- [ ] Notifications par email

---

