package org.ztv.anmeldetool.models;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

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
