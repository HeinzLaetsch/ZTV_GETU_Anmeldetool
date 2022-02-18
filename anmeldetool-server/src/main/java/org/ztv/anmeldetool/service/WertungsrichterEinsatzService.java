package org.ztv.anmeldetool.service;

import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.WertungsrichterEinsatz;
import org.ztv.anmeldetool.repositories.WertungsrichterEinsatzRepository;

import lombok.extern.slf4j.Slf4j;

@Service("wertungsrichterEinsatzService")
@Slf4j
public class WertungsrichterEinsatzService {

	@Autowired
	WertungsrichterEinsatzRepository wertungsrichterEinsatzRepository;

	public WertungsrichterEinsatz getWertungsrichterEinsatz(UUID id) {
		Optional<WertungsrichterEinsatz> opt = wertungsrichterEinsatzRepository.findById(id);
		if (opt.isPresent()) {
			return opt.get();
		}
		return null;
	}

	public WertungsrichterEinsatz update(WertungsrichterEinsatz wertungsrichterEinsatz) {
		if (wertungsrichterEinsatz != null && wertungsrichterEinsatz.getId() != null) {
			WertungsrichterEinsatz temp = getWertungsrichterEinsatz(wertungsrichterEinsatz.getId());
			if (temp != null) {
				log.debug(temp.getId().toString());
				temp.setEingesetzt(wertungsrichterEinsatz.isEingesetzt());
				wertungsrichterEinsatz = wertungsrichterEinsatzRepository.save(temp);
				return wertungsrichterEinsatz;
			}
		}
		wertungsrichterEinsatz = wertungsrichterEinsatzRepository.save(wertungsrichterEinsatz);
		return wertungsrichterEinsatz;
	}
}
