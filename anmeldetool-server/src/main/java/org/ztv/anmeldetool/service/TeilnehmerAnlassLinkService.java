package org.ztv.anmeldetool.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.repositories.OrganisationAnlassLinkRepository;
import org.ztv.anmeldetool.repositories.TeilnehmerAnlassLinkRepository;
import org.ztv.anmeldetool.repositories.TeilnehmerRepository;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkCsvDTO;

import lombok.extern.slf4j.Slf4j;

@Service("teilnehmerAnlassLinkService")
@Slf4j
public class TeilnehmerAnlassLinkService {

	@Autowired
	OrganisationService organisationSrv;

	@Autowired
	AnlassService anlassSrv;

	@Autowired
	TeilnehmerRepository teilnehmerRepository;

	@Autowired
	TeilnehmerAnlassLinkRepository teilnehmerAnlassLinkRepository;

	@Autowired
	OrganisationAnlassLinkRepository organisationAnlassLinkRepository;

	public Optional<TeilnehmerAnlassLink> findTeilnehmerAnlassLinkById(UUID id) {
		return teilnehmerAnlassLinkRepository.findById(id);
	}

	public List<TeilnehmerAnlassLink> findAnlassTeilnahmenByKategorie(Anlass anlass, KategorieEnum kategorie)
			throws ServiceException {

		List<MeldeStatusEnum> exclusion = Arrays
				.asList(new MeldeStatusEnum[] { MeldeStatusEnum.ABGEMELDET, MeldeStatusEnum.UMMELDUNG });
		List<TeilnehmerAnlassLink> teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndAktivAndKategorie(anlass,
				true, exclusion, kategorie);
		return teilnahmen;
	}

	public List<TeilnehmerAnlassLink> findWettkampfTeilnahmenByKategorieOrderByOrganisation(Anlass anlass,
			KategorieEnum kategorie) throws ServiceException {
		List<MeldeStatusEnum> exclusion = Arrays.asList(new MeldeStatusEnum[] { MeldeStatusEnum.NICHTGESTARTET,
				MeldeStatusEnum.ABGEMELDET, MeldeStatusEnum.UMMELDUNG });
		List<TeilnehmerAnlassLink> teilnahmen = teilnehmerAnlassLinkRepository
				.findByAnlassAndAktivAndKategorieOrderByOrganisation(anlass, true, exclusion, kategorie);
		return teilnahmen;
	}

	public List<TeilnehmerAnlassLink> findWettkampfTeilnahmenByKategorie(Anlass anlass, KategorieEnum kategorie)
			throws ServiceException {

		List<MeldeStatusEnum> exclusion = Arrays.asList(new MeldeStatusEnum[] { MeldeStatusEnum.NICHTGESTARTET,
				MeldeStatusEnum.ABGEMELDET, MeldeStatusEnum.UMMELDUNG });
		List<TeilnehmerAnlassLink> teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndAktivAndKategorie(anlass,
				true, exclusion, kategorie);
		return teilnahmen;
	}

	public List<AnlageEnum> findAbteilungenByKategorieAndAbteilung(Anlass anlass, KategorieEnum kategorie,
			AbteilungEnum abteilung) throws ServiceException {

		UUID anlass_id = anlass.getId();
		String kategorieName = kategorie.name();
		String abteilungName = abteilung.name();
		List<AnlageEnum> anlagen = teilnehmerAnlassLinkRepository
				.findDistinctByAnlassAndAktivAndKategorieAndAbteilung(anlass_id, true, kategorieName, abteilungName);
		return anlagen;
	}

	public List<AbteilungEnum> findAbteilungenByKategorie(Anlass anlass, KategorieEnum kategorie)
			throws ServiceException {

		UUID anlass_id = anlass.getId();
		String kategorieName = kategorie.name();
		List<AbteilungEnum> abteilungen = teilnehmerAnlassLinkRepository
				.findDistinctByAnlassAndAktivAndKategorie(anlass_id, true, kategorieName);
		return abteilungen;
	}

