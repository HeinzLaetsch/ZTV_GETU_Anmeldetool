package org.ztv.anmeldetool.anmeldetool.transfer;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import org.ztv.anmeldetool.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.anmeldetool.models.TiTuEnum;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class AnlassDTO {

	UUID id;

	String anlassBezeichnung;

	String ort;

	String halle;

	// String organisator;
	UUID organisatorId;

	private String iban;

	private String zuGunsten;

	private String bank;

	LocalDateTime startDatum;

	LocalDateTime endDatum;

	// Anmeldung ist eröffnet, es kann alles erfasst werden
	private LocalDateTime anmeldungBeginn;

	// Neu Erfassen nicht mehr erlaubt
	private LocalDateTime erfassenGeschlossen;

	// Cross Kategorie Aenderungen nicht mehr erlaubt
	private LocalDateTime crossKategorieAenderungenGeschlossen;

	// Aenderungen innerhalb Kategorie nicht mehr erlaubt.
	private LocalDateTime aenderungenInKategorieGeschlossen;

	// Kurz vor Wettkampf, keine Mutationen mehr erlaubt
	private LocalDateTime aenderungenNichtMehrErlaubt;

	private boolean published;

	TiTuEnum tiTu;

	KategorieEnum tiefsteKategorie;

	KategorieEnum hoechsteKategorie;

	List<OrganisationDTO> organisationen;

	List<WertungsrichterSlotDTO> wertungsrichterSlots;
}
