package org.ztv.anmeldetool.service;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.models.*;
import org.ztv.anmeldetool.repositories.*;
import org.ztv.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.util.PersonMapper;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
//@Disabled
public class PersonServiceTest {

    private static PersonDTO personDto(UUID id, String benutzername, String name, String vorname, String password, boolean aktiv) {
        return new PersonDTO(
                id,
                List.of(),
                List.of(),
                benutzername,
                name,
                vorname,
                null,
                null,
                password,
                aktiv,
                Set.of()
        );
    }

    @Mock PasswordEncoder passwordEncoder;
    @Mock OrganisationService organisationSrv;
    @Mock RoleService roleSrv;
    @Mock PersonenRepository persRepo;
    @Mock RollenLinkRepository rollenLinkRep;
    @Mock OrganisationPersonLinkRepository orgPersLinkRep;
    @Mock PersonMapper personMapper;

    @InjectMocks PersonService personService;

    // MockitoExtension initializes mocks; no additional setup required.

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
            when(persRepo.findByOrganisation(org)).thenReturn(List.of(p));
            Collection<Person> result = personService.findPersonsByOrganisation(org);
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
        void whenNotPresent_thenThrowNotFound() {
            UUID id = UUID.randomUUID();
            when(persRepo.findById(id)).thenReturn(Optional.empty());
            assertThrows(NotFoundException.class, () -> personService.findPersonById(id));
        }
    }

    @Nested
    class FindPersonByBenutzernameTests {
        @Test
        void whenFound_thenReturn() {
            Person p = new Person(); p.setBenutzername("abc");
            when(persRepo.findByBenutzernameIgnoreCase(anyString())).thenReturn(Optional.of(p));
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
        void whenOrganisationNotFound_thenThrowNotFound() {
            UUID orgId = UUID.randomUUID();
            PersonDTO dto = personDto(UUID.randomUUID(), null, null, null, null, false);
            when(organisationSrv.findById(orgId)).thenThrow(new NotFoundException(Organisation.class, orgId));
            assertThrows(NotFoundException.class, () -> personService.update(dto.id(), dto, orgId));
        }

        @Test
        void whenPersonNotFound_thenThrowNotFound() {
            UUID orgId = UUID.randomUUID();
            PersonDTO dto = personDto(UUID.randomUUID(), null, null, null, null, false);
            Organisation org = new Organisation(); org.setId(orgId);
            when(organisationSrv.findById(orgId)).thenReturn(org);
            when(persRepo.findById(dto.id())).thenReturn(Optional.empty());
            assertThrows(NotFoundException.class, () -> personService.update(dto.id(), dto, orgId));
        }

        @Test
        void whenValid_thenUpdateAndReturnDto() {
            UUID orgId = UUID.randomUUID();
            Organisation org = new Organisation(); org.setId(orgId);
            UUID pid = UUID.randomUUID();
            Person existing = Person.builder().id(pid).benutzername("old").name("Last").vorname("First").build();
            when(organisationSrv.findById(orgId)).thenReturn(org);
            PersonDTO dto = personDto(pid, "newuser", "NLast", "NFirst", "pw", true);
            when(persRepo.findById(pid)).thenReturn(Optional.of(existing));

            doAnswer(inv -> {
                PersonDTO source = inv.getArgument(0);
                Person target = inv.getArgument(1);
                target.setBenutzername(source.benutzername());
                target.setName(source.name());
                target.setVorname(source.vorname());
                target.setAktiv(source.aktiv());
                return null;
            }).when(personMapper).updateEntityFromDto(eq(dto), eq(existing));

            when(passwordEncoder.encode(anyString())).thenReturn("encoded");
            when(persRepo.save(any(Person.class))).thenAnswer(inv -> inv.getArgument(0));
            when(personMapper.toDto(any(Person.class), eq(orgId))).thenReturn(dto);
            PersonDTO resp = personService.update(dto.id(), dto, orgId);
            assertNotNull(resp);
            assertEquals("newuser", resp.benutzername());
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
