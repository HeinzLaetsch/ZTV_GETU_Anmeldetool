package org.ztv.anmeldetool.anmeldetool.util;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.anmeldetool.models.Wertungsrichter;
import org.ztv.anmeldetool.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.anmeldetool.transfer.WertungsrichterDTO;
import org.ztv.anmeldetool.anmeldetool.util.idmapper.PersonFromIdMapper;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, uses = { PersonFromIdMapper.class })
public abstract class WertungsrichterExportMapper {

	@Mapping(source = "person.id", target = "personId")
	@Mapping(expression = "java(mapBrevet(wr))", target = "brevet")
	public abstract WertungsrichterDTO WertungsrichterToWertungsrichterDTO(Wertungsrichter wr);

	@Mapping(source = "personId", target = "person")
	@Mapping(expression = "java(mapBrevet(wrDTO))", target = "brevet")
	public abstract Wertungsrichter WertungsrichterDTOToWertungsrichter(WertungsrichterDTO wrDTO);

	int mapBrevet(Wertungsrichter wr) {
		if (WertungsrichterBrevetEnum.Brevet_1.equals(wr.getBrevet())) {
			return 1;
		}
		return 2;
	}

	WertungsrichterBrevetEnum mapBrevet(WertungsrichterDTO wrDTO) {
		if (wrDTO.getBrevet() == 1) {
			return WertungsrichterBrevetEnum.Brevet_1;
		}
		return WertungsrichterBrevetEnum.Brevet_2;
	}
}
