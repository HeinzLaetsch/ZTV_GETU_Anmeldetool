package org.ztv.anmeldetool.service;

import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.Wertungsrichter;
import org.ztv.anmeldetool.repositories.WertungsrichterRepository;

import java.util.LinkedList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@Disabled
public class WertungsrichterServiceTest {

    @Mock
    WertungsrichterRepository wertungsrichterRepo;

    @Mock
    PersonService personSrv;

    @InjectMocks
    WertungsrichterService wertungsrichterService;

    @Nested
    class GetWertungsrichterByIdTests {
        @Test
        void whenExists_returnsEntity() {
            UUID id = UUID.randomUUID();
            Wertungsrichter wr = new Wertungsrichter();
            wr.setId(id);

            when(wertungsrichterRepo.findById(id)).thenReturn(Optional.of(wr));

            Wertungsrichter res = wertungsrichterService.findById(id);
            assertNotNull(res);
            assertEquals(id, res.getId());
        }

        @Test
        void whenNotFound_returnsNull() {
            UUID id = UUID.randomUUID();
            when(wertungsrichterRepo.findById(id)).thenReturn(Optional.empty());

            Wertungsrichter res = wertungsrichterService.findById(id);
            assertNull(res);
        }
    }

    @Nested
    class GetWertungsrichterByPersonIdTests {
        @Test
        void whenRepoReturnsList_thenReturnFirstWrapped() {
            UUID pid = UUID.randomUUID();
            Wertungsrichter first = new Wertungsrichter();
            first.setId(UUID.randomUUID());
            Optional<Wertungsrichter> list = Optional.of(first);

            when(wertungsrichterRepo.findByPersonId(pid)).thenReturn(list);

            Wertungsrichter opt = wertungsrichterService.findById(pid);
            assertEquals(first, opt);
        }
    }
}

