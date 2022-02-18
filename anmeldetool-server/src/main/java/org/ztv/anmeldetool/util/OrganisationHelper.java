package org.ztv.anmeldetool.util;

import java.util.Calendar;

import org.springframework.beans.factory.annotation.Autowired;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Verband;
import org.ztv.anmeldetool.transfer.OrganisationDTO;

public class OrganisationHelper {

	public static OrganisationDTO createOrganisationDTO(Organisation organisation) {
		return OrganisationDTO.builder().id(organisation.getId()).name(organisation.getName()).verbandId(organisation.getVerband().getId()).build();
	}
	public static Organisation createOrganisation(OrganisationDTO organisationDTO, Verband verband) {
		Organisation organisation = new Organisation();
		organisation.setAktiv(true);
		organisation.setChangeDate(Calendar.getInstance());
		organisation.setDeleted(false);
		organisation.setName(organisationDTO.getName());
		organisation.setVerband(verband);
		return organisation;
	}
}
