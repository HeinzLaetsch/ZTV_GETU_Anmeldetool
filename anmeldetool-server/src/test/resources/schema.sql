create table ORGANISATION
(
    ID            uuid default RANDOM_UUID(),
    AKTIV         BOOLEAN,
    DELETED       BOOLEAN,
    CHANGE_DATE   TIMESTAMP(6),
    DELETION_DATE TIMESTAMP(6),
    NAME          VARCHAR(100),
    BEZEICHNUNG   VARCHAR(30),
    VERBAND_ID    uuid,
    PRIMARY KEY (ID)
);
create table PERSON
(
    ID                 uuid default RANDOM_UUID(),
    AKTIV              BOOLEAN,
    DELETED            BOOLEAN,
    CHANGE_DATE        TIMESTAMP(6),
    DELETION_DATE      TIMESTAMP(6),
    BENUTZERNAME       VARCHAR(100),
    NAME               VARCHAR(100),
    VORNAME            VARCHAR(100),
    HANDY              VARCHAR(13),
    EMAIL              VARCHAR(100),
    PASSWORD           VARCHAR(100),
    WERTUNGSRICHTER_ID uuid,

    PRIMARY KEY (ID)
);

create table ORGANISATION_PERSON_LINK
(
    ID              uuid default RANDOM_UUID(),
    AKTIV           BOOLEAN,
    DELETED         BOOLEAN,
    CHANGE_DATE     TIMESTAMP(6),
    DELETION_DATE   TIMESTAMP(6),
    ORGANISATION_ID uuid not null,
    PERSON_ID       uuid, -- not null,
    PRIMARY KEY (ID)
);

CREATE table ROLLE
(
    ID                uuid    default RANDOM_UUID(),
    AKTIV             BOOLEAN,
    DELETED           BOOLEAN,
    CHANGE_DATE       TIMESTAMP(6),
    DELETION_DATE     TIMESTAMP(6),
    NAME              VARCHAR(100),
    BESCHREIBUNG      VARCHAR(200),
    PUBLIC_ASSIGNABLE BOOLEAN default true,
    PRIMARY KEY (ID)
);

CREATE table ROLLEN_LINK
(
    ID            uuid default RANDOM_UUID(),
    AKTIV         BOOLEAN,
    DELETED       BOOLEAN,
    CHANGE_DATE   TIMESTAMP(6),
    DELETION_DATE TIMESTAMP(6),
    ROLLEN_ID     uuid not null,
    LINK_ID       uuid not null,
    PRIMARY KEY (ID)
);

CREATE table VERBAND
(
    ID            uuid default RANDOM_UUID(),
    AKTIV         BOOLEAN,
    DELETED       BOOLEAN,
    CHANGE_DATE   TIMESTAMP(6),
    DELETION_DATE TIMESTAMP(6),

    VERBAND       VARCHAR(6),
    VERBAND_LONG  VARCHAR(100),

    PRIMARY KEY (ID)
);
CREATE table WERTUNGSRICHTER
(
    ID            uuid default RANDOM_UUID(),
    AKTIV         BOOLEAN,
    DELETED       BOOLEAN,
    CHANGE_DATE   TIMESTAMP(6),
    DELETION_DATE TIMESTAMP(6),

    PERSON_ID     uuid,
    BREVET        INTEGER,
    GUELTIG       BOOLEAN,
    LETZTER_FK    TIMESTAMP(6),

    PRIMARY KEY (ID)
);
CREATE table ANLASS
(
    ID                                      uuid    default RANDOM_UUID(),
    AKTIV                                   BOOLEAN,
    DELETED                                 BOOLEAN,
    CHANGE_DATE                             TIMESTAMP(6),
    DELETION_DATE                           TIMESTAMP(6),

    ANLASS_BEZEICHNUNG                      VARCHAR(100),
    ORT                                     VARCHAR(100),
    HALLE                                   VARCHAR(100),
    ORGANISATOR                             VARCHAR(100),
    START_DATE                              TIMESTAMP(6),
    END_DATE                                TIMESTAMP(6),
    TI_TU                                   VARCHAR(4),
    TIEFSTE_KATEGORIE                       VARCHAR(2),
    HOECHSTE_KATEGORIE                      VARCHAR(2),

    ANMELDUNG_BEGINN                        TIMESTAMP(6),
    ERFASSEN_GESCHLOSSEN                    TIMESTAMP(6),
    CROSS_KATEGORIE_AENDERUNGEN_GESCHLOSSEN TIMESTAMP(6),
    AENDERUNGEN_IN_KATEGORIE_GESCHLOSSEN    TIMESTAMP(6),
    AENDERUNGEN_NICHT_MEHR_ERLAUBT          TIMESTAMP(6),
    PUBLISHED                               BOOLEAN default TRUE,
    ABTEILUNG_FIX                           BOOLEAN default false,
    ANLAGE_FIX                              BOOLEAN default false,
    STARTGERAET_FIX                         BOOLEAN default false,
    SM_QUALI                                BOOLEAN default true,
    AUSSERKANTONAL                          BOOLEAN default false,
    zu_gunsten                              varchar(200),
    bank                                    varchar(200),
    IBAN                                    VARCHAR(30),
    KATEGORIEN_SPONSOREN                    VARCHAR(1000),
    organisator_id                          uuid,
    PUBLISHED_SENT                          BOOLEAN default false,
    reminder_meldeschluss_sent              BOOLEAN default false,
    tool_sperren                            BOOLEAN default false,
    RANGLISTEN_FOOTER                       VARCHAR(100),
    PRIMARY KEY (ID)
);

