package org.ztv.anmeldetool.controller;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import java.net.URI;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import org.springframework.web.util.UriComponents;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.Wertungsrichter;
import org.ztv.anmeldetool.models.LoginData;
import org.ztv.anmeldetool.transfer.OrganisationAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.OrganisationDTO;
import org.ztv.anmeldetool.transfer.PersonDTO;
import org.ztv.anmeldetool.transfer.RolleDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerDTO;
import org.ztv.anmeldetool.transfer.VerbandDTO;
import org.ztv.anmeldetool.transfer.WertungsrichterDTO;
import org.ztv.anmeldetool.util.OrganisationAnlassLinkHelper;
import org.ztv.anmeldetool.util.PersonHelper;

import jakarta.servlet.http.HttpServletRequest;

@ExtendWith(MockitoExtension.class)
public class AdminControllerTest {

    @InjectMocks
    private AdminController controller;

    @Mock
    private org.ztv.anmeldetool.service.LoginService loginSrv;

    @Mock
    private org.ztv.anmeldetool.service.PersonService personSrv;

    @Mock
    private org.ztv.anmeldetool.service.RoleService roleSrv;

    @Mock
    private org.ztv.anmeldetool.service.OrganisationService organisationSrv;

    @Mock
    private org.ztv.anmeldetool.service.VerbandService verbandsSrv;

    @Mock
    private org.ztv.anmeldetool.service.WertungsrichterService wertungsrichterSrv;

    @Mock
    private org.ztv.anmeldetool.service.AnlassService anlassSrv;

    @Mock
    private org.ztv.anmeldetool.service.TeilnehmerService teilnehmerSrv;

    @Mock
    private org.ztv.anmeldetool.service.TeilnehmerAnlassLinkService teilnehmerAnlassLinkSrv;

    @Mock
    private org.ztv.anmeldetool.service.WertungsrichterEinsatzService wertungsrichterEinsatzSrv;

    @Mock
    private org.ztv.anmeldetool.util.WertungsrichterMapper wrMapper;

    @Mock
    private org.ztv.anmeldetool.util.PersonMapper personMapper;

    @Mock
    private org.ztv.anmeldetool.util.OrganisationAnlassLinkMapper oalMapper;

    @Mock
    private org.ztv.anmeldetool.util.OrganisationMapper organisationMapper;

    @Mock
    private org.ztv.anmeldetool.util.WertungsrichterEinsatzMapper wertungsrichterEinsatzMapper;

    @Mock
    private org.ztv.anmeldetool.util.TeilnehmerAnlassLinkMapper teilnehmerAnlassMapper;

    @Mock
    private org.ztv.anmeldetool.util.PersonAnlassLinkExportImportMapper palExImMapper;

    @Mock
    private org.ztv.anmeldetool.util.TeilnehmerAnlassLinkExportImportMapper talExImMapper;

    @Mock
    private org.ztv.anmeldetool.repositories.PersonAnlassLinkRepository personAnlassLinkRepository;

    @Mock
    private org.springframework.security.crypto.password.PasswordEncoder passwordEncoder;

    // --------- simple service passthroughs ---------

    @Nested
    class LoginPostTests {
        @Test
        void positive_delegatesToLoginService() {
            HttpServletRequest req = mock(HttpServletRequest.class);
            org.ztv.anmeldetool.models.LoginData ld = new org.ztv.anmeldetool.models.LoginData();
            PersonDTO dto = mock(PersonDTO.class);
            ResponseEntity<PersonDTO> serviceResp = ResponseEntity.ok(dto);
            when(loginSrv.login(any(HttpServletRequest.class), any(LoginData.class))).thenReturn(serviceResp);

            ResponseEntity<PersonDTO> resp = controller.login(req, ld);
            assertSame(serviceResp, resp);
        }

        @Test
        void negative_serviceThrows_propagates() {
            HttpServletRequest req = mock(HttpServletRequest.class);
            org.ztv.anmeldetool.models.LoginData ld = new org.ztv.anmeldetool.models.LoginData();
            when(loginSrv.login(any(HttpServletRequest.class), any(LoginData.class))).thenThrow(new RuntimeException("boom"));
            assertThrows(RuntimeException.class, () -> controller.login(req, ld));
        }
    }

