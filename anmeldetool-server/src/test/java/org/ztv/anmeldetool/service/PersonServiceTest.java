package org.ztv.anmeldetool.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.ztv.anmeldetool.models.*;
import org.ztv.anmeldetool.repositories.*;
import org.ztv.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.transfer.RolleDTO;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class PersonServiceTest {

    @Mock PasswordEncoder passwordEncoder;
    @Mock OrganisationService organisationSrv;
    @Mock RoleService roleSrv;
    @Mock PersonenRepository persRepo;
    @Mock RollenLinkRepository rollenLinkRep;
    @Mock OrganisationPersonLinkRepository orgPersLinkRep;

    @InjectMocks PersonService personService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Nested
    class FindPersonsByOrganisationTests {
        @Test
        void whenPersonsExist_thenReturnDtos() {
            UUID orgId = UUID.randomUUID();
            Person p = Person.builder().id(UUID.randomUUID()).benutzername("user1").name("Last").vorname("First").build();
            OrganisationPersonLink opl = new OrganisationPersonLink();
            Organisation org = new Organisation(); org.setId(orgId);
            opl.setOrganisation(org);
            opl.setPerson(p);
            opl.setAktiv(true);
            p.getOrganisationenLinks().add(opl);
            when(persRepo.findByOrganisationId(orgId)).thenReturn(List.of(p));
            Collection<org.ztv.anmeldetool.transfer.PersonDTO> result = personService.findPersonsByOrganisation(orgId);
            assertNotNull(result);
            assertEquals(1, result.size());
            assertEquals("user1", result.iterator().next().getBenutzername());
        }
    }

    @Nested
    class FindPersonByIdTests {
        @Test
        void whenPresent_thenReturnPerson() {
            UUID id = UUID.randomUUID();
            Person p = new Person(); p.setId(id);
            when(persRepo.findById(id)).thenReturn(Optional.of(p));
            Person res = personService.findPersonById(id);
            assertNotNull(res);
            assertEquals(id, res.getId());
        }
        @Test
        void whenNotPresent_thenReturnNull() {
            UUID id = UUID.randomUUID();
            when(persRepo.findById(id)).thenReturn(Optional.empty());
            Person res = personService.findPersonById(id);
            assertNull(res);
        }
    }

    @Nested
    class FindPersonByBenutzernameTests {
        @Test
        void whenFound_thenReturn() {
            Person p = new Person(); p.setBenutzername("abc");
            when(persRepo.findByBenutzernameIgnoreCase("abc")).thenReturn(p);
            Person res = personService.findPersonByBenutzername("ABC");
            assertNotNull(res);
            assertEquals("abc", res.getBenutzername());
        }
    }

    @Nested
    class CreatePersonEntityTests {
        @Test
        void whenCreateWithPassword_thenEncodeAndSave() {
            Person p = new Person(); p.setPassword("plain");
            when(passwordEncoder.encode("plain")).thenReturn("encoded");
            when(persRepo.save(any(Person.class))).thenAnswer(inv -> inv.getArgument(0));
            Person res = personService.create(p, true);
            assertNotNull(res);
            assertEquals("encoded", res.getPassword());
            verify(persRepo).save(res);
        }
        @Test
        void whenCreateWithoutPassword_thenSaveAsIs() {
            Person p = new Person(); p.setPassword(null);
            when(persRepo.save(any(Person.class))).thenAnswer(inv -> inv.getArgument(0));
            Person res = personService.create(p, true);
            assertNotNull(res);
            assertNull(res.getPassword());
            verify(persRepo).save(res);
        }
    }

    @Nested
    class UpdateTests {
        @Test
        void whenOrganisationNotFound_thenNotFound() {
            UUID orgId = UUID.randomUUID();
            PersonDTO dto = PersonDTO.builder().id(UUID.randomUUID()).build();
            when(organisationSrv.findOrganisationById(orgId)).thenReturn(null);
            ResponseEntity<org.ztv.anmeldetool.transfer.PersonDTO> resp = personService.update(dto, orgId);
            assertEquals(404, resp.getStatusCode().value());
        }

        @Test
        void whenPersonNotFound_thenNotFound() {
            UUID orgId = UUID.randomUUID();
            PersonDTO dto = PersonDTO.builder().id(UUID.randomUUID()).build();
            Organisation org = new Organisation(); org.setId(orgId);
            when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);
            when(persRepo.findById(dto.getId())).thenReturn(Optional.empty());
            ResponseEntity<org.ztv.anmeldetool.transfer.PersonDTO> resp = personService.update(dto, orgId);
            assertEquals(404, resp.getStatusCode().value());
        }

        @Test
        void whenValid_thenUpdateAndReturnDto() {
            UUID orgId = UUID.randomUUID();
            Organisation org = new Organisation(); org.setId(orgId);
            UUID pid = UUID.randomUUID();
            Person existing = Person.builder().id(pid).benutzername("old").name("Last").vorname("First").build();
            when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);
            PersonDTO dto = PersonDTO.builder().id(pid).benutzername("newuser").name("NLast").vorname("NFirst").password("pw").aktiv(true).build();
            when(persRepo.findById(pid)).thenReturn(Optional.of(existing));
            when(passwordEncoder.encode(anyString())).thenReturn("encoded");
            when(persRepo.save(any(Person.class))).thenAnswer(inv -> inv.getArgument(0));
            ResponseEntity<org.ztv.anmeldetool.transfer.PersonDTO> resp = personService.update(dto, orgId);
            assertEquals(200, resp.getStatusCode().value());
            assertNotNull(resp.getBody());
            assertEquals("newuser", resp.getBody().getBenutzername());
        }
    }

    @Nested
    class CreatePersonDtoTests {
        @Test
        void whenUserExistsInOther_thenConflict() {
            PersonDTO dto = PersonDTO.builder().benutzername("u1").organisationids(new ArrayList<>()).build();
            Person existing = new Person(); existing.setId(UUID.randomUUID());
            when(persRepo.findByBenutzernameIgnoreCase("u1")).thenReturn(existing);
            ResponseEntity resp = personService.create(dto, UUID.randomUUID());
            assertEquals(409, resp.getStatusCode().value());
        }

        @Test
        void whenOrganisationNotFound_thenNotFound() {
            PersonDTO dto = PersonDTO.builder().benutzername("u1").organisationids(new ArrayList<>()).build();
            when(persRepo.findByBenutzernameIgnoreCase("u1")).thenReturn(null);
            when(organisationSrv.findOrganisationById(any())).thenReturn(null);
            ResponseEntity resp = personService.create(dto, UUID.randomUUID());
            assertEquals(404, resp.getStatusCode().value());
        }

        @Test
        void whenValid_thenCreateAndReturnDto() {
            UUID orgId = UUID.randomUUID();
            Organisation org = new Organisation(); org.setId(orgId); org.setName("OrgX");
            PersonDTO dto = PersonDTO.builder().benutzername("u1").name("Last").vorname("First").organisationids(new ArrayList<>()).rollen(new HashSet<>()).build();
            when(persRepo.findByBenutzernameIgnoreCase("u1")).thenReturn(null);
            when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);
            Person saved = Person.builder().id(UUID.randomUUID()).benutzername("u1").name("Last").vorname("First").build();
            when(persRepo.save(any(Person.class))).thenReturn(saved);
            ResponseEntity<org.ztv.anmeldetool.transfer.PersonDTO> resp = personService.create(dto, orgId);
            assertEquals(200, resp.getStatusCode().value());
            assertNotNull(resp.getBody());
            assertEquals("u1", resp.getBody().getBenutzername());
        }
    }

    @Nested
    class UpdateUserOrganisationRollenTests {
        @Test
        void whenOrganisationNotFound_thenNotFound() {
            when(organisationSrv.findOrganisationById(any())).thenReturn(null);
            ResponseEntity<PersonDTO> resp = personService.updateUserOrganisationRollen(UUID.randomUUID().toString(), UUID.randomUUID().toString(), new HashSet<>());
            assertEquals(404, resp.getStatusCode().value());
        }

        @Test
        void whenPersonNotFound_thenNotFound() {
            UUID orgId = UUID.randomUUID();
            Organisation org = new Organisation(); org.setId(orgId);
            when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);
            UUID pid = UUID.randomUUID();
            when(persRepo.findById(pid)).thenReturn(Optional.empty());
            ResponseEntity<PersonDTO> resp = personService.updateUserOrganisationRollen(pid.toString(), orgId.toString(), new HashSet<>());
            assertEquals(404, resp.getStatusCode().value());
        }

        @Test
        void whenPersonHasNoOrganisationLinks_thenNotFound() {
            UUID orgId = UUID.randomUUID();
            Organisation org = new Organisation(); org.setId(orgId);
            UUID pid = UUID.randomUUID();
            Person p = new Person(); p.setId(pid);
            when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);
            when(persRepo.findById(pid)).thenReturn(Optional.of(p));
            assertThrows(NoSuchElementException.class, () -> personService.updateUserOrganisationRollen(pid.toString(), orgId.toString(), new HashSet<>()));
        }

        @Test
        void whenValid_thenUpdateRolesAndReturnDto() {
            UUID orgId = UUID.randomUUID();
            Organisation org = new Organisation(); org.setId(orgId);
            UUID pid = UUID.randomUUID();
            Person p = Person.builder().id(pid).benutzername("u").build();
            OrganisationPersonLink opl = new OrganisationPersonLink(); opl.setOrganisation(org); opl.setPerson(p);
            // existing role link
            RollenLink existingRl = new RollenLink(); existingRl.setId(UUID.randomUUID()); existingRl.setAktiv(true);
            Rolle existingR = new Rolle(); existingR.setName("USER"); existingRl.setRolle(existingR);
            Set<RollenLink> rlSet = new HashSet<>(); rlSet.add(existingRl);
            opl.setRollenLink(rlSet);
            p.getOrganisationenLinks().add(opl);
            when(organisationSrv.findOrganisationById(orgId)).thenReturn(org);
            when(persRepo.findById(pid)).thenReturn(Optional.of(p));
            when(persRepo.save(any(Person.class))).thenAnswer(inv -> inv.getArgument(0));
            // request: deactivate existing role and add a new one
            RolleDTO dtoOld = RolleDTO.builder().id(existingRl.getId().toString()).name("USER").aktiv(false).build();
            RolleDTO dtoNew = RolleDTO.builder().id(UUID.randomUUID().toString()).name("ADMIN").aktiv(true).build();
            Set<RolleDTO> rollen = new HashSet<>(); rollen.add(dtoOld); rollen.add(dtoNew);
            Rolle adminR = new Rolle(); adminR.setName("ADMIN"); when(roleSrv.findByName("ADMIN")).thenReturn(adminR);
            when(rollenLinkRep.save(any(RollenLink.class))).thenAnswer(inv -> inv.getArgument(0));
            ResponseEntity<PersonDTO> resp = personService.updateUserOrganisationRollen(pid.toString(), orgId.toString(), rollen);
            assertEquals(200, resp.getStatusCode().value());
            assertNotNull(resp.getBody());
        }
    }

    @Nested
    class PopulateLinkRollenTests {
        @Test
        void whenPopulate_thenRollenLinkAdded() {
            OrganisationPersonLink opl = new OrganisationPersonLink();
            Set<RolleDTO> rollenDto = new HashSet<>();
            RolleDTO rDto = RolleDTO.builder().name("TEST").aktiv(true).build();
            rollenDto.add(rDto);
            Rolle r = new Rolle(); r.setName("TEST");
            when(roleSrv.findByName("TEST")).thenReturn(r);
            personService.populateLinkRollen(opl, rollenDto);
            assertFalse(opl.getRollenLink().isEmpty());
            assertTrue(opl.getRollenLink().iterator().next().isAktiv());
        }
    }

    @Nested
    class GetEncodedPasswordTests {
        @Test
        void whenEncode_thenReturnEncoded() {
            when(passwordEncoder.encode("pw")).thenReturn("enc");
            String res = personService.getEncodedPassword("pw");
            assertEquals("enc", res);
        }
    }
}
