CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;

ALTER DATABASE getuwettkaempfe SET timezone TO 'Europe/Zurich';

-- create table CONFIG
--(
--    ID          int          not null,
--    KEY         VARCHAR(100) not null,
--    VALUE       VARCHAR(1000),
--    CHANGE_DATE TIMESTAMP(6),
--    CHANGED_BY  VARCHAR(7),
--    OLD_VALUE   VARCHAR(1000),
--    PRIMARY KEY (ID)
--);

create table ORGANISATION
(
    ID            uuid          default  gen_random_uuid(),
    AKTIV         BOOLEAN,
    DELETED       BOOLEAN,
    CHANGE_DATE   TIMESTAMP(6),
    DELETION_DATE TIMESTAMP(6),
    NAME	      VARCHAR(100),
    VERBAND_ID    uuid,
    PRIMARY KEY (ID)
);

CREATE UNIQUE INDEX uidx_ORGANISATION_NAME ON ORGANISATION (NAME);

CREATE INDEX idx_ORGANISATION_DELETED ON ORGANISATION (DELETED);

create table PERSON
(
    ID            uuid          default  gen_random_uuid(),
    AKTIV         BOOLEAN,
    DELETED       BOOLEAN,
    CHANGE_DATE   TIMESTAMP(6),
    DELETION_DATE TIMESTAMP(6),
    BENUTZERNAME  VARCHAR(100),
    NAME	   	  VARCHAR(100),
    VORNAME       VARCHAR(100),
    HANDY	      VARCHAR(13),
    EMAIL	      VARCHAR(100),
    PASSWORD	  VARCHAR(100),
    WERTUNGSRICHTER_ID uuid,
    
    PRIMARY KEY (ID)
);

-- INSERT INTO PERSON (ID, AKTIV, DELETED, BENUTZERNAME, NAME, EMAIL, PASSWORD) VALUES ('1', '1', '0', 'admin', 'Administrator', 'admin@ztv.ch', 'test');

CREATE INDEX idx_PERSON_DELETED ON PERSON (DELETED);

CREATE INDEX idx_PERSON_AKTIV ON PERSON (AKTIV);

CREATE INDEX idx_PERSON_EMAIL ON PERSON (EMAIL);

create table ORGANISATION_PERSON_LINK
(
    ID            	uuid          default  gen_random_uuid(),
    AKTIV         	BOOLEAN,
    DELETED       	BOOLEAN,
    CHANGE_DATE   	TIMESTAMP(6),
    DELETION_DATE 	TIMESTAMP(6),
    ORGANISATION_ID uuid not null,
    PERSON_ID       uuid, -- not null,
    PRIMARY KEY (ID)
);

CREATE INDEX idx_ORGANISATION_PERSON_LINK_DELETED ON ORGANISATION_PERSON_LINK (DELETED);

CREATE INDEX idx_ORGANISATION_PERSON_LINK_ORGANISATION_ID ON ORGANISATION_PERSON_LINK (ORGANISATION_ID);

CREATE INDEX idx_ORGANISATION_PERSON_LINK_PERSON_ID ON ORGANISATION_PERSON_LINK (PERSON_ID);

CREATE table ROLLE
(
    ID            	uuid          default  gen_random_uuid(),
    AKTIV         	BOOLEAN,
    DELETED       	BOOLEAN,
    CHANGE_DATE   	TIMESTAMP(6),
    DELETION_DATE 	TIMESTAMP(6),
    NAME	   		VARCHAR(100),
    BESCHREIBUNG    VARCHAR(200),
    PRIMARY KEY (ID)
);

CREATE INDEX idx_ROLLE_DELETED ON ROLLE (DELETED);

CREATE INDEX idx_ROLLE_AKTIV ON ROLLE (AKTIV);

CREATE INDEX idx_ROLLE_NAME ON ROLLE (NAME);

CREATE table ROLLEN_LINK
(
    ID            	uuid          default  gen_random_uuid(),
    AKTIV         	BOOLEAN,
    DELETED       	BOOLEAN,
    CHANGE_DATE   	TIMESTAMP(6),
    DELETION_DATE 	TIMESTAMP(6),
    ROLLEN_ID    	uuid not null,
    LINK_ID       	uuid not null,
    PRIMARY KEY (ID)
);

CREATE INDEX idx_ROLLEN_LINK_DELETED ON ROLLEN_LINK (DELETED);

