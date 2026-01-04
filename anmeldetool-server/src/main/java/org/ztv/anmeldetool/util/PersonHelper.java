package org.ztv.anmeldetool.util;

import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;
import lombok.extern.slf4j.Slf4j;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.transfer.RolleDTO;

@Slf4j
public class PersonHelper {

  /**
   * Creates a DTO with only the Roles valid for the Organisation handed over
   * @param person
   * @param organisation
   * @return PersonDTO
   */
  public static PersonDTO createPersonDTO(Person person, Organisation organisation) {
    List<UUID> organisationids = person.getOrganisationenLinks().stream().map(opl -> opl.getOrganisation().getId())
        .collect(Collectors.toList());
    Set<RolleDTO> rollenDto = new HashSet<>();
    Collection<Rolle> rollen = OrganisationLinkHelper.getRollenForOrganisation(person.getOrganisationenLinks(),
        organisation);

    for (Rolle rolle : rollen) {
      rollenDto.add(RolleDTO.builder().name(rolle.getName()).beschreibung(rolle.getBeschreibung())
          .aktiv(rolle.isAktiv()).build());
    }
    return PersonDTO.builder().id(person.getId()).benutzername(person.getBenutzername()).name(person.getName())
        .email(person.getEmail()).handy(person.getHandy()).vorname(person.getVorname())
        .organisationids(organisationids).rollen(rollenDto).aktiv(person.isAktiv()).build();
  }
}
