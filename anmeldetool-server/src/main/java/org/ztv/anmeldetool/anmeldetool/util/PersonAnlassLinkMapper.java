package org.ztv.anmeldetool.anmeldetool.util;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.anmeldetool.transfer.PersonAnlassLinkDTO;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface PersonAnlassLinkMapper {
	@Mapping(source = "anlass.id", target = "anlassId")
	@Mapping(source = "organisation.id", target = "organisationId")
	@Mapping(source = "person.id", target = "personId")
	PersonAnlassLinkDTO PersonAnlassLinkToPersonAnlassLinkDTO(PersonAnlassLink pal);

	// @Mapping(target = "anlass", expression = "java(")
	// PersonAnlassLink PersonAnlassLinkDTOToPersonAnlassLink(PersonAnlassLinkDTO
	// palDTO);
}