create table TEILNEHMER_ANLASS_LINK
(
    ID                      uuid default RANDOM_UUID(),
    AKTIV                   BOOLEAN,
    DELETED                 BOOLEAN,
    CHANGE_DATE             TIMESTAMP(6),
    DELETION_DATE           TIMESTAMP(6),
    KATEGORIE               VARCHAR(20),

    TEILNEHMER_ID           uuid not null,
    ANLASS_ID               uuid not null,
    ORGANISATION_ID         uuid not null,
    LAUFLISTEN_CONTAINER_ID uuid,
    STARTNUMMER             INTEGER,
    ABTEILUNG               VARCHAR(12),
    ANLAGE                  VARCHAR(12),
    STARTGERAET             varchar(100),
    NOTENBLATT_ID           uuid,
    MELDE_STATUS            VARCHAR(20),
    PRIMARY KEY (ID)
);

create table PERSON_ANLASS_LINK
(
    ID              uuid default RANDOM_UUID(),
    AKTIV           BOOLEAN,
    DELETED         BOOLEAN,
    CHANGE_DATE     TIMESTAMP(6),
    DELETION_DATE   TIMESTAMP(6),

    PERSON_ID       uuid not null,
    ANLASS_ID       uuid not null,
    ORGANISATION_ID uuid not null,

    KOMMENTAR       VARCHAR(200),

    PRIMARY KEY (ID)
);

create table WERTUNGSRICHTER_SLOT
(
    ID            uuid    default RANDOM_UUID(),
    AKTIV         BOOLEAN,
    DELETED       BOOLEAN,
    CHANGE_DATE   TIMESTAMP(6),
    DELETION_DATE TIMESTAMP(6),

    ANLASS_ID     uuid not null,
    REIHENFOLGE   INTEGER,
    BREVET        INTEGER,
    TAG           TIMESTAMP(6),
    START_ZEIT    TIMESTAMP(6),
    END_ZEIT      TIMESTAMP(6),
    BESCHREIBUNG  VARCHAR(50),
    EGAL_SLOT     BOOLEAN default false,
    PRIMARY KEY (ID)
);
create table WERTUNGSRICHTER_EINSATZ
(
    ID                      uuid default RANDOM_UUID(),
    AKTIV                   BOOLEAN,
    DELETED                 BOOLEAN,
    CHANGE_DATE             TIMESTAMP(6),
    DELETION_DATE           TIMESTAMP(6),

    PERSON_ANLASS_LINK_ID   uuid not null,
    WERTUNGSRICHTER_SLOT_ID uuid not null,

    EINGESETZT              BOOLEAN,

    PRIMARY KEY (ID)
);
create table TEILNEHMER
(
    ID              uuid default RANDOM_UUID(),
    AKTIV           BOOLEAN,
    DELETED         BOOLEAN,
    CHANGE_DATE     TIMESTAMP(6),
    DELETION_DATE   TIMESTAMP(6),

    NAME            VARCHAR(100),
    VORNAME         VARCHAR(100),
    JAHRGANG        INTEGER,
    STV_NUMMER      VARCHAR(7),
    TI_TU           VARCHAR(4),
    ORGANISATION_ID uuid not null,
    DIRTY           BOOLEAN,

    PRIMARY KEY (ID)
);

