package org.ztv.anmeldetool.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.Verband;
import org.ztv.anmeldetool.repositories.VerbandsRepository;
import org.ztv.anmeldetool.transfer.VerbandDTO;

import lombok.extern.slf4j.Slf4j;

@Service("verbandService")
@Slf4j
public class VerbandService {
	
	@Autowired
	VerbandsRepository verbandRepo;
	
	public Verband getVerband(UUID verbandId) {
		Optional<Verband> verbandOpt = verbandRepo.findById(verbandId);
		if (verbandOpt.isPresent()) {
			return verbandOpt.get();
		}
		return null;
	}

	public ResponseEntity<Collection<VerbandDTO>> findByVerband(String verbandAbkz) {
		Iterable<Verband> verbaende = verbandRepo.findByVerband(verbandAbkz);
		Collection<VerbandDTO> verbaendeDTO = new ArrayList<VerbandDTO>();
		for (Verband verband : verbaende) {
			VerbandDTO verbandDTO = VerbandDTO.builder().id(verband.getId()).verband(verband.getVerband())
				.verband_long(verband.getVerbandLong()).build();
			verbaendeDTO.add(verbandDTO);
		}
		return ResponseEntity.ok(verbaendeDTO);
	}

	public ResponseEntity<Collection<VerbandDTO>> getVerbaende() {
		Iterable<Verband> verbaende = verbandRepo.findAllByAktivOrderByVerband(true);
		Collection<VerbandDTO> verbaendeDTO = new ArrayList<VerbandDTO>();
		for (Verband verband : verbaende) {
			verbaendeDTO.add(VerbandDTO.builder().id(verband.getId()).verband(verband.getVerband())
					.verband_long(verband.getVerbandLong()).build());
		}
		return ResponseEntity.ok(verbaendeDTO);
	}
}
