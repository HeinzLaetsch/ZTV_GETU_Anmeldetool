package org.ztv.anmeldetool.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.exception.EntityNotFoundException;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.transfer.OrganisationTeilnahmenStatistikDTO;
import org.ztv.anmeldetool.transfer.TeilnahmenDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerDTO;
import org.ztv.anmeldetool.util.TeilnehmerAnlassLinkMapper;
import org.ztv.anmeldetool.util.TeilnehmerHelper;

import lombok.extern.slf4j.Slf4j;

/**
 * 
 * @author heinz
 */
@Service("teilnahmenService")
@Slf4j
public class TeilnahmenService {
	@Autowired
	AnlassService anlassSrv;

	@Autowired
	TeilnehmerAnlassLinkService teilnehmerAnlassLinkSrv;

	@Autowired
	TeilnehmerService teilnehmerSrv;

	@Autowired
	TeilnehmerAnlassLinkMapper teilnehmerAnlassLinkMapper;

	public Collection<OrganisationTeilnahmenStatistikDTO> getAnlassorganisationStati(int jahr, UUID orgId) {
		List<TeilnahmenDTO> teilnahmenPerTeilnehmer = getTeilnahmen(jahr, orgId, false);
		if (teilnahmenPerTeilnehmer.size() == 0) {
			return null;
		}

		// Für jeden Anlass ein OrganisationTeilnahmenStatistikDTO
		Map<UUID, OrganisationTeilnahmenStatistikDTO> organisationTeilnahmeStatiMap = new HashMap<UUID, OrganisationTeilnahmenStatistikDTO>();

		teilnahmenPerTeilnehmer.stream().forEach(teilnahmen -> {
			teilnahmen.getTalDTOList().stream().forEach(tal -> {
				var anlassStati = getAnlassStati(organisationTeilnahmeStatiMap, tal.getAnlassId());
				anlassStati.addTal(tal);
			});
		});

		return organisationTeilnahmeStatiMap.values();
	}

	private OrganisationTeilnahmenStatistikDTO getAnlassStati(
			Map<UUID, OrganisationTeilnahmenStatistikDTO> organisationTeilnahmeStatiMap, UUID anlassId) {
		if (organisationTeilnahmeStatiMap.containsKey(anlassId)) {
			return organisationTeilnahmeStatiMap.get(anlassId);
		}
		OrganisationTeilnahmenStatistikDTO ots = new OrganisationTeilnahmenStatistikDTO(anlassId);
		organisationTeilnahmeStatiMap.put(anlassId, ots);
		return ots;
	}

	public List<TeilnahmenDTO> getTeilnahmen(int jahr, UUID orgId, boolean adjust) {

		Map<Teilnehmer, List<TeilnehmerAnlassLink>> allTeilnehmer = anlassSrv.getTeilnahmen(jahr, orgId);
		Pageable pageable = PageRequest.of(0, 500); // return all
		Collection<Teilnehmer> teilnehmerListe = teilnehmerSrv.findTeilnehmerByOrganisation(orgId, pageable);
		teilnehmerListe.forEach(t -> {
			if (!allTeilnehmer.containsKey(t) && !t.isDeleted()) { // isAktiv not used
				allTeilnehmer.put(t, new ArrayList<>());
			}
		});
		Map<UUID, Anlass> anlassCache = new HashMap<>();

		List<TeilnahmenDTO> teilnahmenDtos = allTeilnehmer.entrySet().stream().map(entry -> {
			List<TeilnehmerAnlassLinkDTO> talDTOList = entry.getValue().stream().map(tal -> {
				var talDTO = teilnehmerAnlassLinkMapper.toDto(tal);
				if (!anlassCache.containsKey(talDTO.getAnlassId())) {
					Anlass anlass = anlassSrv.findAnlassById(talDTO.getAnlassId());
					anlassCache.put(anlass.getId(), anlass);
				}
				if (adjust) {
					talDTO = adjustMeldeStatus(false, anlassCache.get(talDTO.getAnlassId()), talDTO);
				}
				return talDTO;
			}).collect(Collectors.toList());

			KategorieEnum letzteKategorie = null;
			if (entry.getValue().size() == 1) {
				letzteKategorie = entry.getValue().get(0).getKategorie();
			} else {
				Optional<TeilnehmerAnlassLink> res = entry.getValue().stream()
						.filter(tal -> !KategorieEnum.KEIN_START.equals(tal.getKategorie())).max((tal1, tal2) -> {
							return tal1.getKategorie().compareTo(tal2.getKategorie());
						});
				if (res.isPresent()) {
					letzteKategorie = res.get().getKategorie();
				}
			}

			TeilnehmerDTO teilnehmerDto = TeilnehmerHelper.createTeilnehmerDTO(entry.getKey(),
					entry.getKey().getOrganisation().getId(), letzteKategorie);

			TeilnahmenDTO tDto = new TeilnahmenDTO(teilnehmerDto, talDTOList);

			return tDto;
		}).collect(Collectors.toList());
		return teilnahmenDtos;
	}

