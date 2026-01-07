package org.ztv.anmeldetool.controller;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.net.URI;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import org.springframework.web.util.UriComponents;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.service.TeilnahmenService;
import org.ztv.anmeldetool.transfer.OrganisationTeilnahmenStatistikDTO;
import org.ztv.anmeldetool.transfer.TeilnahmenDTO;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;

@ExtendWith(MockitoExtension.class)
@Disabled
public class TeilnahmenControllerTest {

    @InjectMocks
    TeilnahmenController controller;

    @Mock
    TeilnahmenService teilnahmenSrv;

    @Nested
    class GetOrganisationTeilnahmenStatistikTests {
        @Test
        void positive_returnsCollection() {
            UUID orgId = UUID.randomUUID();
            int jahr = 2025;
            Organisation org = mock(Organisation.class);
            when(org.getId()).thenReturn(orgId);

            OrganisationTeilnahmenStatistikDTO dto = mock(OrganisationTeilnahmenStatistikDTO.class);
            when(teilnahmenSrv.getAnlassorganisationStati(jahr, org)).thenReturn(List.of(dto));

            ResponseEntity<Collection<OrganisationTeilnahmenStatistikDTO>> resp = controller.getOrganisationTeilnahmenStatistik(jahr, orgId);

            assertEquals(200, resp.getStatusCode().value());
            assertNotNull(resp.getBody());
            assertEquals(1, resp.getBody().size());
        }

        @Test
        void negative_returns404_whenServiceReturnsNull() {
            UUID orgId = UUID.randomUUID();
            int jahr = 2025;
            Organisation org = mock(Organisation.class);
            when(org.getId()).thenReturn(orgId);
            when(teilnahmenSrv.getAnlassorganisationStati(jahr, org)).thenReturn(null);

            try (MockedStatic<ServletUriComponentsBuilder> ms = Mockito.mockStatic(ServletUriComponentsBuilder.class)) {
                ServletUriComponentsBuilder builderMock = mock(ServletUriComponentsBuilder.class);
                UriComponents uriComp = mock(UriComponents.class);
                when(uriComp.toUri()).thenReturn(URI.create("http://localhost/test"));
                when(builderMock.build()).thenReturn(uriComp);
                ms.when(ServletUriComponentsBuilder::fromCurrentRequest).thenReturn(builderMock);

                ResponseEntity<Collection<OrganisationTeilnahmenStatistikDTO>> resp = controller.getOrganisationTeilnahmenStatistik(jahr, orgId);
                assertEquals(404, resp.getStatusCode().value());
            }
        }
    }

    @Nested
    class UpdateTeilnahmenTests {
        @Test
        void positive_updatesAndReturnsDto() throws NotFoundException {
            UUID orgId = UUID.randomUUID();
            Organisation org = mock(Organisation.class);
            when(org.getId()).thenReturn(orgId);
            int jahr = 2025;
            UUID teilnehmerId = UUID.randomUUID();
            TeilnahmenDTO dto = mock(TeilnahmenDTO.class);
            doReturn(dto).when(teilnahmenSrv).updateTeilnahmen(jahr, org, eq(dto));

            ResponseEntity<TeilnahmenDTO> resp = assertDoesNotThrow(() -> controller.updateTeilnahmen(jahr, orgId, teilnehmerId, dto));
            assertEquals(200, resp.getStatusCode().value());
            assertSame(dto, resp.getBody());
        }

        @Test
        void negative_serviceThrows_propagatesEntityNotFound() throws NotFoundException {
            UUID orgId = UUID.randomUUID();
            int jahr = 2025;
            Organisation org = mock(Organisation.class);
            when(org.getId()).thenReturn(orgId);
            UUID teilnehmerId = UUID.randomUUID();
            TeilnahmenDTO dto = mock(TeilnahmenDTO.class);
            doThrow(new NotFoundException(Object.class, UUID.randomUUID())).when(teilnahmenSrv).updateTeilnahmen(jahr, org, eq(dto));

            assertThrows(NotFoundException.class, () -> controller.updateTeilnahmen(jahr, orgId, teilnehmerId, dto));
        }
    }

    @Nested
    class GetTeilnahmenTests {
        @Test
        void positive_returnsList() {
            UUID orgId = UUID.randomUUID();
            int jahr = 2025;
            Organisation org = mock(Organisation.class);
            when(org.getId()).thenReturn(orgId);
            TeilnahmenDTO dto = mock(TeilnahmenDTO.class);
            when(teilnahmenSrv.getTeilnahmen(jahr, org, true)).thenReturn(List.of(dto));

            ResponseEntity<List<TeilnahmenDTO>> resp = controller.getTeilnahmen(jahr, orgId);
            assertEquals(200, resp.getStatusCode().value());
            assertNotNull(resp.getBody());
            assertEquals(1, resp.getBody().size());
        }

        @Test
        void negative_returns404_whenServiceReturnsNull() {
            UUID orgId = UUID.randomUUID();
            int jahr = 2025;
            Organisation org = mock(Organisation.class);
            when(org.getId()).thenReturn(orgId);
            when(teilnahmenSrv.getTeilnahmen(jahr, org, true)).thenReturn(null);

            try (MockedStatic<ServletUriComponentsBuilder> ms = Mockito.mockStatic(ServletUriComponentsBuilder.class)) {
                ServletUriComponentsBuilder builderMock = mock(ServletUriComponentsBuilder.class);
                UriComponents uriComp = mock(UriComponents.class);
                when(uriComp.toUri()).thenReturn(URI.create("http://localhost/test"));
                when(builderMock.build()).thenReturn(uriComp);
                ms.when(ServletUriComponentsBuilder::fromCurrentRequest).thenReturn(builderMock);

                ResponseEntity<List<TeilnahmenDTO>> resp = controller.getTeilnahmen(jahr, orgId);
                assertEquals(404, resp.getStatusCode().value());
            }
        }
    }
}

