package org.ztv.anmeldetool.anmeldetool.util;

import java.util.Collection;
import java.util.HashSet;

import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.transfer.AnlassDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationenDTO;

public class AnlassHelper {

	public static AnlassDTO createAnlassDTO(Anlass anlass) {
		return AnlassDTO.builder().id(anlass.getId()).anlassBezeichnung(anlass.getAnlassBezeichnung())
				.ort(anlass.getOrt()).halle(anlass.getHalle()).startDatum(anlass.getStartDate())
				.endDatum(anlass.getEndDate()).tiefsteKategorie(anlass.getTiefsteKategorie())
				.hoechsteKategorie(anlass.getHoechsteKategorie()).tiTu(anlass.getTiTu()).build();
	}
	/*
	public static Organisation createOrganisation(OrganisationenDTO organisationDTO, Verband verband) {
		Organisation organisation = new Organisation();
		organisation.setAktiv(true);
		organisation.setChangeDate(Calendar.getInstance());
		organisation.setDeleted(false);
		organisation.setName(organisationDTO.getName());
		organisation.setVerband(verband);
		return organisation;
	}
	*/
}
