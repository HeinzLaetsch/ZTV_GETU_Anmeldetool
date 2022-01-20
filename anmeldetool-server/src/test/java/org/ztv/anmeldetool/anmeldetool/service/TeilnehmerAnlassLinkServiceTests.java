package org.ztv.anmeldetool.anmeldetool.service;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;

import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.anmeldetool.repositories.TeilnehmerRepository;
import org.ztv.anmeldetool.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;
import org.ztv.anmeldetool.anmeldetool.util.TeilnehmerAnlassLinkMapper;

@SpringBootTest
@ActiveProfiles("eclipse")
@Disabled
public class TeilnehmerAnlassLinkServiceTests {

	@Autowired
	AnlassService anlassService;

	@Autowired
	TeilnehmerAnlassLinkService talService;

	@Autowired
	TeilnehmerService teilnehmerService;

	@Autowired
	TeilnehmerRepository teilnehmerRepository;

	@Autowired
	TeilnehmerAnlassLinkMapper talMapper;

	@Test
	public void testGetTeilnehmer() throws Exception {

		List<Anlass> anlaesse = anlassService.getAllAnlaesse();
		assertThat(anlaesse.size()).isGreaterThan(0);
		List<TeilnehmerAnlassLink> tals = talService.findAnlassTeilnahmen(anlaesse.get(0).getId());
		assertThat(tals.size()).isGreaterThan(0);
	}

	@Test
	public void testGetTeilnehmerWithStartnummer() throws Exception {

		List<Anlass> anlaesse = anlassService.getAllAnlaesse();
		assertThat(anlaesse.size()).isGreaterThan(0);
		List<TeilnehmerAnlassLink> talsStart = talService
				.getAllTeilnehmerForAnlassAndUpdateStartnummern(anlaesse.get(0).getId());
		assertThat(talsStart.size()).isGreaterThan(0);
	}

	@Test
	public void testTeilnehmerMapper() throws Exception {
		List<Anlass> anlaesse = anlassService.getAllAnlaesse();
		assertThat(anlaesse.size()).isGreaterThan(0);
		List<TeilnehmerAnlassLink> tals = talService.findAnlassTeilnahmen(anlaesse.get(0).getId());
		TeilnehmerAnlassLink tal = tals.get(0);
		TeilnehmerAnlassLinkDTO talDto = talMapper.toDto(tal);
		TeilnehmerAnlassLink tal2 = talMapper.toEntity(talDto);
		assertThat(tal.getTeilnehmer().getId()).isEqualByComparingTo(tal2.getTeilnehmer().getId());
	}
}
