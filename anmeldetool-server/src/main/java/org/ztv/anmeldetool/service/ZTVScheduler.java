package org.ztv.anmeldetool.service;

import jakarta.activation.DataSource;
import jakarta.mail.util.ByteArrayDataSource;
import jakarta.transaction.Transactional;
import jakarta.transaction.Transactional.TxType;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.MailTypeEnum;
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

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.EnumMap;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Slf4j
@RequiredArgsConstructor
@Component
public class ZTVScheduler {

  private final AnlassService anlassSrv;
  private final AnmeldekontrolService anmeldekontrolSrv;

  private final OrganisationService orgSrv;
  private final PersonAnlassLinkService personAnlassLinkSrv;

  private final OrganisationAnlassLinkRepository oalRepo;
  private final MailerService mailerService;
  private final EmailService mailService;

  @Value("${info.app.web:'https://ztv-anmeldetool.duckdns.org/ztv-anmeldetool'}")
  private String web;

  @Value("${spring.mail.simulate}")
  private boolean simulate;
  @Value("${spring.mail.username:''}")
  private String sender;
  @Value("${spring.mail.templates.path:''}")
  private String mailTemplatesPath;
  @Value("${scheduler.reminder.daysbefore}")
  private int reminderDaysBefore;

  @Value("${scheduler.closed.daysafter}")
  private int closedDaysAfter;

  @Value("${scheduler.mutationen.daysbefore}")
  private int mutationenDaysBefore;

  @Value("${scheduler.riegenaufteilung.daysbefore}")
  private int riegenAufteilungDaysBefore;

