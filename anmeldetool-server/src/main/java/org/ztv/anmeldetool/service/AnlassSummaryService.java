package org.ztv.anmeldetool.service;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.transfer.AnlassSummaryDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service("anlassSummaryService")
@Slf4j
@RequiredArgsConstructor
public class AnlassSummaryService {
	private static final int ATHLETES_PER_WR = 15;

	private final AnlassService anlassSrv;

	public Collection<AnlassSummaryDTO> getAnlassSummaries(UUID orgId, boolean onlyAktiveAnlaesse) {
		List<Anlass> anlaesse = anlassSrv.getAnlaesse(onlyAktiveAnlaesse);
		if (anlaesse != null) {
			return anlaesse.stream()
					.map(anlass -> getAnlassSummary(anlass.getId(), orgId))
					.collect(Collectors.toList());
		}
		return Collections.emptyList();
	}

	public AnlassSummaryDTO getAnlassSummary(UUID anlassId, UUID orgId) {
		OrganisationAnlassLink oalResult = anlassSrv.getVereinStart(anlassId, orgId);

		if (oalResult == null) {
			AnlassSummaryDTO asDto = AnlassSummaryDTO.builder().anlassId(anlassId).organisationsId(orgId).startet(false)
					.verlaengerungsDate(null).startendeBr1(0).startendeBr2(0).gemeldeteBr1(0).gemeldeteBr2(0)
					.br1Ok(true).br2Ok(true).build();
			return asDto;
		}
		int startBr1 = 0;
		int startK1 = 0;
		int startK2 = 0;
		int startK3 = 0;
		int startK4 = 0;
		int startK5 = 0;
		int startK5A = 0;
		int startK5B = 0;
		int startK6 = 0;
		int startK7 = 0;
		int startKD = 0;
		int startKH = 0;

		int startBr2 = 0;
		int gemeldeteBr1 = 0;
		int gemeldeteBr2 = 0;
		boolean br1Ok = false;
		boolean br2Ok = false;
		if (oalResult.isAktiv()) {
			List<TeilnehmerAnlassLink> links = anlassSrv.getTeilnahmen(anlassId, orgId, false);

			startBr1 = (int) links.stream()
					.filter(l -> l.getKategorie() != null && l.getKategorie().isJugend())
					.count();

			startK1 = getStartendeForKategorie(links, KategorieEnum.K1);
			startK2 = getStartendeForKategorie(links, KategorieEnum.K2);
			startK3 = getStartendeForKategorie(links, KategorieEnum.K3);
			startK4 = getStartendeForKategorie(links, KategorieEnum.K4);
			startK5 = getStartendeForKategorie(links, KategorieEnum.K5);
			startK5A = getStartendeForKategorie(links, KategorieEnum.K5A);
			startK5B = getStartendeForKategorie(links, KategorieEnum.K5B);
			startK6 = getStartendeForKategorie(links, KategorieEnum.K6);
			startK7 = getStartendeForKategorie(links, KategorieEnum.K7);
			startKD = getStartendeForKategorie(links, KategorieEnum.KD);
			startKH = getStartendeForKategorie(links, KategorieEnum.KH);

			startBr2 = (int) links.stream()
					.filter(l -> l.getKategorie() != null && l.getKategorie().isAktiv())
					.count();

			List<PersonAnlassLink> pals = anlassSrv.getEingeteilteWertungsrichter(anlassId, orgId,
					WertungsrichterBrevetEnum.Brevet_1);
			gemeldeteBr1 = pals.size();
			pals = anlassSrv.getEingeteilteWertungsrichter(anlassId, orgId, WertungsrichterBrevetEnum.Brevet_2);
			gemeldeteBr2 = pals.size();
			// TODO check anzahl
			// TODO store anzahl within config
			br1Ok = Math.ceil(startBr1 / (float) ATHLETES_PER_WR) <= gemeldeteBr1;
			br2Ok = Math.ceil(startBr2 / (float) ATHLETES_PER_WR) <= gemeldeteBr2;
		}
		AnlassSummaryDTO asDto = AnlassSummaryDTO.builder().anlassId(anlassId).organisationsId(orgId)
				.startet(oalResult.isAktiv()).verlaengerungsDate(oalResult.getVerlaengerungsDate())
				.startendeBr1(startBr1).startendeK1(startK1).startendeK2(startK2).startendeK3(startK3)
				.startendeK4(startK4).startendeK5(startK5).startendeK5A(startK5A).startendeK5B(startK5B)
				.startendeK6(startK6).startendeK7(startK7).startendeKD(startKD).startendeKH(startKH)
				.startendeBr2(startBr2).gemeldeteBr1(gemeldeteBr1).gemeldeteBr2(gemeldeteBr2).br1Ok(br1Ok).br2Ok(br2Ok)
				.build();
		return asDto;
	}

	private int getStartendeForKategorie(List<TeilnehmerAnlassLink> links, KategorieEnum kategorie) {
		return (int) links.stream()
				.filter(l -> l.getKategorie() != null
						&& l.getKategorie().equals(kategorie)
						&& (l.getMeldeStatus().equals(MeldeStatusEnum.STARTET)
							|| l.getMeldeStatus().equals(MeldeStatusEnum.NEUMELDUNG)))
				.count();
	}
}
