package org.ztv.anmeldetool.util;

import java.util.UUID;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.mapstruct.ObjectFactory;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;
import org.ztv.anmeldetool.util.idmapper.AnlassFromIdMapper;
import org.ztv.anmeldetool.util.idmapper.OrganisationFromIdMapper;
import org.ztv.anmeldetool.util.idmapper.TeilnehmerFromIdMapper;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, uses = { AnlassFromIdMapper.class,
		OrganisationFromIdMapper.class, TeilnehmerFromIdMapper.class })
public interface TeilnehmerAnlassLinkMapper {
	@Mapping(source = "teilnehmer.id", target = "teilnehmerId")
	@Mapping(source = "anlass.id", target = "anlassId")
	@Mapping(source = "organisation.id", target = "organisationId")
	@Mapping(source = "meldeStatus.text", target = "meldeStatus")
	TeilnehmerAnlassLinkDTO toDto(TeilnehmerAnlassLink tal);

	@Mapping(target = "id", ignore = true)
	@Mapping(source = "teilnehmerId", target = "teilnehmer")
	@Mapping(source = "organisationId", target = "organisation")
	@Mapping(source = "anlassId", target = "anlass")
	@Mapping(expression = "java(createMeldeStatus(talDTO.getMeldeStatus()))", target = "meldeStatus")
	TeilnehmerAnlassLink toEntity(TeilnehmerAnlassLinkDTO talDTO);

	@ObjectFactory
	default Teilnehmer map(UUID id) {
		return new Teilnehmer();
	}

	default MeldeStatusEnum createMeldeStatus(String text) {
		return MeldeStatusEnum.valueOf(text);
	}

}
