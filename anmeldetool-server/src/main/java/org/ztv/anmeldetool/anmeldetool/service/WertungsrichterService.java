package org.ztv.anmeldetool.anmeldetool.service;

import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.anmeldetool.models.Person;
import org.ztv.anmeldetool.anmeldetool.models.Wertungsrichter;
import org.ztv.anmeldetool.anmeldetool.repositories.WertungsrichterRepository;

import lombok.extern.slf4j.Slf4j;

@Service("wertungsrichterService")
@Slf4j
public class WertungsrichterService {

	@Autowired
	WertungsrichterRepository wertungsrichterRepo;

	@Autowired
	PersonService personSrv;

	public Wertungsrichter getWertungsrichter(UUID id) {
		Optional<Wertungsrichter> opt = wertungsrichterRepo.findById(id);
		if (opt.isPresent()) {
			return opt.get();
		}
		return null;
	}

	public Optional<Wertungsrichter> getWertungsrichterByPersonId(UUID id) {
		Optional<Wertungsrichter> opt = wertungsrichterRepo.findByPersonId(id);
		return opt;
	}

	public Optional<Wertungsrichter> getWertungsrichterForUser(Person person) {
		Optional<Wertungsrichter> optWr = getWertungsrichterByPersonId(person.getId());
		return optWr;
	}

	public Wertungsrichter update(Wertungsrichter wertungsrichter) {
		wertungsrichter = wertungsrichterRepo.save(wertungsrichter);
		return wertungsrichter;
	}
}
