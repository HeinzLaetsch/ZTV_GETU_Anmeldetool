package org.ztv.anmeldetool.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Notenblatt;
import org.ztv.anmeldetool.models.SmQualiAnlassTeilnahmen;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;

import lombok.extern.slf4j.Slf4j;

@Service("smQualiService")
@Slf4j
public class SmQualiService {
	private TeilnehmerAnlassLinkService talService;

	private AnlassService anlassService;
	// NotenblaetterRepository notenblaetterRepo;

	SmQualiService(AnlassService anlassService, TeilnehmerAnlassLinkService talService) {
		this.anlassService = anlassService;
		this.talService = talService;
	}

	public List<List<TeilnehmerAnlassLink>> getTeilnahmen(int jahr, boolean nurSmQuali, TiTuEnum tiTu,
			KategorieEnum kategorie) throws ServiceException {
		List<Anlass> qualiAnlaesse = anlassService.getAnlaesseFiltered(jahr, nurSmQuali, tiTu);
		List<List<TeilnehmerAnlassLink>> teilnahmen = qualiAnlaesse.stream().map(anlass -> {
			try {
				return talService.findWettkampfTeilnahmenByKategorieAndTiTu(anlass, kategorie, tiTu).stream()
						.filter(t -> {
							return t.getOrganisation().getVerband().getVerband().equals("ZTV")
									|| t.getOrganisation().getVerband().getVerband().equals("GLZ")
									|| t.getOrganisation().getVerband().getVerband().equals("WTU")
									|| t.getOrganisation().getVerband().getVerband().equals("AZO");
						}).collect(Collectors.toList());
			} catch (ServiceException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return null;
			}
		}).collect(Collectors.toList());
		return teilnahmen;
	}

	public List<SmQualiAnlassTeilnahmen> getAnlassTeilnahmen(int jahr, boolean nurSmQuali, TiTuEnum tiTu,
			KategorieEnum kategorie) throws ServiceException {
		List<List<TeilnehmerAnlassLink>> teilnahmen = getTeilnahmen(jahr, nurSmQuali, tiTu, kategorie);
		Map<UUID, SmQualiAnlassTeilnahmen> perTeilnehmerMap = new HashMap<UUID, SmQualiAnlassTeilnahmen>();
		Map<UUID, SmQualiAnlassTeilnahmen> perTeilnehmerAusserKantonalMap = new HashMap<UUID, SmQualiAnlassTeilnahmen>();
		for (List<TeilnehmerAnlassLink> anlassTals : teilnahmen) {
			for (TeilnehmerAnlassLink tal : anlassTals) {
				SmQualiAnlassTeilnahmen smq = null;
				if (tal.getAnlass().isAusserkantonal()) {
					System.out.println("Anlass ID " + tal.getAnlass().getId());
					if (perTeilnehmerAusserKantonalMap.containsKey(tal.getTeilnehmer().getId())) {
						smq = perTeilnehmerAusserKantonalMap.get(tal.getTeilnehmer().getId());
					} else {
						smq = new SmQualiAnlassTeilnahmen();
						perTeilnehmerAusserKantonalMap.put(tal.getTeilnehmer().getId(), smq);
						// smq.setTeilnehmer(tal.getTeilnehmer());
					}
					smq.addAusserKantonalAnlass(tal);
				} else {
					if (perTeilnehmerMap.containsKey(tal.getTeilnehmer().getId())) {
						smq = perTeilnehmerMap.get(tal.getTeilnehmer().getId());
					} else {
						smq = new SmQualiAnlassTeilnahmen();
						perTeilnehmerMap.put(tal.getTeilnehmer().getId(), smq);
						// smq.setTeilnehmer(tal.getTeilnehmer());
					}
					smq.addTeilnahme(tal);
				}
				smq.calcDurchschnittEinzelnoten();
				// System.out.println("Durchsch: " + smq.getDurchschnittlichePunktzahl());
			}
		}
		List<SmQualiAnlassTeilnahmen> perTeilnehmerList = new ArrayList<>(perTeilnehmerMap.values());
		List<SmQualiAnlassTeilnahmen> perTeilnehmerAusserKantonalList = new ArrayList<>(
				perTeilnehmerAusserKantonalMap.values());
		perTeilnehmerList = syncWithOtherList(perTeilnehmerList, perTeilnehmerAusserKantonalList);
		perTeilnehmerAusserKantonalList = syncWithOtherList(perTeilnehmerAusserKantonalList, perTeilnehmerList);

		List<Anlass> anlaesse = anlassService.getAnlaesseFiltered(jahr, nurSmQuali, tiTu);
		fillAllAnlaesse(jahr, nurSmQuali, tiTu, kategorie, perTeilnehmerList, anlaesse, true);
		fillAllAnlaesse(jahr, nurSmQuali, tiTu, kategorie, perTeilnehmerAusserKantonalList, anlaesse, false);
		Map<UUID, BigDecimal> bestPerAnlass = getBestResults(anlaesse, perTeilnehmerList, true, kategorie);
		Map<UUID, BigDecimal> bestPerAusserKantonalAnlass = getBestResults(anlaesse, perTeilnehmerAusserKantonalList,
				false, kategorie);
		transferAusserkantonal(perTeilnehmerList, perTeilnehmerAusserKantonalList);

		adjustOhneTeilnahme(bestPerAnlass, perTeilnehmerList, true);
		adjustOhneTeilnahme(bestPerAusserKantonalAnlass, perTeilnehmerList, false);

		transferTotal(perTeilnehmerList, nurSmQuali);
		perTeilnehmerList.sort(SmQualiAnlassTeilnahmen::compareByDurchschnittlichePunktzahl);
		return perTeilnehmerList;
	}

