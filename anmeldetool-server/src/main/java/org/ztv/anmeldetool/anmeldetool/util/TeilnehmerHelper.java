package org.ztv.anmeldetool.anmeldetool.util;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.anmeldetool.models.Person;
import org.ztv.anmeldetool.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.RolleDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.TeilnehmerDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class TeilnehmerHelper {

	public static TeilnehmerDTO createTeilnehmerDTO(Teilnehmer teilnehmer, Organisation organisation) {
		return TeilnehmerDTO.builder().id(teilnehmer.getId()).name(teilnehmer.getName()).vorname(teilnehmer.getVorname())
				.organisationid(organisation.getId()).jahrgang(teilnehmer.getJahrgang()).tiTu(teilnehmer.getTiTu()).aktiv(teilnehmer.isAktiv()).dirty(teilnehmer.isDirty()).build();
	}

	public static TeilnehmerDTO createTeilnehmerDTO(Teilnehmer teilnehmer, UUID orgId) {
		return TeilnehmerDTO.builder().id(teilnehmer.getId()).name(teilnehmer.getName()).vorname(teilnehmer.getVorname())
				.organisationid(orgId).jahrgang(teilnehmer.getJahrgang()).tiTu(teilnehmer.getTiTu()).aktiv(teilnehmer.isAktiv()).dirty(teilnehmer.isDirty()).build();
	}

	public static Teilnehmer createTeilnehmer(TeilnehmerDTO teilnehmerDTO) {
		Teilnehmer teilnehmer = Teilnehmer.builder().name(teilnehmerDTO.getName()).vorname(teilnehmerDTO.getVorname())
				.jahrgang(teilnehmerDTO.getJahrgang()).tiTu(teilnehmerDTO.getTiTu()).dirty(teilnehmerDTO.isDirty()).build();
		teilnehmer.setAktiv(teilnehmerDTO.isAktiv());
		return teilnehmer;
	}

}
