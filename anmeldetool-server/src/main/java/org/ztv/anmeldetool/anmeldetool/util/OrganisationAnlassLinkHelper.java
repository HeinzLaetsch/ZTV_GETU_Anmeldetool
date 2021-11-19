package org.ztv.anmeldetool.anmeldetool.util;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.anmeldetool.service.RoleService;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.RolleDTO;

public class OrganisationAnlassLinkHelper {

	public static Collection<OrganisationDTO> getOrganisationDTOForAnlassLink(Set<OrganisationAnlassLink> organisationenAnlassLinks) {

		Collection<OrganisationDTO> organisationen = new ArrayList<OrganisationDTO>();
		for (OrganisationAnlassLink orgAnlasslink : organisationenAnlassLinks) {
			if (orgAnlasslink.isAktiv()) {
				organisationen.add(OrganisationHelper.createOrganisationDTO(orgAnlasslink.getOrganisation()));
			}
		}
		return organisationen;
	}

}
