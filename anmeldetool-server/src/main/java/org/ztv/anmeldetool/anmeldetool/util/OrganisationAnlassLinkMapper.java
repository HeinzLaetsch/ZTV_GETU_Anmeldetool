package org.ztv.anmeldetool.anmeldetool.util;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationAnlassLinkDTO;
import org.ztv.anmeldetool.anmeldetool.util.idmapper.AnlassFromIdMapper;
import org.ztv.anmeldetool.anmeldetool.util.idmapper.OrganisationFromIdMapper;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, uses = { AnlassFromIdMapper.class,
		OrganisationFromIdMapper.class })
public interface OrganisationAnlassLinkMapper {

	@Mapping(source = "anlass.id", target = "anlassId")
	@Mapping(source = "organisation.id", target = "organisationsId")
	@Mapping(source = "aktiv", target = "startet")
	public abstract OrganisationAnlassLinkDTO toDto(OrganisationAnlassLink organisationAnlassLink);

	@Mapping(source = "organisationAnlassLinkDto.startet", target = "aktiv")
	@Mapping(source = "anlassId", target = "anlass")
	@Mapping(source = "organisationsId", target = "organisation")
	public abstract OrganisationAnlassLink toEntity(OrganisationAnlassLinkDTO organisationAnlassLinkDto);
}
