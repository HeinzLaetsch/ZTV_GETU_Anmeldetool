package org.ztv.anmeldetool.util;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.transfer.OrganisationDTO;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public abstract class OrganisationMapper {

	public abstract OrganisationDTO ToDto(Organisation organisation);
}
