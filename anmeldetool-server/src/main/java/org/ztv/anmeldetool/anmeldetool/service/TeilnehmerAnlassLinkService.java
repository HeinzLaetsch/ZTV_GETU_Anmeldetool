package org.ztv.anmeldetool.anmeldetool.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.anmeldetool.repositories.TeilnehmerAnlassLinkRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.TeilnehmerRepository;
import org.ztv.anmeldetool.anmeldetool.transfer.TeilnehmerAnlassLinkCsvDTO;

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

	public List<TeilnehmerAnlassLink> findAnlassTeilnahmenByKategorie(Anlass anlass, KategorieEnum kategorie)
			throws ServiceException {

		List<MeldeStatusEnum> exclusion = Arrays
				.asList(new MeldeStatusEnum[] { MeldeStatusEnum.ABGEMELDET, MeldeStatusEnum.UMMELDUNG });
		List<TeilnehmerAnlassLink> teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndAktivAndKategorie(anlass,
				true, exclusion, kategorie);
		return teilnahmen;
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

		List<TeilnehmerAnlassLink> teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndAktiv(anlass, true,
				exclusion);
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
