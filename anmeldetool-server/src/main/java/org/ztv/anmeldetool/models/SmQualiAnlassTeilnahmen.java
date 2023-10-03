package org.ztv.anmeldetool.models;

import java.math.BigDecimal;

import lombok.Getter;
import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

@Getter
@Setter
@Slf4j
public class SmQualiAnlassTeilnahmen {
	// private Teilnehmer teilnehmer;

	// private BigDecimal durchschnittlichePunktzahl;

	// private BigDecimal wettkampf1Punktzahl;
	private TeilnehmerAnlassLink fruehlingswettkampf;

	// private BigDecimal wettkampf2Punktzahl;
	private TeilnehmerAnlassLink k5;

	private BigDecimal wettkampf3Punktzahl;
	private TeilnehmerAnlassLink getuInnentage;

	// private BigDecimal kmsPunktzahl;
	private TeilnehmerAnlassLink kms;

	// private BigDecimal finalPunktzahl;
	private TeilnehmerAnlassLink kantonalfinal;

	// private BigDecimal ausserKantonal1Punktzahl;
	private TeilnehmerAnlassLink ausserKantonal1;

	// private BigDecimal ausserKantonal2Punktzahl;
	private TeilnehmerAnlassLink ausserKantonal2;

	// private Map<GeraetEnum, List<Einzelnote>> einzelnoten;

	// private Map<GeraetEnum, BigDecimal> durchschnittlicheEinzelnoten;

	// private List<TeilnehmerAnlassLink> anlassTeilnahmen;

	// private List<TeilnehmerAnlassLink> ausserKantonalAnlassTeilnahmen;

	public SmQualiAnlassTeilnahmen() {
		/*
		 * anlassTeilnahmen = new ArrayList<TeilnehmerAnlassLink>();
		 * ausserKantonalAnlassTeilnahmen = new ArrayList<TeilnehmerAnlassLink>();
		 * durchschnittlicheEinzelnoten = new HashMap<GeraetEnum, BigDecimal>();
		 */
	}

	// Sorter Methoden
	public static int compareByDurchschnittlichePunktzahl(SmQualiAnlassTeilnahmen smq1, SmQualiAnlassTeilnahmen smq2) {
		return smq2.getDurchschnittlichePunktzahl().compareTo(smq1.getDurchschnittlichePunktzahl());
	}

	public static int compareByAnlassStartDatum(TeilnehmerAnlassLink anlass1, TeilnehmerAnlassLink anlass2) {
		return anlass1.getAnlass().getStartDate().compareTo(anlass2.getAnlass().getStartDate());
	}

	public Teilnehmer getTeilnehmer() {
		if (fruehlingswettkampf != null) {
			return fruehlingswettkampf.getTeilnehmer();
		}
		if (k5 != null) {
			return k5.getTeilnehmer();
		}
		if (kms != null) {
			return kms.getTeilnehmer();
		}
		if (kantonalfinal != null) {
			return kantonalfinal.getTeilnehmer();
		}
		if (ausserKantonal1 != null) {
			return ausserKantonal1.getTeilnehmer();
		}
		if (ausserKantonal2 != null) {
			return ausserKantonal2.getTeilnehmer();
		}
		this.log.debug("Keine Anlässe gesetzt, es kann kein Teilnehmer zurückgegeben werden");
		return null;
	}

	public BigDecimal getDurchschnittlichePunktzahl() {
		/*
		 * this.durchschnittlichePunktzahl = BigDecimal.ZERO; // Alle Wettkaempfe in
		 * Array // Je nach Final, SM die besten 2 oder die besten 3 inkl. einem
		 * Ausserkantonalen // nehmen List<BigDecimal> allResults = new
		 * ArrayList<BigDecimal>();
		 * 
		 * for (TeilnehmerAnlassLink tal : anlassTeilnahmen) {
		 * allResults.add(BigDecimal.valueOf(tal.getNotenblatt().getGesamtPunktzahl()));
		 * } if (TiTuEnum.Tu.equals(teilnehmer.getTiTu())) { BigDecimal ausserkantonal =
		 * getBesseresResultat(); if (!ausserkantonal.equals(BigDecimal.ZERO)) {
		 * allResults.add(ausserkantonal); } } Collections.sort(allResults,
		 * Collections.reverseOrder());
		 * 
		 * BigDecimal anzahl = BigDecimal.valueOf(1l); this.durchschnittlichePunktzahl =
		 * this.durchschnittlichePunktzahl.add(allResults.get(0)); if (allResults.size()
		 * > 1) { this.durchschnittlichePunktzahl =
		 * this.durchschnittlichePunktzahl.add(allResults.get(1)); anzahl =
		 * BigDecimal.valueOf(2l); }
		 * 
		 * if (allResults.size() == 0) { System.out.println(teilnehmer.getName()); }
		 * else { this.durchschnittlichePunktzahl =
		 * this.durchschnittlichePunktzahl.divide(anzahl, 3, RoundingMode.HALF_UP); }
		 * return this.durchschnittlichePunktzahl;
		 */
		return BigDecimal.ZERO;
	}

