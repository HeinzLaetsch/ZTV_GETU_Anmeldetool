package org.ztv.anmeldetool.anmeldetool.util;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.anmeldetool.transfer.PersonAnlassLinkDTO;
// WertungsrichterEinsatzMapper.class
import org.ztv.anmeldetool.anmeldetool.util.idmapper.AnlassFromIdMapper;
import org.ztv.anmeldetool.anmeldetool.util.idmapper.OrganisationFromIdMapper;
import org.ztv.anmeldetool.anmeldetool.util.idmapper.PersonFromIdMapper;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, uses = { WertungsrichterEinsatzMapper.class,
		AnlassFromIdMapper.class, OrganisationFromIdMapper.class, PersonFromIdMapper.class })
public interface PersonAnlassLinkMapper {
	@Mapping(source = "anlass.id", target = "anlassId")
	@Mapping(source = "organisation.id", target = "organisationId")
	@Mapping(source = "person.id", target = "personId")
	public abstract PersonAnlassLinkDTO toDto(PersonAnlassLink pal);

	@Mapping(source = "anlassId", target = "anlass")
	@Mapping(source = "organisationId", target = "organisation")
	@Mapping(source = "personId", target = "person")
	public abstract PersonAnlassLink toEntity(PersonAnlassLinkDTO palDto);
}
