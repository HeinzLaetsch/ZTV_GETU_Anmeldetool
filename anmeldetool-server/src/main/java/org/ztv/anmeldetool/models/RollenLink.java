package org.ztv.anmeldetool.models;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity()
@Table(name = "ROLLEN_LINK")
@Getter
@Setter
public class RollenLink extends Base {
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="ROLLEN_ID", nullable=false, insertable=true, updatable=true)
    @ToString.Exclude
	private Rolle rolle;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="LINK_ID", nullable=false, insertable=true, updatable=true)
    @ToString.Exclude
	private OrganisationPersonLink link ;
}
