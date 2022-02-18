package org.ztv.anmeldetool.util;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.Notenblatt;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.transfer.RanglistenEntryDTO;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public abstract class TeilnehmerAnlassLinkRanglistenMapper {

	@Mapping(source = "notenblatt.gesamtPunktzahl", target = "gesamtPunktzahl")
	@Mapping(source = "notenblatt.rang", target = "rang")
	@Mapping(source = "notenblatt.auszeichnung", target = "auszeichnung")
	@Mapping(expression = "java(getReckNote(tal.getNotenblatt()))", target = "noteReck")
	@Mapping(expression = "java(getBodenNote(tal.getNotenblatt()))", target = "noteBoden")
	@Mapping(expression = "java(getSchaukelringeNote(tal.getNotenblatt()))", target = "noteSchaukelringe")
	@Mapping(expression = "java(getSprung1Note(tal.getNotenblatt()))", target = "noteSprung1")
	@Mapping(expression = "java(getSprung2Note(tal.getNotenblatt()))", target = "noteSprung2")
	@Mapping(expression = "java(getSprungZaehlbarNote(tal.getNotenblatt()))", target = "noteZaehlbar")
	@Mapping(expression = "java(getBarrenNote(tal.getNotenblatt()))", target = "noteBarren")

	@Mapping(source = "teilnehmer.name", target = "name")
	@Mapping(source = "teilnehmer.vorname", target = "vorname")
	@Mapping(source = "teilnehmer.jahrgang", target = "jahrgang")
	@Mapping(source = "organisation.name", target = "verein")
	public abstract RanglistenEntryDTO fromEntity(TeilnehmerAnlassLink tal);

	public float getReckNote(Notenblatt notenblatt) {
		return notenblatt.getEinzelnoteForGeraet(GeraetEnum.RECK).getNote_1();
	}

	public float getBodenNote(Notenblatt notenblatt) {
		return notenblatt.getEinzelnoteForGeraet(GeraetEnum.BODEN).getNote_1();
	}

	public float getSchaukelringeNote(Notenblatt notenblatt) {
		return notenblatt.getEinzelnoteForGeraet(GeraetEnum.SCHAUKELRINGE).getNote_1();
	}

	public float getSprung1Note(Notenblatt notenblatt) {
		return notenblatt.getEinzelnoteForGeraet(GeraetEnum.SPRUNG).getNote_1();
	}

	public float getSprung2Note(Notenblatt notenblatt) {
		return notenblatt.getEinzelnoteForGeraet(GeraetEnum.SPRUNG).getNote_2();
	}

	public float getSprungZaehlbarNote(Notenblatt notenblatt) {
		return notenblatt.getEinzelnoteForGeraet(GeraetEnum.SPRUNG).getZaehlbar();
	}

	public float getBarrenNote(Notenblatt notenblatt) {
		return notenblatt.getEinzelnoteForGeraet(GeraetEnum.BARREN).getNote_1();
	}
}