	private List<SmQualiAnlassTeilnahmen> syncWithOtherList(List<SmQualiAnlassTeilnahmen> target,
			List<SmQualiAnlassTeilnahmen> other) {
		other.stream().forEach(otherSmq -> {
			Optional<SmQualiAnlassTeilnahmen> smqTargetOptional = target.stream().filter(smq -> {
				return smq.getTeilnehmer().getId().equals(otherSmq.getTeilnehmer().getId());
			}).findFirst();
			if (smqTargetOptional.isEmpty()) {
				target.add(otherSmq);
			}
		});
		return target;
	}

	private List<SmQualiAnlassTeilnahmen> transferAusserkantonal(List<SmQualiAnlassTeilnahmen> target,
			List<SmQualiAnlassTeilnahmen> other) {
		other.stream().forEach(otherSmq -> {
			Optional<SmQualiAnlassTeilnahmen> smqTargetOptional = target.stream().filter(smq -> {
				return smq.getTeilnehmer().getId().equals(otherSmq.getTeilnehmer().getId());
			}).findFirst();
			if (smqTargetOptional.isPresent()) {
				// smqTargetOptional.get().setAusserKantonalAnlassTeilnahmen(otherSmq.getAusserKantonalAnlassTeilnahmen());
				smqTargetOptional.get().calcDurchschnittEinzelnoten();
			}
		});
		return target;
	}

	public void adjustOhneTeilnahme(Map<UUID, BigDecimal> bestPerAnlass,
			List<SmQualiAnlassTeilnahmen> perTeilnehmerList, boolean nurZTV) {
		perTeilnehmerList.forEach(smq -> {
			List<TeilnehmerAnlassLink> tals = null;
			if (nurZTV) {
				// tals = smq.getAnlassTeilnahmen();
			} else {
				// tals = smq.getAusserKantonalAnlassTeilnahmen();
			}
			tals.forEach(tal -> {
				if (tal.getNotenblatt().getGesamtPunktzahl() == 0.0f) {
					tal.getNotenblatt().setGesamtPunktzahl(
							bestPerAnlass.get(tal.getAnlass().getId()).subtract(BigDecimal.valueOf(5)).floatValue());
				}
			});
			smq.getDurchschnittlichePunktzahl();
		});
	}

