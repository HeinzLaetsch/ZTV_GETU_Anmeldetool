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
    ID            uuid          default random_uuid(),
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
    ID            uuid          default random_uuid(),
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
    ID            	uuid          default random_uuid(),
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
    ID            	uuid          default random_uuid(),
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
    ID            	uuid          default random_uuid(),
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
    ID            	uuid          default random_uuid(),
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

INSERT INTO VERBAND (ID, AKTIV, DELETED, VERBAND, VERBAND_LONG) VALUES (random_uuid(), '1', '0', 'STV', 'Schweizer Turnverband');
INSERT INTO VERBAND (ID, AKTIV, DELETED, VERBAND, VERBAND_LONG) VALUES (random_uuid(), '1', '0', 'ZTV', 'Zürcher Turnverband');
INSERT INTO VERBAND (ID, AKTIV, DELETED, VERBAND, VERBAND_LONG) VALUES (random_uuid(), '1', '0', 'GLZ', 'Region Glatt- Limmattal und Stadt Zürich');
INSERT INTO VERBAND (ID, AKTIV, DELETED, VERBAND, VERBAND_LONG) VALUES (random_uuid(), '1', '0', 'WTU', 'Region Winterthur und Umgebung');
INSERT INTO VERBAND (ID, AKTIV, DELETED, VERBAND, VERBAND_LONG) VALUES (random_uuid(), '1', '0', 'AZO', 'Region Albis, Zürichsee und Oberland');
INSERT INTO VERBAND (ID, AKTIV, DELETED, VERBAND, VERBAND_LONG) VALUES (random_uuid(), '1', '0', 'UTV', 'Urner Turnverband');
INSERT INTO VERBAND (ID, AKTIV, DELETED, VERBAND, VERBAND_LONG) VALUES (random_uuid(), '1', '0', 'GRTV', 'Graubündner Turnverband');

CREATE table WERTUNGSRICHTER
(
    ID            	uuid          default random_uuid(),
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
    ID            	uuid          default random_uuid(),
    AKTIV         	BOOLEAN,
    DELETED       	BOOLEAN,
    CHANGE_DATE   	TIMESTAMP(6),
    DELETION_DATE 	TIMESTAMP(6),
    
    ANLASS_BEZEICHNUNG	VARCHAR(100),
    ORT					VARCHAR(100),
    HALLE				VARCHAR(100),
    START_DATE   		TIMESTAMP(6),
    END_DATE	 		TIMESTAMP(6),
    TI_TU				VARCHAR(4),
    TIEFSTE_KATEGORIE	VARCHAR(2),
    HOECHSTE_KATEGORIE	VARCHAR(2),
     
    PRIMARY KEY (ID)
);
    
CREATE INDEX idx_ANLASS_DELETED ON ANLASS (DELETED);

CREATE INDEX idx_ANLASS_AKTIV ON ANLASS (AKTIV);

CREATE INDEX idx_ANLASS_TI_TU ON ANLASS (TI_TU);

INSERT INTO ANLASS (ID, AKTIV, DELETED, ANLASS_BEZEICHNUNG, ORT, HALLE, START_DATE, END_DATE, TI_TU, TIEFSTE_KATEGORIE, HOECHSTE_KATEGORIE) VALUES (random_uuid(), true, false, 'Frühlings wettkampf', 'Effretikon', 'Eselried',
 parsedatetime('17-4-2021 00:00:00.00', 'dd-MM-yyyy hh:mm:ss.SS'), parsedatetime('18-4-2021 00:00:00.00', 'dd-MM-yyyy hh:mm:ss.SS'), 'Ti', 'K1', 'K4');

INSERT INTO ANLASS (ID, AKTIV, DELETED, ANLASS_BEZEICHNUNG, ORT, HALLE, START_DATE, END_DATE, TI_TU, TIEFSTE_KATEGORIE, HOECHSTE_KATEGORIE) VALUES (random_uuid(), true, false, 'Geräteturnertag', 'Bonstettetn', 'Im Schachen',
 parsedatetime('13-5-2021 00:00:00.00', 'dd-MM-yyyy hh:mm:ss.SS'), parsedatetime('13-5-2021 00:00:00.00', 'dd-MM-yyyy hh:mm:ss.SS'), 'Tu', 'K1', 'K7');

INSERT INTO ANLASS (ID, AKTIV, DELETED, ANLASS_BEZEICHNUNG, ORT, HALLE, START_DATE, END_DATE, TI_TU, TIEFSTE_KATEGORIE, HOECHSTE_KATEGORIE) VALUES (random_uuid(), true, false, 'Geräteturnerinnen tag', 'Regensdorf', 'Wisacher',
 parsedatetime('12-6-2021 00:00:00.00', 'dd-MM-yyyy hh:mm:ss.SS'), parsedatetime('13-6-2021 00:00:00.00', 'dd-MM-yyyy hh:mm:ss.SS'), 'Ti', 'K1', 'K7');

INSERT INTO ANLASS (ID, AKTIV, DELETED, ANLASS_BEZEICHNUNG, ORT, HALLE, START_DATE, END_DATE, TI_TU, TIEFSTE_KATEGORIE, HOECHSTE_KATEGORIE) VALUES (random_uuid(), true, false, 'Gerätewettkampf', 'Rafz', 'Rafz',
 parsedatetime('10-7-2021 00:00:00.00', 'dd-MM-yyyy hh:mm:ss.SS'), parsedatetime('11-7-2021 00:00:00.00', 'dd-MM-yyyy hh:mm:ss.SS'), 'Ti', 'K1', 'K7');

INSERT INTO ANLASS (ID, AKTIV, DELETED, ANLASS_BEZEICHNUNG, ORT, HALLE, START_DATE, END_DATE, TI_TU, TIEFSTE_KATEGORIE, HOECHSTE_KATEGORIE) VALUES (random_uuid(), true, false, 'Kant. Geräte meisterschaften', 'Bonstetten', 'Im Schachen',
 parsedatetime('04-09-2021 00:00:00.00', 'dd-MM-yyyy hh:mm:ss.SS'), parsedatetime('05-09-2021 00:00:00.00', 'dd-MM-yyyy hh:mm:ss.SS'), 'Alle', 'K1', 'K7');

create table ORGANISATION_ANLASS_LINK
(
    ID            	uuid          default random_uuid(),
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
    ID            uuid          default random_uuid(),
    AKTIV         BOOLEAN,
    DELETED       BOOLEAN,
    CHANGE_DATE   TIMESTAMP(6),
    DELETION_DATE TIMESTAMP(6),
    
    NAME	   	  VARCHAR(100),
    VORNAME       VARCHAR(100),
    JAHRGANG      INTEGER,
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
    ID            	uuid          default random_uuid(),
    AKTIV         	BOOLEAN,
    DELETED       	BOOLEAN,
    CHANGE_DATE   	TIMESTAMP(6),
    DELETION_DATE 	TIMESTAMP(6),
 
    TEILNEHMER_ID uuid not null,
    ANLASS_ID       uuid not null,
    
    PRIMARY KEY (ID)
);

CREATE INDEX idx_TEILNEHMER_ANLASS_LINK_DELETED ON TEILNEHMER_ANLASS_LINK (DELETED);

CREATE INDEX idx_TEILNEHMER_ANLASS_LINK_ORGANISATION_ID ON TEILNEHMER_ANLASS_LINK (TEILNEHMER_ID);

CREATE INDEX idx_TEILNEHMER_ANLASS_LINK_PERSON_ID ON TEILNEHMER_ANLASS_LINK (ANLASS_ID);

