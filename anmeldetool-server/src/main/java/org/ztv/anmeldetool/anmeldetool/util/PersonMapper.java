package org.ztv.anmeldetool.anmeldetool.util;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.anmeldetool.models.Person;
import org.ztv.anmeldetool.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.anmeldetool.util.idmapper.OrganisationFromIdMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, uses = { WertungsrichterMapper.class,
		OrganisationFromIdMapper.class })
public abstract class PersonMapper {

	public abstract PersonDTO PersonToPersonDTO(Person person);

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
