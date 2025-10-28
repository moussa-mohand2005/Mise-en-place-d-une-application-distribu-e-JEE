package ma.fstt.ejb.beans;

import ma.fstt.ejb.entities.Etudiant;
import ma.fstt.ejb.entities.Module;
import ma.fstt.ejb.entities.Suivie;
import ma.fstt.ejb.interfaces.GestionEtudiantRemote;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import java.util.List;

@Stateless
public class GestionEtudiantBean implements GestionEtudiantRemote {
    
    @PersistenceContext(unitName = "cnx")
    private EntityManager entityManager;
    
    // Méthodes pour Etudiant
    @Override
    public void ajouterEtudiant(Etudiant etudiant) {
        entityManager.persist(etudiant);
    }
    
    @Override
    public void modifierEtudiant(Etudiant etudiant) {
        entityManager.merge(etudiant);
    }
    
    @Override
    public void supprimerEtudiant(Long id) {
        Etudiant etudiant = entityManager.find(Etudiant.class, id);
        if (etudiant != null) {
            entityManager.remove(etudiant);
        }
    }
    
    @Override
    public Etudiant trouverEtudiant(Long id) {
        return entityManager.find(Etudiant.class, id);
    }
    
    @Override
    public List<Etudiant> listEtudiants() {
        Query query = entityManager.createQuery("SELECT e FROM Etudiant e");
        return query.getResultList();
    }
    
    // Méthodes pour Module
    @Override
    public void ajouterModule(Module module) {
        entityManager.persist(module);
    }
    
    @Override
    public void modifierModule(Module module) {
        entityManager.merge(module);
    }
    
    @Override
    public void supprimerModule(Long id) {
        Module module = entityManager.find(Module.class, id);
        if (module != null) {
            entityManager.remove(module);
        }
    }
    
    @Override
    public Module trouverModule(Long id) {
        return entityManager.find(Module.class, id);
    }
    
    @Override
    public List<Module> listModules() {
        Query query = entityManager.createQuery("SELECT m FROM Module m");
        return query.getResultList();
    }
    
    // Méthodes pour Suivie
    @Override
    public void ajouterSuivie(Suivie suivie) {
        entityManager.persist(suivie);
    }
    
    @Override
    public void modifierSuivie(Suivie suivie) {
        entityManager.merge(suivie);
    }
    
    @Override
    public void supprimerSuivie(Long id) {
        Suivie suivie = entityManager.find(Suivie.class, id);
        if (suivie != null) {
            entityManager.remove(suivie);
        }
    }
    
    @Override
    public Suivie trouverSuivie(Long id) {
        return entityManager.find(Suivie.class, id);
    }
    
    @Override
    public List<Suivie> listSuivies() {
        Query query = entityManager.createQuery("SELECT s FROM Suivie s");
        return query.getResultList();
    }
}