	public Map<UUID, BigDecimal> getBestResults(List<Anlass> anlaesse, List<SmQualiAnlassTeilnahmen> perTeilnehmerList,
			boolean nurZTV, KategorieEnum kategorie) {
		Map<UUID, BigDecimal> anlassMap = new HashMap<UUID, BigDecimal>();
		/*
		 * if (!nurZTV) { anlaesse.stream().filter(anlass -> { return (nurZTV &&
		 * !anlass.isAusserkantonal()) || (!nurZTV && anlass.isAusserkantonal());
		 * }).forEach(anlass -> { switch (kategorie) { case K5:
		 * anlassMap.put(anlass.getId(), BigDecimal.valueOf(anlass.getSiegerTotalK5()));
		 * break; case K6: anlassMap.put(anlass.getId(),
		 * BigDecimal.valueOf(anlass.getSiegerTotalK6())); break; case KH:
		 * anlassMap.put(anlass.getId(), BigDecimal.valueOf(anlass.getSiegerTotalKH()));
		 * break; case K7: anlassMap.put(anlass.getId(),
		 * BigDecimal.valueOf(anlass.getSiegerTotalK7())); break; }
		 * 
		 * }); return anlassMap; }anlaesse.stream().filter(anlass->
		 * 
		 * { return (nurZTV && !anlass.isAusserkantonal()) || (!nurZTV &&
		 * anlass.isAusserkantonal()); }).forEach(anlass-> {
		 * anlassMap.put(anlass.getId(), BigDecimal.ZERO); });
		 * perTeilnehmerList.forEach(smq -> { List<TeilnehmerAnlassLink> tals =
		 * smq.getAnlassTeilnahmen(); tals.forEach(tal -> {
		 * System.out.println("Teilnehmer: " + tal.getTeilnehmer().getName() +
		 * ", Anlass: " + tal.getAnlass().getAnlassBezeichnung()); if
		 * (tal.getNotenblatt().getGesamtPunktzahl() != 0.0f) { BigDecimal maxWert =
		 * anlassMap.get(tal.getAnlass().getId()); BigDecimal punktzahl =
		 * BigDecimal.valueOf(tal.getNotenblatt().getGesamtPunktzahl()); if (punktzahl
		 * != null && maxWert.compareTo(punktzahl) < 0) {
		 * anlassMap.put(tal.getAnlass().getId(), punktzahl); } } }); });
		 */
		return anlassMap;
	}

	public List<SmQualiAnlassTeilnahmen> fillAllAnlaesse(int jahr, boolean nurSmQuali, TiTuEnum tiTu,
			KategorieEnum kategorie, List<SmQualiAnlassTeilnahmen> perTeilnehmerList, List<Anlass> anlaesse,
			boolean nurZTV) throws ServiceException {
		for (SmQualiAnlassTeilnahmen smq : perTeilnehmerList) {
			if (smq.getTeilnehmer().getName().equals("Wüest")) {
				System.out.println("Break");
			}
			Map<UUID, String> besuchteAnlaesse = anlaesse.stream().filter(anlass -> {
				return (nurZTV && !anlass.isAusserkantonal()) || (!nurZTV && anlass.isAusserkantonal());
			}).collect(Collectors.toMap(Anlass::getId, Anlass::getAnlassBezeichnung));

			List<TeilnehmerAnlassLink> tals = null;
			if (nurZTV) {
				// tals = smq.getAnlassTeilnahmen();
			} else {
				// tals = smq.getAusserKantonalAnlassTeilnahmen();
			}
			for (TeilnehmerAnlassLink tal : tals) {
				if (besuchteAnlaesse.containsKey(tal.getAnlass().getId())) {
					besuchteAnlaesse.put(tal.getAnlass().getId(), null);
				}
			}
			// Nicht besuchte Anlaesse mit - 5 Punkten
			TeilnehmerAnlassLink orgTal = null;
			/*
			 * if (smq.getAnlassTeilnahmen().size() > 0) orgTal =
			 * smq.getAnlassTeilnahmen().get(0); else if
			 * (smq.getAusserKantonalAnlassTeilnahmen().size() > 0) orgTal =
			 * smq.getAusserKantonalAnlassTeilnahmen().get(0); else continue;
			 */
			TeilnehmerAnlassLink orgTalFinal = orgTal;
			List<TeilnehmerAnlassLink> toAdd = new ArrayList<TeilnehmerAnlassLink>();
			besuchteAnlaesse.forEach((k, v) -> {
				Anlass currentAnlass = anlaesse.stream().filter(anlass -> anlass.getId() == k)
						.collect(Collectors.toList()).getFirst();
				if (v != null && currentAnlass.isSmQuali()) {
					TeilnehmerAnlassLink newTal = new TeilnehmerAnlassLink();
					newTal.setTeilnehmer(orgTalFinal.getTeilnehmer());
					newTal.setAnlass(currentAnlass);
					System.out.println("Anlass : " + newTal.getAnlass().getAnlassBezeichnung() + ",  für: "
							+ newTal.getTeilnehmer().getName());
					newTal.setOrganisation(orgTalFinal.getOrganisation());
					newTal.setNotenblatt(new Notenblatt());
					toAdd.add(newTal);
				}
			});
			if (nurZTV) {
				toAdd.forEach(newTal -> smq.addTeilnahme(newTal));
			} else {
				toAdd.forEach(newTal -> smq.addAusserKantonalAnlass(newTal));
			}
		}
		return perTeilnehmerList;
	}

