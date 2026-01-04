package org.ztv.anmeldetool.util;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Verband;
import org.ztv.anmeldetool.transfer.OrganisationDTO;

import java.util.Collection;
import java.util.List;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface OrganisationMapper {

    @Mapping(target = "verbandId", source = "verband.id")
    OrganisationDTO toDto(Organisation organisation);

    List<OrganisationDTO> toDtoList(Collection<Organisation> organisations);

    @Mapping(target = "verband", source = "verband")
    Organisation toEntity(OrganisationDTO dto, Verband verband);
}
