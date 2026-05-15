package org.ztv.anmeldetool.util;

import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.mapstruct.AfterMapping;
import org.mapstruct.BeanMapping;
import org.mapstruct.Builder;
import org.mapstruct.Context;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingInheritanceStrategy;
import org.mapstruct.MappingConstants;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.transfer.RolleDTO;
import org.ztv.anmeldetool.util.idmapper.OrganisationFromIdMapper;
import org.ztv.anmeldetool.util.idmapper.PersonFromIdMapper;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING,
    builder = @Builder(disableBuilder = true),
    uses = { WertungsrichterMapper.class,
    OrganisationPersonLinkMapper.class, RolleMapper.class, OrganisationFromIdMapper.class, PersonFromIdMapper.class })
public interface PersonMapper {

    @Mapping(target = "password", ignore = true)
    // @Mapping(source = "rollen", target = "")
    @Mapping(source = "organisationenLinks", target = "organisationenLinks")
    Person toEntity(PersonDTO personDTO, @Context CycleAvoidingMappingContext context);

    /** Convenience wrapper (creates a fresh cycle-avoid context). */
    default Person toEntity(PersonDTO personDTO) {
        return toEntity(personDTO, new CycleAvoidingMappingContext());
    }
    @AfterMapping
    default void handleNullDeptList(PersonDTO source, @MappingTarget Person target) {
        if (source.organisationenLinks() == null) {
            target.setOrganisationenLinks(new HashSet<>());
        }
    }
    /**
     * Maps a {@link Person} to {@link PersonDTO}.
     *
     * <p>Note: {@code rollen} is filtered by the active organisation when an organisationId is provided.
     */
    @Mapping(target = "password", ignore = true)
    @Mapping(target = "organisationids", ignore = true)
    @Mapping(source = "organisationenLinks", target = "rollen")
    @Mapping(source = "organisationenLinks", target = "organisationenLinks")
    PersonDTO toDto(Person person,
                   @Context UUID organisationId,
                   @Context CycleAvoidingMappingContext context);

    /** Convenience wrapper (creates a fresh cycle-avoid context). */
    default PersonDTO toDto(Person person, UUID organisationId) {
        return toDto(person, organisationId, new CycleAvoidingMappingContext());
    }

    // Intentionally no `toDto(Person)` overload here.
    // MapStruct would consider it for element mappings and create ambiguous method resolution.
    // Callers that don't know the active organisation should use `toDto(person, null)`.

    List<PersonDTO> toDtoList(Collection<Person> persons,
                              @Context UUID organisationId,
                              @Context CycleAvoidingMappingContext context);

    default List<PersonDTO> toDtoList(Collection<Person> persons, UUID organisationId) {
        return toDtoList(persons, organisationId, new CycleAvoidingMappingContext());
    }

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "password", ignore = true)
    // @Mapping(source = "organisationenLinks", target = "organisationenLinks")
    void updateEntityFromDto(PersonDTO dto, @MappingTarget Person entity, @Context CycleAvoidingMappingContext context);

    default void updateEntityFromDto(PersonDTO dto, @MappingTarget Person entity) {
        updateEntityFromDto(dto, entity, new CycleAvoidingMappingContext());
    }

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
