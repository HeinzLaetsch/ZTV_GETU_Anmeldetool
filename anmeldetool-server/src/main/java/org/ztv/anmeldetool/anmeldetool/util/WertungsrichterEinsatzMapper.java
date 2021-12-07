package org.ztv.anmeldetool.anmeldetool.util;

import java.util.Optional;
import java.util.UUID;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.springframework.beans.factory.annotation.Autowired;
import org.ztv.anmeldetool.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.anmeldetool.models.WertungsrichterEinsatz;
import org.ztv.anmeldetool.anmeldetool.models.WertungsrichterSlot;
import org.ztv.anmeldetool.anmeldetool.repositories.PersonAnlassLinkRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.WertungsrichterSlotRepository;
import org.ztv.anmeldetool.anmeldetool.transfer.WertungsrichterEinsatzDTO;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public abstract class WertungsrichterEinsatzMapper {

	@Autowired
	WertungsrichterSlotRepository wertungsrichterSlotRepository;

	@Autowired
	PersonAnlassLinkRepository personAnlassLinkRepository;

	@Mapping(source = "wertungsrichterSlot.id", target = "wertungsrichterSlotId")
	@Mapping(source = "personAnlassLink.id", target = "personAnlassLinkId")
	public abstract WertungsrichterEinsatzDTO ToDto(WertungsrichterEinsatz wrEinsatz);

	@Mapping(expression = "java(mapWertungsrichterSlot(wrEinsatzDTO.getWertungsrichterSlotId()))", target = "wertungsrichterSlot")
	@Mapping(expression = "java(mapPersonAnlassLink(wrEinsatzDTO.getPersonAnlassLinkId()))", target = "personAnlassLink")
	public abstract WertungsrichterEinsatz ToEntity(WertungsrichterEinsatzDTO wrEinsatzDTO);

	protected WertungsrichterSlot mapWertungsrichterSlot(UUID wertungsrichterSlotId) {
		Optional<WertungsrichterSlot> opt = wertungsrichterSlotRepository.findById(wertungsrichterSlotId);
		if (opt.isEmpty())
			return null;
		return opt.get();
	}

	protected PersonAnlassLink mapPersonAnlassLink(UUID personAnlassLinkId) {
		Optional<PersonAnlassLink> opt = personAnlassLinkRepository.findById(personAnlassLinkId);
		if (opt.isEmpty())
			return null;
		return opt.get();
	}
}
