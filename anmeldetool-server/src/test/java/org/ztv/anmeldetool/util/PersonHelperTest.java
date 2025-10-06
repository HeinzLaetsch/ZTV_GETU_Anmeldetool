package org.ztv.anmeldetool.util;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.transfer.PersonDTO;

@DisplayName("PersonHelper Test Suite")
public class PersonHelperTest {

  // Contract
  // - isPersonMemberOfOrganisation: returns true when person has an active OrganisationPersonLink
  //   with the same Organisation, false otherwise (including null inputs)
  // - createPersonDTO(person, organisation): builds DTO with organisationids and rollen for that org
  // - createPersonDTO(person): builds DTO; returns null if person null
  // - createPerson(personDTO): builds Person from DTO and copies aktiv flag

  private Organisation createOrganisation(String name) {
    return Organisation.builder().name(name).verband(null).build();
  }

  private Person createPerson(String username) {
    return Person.builder().id(UUID.randomUUID()).benutzername(username).name("Last")
        .vorname("First").email("a@b.c").handy("123").password("pw").build();
  }

  private OrganisationPersonLink createActiveLink(Organisation org, Person p) {
    OrganisationPersonLink link = new OrganisationPersonLink(org, p);
    link.setOrganisation(org);
    link.setPerson(p);
    link.setAktiv(true);
    // add an active RollenLink
    Rolle r = Rolle.builder().name("ADMIN").beschreibung("admin").build();
    r.setAktiv(true);
    RollenLink rl = new RollenLink();
    rl.setRolle(r);
    rl.setLink(link);
    // mark aktiv on RollenLink
    rl.setAktiv(true);
    Set<RollenLink> set = new HashSet<>();
    set.add(rl);
    link.setRollenLink(set);
    return link;
  }

  @Nested
  @DisplayName("isPersonMemberOfOrganisation")
  class IsMember {

    @Test
    @DisplayName("returns true when active link exists for organisation")
    void returnsTrueWhenActiveLinkExists() {
      Organisation org = createOrganisation("TV Test");
      Person p = createPerson("u1");
      OrganisationPersonLink link = createActiveLink(org, p);
      p.addToOrganisationenLink(link);

      assertTrue(PersonHelper.isPersonMemberOfOrganisation(p, org));
    }

    @Test
    @DisplayName("returns false when person null or organisation null or no active link")
    void returnsFalseOnNullsOrNoActive() {
      Organisation org = createOrganisation("TV X");
      Person p = createPerson("u2");

      // null person
      assertFalse(PersonHelper.isPersonMemberOfOrganisation(null, org));
      // null org
      assertFalse(PersonHelper.isPersonMemberOfOrganisation(p, null));

      // person with no links
      assertFalse(PersonHelper.isPersonMemberOfOrganisation(p, org));

      // link exists but inactive
      OrganisationPersonLink l2 = new OrganisationPersonLink(org, p);
      l2.setAktiv(false);
      p.addToOrganisationenLink(l2);
      assertFalse(PersonHelper.isPersonMemberOfOrganisation(p, org));
    }
  }

  @Nested
  @DisplayName("createPersonDTO(Person, Organisation)")
  class CreateDtoWithOrg {

    @Test
    @DisplayName("populates organisationids and rollen for the given organisation")
    void populatesOrganisationIdsAndRollen() {
      Organisation org1 = createOrganisation("Org1");
      Organisation org2 = createOrganisation("Org2");
      Person p = createPerson("u3");

      OrganisationPersonLink link1 = createActiveLink(org1, p);
      OrganisationPersonLink link2 = createActiveLink(org2, p);
      p.addToOrganisationenLink(link1);
      p.addToOrganisationenLink(link2);

      PersonDTO dto = PersonHelper.createPersonDTO(p, org2);
      assertNotNull(dto);
      assertTrue(dto.getOrganisationids().contains(org1.getId()));
      assertTrue(dto.getOrganisationids().contains(org2.getId()));
      // roles should contain the ROLE created for org2
      assertNotNull(dto.getRollen());
      boolean found = dto.getRollen().stream().anyMatch(r -> "ADMIN".equals(r.getName()));
      assertTrue(found);
    }

    @Test
    @DisplayName("handles person with empty links")
    void handlesEmptyLinks() {
      Organisation org = createOrganisation("X");
      Person p = createPerson("u4");
      // no links
      PersonDTO dto = PersonHelper.createPersonDTO(p, org);
      assertNotNull(dto);
      assertNotNull(dto.getOrganisationids());
      assertTrue(dto.getOrganisationids().isEmpty());
      assertNotNull(dto.getRollen());
      assertTrue(dto.getRollen().isEmpty());
    }
  }

  @Nested
  @DisplayName("createPersonDTO(Person)")
  class CreateDto {

    @Test
    @DisplayName("returns null when person is null")
    void returnsNullWhenPersonNull() {
      assertNull(PersonHelper.createPersonDTO(null));
    }

    @Test
    @DisplayName("builds dto with organisation ids when links present")
    void buildsDtoWithOrganisationIds() {
      Organisation org = createOrganisation("O");
      Person p = createPerson("u5");
      OrganisationPersonLink l = new OrganisationPersonLink(org, p);
      l.setOrganisation(org);
      l.setPerson(p);
      p.addToOrganisationenLink(l);

      PersonDTO dto = PersonHelper.createPersonDTO(p);
      assertNotNull(dto);
      assertNotNull(dto.getOrganisationids());
      assertEquals(1, dto.getOrganisationids().size());
      assertEquals(org.getId(), dto.getOrganisationids().get(0));
    }
  }

  @Nested
  @DisplayName("createPerson(PersonDTO)")
  class CreatePersonFromDto {

    @Test
    @DisplayName("copies fields and aktiv flag")
    void copiesFieldsAndAktiv() {
      UUID id = UUID.randomUUID();
      PersonDTO dto = PersonDTO.builder().id(id).benutzername("user").name("L").vorname("F")
          .email("x@x").handy("h").password("pw").aktiv(true)
          .organisationids(Collections.emptyList()).rollen(Collections.emptySet()).build();
      Person p = PersonHelper.createPerson(dto);
      assertNotNull(p);
      assertEquals(id, p.getId());
      assertEquals("user", p.getBenutzername());
      assertEquals("L", p.getName());
      assertEquals("F", p.getVorname());
      assertTrue(p.isAktiv());
      assertEquals("pw", p.getPassword());
    }
  }
}
