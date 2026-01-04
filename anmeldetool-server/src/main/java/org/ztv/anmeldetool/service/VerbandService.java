package org.ztv.anmeldetool.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.models.Verband;
import org.ztv.anmeldetool.repositories.VerbandsRepository;
import org.ztv.anmeldetool.transfer.VerbandDTO;

import lombok.extern.slf4j.Slf4j;

@Service("verbandService")
@Slf4j
@RequiredArgsConstructor
public class VerbandService {

	private final VerbandsRepository verbandRepo;

	public Verband getVerband(UUID verbandId) {
		Optional<Verband> verbandOpt = verbandRepo.findById(verbandId);
		if (verbandOpt.isPresent()) {
			return verbandOpt.get();
		}
		return null;
	}

	public Verband findByVerbandsKuerzel(String verbandAbkz) {
		Optional<Verband> verbaendeOpt = verbandRepo.findByVerband(verbandAbkz);
		return verbaendeOpt.orElseThrow();
	}

  /**
   * Liefert alle aktiven Verbände sortiert nach dem Verbandskürzel
   *
   * @return Liste der Verbände
   */
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
