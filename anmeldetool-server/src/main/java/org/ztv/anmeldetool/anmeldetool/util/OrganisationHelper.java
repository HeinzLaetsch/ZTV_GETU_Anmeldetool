package org.ztv.anmeldetool.anmeldetool.util;

import java.util.Calendar;

import org.springframework.beans.factory.annotation.Autowired;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.Verband;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationenDTO;

public class OrganisationHelper {

	public static OrganisationenDTO createOrganisationDTO(Organisation organisation) {
		return OrganisationenDTO.builder().id(organisation.getId()).name(organisation.getName()).verbandId(organisation.getVerband().getId()).build();
	}
	public static Organisation createOrganisation(OrganisationenDTO organisationDTO, Verband verband) {
		Organisation organisation = new Organisation();
		organisation.setAktiv(true);
		organisation.setChangeDate(Calendar.getInstance());
		organisation.setDeleted(false);
		organisation.setName(organisationDTO.getName());
		organisation.setVerband(verband);
		return organisation;
	}
}
