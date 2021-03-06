package org.ztv.anmeldetool.util;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkCsvDTO;
import org.ztv.anmeldetool.util.idmapper.AnlassFromIdMapper;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, uses = { AnlassFromIdMapper.class })
public interface TeilnehmerAnlassLinkExportImportMapper {

	@Mapping(source = "teilnehmer.id", target = "teilnehmerId")
	@Mapping(source = "teilnehmer.name", target = "name")
	@Mapping(source = "teilnehmer.vorname", target = "vorname")
	@Mapping(source = "teilnehmer.jahrgang", target = "jahrgang")
	@Mapping(source = "teilnehmer.tiTu", target = "tiTu")
	@Mapping(source = "organisation.name", target = "verein")
	@Mapping(source = "organisation.id", target = "organisationId")
	@Mapping(source = "anlass.id", target = "anlassId")
	TeilnehmerAnlassLinkCsvDTO fromEntity(TeilnehmerAnlassLink tal);

	TeilnehmerAnlassLink fromCSV(TeilnehmerAnlassLinkCsvDTO talDTO);

}
