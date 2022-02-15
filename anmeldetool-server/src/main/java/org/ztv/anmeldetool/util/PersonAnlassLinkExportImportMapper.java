package org.ztv.anmeldetool.util;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.transfer.PersonAnlassLinkCsvDTO;
import org.ztv.anmeldetool.util.idmapper.PersonFromIdMapper;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING, uses = { PersonFromIdMapper.class,
		WertungsrichterEinsatzExportMapper.class })
public interface PersonAnlassLinkExportImportMapper {

	@Mapping(source = "person.benutzername", target = "benutzername")
	@Mapping(source = "person.name", target = "name")
	@Mapping(source = "person.vorname", target = "vorname")
	@Mapping(source = "person.handy", target = "handy")
	@Mapping(source = "person.email", target = "email")
	@Mapping(source = "organisation.name", target = "verein")
	@Mapping(source = "einsaetze", target = "wrMeldungen")
	PersonAnlassLinkCsvDTO fromEntity(PersonAnlassLink pal);
}
