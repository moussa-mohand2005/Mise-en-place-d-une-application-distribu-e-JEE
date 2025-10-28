package ma.fstt.ejb.entities;

import jakarta.persistence.*;
import java.io.Serializable;
import java.util.List;

@Entity
@Table(name = "modules")
public class Module implements Serializable {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_module;
    
    private String code;
    private String nom;
    private String description;
    
    @OneToMany(mappedBy = "module")
    private List<Suivie> suivies;

    public Module() {
    }

    public Long getId_module() {
        return id_module;
    }

    public void setId_module(Long id_module) {
        this.id_module = id_module;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<Suivie> getSuivies() {
        return suivies;
    }

    public void setSuivies(List<Suivie> suivies) {
        this.suivies = suivies;
    }
}