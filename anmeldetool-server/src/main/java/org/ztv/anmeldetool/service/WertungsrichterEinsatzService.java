package org.ztv.anmeldetool.service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.models.WertungsrichterEinsatz;
import org.ztv.anmeldetool.models.WertungsrichterSlot;
import org.ztv.anmeldetool.repositories.WertungsrichterEinsatzRepository;

import lombok.extern.slf4j.Slf4j;
import org.ztv.anmeldetool.transfer.WertungsrichterEinsatzDTO;
import org.ztv.anmeldetool.util.WertungsrichterEinsatzMapper;

@Slf4j
@RequiredArgsConstructor
@Service("wertungsrichterEinsatzService")
public class WertungsrichterEinsatzService {

	private final WertungsrichterEinsatzRepository wertungsrichterEinsatzRepository;
  private final WertungsrichterEinsatzMapper wertungsrichterEinsatzMapper;

	@Transactional(readOnly = true)
	public WertungsrichterEinsatz getWertungsrichterEinsatz(UUID id) {
		Optional<WertungsrichterEinsatz> opt = wertungsrichterEinsatzRepository.findById(id);
    return opt.orElse(null);
  }
  public WertungsrichterEinsatzDTO updateEinsatz(WertungsrichterEinsatzDTO wertungsrichterEinsatzDTO) {
    return wertungsrichterEinsatzMapper.ToDto(update(wertungsrichterEinsatzMapper.ToEntity(wertungsrichterEinsatzDTO)));
  }

	public List<WertungsrichterEinsatz> initEinsaetzeForPersonAnlassLink(PersonAnlassLink pal) {
		if (pal.getEinsaetze() == null || pal.getEinsaetze().isEmpty()) {
			if (pal.getAnlass().getWertungsrichterSlots() != null) {
				PersonAnlassLink finalPal = pal;
				// Slots finden, die zum Brevet des WR passen
				List<WertungsrichterSlot> slots = pal.getAnlass().getWertungsrichterSlots().stream()
						.filter(slot -> {
							if (finalPal.getAnlass().getHoechsteKategorie().isJugend()) {
								return true;
							}
							return finalPal.getPerson().getWertungsrichter().getBrevet() == slot.getBrevet();
						}).toList();

				return slots.stream().map(slot -> {
					WertungsrichterEinsatz wrE = WertungsrichterEinsatz.builder().personAnlassLink(finalPal)
							.eingesetzt(false).wertungsrichterSlot(slot).build();
					wrE.setId(UUID.randomUUID());
					wrE.setAktiv(true);
					wrE = wertungsrichterEinsatzRepository.save(wrE);
					return wrE;
				}).toList();
			}
		}
		return pal.getEinsaetze();
	}
	@Transactional
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
		// TODO macht keinen Sinn, wenn beides null ist kann nicht gespeichert werden
		wertungsrichterEinsatz = wertungsrichterEinsatzRepository.save(wertungsrichterEinsatz);
		return wertungsrichterEinsatz;
	}
}
