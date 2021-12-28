package org.ztv.anmeldetool.anmeldetool.util;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.anmeldetool.models.WertungsrichterSlot;
import org.ztv.anmeldetool.anmeldetool.transfer.WertungsrichterSlotDTO;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public abstract class WertungsrichterSlotMapper {

	@Mapping(expression = "java(wrSlot.getBrevet().ordinal()+1)", target = "brevet")
	public abstract WertungsrichterSlotDTO ToDto(WertungsrichterSlot wrSlot);

}
