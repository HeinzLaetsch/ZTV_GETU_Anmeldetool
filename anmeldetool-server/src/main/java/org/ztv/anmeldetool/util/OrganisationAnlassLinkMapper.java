package org.ztv.anmeldetool.util;

import org.mapstruct.Builder;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.transfer.OrganisationAnlassLinkDTO;
import org.ztv.anmeldetool.util.idmapper.AnlassFromIdMapper;
import org.ztv.anmeldetool.util.idmapper.OrganisationFromIdMapper;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING,
		builder = @Builder(disableBuilder = true),
		uses = { AnlassFromIdMapper.class,
		OrganisationFromIdMapper.class, BaseFactory.class })
public interface OrganisationAnlassLinkMapper {

	@Mapping(source = "anlass.id", target = "anlassId")
	@Mapping(source = "organisation.id", target = "organisationsId")
	@Mapping(source = "aktiv", target = "startet")
	OrganisationAnlassLinkDTO toDto(OrganisationAnlassLink organisationAnlassLink);

	@Mapping(source = "organisationAnlassLinkDto.startet", target = "aktiv")
	@Mapping(source = "anlassId", target = "anlass")
	@Mapping(source = "organisationsId", target = "organisation")
	OrganisationAnlassLink toEntity(OrganisationAnlassLinkDTO organisationAnlassLinkDto);
}
