package org.ztv.anmeldetool.anmeldetool;

import java.util.Calendar;
import java.util.Collection;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.anmeldetool.models.Person;
import org.ztv.anmeldetool.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.anmeldetool.models.RollenEnum;
import org.ztv.anmeldetool.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.anmeldetool.models.Verband;
import org.ztv.anmeldetool.anmeldetool.models.VerbandEnum;
import org.ztv.anmeldetool.anmeldetool.repositories.AnlassRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.OrganisationAnlassLinkRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.OrganisationPersonLinkRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.OrganisationsRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.PersonenRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.RollenRepository;
import org.ztv.anmeldetool.anmeldetool.repositories.VerbandsRepository;
import org.ztv.anmeldetool.anmeldetool.service.PersonService;
import org.ztv.anmeldetool.anmeldetool.service.VerbandService;
import org.ztv.anmeldetool.anmeldetool.repositories.RollenLinkRepository;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ZTVStartupApplicationListener implements ApplicationListener<ContextRefreshedEvent> {

	@Autowired
	OrganisationsRepository orgRepo;
	
	@Autowired
	VerbandsRepository verbandRepo;
	
	@Autowired
	OrganisationPersonLinkRepository orgPersRepo;
	
	@Autowired
	PersonService personSrv;
	
	@Autowired
	RollenRepository rollenRepo;
	
	@Autowired
	RollenLinkRepository rollenLinkRepo;

	@Autowired
	AnlassRepository anlassRepo;
	
	@Autowired
	OrganisationAnlassLinkRepository orgAnlassLinkRepo;
	
	@Override
	public void onApplicationEvent(ContextRefreshedEvent event) {
		log.info("Anmeldetool is starting");
		createRollen();
		Organisation ztv  = orgRepo.findAllByName("ZTV");
		if (ztv == null) {
			log.info("Anmeldetool needs initialising");
			Iterable<Verband> verbaende = verbandRepo.findByVerband(VerbandEnum.STV.name());
			Verband verband = verbaende.iterator().next();
			ztv = Organisation.builder().name("ZTV").verband(verband).build();
			OrganisationPersonLink opLink = new OrganisationPersonLink();
			opLink.setAktiv(true);
			opLink.setChangeDate(Calendar.getInstance());
			ztv.addToPersonenLink(opLink);
			String password = "test";
			Person person = Person.builder().benutzername("admin").name("Administrator").vorname("").handy("").email("").password(password).build();
			person.setAktiv(true);
			person.setChangeDate(Calendar.getInstance());
			person.addToOrganisationenLink(opLink);
			RollenLink rollenLink = new RollenLink();
			rollenLink.setLink(opLink);
			rollenLink.setRolle(getRolle(RollenEnum.ADMINISTRATOR));
			rollenLink.setAktiv(true);
			orgRepo.save(ztv);
			// persRepo.save(person);
			personSrv.create(person, true);
			// orgPersRepo.save(opLink); Cascade
			rollenLinkRepo.save(rollenLink);
			log.info("User created: " + password);
			createVerein1();
		} else {
			log.info("Anmeldetool is ready to use");
		}
		createTeilnahme();
	}
	private void createTeilnahme() {
		Organisation verein1 = orgRepo.findByName("TV Verein1");
		Iterable<Anlass> anlaesse = anlassRepo.findAll();
		Anlass anlass = anlaesse.iterator().next();
		OrganisationAnlassLink oal = new OrganisationAnlassLink();
		oal.setAnlass(anlass);
		oal.setOrganisation(verein1);
		orgAnlassLinkRepo.save(oal);
	}
	private void createVerein1() {
		log.info("Create Verein1");
		Iterable<Verband> verbaende = verbandRepo.findByVerband(VerbandEnum.GLZ.name());
		Verband verband = verbaende.iterator().next();
		Organisation verein1 = Organisation.builder().name("TV Verein1").verband(verband).build();
		OrganisationPersonLink opLink = new OrganisationPersonLink();
		opLink.setAktiv(true);
		opLink.setChangeDate(Calendar.getInstance());
		verein1.addToPersonenLink(opLink);
		String password = "pw";
		Person person = Person.builder().benutzername("trainer1@verein1.com").name("Trainer1").vorname("Best").handy("076 12 345 67").email("verein1@verein1.com").password(password).build();
		person.setAktiv(true);
		person.setChangeDate(Calendar.getInstance());
		person.addToOrganisationenLink(opLink);
		RollenLink rollenLink = new RollenLink();
		rollenLink.setLink(opLink);
		rollenLink.setRolle(getRolle(RollenEnum.ANMELDER));
		rollenLink.setAktiv(false);
		orgRepo.save(verein1);
		// persRepo.save(person);
		person = personSrv.create(person, true);
		// orgPersRepo.save(opLink); Cascade
		rollenLinkRepo.save(rollenLink);
		log.info("User created: " + person.getBenutzername());

		opLink = new OrganisationPersonLink();
		opLink.setAktiv(true);
		opLink.setChangeDate(Calendar.getInstance());
		verein1.addToPersonenLink(opLink);

		person = Person.builder().benutzername("trainer2@tvverein1.ch").name("Trainer2").vorname("Super").handy("078 11 111 11").email("trainer2@tvverein1.ch").password(password).build();
		person.setAktiv(true);
		person.setChangeDate(Calendar.getInstance());
		person.addToOrganisationenLink(opLink);
		
		rollenLink = new RollenLink();
		rollenLink.setLink(opLink);
		rollenLink.setRolle(getRolle(RollenEnum.ANMELDER));
		rollenLink.setAktiv(true);
		rollenLinkRepo.save(rollenLink);

		rollenLink = new RollenLink();
		rollenLink.setLink(opLink);
		rollenLink.setRolle(getRolle(RollenEnum.VEREINSVERANTWORTLICHER));
		rollenLink.setAktiv(true);
		rollenLinkRepo.save(rollenLink);
		
		person = personSrv.create(person, true);

	}
	
	private Rolle getRolle(RollenEnum rollenEnum) {
		return rollenRepo.findByName(rollenEnum.name());
	}
	private void createRollen() {
		for (RollenEnum rollenEnum : RollenEnum.values()) {
			Rolle rolle = rollenRepo.findByName(rollenEnum.name());
			if (rolle == null) {
				rolle = new Rolle(rollenEnum);
				rolle.setAktiv(true);
				rollenRepo.save(rolle);
			}
		}
		
	}
}
