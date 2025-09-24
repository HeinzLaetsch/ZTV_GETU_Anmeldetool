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
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.Verband;
import org.ztv.anmeldetool.repositories.OrganisationsRepository;
import org.ztv.anmeldetool.transfer.OrganisationDTO;

import java.util.*;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class OrganisationServiceTest {

    @Mock
    OrganisationsRepository orgRepo;

    @Mock
    VerbandService verbandSrv;

    @InjectMocks
    OrganisationService organisationService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Nested
    class GetAllOrganisationsTests {
        @Test
        void whenThereAreOrganisations_thenReturnDtos() {
            Verband v = new Verband();
            v.setId(UUID.randomUUID());
            Organisation o1 = new Organisation();
            o1.setId(UUID.randomUUID());
            o1.setName("A Club");
            o1.setVerband(v);
            Organisation o2 = new Organisation();
            o2.setId(UUID.randomUUID());
            o2.setName("B Club");
            o2.setVerband(v);

            Iterable<Organisation> iterable = Arrays.asList(o1, o2);
            when(orgRepo.findByAktivOrderByName(true)).thenReturn(iterable);

            ResponseEntity<Collection<org.ztv.anmeldetool.transfer.OrganisationDTO>> resp = organisationService.getAllOrganisations();
            assertNotNull(resp);
            assertEquals(200, resp.getStatusCode().value());
            Collection<org.ztv.anmeldetool.transfer.OrganisationDTO> dtos = resp.getBody();
            assertNotNull(dtos);
            List<String> names = dtos.stream().map(org -> org.getName()).collect(Collectors.toList());
            assertTrue(names.containsAll(Arrays.asList("A Club", "B Club")));
        }

        @Test
        void whenNoOrganisations_thenReturnEmptyCollection() {
            when(orgRepo.findByAktivOrderByName(true)).thenReturn(Collections.emptyList());
            ResponseEntity<Collection<org.ztv.anmeldetool.transfer.OrganisationDTO>> resp = organisationService.getAllOrganisations();
            assertNotNull(resp);
            assertEquals(200, resp.getStatusCode().value());
            assertNotNull(resp.getBody());
            assertTrue(resp.getBody().isEmpty());
        }
    }

    @Nested
    class GetAllZuercherOrganisationenTests {
        @Test
        void whenVerbandsPresent_thenReturnOrganisations() {
            Verband glz = new Verband(); glz.setId(UUID.randomUUID());
            Verband wtu = new Verband(); wtu.setId(UUID.randomUUID());
            Verband azo = new Verband(); azo.setId(UUID.randomUUID());
            Verband ztv = new Verband(); ztv.setId(UUID.randomUUID());
            when(verbandSrv.findByVerbandsKuerzel("GLZ")).thenReturn(glz);
            when(verbandSrv.findByVerbandsKuerzel("WTU")).thenReturn(wtu);
            when(verbandSrv.findByVerbandsKuerzel("AZO")).thenReturn(azo);
            when(verbandSrv.findByVerbandsKuerzel("ZTV")).thenReturn(ztv);

            Organisation o1 = new Organisation();
            o1.setId(UUID.randomUUID());
            o1.setName("ZH Club");
            o1.setVerband(ztv);
            List<Organisation> orgs = List.of(o1);
            when(orgRepo.findZuercherOrganisationen(Arrays.asList(glz, wtu, azo, ztv))).thenReturn(orgs);

            List<Organisation> result = organisationService.getAllZuercherOrganisationen();
            assertNotNull(result);
            assertEquals(1, result.size());
            assertEquals("ZH Club", result.get(0).getName());
        }

        @Test
        void whenRepoReturnsEmpty_thenReturnEmptyList() {
            when(verbandSrv.findByVerbandsKuerzel(anyString())).thenReturn(null);
            when(orgRepo.findZuercherOrganisationen(any())).thenReturn(Collections.emptyList());
            List<Organisation> result = organisationService.getAllZuercherOrganisationen();
            assertNotNull(result);
            assertTrue(result.isEmpty());
        }
    }

    @Nested
    class FindOrganisationByNameTests {
        @Test
        void whenFound_thenReturnOrganisation() {
            Organisation o = new Organisation();
            o.setId(UUID.randomUUID());
            o.setName("SearchClub");
            when(orgRepo.findByName("SearchClub")).thenReturn(o);
            Organisation result = organisationService.findOrganisationByName("SearchClub");
            assertNotNull(result);
            assertEquals("SearchClub", result.getName());
        }

        @Test
        void whenNotFound_thenReturnNull() {
            when(orgRepo.findByName("NoClub")).thenReturn(null);
            Organisation result = organisationService.findOrganisationByName("NoClub");
            assertNull(result);
        }
    }

    @Nested
    class FindOrganisationByIdTests {
        @Test
        void whenPresent_thenReturnOrganisation() {
            UUID id = UUID.randomUUID();
            Organisation o = new Organisation();
            o.setId(id);
            when(orgRepo.findById(id)).thenReturn(Optional.of(o));
            Organisation result = organisationService.findOrganisationById(id);
            assertNotNull(result);
            assertEquals(id, result.getId());
        }

        @Test
        void whenNotPresent_thenThrow() {
            UUID id = UUID.randomUUID();
            when(orgRepo.findById(id)).thenReturn(Optional.empty());
            assertThrows(NoSuchElementException.class, () -> organisationService.findOrganisationById(id));
        }
    }

    @Nested
    class CreateTests {
        @Test
        void whenVerbandExists_thenSaveAndReturnDto() {
            UUID verbandId = UUID.randomUUID();
            OrganisationDTO dto = OrganisationDTO.builder().name("NewClub").verbandId(verbandId).build();
            Verband v = new Verband(); v.setId(verbandId);
            when(verbandSrv.getVerband(verbandId)).thenReturn(v);

            Organisation saved = new Organisation();
            saved.setId(UUID.randomUUID());
            saved.setName("NewClub");
            saved.setVerband(v);
            when(orgRepo.save(any(Organisation.class))).thenReturn(saved);

            ResponseEntity<org.ztv.anmeldetool.transfer.OrganisationDTO> resp = organisationService.create(dto);
            assertNotNull(resp);
            assertEquals(200, resp.getStatusCode().value());
            org.ztv.anmeldetool.transfer.OrganisationDTO body = resp.getBody();
            assertNotNull(body);
            assertEquals(saved.getName(), body.getName());
            assertEquals(v.getId(), body.getVerbandId());
        }

        @Test
        void whenSaveThrows_thenPropagateException() {
            UUID verbandId = UUID.randomUUID();
            OrganisationDTO dto = OrganisationDTO.builder().name("X").verbandId(verbandId).build();
            Verband v = new Verband(); v.setId(verbandId);
            when(verbandSrv.getVerband(verbandId)).thenReturn(v);
            when(orgRepo.save(any())).thenThrow(new RuntimeException("db error"));
            assertThrows(RuntimeException.class, () -> organisationService.create(dto));
        }
    }
}

