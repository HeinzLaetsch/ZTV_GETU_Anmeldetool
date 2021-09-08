package org.ztv.anmeldetool.anmeldetool.util;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.anmeldetool.service.RoleService;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationenDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.RolleDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;

public class TeilnehmerAnlassLinkHelper {

	public static Collection<TeilnehmerAnlassLinkDTO> getTeilnehmerAnlassLinkDTOForTeilnehmerAnlassLink(List<TeilnehmerAnlassLink> teilnehmerAnlassLinks) {

		Collection<TeilnehmerAnlassLinkDTO> talList = new ArrayList<TeilnehmerAnlassLinkDTO>();
		for (TeilnehmerAnlassLink teilnehmerAnlasslink : teilnehmerAnlassLinks) {
			TeilnehmerAnlassLinkDTO talDTO = new TeilnehmerAnlassLinkDTO(teilnehmerAnlasslink.getAnlass().getId(), teilnehmerAnlasslink.getTeilnehmer().getId(), teilnehmerAnlasslink.getKategorie().toString(), false);
			talList.add(talDTO);
		}
		return talList;
	}

}
