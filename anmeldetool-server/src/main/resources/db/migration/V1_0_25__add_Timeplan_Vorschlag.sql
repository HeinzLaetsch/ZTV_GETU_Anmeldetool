create table TIMEPLAN_VORSCHLAG
(
    ID                    uuid          default gen_random_uuid(),
    AKTIV                 BOOLEAN,
    DELETED               BOOLEAN,
    CHANGE_DATE           TIMESTAMP(6),
    DELETION_DATE         TIMESTAMP(6),

    ANLASS_ID             uuid          NOT NULL REFERENCES ANLASS (ID) ON DELETE CASCADE,
    KATEGORIE             VARCHAR(10)   NOT NULL,
    TI_TU                 VARCHAR(4)    NOT NULL,

    MAX_ANLAGEN           integer       NOT NULL,
    MAX_ABTEILUNGEN       integer       NOT NULL,

    ANZAHL_TEILNEHMER     integer       NOT NULL,
    ANZAHL_GRUPPEN        integer       NOT NULL,
    ANZAHL_ANLAGEN        integer       NOT NULL,
    ANZAHL_ABTEILUNGEN    integer       NOT NULL,

    PRIMARY KEY (ID)
);

CREATE UNIQUE INDEX uidx_TIMEPLAN_VORSCHLAG_ANLASS_KATEGORIE_TI_TU ON TIMEPLAN_VORSCHLAG (ANLASS_ID, KATEGORIE, TI_TU);
