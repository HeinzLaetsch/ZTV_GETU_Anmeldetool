package org.ztv.anmeldetool.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.ztv.anmeldetool.models.WertungsrichterEinsatz;
import org.ztv.anmeldetool.repositories.WertungsrichterEinsatzRepository;

import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class WertungsrichterEinsatzServiceTest {

    @Mock
    WertungsrichterEinsatzRepository repository;

    @InjectMocks
    WertungsrichterEinsatzService service;

    @BeforeEach
    void setUp() {
    }

    @Nested
    class GetWertungsrichterEinsatzTests {
        @Test
        void whenPresent_returnsEntity() {
            UUID id = UUID.randomUUID();
            WertungsrichterEinsatz e = new WertungsrichterEinsatz();
            e.setId(id);
            e.setEingesetzt(false);

            when(repository.findById(id)).thenReturn(Optional.of(e));

            WertungsrichterEinsatz res = service.getWertungsrichterEinsatz(id);
            assertNotNull(res);
            assertEquals(id, res.getId());
            assertFalse(res.isEingesetzt());
        }

        @Test
        void whenAbsent_returnsNull() {
            UUID id = UUID.randomUUID();
            when(repository.findById(id)).thenReturn(Optional.empty());

            WertungsrichterEinsatz res = service.getWertungsrichterEinsatz(id);
            assertNull(res);
        }
    }

    @Nested
    class UpdateTests {
        @Test
        void whenExistingEntity_thenUpdateEingesetztAndSave() {
            UUID id = UUID.randomUUID();
            WertungsrichterEinsatz input = new WertungsrichterEinsatz();
            input.setId(id);
            input.setEingesetzt(true);

            WertungsrichterEinsatz existing = new WertungsrichterEinsatz();
            existing.setId(id);
            existing.setEingesetzt(false);

            when(repository.findById(id)).thenReturn(Optional.of(existing));
            when(repository.save(existing)).thenAnswer(inv -> inv.getArgument(0));

            WertungsrichterEinsatz res = service.update(input);

            assertNotNull(res);
            assertTrue(res.isEingesetzt());
            verify(repository).findById(id);
            verify(repository).save(existing);
        }

        @Test
        void whenIdNotFound_thenSaveInput() {
            UUID id = UUID.randomUUID();
            WertungsrichterEinsatz input = new WertungsrichterEinsatz();
            input.setId(id);
            input.setEingesetzt(true);

            when(repository.findById(id)).thenReturn(Optional.empty());
            when(repository.save(input)).thenReturn(input);

            WertungsrichterEinsatz res = service.update(input);

            assertNotNull(res);
            assertSame(input, res);
            verify(repository).findById(id);
            verify(repository).save(input);
        }

        @Test
        void whenIdIsNull_thenSaveNewEntity() {
            WertungsrichterEinsatz input = new WertungsrichterEinsatz();
            input.setId(null);
            input.setEingesetzt(false);

            when(repository.save(input)).thenReturn(input);

            WertungsrichterEinsatz res = service.update(input);

            assertNotNull(res);
            assertSame(input, res);
            verify(repository, never()).findById(any());
            verify(repository).save(input);
        }

        @Test
        void whenInputIsNull_thenSaveNullAndReturnNull() {
            when(repository.save(null)).thenReturn(null);

            WertungsrichterEinsatz res = service.update(null);

            assertNull(res);
            verify(repository).save(null);
        }
    }
}
