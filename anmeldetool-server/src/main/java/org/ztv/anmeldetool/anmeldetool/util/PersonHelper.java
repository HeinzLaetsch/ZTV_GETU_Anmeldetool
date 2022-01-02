package org.ztv.anmeldetool.anmeldetool.util;

import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.anmeldetool.models.Person;
import org.ztv.anmeldetool.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.RolleDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class PersonHelper {

	public static boolean isPersonMemberOfOrganisation(Person person, Organisation organisation) {
		if (person == null || organisation == null) {
			log.info("Person or Organisation empty: " + person + " / " + organisation);
			return false;
		}
		for (OrganisationPersonLink opLink : person.getOrganisationenLinks()) {
			if (opLink.isAktiv() && opLink.getOrganisation().equals(organisation)) {
				return true;
			}
		}
		return false;
	}

	public static PersonDTO createPersonDTO(Person person, Organisation organisation) {
		List<UUID> organisationids = person.getOrganisationenLinks().stream().map(opl -> opl.getOrganisation().getId())
				.collect(Collectors.toList());
		Set<RolleDTO> rollenDto = new HashSet<RolleDTO>();
		Collection<Rolle> rollen = OrganisationLinkHelper.getRollenForOrganisation(person.getOrganisationenLinks(),
				organisation);

		for (Rolle rolle : rollen) {
			rollenDto.add(RolleDTO.builder().name(rolle.getName()).beschreibung(rolle.getBeschreibung())
					.aktiv(rolle.isAktiv()).build());
		}
		return PersonDTO.builder().id(person.getId()).benutzername(person.getBenutzername()).name(person.getName())
				.email(person.getEmail()).handy(person.getHandy()).vorname(person.getVorname())
				.organisationids(organisationids).rollen(rollenDto).aktiv(person.isAktiv()).build();
	}

	public static PersonDTO createPersonDTO(Person person) {
		List<UUID> organisationids = person.getOrganisationenLinks().stream().map(opl -> opl.getOrganisation().getId())
				.collect(Collectors.toList());
		return PersonDTO.builder().id(person.getId()).benutzername(person.getBenutzername()).name(person.getName())
				.email(person.getEmail()).handy(person.getHandy()).vorname(person.getVorname())
				.organisationids(organisationids).aktiv(person.isAktiv()).build();
	}

	public static Person createPerson(PersonDTO personDTO) {
		Person person = Person.builder().benutzername(personDTO.getBenutzername()).email(personDTO.getEmail())
				.handy(personDTO.getHandy()).name(personDTO.getName()).password(personDTO.getPassword())
				.vorname(personDTO.getVorname()).build();
		person.setAktiv(personDTO.isAktiv());
		return person;
	}

}
