package org.ztv.anmeldetool.util;

import org.mapstruct.Context;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.mapstruct.MappingTarget;
import org.mapstruct.ObjectFactory;
import org.ztv.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.transfer.OrganisationPersonLinkDTO;
import org.ztv.anmeldetool.util.idmapper.OrganisationFromIdMapper;
import org.ztv.anmeldetool.util.idmapper.PersonFromIdMapper;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, uses = { OrganisationFromIdMapper.class,
    PersonFromIdMapper.class })
public interface OrganisationPersonLinkMapper {

    //@Mapping(target = "id", ignore = true)
    @Mapping(source = "personId", target = "person")
    @Mapping(source = "organisationId", target = "organisation")
    OrganisationPersonLink toEntity(OrganisationPersonLinkDTO organisationPersonLinkDTO, @Context CycleAvoidingMappingContext context);

    @Mapping(source = "organisation.id", target = "organisationId")
    @Mapping(source = "person.id", target = "personId")
    OrganisationPersonLinkDTO toDto(OrganisationPersonLink organisationPersonLink, @Context CycleAvoidingMappingContext context);

    /*
    default OrganisationPersonLinkDTO map(OrganisationPersonLink organisationPersonLink, @Context CycleAvoidingMappingContext context){
        return new OrganisationPersonLinkDTO(organisationPersonLink.getId(), organisationPersonLink.isAktiv(), organisationPersonLink.getOrganisation().getId(), organisationPersonLink.getPerson().getId());
    }
    */

    List<OrganisationPersonLinkDTO> toDtoList(Collection<OrganisationPersonLink> organisationPersonLinks);

    void updateEntityFromDto(OrganisationPersonLinkDTO dto, @MappingTarget OrganisationPersonLink entity);

    // MapStruct will use these methods to map nested objects to UUIDs
    default UUID mapPersonToId(org.ztv.anmeldetool.models.Person person) {
        return person != null ? person.getId() : null;
    }
    default UUID mapOrganisationToId(org.ztv.anmeldetool.models.Organisation organisation) {
        return organisation != null ? organisation.getId() : null;
    }
}
