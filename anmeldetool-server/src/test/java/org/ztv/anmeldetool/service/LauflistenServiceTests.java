package org.ztv.anmeldetool.service;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;

import jakarta.transaction.Transactional;

import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.AnlassLauflisten;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.LauflistenContainer;
import org.ztv.anmeldetool.repositories.AnlassRepository;

@SpringBootTest
@ActiveProfiles("eclipse")
@Disabled
public class LauflistenServiceTests {

	@Autowired
	LauflistenService lauflistenService;

	@Autowired
	AnlassRepository anlassRepo;

	@Test
	// @Transactional
	public void testDeleteAllLauflistenForAnlassAndKategorie() throws Exception {
		Iterable<Anlass> iterable = anlassRepo.findAll();
		int anzahl = lauflistenService.deleteLauflistenForAnlassAndKategorie(iterable.iterator().next().getId(),
				KategorieEnum.K1, AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_1);
	}

	@Test
	public void testFindLauflistenForAnlassAndKategorie() throws Exception {
		Iterable<Anlass> iterable = anlassRepo.findAll();
		List<LauflistenContainer> allContainer = lauflistenService.findLauflistenForAnlassAndKategorie(
				iterable.iterator().next().getId(), KategorieEnum.K1, AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_1);
		assertThat(allContainer.size()).isGreaterThan(0);
	}

	@Test
	@Transactional
	public void testDeleteLauflistenForAnlassAndKategorie() throws Exception {
		testGenerateLauflistenForAnlassAndKategorie();
		Iterable<Anlass> iterable = anlassRepo.findAll();
		int anzahl = lauflistenService.deleteLauflistenForAnlassAndKategorie(iterable.iterator().next().getId(),
				KategorieEnum.K1, AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_1);
		assertThat(anzahl).isEqualTo(5);
	}

	@Test
	@Transactional
	public void testGenerateLauflistenForAnlassAndKategorie() throws Exception {
		Iterable<Anlass> iterable = anlassRepo.findAll();
		AnlassLauflisten anlassContainer = lauflistenService.generateLauflistenForAnlassAndKategorie(
				iterable.iterator().next().getId(), KategorieEnum.K1, AbteilungEnum.ABTEILUNG_1, AnlageEnum.ANLAGE_1, false);
		assertThat(anlassContainer).isNotNull();
		assertThat(anlassContainer.getLauflistenContainer().size()).isEqualTo(5);
	}
}
