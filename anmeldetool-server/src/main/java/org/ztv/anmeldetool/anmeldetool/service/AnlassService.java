package org.ztv.anmeldetool.anmeldetool.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.anmeldetool.models.Verband;
import org.ztv.anmeldetool.anmeldetool.repositories.AnlassRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.OrganisationAnlassLinkRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.OrganisationsRepository;
import org.ztv.anmeldetool.anmeldetool.transfer.AnlassDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationAnlassLinkDTO;
import org.ztv.anmeldetool.anmeldetool.transfer.OrganisationenDTO;
import org.ztv.anmeldetool.anmeldetool.util.AnlassHelper;
import org.ztv.anmeldetool.anmeldetool.util.OrganisationAnlassLinkHelper;
import org.ztv.anmeldetool.anmeldetool.util.OrganisationHelper;

import lombok.extern.slf4j.Slf4j;
/**
 * 
 * @author heinz
 */
@Service("anlassService")
@Slf4j
public class AnlassService {

	@Autowired
	AnlassRepository anlassRepo;
	
	@Autowired
	OrganisationService organisationSrv;
	
	@Autowired
	OrganisationAnlassLinkRepository orgAnlassRepo;
	
	public ResponseEntity<Collection<AnlassDTO>> getAllAnlaesse() {
		Collection<AnlassDTO> anlaessDto = new ArrayList<AnlassDTO>();
		Iterable<Anlass> anlaesse = anlassRepo.findByAktivOrderByAnlassBezeichnung(true);
		for (Anlass anlass : anlaesse) {
			log.debug("Anlass: " + anlass);
			// Collection<OrganisationenDTO> orgDTOs = OrganisationAnlassLinkHelper.getOrganisationDTOForAnlassLink(anlass.getOrganisationenLinks());
			AnlassDTO anlassDTO = AnlassHelper.createAnlassDTO(anlass);
			anlaessDto.add(anlassDTO);
		}
		return ResponseEntity.ok(anlaessDto);
	}
	
	public ResponseEntity<Boolean> getVereinStarts(UUID anlassId,  UUID orgId) {
		Anlass anlass = findAnlassById(anlassId);
		if (anlass == null) {
			return ResponseEntity.notFound().build();
		}
		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		if (organisation == null) {
			return ResponseEntity.notFound().build();
		}

		OrganisationAnlassLink teilnahme = orgAnlassRepo.findFirstByOrganisationAndAnlass(organisation, anlass);
		if(teilnahme != null && teilnahme.isAktiv()) {
			return ResponseEntity.ok(true);
			
		}
		return ResponseEntity.notFound().build();
	}
	
	public ResponseEntity<Collection<OrganisationenDTO>> getVereinsStarts(UUID anlassId) {
		Anlass anlass = findAnlassById(anlassId);
		if (anlass == null) {
			return ResponseEntity.notFound().build();
		}
		// Collection<OrganisationenDTO> orgDTOs = OrganisationAnlassLinkHelper.getOrganisationDTOForAnlassLink(anlass.getOrganisationenLinks());
		AnlassDTO anlassDTO = AnlassHelper.createAnlassDTO(anlass);
		return ResponseEntity.ok(anlassDTO.getOrganisationen());
	}

	public Anlass findAnlassById(UUID anlassId) {
		Optional<Anlass> optAnlass = anlassRepo.findById(anlassId);
		return optAnlass.get();
	}	
	
	public ResponseEntity updateTeilnehmendeVereine(UUID anlassId, UUID orgId, OrganisationAnlassLinkDTO oal) {

		Anlass anlass = findAnlassById(anlassId);

		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		if (organisation == null) {
			return ResponseEntity.notFound().build();
		}
		
		OrganisationAnlassLink teilnahme = orgAnlassRepo.findFirstByOrganisationAndAnlass(organisation, anlass);
		OrganisationAnlassLink organisationAnlassLink;
		if (teilnahme != null) {
			organisationAnlassLink = teilnahme; 
			organisationAnlassLink.setAktiv(oal.isStarted());
			organisationAnlassLink.setAnlass(anlass);
			organisationAnlassLink.setOrganisation(organisation);
		} else {
			organisationAnlassLink = new OrganisationAnlassLink();
			organisationAnlassLink.setAktiv(oal.isStarted());
			organisationAnlassLink.setAnlass(anlass);
			organisationAnlassLink.setOrganisation(organisation);
		}
		orgAnlassRepo.save(organisationAnlassLink);			
		
		return ResponseEntity.ok().build();
	}

}
