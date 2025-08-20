package org.ztv.anmeldetool.util;

import org.ztv.anmeldetool.repositories.OrganisationsRepository;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class OrganisationBezeichnungTransformer {

	public static void splitOrganisationName(OrganisationsRepository orgRepo) {
		orgRepo.findAll().stream().forEach(org -> {
			log.info("Bezeichung {}, Vereinsname neu {}",
					org.getName().substring(0, org.getName().lastIndexOf(org.cleanName(false))), org.cleanName(false));
			org.setBezeichnung(org.getName().substring(0, org.getName().lastIndexOf(org.cleanName(false))));
			orgRepo.save(org);
		});
	}
}
