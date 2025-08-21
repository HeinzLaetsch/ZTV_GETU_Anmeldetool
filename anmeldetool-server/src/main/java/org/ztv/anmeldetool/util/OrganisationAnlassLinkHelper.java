package org.ztv.anmeldetool.util;

import java.util.List;
import java.util.stream.Collectors;

import org.ztv.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.transfer.OrganisationAnlassLinkDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class OrganisationAnlassLinkHelper {

	public static List<OrganisationAnlassLinkDTO> toDTO(OrganisationAnlassLinkMapper oalMapper,
			List<OrganisationAnlassLink> oallist) {
		return oallist.stream().map(oal -> {
			return oalMapper.toDto(oal);
		}).collect(Collectors.toList());
	}
}
