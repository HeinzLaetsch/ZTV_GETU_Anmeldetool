package org.ztv.anmeldetool.controller;

import static org.hamcrest.Matchers.containsString;
import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import java.util.List;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.UUID;
import java.time.LocalDate;
import java.time.LocalTime;
import org.junit.jupiter.api.Test;
import org.ztv.anmeldetool.transfer.StartlisteDTO;
import org.mockito.ArgumentCaptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.MediaType;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.ztv.anmeldetool.config.ZTVSecurityConfig;
import org.ztv.anmeldetool.service.AnlassService;
import org.ztv.anmeldetool.service.AnlassSummaryService;
import org.ztv.anmeldetool.service.AnmeldekontrolService;
import org.ztv.anmeldetool.service.OrganisationAnlassLinkService;
import org.ztv.anmeldetool.service.OrganisationService;
import org.ztv.anmeldetool.service.PersonAnlassLinkService;
import org.ztv.anmeldetool.service.PersonService;
import org.ztv.anmeldetool.service.StartlisteService;
import org.ztv.anmeldetool.service.StvContestService;
import org.ztv.anmeldetool.service.TeilnehmerAnlassLinkService;
import org.ztv.anmeldetool.service.TeilnehmerService;
import org.ztv.anmeldetool.service.WertungsrichterEinsatzService;
import org.ztv.anmeldetool.service.WertungsrichterService;
import org.ztv.anmeldetool.security.JwtUtil;
import org.ztv.anmeldetool.transfer.AnlassDTO;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.models.Anlass;

@WebMvcTest(AnlassAdminController.class)
@Import(ZTVSecurityConfig.class)
@MockitoBean(types = { AnlassService.class, StartlisteService.class, OrganisationService.class, AnlassSummaryService.class,
        AnmeldekontrolService.class, TeilnehmerAnlassLinkService.class, TeilnehmerService.class,
        StvContestService.class, WertungsrichterService.class, WertungsrichterEinsatzService.class,
        OrganisationAnlassLinkService.class, PersonAnlassLinkService.class, PersonService.class,
        UserDetailsService.class, JwtUtil.class })
class CreateAnlassControllerTest {
    @Autowired
    private MockMvc mvc;
    @Autowired
    private AnlassService service;
    @Autowired
    private StartlisteService startlisteService;

