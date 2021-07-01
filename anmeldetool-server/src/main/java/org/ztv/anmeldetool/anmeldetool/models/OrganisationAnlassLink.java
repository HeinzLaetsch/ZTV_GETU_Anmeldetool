package org.ztv.anmeldetool.anmeldetool.models;


import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity()
@Table(name = "organisation_anlass_link")
@Getter
@Setter
public class OrganisationAnlassLink extends Base {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="ORGANISATION_ID", nullable=false, insertable=true, updatable=true)
    @ToString.Exclude
	private Organisation organisation;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="ANLASS_ID", nullable=false, insertable=true, updatable=true)
    @ToString.Exclude
	private Anlass anlass;
}