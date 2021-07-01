package org.ztv.anmeldetool.anmeldetool.util;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.anmeldetool.service.RoleService;
import org.ztv.anmeldetool.anmeldetool.transfer.RolleDTO;

public class OrganisationLinkHelper {

	public static Collection<Rolle> getRollenForOrganisation(Set<OrganisationPersonLink> organisationenLinks,
			Organisation organisation) {

		Collection<Rolle> roles = new ArrayList<Rolle>();
		for (OrganisationPersonLink orgPerslink : organisationenLinks) {
			if (orgPerslink.getOrganisation().equals(organisation)) {
				for (RollenLink rollenLink : orgPerslink.getRollenLink()) {
					if (rollenLink.isAktiv()) {
						roles.add(rollenLink.getRolle());
					}
				}
			}
		}
		return roles;
	}

}
