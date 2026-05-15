package org.ztv.anmeldetool.util;

import org.mapstruct.Builder;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.transfer.PersonAnlassLinkDTO;
import org.ztv.anmeldetool.util.idmapper.AnlassFromIdMapper;
import org.ztv.anmeldetool.util.idmapper.OrganisationFromIdMapper;
import org.ztv.anmeldetool.util.idmapper.PersonFromIdMapper;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING,
		builder = @Builder(disableBuilder = true),
		uses = { WertungsrichterEinsatzMapper.class,
		AnlassFromIdMapper.class, OrganisationFromIdMapper.class, PersonFromIdMapper.class, BaseFactory.class })
public interface PersonAnlassLinkMapper {
	@Mapping(source = "anlass.id", target = "anlassId")
	@Mapping(source = "organisation.id", target = "organisationId")
	@Mapping(source = "person.id", target = "personId")
	PersonAnlassLinkDTO toDto(PersonAnlassLink pal);

	@Mapping(source = "anlassId", target = "anlass")
	@Mapping(source = "organisationId", target = "organisation")
	@Mapping(source = "personId", target = "person")
	PersonAnlassLink toEntity(PersonAnlassLinkDTO palDto);
}
