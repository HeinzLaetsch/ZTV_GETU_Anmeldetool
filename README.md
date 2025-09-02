# ZTV_GETU_Anmeldetool

Anmeldetool für Geräteturn-Wettkämpfe des ZTV (Zürcher Turnverband). Dieses Repository enthält das Backend (Spring Boot), ein Web-Frontend und unterstützende Module.

- Architektur und Code-Überblick: siehe ARCHITECTURE.md
- Lizenz: siehe LICENSE

## Schnellstart
Voraussetzungen: Java 17+, Maven, Datenbankzugang (gemäß application.yml).

Bauen und starten:

1. mvn clean install
2. cd anmeldetool-server
3. mvn spring-boot:run

Standardmäßig sind nur folgende Pfade ohne Authentifizierung erreichbar:
- /timetable/**
- /health
- /actuator/**

Alle anderen Endpoints erfordern Authentifizierung (siehe ZTVSecurityConfig). Für Entwicklung ggf. Security anpassen.