    @Test
    void startlisteIsDownloadedAsWordDocument() throws Exception {
        UUID id = UUID.randomUUID();
        when(startlisteService.getStartliste(id)).thenReturn(new StartlisteDTO("Frühling", "Effretikon", List.of()));
        mvc.perform(get("/admin/anlaesse/{id}/startliste", id)
                .with(user("admin").authorities(() -> "ADMINISTRATOR")))
                .andExpect(status().isOk())
                .andExpect(header().string("Content-Type",
                        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"))
                .andExpect(header().string("Content-Disposition",
                        containsString("filename*=UTF-8''Startliste_Fr%C3%BChling.docx")));
    }

    @Test
    void administratorCanDeleteAnlass() throws Exception {
        UUID id = UUID.randomUUID();
        mvc.perform(delete("/admin/anlaesse/{id}", id)
                .with(user("admin").authorities(() -> "ADMINISTRATOR")))
                .andExpect(status().isNoContent());
        verify(service).deleteAnlass(id);
    }

    @Test
    void sekretariatCanDeleteAnlass() throws Exception {
        UUID id = UUID.randomUUID();
        mvc.perform(delete("/admin/anlaesse/{id}", id)
                .with(user("sekretariat").authorities(() -> "SEKRETARIAT")))
                .andExpect(status().isNoContent());
        verify(service).deleteAnlass(id);
    }

    @Test
    void anonymousCannotDeleteAnlass() throws Exception {
        mvc.perform(delete("/admin/anlaesse/{id}", UUID.randomUUID())).andExpect(status().isUnauthorized());
        verifyNoInteractions(service);
    }

    @Test
    void anmelderCannotDeleteAnlass() throws Exception {
        mvc.perform(delete("/admin/anlaesse/{id}", UUID.randomUUID())
                .with(user("anmelder").authorities(() -> "ANMELDER")))
                .andExpect(status().isForbidden());
        verifyNoInteractions(service);
    }

    @Test
    void rejectsDeletionWhenOtherDataStillReferencesTheEvent() throws Exception {
        UUID id = UUID.randomUUID();
        doThrow(new DataIntegrityViolationException("Referenced event")).when(service).deleteAnlass(id);
        mvc.perform(delete("/admin/anlaesse/{id}", id)
                .with(user("admin").authorities(() -> "ADMINISTRATOR")))
                .andExpect(status().isConflict());
    }

    @Test
    void deletingMissingEventReturnsNotFound() throws Exception {
        UUID id = UUID.randomUUID();
        doThrow(new NotFoundException(Anlass.class, id)).when(service).deleteAnlass(id);
        mvc.perform(delete("/admin/anlaesse/{id}", id)
                .with(user("admin").authorities(() -> "ADMINISTRATOR")))
                .andExpect(status().isNotFound());
    }

    private static final String REQUEST = """
            {"anlassBezeichnung":"Testanlass","ort":"Zuerich","halle":"Turnhalle",
             "tiTu":"Alle","tiefsteKategorie":"K1","hoechsteKategorie":"K7",
            "startDatum":"2027-03-01T00:00:00","endDatum":"2027-03-01T00:00:00",
            "wertungsrichterSlots":[{"brevet":1,"tag":"2027-03-01","start_zeit":"08:00:00",
            "end_zeit":"12:00:00","beschreibung":"Vormittag","reihenfolge":1}]}
            """;

    @Test
    void administratorCanCreateAnlass() throws Exception {
        UUID id = UUID.randomUUID();
        when(service.createAnlass(any())).thenReturn(AnlassDTO.builder().id(id)
                .anlassBezeichnung("Testanlass").build());
        mvc.perform(post("/admin/anlaesse").with(user("admin").authorities(() -> "ADMINISTRATOR"))
                .contentType(MediaType.APPLICATION_JSON).content(REQUEST))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.id").value(id.toString()));
        ArgumentCaptor<AnlassDTO> captor = ArgumentCaptor.forClass(AnlassDTO.class);
        verify(service).createAnlass(captor.capture());
        assertThat(captor.getValue().getWertungsrichterSlots()).hasSize(1);
        assertThat(captor.getValue().getWertungsrichterSlots().getFirst().getTag())
                .isEqualTo(LocalDate.of(2027, 3, 1));
        assertThat(captor.getValue().getWertungsrichterSlots().getFirst().getStart_zeit())
                .isEqualTo(LocalTime.of(8, 0));
    }

    @Test
    void sekretariatCanCreateAnlass() throws Exception {
        when(service.createAnlass(any())).thenReturn(AnlassDTO.builder().build());
        mvc.perform(post("/admin/anlaesse").with(user("sekretariat").authorities(() -> "SEKRETARIAT"))
                .contentType(MediaType.APPLICATION_JSON).content(REQUEST))
                .andExpect(status().isCreated());
    }

    @Test
    void anonymousCannotCreateAnlass() throws Exception {
        mvc.perform(post("/admin/anlaesse").contentType(MediaType.APPLICATION_JSON).content(REQUEST))
                .andExpect(status().isUnauthorized());
        verifyNoInteractions(service);
    }

    @Test
    void anmelderCannotCreateAnlass() throws Exception {
        mvc.perform(post("/admin/anlaesse").with(user("anmelder").authorities(() -> "ANMELDER"))
                .contentType(MediaType.APPLICATION_JSON).content(REQUEST))
                .andExpect(status().isForbidden());
        verifyNoInteractions(service);
    }
}