	private TeilnehmerAnlassLinkDTO adjustMeldeStatus(boolean fromUI, Anlass anlass, TeilnehmerAnlassLinkDTO talDto) {
		// adjustStates
		if (fromUI) {
			if (talDto.getMeldeStatus() != null && talDto.getMeldeStatus().length() > 0) {
				if (talDto.getMeldeStatus().equalsIgnoreCase("Abgemeldet")) {
					// Anlass noch nicht offen Kein Status
					if (anlass.getAnmeldungBeginn().isAfter(LocalDateTime.now())) {
						return talDtoFactory(talDto, MeldeStatusEnum.KEINE_TEILNAHME.name(), KategorieEnum.KEIN_START);
					}
					// Anmeldung offen erfassen erlaubt, Kat und Status leeren
					if (anlass.getAnmeldungBeginn().isBefore(LocalDateTime.now())
							&& anlass.getErfassenGeschlossen().isAfter(LocalDateTime.now())) {
						return talDtoFactory(talDto, MeldeStatusEnum.KEINE_TEILNAHME.name(), KategorieEnum.KEIN_START);
					}
					// Anmeldung geschlossen erfassen zu, Mutationen erlaubt, Status auf
					// Abgemeldet_1
					if (anlass.getErfassenGeschlossen().isBefore(LocalDateTime.now())
							&& anlass.getAenderungenInKategorieGeschlossen().isAfter(LocalDateTime.now())) {
						return talDtoFactory(talDto, MeldeStatusEnum.ABGEMELDET_1.name(), talDto.getKategorie());
					}
					// Anmeldung geschlossen erfassen zu, Mutationen zu, Status auf Abgemeldet_2
					if (anlass.getErfassenGeschlossen().isBefore(LocalDateTime.now())
							&& anlass.getAenderungenNichtMehrErlaubt().isAfter(LocalDateTime.now())) {
						return talDtoFactory(talDto, MeldeStatusEnum.ABGEMELDET_2.name(), talDto.getKategorie());
					}
					// Anmeldung geschlossen erfassen zu, Aenderungen zu, Wettkampf nicht gest.,
					// Status auf Abgemeldet_3
					if (anlass.getErfassenGeschlossen().isBefore(LocalDateTime.now())
							&& anlass.getAenderungenNichtMehrErlaubt().isBefore(LocalDateTime.now())
							&& anlass.getStartDate().isAfter(LocalDateTime.now())) {
						return talDtoFactory(talDto, MeldeStatusEnum.ABGEMELDET_3.name(), talDto.getKategorie());
					}
					// Anmeldung geschlossen erfassen zu, Aenderungen zu, Wettkampf gestartet.,
					// Status auf Abgemeldet_4
					if (anlass.getStartDate().isBefore(LocalDateTime.now())) {
						return talDtoFactory(talDto, MeldeStatusEnum.ABGEMELDET_4.name(), talDto.getKategorie());
					}
				} else {
					if (talDto.getMeldeStatus().equalsIgnoreCase("Startet")) {
						if (anlass.getErfassenGeschlossen().isBefore(LocalDateTime.now())
								&& anlass.getAenderungenInKategorieGeschlossen().isAfter(LocalDateTime.now())) {
							return talDtoFactory(talDto, MeldeStatusEnum.NEUMELDUNG.name(), talDto.getKategorie());
						}
					}
				}
			}
		} else {
			if (talDto.getMeldeStatus() != null) {
				if (talDto.getMeldeStatus().equalsIgnoreCase(MeldeStatusEnum.NICHTGESTARTET.name())) {
					return talDtoFactory(talDto, "Abgemeldet", talDto.getKategorie()); // Eventuell auch im UI
				}
				if (talDto.getMeldeStatus().toUpperCase().startsWith("ABGEMELDET")) {
					return talDtoFactory(talDto, "Abgemeldet", talDto.getKategorie());
				}
			} else {
				return talDtoFactory(talDto, "KEINE_TEILNAHME", KategorieEnum.KEIN_START);
			}
		}
		return talDto;
	}

