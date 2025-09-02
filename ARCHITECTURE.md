# ZTV_GETU_Anmeldetool – Architekturüberblick

Dieses Dokument erklärt die wichtigsten Bausteine des Projekts, die Datenmodelle sowie die zentralen Request-Flows. Es richtet sich an Entwicklerinnen und Entwickler, die sich schnell in den Code einarbeiten möchten.

Inhalt
- Überblick und Module
- Startpunkt und Konfiguration
- Sicherheitskonzept
- Domänenmodell (wichtige Entities)
- Services (Business-Logik)
- Controller (REST-API)
- Mapper/DTOs
- Scheduled Tasks, E-Mail, Exporte
- Lokales Bauen und Starten

## Überblick und Module
Das Projekt ist ein Spring-Boot-basiertes Anmeldetool für Geräteturn-Wettkämpfe des ZTV.

Module im Repository:
- anmeldetool-server: Spring Boot Backend (REST-API, Datenzugriff, Business-Logik)
- anmeldetool-web: Frontend (nicht im Detail betrachtet)
- TestSecurity: kleines Test-/Beispielmodul für Security (separat)

Der Einstiegspunkt der Anwendung ist:
- org.ztv.anmeldetool.AnmeldetoolApplication

## Startpunkt und Konfiguration
- AnmeldetoolApplication: Standard SpringBootApplication mit main-Methode. Startet das Backend.
- Konfigurationen:
  - org.ztv.anmeldetool.config.ZTVSecurityConfig: SecurityFilterChain und PasswordEncoder (BCrypt)
  - org.ztv.anmeldetool.config.SpringFoxConfig: aktuell deaktiviert (Kommentar), potentiell für Swagger
  - Weitere Konfigurationsklassen für Mail/Scheduler sind vorhanden (ZTVMailConfigurer, ZTVSchedulerConfigurer). 
- application.yml: enthält Umgebungs- und Infrastruktursettings (Datenbank, Ports, etc.).

