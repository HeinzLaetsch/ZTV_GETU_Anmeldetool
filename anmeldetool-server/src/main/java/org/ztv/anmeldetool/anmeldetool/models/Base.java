package org.ztv.anmeldetool.anmeldetool.models;

import java.util.Calendar;
import java.util.UUID;

import javax.persistence.Id;
import javax.persistence.MappedSuperclass;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import lombok.Getter;
import lombok.Setter;

@MappedSuperclass
@Getter
@Setter
public abstract class Base {
	@Id
	// @GeneratedValue
	private UUID id;
	
    private boolean aktiv;
    
    private boolean deleted;

    @Temporal(TemporalType.DATE)
    private Calendar changeDate;

    @Temporal(TemporalType.DATE)
    private Calendar deletionDate;
    
    public Base() {
    	initFields(false, false, Calendar.getInstance(), null);
    }

    public Base(Boolean aktiv) {
    	initFields(aktiv, false, Calendar.getInstance(), null);
    }

    public Base(Boolean aktiv, Calendar changeDate) {
    	initFields(aktiv, false, changeDate, null);
    }
    
    private void initFields(Boolean aktiv, Boolean deleted, Calendar changeDate, Calendar deletionDate) {
    	this.id = UUID.randomUUID();
    	this.aktiv = aktiv;
    	this.deleted = deleted;
    	this.changeDate = changeDate;
    	this.deletionDate = deletionDate;    	
    }
}
