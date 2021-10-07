package org.ztv.anmeldetool.anmeldetool.transfer;

import java.util.Calendar;
import java.util.Set;
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
	
	Calendar startDatum;
	
	Calendar endDatum;
	
	TiTuEnum tiTu;
	
	KategorieEnum tiefsteKategorie;
	
	KategorieEnum hoechsteKategorie;
	
	Set<OrganisationenDTO> organisationen;
}