    @Nested
    class OrganisationenTests {
        @Test
        void getOrganisationen_delegates() {
            ResponseEntity<Collection<OrganisationDTO>> svcResp = ResponseEntity.ok(Collections.emptyList());
            when(organisationSrv.getAllOrganisations()).thenReturn(svcResp);
            ResponseEntity<?> resp = controller.getOrganisationen();
            assertSame(svcResp, resp);
        }

        @Test
        void postOrganisationen_delegates() {
            OrganisationDTO dto = mock(OrganisationDTO.class);
            ResponseEntity<OrganisationDTO> svcResp = ResponseEntity.ok(dto);
            when(organisationSrv.create(dto)).thenReturn(svcResp);
            ResponseEntity<OrganisationDTO> resp = controller.login(mock(HttpServletRequest.class), dto);
            assertSame(svcResp, resp);
        }
    }

    @Nested
    class TeilnehmerCrudTests {
        @Test
        void getTeilnehmer_delegates_withPageable() {
            UUID orgId = UUID.randomUUID();
            ResponseEntity<Collection<TeilnehmerDTO>> svcResp = ResponseEntity.ok(Collections.emptyList());
            when(teilnehmerSrv.findTeilnehmerDtoByOrganisation(eq(orgId), any(Pageable.class))).thenReturn(svcResp);
            ResponseEntity<Collection<TeilnehmerDTO>> resp = controller.getTeilnehmer(mock(HttpServletRequest.class), orgId, 1, 10);
            assertSame(svcResp, resp);
        }

        @Test
        void count_delegates() {
            UUID orgId = UUID.randomUUID();
            ResponseEntity<Integer> svcResp = ResponseEntity.ok(5);
            when(teilnehmerSrv.countTeilnehmerByOrganisation(orgId)).thenReturn(svcResp);
            ResponseEntity<Integer> resp = controller.countTeilnehmer(mock(HttpServletRequest.class), orgId);
            assertSame(svcResp, resp);
        }

        @Test
        void addNewTeilnehmer_delegates() {
            UUID orgId = UUID.randomUUID();
            TeilnehmerDTO dto = mock(TeilnehmerDTO.class);
            ResponseEntity<TeilnehmerDTO> svcResp = ResponseEntity.ok(dto);
            when(teilnehmerSrv.create(orgId, dto)).thenReturn(svcResp);
            ResponseEntity<TeilnehmerDTO> resp = controller.addNewTeilnehmer(mock(HttpServletRequest.class), orgId, dto);
            assertSame(svcResp, resp);
        }

        @Test
        void updateNewTeilnehmer_positive_returnsOk() throws NotFoundException {
            UUID orgId = UUID.randomUUID();
            TeilnehmerDTO dto = mock(TeilnehmerDTO.class);
            doReturn(dto).when(teilnehmerSrv).update(orgId, dto);
            ResponseEntity<TeilnehmerDTO> resp = assertDoesNotThrow(() -> controller.updateNewTeilnehmer(mock(HttpServletRequest.class), orgId, dto));
            assertEquals(200, resp.getStatusCode().value());
            assertEquals(dto, resp.getBody());
        }

        @Test
        void updateNewTeilnehmer_negative_throwsEntityNotFound() throws NotFoundException {
            UUID orgId = UUID.randomUUID();
            TeilnehmerDTO dto = mock(TeilnehmerDTO.class);
            doThrow(new NotFoundException(Object.class, UUID.randomUUID())).when(teilnehmerSrv).update(orgId, dto);
            assertThrows(NotFoundException.class, () -> controller.updateNewTeilnehmer(mock(HttpServletRequest.class), orgId, dto));
        }

        @Test
        void deleteTeilnehmer_delegates() {
            UUID orgId = UUID.randomUUID();
            UUID teilnehmerId = UUID.randomUUID();
            ResponseEntity<UUID> svcResp = ResponseEntity.ok(teilnehmerId);
            when(teilnehmerSrv.delete(orgId, teilnehmerId)).thenReturn(svcResp);
            ResponseEntity<UUID> resp = controller.deleteTeilnehmer(mock(HttpServletRequest.class), orgId, teilnehmerId);
            assertSame(svcResp, resp);
        }
    }

