package org.ztv.anmeldetool.anmeldetool.util;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.anmeldetool.models.WertungsrichterEinsatz;
import org.ztv.anmeldetool.anmeldetool.transfer.WertungsrichterEinsatzDTO;
import org.ztv.anmeldetool.anmeldetool.util.idmapper.PersonAnlassLinkFromIdMapper;
import org.ztv.anmeldetool.anmeldetool.util.idmapper.WertungsrichterSlotFromIdMapper;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, uses = { WertungsrichterSlotFromIdMapper.class,
		PersonAnlassLinkFromIdMapper.class })
public abstract class WertungsrichterEinsatzMapper {

	@Mapping(source = "wertungsrichterSlot.id", target = "wertungsrichterSlotId")
	@Mapping(source = "personAnlassLink.id", target = "personAnlassLinkId")
	public abstract WertungsrichterEinsatzDTO ToDto(WertungsrichterEinsatz wrEinsatz);

	@Mapping(source = "wertungsrichterSlotId", target = "wertungsrichterSlot")
	@Mapping(source = "personAnlassLinkId", target = "personAnlassLink")
	public abstract WertungsrichterEinsatz ToEntity(WertungsrichterEinsatzDTO wrEinsatzDTO);
}