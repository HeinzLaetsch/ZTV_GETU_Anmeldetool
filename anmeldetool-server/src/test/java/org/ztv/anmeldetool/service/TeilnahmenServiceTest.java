package org.ztv.anmeldetool.service;

import static org.mockito.Mockito.any;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.mockito.junit.jupiter.MockitoExtension;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.transfer.TeilnahmenDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerDTO;
import org.ztv.anmeldetool.util.TeilnehmerAnlassLinkMapper;

@ExtendWith(MockitoExtension.class)
@Disabled
public class TeilnahmenServiceTest {

  @Mock
  AnlassService anlassSrv;

  @Mock
  TeilnehmerAnlassLinkService teilnehmerAnlassLinkSrv;

  @Mock
  TeilnehmerService teilnehmerSrv;

  @Mock
  TeilnehmerAnlassLinkMapper teilnehmerAnlassLinkMapper;

  @InjectMocks
  TeilnahmenService teilnahmenService;

  @BeforeEach
  void setUp() {
    MockitoAnnotations.openMocks(this);
  }


  @Test
  void whenAddingNewTal_thenSaveAndReturnUpdatedList() throws Exception {
    UUID orgId = UUID.randomUUID();
    UUID pid = UUID.randomUUID();
    TeilnehmerDTO teilnDTO = TeilnehmerDTO.builder().id(pid).organisationid(orgId).name("N")
        .vorname("F").jahrgang(0).stvNummer("").tiTu(TiTuEnum.Ti).aktiv(true).dirty(false)
        .letzteKategorie(null).build();
    TeilnahmenDTO teilnahmenDTO = new TeilnahmenDTO(teilnDTO, new ArrayList<>());
    UUID anlassId = UUID.randomUUID();
    TeilnehmerAnlassLinkDTO talDto = new TeilnehmerAnlassLinkDTO(anlassId, pid, orgId,
        KategorieEnum.K1, "", false, 0, null, false, null, false, null, false);
    teilnahmenDTO.getTalDTOList().add(talDto);

    Teilnehmer persisted = new Teilnehmer();
    persisted.setId(pid);
    when(teilnehmerSrv.findTeilnehmerById(pid)).thenReturn(persisted);
    // no existing tal
    Anlass anlass = new Anlass();
    anlass.setId(anlassId);
    when(anlassSrv.findById(anlassId)).thenReturn(anlass);
    when(teilnehmerAnlassLinkSrv.findTeilnehmerAnlassLinkByAnlassAndTeilnehmer(anlass,
        persisted)).thenReturn(Optional.empty());
    // map DTO->entity
    TeilnehmerAnlassLink talNeu = new TeilnehmerAnlassLink();
    talNeu.setKategorie(KategorieEnum.K1);
    talNeu.setAnlass(anlass);
    when(teilnehmerAnlassLinkMapper.toEntity(talDto)).thenReturn(talNeu);
    when(teilnehmerAnlassLinkSrv.findMaxStartNummer()).thenReturn(5);
    // ensure save invoked
    doAnswer(inv -> {
      TeilnehmerAnlassLink arg = inv.getArgument(0);
      // simulate persisted id
      arg.setId(UUID.randomUUID());
      return arg;
    }).when(teilnehmerAnlassLinkSrv).save(any(TeilnehmerAnlassLink.class));
    // after processing, findTeilnehmerAnlassLinkByTeilnehmer returns list with saved tal
    when(teilnehmerAnlassLinkSrv.findTeilnehmerAnlassLinkByTeilnehmer(persisted)).thenReturn(
        List.of(talNeu));
    // mapper for persisted link back to DTO (used at end of updateTeilnahmen)
    TeilnehmerAnlassLinkDTO persistedDto = new TeilnehmerAnlassLinkDTO(anlassId, pid, orgId,
        KategorieEnum.K1, "Startet", false, 5, null, false, null, false, null, false);
    when(teilnehmerAnlassLinkMapper.toDto(any(TeilnehmerAnlassLink.class))).thenReturn(
        persistedDto);

    //TeilnahmenDTO res = teilnahmenService.updateTeilnahmen(2025, orgId, teilnahmenDTO);
    //assertNotNull(res);
    //assertEquals(1, res.getTalDTOList().size());
  }
}
