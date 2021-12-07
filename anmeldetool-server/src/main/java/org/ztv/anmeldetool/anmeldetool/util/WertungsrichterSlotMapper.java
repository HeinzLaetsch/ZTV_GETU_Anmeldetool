package org.ztv.anmeldetool.anmeldetool.util;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.anmeldetool.models.WertungsrichterSlot;
import org.ztv.anmeldetool.anmeldetool.transfer.WertungsrichterSlotDTO;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public abstract class WertungsrichterSlotMapper {

	// @Mapping(source = "brevet.brevet", target = "brevet")
	public abstract WertungsrichterSlotDTO ToDto(WertungsrichterSlot wrSlot);

}
