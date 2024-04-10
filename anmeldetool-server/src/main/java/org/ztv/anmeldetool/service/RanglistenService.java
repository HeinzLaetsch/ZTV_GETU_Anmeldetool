package org.ztv.anmeldetool.service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Notenblatt;
import org.ztv.anmeldetool.models.RanglisteConfiguration;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.repositories.NotenblaetterRepository;
import org.ztv.anmeldetool.repositories.RanglisteConfigurationRepository;
import org.ztv.anmeldetool.transfer.RanglistenEntryDTO;
import org.ztv.anmeldetool.transfer.TeamwertungDTO;
import org.ztv.anmeldetool.util.TeilnehmerAnlassLinkRanglistenMapper;

import lombok.extern.slf4j.Slf4j;

@Service("ranglistenService")
@Slf4j
public class RanglistenService {

	@Autowired
	TeilnehmerAnlassLinkService talService;

	@Autowired
	AnlassService anlassService;

	@Autowired
	NotenblaetterRepository notenblaetterRepo;

	@Autowired
	RanglisteConfigurationRepository ranglisteConfigurationRepo;

	@Autowired
	TeilnehmerAnlassLinkRanglistenMapper talrMapper;

	public List<RanglistenEntryDTO> getRanglistenPerVereinDtos(UUID anlassId, TiTuEnum tiTu, KategorieEnum kategorie)
			throws ServiceException {
		Anlass anlass = anlassService.findAnlassById(anlassId);
		List<TeilnehmerAnlassLink> tals = getRanglistePerVerein(anlass, tiTu, kategorie);

		List<RanglistenEntryDTO> ranglistenDTOs = tals.stream().map(tal -> {
			return talrMapper.fromEntity(tal);
		}).collect(Collectors.toList());
		return ranglistenDTOs;
	}

	public List<TeamwertungDTO> getTeamwertungTi(UUID anlassId, KategorieEnum kategorie) throws ServiceException {
		Map<String, TeamwertungDTO> teamwertungen = new HashMap<>();
		List<RanglistenEntryDTO> entries = getRanglistenPerVereinDtos(anlassId, TiTuEnum.Ti, kategorie);
		for (RanglistenEntryDTO entry : entries) {
			TeamwertungDTO teamwertung;
			if (teamwertungen.containsKey(entry.getVerein())) {
				teamwertung = teamwertungen.get(entry.getVerein());
			} else {
				teamwertung = new TeamwertungDTO();
				teamwertung.setVerein(entry.getVerein());
				teamwertungen.put(entry.getVerein(), teamwertung);
			}
			if ((teamwertung.getAnzahlResultate() <= 3 && kategorie.ordinal() <= KategorieEnum.K4.ordinal())
					|| (teamwertung.getAnzahlResultate() <= 2 && kategorie.ordinal() > KategorieEnum.K4.ordinal())) {
				teamwertung.setAnzahlResultate(teamwertung.getAnzahlResultate() + 1);
				teamwertung.setGesamtPunktzahl(teamwertung.getGesamtPunktzahl() + entry.getGesamtPunktzahl());
			}
		}
		List<TeamwertungDTO> result1 = teamwertungen.values().stream().filter(tw -> {
			if (kategorie.ordinal() <= KategorieEnum.K4.ordinal()) {
				return tw.getAnzahlResultate() == 4;
			} else {
				return tw.getAnzahlResultate() == 3;
			}
		}).collect(Collectors.toList());

		List<TeamwertungDTO> result = result1.stream()
				.sorted(Comparator.comparing(tw -> tw.getGesamtPunktzahl(), Comparator.reverseOrder()))
				.collect(Collectors.toList());
		int rang = 0;
		for (TeamwertungDTO tw : result) {
			tw.setRang(++rang);
		}
		return result;
	}

