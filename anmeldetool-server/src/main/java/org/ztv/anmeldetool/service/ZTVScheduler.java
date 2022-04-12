package org.ztv.anmeldetool.service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;

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
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.output.AnmeldeKontrolleOutput;
import org.ztv.anmeldetool.output.WertungsrichterOutput;
import org.ztv.anmeldetool.transfer.AnmeldeKontrolleDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ZTVScheduler {
	@Autowired
	PersonService personSrv;

	@Autowired
	AnlassService anlassSrv;

	@Value("${spring.mail.username}")
	private String sender;

	@Value("${spring.mail.templates.path}")
	private String mailTemplatesPath;

	@Autowired
	private EmailService mailService;

	@Autowired
	MailerService mailerService;

	@Transactional(value = TxType.REQUIRES_NEW)
	@Scheduled(cron = "${scheduler.cron.reminder}")
	public void reminderCheck() {
		log.debug("Reminder fired");
		sendAnmeldeKontrolleMailIfNeeded();
	}

	private void sendAnmeldeKontrolleMailIfNeeded() {
		List<Anlass> anlaesse = anlassSrv.getAllAnlaesse();
		Person person = this.personSrv.findPersonByBenutzername("heinz.laetsch@gmx.ch");
		Organisation org = person.getOrganisationenLinks().iterator().next().getOrganisation();

		sendAnmeldeKontrolleMail(anlaesse.get(0), org, person);
	}

	private boolean sendAnmeldeKontrolleMail(Anlass anlass, Organisation org, Person person) {
		List<PersonAnlassLink> palBr1 = anlassSrv.getEingeteilteWertungsrichter(anlass.getId(), org.getId(),
				WertungsrichterBrevetEnum.Brevet_1);
		List<PersonAnlassLink> palBr2 = anlassSrv.getEingeteilteWertungsrichter(anlass.getId(), org.getId(),
				WertungsrichterBrevetEnum.Brevet_2);

		AnmeldeKontrolleDTO anmeldeKontrolle = anlassSrv.getAnmeldeKontrolle(anlass.getId(), org.getId());
		Map<String, Object> templateModel = mailerService.getAnmeldeDaten(anmeldeKontrolle, org);

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
