package org.ztv.anmeldetool.anmeldetool.service;

import java.util.List;
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
		List<Wertungsrichter> wrList = wertungsrichterRepo.findByPersonId(id);
		if (wrList != null && wrList.size() > 0)
			return Optional.of(wrList.get(0));
		else
			return Optional.empty();
	}

	public Optional<Wertungsrichter> getWertungsrichterForUser(Person person) {
		Optional<Wertungsrichter> optWr = getWertungsrichterByPersonId(person.getId());
		return optWr;
	}

	public Wertungsrichter update(Wertungsrichter wertungsrichter) {
		wertungsrichter = wertungsrichterRepo.save(wertungsrichter);
		wertungsrichter.getPerson().setWertungsrichter(wertungsrichter);
		personSrv.create(wertungsrichter.getPerson(), false);
		return wertungsrichter;
	}

	public void delete(Wertungsrichter wertungsrichter) {
		wertungsrichter.getPerson().setWertungsrichter(null);
		personSrv.create(wertungsrichter.getPerson(), false);
		wertungsrichterRepo.delete(wertungsrichter);
	}

}