create table ORGANISATION_ANLASS_LINK
(
    ID                             uuid    default RANDOM_UUID(),
    AKTIV                          BOOLEAN,
    DELETED                        BOOLEAN,
    CHANGE_DATE                    TIMESTAMP(6),
    DELETION_DATE                  TIMESTAMP(6),
    REMINDER_MELDESCHLUSS_SENT     BOOLEAN default false,
    ANMELDE_KONTROLLE_SENT         BOOLEAN default false,
    REMINDER_MUTATIONSSCHLUSS_SENT BOOLEAN default false,
    VERLAENGERUNGS_DATE            TIMESTAMP(6),

    ORGANISATION_ID                uuid not null,
    ANLASS_ID                      uuid not null,

    PRIMARY KEY (ID)
);
create table LAUFLISTE
(
    ID                      uuid default gen_random_uuid(),
    AKTIV                   BOOLEAN,
    DELETED                 BOOLEAN,
    CHANGE_DATE             TIMESTAMP(6),
    DELETION_DATE           TIMESTAMP(6),

    KEY                     VARCHAR(5),
    LAUFLISTEN_CONTAINER_ID uuid,
    GERAET                  varchar(100),
    ABLOESUNG               integer,

    ERFASST                 BOOLEAN,
    CHECKED                 BOOLEAN,

    PRIMARY KEY (ID)
);

CREATE SEQUENCE lauflisten_nummer START 1;

create table LAUFLISTEN_CONTAINER
(
    ID            uuid default RANDOM_UUID(),
    AKTIV         BOOLEAN,
    DELETED       BOOLEAN,
    CHANGE_DATE   TIMESTAMP(6),
    DELETION_DATE TIMESTAMP(6),
    ANLASS_ID     uuid,
    KEY           integer,
    ERFASST       BOOLEAN,
    CHECKED       BOOLEAN,
    KATEGORIE     VARCHAR(2),
    STARTGERAET   integer,
    PRIMARY KEY (ID)
);
create table NOTENBLATT
(
    ID                        uuid default gen_random_uuid(),
    AKTIV                     BOOLEAN,
    DELETED                   BOOLEAN,
    CHANGE_DATE               TIMESTAMP(6),
    DELETION_DATE             TIMESTAMP(6),

    TEILNEHMER_ANLASS_LINK_ID uuid,
    GESAMT_PUNKTZAHL          decimal(5, 3),
    RANG                      integer,
    AUSZEICHNUNG              BOOLEAN,
    ERFASST                   BOOLEAN,
    CHECKED                   BOOLEAN,

    PRIMARY KEY (ID)
);
create table EINZELNOTE
(
    ID            uuid    default gen_random_uuid(),
    AKTIV         BOOLEAN,
    DELETED       BOOLEAN,
    CHANGE_DATE   TIMESTAMP(6),
    DELETION_DATE TIMESTAMP(6),

    NOTENBLATT_ID uuid,
    LAUFLISTEN_ID uuid,
    GERAET        varchar(100),
    START_ORDER   INTEGER,

    ERFASST       BOOLEAN default false,
    CHECKED       BOOLEAN default false,

    NOTE_1        decimal(5, 3),
    NOTE_2        decimal(5, 3),
    ZAEHLBAR      decimal(5, 3),

    PRIMARY KEY (ID)
);
create table RANGLISTEN_CONFIGURATION
(
    ID                 uuid default gen_random_uuid(),
    AKTIV              BOOLEAN,
    DELETED            BOOLEAN,
    CHANGE_DATE        TIMESTAMP(6),
    DELETION_DATE      TIMESTAMP(6),

    ANLASS_ID          uuid,
    KATEGORIE          VARCHAR(2),
    TI_TU              VARCHAR(4),

    MAX_AUSZEICHNUNGEN integer,

    PRIMARY KEY (ID)
);