CREATE INDEX idx_ROLLEN_LINK_AKTIV ON ROLLEN_LINK (AKTIV);

CREATE INDEX idx_ROLLEN_LINK_ROLLEN_ID ON ROLLEN_LINK (ROLLEN_ID);

CREATE INDEX idx_ROLLEN_LINK_LINK_ID ON ROLLEN_LINK (LINK_ID);

CREATE table VERBAND
(
    ID            	uuid          default  gen_random_uuid(),
    AKTIV         	BOOLEAN,
    DELETED       	BOOLEAN,
    CHANGE_DATE   	TIMESTAMP(6),
    DELETION_DATE 	TIMESTAMP(6),
    
    VERBAND			VARCHAR(6),
    VERBAND_LONG	VARCHAR(100),
    
    PRIMARY KEY (ID)
);
    
CREATE INDEX idx_VERBAND_DELETED ON VERBAND (DELETED);

CREATE INDEX idx_VERBAND_AKTIV ON VERBAND (AKTIV);

CREATE INDEX idx_VERBAND_VERBAND ON VERBAND (VERBAND);

INSERT INTO VERBAND (ID, AKTIV, DELETED, VERBAND, VERBAND_LONG) VALUES (gen_random_uuid(), '1', '0', 'STV', 'Schweizer Turnverband');
INSERT INTO VERBAND (ID, AKTIV, DELETED, VERBAND, VERBAND_LONG) VALUES (gen_random_uuid(), '1', '0', 'ZTV', 'Zürcher Turnverband');
INSERT INTO VERBAND (ID, AKTIV, DELETED, VERBAND, VERBAND_LONG) VALUES (gen_random_uuid(), '1', '0', 'GLZ', 'Region Glatt- Limmattal und Stadt Zürich');
INSERT INTO VERBAND (ID, AKTIV, DELETED, VERBAND, VERBAND_LONG) VALUES (gen_random_uuid(), '1', '0', 'WTU', 'Region Winterthur und Umgebung');
INSERT INTO VERBAND (ID, AKTIV, DELETED, VERBAND, VERBAND_LONG) VALUES (gen_random_uuid(), '1', '0', 'AZO', 'Region Albis, Zürichsee und Oberland');
INSERT INTO VERBAND (ID, AKTIV, DELETED, VERBAND, VERBAND_LONG) VALUES (gen_random_uuid(), '1', '0', 'UTV', 'Urner Turnverband');
INSERT INTO VERBAND (ID, AKTIV, DELETED, VERBAND, VERBAND_LONG) VALUES (gen_random_uuid(), '1', '0', 'GRTV', 'Graubündner Turnverband');

CREATE table WERTUNGSRICHTER
(
    ID            	uuid          default  gen_random_uuid(),
    AKTIV         	BOOLEAN,
    DELETED       	BOOLEAN,
    CHANGE_DATE   	TIMESTAMP(6),
    DELETION_DATE 	TIMESTAMP(6),
    
    PERSON_ID		uuid,
    BREVET			integer,
    GUELTIG			BOOLEAN,
    LETZTER_FK		TIMESTAMP(6),
    
    PRIMARY KEY (ID)
);
    
CREATE INDEX idx_WERTUNGSRICHTER_DELETED ON WERTUNGSRICHTER (DELETED);

CREATE INDEX idx_WERTUNGSRICHTER_AKTIV ON WERTUNGSRICHTER (AKTIV);

CREATE table ANLASS
(
    ID            	uuid          default  gen_random_uuid(),
    AKTIV         	BOOLEAN,
    DELETED       	BOOLEAN,
    CHANGE_DATE   	TIMESTAMP(6),
    DELETION_DATE 	TIMESTAMP(6),
    
    ANLASS_BEZEICHNUNG	VARCHAR(100),
    ORT					VARCHAR(100),
    HALLE				VARCHAR(100),
    ORGANISATOR			VARCHAR(100),
    START_DATE   		TIMESTAMP(6),
    END_DATE	 		TIMESTAMP(6),
    TI_TU				VARCHAR(4),
    TIEFSTE_KATEGORIE	VARCHAR(2),
    HOECHSTE_KATEGORIE	VARCHAR(2),

    ANMELDUNG_BEGINN		TIMESTAMP(6),
    ERFASSEN_GESCHLOSSEN	TIMESTAMP(6),
    CROSS_KATEGORIE_AENDERUNGEN_GESCHLOSSEN TIMESTAMP(6),
    AENDERUNGEN_IN_KATEGORIE_GESCHLOSSEN TIMESTAMP(6),
    AENDERUNGEN_NICHT_MEHR_ERLAUBT TIMESTAMP(6),
    PUBLISHED		BOOLEAN default TRUE,

    PRIMARY KEY (ID)
);
    
