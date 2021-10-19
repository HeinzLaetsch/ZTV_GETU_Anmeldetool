package org.ztv.anmeldetool.anmeldetool.util;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.anmeldetool.service.RoleService;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationenDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.PersonAnlassLinkDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.RolleDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.TeilnehmerAnlassLinkDTO;

public class PersonAnlassLinkHelper {

	public static Collection<PersonAnlassLinkDTO> getPersonAnlassLinkDTOForPersonAnlassLink(List<PersonAnlassLink> personAnlassLinks) {

		Collection<PersonAnlassLinkDTO> palList = new ArrayList<PersonAnlassLinkDTO>();
		for (PersonAnlassLink personAnlasslink : personAnlassLinks) {
			PersonAnlassLinkDTO palDTO = new PersonAnlassLinkDTO(personAnlasslink.getAnlass().getId(), personAnlasslink.getPerson().getId(), false);
			palList.add(palDTO);
		}
		return palList;
	}

}
