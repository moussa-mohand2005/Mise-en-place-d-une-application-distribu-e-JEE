package ma.fstt.ejb.entities;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Entity
@Table(name = "etudiant")
public class Etudiant implements Serializable {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_etudiant;
    
    private String nom;
    private String prenom;
    private String cne;
    private String adresse;
    private String niveau;
    
    @OneToMany(mappedBy = "etudiant")
    private List<Suivie> suivies;

    public Etudiant() {
    }

    public Long getId_etudiant() {
        return id_etudiant;
    }

    public void setId_etudiant(Long id_etudiant) {
        this.id_etudiant = id_etudiant;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getCne() {
        return cne;
    }

    public void setCne(String cne) {
        this.cne = cne;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public String getNiveau() {
        return niveau;
    }

    public void setNiveau(String niveau) {
        this.niveau = niveau;
    }

    public List<Suivie> getSuivies() {
        return suivies;
    }

    public void setSuivies(List<Suivie> suivies) {
        this.suivies = suivies;
    }
}