package org.ztv.anmeldetool.anmeldetool.util;

import org.mapstruct.Context;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.anmeldetool.repositories.TeilnehmerAnlassLinkRepository;
import org.ztv.anmeldetool.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, uses = { AnlassFromIdMapper.class })
public interface TeilnehmerAnlassLinkMapper {
	TeilnehmerAnlassLinkDTO fromTeilnehmerAnlassLink(TeilnehmerAnlassLink tal);

	@Mapping(target = "id", ignore = true)
	TeilnehmerAnlassLink fromTeilnehmerAnlassLinkDTO(TeilnehmerAnlassLinkDTO talDTO,
			@Context TeilnehmerAnlassLinkRepository repo);

}