CREATE INDEX idx_ANLASS_DELETED ON ANLASS (DELETED);

CREATE INDEX idx_ANLASS_AKTIV ON ANLASS (AKTIV);

CREATE INDEX idx_ANLASS_TI_TU ON ANLASS (TI_TU);

ALTER TABLE ANLASS ADD IBAN VARCHAR(30);

INSERT INTO ANLASS (ID, AKTIV, DELETED, ANLASS_BEZEICHNUNG, ORT, HALLE, ORGANISATOR, IBAN, START_DATE, END_DATE, TI_TU, TIEFSTE_KATEGORIE, HOECHSTE_KATEGORIE, 
ANMELDUNG_BEGINN, ERFASSEN_GESCHLOSSEN, CROSS_KATEGORIE_AENDERUNGEN_GESCHLOSSEN, AENDERUNGEN_IN_KATEGORIE_GESCHLOSSEN, AENDERUNGEN_NICHT_MEHR_ERLAUBT) VALUES (gen_random_uuid(), true, false, 'Frühlings%wettkampf', 'Kloten', 'im Feld', 'TV Kloten', 'CH54 0070 0110 0050 8467 0',
 To_TimeStamp('3-4-2022', 'dd-MM-yyyy'), To_TimeStamp('3-4-2022', 'dd-MM-yyyy'), 'Tu', 'K1', 'K7',
 To_TimeStamp('10-01-2022', 'dd-MM-yyyy'),To_TimeStamp('06-02-2022', 'dd-MM-yyyy'),To_TimeStamp('06-02-2022', 'dd-MM-yyyy'),To_TimeStamp('06-02-2022', 'dd-MM-yyyy'),To_TimeStamp('30-3-2022', 'dd-MM-yyyy'));

create table ORGANISATION_ANLASS_LINK
(
    ID            	uuid          default  gen_random_uuid(),
    AKTIV         	BOOLEAN,
    DELETED       	BOOLEAN,
    CHANGE_DATE   	TIMESTAMP(6),
    DELETION_DATE 	TIMESTAMP(6),
 
    ORGANISATION_ID uuid not null,
    ANLASS_ID       uuid not null,
    
    PRIMARY KEY (ID)
);

CREATE INDEX idx_ORGANISATION_ANLASS_LINK_DELETED ON ORGANISATION_ANLASS_LINK (DELETED);

CREATE INDEX idx_ORGANISATION_ANLASS_LINK_ORGANISATION_ID ON ORGANISATION_ANLASS_LINK (ORGANISATION_ID);

CREATE INDEX idx_ORGANISATION_ANLASS_LINK_PERSON_ID ON ORGANISATION_ANLASS_LINK (ANLASS_ID);

create table TEILNEHMER
(
    ID            uuid          default  gen_random_uuid(),
    AKTIV         BOOLEAN,
    DELETED       BOOLEAN,
    CHANGE_DATE   TIMESTAMP(6),
    DELETION_DATE TIMESTAMP(6),
    
    NAME	   	  VARCHAR(100),
    VORNAME       VARCHAR(100),
    JAHRGANG      INTEGER,
    STV_NUMMER	  VARCHAR(7),
    TI_TU	      VARCHAR(4),
    ORGANISATION_ID uuid not null,
    DIRTY		  BOOLEAN,
    
    PRIMARY KEY (ID)
);

CREATE INDEX idx_TEILNEHMER_DELETED ON TEILNEHMER (DELETED);

CREATE INDEX idx_TEILNEHMER_AKTIV ON TEILNEHMER (AKTIV);

CREATE INDEX idx_TEILNEHMER_TI_TU ON TEILNEHMER (TI_TU);

CREATE INDEX idx_TEILNEHMER_NAME_VORNAME ON TEILNEHMER (NAME, VORNAME);

CREATE INDEX idx_TEILNEHMER_ORGANISATION_ID ON TEILNEHMER (ORGANISATION_ID);

CREATE INDEX idx_TEILNEHMER_DIRTY ON TEILNEHMER (DIRTY);

