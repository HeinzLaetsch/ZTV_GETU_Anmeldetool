package org.ztv.anmeldetool.anmeldetool.util;

import java.util.UUID;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.mapstruct.ObjectFactory;
import org.ztv.anmeldetool.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;
import org.ztv.anmeldetool.anmeldetool.util.idmapper.AnlassFromIdMapper;
import org.ztv.anmeldetool.anmeldetool.util.idmapper.OrganisationFromIdMapper;
import org.ztv.anmeldetool.anmeldetool.util.idmapper.TeilnehmerFromIdMapper;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, uses = { AnlassFromIdMapper.class,
		OrganisationFromIdMapper.class, TeilnehmerFromIdMapper.class })
public interface TeilnehmerAnlassLinkMapper {
	@Mapping(source = "teilnehmer.id", target = "teilnehmerId")
	@Mapping(source = "anlass.id", target = "anlassId")
	@Mapping(source = "organisation.id", target = "organisationId")
	TeilnehmerAnlassLinkDTO toDto(TeilnehmerAnlassLink tal);

	@Mapping(target = "id", ignore = true)
	@Mapping(source = "teilnehmerId", target = "teilnehmer")
	@Mapping(source = "organisationId", target = "organisation")
	@Mapping(source = "anlassId", target = "anlass")
	TeilnehmerAnlassLink toEntity(TeilnehmerAnlassLinkDTO talDTO);

	@ObjectFactory
	default Teilnehmer map(UUID id) {
		return new Teilnehmer();
	}

}
