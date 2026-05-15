package org.ztv.anmeldetool.util;

import java.util.Objects;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.Collection;
import java.util.List;

import org.mapstruct.Context;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.transfer.RolleDTO;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface RolleMapper {

    @Mapping(target = "id", source = "rolle.id")
    @Mapping(target = "name", source = "rolle.name")
    @Mapping(target = "beschreibung", source = "rolle.beschreibung")
    @Mapping(target = "aktiv", source = "aktiv")
    @Mapping(target = "publicAssignable", source = "rolle.publicAssignable")
    RolleDTO toDto(RollenLink rollenLink);

    RolleDTO toDto(Rolle rolle);

    List<RolleDTO> toDtoList(Collection<Rolle> rollen);

    /**
     * Flattens all roles for the given organisation from a person's organisation links.
     *
     * <p>Used by {@link PersonMapper} to map {@code Person.organisationenLinks -> PersonDTO.rollen}
     * for the currently active organisation.
     */
    default Set<RolleDTO> toDtoSet(Collection<OrganisationPersonLink> organisationenLinks,
                                  @Context UUID organisationId) {
        if (organisationenLinks == null || organisationId == null) {
            return Set.of();
        }

        return organisationenLinks.stream()
            .filter(Objects::nonNull)
            .filter(link -> link.getOrganisation() != null && organisationId.equals(link.getOrganisation().getId()))
            .flatMap(link -> link.getRollenLink() != null ? link.getRollenLink().stream() : java.util.stream.Stream.empty())
            .map(this::toDto)
            .collect(Collectors.toSet());
    }
}