create table TEILNEHMER_ANLASS_LINK
(
    ID            	uuid          default  gen_random_uuid(),
    AKTIV         	BOOLEAN,
    DELETED       	BOOLEAN,
    CHANGE_DATE   	TIMESTAMP(6),
    DELETION_DATE 	TIMESTAMP(6),
    KATEGORIE       VARCHAR(20), 
 
    TEILNEHMER_ID 	uuid not null,
    ANLASS_ID       uuid not null,
    ORGANISATION_ID uuid not null,
    
    PRIMARY KEY (ID)
);

CREATE INDEX idx_TEILNEHMER_ANLASS_LINK_DELETED ON TEILNEHMER_ANLASS_LINK (DELETED);

CREATE INDEX idx_TEILNEHMER_ANLASS_LINK_TEILNEHMER_ID ON TEILNEHMER_ANLASS_LINK (TEILNEHMER_ID);

CREATE INDEX idx_TEILNEHMER_ANLASS_LINK_ORGANISATION_ID ON TEILNEHMER_ANLASS_LINK (ORGANISATION_ID);

CREATE INDEX idx_TEILNEHMER_ANLASS_LINK_ANLASS_ID ON TEILNEHMER_ANLASS_LINK (ANLASS_ID);

create table PERSON_ANLASS_LINK
(
    ID            	uuid          default  gen_random_uuid(),
    AKTIV         	BOOLEAN,
    DELETED       	BOOLEAN,
    CHANGE_DATE   	TIMESTAMP(6),
    DELETION_DATE 	TIMESTAMP(6),
 
    PERSON_ID 	uuid not null,
    ANLASS_ID       uuid not null,
    ORGANISATION_ID uuid not null,
    
   	KOMMENTAR		VARCHAR(200),
    
    PRIMARY KEY (ID)
);

CREATE INDEX idx_PERSON_ANLASS_LINK_DELETED ON PERSON_ANLASS_LINK (DELETED);

CREATE INDEX idx_PERSON_ANLASS_LINK_PERSON_ID ON PERSON_ANLASS_LINK (PERSON_ID);

CREATE INDEX idx_PERSON_ANLASS_LINK_ORGANISATION_ID ON PERSON_ANLASS_LINK (ORGANISATION_ID);

CREATE INDEX idx_PERSON_ANLASS_LINK_ANLASS_ID ON PERSON_ANLASS_LINK (ANLASS_ID);

create table WERTUNGSRICHTER_SLOT
(
    ID            	uuid          default gen_random_uuid(),
    AKTIV         	BOOLEAN,
    DELETED       	BOOLEAN,
    CHANGE_DATE   	TIMESTAMP(6),
    DELETION_DATE 	TIMESTAMP(6),
 
    ANLASS_ID       	uuid not null,
    REIHENFOLGE			INTEGER,
    BREVET				INTEGER,
    TAG 	TIMESTAMP(6),
    START_ZEIT			TIMESTAMP(6),
    END_ZEIT 			TIMESTAMP(6),
    BESCHREIBUNG	VARCHAR(50),
    
    PRIMARY KEY (ID)
);

CREATE INDEX idx_WERTUNGSRICHTER_SLOT_DELETED ON WERTUNGSRICHTER_SLOT (DELETED);

CREATE INDEX idx_WERTUNGSRICHTER_SLOT_REIHENFOLGE ON WERTUNGSRICHTER_SLOT (REIHENFOLGE);

CREATE INDEX idx_WERTUNGSRICHTER_SLOT_ANLASS_ID ON WERTUNGSRICHTER_SLOT (ANLASS_ID);

create table WERTUNGSRICHTER_EINSATZ
(
    ID            	uuid          default gen_random_uuid(),
    AKTIV         	BOOLEAN,
    DELETED       	BOOLEAN,
    CHANGE_DATE   	TIMESTAMP(6),
    DELETION_DATE 	TIMESTAMP(6),
 
    PERSON_ANLASS_LINK_ID  uuid not null,
    WERTUNGSRICHTER_SLOT_ID       	uuid not null,
    
    EINGESETZT     	BOOLEAN,
    
    PRIMARY KEY (ID)
);

CREATE INDEX idx_WERTUNGSRICHTER_EINSATZ_DELETED ON WERTUNGSRICHTER_EINSATZ (DELETED);

CREATE INDEX idx_WERTUNGSRICHTER_EINSATZ_PERSON_ANLASS_LINK_ID ON WERTUNGSRICHTER_EINSATZ (PERSON_ANLASS_LINK_ID);
