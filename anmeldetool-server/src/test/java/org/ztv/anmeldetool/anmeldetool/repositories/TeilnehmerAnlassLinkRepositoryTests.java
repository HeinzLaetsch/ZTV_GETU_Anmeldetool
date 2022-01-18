package org.ztv.anmeldetool.anmeldetool.repositories;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("eclipse")
public class TeilnehmerAnlassLinkRepositoryTests {

	@Autowired
	TeilnehmerAnlassLinkRepository talRepo;

	@Test
	public void testGetTeilnehmer() throws Exception {

		long anzahl = talRepo.count();
		assertThat(anzahl).isBetween(0l, 1000l);

	}
}
