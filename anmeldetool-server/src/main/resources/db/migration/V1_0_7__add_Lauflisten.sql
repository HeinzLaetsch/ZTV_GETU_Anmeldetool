create table LAUFLISTEN_CONTAINER
(
    ID            uuid          default  gen_random_uuid(),
    AKTIV         BOOLEAN,
    DELETED       BOOLEAN,
    CHANGE_DATE   TIMESTAMP(6),
    DELETION_DATE TIMESTAMP(6),
 
    ANLASS_ID    	uuid,
 	ERFASST		 	BOOLEAN,
 	CHECKED		 	BOOLEAN,
 	KATEGORIE		VARCHAR(2),
   
    PRIMARY KEY (ID)
);


CREATE UNIQUE INDEX uidx_LAUFLISTEN_CONTAINER ON LAUFLISTEN_CONTAINER (ID);

CREATE INDEX idx_LAUFLISTEN_CONTAINER_DELETED ON LAUFLISTEN_CONTAINER (DELETED);

CREATE INDEX idx_LAUFLISTEN_CONTAINER_ANLASS_ID ON LAUFLISTEN_CONTAINER (ANLASS_ID);

create table LAUFLISTEN
(
    ID            uuid          default  gen_random_uuid(),
    AKTIV         BOOLEAN,
    DELETED       BOOLEAN,
    CHANGE_DATE   TIMESTAMP(6),
    DELETION_DATE TIMESTAMP(6),
 
    KEY				VARCHAR(5),
    LAUFLISTEN_CONTAINER_ID    	uuid,
    GERAET 			varchar(100),

 	ERFASST		 	BOOLEAN,
 	CHECKED		 	BOOLEAN,
   
    PRIMARY KEY (ID)
);


CREATE UNIQUE INDEX uidx_LAUFLISTEN ON LAUFLISTEN (ID);

CREATE INDEX idx_LAUFLISTEN_KEY ON LAUFLISTEN (KEY);

CREATE INDEX idx_LAUFLISTEN_ERFASST ON LAUFLISTEN (ERFASST);

CREATE INDEX idx_LAUFLISTEN_CHECKED ON LAUFLISTEN (CHECKED);

CREATE INDEX idx_LAUFLISTEN_DELETED ON LAUFLISTEN (DELETED);


ALTER TABLE TEILNEHMER_ANLASS_LINK ADD LAUFLISTEN_CONTAINER_ID uuid;