## Sicherheitskonzept
ZTVSecurityConfig konfiguriert HTTP Security:
- CORS: erlaubt mit Defaults
- CSRF: disabled (stateless)
- Freigegebene Endpoints: /timetable/**, /health, /actuator/**
- Alle anderen Endpoints: authentication required
- SessionCreationPolicy.STATELESS, Basic/Form-Login explizit disabled
- PasswordEncoder: BCryptPasswordEncoder

Hinweis: LoginService baut intern einen Authentication-Token, das eigentliche AuthenticationManager-Handling ist auskommentiert. Der Service prüft vor allem Domänenregeln (Person vorhanden, Organisation vorhanden, Person ist Mitglied der Organisation) und erzeugt PersonDTO für das Frontend.

## Domänenmodell (wichtige Entities)
Alle Entities befinden sich unter org.ztv.anmeldetool.models. Auswahl:
- Base: gemeinsame Basisklasse (ID, Auditing-Felder, etc.; Code einsehen für Details)
- Organisation: Verein/Organisation mit Name, Bezeichnung, Verband, Links zu Personen und zu organisierten Anlässen
  - Beziehung zu Verband (ManyToOne)
  - Beziehung zu Personen über OrganisationPersonLink (n:m)
  - Hilfsfunktion cleanName(), um den Anzeigenamen zu bereinigen
- Person: Benutzer mit benutzername, name, vorname, handy, email, password und Links zu Organisationen
  - Optional 1:1-Verknüpfung zu Wertungsrichter
- Verband: übergeordneter Verband
- Anlass: ein Wettkampf/Anlass (Details in Datei anschauen)
- Teilnehmer, TeilnehmerAnlassLink: Teilnehmer und ihre Anmeldungen/Startdaten zu einem Anlass
- OrganisationAnlassLink, OrganisationPersonLink: Link-Entities für n:m-Beziehungen inkl. Zusatzinfos (z. B. Rollen)
- Wertungsrichter, WertungsrichterEinsatz, WertungsrichterSlot: Abbildung von Kampfrichtern und deren Einsätzen
- Enums (KategorieEnum, AbteilungEnum, AnlageEnum, GeraetEnum, MeldeStatusEnum, etc.) zur Modellierung von Wettkampfparametern

## Services (Business-Logik)
Services liegen unter org.ztv.anmeldetool.service. Auswahl:
- PersonService, OrganisationService, VerbandService: CRUD/Abfragen rund um Personen, Organisationen, Verbände
- TeilnehmerService, TeilnehmerAnlassLinkService: zentrale Logik für Teilnehmer und deren Anmeldungen zu Anlässen
  - Beispiel: TeilnehmerAnlassLinkService bietet Abfragen und Statistiken nach Kategorie/Abteilung/Anlage/Gerät, Vergabe und Aktualisierung von Startnummern, CSV-Import/Update, Mutationslisten
- AnlassService, AnlassSummaryService: Verwaltung und Auswertung von Anlässen
- WertungsrichterService, WertungsrichterEinsatzService: Verfügbarkeit, Zuteilung und Export von Kampfrichtern
- LoginService: Domänenvalidiertes Login (Person + Organisation), Aufbau SecurityContext (AuthenticationManager ist auskommentiert)
- StvContestService, LauflistenService, RanglistenService: domänenspezifische Generierung von Listen/Exports/Rankings

Die Services verwenden meist Repositories (Spring Data JPA) und geben oft DTOs oder Entities zurück, die in den Controllern serialisiert werden.

## Controller (REST-API)
Controller liegen unter org.ztv.anmeldetool.controller. Auswahl:

- AdminController (/admin)
  - Authentication-nahe Endpoints (Login), Benutzer-/Rollen-/Organisation-Verwaltung, Teilnehmer-CRUD je Organisation, Verbandsliste, Starts
  - Verwendet u. a. PersonService, OrganisationService, TeilnehmerService, TeilnehmerAnlassLinkService
  - Nutzt Mapper (PersonMapper, OrganisationMapper, etc.) zur DTO-Transformation

- AnlassAdminController (/anlass/admin oder ähnlich, genaue Mappings in Klasse)
  - Sehr umfangreich: Verwaltung von Anlässen, Vereinsstarts, Teilnehmerlisten-Exporte/Importe (CSV), Statistiken, Mutationen
  - Endpoints für Wertungsrichterlisten, Einsätze, PDF-Exporte (AnmeldeKontrolle, WertungsrichterKontrolle)
  - Feingranulare Filter: Kategorie, Abteilung, Anlage, Gerät, Suche
  - Arbeitet intensiv mit TeilnehmerAnlassLinkService und diversen Mappern/Exportern

- Weitere Controller: AnlassController, SmQualiController, TeilnahmenController
  - Bieten lesende und schreibende Endpoints rund um Anlässe, Qualifikationen, Teilnahmen

Converter unter controller.util erlauben, Enum-Werte (Kategorie, Abteilung, Anlage, Gerät, MeldeStatus) aus String-Requests komfortabel zu mappen.

## Mapper/DTOs
Unter org.ztv.anmeldetool.transfer liegen DTOs wie PersonDTO, OrganisationDTO, TeilnehmerDTO, OrganisationAnlassLinkDTO, WertungsrichterDTO etc. 
Mapper unter org.ztv.anmeldetool.util (z. B. PersonMapper, OrganisationMapper, TeilnehmerAnlassLinkMapper, WertungsrichterMapper) wandeln Entities in DTOs und zurück. 
Spezielle Export/Import-Mapper (z. B. TeilnehmerAnlassLinkExportImportMapper, PersonAnlassLinkExportImportMapper) bedienen CSV- oder PDF-Generierung.

## Scheduled Tasks, E-Mail, Exporte
- ZTVScheduler und ZTVSchedulerConfigurer: geplante Aufgaben (z. B. periodische Berechnungen/Exporte)
- EmailService/EmailServiceImpl/MailerService und ZTVMailConfigurer: Versand von E-Mails (z. B. Bestätigungen, Infos)
- Exportklassen wie BenutzerExport, WertungsrichterExport, AnmeldeKontrolleExport erzeugen Ausgabedateien (CSV/PDF)

## Request-Flows (Beispiele)
- Login: AdminController.post(LoginData)
  1) Person via Benutzername suchen
  2) Organisation via ID laden
  3) Mitgliedschaft prüfen (PersonHelper.isPersonMemberOfOrganisation)
  4) SecurityContext setzen (Authentication-Objekt derzeit null/auskommentiert)
  5) PersonDTO mit Organisationskontext zurückgeben

- Teilnehmerübersicht pro Verein: AdminController.getTeilnehmer(orgId, page, size)
  1) Organisation laden, Paging mit PageRequest
  2) TeilnehmerService/Repositories abfragen
  3) TeilnehmerDTOs zurückgeben

- Anlass-Statistik: AnlassAdminController.getAnlassStatistic(...)
  1) Filter entgegennehmen (Kategorie/Abteilung/Anlage/Gerät/Suche)
  2) TeilnehmerAnlassLinkService.getStatisticForAnlass(...) aufrufen
  3) TeilnahmeStatisticDTO mit aggregierten Zahlen liefern

## Lokales Bauen und Starten
Voraussetzungen: Java 17+ (abhängig vom pom), Maven.

- Bauen: `mvn clean install`
- Backend starten (im Modul anmeldetool-server): `mvn spring-boot:run`
- Standard-Security blockiert nicht freigegebene Endpoints. Für Entwicklung ggf. Security anpassen oder /health, /actuator/** nutzen.

## Erweiterungshinweise
- Neue Endpoints: in passenden Controller einfügen, Services wiederverwenden, DTOs/Mapper bauen
- Datenmodell: Relations über Link-Entities konsistent halten (z. B. OrganisationPersonLink)
- Sicherheit: Endpoints per ZTVSecurityConfig freigeben oder schützen; PasswordEncoder verwenden
- Tests: unter src/test/java existieren Service-Tests (z. B. TeilnehmerAnlassLinkServiceTests)
