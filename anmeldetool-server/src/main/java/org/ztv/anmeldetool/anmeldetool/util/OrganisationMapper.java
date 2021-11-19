package org.ztv.anmeldetool.anmeldetool.util;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationDTO;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public abstract class OrganisationMapper {

	public abstract OrganisationDTO ToDto(Organisation organisation);
}