	public List<TeamwertungDTO> getTeamwertungTu(UUID anlassId, KategorieEnum kategorie) throws ServiceException {
		List<TeamwertungDTO> unsortedResult = null;
		Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> teamListe = new HashMap<>();
		if (kategorie.isJugend()) {
			prepareKategory(teamListe, anlassId, KategorieEnum.K1, 3);
			prepareKategory(teamListe, anlassId, KategorieEnum.K2, 3);
			prepareKategory(teamListe, anlassId, KategorieEnum.K3, 3);
			prepareKategory(teamListe, anlassId, KategorieEnum.K4, 3);

			cleanUp(teamListe);
			sortTeam(teamListe);
			unsortedResult = calcTeamResult(teamListe, 4);
		} else {
			prepareKategory(teamListe, anlassId, KategorieEnum.K5, 2);
			prepareKategory(teamListe, anlassId, KategorieEnum.K6, 2);
			prepareKategory(teamListe, anlassId, KategorieEnum.KH, 2);
			prepareKategory(teamListe, anlassId, KategorieEnum.K7, 2);

			cleanUp(teamListe);
			sortTeam(teamListe);
			unsortedResult = calcTeamResult(teamListe, 3);
		}
		List<TeamwertungDTO> sortedResult = sortAndSetRank(unsortedResult);
		return sortedResult;
	}

	private Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> prepareKategory(
			Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> teamListe, UUID anlassId, KategorieEnum kategorie,
			int maxProKategorie) throws ServiceException {
		List<RanglistenEntryDTO> entries = getRanglistenPerVereinDtos(anlassId, TiTuEnum.Tu, kategorie);
		selectBestResults(teamListe, entries, kategorie, maxProKategorie);
		return teamListe;
	}

	private Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> selectBestResults(
			Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> teamListe, List<RanglistenEntryDTO> entries,
			KategorieEnum kategorie, int maxKategorieResults) {
		entries.forEach(entry -> {
			List<RanglistenEntryDTO> ranglistenDtos = null;
			Map<KategorieEnum, List<RanglistenEntryDTO>> perKategorieMap = null;
			if (teamListe.containsKey(entry.getVerein())) {
				perKategorieMap = teamListe.get(entry.getVerein());
			} else {
				perKategorieMap = new HashMap<>();
				teamListe.put(entry.getVerein(), perKategorieMap);
			}
			if (perKategorieMap.containsKey(kategorie)) {
				ranglistenDtos = perKategorieMap.get(kategorie);
			} else {
				ranglistenDtos = new ArrayList<>();
				perKategorieMap.put(kategorie, ranglistenDtos);
			}
			if (ranglistenDtos.size() < maxKategorieResults) {
				ranglistenDtos.add(entry);
				if (perKategorieMap.containsKey(KategorieEnum.KEIN_START)) {
					ranglistenDtos = perKategorieMap.get(KategorieEnum.KEIN_START);
				} else {
					ranglistenDtos = new ArrayList<>();
					perKategorieMap.put(KategorieEnum.KEIN_START, ranglistenDtos);
				}
				ranglistenDtos.add(entry);
			}
		});
		return teamListe;
	}

	private List<TeamwertungDTO> calcTeamResult(Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> teamListe,
			int teamSize) {
		List<TeamwertungDTO> unsortedResult = new ArrayList<>();
		teamListe.values().forEach(team -> {
			if (team.get(KategorieEnum.KEIN_START) != null && team.get(KategorieEnum.KEIN_START).size() >= teamSize) {
				TeamwertungDTO teamWertungDto = new TeamwertungDTO();
				team.get(KategorieEnum.KEIN_START).forEach(entry -> {
					teamWertungDto.setVerein(entry.getVerein());
					if (teamWertungDto.getAnzahlResultate() < teamSize) {
						teamWertungDto.setAnzahlResultate(teamWertungDto.getAnzahlResultate() + 1);
						teamWertungDto
								.setGesamtPunktzahl(teamWertungDto.getGesamtPunktzahl() + entry.getGesamtPunktzahl());
					}
				});
				if (teamWertungDto.getVerein() != null) {
					unsortedResult.add(teamWertungDto);
				}
			}
		});
		return unsortedResult;
	}

	private Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> sortTeam(
			Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> teamListe) {
		teamListe.values().forEach(team -> {
			team.values().forEach(kategorie -> {
				List<RanglistenEntryDTO> sortedList = kategorie.stream()
						.sorted(Comparator.comparing(tw -> tw.getGesamtPunktzahl(), Comparator.reverseOrder()))
						.collect(Collectors.toList());
				kategorie.clear();
				kategorie.addAll(sortedList);
			});
		});
		return teamListe;
	}

