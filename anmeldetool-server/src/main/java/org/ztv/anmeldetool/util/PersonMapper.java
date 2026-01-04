package org.ztv.anmeldetool.util;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import org.mapstruct.AfterMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingInheritanceStrategy;
import org.mapstruct.MappingConstants;
import org.mapstruct.MappingTarget;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.transfer.RolleDTO;
import org.ztv.anmeldetool.util.idmapper.OrganisationFromIdMapper;

// @Mapper(componentModel = MappingConstants.ComponentModel.SPRING, mappingInheritanceStrategy = MappingInheritanceStrategy.AUTO_INHERIT_CONFIG_FROM_PARENT)
@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, uses = { WertungsrichterMapper.class,
    OrganisationFromIdMapper.class })
public interface PersonMapper {

    @Mapping(target = "password", ignore = true)
    Person toEntity(PersonDTO personDTO);

    @Mapping(target = "password", ignore = true)
    @Mapping(target = "organisationids", ignore = true)
    @Mapping(target = "rollen", ignore = true)
    PersonDTO toDto(Person person);

    List<PersonDTO> toDtoList(Collection<Person> persons);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "password", ignore = true)
    void updateEntityFromDto(PersonDTO dto, @MappingTarget Person entity);

    /*
    @AfterMapping
    default void afterToDto(Person person, @MappingTarget PersonDTO.PersonDTOBuilder personDTOBuilder) {
        Set<String> organisationIds = person.getOrganisationenLinks().stream()
                .map(opl -> opl.getOrganisation().getId().toString())
                .collect(Collectors.toSet());
        personDTOBuilder.organisationids(organisationIds);
    }*/

    /*
    default PersonDTO toDtoWithOrg(Person person, Organisation organisation) {
        PersonDTO dto = toDto(person);
        Set<RolleDTO> rollen = person.getOrganisationenLinks().stream()
                .filter(opl -> opl.getOrganisation().equals(organisation))
                .flatMap(opl -> opl.getRollenLink().stream())
                .map(rl -> new RolleDTO(rl.getId().toString(), rl.getRolle().getName(), rl.isAktiv()))
                .collect(Collectors.toSet());
        dto.setRollen(rollen);
        return dto;
    }
     */
}