	public TeilnehmerAnlassLink save(TeilnehmerAnlassLink tal) {
		TeilnehmerAnlassLink saved = this.teilnehmerAnlassLinkRepository.saveAndFlush(tal);
		return saved;
	}

	public List<TeilnehmerAnlassLink> findAnlassTeilnahmen(UUID anlassId) throws ServiceException {
		Anlass anlass = anlassSrv.findAnlassById(anlassId);
		if (anlass == null) {
			throw new ServiceException(this.getClass(),
					String.format("Could not find Anlass with id: %s", anlassId.toString()));
		}
		List<MeldeStatusEnum> exclusion = Arrays
				.asList(new MeldeStatusEnum[] { MeldeStatusEnum.ABGEMELDET, MeldeStatusEnum.UMMELDUNG });

		List<OrganisationAnlassLink> orgLinks = organisationAnlassLinkRepository.findByAnlassAndAktiv(anlass, true);
		List<Organisation> orgs = orgLinks.stream().map(oal -> {
			return oal.getOrganisation();
		}).collect(Collectors.toList());
		List<TeilnehmerAnlassLink> teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndAktiv(anlass, true,
				exclusion, orgs);
		return teilnahmen;
	}

	private List<TeilnehmerAnlassLink> updateStartNummern(List<TeilnehmerAnlassLink> tals) {
		Optional<TeilnehmerAnlassLink> max = teilnehmerAnlassLinkRepository
				.findTopByStartnummerNotNullOrderByStartnummerDesc();
		int maxStartnummer = 1;
		if (max.isPresent() && max.get().getStartnummer() != null) {
			maxStartnummer = max.get().getStartnummer() + 1;
		}
		AtomicInteger maxStartnummerAtomic = new AtomicInteger(maxStartnummer);
		List<TeilnehmerAnlassLink> mustUpdateTal = tals.stream().filter(tal -> {
			if (tal.getStartnummer() == null) {
				tal.setStartnummer(maxStartnummerAtomic.getAndIncrement());
				return true;
			}
			return false;
		}).collect(Collectors.toList());

		teilnehmerAnlassLinkRepository.saveAll(mustUpdateTal);
		return tals;
	}

	public List<TeilnehmerAnlassLink> getAllTeilnehmerForAnlassAndUpdateStartnummern(UUID anlassId)
			throws ServiceException {
		List<TeilnehmerAnlassLink> tals = findAnlassTeilnahmen(anlassId);
		tals = updateStartNummern(tals);
		return tals;
	}

	public int updateAnlassTeilnahmen(UUID anlassId, List<TeilnehmerAnlassLinkCsvDTO> talsDto) throws ServiceException {
		List<TeilnehmerAnlassLink> tals = findAnlassTeilnahmen(anlassId);
		List<TeilnehmerAnlassLink> toUpdate = new ArrayList<TeilnehmerAnlassLink>();
		int counter = 0;
		for (TeilnehmerAnlassLinkCsvDTO talDto : talsDto) {
			for (TeilnehmerAnlassLink tal : tals) {
				if (tal.getStartnummer().compareTo(talDto.getStartnummer()) == 0
						&& talDto.getTeilnehmerId().equals(tal.getTeilnehmer().getId())) {
					tal.setAbteilung(talDto.getAbteilung());
					tal.setAnlage(talDto.getAnlage());
					tal.setStartgeraet(talDto.getStartgeraet());
					toUpdate.add(tal);
					counter++;
					break;
				}
			}
		}

		toUpdate = teilnehmerAnlassLinkRepository.saveAll(toUpdate);
		if (toUpdate == null || toUpdate.size() != counter) {
			throw new ServiceException(this.getClass(), "Updated fehlgeschlagen");
		}
		return counter;
	}
}