  @Transactional(value = TxType.REQUIRES_NEW)
  @Scheduled(cron = "${scheduler.riegenaufteilung.cron}")
  public void riegenAufteilungCheck() {
    log.info("Riegenaufteilung check fired");

    List<Anlass> anlaesse = anlassSrv.getAnlaesse(true);

    List<Anlass> filteredAnlaesse = anlaesse.stream().filter(anlass -> {
      boolean riegenAufteilungSent = !anlass.isRiegenAufteilungSent();
      boolean isSameDay = anlass.getStartDate().minusDays(riegenAufteilungDaysBefore)
          .toLocalDate().isEqual(LocalDateTime.now().toLocalDate());
      return riegenAufteilungSent && isSameDay;
    }).toList();

    log.info("Found {} Anläss", filteredAnlaesse.size());

    //MOVe
    filteredAnlaesse.forEach(anlass -> {
      Map<Organisation, HashMap<String, Boolean>> aufgeteilt = anmeldekontrolSrv.getAufgeteilteRiegen(anlass);
      boolean success= sendAufteilungsMailIfNeeded(anlass, aufgeteilt, "Riegenaufteilung");
      if (!success) {
        log.warn("Senden von Riegenaufteilung für Anlass {} ist fehlgeschlagen", anlass.getAnlassBezeichnung());
      }
      anlass.setRiegenAufteilungSent(success);
      anlassSrv.updateAnlass(anlass);

    });
  }

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
    }).toList();

    sendReminderMailIfNeeded(filteredAnlaesse, "Stand der Anmeldung", "Meldeschluss ist");
  }

  @Transactional(value = TxType.REQUIRES_NEW)
  @Scheduled(cron = "${scheduler.closed.cron}")
  public void reminderClosed() {
    log.debug("Closed fired");

    List<Anlass> anlaesse = anlassSrv.getAnlaesse(true);

    List<Anlass> filteredAnlaesse = anlaesse.stream().filter(anlass -> {
      boolean aenderungenNotClosed = anlass.getAenderungenNichtMehrErlaubt()
          .isAfter(LocalDateTime.now());
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
      boolean isMuationenNotClosed = anlass.getAenderungenNichtMehrErlaubt()
          .isAfter(LocalDateTime.now());
      boolean isDaysBefore = anlass.getAenderungenNichtMehrErlaubt().minusDays(mutationenDaysBefore)
          .isBefore(LocalDateTime.now());
      return isMuationenNotClosed && erfassenClosed && isDaysBefore;
    }).toList();
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
    }).toList();

    sendPublishedMailIfNeeded(filteredAnlaesse, "Neue Wettkampf Anmeldung möglich",
        "Anmeldung möglich bis");
  }

  private void sendPublishedMailIfNeeded(List<Anlass> filteredAnlaesse, String subject,
      String datumText) {
    log.info("sendPublishedMailIfNeeded Anzahl: {},  Wettkampf {}", filteredAnlaesse.size(),
        datumText);
    filteredAnlaesse.forEach(anlass -> {
      AtomicBoolean allreadySent = new AtomicBoolean(false);
      if (!anlass.isPublishedSent()) {
        List<Organisation> allZHOrgs = orgSrv.getAllZuercherOrganisationen();
        allZHOrgs.forEach(org -> {
          if (!simulate || (simulate && !allreadySent.get())) {
            sendMailToOrg(anlass, org, subject, anlass.getErfassenGeschlossen(), datumText,
                MailTypeEnum.ANLASSPUBLISHEDMAIL, null);
            allreadySent.set(true);
          }
        });
        anlass.setPublishedSent(true);
        anlassSrv.save(anlass);
      }
    });

  }

  private boolean sendAufteilungsMailIfNeeded(Anlass anlass, Map<Organisation, HashMap<String, Boolean>> aufgeteilt, String subject) {
    AtomicBoolean success = new AtomicBoolean(false);
    aufgeteilt.forEach((org, kategorieMap) -> {
      if (kategorieMap.containsValue(true)) {
        log.info("sendAufteilungsMailIfNeeded Anlass: {}, Org: {}, Wettkampf {}", anlass.getAnlassBezeichnung(), org.getName(), subject);
        if (!anlass.isRiegenAufteilungSent()) {
          success.set(sendMailToOrg(anlass, org, subject, anlass.getErfassenGeschlossen(), "Riegenaufteilung", MailTypeEnum.RIEGENAUFTEILUNG,
                kategorieMap));
        }
      } else {
        log.info("No need to send Mail: Anlass: {}, Org: {}, Wettkampf {}", anlass.getAnlassBezeichnung(), org.getName(), subject);
      }
    });
    return success.get();
  }

  private void sendReminderMailIfNeeded(List<Anlass> filteredAnlaesse, String subject,
      String datumText) {
    log.info("sendReminderMailIfNeeded Anzahl: {},  Wettkampf {}", filteredAnlaesse.size(),
        datumText);
    AtomicBoolean allreadySent = new AtomicBoolean(false);
    filteredAnlaesse.forEach(anlass -> {
      if (!anlass.isReminderMeldeschlussSent()) {
        List<Organisation> allZHOrgs = orgSrv.getAllZuercherOrganisationen();
        allZHOrgs.forEach(org -> {
          if (!simulate || (simulate && !allreadySent.get())) {
            sendMailToOrg(anlass, org, subject, anlass.getErfassenGeschlossen(), datumText,
                MailTypeEnum.ANMELDEKONTROLLMAIL, null);
            allreadySent.set(true);
          }
        });
        anlass.setReminderMeldeschlussSent(true);
        anlassSrv.save(anlass);
      }
    });

  }

  private boolean sendMailToOrg(Anlass anlass, Organisation org, String subject,
      LocalDateTime datum,
      String datumText, MailTypeEnum mailType, Map data) {
    Stream<OrganisationPersonLink> oplStream = org.getPersonenLinks().stream().filter(pl -> {
      return pl.getRollenLink().stream().anyMatch(rolle -> {
        log.debug("Name : {}", pl.getPerson().getBenutzername());
        return rolle.getRolle().getName().equals(RollenEnum.VEREINSVERANTWORTLICHER.name())
            || rolle.getRolle().getName().equals(RollenEnum.ANMELDER.name());
      });
    });
    AtomicBoolean success = new AtomicBoolean(false);
    oplStream.forEach(opl -> {
      log.info("Sende {} Mail an: {} / {}", mailType.name(), opl.getOrganisation().getName(),
          opl.getPerson().getEmail());
      switch (mailType) {
        case ANMELDEKONTROLLMAIL:
          if (sendAnmeldeKontrolleMail(anlass, org, opl.getPerson(), subject, datum, datumText)) {
            success.set(true);
          }
          break;
        case ANLASSPUBLISHEDMAIL:
          if (sendPublishedMail(anlass, org, opl.getPerson(), subject, datum, datumText)) {
            success.set(true);
          }
          break;
        case RIEGENAUFTEILUNG:
          if (sendRiegenAufteilungMail(anlass, org, opl.getPerson(), subject, datum, datumText, data)) {
            success.set(true);
          }
          break;
        default:
          throw new IllegalArgumentException("Unsupported mail type: " + mailType);
      }
    });
    return success.get();
  }

  private void sendClosedMailIfNeeded(List<Anlass> filteredAnlaesse, String subject,
      String datumText) {

    filteredAnlaesse.forEach(anlass -> {
      anlass.getOrganisationenLinks().forEach(oal -> {
        Organisation org = oal.getOrganisation();
        if (oal.isAktiv() && !oal.isAnmeldeKontrolleSent()) {
          boolean success = sendMailToOrg(anlass, org, subject, anlass.getErfassenGeschlossen(),
              datumText,
              MailTypeEnum.ANMELDEKONTROLLMAIL, null);
          if (success) {
            oal.setAnmeldeKontrolleSent(true);
            oalRepo.save(oal);
          }
        }
      });
    });
  }

  private void sendMutationMailIfNeeded(List<Anlass> filteredAnlaesse, String subject,
      String datumText) {
    log.info("sendMutationMailIfNeeded Anzahl: {},  Wettkampf {}", filteredAnlaesse.size(),
        datumText);
    filteredAnlaesse.forEach(anlass -> {
      anlass.getOrganisationenLinks().forEach(oal -> {
        Organisation org = oal.getOrganisation();
        if (oal.isAktiv() && !oal.isReminderMutationsschlussSent()) {
          boolean success = sendMailToOrg(anlass, org, subject,
              anlass.getAenderungenInKategorieGeschlossen(),
              datumText, MailTypeEnum.ANMELDEKONTROLLMAIL, null);
          if (success) {
            oal.setReminderMutationsschlussSent(true);
            oalRepo.save(oal);
          }
        }
      });
    });
  }

  private boolean sendPublishedMail(Anlass anlass, Organisation org, Person person, String subject,
      LocalDateTime datum, String datumText) {
    AnmeldeKontrolleDTO anmeldeKontrolle = anmeldekontrolSrv.getAnmeldeKontrolle(anlass,
        org);
    Map<String, Object> templateModel = mailerService.getPublishedDaten(anmeldeKontrolle, subject,
        org);

    templateModel.put("recipientName", person.getEmail());
    templateModel.put("text", "AnmeldeKontrolle Daten");
    templateModel.put("senderName", sender);
    DateTimeFormatter formatters = DateTimeFormatter.ofPattern("dd.MM.yyyy");
    templateModel.put("datum", datum.format(formatters));
    templateModel.put("datumText", datumText);

    this.mailService.sendMessage(person, templateModel.get("subject").toString(), "published.html",
        templateModel);
    return true;
  }

  private boolean sendRiegenAufteilungMail(Anlass anlass, Organisation org, Person person,
      String subject,
      LocalDateTime datum, String datumText, Map<String, Boolean> data) {
    if (data != null) {
      Map<String, Object> templateModel = mailerService.getRiegenAufteilungsDaten(anlass, data, org,
          subject);
      templateModel.put("recipientName", person.getEmail());
      templateModel.put("text", "Riegenaufteilung");
      templateModel.put("web", web);
      templateModel.put("senderName", sender);
      DateTimeFormatter formatters = DateTimeFormatter.ofPattern("dd.MM.yyyy");
      templateModel.put("datum", datum.format(formatters));
      templateModel.put("datumText", datumText);
      this.mailService.sendMessage(person, templateModel.get("subject").toString(),
          "riegen-aufteilung.html",
          templateModel);
    }
    return true;
  }

  private boolean sendAnmeldeKontrolleMail(Anlass anlass, Organisation org, Person person,
      String subject,
      LocalDateTime datum, String datumText) {
    List<PersonAnlassLink> palBr1 = personAnlassLinkSrv.getEingeteilteWertungsrichter(anlass, org,
        WertungsrichterBrevetEnum.Brevet_1);
    List<PersonAnlassLink> palBr2 = personAnlassLinkSrv.getEingeteilteWertungsrichter(anlass, org,
        WertungsrichterBrevetEnum.Brevet_2);

    AnmeldeKontrolleDTO anmeldeKontrolle = anmeldekontrolSrv.getAnmeldeKontrolle(anlass, org);
    Map<String, Object> templateModel = mailerService.getAnmeldeDaten(anmeldeKontrolle, org,
        subject);

    templateModel.put("recipientName", person.getEmail());
    templateModel.put("text", "AnmeldeKontrolle Daten");
    templateModel.put("senderName", sender);
    DateTimeFormatter formatters = DateTimeFormatter.ofPattern("dd.MM.yyyy");
    templateModel.put("datum", datum.format(formatters));
    templateModel.put("datumText", datumText);

    // Teilnehmer
    ByteArrayOutputStream outAnmeldekontrolle = new ByteArrayOutputStream();
    AnmeldeKontrolleOutput.csvWriteToWriter(anmeldeKontrolle, outAnmeldekontrolle);

    ByteArrayDataSource sourceAnmeldekontrolle = new ByteArrayDataSource(
        outAnmeldekontrolle.toByteArray(),
        "application/pdf");
    sourceAnmeldekontrolle.setName("AnmeldeKontrolle");

    // Wertungsrichter
    ByteArrayOutputStream outWertungsrichter = new ByteArrayOutputStream();
    try {
      WertungsrichterOutput.createWertungsrichter(outWertungsrichter, anmeldeKontrolle, palBr1,
          palBr2);
    } catch (IOException e) {
      log.warn("Could not create WertungsrichterOutput", e);
      return false;
    }

    ByteArrayDataSource sourceWertungsrichter = new ByteArrayDataSource(
        outWertungsrichter.toByteArray(),
        "application/pdf");
    sourceWertungsrichter.setName("Wertungsrichter");

    DataSource[] sources = new ByteArrayDataSource[] {sourceAnmeldekontrolle, sourceWertungsrichter};

    this.mailService.sendMessage(person, templateModel.get("subject").toString(),
        "anmelde-status.html",
        templateModel, sources);
    return true;
  }
}
