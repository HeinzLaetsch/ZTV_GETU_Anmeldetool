package org.ztv.anmeldetool.anmeldetool.util;

import java.util.List;
import java.util.stream.Collectors;

import org.mapstruct.BeanMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.mapstruct.NullValuePropertyMappingStrategy;
import org.springframework.beans.factory.annotation.Autowired;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.anmeldetool.transfer.AnlassDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationDTO;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, uses = { WertungsrichterSlotMapper.class })
public abstract class AnlassMapper {

	@Autowired
	OrganisationMapper organisationMapper;

	@BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
	@Mapping(expression = "java(mapOrganisationenDTO(anlass.getOrganisationenLinks()))", target = "organisationen")
	@Mapping(source = "startDate", target = "startDatum")
	@Mapping(source = "endDate", target = "endDatum")
	public abstract AnlassDTO ToDto(Anlass anlass);

	public List<OrganisationDTO> mapOrganisationenDTO(List<OrganisationAnlassLink> links) {
		return links.stream().map(link -> {
			return organisationMapper.ToDto(link.getOrganisation());
		}).collect(Collectors.toList());
	}

}
