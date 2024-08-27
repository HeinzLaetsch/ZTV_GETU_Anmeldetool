package org.ztv.anmeldetool.transfer;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.ztv.anmeldetool.models.KategorieEnum;

import lombok.Data;

@Data
public class KategorieStatusDTO {
	private KategorieEnum kategorie;
	private List<MeldeStatusStatusDTO> meldeStati;

	public KategorieStatusDTO(KategorieEnum kategorie) {
		this.kategorie = kategorie;
		meldeStati = new ArrayList<>();
	}

	public KategorieEnum getKategorie() {
		return this.kategorie;
	}

	public void addTal(TeilnehmerAnlassLinkDTO tal) {
		Optional<MeldeStatusStatusDTO> meldeStatusOpt = meldeStati.stream()
				.filter((status) -> status.getMeldeStatus().equals(tal.getMeldeStatus())).findFirst();

		meldeStatusOpt.ifPresentOrElse(status -> status.increment(), () -> {
			MeldeStatusStatusDTO status = new MeldeStatusStatusDTO(tal.getMeldeStatus());
			meldeStati.add(status);
		});
	}

	/*
	 * public void addTal(TeilnehmerAnlassLinkDTO tal) { MeldeStatusStatiDTO
	 * meldeStatusStatiDTO = null; if
	 * (kategorieStati.containsKey(tal.getKategorie())) { meldeStatusStatiDTO =
	 * kategorieStati.get(tal.getKategorie()); } else { meldeStatusStatiDTO = new
	 * MeldeStatusStatiDTO(); kategorieStati.put(tal.getKategorie(),
	 * meldeStatusStatiDTO); }
	 * meldeStatusStatiDTO.addMeldeStatus(tal.getMeldeStatus()); }
	 */
}