    @Nested
    class StartsAndVerbaendeTests {
        @Test
        void getStarts_usesHelperAndService() {
            // mock anlassSrv.getOrganisationAnlassLinks and OrganisationAnlassLinkHelper.toDTO
            List<org.ztv.anmeldetool.models.OrganisationAnlassLink> list = List.of();
            when(anlassSrv.getOrganisationAnlassLinks()).thenReturn(list);
            Collection<OrganisationAnlassLinkDTO> dtoColl = List.of(mock(OrganisationAnlassLinkDTO.class));
            try (MockedStatic<OrganisationAnlassLinkHelper> ms = Mockito.mockStatic(OrganisationAnlassLinkHelper.class)) {
                ms.when(() -> OrganisationAnlassLinkHelper.toDTO(oalMapper, list)).thenReturn(dtoColl);
                ResponseEntity<Collection<OrganisationAnlassLinkDTO>> resp = controller.getStarts(mock(HttpServletRequest.class));
                assertEquals(200, resp.getStatusCode().value());
                assertSame(dtoColl, resp.getBody());
            }
        }

        @Test
        void getVerbaende_delegates() {
            ResponseEntity<Collection<VerbandDTO>> svcResp = ResponseEntity.ok(Collections.emptyList());
            when(verbandsSrv.getVerbaende()).thenReturn(svcResp);
            ResponseEntity<Collection<VerbandDTO>> resp = controller.getVerbaende();
            assertSame(svcResp, resp);
        }
    }

    @Nested
    class LoginGetTests {
        @Test
        void loginGet_delegatesToLoginService() {
            HttpServletRequest req = mock(HttpServletRequest.class);
            String organisationsname = "org";
            String benutzername = "user";
            String passwort = "pw";
            PersonDTO dto = mock(PersonDTO.class);
            ResponseEntity<PersonDTO> svcResp = ResponseEntity.ok(dto);
            when(loginSrv.login(any(HttpServletRequest.class), any(LoginData.class))).thenReturn(svcResp);
            ResponseEntity<PersonDTO> resp = controller.loginGet(req, organisationsname, benutzername, passwort);
            assertSame(svcResp, resp);
        }
    }

    @Nested
    class UserPatchPostTests {
        @Test
        void patch_createsWhenIdNull() {
            PersonDTO dto = mock(PersonDTO.class);
            when(dto.getId()).thenReturn(null);
            ResponseEntity<PersonDTO> svcResp = ResponseEntity.ok(mock(PersonDTO.class));
            when(personSrv.create(dto, null)).thenReturn(svcResp);
            ResponseEntity<PersonDTO> resp = controller.patch(mock(HttpServletRequest.class), "u", UUID.randomUUID(), dto);
            assertSame(svcResp, resp);
        }

        @Test
        void patch_updatesWhenIdPresent() {
            PersonDTO dto = mock(PersonDTO.class);
            UUID id = UUID.randomUUID();
            when(dto.getId()).thenReturn(id);
            UUID vereinsId = UUID.randomUUID();
            ResponseEntity<PersonDTO> svcResp = ResponseEntity.ok(mock(PersonDTO.class));
            when(personSrv.update(dto, vereinsId)).thenReturn(svcResp);
            ResponseEntity<PersonDTO> resp = controller.patch(mock(HttpServletRequest.class), "u", vereinsId, dto);
            assertSame(svcResp, resp);
        }

        @Test
        void postUser_creates() {
            PersonDTO dto = mock(PersonDTO.class);
            UUID vereinsId = UUID.randomUUID();
            ResponseEntity<PersonDTO> svcResp = ResponseEntity.ok(mock(PersonDTO.class));
            when(personSrv.create(dto, vereinsId)).thenReturn(svcResp);
            ResponseEntity<PersonDTO> resp = controller.post(mock(HttpServletRequest.class), vereinsId, dto);
            assertSame(svcResp, resp);
        }

        @Test
        void postUserWithId_creates() {
            PersonDTO dto = mock(PersonDTO.class);
            UUID vereinsId = UUID.randomUUID();
            ResponseEntity<PersonDTO> svcResp = ResponseEntity.ok(mock(PersonDTO.class));
            when(personSrv.create(dto, vereinsId)).thenReturn(svcResp);
            ResponseEntity<PersonDTO> resp = controller.postUser(mock(HttpServletRequest.class), "u", vereinsId, "id", dto);
            assertSame(svcResp, resp);
        }

