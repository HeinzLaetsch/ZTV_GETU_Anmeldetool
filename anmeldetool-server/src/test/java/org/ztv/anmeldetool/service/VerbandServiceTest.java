package org.ztv.anmeldetool.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.jupiter.MockitoExtension;
import org.ztv.anmeldetool.models.Verband;
import org.ztv.anmeldetool.repositories.VerbandsRepository;
import org.ztv.anmeldetool.transfer.VerbandDTO;
import org.springframework.http.ResponseEntity;

import java.util.*;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class VerbandServiceTest {

    @Mock
    VerbandsRepository verbandRepo;

    @InjectMocks
    VerbandService verbandService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Nested
    class GetVerbandByIdTests {
        @Test
        void whenExists_returnsEntity() {
            UUID id = UUID.randomUUID();
            Verband v = new Verband();
            v.setId(id);
            v.setVerband("ABK");
            v.setVerbandLong("Full name");

            when(verbandRepo.findById(id)).thenReturn(Optional.of(v));

            Verband res = verbandService.getVerband(id);
            assertNotNull(res);
            assertEquals(id, res.getId());
            assertEquals("ABK", res.getVerband());
        }

        @Test
        void whenNotFound_returnsNull() {
            UUID id = UUID.randomUUID();
            when(verbandRepo.findById(id)).thenReturn(Optional.empty());

            Verband res = verbandService.getVerband(id);
            assertNull(res);
        }
    }

    @Nested
    class FindByVerbandsKuerzelTests {
        @Test
        void whenExists_returnsEntity() {
            Verband v = new Verband();
            v.setId(UUID.randomUUID());
            v.setVerband("ABC");

            when(verbandRepo.findByVerband("ABC")).thenReturn(Optional.of(v));

            Verband res = verbandService.findByVerbandsKuerzel("ABC");
            assertNotNull(res);
            assertEquals("ABC", res.getVerband());
        }

        @Test
        void whenNotFound_throwsNoSuchElement() {
            when(verbandRepo.findByVerband("X")).thenReturn(Optional.empty());
            assertThrows(NoSuchElementException.class, () -> verbandService.findByVerbandsKuerzel("X"));
        }
    }

    @Nested
    class FindByVerbandTests {
        @Test
        void whenExists_returnsDTOResponse() {
            Verband v = new Verband();
            v.setId(UUID.randomUUID());
            v.setVerband("K");
            v.setVerbandLong("Long K");

            when(verbandRepo.findByVerband("K")).thenReturn(Optional.of(v));

            ResponseEntity<VerbandDTO> resp = verbandService.findByVerband("K");
            assertNotNull(resp);
            assertTrue(resp.getStatusCode().is2xxSuccessful());

            VerbandDTO dto = resp.getBody();
            assertNotNull(dto);
            assertEquals(v.getId(), dto.getId());
            assertEquals("K", dto.getVerband());
            assertEquals("Long K", dto.getVerband_long());
        }

        @Test
        void whenNotFound_throwsNoSuchElement() {
            when(verbandRepo.findByVerband("ZZ")).thenReturn(Optional.empty());
            assertThrows(NoSuchElementException.class, () -> verbandService.findByVerband("ZZ"));
        }
    }

    @Nested
    class GetVerbaendeTests {
        @Test
        void whenSomeExist_returnsDtoCollection() {
            Verband v1 = new Verband();
            v1.setId(UUID.randomUUID());
            v1.setVerband("A");
            v1.setVerbandLong("Long A");
            v1.setAktiv(true);

            Verband v2 = new Verband();
            v2.setId(UUID.randomUUID());
            v2.setVerband("B");
            v2.setVerbandLong("Long B");
            v2.setAktiv(true);

            when(verbandRepo.findAllByAktivOrderByVerband(true)).thenReturn(List.of(v1, v2));

            ResponseEntity<Collection<VerbandDTO>> resp = verbandService.getVerbaende();
            assertNotNull(resp);
            assertTrue(resp.getStatusCode().is2xxSuccessful());

            Collection<VerbandDTO> col = resp.getBody();
            assertNotNull(col);
            assertEquals(2, col.size());

            List<String> names = col.stream().map(VerbandDTO::getVerband).collect(Collectors.toList());
            assertTrue(names.contains("A"));
            assertTrue(names.contains("B"));
        }

        @Test
        void whenNoneExist_returnsEmptyCollection() {
            when(verbandRepo.findAllByAktivOrderByVerband(true)).thenReturn(List.of());

            ResponseEntity<Collection<VerbandDTO>> resp = verbandService.getVerbaende();
            assertNotNull(resp);

            Collection<VerbandDTO> col = resp.getBody();
            assertNotNull(col);
            assertTrue(col.isEmpty());
        }
    }
}