	private BigDecimal getBesseresResultat() {
		/*
		 * if (ausserKantonalAnlassTeilnahmen.size() > 0) { if
		 * (ausserKantonalAnlassTeilnahmen.size() > 1) { if
		 * (ausserKantonalAnlassTeilnahmen.get(0).getNotenblatt().getGesamtPunktzahl()
		 * != 0.0f && ausserKantonalAnlassTeilnahmen.get(0).getNotenblatt()
		 * .getGesamtPunktzahl() > ausserKantonalAnlassTeilnahmen.get(1).getNotenblatt()
		 * .getGesamtPunktzahl()) { return BigDecimal
		 * .valueOf(ausserKantonalAnlassTeilnahmen.get(0).getNotenblatt().
		 * getGesamtPunktzahl()); } else if
		 * (ausserKantonalAnlassTeilnahmen.get(1).getNotenblatt().getGesamtPunktzahl()
		 * != 0.0f) { return BigDecimal
		 * .valueOf(ausserKantonalAnlassTeilnahmen.get(1).getNotenblatt().
		 * getGesamtPunktzahl()); } } else { return
		 * BigDecimal.valueOf(ausserKantonalAnlassTeilnahmen.get(0).getNotenblatt().
		 * getGesamtPunktzahl()); } }
		 */
		return BigDecimal.ZERO;
	}

	public void addTeilnahme(TeilnehmerAnlassLink tal) {
		// anlassTeilnahmen.add(tal);
	}

	public void addAusserKantonalAnlass(TeilnehmerAnlassLink tal) {
		// ausserKantonalAnlassTeilnahmen.add(tal);
	}

	public void calcDurchschnittEinzelnoten() {
		/*
		 * Map<GeraetEnum, List<Einzelnote>> einzelnoten = new HashMap<GeraetEnum,
		 * List<Einzelnote>>(); // ueber alle TAL if (anlassTeilnahmen.size() > 0)
		 * System.out.println(anlassTeilnahmen.get(0).getAnlass().getAnlassBezeichnung()
		 * + "  " + anlassTeilnahmen.get(0).getTeilnehmer().getName());
		 * 
		 * for (GeraetEnum g : GeraetEnum.values()) { if (GeraetEnum.UNDEFINED.equals(g)
		 * || (GeraetEnum.BARREN.equals(g) && TiTuEnum.Ti.equals(teilnehmer.getTiTu())))
		 * { continue; } // System.out.println("Gerät " + g); List<Einzelnote>
		 * einzelnotenArray = null; // if (!durchschnittlicheEinzelnoten.containsKey(g))
		 * { if (!einzelnoten.containsKey(g)) { einzelnotenArray = new
		 * ArrayList<Einzelnote>(); einzelnoten.put(g, einzelnotenArray); } else { //
		 * System.out.println("Noten " + durchschnittlicheEinzelnoten); if
		 * (einzelnoten.get(g) == null) { System.out.println("Break"); }
		 * einzelnotenArray = einzelnoten.get(g); if (einzelnotenArray == null) {
		 * System.out.println("Break"); } } final List<Einzelnote> einzelnotenFinal =
		 * einzelnotenArray; anlassTeilnahmen.forEach(tal -> { if
		 * (!(GeraetEnum.BARREN.equals(g) &&
		 * TiTuEnum.Ti.equals(tal.getTeilnehmer().getTiTu()))) { Einzelnote einz =
		 * tal.getNotenblatt().getEinzelnoteForGeraet(g); if (einz == null ||
		 * einzelnotenFinal == null) { System.out.println("Break"); }
		 * einzelnotenFinal.add(einz); } }); ausserKantonalAnlassTeilnahmen.forEach(tal
		 * -> { if (!(GeraetEnum.BARREN.equals(g) &&
		 * TiTuEnum.Ti.equals(tal.getTeilnehmer().getTiTu()))) { Einzelnote einz =
		 * tal.getNotenblatt().getEinzelnoteForGeraet(g); if (einz == null ||
		 * einzelnotenFinal == null) { System.out.println("Break"); } else {
		 * einzelnotenFinal.add(einz); } } }); } for (GeraetEnum g :
		 * GeraetEnum.values()) { if (GeraetEnum.UNDEFINED.equals(g) ||
		 * (GeraetEnum.BARREN.equals(g) && TiTuEnum.Ti.equals(teilnehmer.getTiTu()))) {
		 * continue; } int anzahl = 0; BigDecimal summe = BigDecimal.ZERO; for
		 * (Einzelnote einzelnote : einzelnoten.get(g)) { if (einzelnote.getZaehlbar() >
		 * 0 || einzelnote.getNote_1() > 0) { if (GeraetEnum.SPRUNG.equals(g)) { summe =
		 * summe.add(BigDecimal.valueOf(einzelnote.getZaehlbar())); } else { summe =
		 * summe.add(BigDecimal.valueOf(einzelnote.getNote_1())); } anzahl++; } } if
		 * (anzahl > 0) { durchschnittlicheEinzelnoten.put(g,
		 * summe.divide(BigDecimal.valueOf(anzahl), 3, RoundingMode.HALF_UP)); } }
		 * BigDecimal tmp = this.getDurchschnittlichePunktzahl();
		 */
	}
}
