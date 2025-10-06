package org.ztv.anmeldetool.service;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.ztv.anmeldetool.models.*;
import org.ztv.anmeldetool.repositories.*;
import org.ztv.anmeldetool.transfer.RolleDTO;
import org.springframework.http.ResponseEntity;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class RoleServiceTest {

    @Mock
    RollenRepository rollenRep;

    @Mock
    OrganisationService orgService;

    @Mock
    OrganisationPersonLinkRepository oplRepo;

    @InjectMocks
    RoleService roleService;

    @Nested
    class FindByNameTests {
        @Test
        void findByName_shouldReturnRolle() {
            Rolle r = new Rolle();
            r.setName("ADMIN");
            when(rollenRep.findByName("ADMIN")).thenReturn(r);
            Rolle res = roleService.findByName("ADMIN");
            assertNotNull(res);
            assertEquals("ADMIN", res.getName());
        }

        @Test
        void findByName_shouldReturnNullWhenNotFound() {
            when(rollenRep.findByName("MISSING")).thenReturn(null);
            Rolle res = roleService.findByName("MISSING");
            assertNull(res);
        }
    }

    @Nested
    class FindAllTests {
        @Test
        void findAll_shouldReturnDtos() {
            Rolle r1 = new Rolle(); r1.setId(UUID.randomUUID()); r1.setName("R1"); r1.setBeschreibung("b1"); r1.setAktiv(true); r1.setPublicAssignable(true);
            Rolle r2 = new Rolle(); r2.setId(UUID.randomUUID()); r2.setName("R2"); r2.setBeschreibung("b2"); r2.setAktiv(false); r2.setPublicAssignable(false);
            when(rollenRep.findAll()).thenReturn(List.of(r1, r2));
            ResponseEntity<Collection<RolleDTO>> resp = roleService.findAll();
            assertEquals(200, resp.getStatusCode().value());
            Collection<RolleDTO> body = resp.getBody();
            assertNotNull(body);
            assertEquals(2, body.size());
            // verify fields mapped for one element
            Optional<RolleDTO> maybe = body.stream().filter(d -> d.getName().equals("R1")).findFirst();
            assertTrue(maybe.isPresent());
            RolleDTO dto = maybe.get();
            assertEquals("b1", dto.getBeschreibung());
            assertTrue(dto.isAktiv());
            assertTrue(dto.isPublicAssignable());
            assertEquals(r1.getId().toString(), dto.getId());
        }

        @Test
        void findAll_shouldReturnEmptyWhenNone() {
            when(rollenRep.findAll()).thenReturn(Collections.emptyList());
            ResponseEntity<Collection<RolleDTO>> resp = roleService.findAll();
            assertEquals(200, resp.getStatusCode().value());
            assertNotNull(resp.getBody());
            assertTrue(resp.getBody().isEmpty());
        }
    }

    @Nested
    class FindAllForUserTests {
        @Test
        void whenOrgNotFound_thenReturnNotFound() {
            String vereinsId = UUID.randomUUID().toString();
            when(orgService.findOrganisationById(UUID.fromString(vereinsId))).thenReturn(null);
            ResponseEntity<Collection<RolleDTO>> resp = roleService.findAllForUser(vereinsId, new Person());
            assertEquals(404, resp.getStatusCode().value());
        }

        @Test
        void whenNoLinks_thenReturnEmptyList() {
            Organisation org = new Organisation(); org.setId(UUID.randomUUID());
            String vereinsId = org.getId().toString();
            Person p = new Person(); p.setId(UUID.randomUUID());
            when(orgService.findOrganisationById(org.getId())).thenReturn(org);
            when(oplRepo.findByOrganisationAndPerson(org, p)).thenReturn(Collections.emptyList());
            ResponseEntity<Collection<RolleDTO>> resp = roleService.findAllForUser(vereinsId, p);
            assertEquals(200, resp.getStatusCode().value());
            assertNotNull(resp.getBody());
            assertTrue(resp.getBody().isEmpty());
        }

        @Test
        void whenLinksPresent_thenReturnMappedRoles() {
            Organisation org = new Organisation(); org.setId(UUID.randomUUID());
            String vereinsId = org.getId().toString();
            Person p = new Person(); p.setId(UUID.randomUUID());
            OrganisationPersonLink opl = new OrganisationPersonLink(org, p);
            Rolle role = new Rolle(); role.setId(UUID.randomUUID()); role.setName("USER"); role.setBeschreibung("desc"); role.setAktiv(true); role.setPublicAssignable(false);
            RollenLink rl = new RollenLink(); rl.setId(UUID.randomUUID()); rl.setRolle(role); rl.setLink(opl); rl.setAktiv(true);
            // attach rolle link to opl
            opl.getRollenLink().add(rl);

            when(orgService.findOrganisationById(org.getId())).thenReturn(org);
            when(oplRepo.findByOrganisationAndPerson(org, p)).thenReturn(List.of(opl));

            ResponseEntity<Collection<RolleDTO>> resp = roleService.findAllForUser(vereinsId, p);
            assertEquals(200, resp.getStatusCode().value());
            Collection<RolleDTO> body = resp.getBody();
            assertNotNull(body);
            assertEquals(1, body.size());
            RolleDTO dto = body.iterator().next();
            assertEquals(rl.getId().toString(), dto.getId());
            assertEquals("USER", dto.getName());
            assertEquals("desc", dto.getBeschreibung());
            assertTrue(dto.isAktiv());
            assertFalse(dto.isPublicAssignable());
        }
    }

    @Nested
    class EdgeCaseAndValidationTests {
        @Test
        void findByName_withNull_shouldReturnNull() {
            when(rollenRep.findByName(null)).thenReturn(null);
            Rolle res = roleService.findByName(null);
            assertNull(res);
        }

        @Test
        void findByName_withEmptyString_shouldReturnNull() {
            when(rollenRep.findByName("")).thenReturn(null);
            Rolle res = roleService.findByName("");
            assertNull(res);
        }

        @Test
        void findAll_shouldThrowWhenRepoReturnsNull() {
            when(rollenRep.findAll()).thenReturn(null);
            assertThrows(NullPointerException.class, () -> roleService.findAll());
        }

        @Test
        void findAllForUser_withInvalidUuid_shouldThrowIllegalArgumentException() {
            // invalid UUID string should be rejected by UUID.fromString
            assertThrows(IllegalArgumentException.class, () -> roleService.findAllForUser("not-a-uuid", new Person()));
        }

        @Test
        void findAllForUser_withNullPerson_shouldReturnEmptyWhenNoLinks() {
            Organisation org = new Organisation(); org.setId(UUID.randomUUID());
            String vereinsId = org.getId().toString();
            when(orgService.findOrganisationById(org.getId())).thenReturn(org);
            when(oplRepo.findByOrganisationAndPerson(org, null)).thenReturn(Collections.emptyList());
            ResponseEntity<Collection<RolleDTO>> resp = roleService.findAllForUser(vereinsId, null);
            assertEquals(200, resp.getStatusCode().value());
            assertNotNull(resp.getBody());
            assertTrue(resp.getBody().isEmpty());
        }

        @Test
        void findAllForUser_whenOpRepoReturnsNull_shouldThrowNullPointerException() {
            Organisation org = new Organisation(); org.setId(UUID.randomUUID());
            String vereinsId = org.getId().toString();
            Person p = new Person(); p.setId(UUID.randomUUID());
            when(orgService.findOrganisationById(org.getId())).thenReturn(org);
            when(oplRepo.findByOrganisationAndPerson(org, p)).thenReturn(null);
            assertThrows(NullPointerException.class, () -> roleService.findAllForUser(vereinsId, p));
        }
    }
}
