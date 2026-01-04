package org.ztv.anmeldetool.util;

import java.util.Collection;
import java.util.List;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.transfer.RolleDTO;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface RolleMapper {

    @Mapping(target = "id", source = "rolle.id")
    @Mapping(target = "name", source = "rolle.name")
    @Mapping(target = "beschreibung", source = "rolle.beschreibung")
    @Mapping(target = "publicAssignable", source = "rolle.publicAssignable")
    RolleDTO toDto(RollenLink rollenLink);

    RolleDTO toDto(Rolle rolle);

    List<RolleDTO> toDtoList(Collection<Rolle> rollen);
}