	private TeilnehmerAnlassLinkDTO talDtoFactory(TeilnehmerAnlassLinkDTO talDto, String statusText,
			KategorieEnum kategorie) {
		return new TeilnehmerAnlassLinkDTO(talDto.getAnlassId(), talDto.getTeilnehmerId(), talDto.getOrganisationId(),
				kategorie, statusText, talDto.isDirty(), talDto.getStartnummer(), talDto.getAbteilung(),
				talDto.isAbteilungFix(), talDto.getAnlage(), talDto.isAnlageFix(), talDto.getStartgeraet(),
				talDto.isStartgeraetFix());
	}

	public TeilnahmenDTO updateTeilnahmen(int jahr, UUID orgId, TeilnahmenDTO teilnahmenDto)
			throws EntityNotFoundException {
		Map<UUID, Anlass> anlassCache = new HashMap<>();

		TeilnehmerDTO teilnehmerDto = teilnahmenDto.getTeilnehmer();
		Teilnehmer teilnehmerNeu = TeilnehmerHelper.createTeilnehmer(teilnehmerDto);

		Teilnehmer teilnehmer = teilnehmerSrv.findTeilnehmerById(teilnehmerNeu.getId());
		if (!teilnehmer.equals(teilnehmerNeu)) {
			teilnehmerDto = teilnehmerSrv.update(teilnehmerDto);
		}
		// Teilnehmer wird nicht ersetzt

		List<TeilnehmerAnlassLinkDTO> talDTOList = teilnahmenDto.getTalDTOList();
		talDTOList.forEach(talDto -> {
			if (!anlassCache.containsKey(talDto.getAnlassId())) {
				Anlass anlass = anlassSrv.findAnlassById(talDto.getAnlassId());
				anlassCache.put(anlass.getId(), anlass);
			}
			talDto = adjustMeldeStatus(true, anlassCache.get(talDto.getAnlassId()), talDto);
			TeilnehmerAnlassLink talNeu = teilnehmerAnlassLinkMapper.toEntity(talDto);
			Anlass anlass = anlassSrv.findAnlassById(talNeu.getAnlass().getId());
			Optional<TeilnehmerAnlassLink> talOptional = teilnehmerAnlassLinkSrv
					.findTeilnehmerAnlassLinkByAnlassAndTeilnehmer(anlass, teilnehmer);
			talOptional.ifPresentOrElse((tal) -> {
				// TODO Equals Methode überprüfen
				if (!tal.equals(talNeu)) {
					mergeTeilnehmerAnlassLink(tal, talNeu);
				}
			}, () -> {
				int startNummer = teilnehmerAnlassLinkSrv.findMaxStartNummer();
				talNeu.setStartnummer(startNummer);
				teilnehmerAnlassLinkSrv.save(talNeu);
			});
		});
		List<TeilnehmerAnlassLink> tals = teilnehmerAnlassLinkSrv.findTeilnehmerAnlassLinkByTeilnehmer(teilnehmer);
		List<TeilnehmerAnlassLinkDTO> linksDto = tals.stream()
				.filter(link -> anlassCache.containsKey(link.getAnlass().getId())).map(link -> {
					var talDTO = teilnehmerAnlassLinkMapper.toDto(link);
					talDTO = adjustMeldeStatus(false, anlassCache.get(talDTO.getAnlassId()), talDTO);
					return talDTO;
				}).collect(Collectors.toList());

		teilnahmenDto.getTalDTOList().clear();
		teilnahmenDto.getTalDTOList().addAll(linksDto);

		return teilnahmenDto;
	}

	private void mergeTeilnehmerAnlassLink(TeilnehmerAnlassLink persisted, TeilnehmerAnlassLink talNeu) {
		/*
		 * persisted.setAktiv(talNeu.isAktiv());
		 * persisted.setDeleted(talNeu.isDeleted());
		 * persisted.setAbteilung(talNeu.getAbteilung());
		 * persisted.setAnlage(talNeu.getAnlage());
		 */
		// Check for correct Status
		// Falls abgemeldet und Anmeldung noch offen setze auf Kein_Start
		// Falls Start und Verlängert
		persisted.setKategorie(talNeu.getKategorie());
		if (MeldeStatusEnum.ABGEMELDET_1.equals(persisted.getMeldeStatus())
				&& MeldeStatusEnum.NEUMELDUNG.equals(talNeu.getMeldeStatus())) {
			persisted.setMeldeStatus(MeldeStatusEnum.STARTET);
		} else {
			persisted.setMeldeStatus(talNeu.getMeldeStatus());
		}

		teilnehmerAnlassLinkSrv.save(persisted);
	}
}
