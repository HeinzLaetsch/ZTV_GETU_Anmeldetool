package org.ztv.anmeldetool.service;

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

            Wertungsrichter res = wertungsrichterService.getWertungsrichter(id);
            assertNotNull(res);
            assertEquals(id, res.getId());
        }

        @Test
        void whenNotFound_returnsNull() {
            UUID id = UUID.randomUUID();
            when(wertungsrichterRepo.findById(id)).thenReturn(Optional.empty());

            Wertungsrichter res = wertungsrichterService.getWertungsrichter(id);
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
            LinkedList<Wertungsrichter> list = new LinkedList<>(List.of(first));

            when(wertungsrichterRepo.findByPersonId(pid)).thenReturn(list);

            Optional<Wertungsrichter> opt = wertungsrichterService.getWertungsrichterByPersonId(pid);
            assertTrue(opt.isPresent());
            assertEquals(first, opt.get());
        }

        @Test
        void whenRepoReturnsEmptyList_thenReturnEmptyOptional() {
            UUID pid = UUID.randomUUID();
            when(wertungsrichterRepo.findByPersonId(pid)).thenReturn(new LinkedList<>());

            Optional<Wertungsrichter> opt = wertungsrichterService.getWertungsrichterByPersonId(pid);
            assertTrue(opt.isEmpty());
        }

        @Test
        void whenRepoReturnsNull_thenReturnEmptyOptional() {
            UUID pid = UUID.randomUUID();
            when(wertungsrichterRepo.findByPersonId(pid)).thenReturn(null);

            Optional<Wertungsrichter> opt = wertungsrichterService.getWertungsrichterByPersonId(pid);
            assertTrue(opt.isEmpty());
        }
    }

    @Nested
    class GetWertungsrichterForUserTests {
        @Test
        void whenUserHasWertungsrichter_returnsOptional() {
            UUID pid = UUID.randomUUID();
            Person p = new Person();
            p.setId(pid);

            Wertungsrichter wr = new Wertungsrichter();
            wr.setId(UUID.randomUUID());
            LinkedList<Wertungsrichter> list = new LinkedList<>(List.of(wr));

            when(wertungsrichterRepo.findByPersonId(pid)).thenReturn(list);

            Optional<Wertungsrichter> opt = wertungsrichterService.getWertungsrichterForUser(p);
            assertTrue(opt.isPresent());
            assertEquals(wr, opt.get());
        }

        @Test
        void whenUserHasNoWertungsrichter_returnsEmptyOptional() {
            UUID pid = UUID.randomUUID();
            Person p = new Person();
            p.setId(pid);

            when(wertungsrichterRepo.findByPersonId(pid)).thenReturn(new LinkedList<>());

            Optional<Wertungsrichter> opt = wertungsrichterService.getWertungsrichterForUser(p);
            assertTrue(opt.isEmpty());
        }
    }

    @Nested
    class UpdateTests {
        @Test
        void whenSaveReturnsPersisted_thenPersonIsUpdatedAndPersonServiceCalled() {
            UUID id = UUID.randomUUID();
            Wertungsrichter input = new Wertungsrichter();
            input.setId(id);
            Person person = new Person();
            person.setId(UUID.randomUUID());
            input.setPerson(person);

            Wertungsrichter saved = new Wertungsrichter();
            saved.setId(id);
            saved.setPerson(person);

            when(wertungsrichterRepo.save(input)).thenReturn(saved);

            Wertungsrichter res = wertungsrichterService.update(input);

            assertNotNull(res);
            assertEquals(saved, res);
            // after save, person's wertungsrichter should be set
            assertEquals(saved, person.getWertungsrichter());
            verify(personSrv).create(person, false);
        }

        @Test
        void whenSaveReturnsNull_thenThrowsNPE() {
            Wertungsrichter input = new Wertungsrichter();
            input.setId(UUID.randomUUID());
            Person person = new Person();
            person.setId(UUID.randomUUID());
            input.setPerson(person);

            when(wertungsrichterRepo.save(input)).thenReturn(null);

            assertThrows(NullPointerException.class, () -> wertungsrichterService.update(input));
            // ensure personSrv not called because NPE occurs before
            verify(personSrv, never()).create(any(), anyBoolean());
        }

        @Test
        void whenPersonIsNull_thenThrowsNPE() {
            Wertungsrichter input = new Wertungsrichter();
            input.setId(UUID.randomUUID());
            input.setPerson(null);

            when(wertungsrichterRepo.save(input)).thenReturn(input);

            assertThrows(NullPointerException.class, () -> wertungsrichterService.update(input));
            verify(personSrv, never()).create(any(), anyBoolean());
        }
    }

    @Nested
    class DeleteTests {
        @Test
        void whenPersonPresent_clearsAndDeletes() {
            Wertungsrichter wr = new Wertungsrichter();
            wr.setId(UUID.randomUUID());
            Person p = new Person();
            p.setId(UUID.randomUUID());
            wr.setPerson(p);

            doNothing().when(wertungsrichterRepo).delete(wr);

            wertungsrichterService.delete(wr);

            assertNull(p.getWertungsrichter());
            verify(personSrv).create(p, false);
            verify(wertungsrichterRepo).delete(wr);
        }

        @Test
        void whenPersonNull_throwsNPE() {
            Wertungsrichter wr = new Wertungsrichter();
            wr.setId(UUID.randomUUID());
            wr.setPerson(null);

            assertThrows(NullPointerException.class, () -> wertungsrichterService.delete(wr));
            verify(personSrv, never()).create(any(), anyBoolean());
            verify(wertungsrichterRepo, never()).delete(any());
        }
    }
}

