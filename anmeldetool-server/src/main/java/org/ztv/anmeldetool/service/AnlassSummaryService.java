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
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.transfer.AnlassSummaryDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.ztv.anmeldetool.transfer.OrganisationAnlassLinkDTO;

@Service("anlassSummaryService")
@Slf4j
@RequiredArgsConstructor
public class AnlassSummaryService {
	private static final int ATHLETES_PER_WR = 15;

	private final AnlassService anlassSrv;
  private final OrganisationAnlassLinkService organisationAnlassLinkSrv;
  private final PersonAnlassLinkService personAnlassLinkSrv;

	public Collection<AnlassSummaryDTO> getAnlassSummaries(Organisation organisation, boolean onlyAktiveAnlaesse) {
		List<Anlass> anlaesse = anlassSrv.getAnlaesse(onlyAktiveAnlaesse);
		if (anlaesse != null) {
			return anlaesse.stream()
					.map(anlass -> getAnlassSummary(anlass, organisation))
					.collect(Collectors.toList());
		}
		return Collections.emptyList();
	}

	public AnlassSummaryDTO getAnlassSummary(Anlass anlass, Organisation organisation) {
		OrganisationAnlassLinkDTO oalResultDto = organisationAnlassLinkSrv.getVereinStartDTO(anlass, organisation);

		if (oalResultDto == null) {
			AnlassSummaryDTO asDto = AnlassSummaryDTO.builder().anlassId(anlass.getId()).organisationsId(organisation.getId()).startet(false)
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
		if (oalResultDto.isStartet()) {
			List<TeilnehmerAnlassLink> links = anlassSrv.getTeilnahmen(anlass, organisation, false);

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

			List<PersonAnlassLink> pals = personAnlassLinkSrv.getEingeteilteWertungsrichter(anlass, organisation,
					WertungsrichterBrevetEnum.Brevet_1);
			gemeldeteBr1 = pals.size();
			pals = personAnlassLinkSrv.getEingeteilteWertungsrichter(anlass, organisation, WertungsrichterBrevetEnum.Brevet_2);
			gemeldeteBr2 = pals.size();
			// TODO check anzahl
			// TODO store anzahl within config
			br1Ok = Math.ceil(startBr1 / (float) ATHLETES_PER_WR) <= gemeldeteBr1;
			br2Ok = Math.ceil(startBr2 / (float) ATHLETES_PER_WR) <= gemeldeteBr2;
		}
		return AnlassSummaryDTO.builder().anlassId(anlass.getId()).organisationsId(organisation.getId())
				.startet(oalResultDto.isStartet()).verlaengerungsDate(oalResultDto.getVerlaengerungsDate())
				.startendeBr1(startBr1).startendeK1(startK1).startendeK2(startK2).startendeK3(startK3)
				.startendeK4(startK4).startendeK5(startK5).startendeK5A(startK5A).startendeK5B(startK5B)
				.startendeK6(startK6).startendeK7(startK7).startendeKD(startKD).startendeKH(startKH)
				.startendeBr2(startBr2).gemeldeteBr1(gemeldeteBr1).gemeldeteBr2(gemeldeteBr2).br1Ok(br1Ok).br2Ok(br2Ok)
				.build();
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
