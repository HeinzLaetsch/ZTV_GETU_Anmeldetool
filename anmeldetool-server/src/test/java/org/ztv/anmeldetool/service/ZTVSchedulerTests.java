package org.ztv.anmeldetool.service;

import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("eclipse")
@Disabled
public class ZTVSchedulerTests {

	@Autowired
	ZTVScheduler ztvScheduler;

	@Test
	public void testDeleteAllLauflistenForAnlassAndKategorie() throws Exception {
		ztvScheduler.publishedCheck();
	}
}
