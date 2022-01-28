package org.ztv.anmeldetool.anmeldetool.service;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.AnlassLauflisten;
import org.ztv.anmeldetool.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.anmeldetool.models.LauflistenContainer;
import org.ztv.anmeldetool.anmeldetool.repositories.AnlassRepository;

@SpringBootTest
@ActiveProfiles("eclipse")
public class LauflistenServiceTests {

	@Autowired
	LauflistenService lauflistenService;

	@Autowired
	AnlassRepository anlassRepo;

	@Test
	public void testFindLauflistenForAnlassAndKategorie() throws Exception {
		Iterable<Anlass> iterable = anlassRepo.findAll();
		List<LauflistenContainer> allContainer = lauflistenService
				.findLauflistenForAnlassAndKategorie(iterable.iterator().next(), KategorieEnum.K1);
		assertThat(allContainer.size()).isGreaterThan(0);
	}

	@Test
	public void testGenerateLauflistenForAnlassAndKategorie() throws Exception {
		Iterable<Anlass> iterable = anlassRepo.findAll();
		AnlassLauflisten anlassContainer = lauflistenService
				.generateLauflistenForAnlassAndKategorie(iterable.iterator().next(), KategorieEnum.K1);
		assertThat(anlassContainer).isNotNull();
	}
}
