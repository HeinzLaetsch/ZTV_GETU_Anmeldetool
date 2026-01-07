package org.ztv.anmeldetool.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
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
@Disabled
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
            Collection<Person> result = personService.findPersonsByOrganisation(orgId);
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
            when(persRepo.findByBenutzernameIgnoreCase("abc")).thenReturn(Optional.of(p));
            Person res = personService.findPersonByBenutzername("ABC");
            assertNotNull(res);
            assertEquals("abc", res.getBenutzername());
        }
    }

    @Nested
    class CreatePersonEntityTests {
        @Test
        void whenCreateWithPassword_thenEncodeAndSave() {
            OrganisationPersonLink orgPersLink = new OrganisationPersonLink();
            Person p = new Person(); p.setPassword("plain");
            when(passwordEncoder.encode("plain")).thenReturn("encoded");
            when(persRepo.save(any(Person.class))).thenAnswer(inv -> inv.getArgument(0));
            Person res = personService.create(p,orgPersLink );
            assertNotNull(res);
            assertEquals("encoded", res.getPassword());
            verify(persRepo).save(res);
        }
        @Test
        void whenCreateWithoutPassword_thenSaveAsIs() {
            OrganisationPersonLink orgPersLink = new OrganisationPersonLink();
            Person p = new Person(); p.setPassword(null);
            when(persRepo.save(any(Person.class))).thenAnswer(inv -> inv.getArgument(0));
            Person res = personService.create(p, orgPersLink);
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
            when(organisationSrv.findById(orgId)).thenReturn(null);
            PersonDTO resp = personService.update(dto.getId(), dto, orgId);
            assertNull(resp);
        }

        @Test
        void whenPersonNotFound_thenNotFound() {
            UUID orgId = UUID.randomUUID();
            PersonDTO dto = PersonDTO.builder().id(UUID.randomUUID()).build();
            Organisation org = new Organisation(); org.setId(orgId);
            when(organisationSrv.findById(orgId)).thenReturn(org);
            when(persRepo.findById(dto.getId())).thenReturn(Optional.empty());
            PersonDTO resp = personService.update(dto.getId(), dto, orgId);
            assertNull(resp);
        }

        @Test
        void whenValid_thenUpdateAndReturnDto() {
            UUID orgId = UUID.randomUUID();
            Organisation org = new Organisation(); org.setId(orgId);
            UUID pid = UUID.randomUUID();
            Person existing = Person.builder().id(pid).benutzername("old").name("Last").vorname("First").build();
            when(organisationSrv.findById(orgId)).thenReturn(org);
            PersonDTO dto = PersonDTO.builder().id(pid).benutzername("newuser").name("NLast").vorname("NFirst").password("pw").aktiv(true).build();
            when(persRepo.findById(pid)).thenReturn(Optional.of(existing));
            when(passwordEncoder.encode(anyString())).thenReturn("encoded");
            when(persRepo.save(any(Person.class))).thenAnswer(inv -> inv.getArgument(0));
            PersonDTO resp = personService.update(dto.getId(),dto, orgId);
            assertNotNull(resp);
            assertEquals("newuser", resp.getBenutzername());
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
