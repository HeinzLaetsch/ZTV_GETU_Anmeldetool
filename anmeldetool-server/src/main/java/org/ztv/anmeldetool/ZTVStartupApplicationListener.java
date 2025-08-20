package org.ztv.anmeldetool;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.Rolle;
import org.ztv.anmeldetool.models.RollenEnum;
import org.ztv.anmeldetool.models.RollenLink;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.models.Verband;
import org.ztv.anmeldetool.models.VerbandEnum;
import org.ztv.anmeldetool.models.Wertungsrichter;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.models.WertungsrichterSlot;
import org.ztv.anmeldetool.repositories.AnlassRepository;
import org.ztv.anmeldetool.repositories.OrganisationAnlassLinkRepository;
import org.ztv.anmeldetool.repositories.OrganisationPersonLinkRepository;
import org.ztv.anmeldetool.repositories.OrganisationsRepository;
import org.ztv.anmeldetool.repositories.RollenLinkRepository;
import org.ztv.anmeldetool.repositories.RollenRepository;
import org.ztv.anmeldetool.repositories.VerbandsRepository;
import org.ztv.anmeldetool.repositories.WertungsrichterRepository;
import org.ztv.anmeldetool.repositories.WertungsrichterSlotRepository;
import org.ztv.anmeldetool.service.FlywayService;
import org.ztv.anmeldetool.service.PersonService;
import org.ztv.anmeldetool.service.TeilnehmerService;
import org.ztv.anmeldetool.util.OrganisationBezeichnungTransformer;

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
	FlywayService flywayService;

	@Autowired
	TeilnehmerService teilnehmerService;

	@Autowired
	WertungsrichterRepository wertungsrichterRepo;

	@Autowired
	WertungsrichterSlotRepository wertungsrichterSlotRepo;

	@Autowired
	OrganisationPersonLinkRepository orgPersLinkRepo;

	@Override
	public void onApplicationEvent(ContextRefreshedEvent event) {
		log.info("Anmeldetool is starting");
		createRollen();
		Organisation ztv = orgRepo.findAllByName("ZTV");
		if (ztv == null) {
			log.info("Anmeldetool needs initialising");
			Iterable<Verband> verbaende = verbandRepo.findByVerband(VerbandEnum.STV.name());
			Verband verband = verbaende.iterator().next();

			ztv = Organisation.builder().name("ZTV").verband(verband).build();
			ztv = orgRepo.save(ztv);

			createWLTi(ztv);
			createWLTu(ztv);

			createSlots();

			// createVerein1();
			// createTeilnahme();
		} else {
			log.info("Anmeldetool is ready to use");
		}
		if (flywayService.isJavaMigrationNeeded("1.0.23")) {
			OrganisationBezeichnungTransformer.splitOrganisationName(orgRepo);
		}
	}

	private void createWLTu(Organisation ztv) {
		OrganisationPersonLink opLink = new OrganisationPersonLink();
		opLink.setAktiv(true);
		opLink.setChangeDate(Calendar.getInstance());
		ztv.addToPersonenLink(opLink);
		String password = "wl@ztv";

		Person person = Person.builder().benutzername("getu-wettkaempfe-tu@ztv.ch").name("Lätsch").vorname("Heinz")
				.handy("076 336 30 31").email("getu-wettkaempfe-tu@ztv.ch").password(password).build();
		person.setAktiv(true);
		person.setChangeDate(Calendar.getInstance());
		person.addToOrganisationenLink(opLink);
		opLink = orgPersLinkRepo.save(opLink);

		RollenLink rollenLink = new RollenLink();
		rollenLink.setLink(opLink);
		rollenLink.setRolle(getRolle(RollenEnum.ADMINISTRATOR));
		rollenLink.setAktiv(true);
		// persRepo.save(person);
		personSrv.create(person, true);
		// orgPersRepo.save(opLink); Cascade
		rollenLinkRepo.save(rollenLink);
	}

	private void createWLTi(Organisation ztv) {
		OrganisationPersonLink opLink = new OrganisationPersonLink();
		opLink.setAktiv(true);
		opLink.setChangeDate(Calendar.getInstance());
		ztv.addToPersonenLink(opLink);
		String password = "wl@ztv";

		Person person = Person.builder().benutzername("getu-wettkaempfe-ti@ztv.ch").name("Spitznagel/Althaus")
				.vorname("Karin/Sandy").handy("").email("getu-wettkaempfe-ti@ztv.ch").password(password).build();
		person.setAktiv(true);
		person.setChangeDate(Calendar.getInstance());
		person.addToOrganisationenLink(opLink);
		opLink = orgPersLinkRepo.save(opLink);

		RollenLink rollenLink = new RollenLink();
		rollenLink.setLink(opLink);
		rollenLink.setRolle(getRolle(RollenEnum.ADMINISTRATOR));
		rollenLink.setAktiv(true);
		// persRepo.save(person);
		personSrv.create(person, true);
		// orgPersRepo.save(opLink); Cascade
		rollenLinkRepo.save(rollenLink);
	}

	private void createSlots() {
		Iterable<Anlass> anlaesse = anlassRepo.findAll();
		for (Anlass a : anlaesse) {
			List<WertungsrichterSlot> slots = new ArrayList<WertungsrichterSlot>();
			a.setWertungsrichterSlots(slots);
			WertungsrichterSlot slot = new WertungsrichterSlot();
			slot.setAktiv(true);
			slot.setAnlass(a);
			slot.setBeschreibung("SO Morgen");
			slot.setBrevet(WertungsrichterBrevetEnum.Brevet_1);
			slot.setReihenfolge(0);
			slots.add(slot);
			wertungsrichterSlotRepo.save(slot);
			slot = new WertungsrichterSlot();
			slot.setAktiv(true);
			slot.setAnlass(a);
			slot.setBeschreibung("SO Mittag");
			slot.setBrevet(WertungsrichterBrevetEnum.Brevet_2);
			slot.setReihenfolge(1);
			slots.add(slot);
			wertungsrichterSlotRepo.save(slot);
		}

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
		String password = "pw";
		Iterable<Verband> verbaende = verbandRepo.findByVerband(VerbandEnum.GLZ.name());
		Verband verband = verbaende.iterator().next();

		// Verein erstellen
		Organisation verein1 = Organisation.builder().name("TV Verein1").verband(verband).build();
		verein1 = this.orgRepo.save(verein1);

		// Trainer 1
		Person person = Person.builder().benutzername("trainer1@verein1.com").name("Trainer1").vorname("Best")
				.handy("076 12 345 67").email("verein1@verein1.com").password(password).build();
		person.setAktiv(true);
		person.setChangeDate(Calendar.getInstance());

		person = personSrv.create(person, true);

		OrganisationPersonLink opLink = new OrganisationPersonLink();
		opLink.setAktiv(true);
		opLink.setChangeDate(Calendar.getInstance());
		opLink.setPerson(person);
		opLink.setOrganisation(verein1);
		opLink = orgPersLinkRepo.save(opLink);

		// person.addToOrganisationenLink(opLink);
		// verein1.addToPersonenLink(opLink);

		RollenLink rollenLink = new RollenLink();
		rollenLink.setLink(opLink);
		rollenLink.setRolle(getRolle(RollenEnum.ANMELDER));
		rollenLink.setAktiv(false);
		rollenLinkRepo.save(rollenLink);

		log.info("User created: " + person.getBenutzername());

		// Trainer 2
		person = Person.builder().benutzername("trainer2@tvverein1.ch").name("Trainer2").vorname("Super")
				.handy("078 11 111 11").email("trainer2@tvverein1.ch").password(password).build();
		person.setAktiv(true);
		person.setChangeDate(Calendar.getInstance());
		// person.addToOrganisationenLink(opLink);
		person = personSrv.create(person, true);

		opLink = new OrganisationPersonLink();
		opLink.setAktiv(true);
		opLink.setChangeDate(Calendar.getInstance());
		// verein1.addToPersonenLink(opLink);
		opLink.setPerson(person);
		opLink.setOrganisation(verein1);
		opLink = orgPersLinkRepo.save(opLink);

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

		log.info("User created: " + person.getBenutzername());

		// WR Brevet 1
		person = Person.builder().benutzername("WR.Brevet_1@tvverein1.ch").name("Muster").vorname("Hans")
				.handy("078 11 111 11").email("WR.Brevet_1@tvverein1.ch").password(password).build();
		person.setAktiv(true);
		person.setChangeDate(Calendar.getInstance());
		// person.addToOrganisationenLink(opLink);
		person = personSrv.create(person, true);

		opLink = new OrganisationPersonLink();
		opLink.setAktiv(true);
		opLink.setChangeDate(Calendar.getInstance());
		opLink.setPerson(person);
		opLink.setOrganisation(verein1);
		// verein1.addToPersonenLink(opLink);
		opLink = orgPersLinkRepo.save(opLink);

		rollenLink = new RollenLink();
		rollenLink.setLink(opLink);
		rollenLink.setRolle(getRolle(RollenEnum.WERTUNGSRICHTER));
		rollenLink.setAktiv(true);
		rollenLinkRepo.save(rollenLink);

		Wertungsrichter wertungsrichter = Wertungsrichter.builder().person(person)
				.brevet(WertungsrichterBrevetEnum.Brevet_1).letzterFk(null).build();
		// wertungsrichter = wertungsrichterRepo.save(wertungsrichter);
		person.setWertungsrichter(wertungsrichter);
		person = personSrv.create(person, true);

		log.info("User created: " + person.getBenutzername());

		// WR Brevet 2
		person = Person.builder().benutzername("WR.Brevet_2@tvverein1.ch").name("Kein Muster").vorname("Sofie")
				.handy("078 11 111 11").email("WR.Brevet_2@tvverein1.ch").password(password).build();
		person.setAktiv(true);
		person.setChangeDate(Calendar.getInstance());
		// person.addToOrganisationenLink(opLink);
		person = personSrv.create(person, true);

		opLink = new OrganisationPersonLink();
		opLink.setAktiv(true);
		opLink.setChangeDate(Calendar.getInstance());
		opLink.setPerson(person);
		opLink.setOrganisation(verein1);
		// verein1.addToPersonenLink(opLink);
		opLink = orgPersLinkRepo.save(opLink);

		rollenLink = new RollenLink();
		rollenLink.setLink(opLink);
		rollenLink.setRolle(getRolle(RollenEnum.WERTUNGSRICHTER));
		rollenLink.setAktiv(true);
		rollenLinkRepo.save(rollenLink);

		wertungsrichter = Wertungsrichter.builder().person(person).brevet(WertungsrichterBrevetEnum.Brevet_2)
				.letzterFk(null).build();
		// wertungsrichter = wertungsrichterRepo.save(wertungsrichter);
		person.setWertungsrichter(wertungsrichter);
		person = personSrv.create(person, true);

		log.info("User created: " + person.getBenutzername());

		// verein1 = orgRepo.save(verein1);

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
		int random_int = (int) Math.floor(Math.random() * 18);
		String surname = SURNAMES[random_int] + "_" + tiTu;
		random_int = (int) Math.floor(Math.random() * 19);
		String name = NAMES[random_int] + "_" + i;
		random_int = (2021 - 45) + (int) Math.floor(Math.random() * 45);
		Teilnehmer teilnehmer = Teilnehmer.builder().name(name).vorname(surname).jahrgang(random_int).tiTu(tiTu)
				.organisation(verein).build();
		teilnehmerService.create(teilnehmer);
	}

	/** Constants used to fill up our data base. */
	private static String[] SURNAMES = { "Maia", "Asher", "Olivia", "Atticus", "Amelia", "Jack", "Charlotte",
			"Theodore", "Isla", "Oliver", "Isabella", "Jasper", "Cora", "Levi", "Violet", "Arthur", "Mia", "Thomas",
			"Elizabeth" };

	private static String[] NAMES = { "Balmer", "Bärtschi", "Meier", "Müller", "Keller", "Brandenberger",
			"Schmidhauser", "Kneubühler", "Hochmuth", "Berset", "Trump", "Einstein", "Hase", "Schneemann", "Cologna",
			"Federer", "Bretscher", "Züllig", "Marti" };
}
