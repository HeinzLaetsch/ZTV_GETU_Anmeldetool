package org.ztv.anmeldetool.service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.stream.Collectors;
import java.util.stream.Stream;

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

import jakarta.activation.DataSource;
import jakarta.mail.util.ByteArrayDataSource;
import jakarta.transaction.Transactional;
import jakarta.transaction.Transactional.TxType;
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

	@Value("${spring.mail.simulate}")
	private boolean simulate;

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
	// @Scheduled(fixedDelay =30000)
	// @Scheduled(cron = "0 */5 * * * ?")
	public void reminderCheck() {
		log.info("Reminder check fired");

		List<Anlass> anlaesse = anlassSrv.getAnlaesse(true);

		List<Anlass> filteredAnlaesse = anlaesse.stream().filter(anlass -> {
			boolean erfassenNotClosed = anlass.getErfassenGeschlossen().isAfter(LocalDateTime.now());
			boolean isDaysBefore = anlass.getErfassenGeschlossen().minusDays(reminderDaysBefore)
					.isBefore(LocalDateTime.now());
			return erfassenNotClosed && isDaysBefore;
		}).collect(Collectors.toList());

		sendReminderMailIfNeeded(filteredAnlaesse, "Stand der Anmeldung", "Meldeschluss ist");
	}

	@Transactional(value = TxType.REQUIRES_NEW)
	@Scheduled(cron = "${scheduler.closed.cron}")
	public void reminderClosed() {
		log.debug("Closed fired");

		List<Anlass> anlaesse = anlassSrv.getAnlaesse(true);

		List<Anlass> filteredAnlaesse = anlaesse.stream().filter(anlass -> {
			boolean aenderungenNotClosed = anlass.getAenderungenNichtMehrErlaubt().isAfter(LocalDateTime.now());
			boolean isDaysAfter = anlass.getErfassenGeschlossen().plusDays(closedDaysAfter)
					.isBefore(LocalDateTime.now());
			return aenderungenNotClosed && isDaysAfter;
		}).collect(Collectors.toList());

		sendClosedMailIfNeeded(filteredAnlaesse, "Anmeldebestätigung", "Meldeschluss war");
	}

	@Transactional(value = TxType.REQUIRES_NEW)
	@Scheduled(cron = "${scheduler.mutationen.cron}")
	public void reminderMutationen() {
		log.debug("Reminder Mutation fired");

		List<Anlass> anlaesse = anlassSrv.getAnlaesse(true);

		List<Anlass> filteredAnlaesse = anlaesse.stream().filter(anlass -> {
			boolean erfassenClosed = anlass.getErfassenGeschlossen().isBefore(LocalDateTime.now());
			boolean isMuationenNotClosed = anlass.getAenderungenNichtMehrErlaubt().isAfter(LocalDateTime.now());
			boolean isDaysBefore = anlass.getAenderungenNichtMehrErlaubt().minusDays(mutationenDaysBefore)
					.isBefore(LocalDateTime.now());
			return isMuationenNotClosed && erfassenClosed && isDaysBefore;
		}).collect(Collectors.toList());

		sendMutationMailIfNeeded(filteredAnlaesse, "Mutationsschluss", "Mutationen möglich bis");
	}

	@Transactional(value = TxType.REQUIRES_NEW)
	@Scheduled(cron = "${scheduler.published.cron}")
	public void publishedCheck() {
		log.debug("Published check fired");

		List<Anlass> anlaesse = anlassSrv.getAnlaesse(true);

		List<Anlass> filteredAnlaesse = anlaesse.stream().filter(anlass -> {
			boolean erfassenOffen = anlass.getAnmeldungBeginn().isBefore(LocalDateTime.now());
			boolean published = anlass.isPublished();
			boolean publishedSent = anlass.isPublishedSent();
			return erfassenOffen && published && !publishedSent;
		}).collect(Collectors.toList());

		sendPublishedMailIfNeeded(filteredAnlaesse, "Neue Wettkampf Anmeldung möglich", "Anmeldung möglich bis");
	}

	private void sendPublishedMailIfNeeded(List<Anlass> filteredAnlaesse, String subject, String datumText) {
		log.info("sendPublishedMailIfNeeded Anzahl: {},  Wettkampf {}", filteredAnlaesse.size(), datumText);
		filteredAnlaesse.forEach(anlass -> {
			AtomicBoolean allreadySent = new AtomicBoolean(false);
			if (!anlass.isPublishedSent()) {
				List<Organisation> allZHOrgs = orgSrv.getAllZuercherOrganisationen();
				allZHOrgs.forEach(org -> {
					if (!simulate || (simulate && !allreadySent.get())) {
						sendMailToOrg(anlass, org, subject, anlass.getErfassenGeschlossen(), datumText, false);
						allreadySent.set(true);
					}
				});
				anlass.setPublishedSent(true);
				anlassSrv.save(anlass);
			}
		});

	}

	private void sendReminderMailIfNeeded(List<Anlass> filteredAnlaesse, String subject, String datumText) {
		log.info("sendReminderMailIfNeeded Anzahl: {},  Wettkampf {}", filteredAnlaesse.size(), datumText);
		AtomicBoolean allreadySent = new AtomicBoolean(false);
		filteredAnlaesse.forEach(anlass -> {
			if (!anlass.isReminderMeldeschlussSent()) {
				List<Organisation> allZHOrgs = orgSrv.getAllZuercherOrganisationen();
				allZHOrgs.forEach(org -> {
					if (!simulate || (simulate && !allreadySent.get())) {
						sendMailToOrg(anlass, org, subject, anlass.getErfassenGeschlossen(), datumText, true);
						allreadySent.set(true);
					}
				});
				anlass.setReminderMeldeschlussSent(true);
				anlassSrv.save(anlass);
			}
		});

	}

	private boolean sendMailToOrg(Anlass anlass, Organisation org, String subject, LocalDateTime datum,
			String datumText, boolean kontrollMail) {
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
			if (kontrollMail) {
				log.debug("Sende Mail an: {} / {}", opl.getOrganisation().getName(), opl.getPerson().getEmail());
				if (!sendAnmeldeKontrolleMail(anlass, org, opl.getPerson(), subject, datum, datumText)) {
					error.set(true);
				}
			} else {
				if (!sendPublishedMail(anlass, org, opl.getPerson(), subject, datum, datumText)) {
					error.set(true);
				}
			}
		});
		return error.get();
	}

	private void sendClosedMailIfNeeded(List<Anlass> filteredAnlaesse, String subject, String datumText) {

		filteredAnlaesse.forEach(anlass -> {
			anlass.getOrganisationenLinks().forEach(oal -> {
				Organisation org = oal.getOrganisation();
				if (oal.isAktiv() && !oal.isAnmeldeKontrolleSent()) {
					boolean error = sendMailToOrg(anlass, org, subject, anlass.getErfassenGeschlossen(), datumText,
							true);
					if (!error) {
						oal.setAnmeldeKontrolleSent(true);
						oalRepo.save(oal);
					}
				}
			});
		});
	}

	private void sendMutationMailIfNeeded(List<Anlass> filteredAnlaesse, String subject, String datumText) {
		log.info("sendMutationMailIfNeeded Anzahl: {},  Wettkampf {}", filteredAnlaesse.size(), datumText);
		filteredAnlaesse.forEach(anlass -> {
			anlass.getOrganisationenLinks().forEach(oal -> {
				Organisation org = oal.getOrganisation();
				if (oal.isAktiv() && !oal.isReminderMutationsschlussSent()) {
					boolean error = sendMailToOrg(anlass, org, subject, anlass.getAenderungenInKategorieGeschlossen(),
							datumText, true);
					if (!error) {
						oal.setReminderMutationsschlussSent(true);
						oalRepo.save(oal);
					}
				}
			});
		});
	}

	private boolean sendPublishedMail(Anlass anlass, Organisation org, Person person, String subject,
			LocalDateTime datum, String datumText) {
		AnmeldeKontrolleDTO anmeldeKontrolle = anlassSrv.getAnmeldeKontrolle(anlass.getId(), org.getId());
		Map<String, Object> templateModel = mailerService.getPublishedDaten(anmeldeKontrolle, subject, org);

		// Map<String, Object> templateModel = new HashMap();
		templateModel.put("recipientName", person.getEmail());
		templateModel.put("text", "AnmeldeKontrolle Daten");
		templateModel.put("senderName", sender);
		DateTimeFormatter formatters = DateTimeFormatter.ofPattern("dd.MM.yyyy");
		templateModel.put("datum", datum.format(formatters));
		templateModel.put("datumText", datumText);

		this.mailService.sendMessage(person, templateModel.get("subject").toString(), "published.html", templateModel);
		return true;
	}

	private boolean sendAnmeldeKontrolleMail(Anlass anlass, Organisation org, Person person, String subject,
			LocalDateTime datum, String datumText) {
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
		DateTimeFormatter formatters = DateTimeFormatter.ofPattern("dd.MM.yyyy");
		templateModel.put("datum", datum.format(formatters));
		templateModel.put("datumText", datumText);

		// Teilnehmer
		ByteArrayOutputStream outAnmeldekontrolle = new ByteArrayOutputStream();
		try {
			AnmeldeKontrolleOutput.createAnmeldeKontrolle(outAnmeldekontrolle, anmeldeKontrolle);
		} catch (IOException e) {
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
		} catch (IOException e) {
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
