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
import org.ztv.anmeldetool.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.anmeldetool.models.TiTuEnum;
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
import org.ztv.anmeldetool.anmeldetool.service.TeilnehmerService;
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
	
	@Autowired
	TeilnehmerService teilnehmerService;
	
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

		createListOfTeilnehmer(verein1, 33);
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
	
	private void createListOfTeilnehmer(Organisation verein, int anzahl) {
		for (int i = 0; i < anzahl; i++)
			createTeilnehmer(verein, TiTuEnum.Ti, i);
		for (int i = 0; i < anzahl / 2; i++)
			createTeilnehmer(verein, TiTuEnum.Tu, i);
	}
	
	private void createTeilnehmer(Organisation verein, TiTuEnum tiTu, int i) {
		int random_int = (int)Math.floor(Math.random() * 18);
		String surname = SURNAMES[random_int] + "_" + tiTu;
		random_int = (int)Math.floor(Math.random() * 19);
		String name = NAMES[random_int] + "_" + i;
		random_int = (2021-45) + (int)Math.floor(Math.random() * 45);
		Teilnehmer teilnehmer = Teilnehmer.builder().name(name).vorname(surname).jahrgang(random_int).tiTu(tiTu).organisation(verein).build();
		teilnehmerService.create(teilnehmer);	
	}
	
	  /** Constants used to fill up our data base. */
	private static String[] SURNAMES = {"Maia", "Asher", "Olivia", "Atticus", "Amelia", "Jack",
	"Charlotte", "Theodore", "Isla", "Oliver", "Isabella", "Jasper",
	"Cora", "Levi", "Violet", "Arthur", "Mia", "Thomas", "Elizabeth"};

	private static String[] NAMES = {"Balmer", "Bärtschi", "Meier", "Müller", "Keller", "Brandenberger",
	  "Schmidhauser", "Kneubühler", "Hochmuth", "Berset", "Trump", "Einstein",
	  "Hase", "Schneemann", "Cologna", "Federer", "Bretscher", "Züllig", "Marti"};
}
