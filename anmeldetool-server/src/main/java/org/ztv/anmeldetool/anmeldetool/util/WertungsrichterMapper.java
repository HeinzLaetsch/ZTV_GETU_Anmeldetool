package org.ztv.anmeldetool.anmeldetool.util;

import java.util.UUID;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.springframework.beans.factory.annotation.Autowired;
import org.ztv.anmeldetool.anmeldetool.models.Person;
import org.ztv.anmeldetool.anmeldetool.models.Wertungsrichter;
import org.ztv.anmeldetool.anmeldetool.service.PersonService;
import org.ztv.anmeldetool.anmeldetool.transfer.WertungsrichterDTO;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public abstract class WertungsrichterMapper {
	@Autowired
	private PersonService personSrv;

	@Mapping(source = "person.id", target = "personId")
	public abstract WertungsrichterDTO WertungsrichterToWertungsrichterDTO(Wertungsrichter wr);

	@Mapping(expression = "java(getPersonFromId(wrDTO.getPersonId()))", target = "person")
	public abstract Wertungsrichter WertungsrichterDTOToWertungsrichter(WertungsrichterDTO wrDTO);

	public Person getPersonFromId(UUID personId) {
		return personSrv.findPersonById(personId);
	}
}
