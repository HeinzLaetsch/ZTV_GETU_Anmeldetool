package org.ztv.anmeldetool.anmeldetool.util;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.anmeldetool.models.WertungsrichterEinsatz;
import org.ztv.anmeldetool.anmeldetool.transfer.WertungsrichterEinsatzCsvDTO;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public abstract class WertungsrichterEinsatzExportMapper {

	@Mapping(source = "wertungsrichterSlot.brevet", target = "brevet")
	@Mapping(source = "wertungsrichterSlot.tag", target = "tag")
	@Mapping(source = "wertungsrichterSlot.start_zeit", target = "start_zeit")
	@Mapping(source = "wertungsrichterSlot.end_zeit", target = "end_zeit")
	@Mapping(source = "wertungsrichterSlot.beschreibung", target = "beschreibung")
	public abstract WertungsrichterEinsatzCsvDTO ToDto(WertungsrichterEinsatz wrEinsatz);
}