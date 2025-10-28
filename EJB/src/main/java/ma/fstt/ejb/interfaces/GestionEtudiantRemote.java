package ma.fstt.ejb.interfaces;

import ma.fstt.ejb.entities.Etudiant;
import ma.fstt.ejb.entities.Module;
import ma.fstt.ejb.entities.Suivie;
import jakarta.ejb.Remote;
import java.util.List;

@Remote
public interface GestionEtudiantRemote {
    
    // Méthodes pour Etudiant
    void ajouterEtudiant(Etudiant etudiant);
    void modifierEtudiant(Etudiant etudiant);
    void supprimerEtudiant(Long id);
    Etudiant trouverEtudiant(Long id);
    List<Etudiant> listEtudiants();
    
    // Méthodes pour Module
    void ajouterModule(Module module);
    void modifierModule(Module module);
    void supprimerModule(Long id);
    Module trouverModule(Long id);
    List<Module> listModules();
    
    // Méthodes pour Suivie
    void ajouterSuivie(Suivie suivie);
    void modifierSuivie(Suivie suivie);
    void supprimerSuivie(Long id);
    Suivie trouverSuivie(Long id);
    List<Suivie> listSuivies();
}