        @Test
        void postUserOrganisationRollen_delegates() {
            String userId = "u";
            String organisationsId = "o";
            Set<RolleDTO> rollen = Set.of();
            ResponseEntity<PersonDTO> svcResp = ResponseEntity.ok(mock(PersonDTO.class));
            when(personSrv.updateUserOrganisationRollen(userId, organisationsId, rollen)).thenReturn(svcResp);
            ResponseEntity<PersonDTO> resp = controller.postUserOrganisationRollen(mock(HttpServletRequest.class), userId, organisationsId, rollen);
            assertSame(svcResp, resp);
        }
    }

    @Nested
    class GetUsersAndLookupTests {
        @Test
        void get_returnsPersons() {
            UUID vereinsId = UUID.randomUUID();
            Collection<PersonDTO> list = List.of(mock(PersonDTO.class));
            when(personSrv.findPersonsByOrganisation(vereinsId)).thenReturn(list);
            ResponseEntity<Collection<PersonDTO>> resp = controller.get(mock(HttpServletRequest.class), "u", vereinsId);
            assertEquals(200, resp.getStatusCode().value());
            assertSame(list, resp.getBody());
        }

        @Test
        void getPersonByBenutzername_positive_returnsDto() {
            String benutzername = "u";
            Person person = new Person();
            person.setBenutzername(benutzername);
            when(personSrv.findPersonByBenutzername(benutzername)).thenReturn(person);
            PersonDTO expected = mock(PersonDTO.class);
            try (MockedStatic<PersonHelper> ms = Mockito.mockStatic(PersonHelper.class)) {
                ms.when(() -> PersonHelper.createPersonDTO(person)).thenReturn(expected);
                ResponseEntity<PersonDTO> resp = controller.getPersonByBenutzername(mock(HttpServletRequest.class), benutzername, Optional.empty(), Optional.empty());
                assertEquals(200, resp.getStatusCode().value());
                assertSame(expected, resp.getBody());
            }
        }

        @Test
        void getPersonByBenutzername_negative_notFound() {
            String benutzername = "u";
            when(personSrv.findPersonByBenutzername(benutzername)).thenReturn(null);
            // mock ServletUriComponentsBuilder used by getNotFound()
            try (MockedStatic<ServletUriComponentsBuilder> ms = Mockito.mockStatic(ServletUriComponentsBuilder.class)) {
                ServletUriComponentsBuilder builderMock = mock(ServletUriComponentsBuilder.class);
                UriComponents uriComp = mock(UriComponents.class);
                when(uriComp.toUri()).thenReturn(URI.create("http://localhost/test"));
                when(builderMock.build()).thenReturn(uriComp);
                ms.when(ServletUriComponentsBuilder::fromCurrentRequest).thenReturn(builderMock);

                ResponseEntity<PersonDTO> resp = controller.getPersonByBenutzername(mock(HttpServletRequest.class), benutzername, Optional.empty(), Optional.empty());
                assertEquals(404, resp.getStatusCode().value());
            }
        }
    }

    @Nested
    class RoleAndWrtTests {
        @Test
        void getRole_withSearchUser_callsFindAllForUser() {
            String searchUserId = UUID.randomUUID().toString();
            String vereinsId = UUID.randomUUID().toString();
            Person person = new Person();
            UUID pid = UUID.fromString(searchUserId);
            when(personSrv.findPersonById(pid)).thenReturn(person);
            ResponseEntity<Collection<RolleDTO>> svcResp = ResponseEntity.ok(Collections.emptyList());
            when(roleSrv.findAllForUser(vereinsId, person)).thenReturn(svcResp);
            ResponseEntity<Collection<RolleDTO>> resp = controller.getRole(mock(HttpServletRequest.class), "u", vereinsId, searchUserId);
            assertSame(svcResp, resp);
        }

        @Test
        void getRole_withoutSearchUser_callsFindAll() {
            String vereinsId = UUID.randomUUID().toString();
            ResponseEntity<Collection<RolleDTO>> svcResp = ResponseEntity.ok(Collections.emptyList());
            when(roleSrv.findAll()).thenReturn(svcResp);
            ResponseEntity<Collection<RolleDTO>> resp = controller.getRole(mock(HttpServletRequest.class), "u", vereinsId, "");
            assertSame(svcResp, resp);
        }

