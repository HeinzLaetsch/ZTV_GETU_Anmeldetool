package org.ztv.anmeldetool.anmeldetool.util;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationAnlassLinkDTO;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, uses = { AnlassFromIdMapper.class,
		OrganisationFromOALMapper.class })
public interface OrganisationAnlassLinkMapper {

	@Mapping(source = "organisationAnlassLink.anlass.id", target = "anlassId")
	@Mapping(source = "organisationAnlassLink.organisation.id", target = "organisationsId")
	@Mapping(source = "organisationAnlassLink.aktiv", target = "startet")
	public abstract OrganisationAnlassLinkDTO toDto(OrganisationAnlassLink organisationAnlassLink);

	@Mapping(source = "organisationAnlassLinkDto.startet", target = "aktiv")
	@Mapping(source = "organisationAnlassLinkDto", target = "anlass")
	public abstract OrganisationAnlassLink toEntity(OrganisationAnlassLinkDTO organisationAnlassLinkDto);
}
