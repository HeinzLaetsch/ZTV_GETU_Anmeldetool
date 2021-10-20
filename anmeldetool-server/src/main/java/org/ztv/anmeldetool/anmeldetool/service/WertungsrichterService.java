package org.ztv.anmeldetool.anmeldetool.service;

import java.util.Calendar;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.anmeldetool.models.Person;
import org.ztv.anmeldetool.anmeldetool.models.Wertungsrichter;
import org.ztv.anmeldetool.anmeldetool.repositories.WertungsrichterRepository;
import org.ztv.anmeldetool.anmeldetool.transfer.WertungsrichterDTO;

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

	public Wertungsrichter getWertungsrichterByPersonId(UUID id) {
		Optional<Wertungsrichter> opt = wertungsrichterRepo.findByPersonId(id);
		if (opt.isPresent()) {
			return opt.get();
		}
		return null;
	}
	
	public ResponseEntity<WertungsrichterDTO> getWertungsrichterForUserId(String id) {
		Wertungsrichter wr = getWertungsrichterByPersonId(UUID.fromString(id));
		if (wr != null) {
			WertungsrichterDTO wrDTO = WertungsrichterDTO.builder().personId(UUID.fromString(id)).aktiv(wr.isAktiv()).brevet(wr.getBrevet()).gueltig(wr.isGueltig()).id(wr.getId()).letzterFk(wr.getLetzterFk()).build();
			return ResponseEntity.ok(wrDTO);
		}
		return ResponseEntity.notFound().build();
	}

	public ResponseEntity<WertungsrichterDTO> update(String id, WertungsrichterDTO wertungsrichterDTO) {
		if (wertungsrichterDTO.getId() == null) {
			Person person = personSrv.findPersonById(UUID.fromString(id));
			Wertungsrichter wr = Wertungsrichter.builder().person(person).brevet(wertungsrichterDTO.getBrevet()).letzterFk(wertungsrichterDTO.getLetzterFk()).build();
			wr.setAktiv(wertungsrichterDTO.isAktiv());
			wr.setGueltig(wertungsrichterDTO.isGueltig());
			wr.setChangeDate(Calendar.getInstance());
			wr = wertungsrichterRepo.save(wr);
			WertungsrichterDTO wrDTO = WertungsrichterDTO.builder().personId(UUID.fromString(id)).aktiv(wr.isAktiv()).brevet(wr.getBrevet()).gueltig(wr.isGueltig()).id(wr.getId()).letzterFk(wr.getLetzterFk()).build();
			return ResponseEntity.ok(wrDTO);			
		}
		Wertungsrichter wr = getWertungsrichterByPersonId(UUID.fromString(id));
		if (wr != null) {
			wr.setBrevet(wertungsrichterDTO.getBrevet());
			wr = wertungsrichterRepo.save(wr);
			WertungsrichterDTO wrDTO = WertungsrichterDTO.builder().personId(UUID.fromString(id)).aktiv(wr.isAktiv()).brevet(wr.getBrevet()).gueltig(wr.isGueltig()).id(wr.getId()).letzterFk(wr.getLetzterFk()).build();
			return ResponseEntity.ok(wrDTO);
		}
		return ResponseEntity.notFound().build();
	}
}