        @Test
        void getWertungsrichterForUserId_positive() {
            UUID id = UUID.randomUUID();
            Wertungsrichter wr = new Wertungsrichter();
            when(wertungsrichterSrv.getWertungsrichterByPersonId(id)).thenReturn(Optional.of(wr));
            WertungsrichterDTO dto = mock(WertungsrichterDTO.class);
            when(wrMapper.WertungsrichterToWertungsrichterDTO(wr)).thenReturn(dto);
            ResponseEntity<WertungsrichterDTO> resp = controller.getWertungsrichterForUserId(mock(HttpServletRequest.class), id);
            assertEquals(200, resp.getStatusCode().value());
            assertSame(dto, resp.getBody());
        }

        @Test
        void getWertungsrichterForUserId_negative_notFound() {
            UUID id = UUID.randomUUID();
            when(wertungsrichterSrv.getWertungsrichterByPersonId(id)).thenReturn(Optional.empty());
            try (MockedStatic<ServletUriComponentsBuilder> ms = Mockito.mockStatic(ServletUriComponentsBuilder.class)) {
                ServletUriComponentsBuilder builderMock = mock(ServletUriComponentsBuilder.class);
                UriComponents uriComp = mock(UriComponents.class);
                when(uriComp.toUri()).thenReturn(URI.create("http://localhost/test"));
                when(builderMock.build()).thenReturn(uriComp);
                ms.when(ServletUriComponentsBuilder::fromCurrentRequest).thenReturn(builderMock);

                ResponseEntity<WertungsrichterDTO> resp = controller.getWertungsrichterForUserId(mock(HttpServletRequest.class), id);
                assertEquals(404, resp.getStatusCode().value());
            }
        }
    }

    @Nested
    class UpdateAndDeleteWrtTests {
        @Test
        void updateWertungsrichter_createsResponse() {
            UUID id = UUID.randomUUID();
            WertungsrichterDTO dto = mock(WertungsrichterDTO.class);
            Wertungsrichter entity = new Wertungsrichter();
            when(wrMapper.WertungsrichterDTOToWertungsrichter(dto)).thenReturn(entity);
            when(wertungsrichterSrv.update(entity)).thenReturn(entity);

                try (MockedStatic<ServletUriComponentsBuilder> ms = Mockito.mockStatic(ServletUriComponentsBuilder.class)) {
                ServletUriComponentsBuilder builderMock = mock(ServletUriComponentsBuilder.class);
                UriComponents uriComp = mock(UriComponents.class);
                when(uriComp.toUri()).thenReturn(URI.create("http://localhost/test"));
                when(builderMock.build()).thenReturn(uriComp);
                ms.when(ServletUriComponentsBuilder::fromCurrentRequest).thenReturn(builderMock);

                ResponseEntity<WertungsrichterDTO> resp = controller.updateWertungsrichter(mock(HttpServletRequest.class), id, dto);
                assertEquals(201, resp.getStatusCode().value());
            }
        }

        @Test
        void deletWertungsrichter_createsResponseRegardless() {
            UUID id = UUID.randomUUID();
            Wertungsrichter wr = new Wertungsrichter();
            when(wertungsrichterSrv.getWertungsrichterByPersonId(id)).thenReturn(Optional.of(wr));
            doNothing().when(wertungsrichterSrv).delete(wr);
            try (MockedStatic<ServletUriComponentsBuilder> ms = Mockito.mockStatic(ServletUriComponentsBuilder.class)) {
                ServletUriComponentsBuilder builderMock = mock(ServletUriComponentsBuilder.class);
                UriComponents uriComp = mock(UriComponents.class);
                when(uriComp.toUri()).thenReturn(URI.create("http://localhost/test"));
                when(builderMock.build()).thenReturn(uriComp);
                ms.when(ServletUriComponentsBuilder::fromCurrentRequest).thenReturn(builderMock);

                ResponseEntity<WertungsrichterDTO> resp = controller.deletWertungsrichter(mock(HttpServletRequest.class), id);
                assertEquals(201, resp.getStatusCode().value());
            }
        }
    }

    @Nested
    class ExceptionHandlerTests {
        @Test
        void entityNotFound_returns404AndMessage() {
            EntityNotFoundException ex = new EntityNotFoundException(Object.class, UUID.randomUUID());
            ResponseEntity<?> resp = controller.handlerEntityNotFound(ex);
            assertEquals(404, resp.getStatusCode().value());
            assertEquals(ex.getMessage(), resp.getBody());
        }
    }

}
