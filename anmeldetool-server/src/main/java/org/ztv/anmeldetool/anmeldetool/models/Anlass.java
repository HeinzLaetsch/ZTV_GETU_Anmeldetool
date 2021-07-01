package org.ztv.anmeldetool.anmeldetool.models;

import java.util.Calendar;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;


@Entity()
@Table(name = "ANLASS")
@Getter
@Setter
public class Anlass extends Base {
	
	private String anlassBezeichnung;
	
	private String ort;

	private String halle;
	
    @Temporal(TemporalType.DATE)
    private Calendar startDate;
	
    @Temporal(TemporalType.DATE)
    private Calendar endDate;
	
    @Enumerated(EnumType.STRING)
    private TiTuEnum tiTu;
	
    @Enumerated(EnumType.STRING)
	private KategorieEnum tiefsteKategorie;
    
    @Enumerated(EnumType.STRING)
	private KategorieEnum hoechsteKategorie;
	
    @OneToMany(fetch = FetchType.LAZY, mappedBy = "anlass", cascade = { CascadeType.PERSIST , CascadeType.MERGE })
    @ToString.Exclude
	private Set<OrganisationAnlassLink> organisationenLinks;
        
    public Anlass() {
    	this.organisationenLinks = new HashSet<OrganisationAnlassLink>();
    }
    
    @Builder
    public Anlass(String anlassBezeichnung, String ort, String halle, Calendar startDate, Calendar endDate, TiTuEnum tiTu, KategorieEnum tiefsteKategorie, KategorieEnum hoechsteKategorie) {
    	super();
    	this.anlassBezeichnung = anlassBezeichnung;
    	this.ort = ort;
    	this.halle = halle;
    	this.startDate = startDate;
    	this.endDate = endDate;
    	this.tiTu = tiTu;
    	this.tiefsteKategorie = tiefsteKategorie;
    	this.hoechsteKategorie = hoechsteKategorie;
    	this.organisationenLinks = new HashSet<OrganisationAnlassLink>();
    }
    
    public void addToOrganisationenLink(OrganisationAnlassLink organisationenLink) {
    	if (!this.organisationenLinks.contains(organisationenLink) ) {
    	this.organisationenLinks.add(organisationenLink);
    		organisationenLink.setAnlass(this);
    	}
    }
    // Wertungsrichter Info bei WR's
}
