package org.ztv.anmeldetool.controller;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.net.URI;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

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
import org.ztv.anmeldetool.service.TeilnahmenService;
import org.ztv.anmeldetool.transfer.OrganisationTeilnahmenStatistikDTO;
import org.ztv.anmeldetool.transfer.TeilnahmenDTO;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;

@ExtendWith(MockitoExtension.class)
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
            OrganisationTeilnahmenStatistikDTO dto = mock(OrganisationTeilnahmenStatistikDTO.class);
            when(teilnahmenSrv.getAnlassorganisationStati(jahr, orgId)).thenReturn(List.of(dto));

            ResponseEntity<Collection<OrganisationTeilnahmenStatistikDTO>> resp = controller.getOrganisationTeilnahmenStatistik(mock(HttpServletRequest.class), jahr, orgId);

            assertEquals(200, resp.getStatusCode().value());
            assertNotNull(resp.getBody());
            assertEquals(1, resp.getBody().size());
        }

        @Test
        void negative_returns404_whenServiceReturnsNull() {
            UUID orgId = UUID.randomUUID();
            int jahr = 2025;
            when(teilnahmenSrv.getAnlassorganisationStati(jahr, orgId)).thenReturn(null);

            try (MockedStatic<ServletUriComponentsBuilder> ms = Mockito.mockStatic(ServletUriComponentsBuilder.class)) {
                ServletUriComponentsBuilder builderMock = mock(ServletUriComponentsBuilder.class);
                UriComponents uriComp = mock(UriComponents.class);
                when(uriComp.toUri()).thenReturn(URI.create("http://localhost/test"));
                when(builderMock.build()).thenReturn(uriComp);
                ms.when(ServletUriComponentsBuilder::fromCurrentRequest).thenReturn(builderMock);

                ResponseEntity<Collection<OrganisationTeilnahmenStatistikDTO>> resp = controller.getOrganisationTeilnahmenStatistik(mock(HttpServletRequest.class), jahr, orgId);
                assertEquals(404, resp.getStatusCode().value());
            }
        }
    }

    @Nested
    class UpdateTeilnahmenTests {
        @Test
        void positive_updatesAndReturnsDto() throws NotFoundException {
            UUID orgId = UUID.randomUUID();
            int jahr = 2025;
            UUID teilnehmerId = UUID.randomUUID();
            TeilnahmenDTO dto = mock(TeilnahmenDTO.class);
            doReturn(dto).when(teilnahmenSrv).updateTeilnahmen(eq(jahr), eq(orgId), eq(dto));

            ResponseEntity<TeilnahmenDTO> resp = assertDoesNotThrow(() -> controller.updateTeilnahmen(mock(HttpServletRequest.class), jahr, orgId, teilnehmerId, dto));
            assertEquals(200, resp.getStatusCode().value());
            assertSame(dto, resp.getBody());
        }

        @Test
        void negative_serviceThrows_propagatesEntityNotFound() throws NotFoundException {
            UUID orgId = UUID.randomUUID();
            int jahr = 2025;
            UUID teilnehmerId = UUID.randomUUID();
            TeilnahmenDTO dto = mock(TeilnahmenDTO.class);
            doThrow(new NotFoundException(Object.class, UUID.randomUUID())).when(teilnahmenSrv).updateTeilnahmen(eq(jahr), eq(orgId), eq(dto));

            assertThrows(NotFoundException.class, () -> controller.updateTeilnahmen(mock(HttpServletRequest.class), jahr, orgId, teilnehmerId, dto));
        }
    }

    @Nested
    class GetTeilnahmenTests {
        @Test
        void positive_returnsList() {
            UUID orgId = UUID.randomUUID();
            int jahr = 2025;
            TeilnahmenDTO dto = mock(TeilnahmenDTO.class);
            when(teilnahmenSrv.getTeilnahmen(jahr, orgId, true)).thenReturn(List.of(dto));

            ResponseEntity<List<TeilnahmenDTO>> resp = controller.getTeilnahmen(mock(HttpServletRequest.class), jahr, orgId);
            assertEquals(200, resp.getStatusCode().value());
            assertNotNull(resp.getBody());
            assertEquals(1, resp.getBody().size());
        }

        @Test
        void negative_returns404_whenServiceReturnsNull() {
            UUID orgId = UUID.randomUUID();
            int jahr = 2025;
            when(teilnahmenSrv.getTeilnahmen(jahr, orgId, true)).thenReturn(null);

            try (MockedStatic<ServletUriComponentsBuilder> ms = Mockito.mockStatic(ServletUriComponentsBuilder.class)) {
                ServletUriComponentsBuilder builderMock = mock(ServletUriComponentsBuilder.class);
                UriComponents uriComp = mock(UriComponents.class);
                when(uriComp.toUri()).thenReturn(URI.create("http://localhost/test"));
                when(builderMock.build()).thenReturn(uriComp);
                ms.when(ServletUriComponentsBuilder::fromCurrentRequest).thenReturn(builderMock);

                ResponseEntity<List<TeilnahmenDTO>> resp = controller.getTeilnahmen(mock(HttpServletRequest.class), jahr, orgId);
                assertEquals(404, resp.getStatusCode().value());
            }
        }
    }

    @Nested
    class ExceptionHandlerTests {
        @Test
        void entityNotFoundHandler_returns404_andMessage() {
            NotFoundException ex = new NotFoundException(Object.class, UUID.randomUUID());
            ResponseEntity<?> resp = controller.handlerEntityNotFound(ex);
            assertEquals(HttpStatus.NOT_FOUND, resp.getStatusCode());
            assertEquals(ex.getMessage(), resp.getBody());
        }

        @Test
        void genericExceptionHandler_returns400_andMessage() {
            Exception ex = new RuntimeException("bad");
            ResponseEntity<?> resp = controller.handlerException(ex);
            assertEquals(HttpStatus.BAD_REQUEST, resp.getStatusCode());
            assertEquals(ex.getMessage(), resp.getBody());
        }
    }

}

