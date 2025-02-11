package org.ztv.anmeldetool.transfer;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import lombok.Data;

/**
 * Struktur um pro Organisation und pro Anlass die MeldeStati je Kategorie zu
 * verwalten
 */
@Data
public class OrganisationTeilnahmenStatistikDTO {
	UUID anlassId;
	List<KategorieStatusDTO> kategorieStati;

	public OrganisationTeilnahmenStatistikDTO(UUID anlassId) {
		this.anlassId = anlassId;
		this.kategorieStati = new ArrayList<KategorieStatusDTO>();
	}

	public void addTal(TeilnehmerAnlassLinkDTO tal) {
		Optional<KategorieStatusDTO> kategorieStatusOpt = kategorieStati.stream().filter((status) -> status != null
				&& tal != null && tal.getKategorie() != null && status.getKategorie().equals(tal.getKategorie()))
				.findFirst();

		kategorieStatusOpt.ifPresentOrElse(status -> status.addTal(tal), () -> {
			KategorieStatusDTO status = new KategorieStatusDTO(tal.getKategorie());
			status.addTal(tal);
			kategorieStati.add(status);
		});
	}

//	public void addTal(TeilnehmerAnlassLinkDTO tal) {
//		MeldeStatusStatusDTO meldeStatusStatiDTO = null;
//		if (kategorieStati.containsKey(tal.getKategorie())) {
//			meldeStatusStatiDTO = kategorieStati.get(tal.getKategorie());
//		} else {
//			meldeStatusStatiDTO = new MeldeStatusStatusDTO();
//			kategorieStati.put(tal.getKategorie(), meldeStatusStatiDTO);
//		}
//		meldeStatusStatiDTO.addMeldeStatus(tal.getMeldeStatus());
//	}
}