	private void transferTotal(List<SmQualiAnlassTeilnahmen> perTeilnehmerList, boolean nurSmQuali) {
		/*
		 * perTeilnehmerList.stream().forEach(smq -> { int basis = 0; if (nurSmQuali) {
		 * basis = 1; } smq.getAnlassTeilnahmen().sort(SmQualiAnlassTeilnahmen::
		 * compareByAnlassStartDatum);
		 * smq.getAusserKantonalAnlassTeilnahmen().sort(SmQualiAnlassTeilnahmen::
		 * compareByAnlassStartDatum); // Frühlingswettkampf if (!nurSmQuali &&
		 * smq.getAnlassTeilnahmen().size() > 0 && smq.getAnlassTeilnahmen().get(0) !=
		 * null) { smq.setWettkampf1Punktzahl(
		 * BigDecimal.valueOf(smq.getAnlassTeilnahmen().get(0).getNotenblatt().
		 * getGesamtPunktzahl()) .setScale(3, RoundingMode.HALF_UP)); } // K5+ if
		 * (smq.getAnlassTeilnahmen().size() > 1 - basis &&
		 * smq.getAnlassTeilnahmen().get(1 - basis) != null) {
		 * smq.setWettkampf2Punktzahl(BigDecimal
		 * .valueOf(smq.getAnlassTeilnahmen().get(1 -
		 * basis).getNotenblatt().getGesamtPunktzahl()) .setScale(3,
		 * RoundingMode.HALF_UP)); } // TiTU if
		 * (TiTuEnum.Ti.equals(smq.getTeilnehmer().getTiTu())) { if
		 * (smq.getAnlassTeilnahmen().size() > 2 - basis &&
		 * smq.getAnlassTeilnahmen().get(2 - basis) != null) {
		 * smq.setWettkampf3Punktzahl(BigDecimal
		 * .valueOf(smq.getAnlassTeilnahmen().get(2 -
		 * basis).getNotenblatt().getGesamtPunktzahl()) .setScale(3,
		 * RoundingMode.HALF_UP)); } if (smq.getAnlassTeilnahmen().size() > 3 - basis &&
		 * smq.getAnlassTeilnahmen().get(3 - basis) != null) {
		 * smq.setKmsPunktzahl(BigDecimal .valueOf(smq.getAnlassTeilnahmen().get(3 -
		 * basis).getNotenblatt().getGesamtPunktzahl()) .setScale(3,
		 * RoundingMode.HALF_UP)); } if (smq.getAnlassTeilnahmen().size() > 4 - basis &&
		 * smq.getAnlassTeilnahmen().get(4 - basis) != null) {
		 * smq.setFinalPunktzahl(BigDecimal .valueOf(smq.getAnlassTeilnahmen().get(4 -
		 * basis).getNotenblatt().getGesamtPunktzahl()) .setScale(3,
		 * RoundingMode.HALF_UP)); } } else { if (smq.getAnlassTeilnahmen().size() > 2 -
		 * basis && smq.getAnlassTeilnahmen().get(2 - basis) != null) {
		 * smq.setKmsPunktzahl(BigDecimal .valueOf(smq.getAnlassTeilnahmen().get(2 -
		 * basis).getNotenblatt().getGesamtPunktzahl()) .setScale(3,
		 * RoundingMode.HALF_UP)); } if (smq.getAnlassTeilnahmen().size() > 3 - basis &&
		 * smq.getAnlassTeilnahmen().get(3 - basis) != null) {
		 * smq.setFinalPunktzahl(BigDecimal .valueOf(smq.getAnlassTeilnahmen().get(3 -
		 * basis).getNotenblatt().getGesamtPunktzahl()) .setScale(3,
		 * RoundingMode.HALF_UP)); }
		 * 
		 * if (smq.getAusserKantonalAnlassTeilnahmen().size() > 0 &&
		 * smq.getAusserKantonalAnlassTeilnahmen().get(0) != null) {
		 * smq.setAusserKantonal1Punktzahl(BigDecimal .valueOf(
		 * smq.getAusserKantonalAnlassTeilnahmen().get(0).getNotenblatt().
		 * getGesamtPunktzahl()) .setScale(3, RoundingMode.HALF_UP)); } if
		 * (smq.getAusserKantonalAnlassTeilnahmen().size() > 1 &&
		 * smq.getAusserKantonalAnlassTeilnahmen().get(1) != null) {
		 * smq.setAusserKantonal2Punktzahl(BigDecimal .valueOf(
		 * smq.getAusserKantonalAnlassTeilnahmen().get(1).getNotenblatt().
		 * getGesamtPunktzahl()) .setScale(3, RoundingMode.HALF_UP)); } }
		 * 
		 * });
		 */
	}
}
