package org.ztv.anmeldetool.service;

import org.junit.jupiter.api.Disabled;
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
@Disabled
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
            when(rollenRep.findByName("ADMIN")).thenReturn(Optional.of(r));
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
    }
}
