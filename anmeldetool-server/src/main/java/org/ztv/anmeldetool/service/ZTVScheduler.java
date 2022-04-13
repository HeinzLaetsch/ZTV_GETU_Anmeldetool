package org.ztv.anmeldetool.service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.activation.DataSource;
import javax.mail.util.ByteArrayDataSource;
import javax.transaction.Transactional;
import javax.transaction.Transactional.TxType;

import org.dom4j.DocumentException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationPersonLink;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.models.RollenEnum;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.output.AnmeldeKontrolleOutput;
import org.ztv.anmeldetool.output.WertungsrichterOutput;
import org.ztv.anmeldetool.repositories.OrganisationAnlassLinkRepository;
import org.ztv.anmeldetool.transfer.AnmeldeKontrolleDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ZTVScheduler {
	@Autowired
	PersonService personSrv;

	@Autowired
	AnlassService anlassSrv;

	@Autowired
	OrganisationService orgSrv;

	@Autowired
	OrganisationAnlassLinkRepository oalRepo;

	@Value("${spring.mail.username}")
	private String sender;

	@Value("${spring.mail.templates.path}")
	private String mailTemplatesPath;

	@Autowired
	private EmailService mailService;

	@Autowired
	MailerService mailerService;

	@Value("${scheduler.reminder.daysbefore}")
	private int reminderDaysBefore;

	@Value("${scheduler.closed.daysafter}")
	private int closedDaysAfter;

	@Value("${scheduler.mutationen.daysbefore}")
	private int mutationenDaysBefore;

	@Transactional(value = TxType.REQUIRES_NEW)
	@Scheduled(cron = "${scheduler.reminder.cron}")
	public void reminderCheck() {
		log.debug("Reminder check fired");

		List<Anlass> anlaesse = anlassSrv.getAllAnlaesse();

		List<Anlass> filteredAnlaesse = anlaesse.stream().filter(anlass -> {
			boolean erfassenNotClosed = anlass.getErfassenGeschlossen().isAfter(LocalDateTime.now());
			boolean isDaysBefore = anlass.getErfassenGeschlossen().minusDays(reminderDaysBefore)
					.isBefore(LocalDateTime.now());
			return erfassenNotClosed && isDaysBefore;
		}).collect(Collectors.toList());

		sendReminderMailIfNeeded(filteredAnlaesse, "Stand der Anmeldung");
	}

	@Transactional(value = TxType.REQUIRES_NEW)
	@Scheduled(cron = "${scheduler.closed.cron}")
	public void reminderClosed() {
		log.debug("Closed fired");

		List<Anlass> anlaesse = anlassSrv.getAllAnlaesse();

		List<Anlass> filteredAnlaesse = anlaesse.stream().filter(anlass -> {
			boolean aenderungenNotClosed = anlass.getAenderungenNichtMehrErlaubt().isAfter(LocalDateTime.now());
			boolean isDaysAfter = anlass.getErfassenGeschlossen().plusDays(closedDaysAfter)
					.isBefore(LocalDateTime.now());
			return aenderungenNotClosed && isDaysAfter;
		}).collect(Collectors.toList());

		sendClosedMailIfNeeded(filteredAnlaesse, "Anmeldebestätigung");
	}

	@Transactional(value = TxType.REQUIRES_NEW)
	@Scheduled(cron = "${scheduler.mutationen.cron}")
	public void reminderMutationen() {
		log.debug("Reminder Mutation fired");

		List<Anlass> anlaesse = anlassSrv.getAllAnlaesse();

		List<Anlass> filteredAnlaesse = anlaesse.stream().filter(anlass -> {
			boolean erfassenClosed = anlass.getErfassenGeschlossen().isBefore(LocalDateTime.now());
			boolean isMuationenNotClosed = anlass.getAenderungenNichtMehrErlaubt().isAfter(LocalDateTime.now());
			boolean isDaysBefore = anlass.getAenderungenNichtMehrErlaubt().minusDays(mutationenDaysBefore)
					.isBefore(LocalDateTime.now());
			return isMuationenNotClosed && erfassenClosed && isDaysBefore;
		}).collect(Collectors.toList());

		sendMutationMailIfNeeded(filteredAnlaesse, "Mutationsschluss");
	}

	private void sendReminderMailIfNeeded(List<Anlass> filteredAnlaesse, String subject) {
		filteredAnlaesse.forEach(anlass -> {
			if (!anlass.isReminderMeldeschlussSent()) {
				List<Organisation> allZHOrgs = orgSrv.getAllZuercherOrganisationen();
				allZHOrgs.forEach(org -> {
					sendMailToOrg(anlass, org, subject);
				});
				anlass.setReminderMeldeschlussSent(true);
				anlassSrv.save(anlass);
			}
		});

	}

	private boolean sendMailToOrg(Anlass anlass, Organisation org, String subject) {
		Stream<OrganisationPersonLink> oplStream = org.getPersonenLinks().stream().filter(pl -> {
			return pl.getRollenLink().stream().filter(rolle -> {
				log.debug("Name : {}", pl.getPerson().getBenutzername());
				return rolle.getRolle().getName().equals(RollenEnum.VEREINSVERANTWORTLICHER.name())
						|| rolle.getRolle().getName().equals(RollenEnum.ANMELDER.name());
			}).count() > 0;
		});
		AtomicBoolean error = new AtomicBoolean(false);
		oplStream.forEach(opl -> {
			// Person person =
			// this.personSrv.findPersonByBenutzername("heinz.laetsch@gmx.ch");
			log.debug("Sende Mail an: {} / {}", opl.getOrganisation().getName(), opl.getPerson().getEmail());
			if (!sendAnmeldeKontrolleMail(anlass, org, opl.getPerson(), subject)) {
				error.set(true);
			}
		});
		return error.get();
	}

	private void sendClosedMailIfNeeded(List<Anlass> filteredAnlaesse, String subject) {

		filteredAnlaesse.forEach(anlass -> {
			anlass.getOrganisationenLinks().forEach(oal -> {
				Organisation org = oal.getOrganisation();
				if (!oal.isAnmeldeKontrolleSent()) {
					boolean error = sendMailToOrg(anlass, org, subject);
					if (!error) {
						oal.setAnmeldeKontrolleSent(true);
						oalRepo.save(oal);
					}
				}
			});
		});
	}

	private void sendMutationMailIfNeeded(List<Anlass> filteredAnlaesse, String subject) {

		filteredAnlaesse.forEach(anlass -> {
			anlass.getOrganisationenLinks().forEach(oal -> {
				Organisation org = oal.getOrganisation();
				if (!oal.isReminderMutationsschlussSent()) {
					boolean error = sendMailToOrg(anlass, org, subject);
					if (!error) {
						oal.setReminderMutationsschlussSent(true);
						oalRepo.save(oal);
					}
				}
			});
		});
	}

	private boolean sendAnmeldeKontrolleMail(Anlass anlass, Organisation org, Person person, String subject) {
		List<PersonAnlassLink> palBr1 = anlassSrv.getEingeteilteWertungsrichter(anlass.getId(), org.getId(),
				WertungsrichterBrevetEnum.Brevet_1);
		List<PersonAnlassLink> palBr2 = anlassSrv.getEingeteilteWertungsrichter(anlass.getId(), org.getId(),
				WertungsrichterBrevetEnum.Brevet_2);

		AnmeldeKontrolleDTO anmeldeKontrolle = anlassSrv.getAnmeldeKontrolle(anlass.getId(), org.getId());
		Map<String, Object> templateModel = mailerService.getAnmeldeDaten(anmeldeKontrolle, org, subject);

		// Map<String, Object> templateModel = new HashMap();
		templateModel.put("recipientName", person.getEmail());
		templateModel.put("text", "AnmeldeKontrolle Daten");
		templateModel.put("senderName", sender);

		// Teilnehmer
		ByteArrayOutputStream outAnmeldekontrolle = new ByteArrayOutputStream();
		try {
			AnmeldeKontrolleOutput.createAnmeldeKontrolle(outAnmeldekontrolle, anmeldeKontrolle);
		} catch (DocumentException | IOException e) {
			log.warn("Could not create AnmeldeKontrolleOutput", e);
			return false;
		}

		ByteArrayDataSource sourceAnmeldekontrolle = new ByteArrayDataSource(outAnmeldekontrolle.toByteArray(),
				"application/pdf");
		sourceAnmeldekontrolle.setName("AnmeldeKontrolle");

		// Wertungsrichter
		ByteArrayOutputStream outWertungsrichter = new ByteArrayOutputStream();
		try {
			WertungsrichterOutput.createWertungsrichter(outWertungsrichter, anmeldeKontrolle, palBr1, palBr2);
		} catch (DocumentException | IOException e) {
			log.warn("Could not create WertungsrichterOutput", e);
			return false;
		}

		ByteArrayDataSource sourceWertungsrichter = new ByteArrayDataSource(outWertungsrichter.toByteArray(),
				"application/pdf");
		sourceWertungsrichter.setName("Wertungsrichter");

		DataSource[] sources = new ByteArrayDataSource[] { sourceAnmeldekontrolle, sourceWertungsrichter };

		this.mailService.sendMessage(person, templateModel.get("subject").toString(), "anmelde-status.html",
				templateModel, sources);
		return true;
	}
}
