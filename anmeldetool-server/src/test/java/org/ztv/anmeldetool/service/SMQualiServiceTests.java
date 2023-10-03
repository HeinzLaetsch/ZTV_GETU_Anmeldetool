package org.ztv.anmeldetool.service;

import java.util.List;

import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.SmQualiAnlassTeilnahmen;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;

@SpringBootTest
@ActiveProfiles("eclipse")
@Disabled
public class SMQualiServiceTests {

	@Autowired
	AnlassService anlassService;

	@Autowired
	SmQualiService smQualiService;

	private void printResult(List<SmQualiAnlassTeilnahmen> anlassTeilnahmen) {
		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			smq.calcDurchschnittEinzelnoten();
		}
		System.out.println(anlassTeilnahmen.size());
		/*
		 * for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
		 * System.out.println("Name: " + smq.getTeilnehmer().getName() +
		 * ",  Punktzahl: " + smq.getDurchschnittlichePunktzahl() + " , Wettkampf 1: " +
		 * smq.getWettkampf1Punktzahl() + " , Wettkampf 2: " +
		 * smq.getWettkampf2Punktzahl() + " , Wettkampf 3: " +
		 * smq.getWettkampf3Punktzahl() + " , Ausser 1: " +
		 * smq.getAusserKantonal1Punktzahl() + " , Ausser 2: " +
		 * smq.getAusserKantonal2Punktzahl() + " , KMS: " + smq.getKmsPunktzahl() +
		 * " , Final: " + smq.getFinalPunktzahl()); }
		 */
	}

	@Test
	public void testGetTiQuali() throws Exception {
		List<Anlass> anlaesse = anlassService.getAnlaesseFiltered(2023, true, TiTuEnum.Ti);
		System.out.println(anlaesse.size());
		// assertThat(anlaesse.size()).isEqualTo(2);
	}

	@Test
	public void testGetTuQuali() throws Exception {
		List<Anlass> anlaesse = anlassService.getAnlaesseFiltered(2023, true, TiTuEnum.Tu);
		System.out.println(anlaesse.size());
		// assertThat(anlaesse.size()).isEqualTo(2);
	}

	@Test
	public void testGetTiAll() throws Exception {
		List<Anlass> anlaesse = anlassService.getAnlaesseFiltered(2023, false, TiTuEnum.Ti);
		System.out.println(anlaesse.size());
		// assertThat(anlaesse.size()).isEqualTo(3);
	}

	@Test
	public void testSmTeilnahmenK7() throws Exception {
		List<List<TeilnehmerAnlassLink>> teilnahmen = smQualiService.getTeilnahmen(2023, false, TiTuEnum.Ti,
				KategorieEnum.K7);
		System.out.println(teilnahmen.size());
		// assertThat(teilnahmen.size()).isEqualTo(3);
	}

	@Test
	@Disabled
	public void testSmAnlassTeilnahmenK7() throws Exception {
		List<SmQualiAnlassTeilnahmen> anlassTeilnahmen = smQualiService.getAnlassTeilnahmen(2023, false, TiTuEnum.Ti,
				KategorieEnum.K7);
		System.out.println(anlassTeilnahmen.size());
		// assertThat(anlassTeilnahmen.size()).isEqualTo(29);
	}

	@Test
	public void testSmCalcK7() throws Exception {
		List<SmQualiAnlassTeilnahmen> anlassTeilnahmen = smQualiService.getAnlassTeilnahmen(2023, false, TiTuEnum.Ti,
				KategorieEnum.K7);

		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			smq.calcDurchschnittEinzelnoten();
		}
		System.out.println(anlassTeilnahmen.size());
		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			System.out.println(
					"Name: " + smq.getTeilnehmer().getName() + ",  Punktzahl: " + smq.getDurchschnittlichePunktzahl());
		}

		// assertThat(anlassTeilnahmen.size()).isEqualTo(28);
	}

	@Test
	public void testSmCalcNurQualiK7() throws Exception {
		List<SmQualiAnlassTeilnahmen> anlassTeilnahmen = smQualiService.getAnlassTeilnahmen(2023, true, TiTuEnum.Ti,
				KategorieEnum.K7);
		printResult(anlassTeilnahmen);
	}

	@Test
	public void testSmCalcK6() throws Exception {
		List<SmQualiAnlassTeilnahmen> anlassTeilnahmen = smQualiService.getAnlassTeilnahmen(2023, false, TiTuEnum.Ti,
				KategorieEnum.K6);

		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			smq.calcDurchschnittEinzelnoten();
		}
		System.out.println(anlassTeilnahmen.size());
		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			System.out.println(
					"Name: " + smq.getTeilnehmer().getName() + ",  Punktzahl: " + smq.getDurchschnittlichePunktzahl());
		}

		// assertThat(anlassTeilnahmen.size()).isEqualTo(99);
	}

	@Test
	public void testSmCalcNurQualiK6() throws Exception {
		List<SmQualiAnlassTeilnahmen> anlassTeilnahmen = smQualiService.getAnlassTeilnahmen(2023, true, TiTuEnum.Ti,
				KategorieEnum.K6);

		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			smq.calcDurchschnittEinzelnoten();
		}
		System.out.println(anlassTeilnahmen.size());
		// assertThat(anlassTeilnahmen.size()).isEqualTo(24);

		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			System.out.println(
					"Name: " + smq.getTeilnehmer().getName() + ",  Punktzahl: " + smq.getDurchschnittlichePunktzahl());
		}
	}

	@Test
	public void testSmCalcK5A() throws Exception {
		List<SmQualiAnlassTeilnahmen> anlassTeilnahmen = smQualiService.getAnlassTeilnahmen(2023, false, TiTuEnum.Ti,
				KategorieEnum.K5A);

		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			smq.calcDurchschnittEinzelnoten();
		}
		System.out.println(anlassTeilnahmen.size());
		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			System.out.println(
					"Name: " + smq.getTeilnehmer().getName() + ",  Punktzahl: " + smq.getDurchschnittlichePunktzahl());
		}

		// assertThat(anlassTeilnahmen.size()).isEqualTo(178);
	}

	@Test
	public void testSmCalcNurQualiK5A() throws Exception {
		List<SmQualiAnlassTeilnahmen> anlassTeilnahmen = smQualiService.getAnlassTeilnahmen(2023, true, TiTuEnum.Ti,
				KategorieEnum.K5A);

		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			smq.calcDurchschnittEinzelnoten();
		}
		System.out.println(anlassTeilnahmen.size());
		// assertThat(anlassTeilnahmen.size()).isEqualTo(24);

		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			System.out.println(
					"Name: " + smq.getTeilnehmer().getName() + ",  Punktzahl: " + smq.getDurchschnittlichePunktzahl());
		}
	}

	@Test
	public void testSmCalcKD() throws Exception {
		List<SmQualiAnlassTeilnahmen> anlassTeilnahmen = smQualiService.getAnlassTeilnahmen(2023, false, TiTuEnum.Ti,
				KategorieEnum.KD);

		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			smq.calcDurchschnittEinzelnoten();
		}
		System.out.println(anlassTeilnahmen.size());
		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			System.out.println(
					"Name: " + smq.getTeilnehmer().getName() + ",  Punktzahl: " + smq.getDurchschnittlichePunktzahl());
		}

		// assertThat(anlassTeilnahmen.size()).isEqualTo(178);
	}

	@Test
	public void testSmCalcNurQualiKD() throws Exception {
		List<SmQualiAnlassTeilnahmen> anlassTeilnahmen = smQualiService.getAnlassTeilnahmen(2023, true, TiTuEnum.Ti,
				KategorieEnum.KD);

		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			smq.calcDurchschnittEinzelnoten();
		}
		System.out.println(anlassTeilnahmen.size());
		// assertThat(anlassTeilnahmen.size()).isEqualTo(24);

		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			System.out.println(
					"Name: " + smq.getTeilnehmer().getName() + ",  Punktzahl: " + smq.getDurchschnittlichePunktzahl());
		}
	}

	@Test
	public void testSmCalcQualiK7Tu() throws Exception {
		List<SmQualiAnlassTeilnahmen> anlassTeilnahmen = smQualiService.getAnlassTeilnahmen(2023, false, TiTuEnum.Tu,
				KategorieEnum.K7);

		printResult(anlassTeilnahmen);

		// assertThat(anlassTeilnahmen.size()).isEqualTo(17);
	}

	@Test
	public void testSmCalcQualiK7TuNurQuali() throws Exception {
		List<SmQualiAnlassTeilnahmen> anlassTeilnahmen = smQualiService.getAnlassTeilnahmen(2023, true, TiTuEnum.Tu,
				KategorieEnum.K7);

		printResult(anlassTeilnahmen);

		// assertThat(anlassTeilnahmen.size()).isEqualTo(17);
	}

	@Test
	public void testSmCalcQualiK6Tu() throws Exception {
		List<SmQualiAnlassTeilnahmen> anlassTeilnahmen = smQualiService.getAnlassTeilnahmen(2023, false, TiTuEnum.Tu,
				KategorieEnum.K6);

		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			smq.calcDurchschnittEinzelnoten();
		}
		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			System.out.println(smq.getTeilnehmer().getName() + " Pkt:" + smq.getDurchschnittlichePunktzahl());
		}

		// assertThat(anlassTeilnahmen.size()).isEqualTo(17);
	}

	@Test
	public void testSmCalcQualiK6TuNurQuali() throws Exception {
		List<SmQualiAnlassTeilnahmen> anlassTeilnahmen = smQualiService.getAnlassTeilnahmen(2023, true, TiTuEnum.Tu,
				KategorieEnum.K6);

		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			smq.calcDurchschnittEinzelnoten();
		}
		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			System.out.println(smq.getTeilnehmer().getName() + " Pkt:" + smq.getDurchschnittlichePunktzahl());
		}

		// assertThat(anlassTeilnahmen.size()).isEqualTo(17);
	}

	@Test
	public void testSmCalcQualiK5Tu() throws Exception {
		List<SmQualiAnlassTeilnahmen> anlassTeilnahmen = smQualiService.getAnlassTeilnahmen(2023, false, TiTuEnum.Tu,
				KategorieEnum.K5);

		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			smq.calcDurchschnittEinzelnoten();
		}
		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			System.out.println(smq.getTeilnehmer().getName() + " Pkt:" + smq.getDurchschnittlichePunktzahl());
		}

		// assertThat(anlassTeilnahmen.size()).isEqualTo(17);
	}

	@Test
	public void testSmCalcQualiK5TuNurQuali() throws Exception {
		List<SmQualiAnlassTeilnahmen> anlassTeilnahmen = smQualiService.getAnlassTeilnahmen(2023, true, TiTuEnum.Tu,
				KategorieEnum.K5);

		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			smq.calcDurchschnittEinzelnoten();
		}
		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			System.out.println(smq.getTeilnehmer().getName() + " Pkt:" + smq.getDurchschnittlichePunktzahl());
		}

		// assertThat(anlassTeilnahmen.size()).isEqualTo(17);
	}

	@Test
	public void testSmCalcNurQualiK5() throws Exception {
		List<SmQualiAnlassTeilnahmen> anlassTeilnahmen = smQualiService.getAnlassTeilnahmen(2023, true, TiTuEnum.Ti,
				KategorieEnum.K5A);

		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			smq.calcDurchschnittEinzelnoten();
		}
		System.out.println(anlassTeilnahmen.size());
		// assertThat(anlassTeilnahmen.size()).isEqualTo(24);

		for (SmQualiAnlassTeilnahmen smq : anlassTeilnahmen) {
			System.out.println(
					"Name: " + smq.getTeilnehmer().getName() + ",  Punktzahl: " + smq.getDurchschnittlichePunktzahl());
		}
	}
}