	private Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> cleanUp(
			Map<String, Map<KategorieEnum, List<RanglistenEntryDTO>>> teamListe) {
		teamListe.values().forEach(team -> {
			if (team.size() < 2) {
				team.clear();
			}
		});
		teamListe.values().forEach(team -> {
			List<RanglistenEntryDTO> alle = new ArrayList<>();
			team.values().forEach(perKategorieMapEntry -> {
				alle.addAll(perKategorieMapEntry);
			});
		});
		return teamListe;
	}

	private List<TeamwertungDTO> sortAndSetRank(List<TeamwertungDTO> unsortedResult) {
		List<TeamwertungDTO> result = unsortedResult.stream()
				.sorted(Comparator.comparing(tw -> tw.getGesamtPunktzahl(), Comparator.reverseOrder()))
				.collect(Collectors.toList());
		int rang = 0;
		for (TeamwertungDTO tw : result) {
			tw.setRang(++rang);
		}
		return result;
	}

	public Notenblatt saveNotenblatt(Notenblatt notenblatt) {
		return notenblaetterRepo.save(notenblatt);
	}

	public RanglisteConfiguration saveRanglisteConfiguration(RanglisteConfiguration rc) {
		Optional<RanglisteConfiguration> entityOpt = ranglisteConfigurationRepo.findById(rc.getId());
		if (entityOpt.isPresent()) {
			entityOpt.get().setMaxAuszeichnungen(rc.getMaxAuszeichnungen());
			return ranglisteConfigurationRepo.save(entityOpt.get());
		}
		return ranglisteConfigurationRepo.save(rc);
	}

	public List<TeilnehmerAnlassLink> getRanglistePerVerein(Anlass anlass, TiTuEnum tiTu, KategorieEnum kategorie)
			throws ServiceException {
		List<TeilnehmerAnlassLink> tals = talService
				.findWettkampfTeilnahmenByKategorieAndTiTuOrderByOrganisation(anlass, kategorie, tiTu);
		return tals;
	}

	public RanglisteConfiguration getRanglisteConfiguration(Anlass anlass, KategorieEnum kategorie, TiTuEnum tiTu) {
		Optional<RanglisteConfiguration> ranglistenConfigOpt = anlass.getRanglisteConfigurationen().stream()
				.filter(conf -> {
					return conf.getKategorie().equals(kategorie) && conf.getTiTu().equals(tiTu);
				}).findFirst();
		RanglisteConfiguration ranglistenConfig = null;
		if (ranglistenConfigOpt.isEmpty()) {
			ranglistenConfig = new RanglisteConfiguration(anlass, kategorie, tiTu, 0);
		} else {
			ranglistenConfig = ranglistenConfigOpt.get();
		}
		return ranglistenConfig;
	}

	public int calcMaxAuszeichnungen(List<TeilnehmerAnlassLink> tals, int maxAuszeichung) throws ServiceException {
		if (maxAuszeichung == 0) {
			maxAuszeichung = (int) Math.ceil(tals.size() * 0.4);
		}
		return maxAuszeichung;
	}

	public List<TeilnehmerAnlassLink> getTeilnehmerSorted(Anlass anlass, KategorieEnum kategorie, TiTuEnum titu)
			throws ServiceException {
		List<TeilnehmerAnlassLink> tals = talService.findWettkampfTeilnahmenByKategorieAndTiTu(anlass, kategorie, titu);

		tals = tals.stream().sorted(
				Comparator.comparing(tal -> tal.getNotenblatt().getGesamtPunktzahl(), Comparator.reverseOrder()))
				.collect(Collectors.toList());

		return tals;
	}

	public List<TeilnehmerAnlassLink> createRangliste(List<TeilnehmerAnlassLink> tals, int maxAuszeichung)
			throws ServiceException {

		int rang = 0;
		int pos = 0;
		float last = 0.0f;
		for (TeilnehmerAnlassLink tal : tals) {
			pos++;
			float actual = tal.getNotenblatt().getGesamtPunktzahl();
			if (last != actual) {
				rang = pos;
				last = actual;
			}
			tal.getNotenblatt().setRang(rang);
			if (rang <= maxAuszeichung) {
				tal.getNotenblatt().setAuszeichnung(true);
			} else {
				tal.getNotenblatt().setAuszeichnung(false);
			}
		}
		;
		return tals;
	}
}
