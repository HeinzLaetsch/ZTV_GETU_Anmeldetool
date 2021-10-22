package org.ztv.anmeldetool.anmeldetool.util;

import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.anmeldetool.models.Person;
import org.ztv.anmeldetool.anmeldetool.transfer.PersonDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
// @Mapper(componentModel = "spring", uses = {AnforderungMapper.class}, imports = Anforderung.class)
// @Mapper(componentModel = "spring")
public abstract class PersonMapper {

	// @Mappings({ @Mapping(source = "organisationenLinks", target =
	// "organisationId") })
	public abstract PersonDTO PersonToPersonDTO(Person person, Organisation organisation);

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
}
