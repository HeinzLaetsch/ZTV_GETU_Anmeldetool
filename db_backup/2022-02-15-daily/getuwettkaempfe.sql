--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1 (Debian 14.1-1.pgdg110+1)
-- Dumped by pg_dump version 14.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: anlass; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.anlass (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aktiv boolean,
    deleted boolean,
    change_date timestamp(6) without time zone,
    deletion_date timestamp(6) without time zone,
    anlass_bezeichnung character varying(100),
    ort character varying(100),
    halle character varying(100),
    organisator character varying(100),
    start_date timestamp(6) without time zone,
    end_date timestamp(6) without time zone,
    ti_tu character varying(4),
    tiefste_kategorie character varying(2),
    hoechste_kategorie character varying(2),
    anmeldung_beginn timestamp(6) without time zone,
    erfassen_geschlossen timestamp(6) without time zone,
    cross_kategorie_aenderungen_geschlossen timestamp(6) without time zone,
    aenderungen_in_kategorie_geschlossen timestamp(6) without time zone,
    aenderungen_nicht_mehr_erlaubt timestamp(6) without time zone,
    published boolean DEFAULT true,
    iban character varying(30),
    zu_gunsten character varying(200),
    bank character varying(200),
    abteilung_fix boolean DEFAULT false,
    anlage_fix boolean DEFAULT false,
    startgeraet_fix boolean DEFAULT false
);


ALTER TABLE public.anlass OWNER TO postgres;

--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO postgres;

--
-- Name: laufliste; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.laufliste (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aktiv boolean,
    deleted boolean,
    change_date timestamp(6) without time zone,
    deletion_date timestamp(6) without time zone,
    key character varying(5),
    lauflisten_container_id uuid,
    geraet character varying(100),
    erfasst boolean,
    checked boolean
);


ALTER TABLE public.laufliste OWNER TO postgres;

--
-- Name: lauflisten_container; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lauflisten_container (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aktiv boolean,
    deleted boolean,
    change_date timestamp(6) without time zone,
    deletion_date timestamp(6) without time zone,
    anlass_id uuid,
    key integer,
    erfasst boolean,
    checked boolean,
    kategorie character varying(2),
    startgeraet integer
);


ALTER TABLE public.lauflisten_container OWNER TO postgres;

--
-- Name: organisation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organisation (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aktiv boolean,
    deleted boolean,
    change_date timestamp(6) without time zone,
    deletion_date timestamp(6) without time zone,
    name character varying(100),
    verband_id uuid
);


ALTER TABLE public.organisation OWNER TO postgres;

--
-- Name: organisation_anlass_link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organisation_anlass_link (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aktiv boolean,
    deleted boolean,
    change_date timestamp(6) without time zone,
    deletion_date timestamp(6) without time zone,
    organisation_id uuid NOT NULL,
    anlass_id uuid NOT NULL,
    verlaengerungs_date timestamp(6) without time zone
);


ALTER TABLE public.organisation_anlass_link OWNER TO postgres;

--
-- Name: organisation_person_link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organisation_person_link (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aktiv boolean,
    deleted boolean,
    change_date timestamp(6) without time zone,
    deletion_date timestamp(6) without time zone,
    organisation_id uuid NOT NULL,
    person_id uuid
);


ALTER TABLE public.organisation_person_link OWNER TO postgres;

--
-- Name: person; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aktiv boolean,
    deleted boolean,
    change_date timestamp(6) without time zone,
    deletion_date timestamp(6) without time zone,
    benutzername character varying(100),
    name character varying(100),
    vorname character varying(100),
    handy character varying(13),
    email character varying(100),
    password character varying(100),
    wertungsrichter_id uuid
);


ALTER TABLE public.person OWNER TO postgres;

--
-- Name: person_anlass_link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.person_anlass_link (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aktiv boolean,
    deleted boolean,
    change_date timestamp(6) without time zone,
    deletion_date timestamp(6) without time zone,
    person_id uuid NOT NULL,
    anlass_id uuid NOT NULL,
    organisation_id uuid NOT NULL,
    kommentar character varying(200)
);


ALTER TABLE public.person_anlass_link OWNER TO postgres;

--
-- Name: rolle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rolle (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aktiv boolean,
    deleted boolean,
    change_date timestamp(6) without time zone,
    deletion_date timestamp(6) without time zone,
    name character varying(100),
    beschreibung character varying(200)
);


ALTER TABLE public.rolle OWNER TO postgres;

--
-- Name: rollen_link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rollen_link (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aktiv boolean,
    deleted boolean,
    change_date timestamp(6) without time zone,
    deletion_date timestamp(6) without time zone,
    rollen_id uuid NOT NULL,
    link_id uuid NOT NULL
);


ALTER TABLE public.rollen_link OWNER TO postgres;

--
-- Name: teilnehmer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teilnehmer (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aktiv boolean,
    deleted boolean,
    change_date timestamp(6) without time zone,
    deletion_date timestamp(6) without time zone,
    name character varying(100),
    vorname character varying(100),
    jahrgang integer,
    stv_nummer character varying(7),
    ti_tu character varying(4),
    organisation_id uuid NOT NULL,
    dirty boolean
);


ALTER TABLE public.teilnehmer OWNER TO postgres;

--
-- Name: teilnehmer_anlass_link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teilnehmer_anlass_link (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aktiv boolean,
    deleted boolean,
    change_date timestamp(6) without time zone,
    deletion_date timestamp(6) without time zone,
    kategorie character varying(20),
    teilnehmer_id uuid NOT NULL,
    anlass_id uuid NOT NULL,
    organisation_id uuid NOT NULL,
    startnummer integer,
    abteilung character varying(12),
    anlage character varying(12),
    startgeraet character varying(100),
    melde_status character varying(20),
    lauflisten_container_id uuid
);


ALTER TABLE public.teilnehmer_anlass_link OWNER TO postgres;

--
-- Name: verband; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.verband (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aktiv boolean,
    deleted boolean,
    change_date timestamp(6) without time zone,
    deletion_date timestamp(6) without time zone,
    verband character varying(6),
    verband_long character varying(100)
);


ALTER TABLE public.verband OWNER TO postgres;

--
-- Name: wertungsrichter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wertungsrichter (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aktiv boolean,
    deleted boolean,
    change_date timestamp(6) without time zone,
    deletion_date timestamp(6) without time zone,
    person_id uuid,
    brevet integer,
    gueltig boolean,
    letzter_fk timestamp(6) without time zone
);


ALTER TABLE public.wertungsrichter OWNER TO postgres;

--
-- Name: wertungsrichter_einsatz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wertungsrichter_einsatz (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aktiv boolean,
    deleted boolean,
    change_date timestamp(6) without time zone,
    deletion_date timestamp(6) without time zone,
    person_anlass_link_id uuid NOT NULL,
    wertungsrichter_slot_id uuid NOT NULL,
    eingesetzt boolean
);


ALTER TABLE public.wertungsrichter_einsatz OWNER TO postgres;

--
-- Name: wertungsrichter_slot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wertungsrichter_slot (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    aktiv boolean,
    deleted boolean,
    change_date timestamp(6) without time zone,
    deletion_date timestamp(6) without time zone,
    anlass_id uuid NOT NULL,
    reihenfolge integer,
    brevet integer,
    tag timestamp(6) without time zone,
    start_zeit timestamp(6) without time zone,
    end_zeit timestamp(6) without time zone,
    beschreibung character varying(50)
);


ALTER TABLE public.wertungsrichter_slot OWNER TO postgres;

--
-- Data for Name: anlass; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.anlass (id, aktiv, deleted, change_date, deletion_date, anlass_bezeichnung, ort, halle, organisator, start_date, end_date, ti_tu, tiefste_kategorie, hoechste_kategorie, anmeldung_beginn, erfassen_geschlossen, cross_kategorie_aenderungen_geschlossen, aenderungen_in_kategorie_geschlossen, aenderungen_nicht_mehr_erlaubt, published, iban, zu_gunsten, bank, abteilung_fix, anlage_fix, startgeraet_fix) FROM stdin;
b7440787-50bd-4e41-b38b-48acf37af0de	t	f	\N	\N	Frühlings%wettkampf	Kloten	im Feld	TV Kloten	2022-04-03 00:00:00	2022-04-03 00:00:00	Tu	K1	K7	2022-01-10 00:00:00	2022-02-08 00:00:00	2022-02-08 00:00:00	2022-03-30 00:00:00	2022-03-30 00:00:00	t	CH54 0070 0110 0050 8467 0	Turnverein Kloten, 8302 Kloten	ZKB, 8302 Kloten	f	f	f
0fa002f3-d432-46d4-a753-991d021db3fa	t	f	\N	\N	Frühlings%wettkampf	Rafz	Saalsporthalle Rafz	Freienstein / Neftenbach	2022-04-09 00:00:00	2022-04-10 00:00:00	Ti	K1	K7	2022-02-06 00:00:00	2022-02-20 00:00:00	2022-02-20 00:00:00	2022-04-06 00:00:00	2022-04-06 00:00:00	t	CH14 0900 0000 8709 2263 9	Turnverein Freienstein	\N	f	f	f
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	Create tables	SQL	V1__Create_tables.sql	1096853134	postgres	2022-01-09 21:50:21.773333	2541	t
2	1.0.1	add uniqueConstraint	SQL	V1_0_1__add_uniqueConstraint.sql	-907031492	postgres	2022-01-09 21:50:24.3531	29	t
3	1.0.2	add Verlaengerungs Date	SQL	V1_0_2__add_Verlaengerungs_Date.sql	1237852161	postgres	2022-01-12 21:36:39.819629	10	t
4	1.0.3	add Zahlungsinfos	SQL	V1_0_3__add_Zahlungsinfos.sql	1775724609	postgres	2022-01-14 17:12:21.978699	89	t
5	1.0.4	add StartInfo	SQL	V1_0_4__add_StartInfo.sql	409741404	postgres	2022-01-20 17:43:20.488085	64	t
6	1.0.5	add StartInfo	SQL	V1_0_5__add_StartInfo.sql	384491224	postgres	2022-01-25 09:57:51.762646	12	t
7	1.0.6	add Flags	SQL	V1_0_6__add_Flags.sql	1304000914	postgres	2022-01-28 10:14:00.10568	29	t
8	1.0.7	add Lauflisten	SQL	V1_0_7__add_Lauflisten.sql	576974242	postgres	2022-02-07 08:19:54.332027	438	t
\.


--
-- Data for Name: laufliste; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.laufliste (id, aktiv, deleted, change_date, deletion_date, key, lauflisten_container_id, geraet, erfasst, checked) FROM stdin;
\.


--
-- Data for Name: lauflisten_container; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lauflisten_container (id, aktiv, deleted, change_date, deletion_date, anlass_id, key, erfasst, checked, kategorie, startgeraet) FROM stdin;
\.


--
-- Data for Name: organisation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organisation (id, aktiv, deleted, change_date, deletion_date, name, verband_id) FROM stdin;
43812428-ee9e-486f-81d1-8e38da69c9c4	t	f	\N	\N	ZTV	0da6da10-2d26-4285-8e7e-7154ba5447e5
2fc3365b-34d9-4054-b2d8-aa859c7455e7	t	f	2022-01-10 00:00:00	\N	TV Regensdorf	e804eb0e-ed31-42aa-8154-38cc0ddf2126
7647310f-d340-4dc7-b6d8-bda7a5716728	t	f	2022-01-11 00:00:00	\N	TV Bauma	ecd2ee2f-6d5a-4f85-a7eb-b935ef9188c4
89e47949-21f1-4855-a397-20c3bc3426d7	t	f	2022-01-11 00:00:00	\N	GR Rugeli	702c2173-19a2-44c5-bb06-4326f779f4d7
1fe6d9ce-05bf-4a02-81c4-53d731398880	t	f	2022-01-12 00:00:00	\N	Getu Bäretswil	08204af7-4284-468a-8708-efd7fb0b8abb
688a34cb-72f2-4920-aeb3-89325956de26	t	f	2022-01-12 00:00:00	\N	Geräteriege Obfelden	08204af7-4284-468a-8708-efd7fb0b8abb
852ccab3-35f6-4d12-815c-d8b66ff664b7	t	f	2022-01-12 00:00:00	\N	Getu Weisslingen	ecd2ee2f-6d5a-4f85-a7eb-b935ef9188c4
205d3aed-6ce7-4cd3-8f6d-8d222d9d59b0	t	f	2022-01-11 00:00:00	\N	STV Kriessern	b72f2c99-7568-43df-a653-89b52cafa6a3
a60429c0-6964-454b-8ee1-ddad66957f06	t	f	2022-01-13 00:00:00	\N	TV Altikon	ecd2ee2f-6d5a-4f85-a7eb-b935ef9188c4
c0a6c2eb-1278-42b5-8aba-0426f3550863	t	f	2022-01-14 00:00:00	\N	TV Egg	e804eb0e-ed31-42aa-8154-38cc0ddf2126
24510313-6d39-4217-bb3f-0bfa7fbb73d3	t	f	2022-01-14 00:00:00	\N	TV Weiningen	702c2173-19a2-44c5-bb06-4326f779f4d7
80c08ccc-c90e-4377-af3b-2de779197c7a	t	f	2022-01-16 00:00:00	\N	DTV Küsnacht	702c2173-19a2-44c5-bb06-4326f779f4d7
e3df7bcf-4e86-48a6-92de-474fa94729a3	t	f	2022-01-17 00:00:00	\N	Getu Fehraltorf	702c2173-19a2-44c5-bb06-4326f779f4d7
8b92d8ae-ce49-4ffb-842d-9de90fb5737f	t	f	2022-01-11 00:00:00	\N	Geräteriege Hinwil	08204af7-4284-468a-8708-efd7fb0b8abb
9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	t	f	2022-01-17 00:00:00	\N	Geräteriege Birmensdorf	702c2173-19a2-44c5-bb06-4326f779f4d7
773a0356-9c76-4dfb-8c56-c1693ee2819d	t	f	2022-01-17 00:00:00	\N	TV Altstetten	702c2173-19a2-44c5-bb06-4326f779f4d7
a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	t	f	2022-01-18 00:00:00	\N	GETU Urdorf	702c2173-19a2-44c5-bb06-4326f779f4d7
854e7b58-34dc-4ed5-ac6c-f233476b1e9e	t	f	2022-01-19 00:00:00	\N	TV Widnau	b72f2c99-7568-43df-a653-89b52cafa6a3
46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	t	f	2022-01-20 00:00:00	\N	TV Neftenbach	ecd2ee2f-6d5a-4f85-a7eb-b935ef9188c4
d48095c7-3de5-4a8d-b893-b8d432e7c647	t	f	2022-01-20 00:00:00	\N	Getu Bülach	702c2173-19a2-44c5-bb06-4326f779f4d7
5a2c7e90-a8e1-49a6-80c8-3a753967dff1	t	f	2022-01-20 00:00:00	\N	Getu Mettmenstetten	702c2173-19a2-44c5-bb06-4326f779f4d7
81308200-79d0-466c-a19a-ca3fbef6045a	t	f	2022-01-20 00:00:00	\N	TV Grüningen	08204af7-4284-468a-8708-efd7fb0b8abb
e2438143-6017-4683-a533-6113748d4117	t	f	2022-01-21 00:00:00	\N	Getu Stammertal	702c2173-19a2-44c5-bb06-4326f779f4d7
ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	t	f	2022-01-22 00:00:00	\N	TV Dietlikon	702c2173-19a2-44c5-bb06-4326f779f4d7
f70f01bf-53ff-48cd-8b6d-95a652b9d44e	t	f	2022-01-22 00:00:00	\N	Getu Bonaduz	458a69b6-75dd-4c17-a9aa-eeb755e8b3a8
1d2a9859-0137-4da2-8390-6cd570385ec4	t	f	2022-01-22 00:00:00	\N	Getu Rafz	702c2173-19a2-44c5-bb06-4326f779f4d7
b490aa6f-84cd-4be3-95da-7e230d5f645e	t	f	2022-01-23 00:00:00	\N	Geräteriege Wülflingen	702c2173-19a2-44c5-bb06-4326f779f4d7
0205ab00-b754-463a-9227-28ee5b6fe953	t	f	2022-01-26 00:00:00	\N	Getu Glattfelden	702c2173-19a2-44c5-bb06-4326f779f4d7
a5302a2b-d270-49e5-9876-47c84cb38038	t	f	2022-01-27 00:00:00	\N	Geräteriege Wildberg	ecd2ee2f-6d5a-4f85-a7eb-b935ef9188c4
7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	t	f	2022-01-28 00:00:00	\N	Turnverein Kloten	702c2173-19a2-44c5-bb06-4326f779f4d7
86a39d76-71ed-4890-82ec-ce2a48d32627	t	f	2022-01-28 00:00:00	\N	Turnverein Rümlang	e804eb0e-ed31-42aa-8154-38cc0ddf2126
1030974d-cffe-46d6-b6ea-79c8839cf2ea	t	f	2022-01-30 00:00:00	\N	TV Opfikon-Glattbrugg	702c2173-19a2-44c5-bb06-4326f779f4d7
4e9262a1-fef9-4701-9c91-1b3016ee971d	t	f	2022-01-30 00:00:00	\N	Getu Hettlingen	702c2173-19a2-44c5-bb06-4326f779f4d7
0a9d4719-903b-4f31-9e00-10fc47c954fd	t	f	2022-01-31 00:00:00	\N	TV Rheinau	702c2173-19a2-44c5-bb06-4326f779f4d7
08bfbb88-e782-4169-83fd-17b0fd03da18	t	f	2022-01-31 00:00:00	\N	Getu Lufingen	702c2173-19a2-44c5-bb06-4326f779f4d7
d701ba83-2b9a-45e4-8c54-ba88cb8e1260	t	f	2022-02-02 00:00:00	\N	GETU Rickenbach	702c2173-19a2-44c5-bb06-4326f779f4d7
fe6fd149-2231-415b-95c0-c4194aaf56a1	t	f	2022-02-02 00:00:00	\N	TV Dägerlen	702c2173-19a2-44c5-bb06-4326f779f4d7
0f604f34-370f-4593-8173-cd24234cff78	t	f	2022-02-02 00:00:00	\N	Neue Sektion Winterthur 	702c2173-19a2-44c5-bb06-4326f779f4d7
1cea7eb3-981e-4c6e-bb83-bfcc1578351b	t	f	2022-02-02 00:00:00	\N	Getu Seuzach	ecd2ee2f-6d5a-4f85-a7eb-b935ef9188c4
a3895837-7bb9-48fa-afd0-b88c1edc7a95	t	f	2022-02-02 00:00:00	\N	TV Wil ZH	e804eb0e-ed31-42aa-8154-38cc0ddf2126
cfb35447-962b-479e-af0e-2f95dfbc9fde	t	f	2022-02-02 00:00:00	\N	TSV Bonstetten	702c2173-19a2-44c5-bb06-4326f779f4d7
28f767de-cc97-4d11-9c40-6888376971a6	t	f	2022-02-03 00:00:00	\N	GETU Hombrechtikon Mädchen	08204af7-4284-468a-8708-efd7fb0b8abb
89d0839c-785c-4037-ac95-05745e1fd429	t	f	2022-02-03 00:00:00	\N	Geräteriege Zumikon	08204af7-4284-468a-8708-efd7fb0b8abb
6cd2dec1-6466-4eb1-970b-81420914a9ed	t	f	2022-02-03 00:00:00	\N	Geräteriege Jugi Elgg	702c2173-19a2-44c5-bb06-4326f779f4d7
5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	t	f	2022-02-04 00:00:00	\N	TV Effretikon	702c2173-19a2-44c5-bb06-4326f779f4d7
9562c508-9b9f-4852-af78-acd45d6f5d8d	t	f	2022-02-05 00:00:00	\N	GETu Nürensdorf	702c2173-19a2-44c5-bb06-4326f779f4d7
5ee987b5-deec-4087-b36f-bba4dcaf842f	t	f	2022-02-06 00:00:00	\N	Geräteriege Rikon	702c2173-19a2-44c5-bb06-4326f779f4d7
4c850776-1fc1-4201-9490-c1e848cd0f00	t	f	2022-02-06 00:00:00	\N	TV ZH-Wiedikon	702c2173-19a2-44c5-bb06-4326f779f4d7
23241a48-58b4-4a92-9529-86e25bc8ab9a	t	f	2022-02-06 00:00:00	\N	TV Zürich Unterstrass	702c2173-19a2-44c5-bb06-4326f779f4d7
80200590-2e5d-4900-bc9b-cf4d6f5d7265	t	f	2022-02-06 00:00:00	\N	GETU Mönchaltorf	e804eb0e-ed31-42aa-8154-38cc0ddf2126
97cf3158-df81-45c1-b49e-47a692438dca	t	f	2022-02-06 00:00:00	\N	TV Hombrechtikon	08204af7-4284-468a-8708-efd7fb0b8abb
a47c9fe9-9d46-47c6-8cc8-b9728464daa2	t	f	2022-02-06 00:00:00	\N	Turnsport Rüti	702c2173-19a2-44c5-bb06-4326f779f4d7
dc8ff971-5522-45bf-b501-ff65ecb46db9	t	f	2022-02-07 00:00:00	\N	Getu Rorbas-Freienstein	0da6da10-2d26-4285-8e7e-7154ba5447e5
a7f39754-f6ec-4934-9c2e-6bb84f8be764	t	f	2022-02-08 00:00:00	\N	GETU Niederhasli	702c2173-19a2-44c5-bb06-4326f779f4d7
83a5507a-c2fc-4171-8af4-fb4d8d45c889	t	f	2022-02-09 00:00:00	\N	GETU Bassersdorf	702c2173-19a2-44c5-bb06-4326f779f4d7
f72ef658-2832-4835-af07-de91109d4f7f	t	f	2022-02-09 00:00:00	\N	TV ASZüri-Hard	702c2173-19a2-44c5-bb06-4326f779f4d7
b0574726-8fed-4a1f-aac3-09f61225548d	t	f	2022-02-10 00:00:00	\N	TV Zürich Affoltern 	e804eb0e-ed31-42aa-8154-38cc0ddf2126
4a94dfe1-edf1-4421-93e1-e53183ed3dbc	t	f	2022-02-11 00:00:00	\N	Geräteturnen Stäfa - Uerikon	08204af7-4284-468a-8708-efd7fb0b8abb
e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	t	f	2022-02-11 00:00:00	\N	GETU Gossau ZH	08204af7-4284-468a-8708-efd7fb0b8abb
a0ea91c8-f018-424b-ac69-1246f657d591	t	f	2022-02-12 00:00:00	\N	TV Wädenswil	702c2173-19a2-44c5-bb06-4326f779f4d7
1ef47e57-2af3-4027-8cd6-427f30a63792	t	f	2022-02-12 00:00:00	\N	Getu Flaachtal	702c2173-19a2-44c5-bb06-4326f779f4d7
e7e33831-c7ee-4aca-97b1-d2c32b102d58	t	f	2022-02-13 00:00:00	\N	Getu Eglisau	702c2173-19a2-44c5-bb06-4326f779f4d7
42933e50-7306-4a54-b42a-276813e8b03a	t	f	2022-02-14 00:00:00	\N	GETU Niederglatt	702c2173-19a2-44c5-bb06-4326f779f4d7
465cb8a9-3909-4d55-beab-ca76d490081e	t	f	2022-02-14 00:00:00	\N	GETU Schönenberg	702c2173-19a2-44c5-bb06-4326f779f4d7
\.


--
-- Data for Name: organisation_anlass_link; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organisation_anlass_link (id, aktiv, deleted, change_date, deletion_date, organisation_id, anlass_id, verlaengerungs_date) FROM stdin;
3efe02eb-a70e-4729-b36a-b6be4cac01be	t	f	2022-01-10 00:00:00	\N	2fc3365b-34d9-4054-b2d8-aa859c7455e7	b7440787-50bd-4e41-b38b-48acf37af0de	\N
cc7c4985-0d21-4884-823c-9d1f900b7936	t	f	2022-01-11 00:00:00	\N	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	b7440787-50bd-4e41-b38b-48acf37af0de	\N
f6098bf1-a1bd-4517-80af-5bf2d74f2dab	t	f	2022-01-11 00:00:00	\N	7647310f-d340-4dc7-b6d8-bda7a5716728	b7440787-50bd-4e41-b38b-48acf37af0de	\N
3fa2e878-4618-4cd0-b3a8-6be9e5b2b6a2	t	f	2022-02-07 00:00:00	\N	81308200-79d0-466c-a19a-ca3fbef6045a	0fa002f3-d432-46d4-a753-991d021db3fa	\N
a42819e1-636b-4b61-aa94-e825846d82cd	t	f	2022-01-25 00:00:00	\N	d48095c7-3de5-4a8d-b893-b8d432e7c647	b7440787-50bd-4e41-b38b-48acf37af0de	\N
5622f72a-f431-4713-9107-c87eed147a00	t	f	2022-02-02 00:00:00	\N	0a9d4719-903b-4f31-9e00-10fc47c954fd	b7440787-50bd-4e41-b38b-48acf37af0de	\N
829b11af-1ba3-4aa3-8233-7046ab4aeb3b	t	f	2022-02-02 00:00:00	\N	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	b7440787-50bd-4e41-b38b-48acf37af0de	\N
a62ea972-0505-4fbe-9325-a9820c4aa52e	t	f	2022-02-08 00:00:00	\N	80c08ccc-c90e-4377-af3b-2de779197c7a	0fa002f3-d432-46d4-a753-991d021db3fa	\N
e2d1aecf-df19-4e91-af0d-b66ca5a7bd2e	t	f	2022-01-13 00:00:00	\N	a60429c0-6964-454b-8ee1-ddad66957f06	b7440787-50bd-4e41-b38b-48acf37af0de	\N
b5fa726a-622e-46e6-9704-1403b541c596	t	f	2022-01-14 00:00:00	\N	24510313-6d39-4217-bb3f-0bfa7fbb73d3	b7440787-50bd-4e41-b38b-48acf37af0de	\N
0ef53533-f9a6-4af4-9a4c-715b4b5b63e8	t	f	2022-02-02 00:00:00	\N	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	b7440787-50bd-4e41-b38b-48acf37af0de	\N
dd86270b-ce3e-4684-a820-bcf21894f78b	t	f	2022-01-17 00:00:00	\N	e3df7bcf-4e86-48a6-92de-474fa94729a3	b7440787-50bd-4e41-b38b-48acf37af0de	\N
3bdff40b-9f83-4bfd-9023-b6bb92786683	t	f	2022-01-17 00:00:00	\N	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	b7440787-50bd-4e41-b38b-48acf37af0de	\N
6656ce9d-c8a1-46c6-8482-8d4b114d7838	t	f	2022-01-18 00:00:00	\N	773a0356-9c76-4dfb-8c56-c1693ee2819d	b7440787-50bd-4e41-b38b-48acf37af0de	\N
298fd6a1-cea7-4da8-9897-24ddd5b4a697	t	f	2022-02-12 00:00:00	\N	1ef47e57-2af3-4027-8cd6-427f30a63792	0fa002f3-d432-46d4-a753-991d021db3fa	\N
7aebf22e-1213-4f27-b00c-0fa1558daa0f	t	f	2022-01-30 00:00:00	\N	4e9262a1-fef9-4701-9c91-1b3016ee971d	b7440787-50bd-4e41-b38b-48acf37af0de	2022-02-09 00:00:00
0f1e7f6e-1344-4e80-ad87-a0a741344d6d	t	f	2022-02-08 00:00:00	\N	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	0fa002f3-d432-46d4-a753-991d021db3fa	\N
0391fd65-0bc1-4d59-988b-67840a038784	t	f	2022-01-12 00:00:00	\N	688a34cb-72f2-4920-aeb3-89325956de26	b7440787-50bd-4e41-b38b-48acf37af0de	\N
13843a08-bebb-44c1-8553-9d9bc56f98d0	t	f	2022-02-08 00:00:00	\N	24510313-6d39-4217-bb3f-0bfa7fbb73d3	0fa002f3-d432-46d4-a753-991d021db3fa	\N
d2fe71a6-a21e-470a-849d-8c02a7489ad9	t	f	2022-01-19 00:00:00	\N	854e7b58-34dc-4ed5-ac6c-f233476b1e9e	b7440787-50bd-4e41-b38b-48acf37af0de	\N
8b83d468-f522-4dd5-9ba5-17ded0a580fb	t	f	2022-02-08 00:00:00	\N	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	0fa002f3-d432-46d4-a753-991d021db3fa	\N
daf3690c-081a-4ef1-95d8-935dff1c0f0d	t	f	2022-02-02 00:00:00	\N	a3895837-7bb9-48fa-afd0-b88c1edc7a95	b7440787-50bd-4e41-b38b-48acf37af0de	\N
e19bc159-8005-4eef-950f-db687c8065b3	t	f	2022-02-12 00:00:00	\N	4e9262a1-fef9-4701-9c91-1b3016ee971d	0fa002f3-d432-46d4-a753-991d021db3fa	\N
b502d8dd-c71c-4418-9430-cf270f4251c5	t	f	2022-02-02 00:00:00	\N	fe6fd149-2231-415b-95c0-c4194aaf56a1	b7440787-50bd-4e41-b38b-48acf37af0de	\N
6bd1cd79-f5f2-406a-af8f-bcf3e883dfb2	t	f	2022-02-11 00:00:00	\N	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	0fa002f3-d432-46d4-a753-991d021db3fa	\N
eb0307c8-5254-4ec0-8590-789c53e06bb9	t	f	2022-01-22 00:00:00	\N	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	b7440787-50bd-4e41-b38b-48acf37af0de	\N
36231896-91d1-4612-9775-c20b78db5ed2	t	f	2022-01-22 00:00:00	\N	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	b7440787-50bd-4e41-b38b-48acf37af0de	\N
fd7583ac-34c2-463d-8f37-3ba81dfb7b8a	t	f	2022-01-22 00:00:00	\N	1d2a9859-0137-4da2-8390-6cd570385ec4	b7440787-50bd-4e41-b38b-48acf37af0de	\N
ceacbeb4-7ab4-4e62-8274-39382bd58679	t	f	2022-02-08 00:00:00	\N	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	0fa002f3-d432-46d4-a753-991d021db3fa	\N
3e3b719d-6d5e-4a15-8c7e-d7b35ecb9379	t	f	2022-01-23 00:00:00	\N	b490aa6f-84cd-4be3-95da-7e230d5f645e	b7440787-50bd-4e41-b38b-48acf37af0de	\N
5efdea9e-b7c6-4164-a06f-9d4f45a126ca	t	f	2022-02-02 00:00:00	\N	cfb35447-962b-479e-af0e-2f95dfbc9fde	b7440787-50bd-4e41-b38b-48acf37af0de	\N
944c55fc-c05b-400c-8ef4-d41616df554a	t	f	2022-02-07 00:00:00	\N	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	0fa002f3-d432-46d4-a753-991d021db3fa	\N
b6bc3277-f6c3-424c-afac-9e3c5a3fd52b	t	f	2022-02-09 00:00:00	\N	e3df7bcf-4e86-48a6-92de-474fa94729a3	0fa002f3-d432-46d4-a753-991d021db3fa	\N
d0edd2c5-1d76-4d04-86c8-dead036cff31	t	f	2022-01-20 00:00:00	\N	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	b7440787-50bd-4e41-b38b-48acf37af0de	\N
eee25b34-bcde-4366-a42f-fed1683982c4	f	f	2022-02-03 00:00:00	\N	28f767de-cc97-4d11-9c40-6888376971a6	b7440787-50bd-4e41-b38b-48acf37af0de	\N
a11d58fb-54f9-4963-8838-a455e9e278ef	f	f	2022-01-11 00:00:00	\N	89e47949-21f1-4855-a397-20c3bc3426d7	b7440787-50bd-4e41-b38b-48acf37af0de	\N
dfea56b7-f871-4c9f-9e86-ab7baa6a40a7	t	f	2022-01-20 00:00:00	\N	81308200-79d0-466c-a19a-ca3fbef6045a	b7440787-50bd-4e41-b38b-48acf37af0de	\N
ef99880f-0098-4f46-a9dd-7beff3aa8625	t	f	2022-01-27 00:00:00	\N	a5302a2b-d270-49e5-9876-47c84cb38038	b7440787-50bd-4e41-b38b-48acf37af0de	\N
7b35028a-8619-41e9-a6fc-128f34142989	t	f	2022-01-28 00:00:00	\N	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	b7440787-50bd-4e41-b38b-48acf37af0de	\N
7a441273-1a93-4d9c-b258-01bc5ec0354c	t	f	2022-01-28 00:00:00	\N	86a39d76-71ed-4890-82ec-ce2a48d32627	b7440787-50bd-4e41-b38b-48acf37af0de	\N
a015c1ff-0525-4863-9e1b-44048f7d704a	t	f	2022-01-21 00:00:00	\N	e2438143-6017-4683-a533-6113748d4117	b7440787-50bd-4e41-b38b-48acf37af0de	\N
639fe28d-57e1-44e1-8876-9e5ca6ecfca2	t	f	2022-02-03 00:00:00	\N	6cd2dec1-6466-4eb1-970b-81420914a9ed	b7440787-50bd-4e41-b38b-48acf37af0de	\N
3ce699f7-86c3-44ba-91cf-caaa415d0327	t	f	2022-02-09 00:00:00	\N	83a5507a-c2fc-4171-8af4-fb4d8d45c889	0fa002f3-d432-46d4-a753-991d021db3fa	\N
36b58997-c7e9-4fc3-a503-729e0beb61bc	t	f	2022-01-29 00:00:00	\N	80c08ccc-c90e-4377-af3b-2de779197c7a	b7440787-50bd-4e41-b38b-48acf37af0de	\N
25289562-aed4-4d6c-b222-e3d6211b5e7e	t	f	2022-01-30 00:00:00	\N	1030974d-cffe-46d6-b6ea-79c8839cf2ea	b7440787-50bd-4e41-b38b-48acf37af0de	\N
b639917d-1033-49f3-b94c-d6fcdce6f48c	t	f	2022-01-31 00:00:00	\N	08bfbb88-e782-4169-83fd-17b0fd03da18	b7440787-50bd-4e41-b38b-48acf37af0de	\N
49b279e9-ee53-4dce-a01f-1184738b5eaf	t	f	2022-02-01 00:00:00	\N	c0a6c2eb-1278-42b5-8aba-0426f3550863	b7440787-50bd-4e41-b38b-48acf37af0de	\N
7808b525-9247-479a-8ace-358fe2113886	t	f	2022-01-11 00:00:00	\N	205d3aed-6ce7-4cd3-8f6d-8d222d9d59b0	b7440787-50bd-4e41-b38b-48acf37af0de	\N
b5205393-37a3-456d-9b8b-1c3f19df11a5	t	f	2022-01-20 00:00:00	\N	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	b7440787-50bd-4e41-b38b-48acf37af0de	\N
2791792a-383e-4946-9b0b-3b01f30bb060	f	f	2022-02-09 00:00:00	\N	43812428-ee9e-486f-81d1-8e38da69c9c4	0fa002f3-d432-46d4-a753-991d021db3fa	\N
10ccba4d-b8f6-4df0-a7f7-1d642cd5654f	f	f	2022-02-04 00:00:00	\N	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	b7440787-50bd-4e41-b38b-48acf37af0de	\N
6f08a1ef-ae3f-400b-bb64-63edf8617694	t	f	2022-02-09 00:00:00	\N	a7f39754-f6ec-4934-9c2e-6bb84f8be764	0fa002f3-d432-46d4-a753-991d021db3fa	\N
3c1c436e-77fc-4d35-8f5d-25a2a8b008bc	t	f	2022-01-12 00:00:00	\N	852ccab3-35f6-4d12-815c-d8b66ff664b7	b7440787-50bd-4e41-b38b-48acf37af0de	\N
e8db49e1-673f-423a-a43b-309ee7d6d113	t	f	2022-02-06 00:00:00	\N	773a0356-9c76-4dfb-8c56-c1693ee2819d	0fa002f3-d432-46d4-a753-991d021db3fa	\N
0b2e1480-2e59-4e78-8b92-287268e24e61	t	f	2022-02-06 00:00:00	\N	a47c9fe9-9d46-47c6-8cc8-b9728464daa2	b7440787-50bd-4e41-b38b-48acf37af0de	\N
8255a134-90b0-4fd3-adbd-f0bd1054803b	t	f	2022-02-07 00:00:00	\N	97cf3158-df81-45c1-b49e-47a692438dca	b7440787-50bd-4e41-b38b-48acf37af0de	\N
265e3c9a-1447-4db3-8a6c-9d2b87c238d3	t	f	2022-01-12 00:00:00	\N	1fe6d9ce-05bf-4a02-81c4-53d731398880	b7440787-50bd-4e41-b38b-48acf37af0de	\N
7e8461ea-7aeb-47f1-abb6-d89b47f6c859	t	f	2022-02-07 00:00:00	\N	1fe6d9ce-05bf-4a02-81c4-53d731398880	0fa002f3-d432-46d4-a753-991d021db3fa	\N
17e16913-0d7f-49ae-8005-a105e1637b15	t	f	2022-02-07 00:00:00	\N	dc8ff971-5522-45bf-b501-ff65ecb46db9	0fa002f3-d432-46d4-a753-991d021db3fa	\N
6c3c2a14-c36e-4462-b1fa-f9f2248508bb	t	f	2022-02-14 00:00:00	\N	d48095c7-3de5-4a8d-b893-b8d432e7c647	0fa002f3-d432-46d4-a753-991d021db3fa	\N
5b333026-b8f3-4b54-b5af-43275f09ce30	t	f	2022-02-02 00:00:00	\N	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	b7440787-50bd-4e41-b38b-48acf37af0de	\N
9de7ec78-6b1f-4977-8164-c6dbeadc2486	t	f	2022-02-07 00:00:00	\N	5ee987b5-deec-4087-b36f-bba4dcaf842f	0fa002f3-d432-46d4-a753-991d021db3fa	\N
e754e045-bca8-4896-b86d-b246fc9c1599	t	f	2022-02-07 00:00:00	\N	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	0fa002f3-d432-46d4-a753-991d021db3fa	\N
38a79338-dec4-4b17-a835-57976d72cdf3	t	f	2022-02-10 00:00:00	\N	b0574726-8fed-4a1f-aac3-09f61225548d	0fa002f3-d432-46d4-a753-991d021db3fa	\N
73c660da-04a5-4865-a8df-a2d31200bb3a	t	f	2022-02-10 00:00:00	\N	a5302a2b-d270-49e5-9876-47c84cb38038	0fa002f3-d432-46d4-a753-991d021db3fa	\N
65826d35-875b-40f0-b007-bfa0e7c8c3e8	t	f	2022-02-10 00:00:00	\N	4c850776-1fc1-4201-9490-c1e848cd0f00	0fa002f3-d432-46d4-a753-991d021db3fa	\N
0af798c6-e4a0-4e14-a372-cc364a255cf5	t	f	2022-02-11 00:00:00	\N	0f604f34-370f-4593-8173-cd24234cff78	0fa002f3-d432-46d4-a753-991d021db3fa	\N
b4f20c29-1aeb-4840-98e3-07f4c08ed965	t	f	2022-02-11 00:00:00	\N	08bfbb88-e782-4169-83fd-17b0fd03da18	0fa002f3-d432-46d4-a753-991d021db3fa	\N
4e2ac22a-5490-40a4-a3d9-be5800eb0f64	t	f	2022-02-11 00:00:00	\N	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	0fa002f3-d432-46d4-a753-991d021db3fa	\N
51370e26-2f72-487a-be51-2c1cc751f93d	t	f	2022-02-12 00:00:00	\N	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	0fa002f3-d432-46d4-a753-991d021db3fa	\N
ebc33492-63b8-4e5c-9cf4-f6eb3c4e81ee	t	f	2022-02-12 00:00:00	\N	688a34cb-72f2-4920-aeb3-89325956de26	0fa002f3-d432-46d4-a753-991d021db3fa	\N
b20693b7-f954-457f-a7cb-85f97adbf7fc	t	f	2022-02-12 00:00:00	\N	a0ea91c8-f018-424b-ac69-1246f657d591	0fa002f3-d432-46d4-a753-991d021db3fa	\N
02bc2653-260f-4315-badd-4da70f097646	t	f	2022-02-14 00:00:00	\N	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	0fa002f3-d432-46d4-a753-991d021db3fa	\N
0efbea1a-1594-4f4e-8637-5034d7702c03	f	f	2022-02-12 00:00:00	\N	e2438143-6017-4683-a533-6113748d4117	0fa002f3-d432-46d4-a753-991d021db3fa	\N
01d327f9-3a8b-4034-b943-b49ccb45039e	t	f	2022-02-14 00:00:00	\N	b490aa6f-84cd-4be3-95da-7e230d5f645e	0fa002f3-d432-46d4-a753-991d021db3fa	\N
ee5d659f-3bf7-4d52-bf85-0525d9b23ad7	t	f	2022-02-13 00:00:00	\N	e7e33831-c7ee-4aca-97b1-d2c32b102d58	0fa002f3-d432-46d4-a753-991d021db3fa	\N
e1b00c5e-c619-4de8-bc2f-28e864578838	t	f	2022-02-14 00:00:00	\N	465cb8a9-3909-4d55-beab-ca76d490081e	0fa002f3-d432-46d4-a753-991d021db3fa	\N
3d735179-f49d-4d8c-b8af-b86f44323644	f	f	2022-02-14 00:00:00	\N	42933e50-7306-4a54-b42a-276813e8b03a	0fa002f3-d432-46d4-a753-991d021db3fa	\N
\.


--
-- Data for Name: organisation_person_link; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organisation_person_link (id, aktiv, deleted, change_date, deletion_date, organisation_id, person_id) FROM stdin;
d6cc188a-e2e8-4304-a4da-8b8565883a24	t	f	2022-01-09 00:00:00	\N	43812428-ee9e-486f-81d1-8e38da69c9c4	ff5b4a49-aa15-4577-a8a6-075deb215f71
89e2abc1-01ee-497f-a3b5-ecfabacd1299	t	f	2022-01-09 00:00:00	\N	43812428-ee9e-486f-81d1-8e38da69c9c4	e8992741-c560-4920-bc6b-f09b14a5c5fd
5915e3b5-84ad-4cd7-95d4-38a9cf0179af	t	f	2022-01-10 00:00:00	\N	2fc3365b-34d9-4054-b2d8-aa859c7455e7	55407925-43fe-43cc-aa02-fb647b012dfc
1e5081d2-0287-4a00-bcda-99e1fe1a44b2	t	f	2022-01-10 00:00:00	\N	2fc3365b-34d9-4054-b2d8-aa859c7455e7	6c8b444d-d52e-4837-b1b6-466771cddb5d
f9a421c3-fe03-4981-be64-9074e2ad2548	t	f	2022-01-11 00:00:00	\N	205d3aed-6ce7-4cd3-8f6d-8d222d9d59b0	a6c1e6df-5338-4dc4-b661-f6875b327517
a96d9cac-e8c6-41f9-a081-99b30d2e05d5	t	f	2022-01-11 00:00:00	\N	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	e8bb3a4e-ff5b-4d60-8e37-f2358c646077
c780aba6-de04-41e6-a739-5c4267005dd7	t	f	2022-01-11 00:00:00	\N	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	faf769a3-47fa-4c20-b65c-24ddff3abd01
432cb098-1725-4ee9-bfd1-32cdb25b2f3d	t	f	2022-01-11 00:00:00	\N	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	413f0fe6-ffc8-49c5-ae71-1ff527b8930b
8f4a7d90-862d-4ff3-9670-3073f698950e	t	f	2022-01-11 00:00:00	\N	7647310f-d340-4dc7-b6d8-bda7a5716728	6b5ccf49-c989-4973-8237-95717f010161
33977204-3c0c-49d8-911e-b2746722f627	t	f	2022-01-11 00:00:00	\N	7647310f-d340-4dc7-b6d8-bda7a5716728	e201e5ef-cac2-465f-9956-4abecdbd08c8
d8ee77f5-1aab-48ae-bf08-a27be72f8b6d	t	f	2022-01-11 00:00:00	\N	7647310f-d340-4dc7-b6d8-bda7a5716728	de6d4c3d-283c-478c-87fa-278cac6f692a
9358b718-d720-4dd4-b6bf-6bfe6f484574	t	f	2022-01-11 00:00:00	\N	7647310f-d340-4dc7-b6d8-bda7a5716728	f255be7f-d6da-42f8-97b0-80aefbbfd52d
bfe4df3e-8156-4c4d-9ec8-a7638ebff2ca	t	f	2022-01-11 00:00:00	\N	7647310f-d340-4dc7-b6d8-bda7a5716728	f575215f-4eab-4db9-993c-f0a89d64746f
12a647ba-3464-4912-950b-242b1ccbcb99	t	f	2022-01-11 00:00:00	\N	7647310f-d340-4dc7-b6d8-bda7a5716728	fcbe03a8-fe1c-4a28-892b-9e09eda4820b
8286c3c5-bde9-4e0c-bd8e-6dce5b3d5e52	t	f	2022-01-11 00:00:00	\N	7647310f-d340-4dc7-b6d8-bda7a5716728	6b94806e-bc8f-4ea0-99b9-5397759bc338
e53512c1-fbbe-42c9-b2b3-1d23abc2f638	t	f	2022-01-11 00:00:00	\N	7647310f-d340-4dc7-b6d8-bda7a5716728	9578f329-e7f1-4839-a676-b5586136a56d
e6f59633-2135-4198-affe-d2cdf3f04cac	t	f	2022-01-11 00:00:00	\N	7647310f-d340-4dc7-b6d8-bda7a5716728	c23e3b72-abf0-476c-8c06-98f79cb9e79c
166be6dc-d526-4acf-8c2c-62c309dcc701	t	f	2022-01-11 00:00:00	\N	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	86b3a1de-3668-4dcc-97ac-8cc6d2d599d6
bf94e9d5-5d49-4a65-9edb-81b27cff9716	t	f	2022-01-11 00:00:00	\N	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	9b6422ac-fd26-44e4-a0a7-6ea980ddf8ef
40add39a-c0db-4dee-a1bd-ea1cee30d266	t	f	2022-01-11 00:00:00	\N	89e47949-21f1-4855-a397-20c3bc3426d7	438b959b-3e2d-4a8f-acdb-c208c2ef7c77
cb5cbd54-8bb8-4a81-9450-173b5fe7f089	t	f	2022-01-12 00:00:00	\N	1fe6d9ce-05bf-4a02-81c4-53d731398880	c43e58b3-e4b5-4fd5-a470-ad57d7bdf1fe
8d292d7e-8467-4a36-9b51-9963b15bf858	t	f	2022-01-12 00:00:00	\N	1fe6d9ce-05bf-4a02-81c4-53d731398880	f262a7de-3583-4ea0-b3f8-9003b8e0ee88
9cf77b37-620f-40da-acfe-9a13e9831168	t	f	2022-01-12 00:00:00	\N	688a34cb-72f2-4920-aeb3-89325956de26	4cbc430f-44fe-4482-8298-e8f859552e29
63bbf548-7a5e-4c36-9019-5aa84a4b7da5	t	f	2022-01-12 00:00:00	\N	852ccab3-35f6-4d12-815c-d8b66ff664b7	ef8e38e0-7caf-4e07-87f6-8a70b77c1ff1
d3b72d3b-4090-41c4-a8f1-062e2c1055f3	t	f	2022-01-13 00:00:00	\N	1fe6d9ce-05bf-4a02-81c4-53d731398880	41caa163-7800-48d8-b8a5-30bedc6d861d
2f51adec-86b2-4a4b-ae5b-b2f1e8cd1691	t	f	2022-01-13 00:00:00	\N	1fe6d9ce-05bf-4a02-81c4-53d731398880	36a9a36f-0208-42ae-b879-eea8ae96d828
1f609a4b-1735-4af9-b895-32701bf19818	t	f	2022-01-13 00:00:00	\N	a60429c0-6964-454b-8ee1-ddad66957f06	affa65ea-3dea-4ca9-ab99-78a5e47258fc
cbcc8ef4-a54b-4989-9010-cd6d5a4c98f0	t	f	2022-01-13 00:00:00	\N	a60429c0-6964-454b-8ee1-ddad66957f06	98446f19-e0a5-4c96-853c-2c0b6751a9d2
8ae012fa-c4b0-4ee3-bfcb-2305217f4508	t	f	2022-01-14 00:00:00	\N	c0a6c2eb-1278-42b5-8aba-0426f3550863	941bbd43-2df8-491b-a667-c7e455a8a49d
38f191e2-492a-4e86-a8f1-c151cc5357b1	t	f	2022-01-14 00:00:00	\N	24510313-6d39-4217-bb3f-0bfa7fbb73d3	5d5d4b80-7009-4b03-950a-be4e5e97ac7c
581c4f03-2c82-4e8c-aa21-08ee4582f254	t	f	2022-01-14 00:00:00	\N	24510313-6d39-4217-bb3f-0bfa7fbb73d3	fa0e3750-34e6-493d-b3fc-d93b7506ab14
350ee796-d7d0-42d7-9874-0d28c52831fb	t	f	2022-01-14 00:00:00	\N	24510313-6d39-4217-bb3f-0bfa7fbb73d3	3f855bcc-e320-4346-b97b-ab7c74bb9e35
a09628eb-3632-4ebc-96a3-409ad194ca5e	t	f	2022-01-14 00:00:00	\N	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f05edd05-f39e-480d-b1dc-c07df0b5639e
12b84c72-db5f-46a7-b485-bcbdfb6aa317	t	f	2022-01-14 00:00:00	\N	24510313-6d39-4217-bb3f-0bfa7fbb73d3	474b3b8c-3108-48a6-bc8f-da6ad98a062d
69ea78ed-d5c3-4542-bb85-a5d86e16570c	t	f	2022-01-14 00:00:00	\N	24510313-6d39-4217-bb3f-0bfa7fbb73d3	6b597911-6386-4da6-a771-d1ae47749e44
521d4aca-ed34-4a24-9a58-2d7957d937d3	t	f	2022-01-14 00:00:00	\N	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f06eddd1-2f48-49c2-b3f8-0671ae727d1a
3228c93b-2fad-45ab-a9b7-041640bad3f0	t	f	2022-01-14 00:00:00	\N	24510313-6d39-4217-bb3f-0bfa7fbb73d3	d1e393de-3fc5-4a5f-9684-10b3f5c4dc38
811580a0-6b48-4186-9b6e-f27edf41fc49	t	f	2022-01-14 00:00:00	\N	24510313-6d39-4217-bb3f-0bfa7fbb73d3	35e7e6fe-5d65-4d2c-aa85-f4a127c8a74a
1214e9aa-648c-4453-a15c-c08ed9db7600	t	f	2022-01-14 00:00:00	\N	24510313-6d39-4217-bb3f-0bfa7fbb73d3	df60d1e1-188c-4599-b481-f883bf6e43c9
8bf615ca-4619-4d5c-9f80-0170450111ee	t	f	2022-01-14 00:00:00	\N	24510313-6d39-4217-bb3f-0bfa7fbb73d3	b50a9187-40f3-495b-904b-9ac1b0ecddf1
3a27ce45-b6d8-4b6c-bb31-cd8fde65c7ed	t	f	2022-01-14 00:00:00	\N	2fc3365b-34d9-4054-b2d8-aa859c7455e7	bcf7557d-05e9-4eca-9b8f-f2293b122e6f
78497b7f-aad9-4e8b-86c8-cf68ac2d68ba	t	f	2022-01-14 00:00:00	\N	2fc3365b-34d9-4054-b2d8-aa859c7455e7	d3616962-6b9d-44c8-be54-1d321ea5e511
65ed48ce-30b4-4998-849c-3c309c33f7a6	t	f	2022-01-16 00:00:00	\N	80c08ccc-c90e-4377-af3b-2de779197c7a	ccb1b8b9-7393-41ac-81a4-91aee3517aef
5610263b-1691-49f6-af22-777ff5dbc51f	t	f	2022-01-17 00:00:00	\N	e3df7bcf-4e86-48a6-92de-474fa94729a3	d716fa96-59e6-46c7-90a1-32583e8a4253
f2750c32-0223-4384-82d2-4fcdad2f867b	t	f	2022-01-17 00:00:00	\N	e3df7bcf-4e86-48a6-92de-474fa94729a3	d48a2241-8a41-403a-989c-d408bdbed5e4
de389304-d790-42f2-86b0-94b98e5ea5b3	t	f	2022-01-17 00:00:00	\N	e3df7bcf-4e86-48a6-92de-474fa94729a3	1c65ffb5-f1ce-4979-a2ce-bb0ac54f6ffc
bf284aad-c4df-436c-a9c5-ae3395d7b481	t	f	2022-01-17 00:00:00	\N	e3df7bcf-4e86-48a6-92de-474fa94729a3	c1ff2734-9478-4747-aa67-d84cf087868e
2ae27d51-f415-4a27-9f31-fa4fd15e4a64	t	f	2022-01-17 00:00:00	\N	e3df7bcf-4e86-48a6-92de-474fa94729a3	4aafd813-b46a-4496-a5c1-6104cf8511dd
da80b1c3-b6b6-4170-a58c-d3dc279e5a36	t	f	2022-01-17 00:00:00	\N	e3df7bcf-4e86-48a6-92de-474fa94729a3	9926f56b-418a-4484-8b06-83d8b7dcec50
6218d6c1-d190-49cf-b5e2-90fcb49d1632	t	f	2022-01-17 00:00:00	\N	e3df7bcf-4e86-48a6-92de-474fa94729a3	8fbdbec6-80f0-47a5-94d5-5d02fda96258
fc9a1b2e-28ea-423a-84d3-70b6c70268d2	t	f	2022-01-17 00:00:00	\N	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	4df08a37-ae33-4c42-aee0-5b8f6a483166
5b774204-c7a3-472d-99da-b3fbdf7efc48	t	f	2022-01-17 00:00:00	\N	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	4ec3c51c-93cf-43cc-9c48-8d588c04211d
abd2935b-5253-47e4-a80f-907fd4ea169f	t	f	2022-01-17 00:00:00	\N	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	611a1bed-57b2-4f8e-b0c0-9c7ce15d8719
7d0fbaa0-89d1-4c99-8b93-5edb561691cc	t	f	2022-01-17 00:00:00	\N	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	af4c71b9-b08d-4099-9fb1-7cf9f23c1786
affaa614-e361-415b-b9c6-955e47290b03	t	f	2022-01-17 00:00:00	\N	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	be60e1fb-63e3-480e-9209-33d106a95c44
fc00113c-f6ac-40c3-8448-b753005dff57	t	f	2022-01-17 00:00:00	\N	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	85679d14-b276-4d13-b9a5-1e9e88d4c76e
0a232d4b-5fdc-4097-bf4b-878ca991f348	t	f	2022-01-17 00:00:00	\N	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	19f95456-20f4-41ac-8d1d-c047fddcd9c6
d572503f-c208-4701-bde0-5ac7524b824f	t	f	2022-01-17 00:00:00	\N	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	c471fd65-a76b-4110-bc26-313e58c98491
e1f862c7-d57e-4c54-8ff2-71e4a13ded73	t	f	2022-01-17 00:00:00	\N	773a0356-9c76-4dfb-8c56-c1693ee2819d	3f161f1d-4285-4694-aa13-842425295826
e168f0c7-5ded-4d70-8b23-cc2d903a4709	t	f	2022-01-17 00:00:00	\N	773a0356-9c76-4dfb-8c56-c1693ee2819d	4b3d79b0-79a5-4d52-9c25-36e7455097e1
f3f06119-3b39-4dd9-8af5-c09b5dd01e05	t	f	2022-01-17 00:00:00	\N	773a0356-9c76-4dfb-8c56-c1693ee2819d	8f9b9fca-0606-4944-a414-3d56b4d43ed6
12dc16f7-18ba-4ebf-81ac-1af7e4f2e771	t	f	2022-01-17 00:00:00	\N	773a0356-9c76-4dfb-8c56-c1693ee2819d	5eb2361a-e95f-49ab-8d15-b77d00fc7e1a
3d86255d-d077-40f0-8186-1a91b1386fcf	t	f	2022-01-18 00:00:00	\N	773a0356-9c76-4dfb-8c56-c1693ee2819d	24f02407-5cf2-4384-8ea3-ec5292ce4a72
ca88f262-8a4e-44e5-a31c-987421defc9d	t	f	2022-01-18 00:00:00	\N	773a0356-9c76-4dfb-8c56-c1693ee2819d	f7aa7d0a-58c8-4781-b8bd-0af1bf4615bd
5156a07f-fada-4501-b66c-a1b092091572	t	f	2022-01-18 00:00:00	\N	773a0356-9c76-4dfb-8c56-c1693ee2819d	70870a17-d0c2-45be-ab72-3a819b3c7673
e2d41d40-0d0b-46ed-a123-cfc5e53dee94	t	f	2022-01-18 00:00:00	\N	773a0356-9c76-4dfb-8c56-c1693ee2819d	974578c2-33f3-494d-93e6-eea345ef6d22
d9e9d3dc-58d6-4db5-93c9-2b89fbf6cd79	t	f	2022-01-18 00:00:00	\N	773a0356-9c76-4dfb-8c56-c1693ee2819d	c403ff2f-1f49-49f8-87b9-2563f163a437
41ce08da-3362-46cb-90e4-8d361359fd7b	t	f	2022-01-18 00:00:00	\N	773a0356-9c76-4dfb-8c56-c1693ee2819d	06e1270e-8eda-4790-a920-7a4089869c7d
19d9bee9-7c4d-4c5e-8eaa-8ac5051c935e	t	f	2022-01-18 00:00:00	\N	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	c20621d6-69c7-403b-98af-658229c9c45d
fcb2af13-aaac-4317-80eb-c998d203969e	t	f	2022-01-18 00:00:00	\N	688a34cb-72f2-4920-aeb3-89325956de26	825576b7-1723-4c59-ab5f-1a4fd04c0d72
5322b62b-d666-4909-bf6e-859c4dc896f3	t	f	2022-01-18 00:00:00	\N	688a34cb-72f2-4920-aeb3-89325956de26	93851cba-8452-4b98-a25c-972fdb42c5cd
26b16a66-0446-485b-b81b-742031689c66	t	f	2022-01-18 00:00:00	\N	688a34cb-72f2-4920-aeb3-89325956de26	e422a46c-df51-4aa4-bb5c-9b5b5f29e67d
5fb8b572-ba16-4783-b7a3-0c67fb5318f0	t	f	2022-01-18 00:00:00	\N	688a34cb-72f2-4920-aeb3-89325956de26	1a80a988-db22-4991-a676-091f902279c3
44e74cc3-2fc4-4426-b33b-ea6f3def3534	t	f	2022-01-18 00:00:00	\N	688a34cb-72f2-4920-aeb3-89325956de26	3f56cd5a-ed1f-488b-aac7-752be8053a11
2a1626c1-e492-4e11-bb7a-a9e011e4055e	t	f	2022-01-19 00:00:00	\N	854e7b58-34dc-4ed5-ac6c-f233476b1e9e	7f800a3c-a073-45e2-9a19-88cbb30d409b
5c595fd8-ec7a-4b34-9d26-e7794b13ba3b	t	f	2022-01-20 00:00:00	\N	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	77ecdfbf-9452-4404-92c1-fa0841e51591
976388b0-2272-47b6-9a47-546cbee65037	t	f	2022-01-20 00:00:00	\N	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	5d0b3959-5174-4530-ba14-b33f686b1b2c
8eeca7c2-18f6-4bbf-b5f7-183eb6087e32	t	f	2022-01-20 00:00:00	\N	d48095c7-3de5-4a8d-b893-b8d432e7c647	2193264e-d362-4d75-a51b-b319dea02438
e06ae247-6d2d-49cd-8a35-39c2b84a042c	t	f	2022-01-20 00:00:00	\N	d48095c7-3de5-4a8d-b893-b8d432e7c647	9a19e2a2-ace7-4d2c-a308-429c76d6d683
28a56b32-b102-4576-9aef-765e091efb53	t	f	2022-01-20 00:00:00	\N	d48095c7-3de5-4a8d-b893-b8d432e7c647	0e54809f-de03-4ccc-a761-2eb4541d5e01
39fd204d-f2b9-4bf8-9a5a-3e4f6032cf28	t	f	2022-01-20 00:00:00	\N	d48095c7-3de5-4a8d-b893-b8d432e7c647	2e0b35ff-c539-4f6e-995c-f937202c9f88
0da52625-65fe-4ff9-ab26-559be12c133c	t	f	2022-01-20 00:00:00	\N	d48095c7-3de5-4a8d-b893-b8d432e7c647	d2296a55-2592-4eb9-884d-2ab5fc33b3d6
13495f4c-b22d-459b-a26f-73581c7bb2f8	t	f	2022-01-20 00:00:00	\N	d48095c7-3de5-4a8d-b893-b8d432e7c647	72bcd2da-883c-4119-ad5b-3ac96d75e79c
2f5f489f-b8d9-4bcd-a41a-894dce30ab6e	t	f	2022-01-20 00:00:00	\N	d48095c7-3de5-4a8d-b893-b8d432e7c647	d66be606-f1a2-4202-8b68-41ce7630ac2f
2c712383-08e9-4086-ac52-68573bc7830d	t	f	2022-01-20 00:00:00	\N	d48095c7-3de5-4a8d-b893-b8d432e7c647	622ae8b3-d876-4d6c-b4dd-0d6e93ea3df1
7cfcdf0b-1bb4-4b4e-af69-3b6635048406	t	f	2022-01-20 00:00:00	\N	43812428-ee9e-486f-81d1-8e38da69c9c4	55652cc8-bcb7-49ba-8348-e62b362ee2a9
b268e6e6-cd3a-4780-8ffe-ec0a6f4e74af	t	f	2022-01-20 00:00:00	\N	43812428-ee9e-486f-81d1-8e38da69c9c4	993eee0c-9967-4f02-8462-72c91bbd0c29
d9887dfb-e188-45ee-b9dd-266afeaf35b7	t	f	2022-01-20 00:00:00	\N	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	a8528c10-1ca9-4de5-8c0b-54b4e2702872
c348e2eb-56d5-4f39-856f-050fde55dea4	t	f	2022-01-20 00:00:00	\N	81308200-79d0-466c-a19a-ca3fbef6045a	c0fb2212-c732-4a53-a567-7fc5482381b0
1abdcb47-935a-452f-a04a-a1b40b403b51	t	f	2022-01-20 00:00:00	\N	81308200-79d0-466c-a19a-ca3fbef6045a	17ed84be-4dcd-4fab-baf8-40c3c422dcc0
d689c5f2-37f2-4349-9d49-527b3f09ad30	t	f	2022-01-21 00:00:00	\N	e2438143-6017-4683-a533-6113748d4117	5027e4f7-6222-46bc-8972-6e76a136c3bd
b3022aec-0be2-4a86-83b0-488f1c608d68	t	f	2022-01-21 00:00:00	\N	e2438143-6017-4683-a533-6113748d4117	061f1886-4c55-442e-8b39-105a494a09ad
1c9ab38a-129a-4f33-897f-f6c15d4e9137	t	f	2022-01-22 00:00:00	\N	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	d51f134d-0515-4910-a830-441f701f687e
e998e276-6ebb-4813-b8bc-753b19a4ad25	t	f	2022-01-22 00:00:00	\N	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	07a30ce1-69bd-406a-9f46-5b790f2b5f77
83d8ffaa-6c5f-4d21-b885-cb4098e99265	t	f	2022-01-22 00:00:00	\N	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	21ac6f4c-e6ba-48dd-a8bc-63c8ccd1e158
7bbf3bf0-7729-4936-b372-62051d64b4dd	t	f	2022-01-22 00:00:00	\N	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	0bd1479e-448a-45b9-b655-668fddffe9ab
1bd57e0e-2bb9-4a83-9338-b22c550ad532	t	f	2022-01-22 00:00:00	\N	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	7bd09345-9f0b-46b8-8c67-557e2fe1da3c
6682a28c-c467-4b7c-95fa-4f716daa2f3d	t	f	2022-01-22 00:00:00	\N	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	086863f5-5162-464d-8399-f3835f80e0c4
075ac35f-cfdc-4d1c-b299-97f0211a9167	t	f	2022-01-22 00:00:00	\N	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f66694e8-2f3e-492d-b9b4-9a2e5b7066c3
0d6df09f-3198-45a9-94f2-ebe2d844dbfd	t	f	2022-01-22 00:00:00	\N	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	3ec16c8b-1656-4c98-83f2-92de26adba79
021639b4-e8bf-428d-99d1-7e0c85733ef6	t	f	2022-01-22 00:00:00	\N	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	2d825100-4593-45a1-b486-2670cb27eb1c
9937b264-f2a7-428d-9c4b-5c42eed6b2c5	t	f	2022-01-22 00:00:00	\N	1d2a9859-0137-4da2-8390-6cd570385ec4	3680433a-ff79-4a68-9715-44563de86317
9c2e36da-7d86-463c-b874-897164ebcad8	t	f	2022-01-22 00:00:00	\N	1d2a9859-0137-4da2-8390-6cd570385ec4	db8ee7df-c8f5-4aec-a78f-72ea750ba251
6dddbc60-58d9-4faf-ad06-8e0f4189bb25	t	f	2022-01-22 00:00:00	\N	1d2a9859-0137-4da2-8390-6cd570385ec4	7a330c16-06a5-428c-a46d-1b70bdd2ec56
7457b675-6a95-47de-9d7c-54168be61e9e	t	f	2022-01-22 00:00:00	\N	1d2a9859-0137-4da2-8390-6cd570385ec4	3b2954f5-a0c6-419a-8e5b-0e48dc81f042
4b125534-5e4d-4b90-9dd7-3c17718bd988	t	f	2022-01-23 00:00:00	\N	b490aa6f-84cd-4be3-95da-7e230d5f645e	345ef8eb-5e36-49fa-adbf-9a6be345f123
e3aae154-1912-42f3-9181-b53fadde0273	t	f	2022-01-23 00:00:00	\N	b490aa6f-84cd-4be3-95da-7e230d5f645e	0aa96d4f-62c3-47e3-8b8f-94809f66f05a
c75ed0d7-7817-4c4c-9234-e3f690edebb4	t	f	2022-01-23 00:00:00	\N	b490aa6f-84cd-4be3-95da-7e230d5f645e	e2fd5aa9-6922-4c05-8731-b4481a0e30db
d839e50f-e91d-457a-96ee-3a09d592180f	t	f	2022-01-23 00:00:00	\N	b490aa6f-84cd-4be3-95da-7e230d5f645e	9381b75b-ffcf-46c5-9485-3de896616db3
5de435b6-4d41-4f04-9115-c27c1c0aed6c	t	f	2022-01-24 00:00:00	\N	e2438143-6017-4683-a533-6113748d4117	3acca230-7a77-4087-876b-f4fdaeb582e1
34b39613-bc53-46ac-b4c9-bf2b50999784	t	f	2022-01-25 00:00:00	\N	852ccab3-35f6-4d12-815c-d8b66ff664b7	ad68f084-9f3c-46f8-8f3d-6d6a339b10eb
0ee637ce-0f0b-411e-8f1c-40f913f9b355	t	f	2022-01-25 00:00:00	\N	81308200-79d0-466c-a19a-ca3fbef6045a	1e1bcb74-bcde-4303-bcec-7902e23a5b77
09cf6f33-2689-461d-bb60-9f908092aba2	t	f	2022-01-26 00:00:00	\N	0205ab00-b754-463a-9227-28ee5b6fe953	6a37a1d4-593f-425e-8335-a52dcd43391c
75d59d93-2b63-4513-b830-e904487f7244	t	f	2022-01-27 00:00:00	\N	a5302a2b-d270-49e5-9876-47c84cb38038	d64acad6-ca2f-4c2b-8407-854d9c3ba060
90e4edae-9c69-4026-a0f1-37f62a5878d4	t	f	2022-01-27 00:00:00	\N	a5302a2b-d270-49e5-9876-47c84cb38038	b2736bf3-6d33-439a-906b-d19ed002190b
6999f6b8-8f5d-46c2-aa7d-beca523e1f28	t	f	2022-01-27 00:00:00	\N	a5302a2b-d270-49e5-9876-47c84cb38038	ca42885f-89a4-4adc-bcda-dacb79920c8e
814871c9-dee5-4834-b5eb-799b23227ed6	t	f	2022-01-27 00:00:00	\N	a5302a2b-d270-49e5-9876-47c84cb38038	ca8a9503-1aa2-4ed2-8dc0-933fbb67d222
86fdb872-2605-453d-b267-a0daefc60f35	t	f	2022-01-27 00:00:00	\N	a5302a2b-d270-49e5-9876-47c84cb38038	4d82dad7-7c7e-476a-bdb2-7a7a52d7ac6f
a936bad0-4d95-4ca3-ba67-888ae0ed8ad1	t	f	2022-01-27 00:00:00	\N	a5302a2b-d270-49e5-9876-47c84cb38038	925ac1e2-e8e7-4054-bb57-5f54a875ccb0
5b00dbab-ce47-45a5-9b2d-df1c7cd2aad3	t	f	2022-01-28 00:00:00	\N	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	17f95695-7deb-49cb-b14a-f73e44619c78
449b112b-852d-4d46-bfe8-714b42444f8a	t	f	2022-01-28 00:00:00	\N	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	5446d58f-3a93-41bc-8018-b792df6f463a
b114405b-fecc-429d-9e05-0e8e1f4a32a0	t	f	2022-01-28 00:00:00	\N	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	a1ea2681-1d28-4581-b5b3-94fe471976b5
69b42b7b-d103-4c22-ac7a-221ac6bdef33	t	f	2022-01-28 00:00:00	\N	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	e6fecc49-f1aa-42c2-8d13-9a22dd77627d
94537589-44b6-401b-9ad0-3f55a5a038d0	t	f	2022-01-28 00:00:00	\N	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	7e1bb369-f7fd-4182-8a78-60964391c46d
7af26cce-8823-4461-be3b-7e2886b6d746	t	f	2022-01-28 00:00:00	\N	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	4190ccc1-1383-488f-946c-cd4bf3f4073c
bcb23b74-b2c2-428e-8948-81300c94b23a	t	f	2022-01-28 00:00:00	\N	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	3ebfa3a6-812c-4d17-bcf2-9a493fcb7798
56a9eef4-749b-4ee0-b515-aac52b8b113a	t	f	2022-01-28 00:00:00	\N	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	b56e5bce-c15c-439a-94dd-988ec063b9fe
53091396-4d45-4e79-8454-906048ac74f7	t	f	2022-01-28 00:00:00	\N	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	22f9861a-28d1-4bdb-8fc8-4f52fb105495
850034c1-8da3-4669-992e-33aaee6d8231	t	f	2022-01-28 00:00:00	\N	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f830913d-ad31-40a0-87be-f02e02af340f
4d098039-3d99-4dc9-b124-47cd08240e46	t	f	2022-01-28 00:00:00	\N	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	eafe70ae-d4f6-4678-93fc-e10d817b0334
a16b1928-0c34-4895-a364-30f4ba943718	t	f	2022-01-28 00:00:00	\N	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	c9189cbd-6a02-40a1-8ab0-12f62fe3ab86
fe6275d9-75f9-4214-af86-a2c314052a61	t	f	2022-01-28 00:00:00	\N	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	47c29583-4a08-4aef-97dd-f999f515aea9
d82e4ea5-978f-4b9b-b68e-b892d11fde66	t	f	2022-01-28 00:00:00	\N	86a39d76-71ed-4890-82ec-ce2a48d32627	17d13b97-d58e-4203-9610-d7d0047a90c6
f3e0dd16-d46f-4c7a-aaf8-abf1dfb1249e	t	f	2022-01-28 00:00:00	\N	86a39d76-71ed-4890-82ec-ce2a48d32627	1b74e314-60a0-4d27-8a43-0265b6be2fd5
7c50c29c-e9f4-43be-9a4b-8e69480d34b0	t	f	2022-01-29 00:00:00	\N	852ccab3-35f6-4d12-815c-d8b66ff664b7	04d35523-c7ce-47cf-bf63-b9f35e991760
945d123f-2fdf-46ac-baa1-1f7fa88648ae	t	f	2022-01-29 00:00:00	\N	852ccab3-35f6-4d12-815c-d8b66ff664b7	b07891d6-22bb-453c-806c-ddb503bde0c1
ef934c7e-22c5-4341-ab82-b837a9a0ba02	t	f	2022-01-29 00:00:00	\N	852ccab3-35f6-4d12-815c-d8b66ff664b7	0f817251-d3f2-4616-8ae7-5c6a1c67eb0e
c133c0c5-60c4-4a1c-aaf6-4d5ae77ab176	t	f	2022-01-29 00:00:00	\N	80c08ccc-c90e-4377-af3b-2de779197c7a	4dc2eaaf-22fd-47b3-965b-c50e130cf2bc
540e44c0-170d-4ab3-afc0-a77ef5e118ef	t	f	2022-01-29 00:00:00	\N	80c08ccc-c90e-4377-af3b-2de779197c7a	384f338f-40e3-4330-831e-7a657bff33f8
0eb9e25c-9f59-4dba-a475-4f98d295d4a5	t	f	2022-01-29 00:00:00	\N	80c08ccc-c90e-4377-af3b-2de779197c7a	4d0580dd-a48a-42b4-abdd-85d17500a946
f9643bfe-181d-41b2-abfa-03f859dcb46a	t	f	2022-01-29 00:00:00	\N	80c08ccc-c90e-4377-af3b-2de779197c7a	bc81b02a-b96c-4cd0-99be-7aac90ff269a
a6a2f6a8-178e-41c3-a0ee-81bc4f4f62f5	t	f	2022-01-29 00:00:00	\N	80c08ccc-c90e-4377-af3b-2de779197c7a	6aa74387-60aa-4e0e-9477-5f4d10d39263
2ff897a4-2407-4917-aedb-1d16ea9d87f2	t	f	2022-01-30 00:00:00	\N	1030974d-cffe-46d6-b6ea-79c8839cf2ea	42b40986-b948-471f-9844-be6cd45e64e7
1675fc8e-6714-46eb-8153-ce2ccda25ec8	t	f	2022-01-30 00:00:00	\N	4e9262a1-fef9-4701-9c91-1b3016ee971d	1b645a4c-9c7f-4648-8663-4e621fd2aaa1
0a898bcd-8f91-45dd-8676-e0f35aab8031	t	f	2022-01-30 00:00:00	\N	4e9262a1-fef9-4701-9c91-1b3016ee971d	f2b44c2f-7eec-40b8-a7df-0189cefdfb78
6d8abb48-e43b-48ae-b929-1e109919bc5f	t	f	2022-01-30 00:00:00	\N	4e9262a1-fef9-4701-9c91-1b3016ee971d	4b6e6eaa-24d4-4cec-9ed0-be4380718b80
e3dd948f-7935-48c4-8b01-3ba755741d12	t	f	2022-01-30 00:00:00	\N	4e9262a1-fef9-4701-9c91-1b3016ee971d	6b444e83-c271-4879-8b02-367cf035ca96
c5d31325-6a0c-4ae1-8a55-cc8450cf033d	t	f	2022-01-30 00:00:00	\N	4e9262a1-fef9-4701-9c91-1b3016ee971d	83e5c48e-15ca-442d-afee-668be11d8226
fb52ce66-c821-47d6-9211-c911ea010a35	t	f	2022-01-30 00:00:00	\N	4e9262a1-fef9-4701-9c91-1b3016ee971d	4b382a2d-2d01-491a-8d43-7166a57e3302
a687341d-7f1c-4f3d-af1b-5c91b1b2dbeb	t	f	2022-01-30 00:00:00	\N	4e9262a1-fef9-4701-9c91-1b3016ee971d	612da206-6246-4df9-a86e-9f645a6115db
a8c21996-630b-40f9-a97c-e45879365581	t	f	2022-01-31 00:00:00	\N	0a9d4719-903b-4f31-9e00-10fc47c954fd	2155cb46-c288-46f7-afa4-6637e6f35b60
caf6e68d-540a-4b80-b183-a9f753cb0f6a	t	f	2022-01-31 00:00:00	\N	08bfbb88-e782-4169-83fd-17b0fd03da18	822732d6-3bf2-49cb-9128-815d6bac8437
99bb3a70-e71e-445c-97df-df5b534e606e	t	f	2022-01-31 00:00:00	\N	08bfbb88-e782-4169-83fd-17b0fd03da18	bd872f00-9dea-4026-9711-00439a28b4f4
afdb2768-ca63-4e25-8849-7d650bfa8e3d	t	f	2022-01-31 00:00:00	\N	08bfbb88-e782-4169-83fd-17b0fd03da18	7d656112-7de1-4c76-80ba-162e24bf4a0a
cabfd8e3-a9a4-445a-9eba-a6f4fc2f9f02	t	f	2022-01-31 00:00:00	\N	08bfbb88-e782-4169-83fd-17b0fd03da18	83f8fc6e-1d1b-4d68-aa2c-baf4f4939964
7315fcef-d17c-45b5-a1f3-f48bf695965c	t	f	2022-01-31 00:00:00	\N	08bfbb88-e782-4169-83fd-17b0fd03da18	f8cbc6eb-b99a-464a-b9d4-bfb495f70830
32d3316d-3f99-417b-8497-ad5f83393368	t	f	2022-01-31 00:00:00	\N	08bfbb88-e782-4169-83fd-17b0fd03da18	38b4fe63-43b0-463f-8730-4a5908d0decf
f134a989-3a50-48e8-8f8b-920952333f8e	t	f	2022-01-31 00:00:00	\N	08bfbb88-e782-4169-83fd-17b0fd03da18	3552e5c0-b13f-4fb2-8a75-ceb6ef4cf677
d756e49f-2b9c-47d5-8dbb-52a24d835fd8	t	f	2022-01-31 00:00:00	\N	08bfbb88-e782-4169-83fd-17b0fd03da18	26a9d8c1-3d57-455d-81f1-e25a0fec7c71
40f7bb02-20b6-4d21-a3ff-38187b62b1a7	t	f	2022-02-01 00:00:00	\N	c0a6c2eb-1278-42b5-8aba-0426f3550863	9fe8a226-1f0f-4646-bffd-dc04159e8afd
53a5db62-2745-459c-9654-8cf8fd985101	t	f	2022-02-01 00:00:00	\N	c0a6c2eb-1278-42b5-8aba-0426f3550863	e49bf978-0b2a-4156-9d23-f360306d442d
a58f3bef-18a7-4280-a7fb-52ee6f18afb9	t	f	2022-02-01 00:00:00	\N	c0a6c2eb-1278-42b5-8aba-0426f3550863	9910fc55-5bc6-4479-af92-eae7b840f295
ebe45c81-2317-42bb-a32a-99594764b430	t	f	2022-02-01 00:00:00	\N	c0a6c2eb-1278-42b5-8aba-0426f3550863	18102c15-f386-43cd-a84b-86f792e2a3ce
d5cf5a3c-76af-498e-a3a4-9a31f966c054	t	f	2022-02-01 00:00:00	\N	c0a6c2eb-1278-42b5-8aba-0426f3550863	b22ac014-1a23-4afa-b64c-51d3a5598b40
6009ad3d-e7fc-4048-aa9c-635aeddf50d7	t	f	2022-02-01 00:00:00	\N	c0a6c2eb-1278-42b5-8aba-0426f3550863	8bd3e973-5d5a-4f6b-93a2-2c12150667a8
33af9058-90cc-4fa0-9f7e-1cca04b28973	t	f	2022-02-02 00:00:00	\N	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	1f84c59d-f045-4bf6-9535-a0ca0d6af899
42969c9b-3e20-40ac-800f-275064d09813	t	f	2022-02-02 00:00:00	\N	fe6fd149-2231-415b-95c0-c4194aaf56a1	b73c8e58-32a1-4178-9e7d-8b4f472f24e6
fdcbc4f6-5134-4284-9757-a6d287a162b5	t	f	2022-02-02 00:00:00	\N	0f604f34-370f-4593-8173-cd24234cff78	a69b96a6-8676-4a76-9c11-acfbab6d8676
2ca48d13-4c16-47f0-baae-847b5d744371	t	f	2022-02-02 00:00:00	\N	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	2b324662-f93a-4017-bda8-48ed46fae70f
4bc7a297-c56d-4cdc-a8e8-683a1134bd00	t	f	2022-02-02 00:00:00	\N	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	1f3938a4-89b5-425d-9e28-497df7df1a28
cbeebe90-baec-4e02-ab4e-4740bf9faa29	t	f	2022-02-02 00:00:00	\N	a3895837-7bb9-48fa-afd0-b88c1edc7a95	5ce1c09e-32cd-4153-811d-283b51f0fb48
41bc64df-a3b3-47e8-b2eb-d3fc52b7516a	t	f	2022-02-02 00:00:00	\N	a3895837-7bb9-48fa-afd0-b88c1edc7a95	1fc9ff0c-1fe2-4028-9db8-818b0fce6e4c
16100089-537c-4f59-914d-18452ff7c310	t	f	2022-02-02 00:00:00	\N	cfb35447-962b-479e-af0e-2f95dfbc9fde	675c7652-6162-4b89-bd73-dccb3ab657dc
d12ec465-a083-4bee-945d-135964e36431	t	f	2022-02-02 00:00:00	\N	cfb35447-962b-479e-af0e-2f95dfbc9fde	bc32d83a-8eb6-42fa-8457-9104fb535a5b
dab92035-2330-44b4-b0cb-da26c3ff2751	t	f	2022-02-03 00:00:00	\N	28f767de-cc97-4d11-9c40-6888376971a6	6b5eb2d3-956a-47da-b731-fd2017b7434d
747c98e1-1958-4517-964b-3662c6ad4ce6	t	f	2022-02-03 00:00:00	\N	89d0839c-785c-4037-ac95-05745e1fd429	1eb82ebf-1ba1-4a8d-a7fd-4351b06e88c3
338ccd7e-6a4f-46d3-820a-c0f8514f76a2	t	f	2022-02-03 00:00:00	\N	1d2a9859-0137-4da2-8390-6cd570385ec4	adae4dae-17b4-44cd-8faf-d6a6d6eafb36
b7778ea5-c56a-4bd9-8698-5c020b71fe9b	t	f	2022-02-03 00:00:00	\N	1d2a9859-0137-4da2-8390-6cd570385ec4	6c83e7f3-684d-41d9-9304-cba6eaee2b80
f4187988-5574-42ec-9e25-f5ea8ea2255b	t	f	2022-02-03 00:00:00	\N	1d2a9859-0137-4da2-8390-6cd570385ec4	f87f0f05-54c6-46e9-b36c-7b00ea92cf2a
7aa23f98-160e-4556-b599-9a5bdc1cb2f7	t	f	2022-02-03 00:00:00	\N	6cd2dec1-6466-4eb1-970b-81420914a9ed	499e51e1-e117-4479-9a51-967cca2122c0
3d8c5695-693c-45b0-a4b4-3fc5f7a91b09	t	f	2022-02-03 00:00:00	\N	6cd2dec1-6466-4eb1-970b-81420914a9ed	ac5bbd7b-726e-494b-8144-50035114a9b5
8f404a51-192c-4c43-be9a-22b3e2079959	t	f	2022-02-04 00:00:00	\N	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	511a53ef-0a61-4e03-98eb-ee55f3310a59
86cbc42e-8e92-434b-b34d-b82316358e9a	t	f	2022-02-05 00:00:00	\N	9562c508-9b9f-4852-af78-acd45d6f5d8d	b5eb4c41-78cf-440d-a7f9-0f69b39d6580
79c3a4ab-a269-4a60-8e4b-49e1a2407dc2	t	f	2022-02-06 00:00:00	\N	5ee987b5-deec-4087-b36f-bba4dcaf842f	ae021822-4388-4357-b2be-badd7ad52a12
ff663c09-7972-40cc-b9e4-17af3160a575	t	f	2022-02-06 00:00:00	\N	4c850776-1fc1-4201-9490-c1e848cd0f00	680e412e-c1d6-41ca-a780-88061f8c94de
03cb6f0b-2780-4620-a7ea-c0c1c3302c8c	t	f	2022-02-06 00:00:00	\N	81308200-79d0-466c-a19a-ca3fbef6045a	b476230f-9903-47bb-b2ed-20ec9c1cf194
c52bca62-e259-4bad-9070-13c945f06299	t	f	2022-02-06 00:00:00	\N	81308200-79d0-466c-a19a-ca3fbef6045a	8502503a-3bfc-4e21-87b9-dad1b87cdb87
23b302cb-7f8f-4118-baef-e9f25b67d7e4	t	f	2022-02-06 00:00:00	\N	23241a48-58b4-4a92-9529-86e25bc8ab9a	2a805d9c-5fbd-4bc7-ac97-76bad732613c
c433e07a-7bda-4a5c-99e0-c43ea95d81a8	t	f	2022-02-06 00:00:00	\N	80200590-2e5d-4900-bc9b-cf4d6f5d7265	684560d2-5ea3-4076-92e3-35d018968385
e252aec7-4164-4f1b-bb74-f98bf2bb2d81	t	f	2022-02-06 00:00:00	\N	97cf3158-df81-45c1-b49e-47a692438dca	dd98a669-bffb-47f4-9786-517866086534
a46daceb-75ee-42c9-b026-20217e9aa6d3	t	f	2022-02-06 00:00:00	\N	a47c9fe9-9d46-47c6-8cc8-b9728464daa2	b8bbee08-a65b-4f59-8b61-a5cd4881f4d4
d8fc4a3f-8d0b-4e5c-9f51-3c7ad188f8f2	t	f	2022-02-06 00:00:00	\N	97cf3158-df81-45c1-b49e-47a692438dca	fd2e5b8f-2ccf-4f2f-a64b-b667fa2e81d6
ab3bfe36-8cd7-41a8-95e5-11a77537743b	t	f	2022-02-06 00:00:00	\N	97cf3158-df81-45c1-b49e-47a692438dca	34da2c5f-0c4f-401f-b817-de9ce9f25db7
952ab15b-130f-426c-881e-9c4c468ad0c7	t	f	2022-02-06 00:00:00	\N	97cf3158-df81-45c1-b49e-47a692438dca	b3388e65-6a0b-41bc-a5e2-ec4a91f604e2
ccbc7bcb-d112-4f19-96fa-1f76473e7d5d	t	f	2022-02-06 00:00:00	\N	a47c9fe9-9d46-47c6-8cc8-b9728464daa2	774adf0d-2f37-4fc5-8c5b-6c0bce8b8680
24d7446b-79a0-4faf-b255-7f6b0e70420c	t	f	2022-02-06 00:00:00	\N	a47c9fe9-9d46-47c6-8cc8-b9728464daa2	3646dda9-2cd9-4f0c-afd6-f4ed170f6328
4b23fc92-177f-4afa-9578-5589f796d3af	t	f	2022-02-06 00:00:00	\N	a47c9fe9-9d46-47c6-8cc8-b9728464daa2	1e7b075f-151f-4b1e-9bbb-93118dbcd972
a1ba548b-658a-4954-a705-77a94dcc36bc	t	f	2022-02-06 00:00:00	\N	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	7da403e9-57fe-4ce7-84c0-27de44901373
8148ad1a-f9e4-49fa-99ed-f63ae4181d79	t	f	2022-02-06 00:00:00	\N	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	0cfeac7b-b3c0-4e5f-ad0b-b70323591294
9aa54e8a-952d-466f-9f49-d26b252d54d9	t	f	2022-02-06 00:00:00	\N	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	e3f8f50b-53c0-4caa-b2a1-042a86971a01
5d8ac5af-988b-41d0-8e0a-9bc24e7a00da	t	f	2022-02-06 00:00:00	\N	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	4a78d9be-5fab-4a9a-92cd-9d99a86fcd73
5f060360-f81c-4bf5-be05-bdb1b3fe73ce	t	f	2022-02-06 00:00:00	\N	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	4cd13020-4b58-4685-84c8-f1783f45d361
f635fbca-21cf-4190-a7e7-5087827bfb86	t	f	2022-02-07 00:00:00	\N	1fe6d9ce-05bf-4a02-81c4-53d731398880	e84bd253-96b9-43d4-846d-3894e82f6f02
77961b7f-ed81-4a30-8cb4-8ae48fced322	t	f	2022-02-07 00:00:00	\N	dc8ff971-5522-45bf-b501-ff65ecb46db9	1e8fe38a-aa89-486f-a31a-bebf4219f22e
f972b03f-4d84-450c-95c4-5a1b18aab697	t	f	2022-02-07 00:00:00	\N	773a0356-9c76-4dfb-8c56-c1693ee2819d	c1257a79-adcc-48ec-97c0-9cbc900d1fcc
419bd1a9-f711-4c12-8813-a6c00ba57758	t	f	2022-02-07 00:00:00	\N	773a0356-9c76-4dfb-8c56-c1693ee2819d	4116f11c-1a40-49aa-81a7-c041f218f8d0
bec8409c-55e5-49da-87c8-c933a7c0d24f	t	f	2022-02-07 00:00:00	\N	773a0356-9c76-4dfb-8c56-c1693ee2819d	d4d542e0-0194-48ef-a75f-668ba72f1c89
4540ed9d-e026-4ec6-a65a-a3b4294922ae	t	f	2022-02-07 00:00:00	\N	5ee987b5-deec-4087-b36f-bba4dcaf842f	5d832eec-7910-4153-8955-691938064e0d
6008f9b8-0ddb-4e1b-b2e2-05333da22b44	t	f	2022-02-07 00:00:00	\N	5ee987b5-deec-4087-b36f-bba4dcaf842f	49e092ce-b1dd-42af-a38a-b569212485d9
c36e8ab8-4878-4af2-b71b-c73e5014eb21	t	f	2022-02-07 00:00:00	\N	97cf3158-df81-45c1-b49e-47a692438dca	6be7499e-9c16-45e1-8741-aac41b19835c
7d3c601e-057f-4433-a55b-6e10cae56d1b	t	f	2022-02-08 00:00:00	\N	a7f39754-f6ec-4934-9c2e-6bb84f8be764	68d1b8e8-28fb-4824-a2a9-1272b22749ca
caf5b2e8-20e6-4058-98df-cfa02a3f1dc3	t	f	2022-02-08 00:00:00	\N	a7f39754-f6ec-4934-9c2e-6bb84f8be764	561abb5e-fd7a-4ac3-8234-2c2eed06046a
1270bf6a-d443-431f-8095-afa03071d780	t	f	2022-02-08 00:00:00	\N	a7f39754-f6ec-4934-9c2e-6bb84f8be764	cc4ce5c0-10db-4043-b4b3-2ce0f5c411c9
d808a48e-4f19-43d0-b53c-352a0c304b44	t	f	2022-02-08 00:00:00	\N	a7f39754-f6ec-4934-9c2e-6bb84f8be764	4cc265ad-9660-46bf-9a65-f388d84d1e66
abbb9ae0-e03a-4e9b-b655-f748722c8f3d	t	f	2022-02-08 00:00:00	\N	a7f39754-f6ec-4934-9c2e-6bb84f8be764	06c4b10e-5d4c-4dbc-8f60-979d116905c3
8fc56f98-c868-4e74-89ef-0b3083b6d14a	t	f	2022-02-08 00:00:00	\N	a7f39754-f6ec-4934-9c2e-6bb84f8be764	b544819d-de0b-4a87-ac1b-f6aeaa6b9a35
a85a097a-287d-41a1-b683-ff3088703986	t	f	2022-02-08 00:00:00	\N	a7f39754-f6ec-4934-9c2e-6bb84f8be764	212abe50-e318-4160-b8b3-6a73b90e7db3
4ddfaba9-65c0-4e97-8864-29e414a20040	t	f	2022-02-09 00:00:00	\N	0f604f34-370f-4593-8173-cd24234cff78	ab740e36-07ac-471c-8a8d-42b004bf2264
e200fa65-db48-43ce-b222-c495ca26c50a	t	f	2022-02-09 00:00:00	\N	0f604f34-370f-4593-8173-cd24234cff78	18f9b3d2-e879-4158-8c00-389eae8ef91d
ca9bfcae-501f-41c2-a608-77313889bead	t	f	2022-02-09 00:00:00	\N	0f604f34-370f-4593-8173-cd24234cff78	f5e10ce9-2d10-4d8e-8dcf-a96768fa99ea
98cb8454-8dd6-4328-b3a5-1dbc6db77996	t	f	2022-02-09 00:00:00	\N	0f604f34-370f-4593-8173-cd24234cff78	d734e36d-7232-448e-91c5-55fad3c1eee4
54ca306e-be69-4a9e-9d69-623c89f879bd	t	f	2022-02-09 00:00:00	\N	0f604f34-370f-4593-8173-cd24234cff78	9a3ee8f2-8195-4557-8648-26f45f3bb029
21e8d66c-a4d3-4e93-82ab-ca7bdae4a504	t	f	2022-02-09 00:00:00	\N	83a5507a-c2fc-4171-8af4-fb4d8d45c889	3e91824b-6148-4d3d-b1f8-d0cd67755424
f4df18a7-2195-44d2-b5a5-2db618b3bff3	t	f	2022-02-09 00:00:00	\N	83a5507a-c2fc-4171-8af4-fb4d8d45c889	cc500728-7e8e-4266-a2ea-3b21f26a314a
403bede8-313f-4cbf-9a91-cdf72ebda012	t	f	2022-02-09 00:00:00	\N	83a5507a-c2fc-4171-8af4-fb4d8d45c889	387da566-0489-4a69-afad-5e392ace964c
316f6891-d980-4086-a89e-66f3c36edc25	t	f	2022-02-09 00:00:00	\N	f72ef658-2832-4835-af07-de91109d4f7f	07452f3c-4607-4430-8c49-2956b2e94176
9482fb14-bb6e-49b3-b735-0080325629f3	t	f	2022-02-10 00:00:00	\N	b0574726-8fed-4a1f-aac3-09f61225548d	54362deb-2aa4-495b-927f-1dd37caf0560
234dc711-0bb8-4f7e-a231-45372ecd4537	t	f	2022-02-10 00:00:00	\N	b0574726-8fed-4a1f-aac3-09f61225548d	5412961e-cf30-44ea-b9a0-7679e5306204
47eda5df-9fdc-4d7a-a860-2863ead4856a	t	f	2022-02-10 00:00:00	\N	b0574726-8fed-4a1f-aac3-09f61225548d	1a5f4d6f-76de-42e3-9ad5-0356eee2509c
b7a3865f-8bfe-4acc-b24d-9c9bdd110cbf	t	f	2022-02-11 00:00:00	\N	4a94dfe1-edf1-4421-93e1-e53183ed3dbc	d864ce4e-2ee9-4185-80a2-f664d3cc5654
d2704b12-ba37-412b-98a8-ac82c19c2cc0	t	f	2022-02-11 00:00:00	\N	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	5d3667e0-681a-4040-b96e-7de551c5c3f4
3dbe75a9-b938-4fc3-a429-0f492f6f08f1	t	f	2022-02-11 00:00:00	\N	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	9fd52c08-46a8-4c08-a6e7-4ee7f4995d9d
c7ac80ba-1ac4-41ea-8384-f20bd920c911	t	f	2022-02-11 00:00:00	\N	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	0adbd46d-ce5d-4575-9c3b-1d20aab14b6d
85107ceb-456c-44e3-8a83-386202cf4347	t	f	2022-02-11 00:00:00	\N	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	55debbc1-6e33-4b45-ac93-961f5ce31f33
cf715378-a833-43eb-aa78-b32992b4cb11	t	f	2022-02-11 00:00:00	\N	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f1f88d14-f3d3-4419-800c-c6bb144fd1fb
861d50fd-f99a-4496-bfcd-8bc43429d67c	t	f	2022-02-11 00:00:00	\N	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	fcd78ddb-4d5d-4fad-9442-32f1f501aca2
994258bc-b95d-4876-93c6-7f64f9db7e9b	t	f	2022-02-11 00:00:00	\N	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	122aa0eb-e096-45da-b679-cafebbcd1048
1fc90bb5-f3bc-4b64-b519-b6338495bddd	t	f	2022-02-12 00:00:00	\N	2fc3365b-34d9-4054-b2d8-aa859c7455e7	6a3387a9-4f35-4c62-989e-077b9e1366ef
571848af-348b-4c41-be80-d4fc6ee7322e	t	f	2022-02-12 00:00:00	\N	2fc3365b-34d9-4054-b2d8-aa859c7455e7	edd3f015-0bb7-45fe-bccf-a0f63fb97557
1ec78f9f-e642-4807-aeed-cf03352068c5	t	f	2022-02-12 00:00:00	\N	a0ea91c8-f018-424b-ac69-1246f657d591	2444be84-b6d3-4cab-bfbb-3b95432db6a0
57afda38-ce4a-44e5-aed1-8e125afac642	t	f	2022-02-12 00:00:00	\N	1ef47e57-2af3-4027-8cd6-427f30a63792	02d213b3-1193-4b02-8a95-4ff0f602ff2e
61c3fc5d-e131-430e-86ef-168826be20b9	t	f	2022-02-12 00:00:00	\N	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	57617f49-78df-46d7-bdd8-a9524b4cbe81
4b06786d-a900-41dd-aab6-f66884607aef	t	f	2022-02-12 00:00:00	\N	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	1ebef21a-14dd-4b2d-969a-e8e2804fb8d1
f4f338e5-7193-4868-b5a6-f719bd671f32	t	f	2022-02-12 00:00:00	\N	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	2860c43b-b4f9-4c1f-88ab-584f78c212a1
ac736a64-dc11-4763-b53a-cfe1ea7c6546	t	f	2022-02-12 00:00:00	\N	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	23c00e1a-a9da-4f1e-a143-949e85b7a153
86d589ad-4383-4f7a-ad9f-50bf1118cf48	t	f	2022-02-13 00:00:00	\N	e7e33831-c7ee-4aca-97b1-d2c32b102d58	ee1447cd-39fc-4d59-bd89-ac82e9f781dd
cbe7672b-d4ac-412d-a584-f5f4372fe744	t	f	2022-02-13 00:00:00	\N	4c850776-1fc1-4201-9490-c1e848cd0f00	0eb8b85b-e34e-40a5-a5f8-5eec70082ab5
01964cce-b26a-43b8-9f32-eb667b6f65ba	t	f	2022-02-13 00:00:00	\N	4c850776-1fc1-4201-9490-c1e848cd0f00	7f9a3ac4-e86b-4d51-bd2e-2a09ad93fe8a
161a2d6b-6b3d-4c14-bbdb-5c8fa07fa1f2	t	f	2022-02-13 00:00:00	\N	4c850776-1fc1-4201-9490-c1e848cd0f00	0619ee4d-c9e3-484d-9bf0-949c6a02a2f2
6913fe9f-674c-4118-9d76-df576c06abfe	t	f	2022-02-13 00:00:00	\N	4c850776-1fc1-4201-9490-c1e848cd0f00	01a7df2f-6a9e-41db-a75e-71f30171f44b
4426d626-388d-4b9a-b0dc-c362d30fda6d	t	f	2022-02-13 00:00:00	\N	4c850776-1fc1-4201-9490-c1e848cd0f00	5c5f951c-ba41-40f2-893c-18f00900313a
5b96b0eb-7013-4b1c-9525-18dab3af893a	t	f	2022-02-13 00:00:00	\N	4c850776-1fc1-4201-9490-c1e848cd0f00	d426b797-6389-4b27-a696-69e1a231abb3
beaa63fd-b5ec-4801-b79d-a7eb9ce5aab4	t	f	2022-02-13 00:00:00	\N	a0ea91c8-f018-424b-ac69-1246f657d591	5f443dae-ef08-40fc-ba1c-46a4ebd4951d
cff6ca6a-7dee-41b4-bd72-ac3534c8aa26	t	f	2022-02-13 00:00:00	\N	a0ea91c8-f018-424b-ac69-1246f657d591	2aa32e66-2896-465a-9e71-df92dbcbca3e
902335c6-cea7-4f06-b8a5-070e519ef34e	t	f	2022-02-13 00:00:00	\N	a0ea91c8-f018-424b-ac69-1246f657d591	226281fb-6ea8-4920-a507-93f7370bfe50
f2cadb4f-8b47-48be-8854-cc9af9f596b8	t	f	2022-02-14 00:00:00	\N	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	cf04baca-a6ab-4fa6-93fe-c8037aed6416
6cde9caa-122e-4f73-aa3d-9e3668a17ab2	t	f	2022-02-14 00:00:00	\N	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	a0b2aeeb-9488-48c9-8763-5879c9852478
8a0a9175-a2bf-4e0a-b1d2-1ddc537de0aa	t	f	2022-02-14 00:00:00	\N	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	9eae4f57-ddac-436e-8c44-0861545cefe5
c4d41587-9eaa-42fd-99f4-0bf2dc85866d	t	f	2022-02-14 00:00:00	\N	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	fb74aa81-9b33-44c6-a77f-c961179f8814
77fee69c-6002-4d37-baf7-b7bea62f96bc	t	f	2022-02-14 00:00:00	\N	42933e50-7306-4a54-b42a-276813e8b03a	6ea71f63-2e65-4d5e-8ea2-cda595777d49
2f40997b-527f-4536-9754-bf84b2f536c2	t	f	2022-02-14 00:00:00	\N	465cb8a9-3909-4d55-beab-ca76d490081e	bdc171c6-e2e9-438c-8b12-b2259917ee25
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person (id, aktiv, deleted, change_date, deletion_date, benutzername, name, vorname, handy, email, password, wertungsrichter_id) FROM stdin;
ff5b4a49-aa15-4577-a8a6-075deb215f71	t	f	2022-01-09 00:00:00	\N	getu-wettkaempfe-ti@ztv.ch	Spitznagel/Althaus	Karin/Sandy		getu-wettkaempfe-ti@ztv.ch	{bcrypt}$2a$10$MN9xjKcyRnpWIzEJ7cccsuU39s2CWUCZuVcEHGoXYo7AddbrUEGWi	\N
e8992741-c560-4920-bc6b-f09b14a5c5fd	t	f	2022-01-09 00:00:00	\N	getu-wettkaempfe-tu@ztv.ch	Lätsch	Heinz	076 336 30 31	getu-wettkaempfe-tu@ztv.ch	{bcrypt}$2a$10$.6H9BtYvRPTaLBSK8hNQUuaIFPfK.fEI8RymXvWROOsJ9QWruGy46	\N
6c8b444d-d52e-4837-b1b6-466771cddb5d	t	f	2022-01-10 00:00:00	\N	heinz.laetsch@gmx.ch	Lätsch	Heinz	076 336 30 31	heinz.laetsch@gmx.ch	{bcrypt}$2a$10$HhXZcpk9EfmpJDrOWWjyw.n49yYOSi7t8uDVEE34JoGrUZIK3Y/Ni	\N
345ef8eb-5e36-49fa-adbf-9a6be345f123	t	f	2022-01-23 00:00:00	\N	r.odi@hispeed.ch	Odermatt	Roland	076 803 22 92	r.odi@hispeed.ch	{bcrypt}$2a$10$OnMehIcOWUK9exkdlogGfeZCmlItWSpadUIRHmImPC6Unfurdds0m	\N
e8bb3a4e-ff5b-4d60-8e37-f2358c646077	t	f	2022-01-11 00:00:00	\N	alinekaufmann@bluewin.ch	Kaufmann	Aline	079 259 49 69	alinekaufmann@bluewin.ch	{bcrypt}$2a$10$H.u2ZQUR7CKq/3M0i/4x9ukg4O4XYvtuLw22XNM7.Vlhf3rviVNGK	6a8f3370-50b4-481e-9463-9703e20fed7b
faf769a3-47fa-4c20-b65c-24ddff3abd01	t	f	2022-01-11 00:00:00	\N	waelti.a@gmail.com	Wälti	Alexandra	079 245 08 07	waelti.a@gmail.com	{bcrypt}$2a$10$JHdUWZRRAD9n4C2f54cxEOdtuo05l9nTzcOTd7yo9PzfjX2cxyjH2	53f7163c-87a5-470d-9c0e-bcd19ddfe0c1
413f0fe6-ffc8-49c5-ae71-1ff527b8930b	t	f	2022-01-11 00:00:00	\N	janinesp@windowslive.com	Sprecher	Janine	079 394 15 28	janinesp@windowslive.com	{bcrypt}$2a$10$Vo0DpIrlUkUIfqEG0ZJB/.Ff0VYVD82iYOV.ia1JH8RHS6P3ApMKO	a75781e7-5f8c-4dac-a631-b60a276c4b30
e201e5ef-cac2-465f-9956-4abecdbd08c8	t	f	2022-01-11 00:00:00	\N	philipp.wueest@gmail.com	Wüest	Philipp	079 383 45 89	philipp.wueest@gmail.com	{bcrypt}$2a$10$tUawN0P8QvydDHyw3LDsrOSdee3fJWYujyQsdr8GOl1EZ590wN3fG	1afa03ce-cd61-434a-8bdc-e0ae8350fd52
6b5ccf49-c989-4973-8237-95717f010161	t	f	2022-01-11 00:00:00	\N	jeanine.wueest@gmail.com	Buchmann	Jeanine	079 448 35 62	jeanine.wueest@gmail.com	{bcrypt}$2a$10$FDVC66w7FfKx5bex.EGohOd2PSJjPV7BWMqrWNQ09n0.uIRe7P5RO	4d97ad26-a09c-4be8-a5f1-b9c33ec5730d
de6d4c3d-283c-478c-87fa-278cac6f692a	t	f	2022-01-11 00:00:00	\N	kelli@gmx.ch	Keller	Livia	077 458 31 51	kelli@gmx.ch	{bcrypt}$2a$10$brW/bOwojiUc873tEUARQO4t9Ew5akbNAIxU2D4ebL0HBKnYl2MRW	9893bbc2-4128-4457-b86f-a194f887ba74
f255be7f-d6da-42f8-97b0-80aefbbfd52d	t	f	2022-01-11 00:00:00	\N	dosch_94@bluewin.ch	Schläpfer	Dominik	079 934 47 21	dosch_94@bluewin.ch	{bcrypt}$2a$10$JMfedsaDoSc4GKz9KTS0Cu5oeUIV92c9soNoWoEDqIcy4L8CMCyua	1a6db83c-66bb-4208-aacb-c2b159672696
f575215f-4eab-4db9-993c-f0a89d64746f	t	f	2022-01-11 00:00:00	\N	sabrina-schoch@hotmail.com	Schoch	Sabrina	079 908 83 33	sabrina-schoch@hotmail.com	{bcrypt}$2a$10$1KtkzuhA2yviyFhtt1unpO9lXWNqC3HFMeC.D7MkRyGDWn3/FhfrC	e3b14d22-0947-4272-8977-55748ce10ddd
fcbe03a8-fe1c-4a28-892b-9e09eda4820b	t	f	2022-01-11 00:00:00	\N	sandra11schoch@hotmail.com	Schoch	Sandra	079 385 54 11	sandra11schoch@hotmail.com	{bcrypt}$2a$10$f4dEG1/IDnd3YRPNbirJUehQXTsz9Wim2Ed8Qie/jIQsj2OLbqGEa	d4c1cf45-237c-4e0d-90da-3fcb39b92f1f
6b94806e-bc8f-4ea0-99b9-5397759bc338	t	f	2022-01-11 00:00:00	\N	sarahbrossi@gmail.com	Brossi	Sarah	079 233 59 89	sarahbrossi@gmail.com	{bcrypt}$2a$10$JHDCevALNwpesJ017TLYT.cdUmEhOS7xZ5GdyTu5lRVVo4O7TZSM6	c191f0ca-99b0-4e39-954b-6e65d37914ac
9578f329-e7f1-4839-a676-b5586136a56d	t	f	2022-01-11 00:00:00	\N	widmertanja@bluewin.ch	Widmer	Tanja	079 781 29 97	widmertanja@bluewin.ch	{bcrypt}$2a$10$bW1al4JivW3fkiQulsqzWerIobDgV9K269KvlVSl1thgPLT1wJdJe	1a6a14f4-a23d-419a-95d8-d2ba29028a46
c23e3b72-abf0-476c-8c06-98f79cb9e79c	t	f	2022-01-11 00:00:00	\N	vanessaegli02@gmail.com	Egli	Vanessa	079 843 58 90	vanessaegli02@gmail.com	{bcrypt}$2a$10$hzWmrvhR2Fe9s8hZvEhSkuEXuiuFVoKR5m9evabD47SVbflVZH0zq	ea05343f-396a-42b4-9373-eca96e972348
86b3a1de-3668-4dcc-97ac-8cc6d2d599d6	t	f	2022-01-11 00:00:00	\N	naomi.zarth.ch@gmail.com	Zarth	Naomi	076 576 85 94	naomi.zarth.ch@gmail.com	{bcrypt}$2a$10$1kjPYnD1RSuXKu5HpYRnC.QBHxivZV/3zsP/JLaCu5Ea1ZxS1AuYq	5792036b-728d-42fe-affd-11c2adbc4ad3
9b6422ac-fd26-44e4-a0a7-6ea980ddf8ef	t	f	2022-01-11 00:00:00	\N	alice-mueller@bluewin.ch	Müller	Alice	079 675 40 76	alice-mueller@bluewin.ch	{bcrypt}$2a$10$ZGgFtx7O/zotNTSOUXuwVukJW/.mVCuwEx8BFOB0cm.3vFjPXlYH.	d22267ed-6bae-41ac-bb2a-ac4c7cb8aac6
438b959b-3e2d-4a8f-acdb-c208c2ef7c77	t	f	2022-01-11 00:00:00	\N	rugeli@rugeli.ch	Hunn	Irene	077 777 77 77	rugeli@rugeli.ch	{bcrypt}$2a$10$.vFq8HmRU0JGPFIncRji1.MNbLDS69eD6zPTFL.64WsAlb/m2o1em	\N
0f817251-d3f2-4616-8ae7-5c6a1c67eb0e	t	f	2022-01-29 00:00:00	\N	simi.wylenmann@hotmail.com	Wylenmann	Simon	079 358 73 92	simi.wylenmann@hotmail.com	{bcrypt}$2a$10$GrifqN9NTr2zJb84K8mPvOClC1GlDzvhljQ52CXIF.FD7HTD0j0ba	193e5009-17be-4710-83d6-c2c729a51e74
f262a7de-3583-4ea0-b3f8-9003b8e0ee88	t	f	2022-01-12 00:00:00	\N	karin.lanz@algartenbau.ch	Lanz	Karin	079 399 88 54	karin.lanz@algartenbau.ch	{bcrypt}$2a$10$e4IglP0cR/co/zdZdHEG8uNOfd2OgjdrzOCI37kMFn5bIcAYE/I.O	335a94c8-2ead-4d79-bde2-460e335ee044
36a9a36f-0208-42ae-b879-eea8ae96d828	t	f	2022-01-13 00:00:00	\N	b.schnorf@gmail.com	Schnorf	Bettina	077 403 12 45	b.schnorf@gmail.com	{bcrypt}$2a$10$xNvrJt4fBjxhIOP/UcIS7OCXASSkE8ZPPVnr8w./pBv49j8PsiXzS	492130f4-2420-497f-9224-9f4af4f08b27
5d5d4b80-7009-4b03-950a-be4e5e97ac7c	t	f	2022-01-14 00:00:00	\N	nicolegrau@bluewin.ch	Grau	Nicole	079 376 16 61	nicolegrau@bluewin.ch	{bcrypt}$2a$10$o7JZG/G2ZUuNV3l.JWnphujGD44Kfr1a6RZwBRrBoK7Ww.fJ9chbq	55ea0286-12cb-4e01-9d80-18977c599fa6
fa0e3750-34e6-493d-b3fc-d93b7506ab14	t	f	2022-01-14 00:00:00	\N	fritschi.reto@bluewin.ch	Fritschi	Reto	077 421 88 77	fritschi.reto@bluewin.ch	{bcrypt}$2a$10$OE5sSWAPZlGyP3A7rh4LVeGFS8TzxkHURaUdO5qgyvh8iEn3yZOJ2	24a295bd-d27e-418b-8e76-e2383d65b70d
3f855bcc-e320-4346-b97b-ab7c74bb9e35	t	f	2022-01-14 00:00:00	\N	marti_andreas@hotmail.com	Marti	Andreas	076 446 18 67	marti_andreas@hotmail.com	{bcrypt}$2a$10$jNIuGC.21ZfyzCC722H1ZOZMXukMQQqUf7eWF1A2XqQ01mIHd9xx2	c3b31c6a-fda8-41e1-9136-499c97c526ae
f05edd05-f39e-480d-b1dc-c07df0b5639e	t	f	2022-01-14 00:00:00	\N	nathalie_zatti@gmx.ch	Marti	Nathalie	079 734 42 84	nathalie_zatti@gmx.ch	{bcrypt}$2a$10$bLmTwDnIekcT4wi3JO6GHekNM7cKF0zVhR39OVS0arh3TegsKIsU2	58d5aaf6-7074-4d36-9c9e-5b62cb99164f
474b3b8c-3108-48a6-bc8f-da6ad98a062d	t	f	2022-01-14 00:00:00	\N	andrea-muellergraf@sunrise.ch	Müller	Andrea	078 880 06 40	andrea-muellergraf@sunrise.ch	{bcrypt}$2a$10$4Bg12WLo37VJgnzeLE7iAOvtruznqdf/w1cHzn.iOLLdPPki8mgLi	e225f2f3-eef9-4510-8fbf-6349bf41551d
41caa163-7800-48d8-b8a5-30bedc6d861d	t	f	2022-01-13 00:00:00	\N	fisjas@bluewin.ch	Fischbacher	Jasmin	079 291 73 99	fisjas@bluewin.ch	{bcrypt}$2a$10$AFt5WDasBeS4UGduyqxQseHAMgjSsnUuodU43x1B.J./bNCyauB2S	f19dd761-47c2-4f4b-a256-c86707b8371f
a6c1e6df-5338-4dc4-b661-f6875b327517	t	f	2022-01-11 00:00:00	\N	balmer.marcel@gmx.ch	Balmer	Marcel	078 779 03 34	balmer.marcel@gmx.ch	{bcrypt}$2a$10$Fx3Lrlq7dXkXSxdvQlDRbueThfYJfplZ0SUa2yh3z.uW6TrdUoWDC	\N
4cbc430f-44fe-4482-8298-e8f859552e29	t	f	2022-01-12 00:00:00	\N	m.haeberling@tvobfelden.ch	Häberling	Martin	079 731 52 66	m.haeberling@tvobfelden.ch	{bcrypt}$2a$10$5P15seAI296ekdybf08FEOO5WEiy5kT26eO2JNFtIZsYbrrgFpIau	\N
ef8e38e0-7caf-4e07-87f6-8a70b77c1ff1	t	f	2022-01-12 00:00:00	\N	michi_164@hotmail.com	Rüegg	Michael	079 507 41 65	michi_164@hotmail.com	{bcrypt}$2a$10$vN9XgGr0TgARTP.0256vOe6/jyutvoNFEHL0dDBw1QT69f6fatiNG	\N
affa65ea-3dea-4ca9-ab99-78a5e47258fc	t	f	2022-01-13 00:00:00	\N	m.itten@gmx.ch	Itten	Marco	078 814 67 15	m.itten@gmx.ch	{bcrypt}$2a$10$hVfgs4m.PR39YiNDkskPwuH41PvmhsW0CXp9GDwHSE94FRzBdTewC	\N
98446f19-e0a5-4c96-853c-2c0b6751a9d2	t	f	2022-01-13 00:00:00	\N	tobii.suter@hotmail.ch	Suter	Tobias	076 570 75 88	tobii.suter@hotmail.ch	{bcrypt}$2a$10$sTNWjYhDce0CHachuhPjRu0hJ/C1EU3.YCAyqXA//7fi5xtr0VZs2	d9c29426-2d8b-4f66-aa06-543b9cc028cb
6b597911-6386-4da6-a771-d1ae47749e44	t	f	2022-01-14 00:00:00	\N	cornelia.wigger@gmx.net	Schmidt	Cornelia	078 606 94 86	cornelia.wigger@gmx.net	{bcrypt}$2a$10$cAEc2sljwMR/wMKT5JGsve5p7J3qbpFE7/G4GO8QVRAmy78kr2qXa	ace97f48-aae1-4bf6-b31e-078812da26ca
f06eddd1-2f48-49c2-b3f8-0671ae727d1a	t	f	2022-01-14 00:00:00	\N	silja.mohler@gmail.com	Mohler	Silja	078 656 05 88	silja.mohler@gmail.com	{bcrypt}$2a$10$tnOwAkzuGx6hNQ1utW26wO4OGEehLqsAjcohh.5wQM8l.R7sc5BC6	56e7d9ab-ef0c-4b2e-ad5c-60d6824a4f3d
d1e393de-3fc5-4a5f-9684-10b3f5c4dc38	t	f	2022-01-14 00:00:00	\N	alessia.romanelli@sunrise.ch	Romanelli	Alessia	076 434 97 97	alessia.romanelli@sunrise.ch	{bcrypt}$2a$10$PMuntEg2O4KplRM7gSq5V.FGopxry2HGi/e8i4AODAAYlLDcRL.YC	bbcd92f1-cd28-4f5f-b0b2-c84295f82f79
35e7e6fe-5d65-4d2c-aa85-f4a127c8a74a	t	f	2022-01-14 00:00:00	\N	alessia.schlatter@hotmail.com	Schlatter	Alessia	079 812 25 30	alessia.schlatter@hotmail.com	{bcrypt}$2a$10$.I.Rklx/XMlLcBMzBgW0iu1Kxxe0jfEKAca2jAh.39qCR.JXaYfyW	752bf431-a64e-431c-85d4-9eb37002907f
df60d1e1-188c-4599-b481-f883bf6e43c9	t	f	2022-01-14 00:00:00	\N	serainamueller29@gmail.com	Müller	Seraina	078 966 29 20	serainamueller29@gmail.com	{bcrypt}$2a$10$x4HNSlpqXPOsnZHhzDmeVuRA6AtMuczuIKpGkS1Eeto/vhxQSXhZm	44c9b438-15fb-4a4c-8f97-bb7fec08e0ea
b50a9187-40f3-495b-904b-9ac1b0ecddf1	t	f	2022-01-14 00:00:00	\N	hodelwilli@gmail.com	Hodel	Willi	079 639 99 92	hodelwilli@gmail.com	{bcrypt}$2a$10$TKZbgtPBJb3nTvQla1V8uubNEr2R21X4iOhophvh2wziLE2Eazv86	9728b74c-5006-40b5-93b0-10f39694dbdc
bcf7557d-05e9-4eca-9b8f-f2293b122e6f	t	f	2022-01-14 00:00:00	\N	adrian.laetsch@gmx.ch	Lätsch	Adrian	076 465 14 02	adrian.laetsch@gmx.ch	{bcrypt}$2a$10$j6ZHGsg07A3kLmzTH2DfEuqCT28HI0H2q8iIxCi/Nc3JNGrWk328S	9383b3fc-2de7-45b7-8798-f0fc13509057
d3616962-6b9d-44c8-be54-1d321ea5e511	t	f	2022-01-14 00:00:00	\N	esther.zoller@gmail.com	Zoller	Esther	077 401 67 86	esther.zoller@gmail.com	{bcrypt}$2a$10$Ozj.au5bqY/.NfzMc2xKP.qcPVZErNJ/vw1gmR5YbomI.8rger6nm	41a2f45c-4b4a-4e59-8b86-f85a22cd90d7
ccb1b8b9-7393-41ac-81a4-91aee3517aef	t	f	2022-01-16 00:00:00	\N	ladina-schlumpf@bluewin.ch	Schlumpf	Ladina	077 470 12 81	ladina-schlumpf@bluewin.ch	{bcrypt}$2a$10$sn1lctwlC1EVtf9VviTiDuxYzdpFIb9L/VmMmzgZDDAasWZ2To3Yq	3e7d3ea7-6014-4e50-b22e-3e859147a8ee
f7aa7d0a-58c8-4781-b8bd-0af1bf4615bd	t	f	2022-01-18 00:00:00	\N	loredana.divito@gmx.ch	Di Vito	Loredana	078 899 69 35	loredana.divito@gmx.ch	{bcrypt}$2a$10$6v4MnmiDy7bQU41ngbpfZ.KuCH3PumAzMB53OA6oXT6W1CS2jyIQK	\N
d48a2241-8a41-403a-989c-d408bdbed5e4	t	f	2022-01-17 00:00:00	\N	beilstein@bluewin.ch	Beilstein	Marcel	079 771 55 70	beilstein@bluewin.ch	{bcrypt}$2a$10$8f7SRiKHsop8TTfJQyRhaOX9kBXRSfE9GX8VFBB53XgsBiQVAk6cC	1282d53b-1b73-4129-a7b0-4b899ffb77df
42b40986-b948-471f-9844-be6cd45e64e7	t	f	2022-01-30 00:00:00	\N	martina.gut@bluewin.ch	Gut	Martina	079 338 58 71	martina.gut@bluewin.ch	{bcrypt}$2a$10$jDifVrH9mXoEj0822bsvNuec7tev2bGETb2PMd/7X.mLQYYwgZL/G	\N
1c65ffb5-f1ce-4979-a2ce-bb0ac54f6ffc	t	f	2022-01-17 00:00:00	\N	alexa.blaser@hispeed.ch	Blaser	Alexa	079 849 05 09	alexa.blaser@hispeed.ch	{bcrypt}$2a$10$2Yj7oXmCi8lxM.8QF6lbFe/Xwsqc2pEm6.AZ3E000rHAYjTvcLCXG	808eb6bd-7acf-47e3-a420-6bf5c2b42811
d716fa96-59e6-46c7-90a1-32583e8a4253	t	f	2022-01-17 00:00:00	\N	daniel.blaser@hispeed.ch	Blaser	Daniel	079 238 38 68	daniel.blaser@hispeed.ch	{bcrypt}$2a$10$ro6hMzkqIkuKsEvgXOXA7OCk1Ui/NAyMfj1SZzvP24upHmvcItOii	03cf3b2b-c8e6-453b-93aa-94c033de0a56
c1ff2734-9478-4747-aa67-d84cf087868e	t	f	2022-01-17 00:00:00	\N	katja.berger@bluewin.ch	Berger	Katja	079 827 75 80	katja.berger@bluewin.ch	{bcrypt}$2a$10$8wWDW0N8nEfjEd/o5z2NL.PcPbDxN28FezW3x4p33aQ4zGaC/vox6	7f72cfc5-9d91-4f88-97a1-ab0ed4165b40
9926f56b-418a-4484-8b06-83d8b7dcec50	t	f	2022-01-17 00:00:00	\N	nicole.rebsamen@outlook.com	Rebsamen	Nicole	079 544 57 22	nicole.rebsamen@outlook.com	{bcrypt}$2a$10$9N72J..3LuKP6fCKd5PX9.2gHn9wIzXzsxHZ0w1CDSAdhg3f4U11y	5ba3ea8a-76c9-444e-8474-8bb27f40e9af
8fbdbec6-80f0-47a5-94d5-5d02fda96258	t	f	2022-01-17 00:00:00	\N	anja_bachmann@hispeed.ch	Bachmann	Anja	076 417 41 47	anja_bachmann@hispeed.ch	{bcrypt}$2a$10$hk0lyao1rEpuhXLLCe3fW.UdbkTdWBV2dLOhhKoV.59KjPp3gqAH6	bceab38f-9182-4b20-ba6d-0d84fbeca8ca
4df08a37-ae33-4c42-aee0-5b8f6a483166	t	f	2022-01-17 00:00:00	\N	jana@missfelder.ch	Missfelder	Jana	076 348 89 48	jana@missfelder.ch	{bcrypt}$2a$10$GoDVapsyZbq1O0v/Jh4CnOyoUL3pos1/2p7jzk.mGAUvFqBPuBeku	\N
4ec3c51c-93cf-43cc-9c48-8d588c04211d	t	f	2022-01-17 00:00:00	\N	daniel.gugerli@bluewin.ch	Gugerli	Daniel	079 635 85 52	daniel.gugerli@bluewin.ch	{bcrypt}$2a$10$7MRO/x4qbbJF.REYdQCn../U1lUtgFciJDkDXa5CCCTJOjJQ3pF/6	73115c9e-5e76-4f17-9103-cf4bf8b08714
611a1bed-57b2-4f8e-b0c0-9c7ce15d8719	t	f	2022-01-17 00:00:00	\N	sarahofstetter97@gmail.com	Hofstetter	Sara	076 332 19 97	sarahofstetter97@gmail.com	{bcrypt}$2a$10$ounUIQ6tRh8KFxKZIYyRiON.JPMcyG7r4Aa75H3NB5O4.9yZaF90C	d7ad36b8-61e3-4791-9d31-5ecfcb7e0a03
af4c71b9-b08d-4099-9fb1-7cf9f23c1786	t	f	2022-01-17 00:00:00	\N	patrik.wue@bluewin.ch	Wüthrich	Patrik	079 378 31 63	patrik.wue@bluewin.ch	{bcrypt}$2a$10$1bLazgYJ6CiNQHdP1g/xgeLw6Xdkt8vGx/F.ZWqOguHY4MW7dpMhm	f27c009b-aeb2-4060-b219-ee74a3ec5b5f
85679d14-b276-4d13-b9a5-1e9e88d4c76e	t	f	2022-01-17 00:00:00	\N	c.kaeser@bluewin.ch	Käser	Christian	079 420 13 34	c.kaeser@bluewin.ch	{bcrypt}$2a$10$klqpO9gdqbMCbJBiXNqB6ujzcvbWaoYWTobR30ybV.CJhqy5RUex.	90fac6ee-9e8c-45a2-84bf-a8289e51ed61
19f95456-20f4-41ac-8d1d-c047fddcd9c6	t	f	2022-01-17 00:00:00	\N	dubsanita@gmail.com	Dubs	Anita	079 737 16 59	dubsanita@gmail.com	{bcrypt}$2a$10$sJd9fFQK4pPzcYJ1n8MTH.1DlYhKl71lCRm7Yq9YQYr.ikiHz6h7.	fe431c00-a034-4ea8-a738-5bc416698394
c471fd65-a76b-4110-bc26-313e58c98491	t	f	2022-01-17 00:00:00	\N	isabel.hirzel@gmx.ch	Hirzel	Isabel	079 521 86 12	isabel.hirzel@gmx.ch	{bcrypt}$2a$10$H1M3cIX/ONWJav/HI04yfODeQ7iJRoOTZVHL.TwucIM2XtUeX/ygG	6c3bf3f7-ec9c-4c38-a408-d6de8a3f666e
be60e1fb-63e3-480e-9209-33d106a95c44	t	f	2022-01-17 00:00:00	\N	alexandra.home@bluewin.ch	Bucher	Alexandra	079 204 13 87	alexandra.home@bluewin.ch	{bcrypt}$2a$10$j8jiplwgu9.ugmdjQ/.Cd.N/1edqjVmiA/xlBAzXhwvOLxLUMUpVq	106be793-ec83-4a5a-b7c6-f457fd98d94c
3f161f1d-4285-4694-aa13-842425295826	t	f	2022-01-17 00:00:00	\N	getu@tvaltstetten.ch	Gassmann	Sibylle	079 710 10 02	getu@tvaltstetten.ch	{bcrypt}$2a$10$6fAP.HLhQgqZ0uooNaLZL.0NgwB7DSLY/2J140faNkJizISU5h5Py	a856e562-9df5-4885-a6fa-a91f8da24394
4b3d79b0-79a5-4d52-9c25-36e7455097e1	t	f	2022-01-17 00:00:00	\N	laura.agazzi@gmx.ch	Agazzi	Laura	079 769 37 61	laura.agazzi@gmx.ch	{bcrypt}$2a$10$xFJ.D4r1Y4lEE75nvIhhoePlxZxmO96sWUG02NniUCqtgBysPEQ1a	54df2396-e9bb-458a-ae79-dfd9e2e489f2
8f9b9fca-0606-4944-a414-3d56b4d43ed6	t	f	2022-01-17 00:00:00	\N	yvonne.bergmaier@tvaltstetten.ch	Bergmaier	Yvonne	079 346 15 12	yvonne.bergmaier@tvaltstetten.ch	{bcrypt}$2a$10$G2xpWTH4DAlnqMMQYLMDV.BEx6LdMlIs12fv8YphU4Dy5qgRTfJLS	763783ae-8ace-40b9-9714-31b2b89a1c3e
5eb2361a-e95f-49ab-8d15-b77d00fc7e1a	t	f	2022-01-17 00:00:00	\N	ramona_blum@hotmail.com	Blum	Ramona	079 268 62 88	ramona_blum@hotmail.com	{bcrypt}$2a$10$o38Q2t89sqix7U5/iAJyAOlr1MBy2HVSMgcmgq1bIuM.jyqKstL86	782b7207-e567-452c-9222-003e04a9a305
24f02407-5cf2-4384-8ea3-ec5292ce4a72	t	f	2022-01-18 00:00:00	\N	kohlermelanie@icloud.com	Kohler	Mélanie	078 670 64 96	kohlermelanie@icloud.com	{bcrypt}$2a$10$KH1cNGA7ozMWSd4t9XPBRu56rKp7BoaFr.lPfwSXtcg9sB92XAls6	fb731015-616e-413e-99a5-dcd58baaed6c
70870a17-d0c2-45be-ab72-3a819b3c7673	t	f	2022-01-18 00:00:00	\N	leandro.gschwend@gmail.com	Gschwend	Leandro	076 534 81 88	leandro.gschwend@gmail.com	{bcrypt}$2a$10$l9xv5WtsdTCTuiw972T84.qm2gqVMUWzpTavGs583iE1q6ERIMGLm	0d87abbb-f023-46aa-b54c-0cc9a29b6bab
c403ff2f-1f49-49f8-87b9-2563f163a437	t	f	2022-01-18 00:00:00	\N	molin.virginia@gmail.com	Molin	Virginia	078 821 15 53	molin.virginia@gmail.com	{bcrypt}$2a$10$cqWjWY0FS3Fk38z/9KR0vOcRb6hVDUdmCZWO15eS.vYqocq3W9LkS	0316605b-ab44-49f8-8f4b-852396cf79c0
06e1270e-8eda-4790-a920-7a4089869c7d	t	f	2022-01-18 00:00:00	\N	winkler.lia@gmail.com	Winkler	Lia	076 514 69 80	winkler.lia@gmail.com	{bcrypt}$2a$10$TNBBdOjMGRreGZEhUwOQf.OeAaE9yfloxCS/LvG6Ki8Cozf8P.8uC	c0c86210-ac0c-49d3-a972-014220541613
0aa96d4f-62c3-47e3-8b8f-94809f66f05a	t	f	2022-01-23 00:00:00	\N	f.odi@hispeed.ch	Odermatt-Paratte	Fabienne	079 340 30 03	f.odi@hispeed.ch	{bcrypt}$2a$10$VAxqvxmvDIfnmTtOr0MKWOFQ5WJYYuers23wS/u7sgZ3suCxg5Nu6	6a117951-ca80-44d0-b363-83982679e70b
17ed84be-4dcd-4fab-baf8-40c3c422dcc0	t	f	2022-01-23 00:00:00	\N	cschnorf@hotmail.com	Schnorf	Carmen	079 768 93 94	cschnorf@hotmail.com	{bcrypt}$2a$10$UBvSGftj24KAGgft3ulwA./FVbtkn002PgZGLtaZE97DpeAGDaREq	7b31dfc8-e2fa-4061-8be8-e5ccb99c7845
825576b7-1723-4c59-ab5f-1a4fd04c0d72	t	f	2022-01-18 00:00:00	\N	m.niederhauser@drobfelden.ch	Häberling	Melanie	079 675 46 64	m.niederhauser@drobfelden.ch	{bcrypt}$2a$10$dmFIm96/pzO3IRLkstuSxOMPZKQxbo8BSEySSiPVbdK0dRbNjnRWy	abe50fa3-2ef4-4d18-96bb-f488174e5010
93851cba-8452-4b98-a25c-972fdb42c5cd	t	f	2022-01-18 00:00:00	\N	stephan.nie@bluewin.ch	Niederhäuser	Stephan	079 207 59 37	stephan.nie@bluewin.ch	{bcrypt}$2a$10$uneFrIHJ94Eybcv15hEq1OerifBRZ.6ReZT9Fmu86hVuIKEvwCHwq	a8e3fdb1-84b5-455d-9938-4993a33e7107
e422a46c-df51-4aa4-bb5c-9b5b5f29e67d	t	f	2022-01-18 00:00:00	\N	nico.nussbaumer@bluewin.ch	Nussbaumer	Nico	079 890 57 10	nico.nussbaumer@bluewin.ch	{bcrypt}$2a$10$xCwEyOqkyPk8UbTKnDe25O6X1LK1BUW.ixHELJcqH2vAHLbJxUmOa	cb31d7ef-447f-480f-95e0-903acf1a7c2c
3f56cd5a-ed1f-488b-aac7-752be8053a11	t	f	2022-01-18 00:00:00	\N	corina.stutz1997@hotmail.com	Stutz	Corina	078 894 88 98	corina.stutz1997@hotmail.com	{bcrypt}$2a$10$81mm1Y8Qftnoz6IWFveyc.TGMwBCZzXntHGyHAo8g/XjGGhv6rtma	87aa4ad5-0e6f-4ed5-9752-ab3f4032f303
b07891d6-22bb-453c-806c-ddb503bde0c1	t	f	2022-01-29 00:00:00	\N	roland_denzler@bluewin.ch	Denzler	Roland	079 729 19 93	roland_denzler@bluewin.ch	{bcrypt}$2a$10$Wo.W7N4wnhaoLdiYsc2/Ley0hNHMyg/nfF9HqFkvIoeT96hgrNlJ.	73abcba3-f820-432f-8afd-06d0f9acb239
77ecdfbf-9452-4404-92c1-fa0841e51591	t	f	2022-01-20 00:00:00	\N	mischim@gmx.ch	Meier	Michel	079 306 27 41	mischim@gmx.ch	{bcrypt}$2a$10$iuIkod8zHs440IWRjQQDJOxq40gkrm7iAtGUzczaNRDgfx6vNq5bO	da170c3b-3676-479a-aeaa-b7cec94c1f1b
1a80a988-db22-4991-a676-091f902279c3	t	f	2022-01-19 00:00:00	\N	i-sennhauser@datazug.ch	Sennhauser	Ilona	079 844 24 14	i-sennhauser@datazug.ch	{bcrypt}$2a$10$34/Whdwom7q3FVnIc2qIW.T7WudnuG/HZ1ci8wK6kLpzVAJM0FXlu	9c878988-8ead-4324-97d6-f7816b2da273
7f800a3c-a073-45e2-9a19-88cbb30d409b	t	f	2022-01-19 00:00:00	\N	m.c.heule@bluewin.ch	Heule	Marco	079 289 30 60	m.c.heule@bluewin.ch	{bcrypt}$2a$10$InAnCaWXFuI8Znim6M.ocOiTiptOtbj2fg5QHoPwUywZoLUyYeoVC	\N
5d0b3959-5174-4530-ba14-b33f686b1b2c	t	f	2022-01-20 00:00:00	\N	jz.friedman@hotmail.com	Friedman	Jason	078 810 97 57	jz.friedman@hotmail.com	{bcrypt}$2a$10$Sz43HzK4AJ978kLPP.xlv.6OP2JmnqVG5MZSwvqBQOIcuIEypWG7C	aada2ed2-ff6f-4eba-950f-7bd180a00551
9a19e2a2-ace7-4d2c-a308-429c76d6d683	t	f	2022-01-20 00:00:00	\N	simona.bosshard@gmx.ch	Bosshard	Simona	076 455 25 07	simona.bosshard@gmx.ch	{bcrypt}$2a$10$pc41ZcaruLFK5gxaR02aeeqoHOplPHujk7Q6PhakzuX6eckwSZKCS	2cb2de79-f430-49b5-acb1-a158d21a4896
2193264e-d362-4d75-a51b-b319dea02438	t	f	2022-01-20 00:00:00	\N	ardnaxela@bluewin.ch	Roost	Alexandra	079 452 72 54	ardnaxela@bluewin.ch	{bcrypt}$2a$10$uMiXJr3D2Pm8o3fiiyn3X.uH53YkQJHmBnMqUN1CpxiYHnWKxelxK	1fe567c7-3e26-414a-b441-fbb0d0dbdeb7
0e54809f-de03-4ccc-a761-2eb4541d5e01	t	f	2022-01-20 00:00:00	\N	wittwer.a@yahoo.com	Wittwer	Andrea	079 261 23 68	wittwer.a@yahoo.com	{bcrypt}$2a$10$tIM8//7x5IaNAF5PHlLQO.37baW1MP/aOx5CL2aPWBdhZtJ7uFKiK	5c37c1c8-49e2-4062-86c6-f6a633f55925
2e0b35ff-c539-4f6e-995c-f937202c9f88	t	f	2022-01-20 00:00:00	\N	chiara.buergi@gmx.ch	Bürgi	Chiara	076 349 44 35	chiara.buergi@gmx.ch	{bcrypt}$2a$10$4OtrvrSHkCbhSXQ1v8SGVuCaMzpcbFG8toTRLmGc8wwAg.hblN/jq	7e50de3f-6f98-4307-91d0-fe9f70bed06d
d2296a55-2592-4eb9-884d-2ab5fc33b3d6	t	f	2022-01-20 00:00:00	\N	lara.rechsteiner@gmail.com	Rechsteiner	Lara	079 943 77 03	lara.rechsteiner@gmail.com	{bcrypt}$2a$10$3E.A0rUBr6ji5qh/50H1KOkwE2nBzwqnFQ9MW60nqOM/oBzAldcgm	3de4355f-a180-4ddc-9230-7ab2841aa5da
72bcd2da-883c-4119-ad5b-3ac96d75e79c	t	f	2022-01-20 00:00:00	\N	l.wuelser@hispeed.ch	Wülser	Larissa	077 446 41 80	l.wuelser@hispeed.ch	{bcrypt}$2a$10$qg3jjYSVoGEMLWkBbBxOle0kfDjN5ixoYTYe2GSK06trnX1sgGXPu	03c6aa3d-25a6-4861-a27a-384030324b0e
d66be606-f1a2-4202-8b68-41ce7630ac2f	t	f	2022-01-20 00:00:00	\N	sinja.haegi@icloud.com	Hägi	Sinja	078 855 59 46	sinja.haegi@icloud.com	{bcrypt}$2a$10$mpBszoMPn1vNQWVzxI22LuX5Zflu4hy2DmO7JzC4zCmYLWnxj3xJm	cf9a5fa4-2d2c-4985-a410-b05b1358e506
622ae8b3-d876-4d6c-b4dd-0d6e93ea3df1	t	f	2022-01-20 00:00:00	\N	selina.bosshard@gmx.ch	Bosshard	Selina	079 389 94 71	selina.bosshard@gmx.ch	{bcrypt}$2a$10$smdHc.ir0Wo.lR7hijnbbe/wV2f71nUGzznAAr8P0sYff78NCRHj6	c54b09ba-f4f6-4a78-8984-eb8af0cffed3
993eee0c-9967-4f02-8462-72c91bbd0c29	t	f	2022-01-20 00:00:00	\N	Sandy.Althaus@bluewin.ch	Althaus	Sandy	079 554 42 25	Sandy.Althaus@bluewin.ch	{bcrypt}$2a$10$AYA9BJfepfNmcxPU1QCp.OV425Jn/YxBkSTawqXKr4fhgsA2.3oVO	\N
55652cc8-bcb7-49ba-8348-e62b362ee2a9	t	f	2022-01-20 00:00:00	\N	Spitznagel.Karin@gmail.com	Spitznagel	Karin	079 592 92 04	Spitznagel.Karin@gmail.com	{bcrypt}$2a$10$kEpJ5/YbPZkr9yDsEE04OO3uiHaQD/mjDGf.obv3pOCjZUT83Q1ZC	\N
c0fb2212-c732-4a53-a567-7fc5482381b0	t	f	2022-01-20 00:00:00	\N	n.mattli@bluemail.ch	Mattli	Nicole	079 350 28 63	n.mattli@bluemail.ch	{bcrypt}$2a$10$6QQFuhzwWyZohEknkoLVM.cxFlHIWEkssiU0oLKzGOQ5DCwXiiHqa	5c30e52f-3061-43f5-b959-fadd42052c3e
5027e4f7-6222-46bc-8972-6e76a136c3bd	t	f	2022-01-21 00:00:00	\N	just_pa@hotmail.com	Schmid	Patricia	077 405 37 30	just_pa@hotmail.com	{bcrypt}$2a$10$.iL3W2MGrhg4NmfXSb6kI.gMwEDZK4Dow3ULcoqNeo4CbwO127qJu	b74db374-8096-4190-ac2e-310b22085b6f
061f1886-4c55-442e-8b39-105a494a09ad	t	f	2022-01-21 00:00:00	\N	tami.ul@bluewin.ch	Ulrich	Tamara	079 546 82 15	tami.ul@bluewin.ch	{bcrypt}$2a$10$40ga/X5fh0b2xQAKNMpkmugF3BKXcn/.l8E3N5pmm4IwT.2NoTLJ2	b21b05fd-6351-4d1d-a594-a60fc8aedd42
d51f134d-0515-4910-a830-441f701f687e	t	f	2022-01-22 00:00:00	\N	lara.kaufmann@gmx.ch	Kaufmann	Lara	076 344 05 38	lara.kaufmann@gmx.ch	{bcrypt}$2a$10$jGQlxHV9X6efmuKcwBPGO.x//Vti56ajNWIbVoXBHwcmoNU.WIODG	f524a41e-70a9-4b2a-8943-a126ed2fdd02
07a30ce1-69bd-406a-9f46-5b790f2b5f77	t	f	2022-01-22 00:00:00	\N	nicolehonegger@vtxmail.ch	Honegger	Nicole	079 575 06 65	nicolehonegger@vtxmail.ch	{bcrypt}$2a$10$U.z74T.jNAXBM/gguEqrkOaXZyuSVsMBOdAJ1PgQgKWp6WaZ2.LOu	9c2ee5f7-9b6a-41ab-ae04-822a115ced50
21ac6f4c-e6ba-48dd-a8bc-63c8ccd1e158	t	f	2022-01-22 00:00:00	\N	m.carrel@hotmail.ch	Carrel	Micha	079 379 99 59	m.carrel@hotmail.ch	{bcrypt}$2a$10$rrpv42Zx/OWwiuKvT7PlXOOrWK.emqB9RTxBUaksg5EYbMbHpUy4O	fbc70dd8-a61b-4429-b6d0-3b84375cd9bc
0bd1479e-448a-45b9-b655-668fddffe9ab	t	f	2022-01-22 00:00:00	\N	raffael.pfaller@hotmail.com	Pfaller	Raffael	076 441 34 37	raffael.pfaller@hotmail.com	{bcrypt}$2a$10$799w62zOuF6FtRWesNrz9eFBKD6svlIhU/SdjYaSLV7kibbK.xJIS	9e3fca15-fb7e-4820-8aca-ef73b1b1d1b9
7bd09345-9f0b-46b8-8c67-557e2fe1da3c	t	f	2022-01-22 00:00:00	\N	lena.arndt@sunrise.ch	Arndt	Lena	076 504 96 90	lena.arndt@sunrise.ch	{bcrypt}$2a$10$9krD.VR9N/O7jz.fJA8Jdu/wyiXRPsi.FIzjpia2nnJ/y6usmZvQO	931793eb-5168-462a-b924-a350f87d990c
086863f5-5162-464d-8399-f3835f80e0c4	t	f	2022-01-22 00:00:00	\N	natalie.stoepel@gmail.com	Stöpel	Natalie	079 724 68 41	natalie.stoepel@gmail.com	{bcrypt}$2a$10$DW0XbjAkNDys6Xchb22E1OuXwGzhmbkD.B4m2x6x6pyJLR19H0GhK	a4fba4b2-7521-401d-8a2d-e6a678fa1835
f66694e8-2f3e-492d-b9b4-9a2e5b7066c3	t	f	2022-01-22 00:00:00	\N	blank.alinelaura@gmail.com	Blank	Aline	079 906 21 39	blank.alinelaura@gmail.com	{bcrypt}$2a$10$zKlJKCGOd3PnuN89v1n1RutAktgkHaztVuIsThpJeQkPPVlcnZddi	5f1e6040-c9a8-4904-b013-ef95ea0754bd
e2fd5aa9-6922-4c05-8731-b4481a0e30db	t	f	2022-01-23 00:00:00	\N	furter.rolf@gmail.com	Furter	Rolf	079 137 44 80	furter.rolf@gmail.com	{bcrypt}$2a$10$MMdJjf5sM7llz0WmsUq.Ne7gdzuYvgecHmpaO/3NrFSeHQJ.ruC0S	78a3f485-86a6-4821-be53-4aa2334aa831
3acca230-7a77-4087-876b-f4fdaeb582e1	t	f	2022-01-24 00:00:00	\N	a.l.kleibusch@gmail.com	Kleibusch	Anna-Lena	076 467 44 48	a.l.kleibusch@gmail.com	{bcrypt}$2a$10$a.TyhTTPbZAqeUrfKW0NMO11ULsj10w5qrByYKiYUOTcexJVeBAYa	a873f0af-3825-4ab6-a3b7-baa3867bce1f
1e1bcb74-bcde-4303-bcec-7902e23a5b77	t	f	2022-01-25 00:00:00	\N	katharina@vanderweg.ch	Katharina	Van der Weg	078 816 17 45	katharina@vanderweg.ch	{bcrypt}$2a$10$eRj1Vi9TnAhse40L4uFJQujYewtSdZapE5pSNeAGicUsAy.hzyHe2	b07ec6bc-6089-49d0-952e-2371d435d639
6a37a1d4-593f-425e-8335-a52dcd43391c	t	f	2022-01-26 00:00:00	\N	turnen@andreasschmid.ch	Schmid	Andreas	079 373 84 24	turnen@andreasschmid.ch	{bcrypt}$2a$10$/G5.pqPXHdtUdPobgp7kIOBerNSD7oyANW9/rGQsvoqytiG82LLuS	7f9e4371-8748-428a-8086-e16eac0f3d86
ca42885f-89a4-4adc-bcda-dacb79920c8e	t	f	2022-01-27 00:00:00	\N	a.camenzind86@gmx.ch	Deininger	Annelies	079 729 64 52	a.camenzind86@gmx.ch	{bcrypt}$2a$10$15WRAWKd/S/5oguazgxDUe0Am/edUsXcXHAzOrWqucujL1IzNK0Qy	117653dc-74a6-41c4-b3cd-23e16f1ec993
d64acad6-ca2f-4c2b-8407-854d9c3ba060	t	f	2022-01-27 00:00:00	\N	catherine.d@bluewin.ch	Gretler	Catherine	079 708 66 61	catherine.d@bluewin.ch	{bcrypt}$2a$10$xnR6PsciCuB655XkXorauukH7jjG3Uzfs1iFZju4DN8bV9N5Z6mfC	ea0e2ab4-722c-4093-993b-de4ae930cad3
925ac1e2-e8e7-4054-bb57-5f54a875ccb0	t	f	2022-01-27 00:00:00	\N	ela.wettstein@bluewin.ch	Wettstein	Michaela	079 383 01 81	ela.wettstein@bluewin.ch	{bcrypt}$2a$10$WPqwY6VA0fCfEzFuaaBuJ.RCqLt0bkbZ9MCIkpQ1ld6LoTBAE1y2C	8ce1e456-6fab-44c0-92b4-3c55bc6ff535
4dc2eaaf-22fd-47b3-965b-c50e130cf2bc	t	f	2022-01-29 00:00:00	\N	annamayr@live.com	Mayr	Anna	078 967 99 98	annamayr@live.com	{bcrypt}$2a$10$ixCKTRZdTPlaoCB0e85gSOr6czTN4rftRW8hNj2H4lPgtf12/yr5y	858c1335-8ef9-42ad-ae38-c84a4062bf66
4d0580dd-a48a-42b4-abdd-85d17500a946	t	f	2022-01-29 00:00:00	\N	mia@kuederli.com	Küderli	Mia	079 108 89 66	mia@kuederli.com	{bcrypt}$2a$10$0egdm/VfuqUWb1hfdRLkguoL9z4FbPN.wNy0HNJMmvqJZTo197FYe	e73ecadb-11b7-4709-91aa-a9e5a8d10dc2
bc81b02a-b96c-4cd0-99be-7aac90ff269a	t	f	2022-01-29 00:00:00	\N	viviane.stalder@gmx.com	Stalder	Viviane	079 281 25 95	viviane.stalder@gmx.com	{bcrypt}$2a$10$0OPeMrWYzgZAWLjYLNsJfOkZ.G64pCSNxdfjVdaiTemsVpFo4GTny	f42a5925-47af-4d57-a5f4-67a55e9a82b7
1b645a4c-9c7f-4648-8663-4e621fd2aaa1	t	f	2022-01-30 00:00:00	\N	getuhettlingen@gmx.ch	Erni	Conny	076 370 13 59	getuhettlingen@gmx.ch	{bcrypt}$2a$10$.z8nL5IRFWnG3xCk5KlgiuIvejuUfKnUKMS8sQLa22sZJglBku7da	\N
a8528c10-1ca9-4de5-8c0b-54b4e2702872	t	f	2022-01-28 00:00:00	\N	barblin@bluewin.ch	Meier	Barblin	076 562 03 13	barblin@bluewin.ch	{bcrypt}$2a$10$pq9ZYBlZDmlancKfYKWBruGeBvo7yiqkGDws.UFjHMSf656iB1dn2	4aac045f-2843-4dc4-a6cb-b178337ac164
5446d58f-3a93-41bc-8018-b792df6f463a	t	f	2022-01-28 00:00:00	\N	pelenks@hotmail.com	Pelenk	Manu	079 732 07 73	pelenks@hotmail.com	{bcrypt}$2a$10$6rxVLl88BDcVTnoQblOpQeWGKjSmPP8rgkmcDs/8Uev8s5dQIrKui	71411060-96c1-4947-abe2-e1e4dad875ba
a1ea2681-1d28-4581-b5b3-94fe471976b5	t	f	2022-01-28 00:00:00	\N	olivia.buechi@gmail.com	Büchi	Olivia	076 323 57 12	olivia.buechi@gmail.com	{bcrypt}$2a$10$myg9xnPWO76CoWmnA7.GMO0blkrWjyb0sNdLUVJYZvzm/gOL4iUuu	d5d9dfe1-16aa-45c8-8415-fe66b3f4791f
7e1bb369-f7fd-4182-8a78-60964391c46d	t	f	2022-01-28 00:00:00	\N	lena.junker@bluewin.ch	Junker	Lena	079 953 92 35	lena.junker@bluewin.ch	{bcrypt}$2a$10$BmL30gR2fmZH0fGVh75peOGPs9dIw2aPNZNRW0odWxAACOl.Sn89a	4a787979-5165-4ad4-a9b5-b0c9b760cbed
3ebfa3a6-812c-4d17-bcf2-9a493fcb7798	t	f	2022-01-28 00:00:00	\N	cme@svazurich.ch	Meng	Corina	076 572 10 83	cme@svazurich.ch	{bcrypt}$2a$10$oUI5weAvTvrBs9BwfCWHmOir.3N4rvIkH1aUhMFTqfjnydNgfEDUK	1e28f37a-fb5b-41b3-bef2-5e3b54c77e03
22f9861a-28d1-4bdb-8fc8-4f52fb105495	t	f	2022-01-28 00:00:00	\N	anna@monsch.ch	Monsch	Anna	079 537 07 54	anna@monsch.ch	{bcrypt}$2a$10$ketbmxP0XOcfngDgmf7E0uMmSd3Aa.cdyVH0q7dqfuWQCGNmyynOm	e6a92540-871f-478a-9c34-725e1d43b704
f830913d-ad31-40a0-87be-f02e02af340f	t	f	2022-01-28 00:00:00	\N	sanne.schnitzler@gmail.com	Schnitzler	Susanne	079 773 05 00	sanne.schnitzler@gmail.com	{bcrypt}$2a$10$TCZ0EIwy7S.sbCIPLtk20egW4AuZZxHbzdVLMS3.shZRniisg.EYi	142d752e-47ba-4992-b700-bd86e29aa9a1
4b6e6eaa-24d4-4cec-9ed0-be4380718b80	t	f	2022-01-30 00:00:00	\N	tamina99@gmx.ch	Wenger	Tamina	078 727 13 59	tamina99@gmx.ch	{bcrypt}$2a$10$tTXA7YspZE/oqRfmJ8ST4.HmFmB/YN5P4J11FnAOhkN/a2kCCi.9q	3655bdb1-70cb-4fae-bbcb-85d7a717704c
6b444e83-c271-4879-8b02-367cf035ca96	t	f	2022-01-30 00:00:00	\N	sina.giger@gmx.ch	Giger	Sina	078 868 79 97	sina.giger@gmx.ch	{bcrypt}$2a$10$Ck7uwp993KYMA7/oGCnA9.K.Q98FWuklM8qMMZxzRxy1xxh7rtxbO	c7e14149-5e49-4a5f-bf37-e7d9767d32e6
17d13b97-d58e-4203-9610-d7d0047a90c6	t	f	2022-01-28 00:00:00	\N	getu@tvruemlang.ch	Klaus	Seraina	079 309 15 00	getu@tvruemlang.ch	{bcrypt}$2a$10$GiqWZr4.2Lwo7sPf.qohwecSzP1AacrbkCNWdAfytSVM6D3orh02u	\N
4b382a2d-2d01-491a-8d43-7166a57e3302	t	f	2022-01-30 00:00:00	\N	vera.ruegge@hispeed.ch	Rüegge	Vera	077 443 54 62	vera.ruegge@hispeed.ch	{bcrypt}$2a$10$uMLE.sTD9D8HOll5cCkpwOvNs7kJA8S8jlEATdnijOFvyhEtybrLK	ad8400aa-5409-4161-a245-407885118514
bd872f00-9dea-4026-9711-00439a28b4f4	t	f	2022-01-31 00:00:00	\N	liv.hoch@gmail.com	Hoch	Livia	076 391 08 50	liv.hoch@gmail.com	{bcrypt}$2a$10$yHzid06okB9H2SW.AkY0pOhst7/ILF2mfGuw.yMb/xr9uqMwlsCJq	7f4fd554-63c7-4c17-8411-84d24bd6971b
f8cbc6eb-b99a-464a-b9d4-bfb495f70830	t	f	2022-01-31 00:00:00	\N	angela.renk@bluewin.ch	Renk	Angela	079 643 32 63	angela.renk@bluewin.ch	{bcrypt}$2a$10$5693mvAg.cifLl3u39f0TuzCCxN8UXakffLkblDxLOemBgMG9cgkW	71f89f96-2ca5-4dfd-9257-643a27e4af56
38b4fe63-43b0-463f-8730-4a5908d0decf	t	f	2022-01-31 00:00:00	\N	khaenni@bluewin.ch	Hänni	Karin	079 728 39 69	khaenni@bluewin.ch	{bcrypt}$2a$10$.ZcCzIYgtw6Y4M3wy2acy.UHDzTVxOEH4fDSlhAf2n4VmufP3U5W2	66df5d28-a3d9-4a02-9eab-8d7d10d93e28
3552e5c0-b13f-4fb2-8a75-ceb6ef4cf677	t	f	2022-01-31 00:00:00	\N	carla.pfister@bluewin.ch	Pfister	Carla	077 412 04 83	carla.pfister@bluewin.ch	{bcrypt}$2a$10$HMk8qRz/Q28ZwC5F4GnFJuqiOJOrfuI8iG5rfVgZlVFNIutBfHeq2	dbf29cac-3dac-4b53-98ce-79d85b81e743
26a9d8c1-3d57-455d-81f1-e25a0fec7c71	t	f	2022-01-31 00:00:00	\N	se.pfister@bluewin.ch	Pfister	Selina	077 414 24 79	se.pfister@bluewin.ch	{bcrypt}$2a$10$Feq3m33iCeTNfnd8rin/yuCxpGMpwbX0UJ88.TUl3GVQ5rGzoNWoK	316b4b23-7943-472e-9512-58fc92a03023
9fe8a226-1f0f-4646-bffd-dc04159e8afd	t	f	2022-02-01 00:00:00	\N	tinagut@bluewin.ch	Gut	Tina	078 646 34 28	tinagut@bluewin.ch	{bcrypt}$2a$10$rtPqpkARoPqbKpk/dEi/.ulphE42KGGq6gt.OWdivpILLL6Ck4I3C	d15dad2e-5df6-4c51-8000-eb3641791718
18102c15-f386-43cd-a84b-86f792e2a3ce	t	f	2022-02-01 00:00:00	\N	michellehauser20@gmail.com	Hauser	Michelle	076 680 08 09	michellehauser20@gmail.com	{bcrypt}$2a$10$EWjX5MlFyZBZT84M6w1VTemfA01H.bewmJXl6DNZmbZVj39.sLSce	36928f27-08da-49e2-bc17-fa4a17ef9509
b22ac014-1a23-4afa-b64c-51d3a5598b40	t	f	2022-02-01 00:00:00	\N	eliane-hepp@hotmail.com	Hepp	Eliane	079 762 94 73	eliane-hepp@hotmail.com	{bcrypt}$2a$10$lXeVGiwya0zthGsuSvUt4ee/hKAqp9WZfeU3xOIVxFkMyGc80Asia	750e59b8-148a-4f18-bdc3-010a97cda385
8bd3e973-5d5a-4f6b-93a2-2c12150667a8	t	f	2022-02-01 00:00:00	\N	fabienne.schaettin@outlook.com	Schättin	Fabienne	079 412 09 78	fabienne.schaettin@outlook.com	{bcrypt}$2a$10$ppgTFp0E92TRK0WRpElqE.dscFFMCYPDKI6lOKB66Ien3sc810xLC	0e0b2934-1284-48b8-9b8f-ca77e108e832
5ce1c09e-32cd-4153-811d-283b51f0fb48	t	f	2022-02-02 00:00:00	\N	muriel.siegrist@hotmail.com	Siegrist	Muriel	079 884 96 79	muriel.siegrist@hotmail.com	{bcrypt}$2a$10$faIjOczidxVRJiofdm5vQelfBkjSOaBp23zHJMokW1R2uJylF87RS	128e7321-0737-4920-b4c1-2e9c8d2d0e59
1eb82ebf-1ba1-4a8d-a7fd-4351b06e88c3	t	f	2022-02-03 00:00:00	\N	marmei@ggaweb.ch	Meier	Marlies	079 747 19 15	marmei@ggaweb.ch	{bcrypt}$2a$10$FKHOuoWOe83KhBe1WFC89ee/7Aq7VAf394YLheN6xUZscG1Q/lDKa	\N
3ec16c8b-1656-4c98-83f2-92de26adba79	t	f	2022-01-22 00:00:00	\N	getu.bonaduz@gmail.com	Schoop	Seraina	079 541 20 40	getu.bonaduz@gmail.com	{bcrypt}$2a$10$ROIN.axDnFTAfDKlC8f8huIBYOcrflMHzM9kUcBoJEKf8eTA4vQoS	\N
2d825100-4593-45a1-b486-2670cb27eb1c	t	f	2022-01-22 00:00:00	\N	fetzfrei@bluewin.ch	Frei	Cornelia	079 548 65 36	fetzfrei@bluewin.ch	{bcrypt}$2a$10$DpLABFj.lcnThZMHx0TDROZuhiOC2HqseEpwpxk5iudUDaUcJ9.Wq	55d42f0d-2538-4934-96ef-08a6973d28a8
3680433a-ff79-4a68-9715-44563de86317	t	f	2022-01-22 00:00:00	\N	steinkamp.dagmar@t-online.de	Steinkamp	Dagmar	077 458 37 56	steinkamp.dagmar@t-online.de	{bcrypt}$2a$10$sLdm3bdP7xQ2SfQQVsMcA.0qzKzaquB0Rr6LPEDm8fRr4R0zkF9LG	2b34e952-0e96-4b21-acb7-3909ca15bf36
7a330c16-06a5-428c-a46d-1b70bdd2ec56	t	f	2022-01-22 00:00:00	\N	tim.wisotzki@protonmail.com	Wisotzki	Tim	077 427 87 61	tim.wisotzki@protonmail.com	{bcrypt}$2a$10$Fq7Xlo0tblr8zQBrSXFt/ev9eejUiXpsOqGYQe34b.6x2pUJgPz6i	c7b16e0c-d58f-453f-87bd-2aa072c4d720
db8ee7df-c8f5-4aec-a78f-72ea750ba251	t	f	2022-02-03 00:00:00	\N	michaelsteinkamp@gmx.net	Steinkamp	Michael	078 734 15 50	michaelsteinkamp@gmx.net	{bcrypt}$2a$10$S9bYV/l83KBB/sq7AHQhj.q27RrWAh6b1daOu0oaWWk2AKdwCgweu	40ed7853-4ab7-4ec5-8c76-8234b213f1c2
9381b75b-ffcf-46c5-9485-3de896616db3	t	f	2022-01-23 00:00:00	\N	roli.schmidli@vtxmail.ch	Schmidli	Roland	076 400 80 12	roli.schmidli@vtxmail.ch	{bcrypt}$2a$10$6Zg4wghL2L3Ee0pkL2fPDeFaEOnkjigkTKmG8PphNH5fv9IblZTh2	2e8918bc-bc38-420e-be1d-0c78aa3ef6e3
ad68f084-9f3c-46f8-8f3d-6d6a339b10eb	t	f	2022-01-29 00:00:00	\N	sefrei@student.ethz.ch	Frei	Severin	078 907 93 55	sefrei@student.ethz.ch	{bcrypt}$2a$10$TgWisVweJEmJXosH0wBBUeIuEonzHc9fgiCwx0/6rDtrJDkpGQFaK	\N
55407925-43fe-43cc-aa02-fb647b012dfc	t	f	2022-01-27 00:00:00	\N	celine.schmid@bluewin.ch	Schmid	Céline	079 227 26 85	celine.schmid@bluewin.ch	{bcrypt}$2a$10$UpggSLtDE8x.FYvK/42rAulKMAfebkUIsE7laO7nZXjHFY52IN1UC	c5d649e5-9aa3-4221-a0ec-036d03d1393e
b2736bf3-6d33-439a-906b-d19ed002190b	t	f	2022-01-27 00:00:00	\N	maja.haeringer@bluewin.ch	Häringer	Maja	079 584 59 25	maja.haeringer@bluewin.ch	{bcrypt}$2a$10$cJyFqA7R.Yri/9XQz5qUDONl3TEShJqrsAd1aiDMtlf60U4GJaxlO	a3be5132-1644-4c26-866c-cb4f872eed77
ca8a9503-1aa2-4ed2-8dc0-933fbb67d222	t	f	2022-01-27 00:00:00	\N	ja.furrer@bluewin.ch	Furrer	Jacqueline	079 444 39 33	ja.furrer@bluewin.ch	{bcrypt}$2a$10$GuUZAM0OZoUMGDsVGH/LKehHP6/EmqNFiKFuNQ.ZoNuaTh5IeXh6G	1dc074d8-a3ed-4be0-a2cc-36c06635875c
4d82dad7-7c7e-476a-bdb2-7a7a52d7ac6f	t	f	2022-01-27 00:00:00	\N	linda.kaempfer@gmx.ch	Kämper	Linda	079 681 30 89	linda.kaempfer@gmx.ch	{bcrypt}$2a$10$jiiU.IbY5wwVBXSCQQQdC.Sag0ezi/YgYHWQ7fCLPY8z/4QKGwpOO	feb0ad38-35ce-4a91-9c38-8a800fce50aa
384f338f-40e3-4330-831e-7a657bff33f8	t	f	2022-01-29 00:00:00	\N	lenamayr@live.com	Mayr	Lena	078 676 88 89	lenamayr@live.com	{bcrypt}$2a$10$rTMjWgHvzxhv7eInizGRYe.GcLQUya0eT4IgE.Dslw18EACDFRNKq	ba22264f-37df-474b-a394-94f75546dd43
6aa74387-60aa-4e0e-9477-5f4d10d39263	t	f	2022-01-29 00:00:00	\N	milijana.barudzija@gmx.ch	Barudzija	Milijana	078 735 18 40	milijana.barudzija@gmx.ch	{bcrypt}$2a$10$17z2KlRumWZCqpwgD7UjJOo.ox0QKEguI8sNPxCTc9WQkXANXlmG6	ae8c420f-92f1-47b3-be96-6859ec12a7d3
f2b44c2f-7eec-40b8-a7df-0189cefdfb78	t	f	2022-01-30 00:00:00	\N	conny.erni@gmx.ch	Erni	Conny	076 370 13 59	conny.erni@gmx.ch	{bcrypt}$2a$10$/gTnDVO662yy0NbruUYsruMT7nn/7XqBox0oXL533X2uFGN8KUNJ6	8932c351-bb01-4da9-96ca-e45b3ec571c3
83e5c48e-15ca-442d-afee-668be11d8226	t	f	2022-01-30 00:00:00	\N	danisha.merlo@gmail.com	Merlo	Danisha	079 152 96 71	danisha.merlo@gmail.com	{bcrypt}$2a$10$f2DljjJZaDA8Soi6.KEtGuLxdeITLBbeSNzl9b.TCU7QN.b/Y0iFa	9a79a8fc-e478-4736-b119-2df804b6ec22
612da206-6246-4df9-a86e-9f645a6115db	t	f	2022-01-30 00:00:00	\N	anja.kaufmann-hettlingen@hotmail.com	Kaufmann	Anja	079 949 86 77	anja.kaufmann-hettlingen@hotmail.com	{bcrypt}$2a$10$Y90aCYs7UcMLRo/S8gf.juuRPiZnWsIoKRM.T3QVkz8wYNYrwAVz6	239543ef-de4b-4c88-9f5f-7109cda3297c
822732d6-3bf2-49cb-9128-815d6bac8437	t	f	2022-01-31 00:00:00	\N	benji.staeubli@bluewin.ch	Stäubli	Benjamin	076 504 90 22	benji.staeubli@bluewin.ch	{bcrypt}$2a$10$WA6sW7Y1FKZcAilamToCfeFWMK4rjJDF4z7lH6qb5DnNfQ6kmnywi	\N
17f95695-7deb-49cb-b14a-f73e44619c78	t	f	2022-01-28 00:00:00	\N	franziska.michel@gmx.ch	Michel	Franziska	079 460 64 17	franziska.michel@gmx.ch	{bcrypt}$2a$10$zNO1u8WiZif5MUS83BtDFO7LD0ohz52/8ppd.lgbHra4eRaXpYnzO	8f475ece-fa83-4d25-80d8-7acf49bc1695
e6fecc49-f1aa-42c2-8d13-9a22dd77627d	t	f	2022-01-28 00:00:00	\N	rouvenfo@gmx.ch	Foster	Emanuel	076 389 08 04	rouvenfo@gmx.ch	{bcrypt}$2a$10$Wsup0trCT7qC7kGNimFYWuCcYw8cLffw0xS5Zyk01I6GaRoubXDaS	b59c5523-423f-432a-9af5-803128b90f82
4190ccc1-1383-488f-946c-cd4bf3f4073c	t	f	2022-01-28 00:00:00	\N	nicole.volkart@bluewin.ch	Volkart	Nicole	079 259 16 69	nicole.volkart@bluewin.ch	{bcrypt}$2a$10$007fdJ4XhnACJyVkDSZ0VedMQKs19kuTeaElbJTsqQqLUew0oAxfK	05cb103f-33c7-4a60-912e-2cd146996733
b56e5bce-c15c-439a-94dd-988ec063b9fe	t	f	2022-01-28 00:00:00	\N	sabrina_staub@yahoo.de	Staub	Sabrina	079 565 89 64	sabrina_staub@yahoo.de	{bcrypt}$2a$10$kuvVRY7cnXQlhvUY412pXOVX31GUrYaDZSRzm0wGOOKxxR2hhJ.Tm	ec25b8f6-e2db-47b4-bee6-99589440dc7a
eafe70ae-d4f6-4678-93fc-e10d817b0334	t	f	2022-01-28 00:00:00	\N	elian_keller@gmx.ch	Keller	Elian	078 816 99 15	elian_keller@gmx.ch	{bcrypt}$2a$10$faIkdaJj4A5cSJT8kHDX4unGkIv4B5yFOO90K5cswm6/nZjCRhyu2	662d5c7e-ff93-4b3f-bc9f-e73098509455
c9189cbd-6a02-40a1-8ab0-12f62fe3ab86	t	f	2022-01-28 00:00:00	\N	v.koller@hotmail.com	Koller	Vanessa	078 966 67 70	v.koller@hotmail.com	{bcrypt}$2a$10$MdBAPFxTz2m7YzpXJUwdoOKJoJWSK4/0YO9RIsf1Tq9BNtc/h2aUK	6e405e7e-fbc0-42ad-b00e-37eda73076a8
47c29583-4a08-4aef-97dd-f999f515aea9	t	f	2022-01-28 00:00:00	\N	wiggermara@yahoo.com	Wigger	Mara	079 195 41 32	wiggermara@yahoo.com	{bcrypt}$2a$10$asc7N8avLEPLBBndPsZDI.HKSbfzpQmtor7V5F1nZ1nk7Xg/gdRoC	fd1a3a4d-998a-4076-a5c0-4b8ff3e48bd1
1b74e314-60a0-4d27-8a43-0265b6be2fd5	t	f	2022-01-28 00:00:00	\N	Knoepfel92@gmx.ch	Knöpfel	Christian	079 309 15 00	Knoepfel92@gmx.ch	{bcrypt}$2a$10$CuEXlJcker2bajnBB1WvN.o00gKFpGxf0BkTx2iTeHm3GZM1/LTN2	60757479-15fe-49b9-9b71-ca6ebf8c1484
7d656112-7de1-4c76-80ba-162e24bf4a0a	t	f	2022-01-31 00:00:00	\N	ronja.kober@outlook.com	Kober	Ronja	076 470 23 11	ronja.kober@outlook.com	{bcrypt}$2a$10$PHHM3IXbQR1RIcKlfvgsyOGcdBWH8pHk.6J7rAJEWo83OwEyUd6mG	4c4c9845-ba3d-4715-abc1-506d42686ce5
83f8fc6e-1d1b-4d68-aa2c-baf4f4939964	t	f	2022-01-31 00:00:00	\N	thierry.raible97@windowslive.com	Raible	Thierry	077 406 92 32	thierry.raible97@windowslive.com	{bcrypt}$2a$10$DfEYjQ69R.V0Ps9JxS/NBuct1oVf1k5dMZafGI1If.i5xLt25n0oK	c277eb4f-37ae-4b11-867c-5675756a2f29
04d35523-c7ce-47cf-bf63-b9f35e991760	t	f	2022-01-29 00:00:00	\N	n.messikommer@gmx.ch	Messikommer	Nico	076 443 12 29	n.messikommer@gmx.ch	{bcrypt}$2a$10$E7LWBBH/6FpiVG8Djm2P9uKqIVkqsIOqYhcuo4XBfKGZdKReU/q6O	2136e0fa-7cef-40e5-bb8d-93317096b081
1fc9ff0c-1fe2-4028-9db8-818b0fce6e4c	t	f	2022-02-02 00:00:00	\N	patrick.luginbuehl@bluewin.ch	Luginbühl	Patrick	079 714 14 15	patrick.luginbuehl@bluewin.ch	{bcrypt}$2a$10$DrMQyxzxV9ND02HoIvgHNuNG1RpDH/YiN1BPj8TLQgmdUqaITJnIm	f046d484-deb3-430f-ae6b-07226033604e
e49bf978-0b2a-4156-9d23-f360306d442d	t	f	2022-02-01 00:00:00	\N	sandra.kaufmann@ggaweb.ch	Kaufmann	Sandra	079 734 96 60	sandra.kaufmann@ggaweb.ch	{bcrypt}$2a$10$p3mRpA4fa6kdi9oxxUhEPeT.UsE1zZ5JiAxr7PDaBHR5.CKRkzkze	ee57b63f-7396-468a-9f60-de48cbd83e0f
9910fc55-5bc6-4479-af92-eae7b840f295	t	f	2022-02-01 00:00:00	\N	janine.hauser@outlook.com	Hauser	Janine	079 890 24 71	janine.hauser@outlook.com	{bcrypt}$2a$10$IayK4Eb2GEmOI2Jz4rK3lusMON6fb/QOwCLENlhDKV6zpfvLuW.tC	3ec152cd-6dca-4d21-a915-25ca5db72967
675c7652-6162-4b89-bd73-dccb3ab657dc	t	f	2022-02-02 00:00:00	\N	joanna.b.getu@gmail.com	Borowska	Joanna	078 873 83 88	joanna.b.getu@gmail.com	{bcrypt}$2a$10$Zm.Ub/hClkZzg58n7kxCH.1dJE2xj4SytuccRVRSCRp91lRFyAuda	0676b495-b4b1-4457-be3a-4865b462bde6
ac5bbd7b-726e-494b-8144-50035114a9b5	t	f	2022-02-03 00:00:00	\N	e.gehring@hispeed.ch	Gehring	Esther	079 463 23 80	e.gehring@hispeed.ch	{bcrypt}$2a$10$HDIUD2BsQx54fEChfOzR..iZRMwVyiZSCKOCnKDtratLNayTRTR42	ee4af964-8638-4140-94c9-a6df24132106
6a3387a9-4f35-4c62-989e-077b9e1366ef	t	f	2022-02-12 00:00:00	\N	miles@knoepfli.ch	Knöpfli	Miles	077 777 77 77	miles@knoepfli.ch	{bcrypt}$2a$10$yKefg6LiujVLOP3OcDyx0OEDd2jTcAlL0B7Ys1go8oHt8JSG1lYTe	a37163d3-5148-44b3-814c-9c3d316517ed
941bbd43-2df8-491b-a667-c7e455a8a49d	t	f	2022-02-01 00:00:00	\N	getuegg@gmail.com	Gut	Tina	078 646 34 28	getuegg@gmail.com	{bcrypt}$2a$10$HJ3f8LL/mTnrCpVL6zRBlOqxVJDn/FGfRKMjSzFkggLKo5libEfYG	\N
02d213b3-1193-4b02-8a95-4ff0f602ff2e	t	f	2022-02-12 00:00:00	\N	getu.flaachtal@bluewin.ch	Lenherr	Therese		getu.flaachtal@bluewin.ch	{bcrypt}$2a$10$Cw89gl///sWdnYUfxuxYKuZt0gp0MAZ.16JJe0UebyovHZh4VzvjG	\N
0eb8b85b-e34e-40a5-a5f8-5eec70082ab5	t	f	2022-02-13 00:00:00	\N	Priska.hottinger@me.com	Hottinger	Priska	076 421 97 72	Priska.hottinger@me.com	{bcrypt}$2a$10$HP0lgAqMaTdrG0rCzWaq.e5.nGr9k3h9yg4xRj4HtQPz..sVmShLG	e9b0771e-9e48-4c85-b459-cf46a02fe422
01a7df2f-6a9e-41db-a75e-71f30171f44b	t	f	2022-02-13 00:00:00	\N	mia.buettler@bluewin.ch	Büttler	Mia	078 635 19 91	mia.buettler@bluewin.ch	{bcrypt}$2a$10$NdyE8dj3VZFKppPXK4MSaOUP141a3c241Ml6Nx8qgODQrsCsHY8Lu	cf823f0d-bfb3-482b-a076-7a426262ee07
1f84c59d-f045-4bf6-9535-a0ca0d6af899	t	f	2022-02-02 00:00:00	\N	francoise.heiniger@bluewin.ch	Heiniger	Françoise	076 453 48 69	francoise.heiniger@bluewin.ch	{bcrypt}$2a$10$5qrxkT2brQTa6OHWA6TXTu2OxEA3F.TJwQM3Zj5/scS70.Dhn9P66	\N
b73c8e58-32a1-4178-9e7d-8b4f472f24e6	t	f	2022-02-02 00:00:00	\N	joel.furrer@hotmail.com	Furrer	Joel	076 389 77 29	joel.furrer@hotmail.com	{bcrypt}$2a$10$zwzpkN6vrarniKwnaCT1R.IzWOaFXMe/h/yBk7xNxovzEuTHOb0sG	69c7edd8-7d68-4e79-88c7-c5907a712ffc
bc32d83a-8eb6-42fa-8457-9104fb535a5b	t	f	2022-02-02 00:00:00	\N	moniquestraub@bluewin.ch	Straub	Monique	078 705 80 30	moniquestraub@bluewin.ch	{bcrypt}$2a$10$scC5UERA4a5THdqPA9DZkOUD666DSpZj/wQ1YtKJ3uVkTMRqe1JdO	1d7a723d-fd6d-4e41-a889-b611edc669ae
adae4dae-17b4-44cd-8faf-d6a6d6eafb36	t	f	2022-02-03 00:00:00	\N	rahel.doll@bluewin.ch	Doll	Rahel	079 814 39 85	rahel.doll@bluewin.ch	{bcrypt}$2a$10$Ye9917BhpEws6CWHToPYd.weKa/eYymsPmlSb5EIVsydQyRoDgxnG	9dd9c490-6645-431a-b0a9-585054bc3d2c
5c5f951c-ba41-40f2-893c-18f00900313a	t	f	2022-02-13 00:00:00	\N	charlotte.jaeggi@gmx.ch	Jäggi	Charlotte	076 429 16 29	charlotte.jaeggi@gmx.ch	{bcrypt}$2a$10$yP63W4UFUr2gPf49PHnB9eZotn8u.O3nDwox0dBNmA7/63NPWYn.y	ebe1b1f1-6d7f-4f7e-826f-a5e30d7f7de0
499e51e1-e117-4479-9a51-967cca2122c0	t	f	2022-02-03 00:00:00	\N	richard.staub@hispeed.ch	Staub	Richard	076 204 11 72	richard.staub@hispeed.ch	{bcrypt}$2a$10$2v9QF1qgyk0AiJ04tk4zQur/NxdRJlgV50ybceqYApIOnO5McsDBS	\N
2a805d9c-5fbd-4bc7-ac97-76bad732613c	t	f	2022-02-06 00:00:00	\N	moni_unterstrass@hotmail.com	Meile	Monika	078 876 84 77	moni_unterstrass@hotmail.com	{bcrypt}$2a$10$tX0f3xYdYX86o1t3mpNx8O.I9mfbv5l/E/PS3A6P3ok06Vt2CWWY.	\N
511a53ef-0a61-4e03-98eb-ee55f3310a59	t	f	2022-02-04 00:00:00	\N	hodel.effi@gmx.ch	Hodel	Claudia	078 713 90 90	hodel.effi@gmx.ch	{bcrypt}$2a$10$wLe2/jnXQz6mgKqSDemnDuF09IoeZBd.B7Tt6mBrB0Hw7IzkJg8Ya	fd8e0ac4-0e95-40da-8701-65b4aecbaaa2
b8bbee08-a65b-4f59-8b61-a5cd4881f4d4	t	f	2022-02-06 00:00:00	\N	karin.prasser@bluemail.ch	Prasser	Karin	079 328 97 87	karin.prasser@bluemail.ch	{bcrypt}$2a$10$SdJes6Me2.cB3hWGCJa0IOgPosYrPXQaw/rz6aNIdXjTypZhyRz56	\N
a69b96a6-8676-4a76-9c11-acfbab6d8676	t	f	2022-02-02 00:00:00	\N	akro-getu@tv-nsw.ch	Bundi	Christina 	078 726 86 76	akro-getu@tv-nsw.ch	{bcrypt}$2a$10$lfZcQ0zFNp4c.ySahYduO./dsClwZA/l5EPIYJ6mxmPrmmUbaISxK	\N
2155cb46-c288-46f7-afa4-6637e6f35b60	t	f	2022-01-31 00:00:00	\N	Svenja.riedo@tv-rheinau.ch	Riedo	Svenja	079 132 08 48	Svenja.riedo@tv-rheinau.ch	{bcrypt}$2a$10$7RE3bKL/PiaYNjwQm8xxUup3auxiFfwCQyNuOY85T8ZR2nyocauUe	0b093ac7-6e25-4bab-aaae-e452371773ab
1f3938a4-89b5-425d-9e28-497df7df1a28	t	f	2022-02-02 00:00:00	\N	christoph_wetli@hotmail.com	Wetli	Christoph	077 402 09 59	christoph_wetli@hotmail.com	{bcrypt}$2a$10$DBbh86iOeNfbbJGqJcfL3uJWrGo3b41lMTpVUryAZjgvRbN4/H7Bq	10bc16af-66b4-4e3c-800c-40a42a9d5507
b3388e65-6a0b-41bc-a5e2-ec4a91f604e2	t	f	2022-02-06 00:00:00	\N	sevielmer@msn.com	Elmer	Severin	076 559 16 89	sevielmer@msn.com	{bcrypt}$2a$10$APni9GqTwALeHMxLx64VPOHgoKSVqvcgnHL1Fw9FrxNxBGxtanFsy	afb25b3d-5212-4cd2-a6db-d4e9003fc938
06c4b10e-5d4c-4dbc-8f60-979d116905c3	t	f	2022-02-08 00:00:00	\N	celine.meier@getuniederhasli.ch	Meier	Céline	076 536 66 69	celine.meier@getuniederhasli.ch	{bcrypt}$2a$10$l5jjTdnd8vZ6hIIwmLCs1.sJKtQ0V3FhzbL.3AaGfvM5jM/17zcU2	03d8dc57-4c6e-42d7-b6c9-7d3e1ab1a9a9
b544819d-de0b-4a87-ac1b-f6aeaa6b9a35	t	f	2022-02-08 00:00:00	\N	fabienne.koch@getuniederhasli.ch	Koch	Fabienne	076 384 10 44	fabienne.koch@getuniederhasli.ch	{bcrypt}$2a$10$o5RXEbP.vtM.Qrv77xNvf.qQnTWmTlpkndcLZpUNQ/cbBpdmDYdBm	5a23cf40-33ab-4e32-a435-5375b1ce2e83
7da403e9-57fe-4ce7-84c0-27de44901373	t	f	2022-02-06 00:00:00	\N	manu.b@gmx.net	Beutler	Manu	079 580 06 77	manu.b@gmx.net	{bcrypt}$2a$10$3D4CpWjyGOfTT3PjnDcmJOKnztROMAe4tp8oxJroFj205np73t9Ra	3a2ead3a-bf03-4e6e-87d6-3405f931d953
4a78d9be-5fab-4a9a-92cd-9d99a86fcd73	t	f	2022-02-06 00:00:00	\N	sonja.marthaler@hispeed.ch	Marthaler	Sonja	079 289 74 70	sonja.marthaler@hispeed.ch	{bcrypt}$2a$10$9NKv4rDA/EqaPHLY4Xk2HO7iNxnPVJht7gI.w.IjnhOYyBFBMko1O	b9452e12-ec82-4e27-b5e5-8b189e424557
4cd13020-4b58-4685-84c8-f1783f45d361	t	f	2022-02-06 00:00:00	\N	heidi.marthaler@hispeed.ch	Marthaler	Heidi	079 730 63 31	heidi.marthaler@hispeed.ch	{bcrypt}$2a$10$6yOovYWvcMFBiyJY2HojWOXAULmcDNyF9hWEOcyjlLzSkp1XOOLjy	3b18877c-f520-4b23-a944-eef9bb1bba4f
6be7499e-9c16-45e1-8741-aac41b19835c	t	f	2022-02-07 00:00:00	\N	altin.alickaj@gmail.com	Aickaj	Altin	076 680 86 34	altin.alickaj@gmail.com	{bcrypt}$2a$10$Y4mpYdzMCnpmtl4OyagheODYCeLBq6huDsHm/IyA1TMcvSt.OOoi2	6ac081ca-9695-4790-8dcd-926a40c835bc
774adf0d-2f37-4fc5-8c5b-6c0bce8b8680	t	f	2022-02-06 00:00:00	\N	hans.muster@turnverein.ch	xy	xy	079 766 60 93	hans.muster@turnverein.ch	{bcrypt}$2a$10$58TRei9oPwqVt4CU7mnxleO/oGYqSIjpQJ5bFkXBqQ3QtEQMHx9GS	\N
e84bd253-96b9-43d4-846d-3894e82f6f02	t	f	2022-02-07 00:00:00	\N	irene.max@bluewin.ch	Pettermand	Irene	079 731 92 03	irene.max@bluewin.ch	{bcrypt}$2a$10$x0Ao7DN2b2EbkLO8Psako.Nl0TkGOonIiow4z2upzjOZN9aT6ETmW	4b87f0dc-a368-43cf-a3b5-25e74433774a
4aafd813-b46a-4496-a5c1-6104cf8511dd	t	f	2022-01-17 00:00:00	\N	dani.bucher5@gmx.ch	Bucher	Daniel	076 323 31 05	dani.bucher5@gmx.ch	{bcrypt}$2a$10$Qif5PSl9AzVUxKH8zx8oOuWWpa8xnrYhnZGerWIWw4g058qmQjoie	\N
d734e36d-7232-448e-91c5-55fad3c1eee4	t	f	2022-02-09 00:00:00	\N	niccigredig@hotmail.ch	Gredig	Nicole	079 576 00 92	niccigredig@hotmail.ch	{bcrypt}$2a$10$cJzffJ7Xn3R7POGGXT2QwuQG2z/SdNft.NMC.DIsUXgxECRN.wS4y	7e2c7fe7-bb24-45d2-a879-e57c2a496e12
d4d542e0-0194-48ef-a75f-668ba72f1c89	t	f	2022-02-07 00:00:00	\N	daniela.pongelli@bluewin.ch	Pongelli	Daniela	076 405 44 20	daniela.pongelli@bluewin.ch	{bcrypt}$2a$10$i0ks9mpNqTRFPJPmmzFS7uLTa4pKhYfIF2IKSx8h3T2HE5E1gENJ.	\N
387da566-0489-4a69-afad-5e392ace964c	t	f	2022-02-09 00:00:00	\N	laura91_lauriane@hotmail.com	Steinmann	Laura	076 392 30 71	laura91_lauriane@hotmail.com	{bcrypt}$2a$10$lvjhbOvHTmJ7rf07w6J64e5SyzbeONMJNeDjJCS3ww5IX9pv2EhJG	dda39ab6-2d01-4c52-a189-29fe8bbd2ed2
cc500728-7e8e-4266-a2ea-3b21f26a314a	t	f	2022-02-09 00:00:00	\N	katjbru@gmail.com	Brunner	Katja	079 719 15 67	katjbru@gmail.com	{bcrypt}$2a$10$yzm5INET6QBiWCLsRsXm4.e.WZF6/NltTwTJAPPqMywJOI0eNkQPi	a160e28d-a1d7-4a80-806c-6eb8cd7ca3c1
561abb5e-fd7a-4ac3-8234-2c2eed06046a	t	f	2022-02-09 00:00:00	\N	pia.consoli@getuniederhasli.ch	Consoli	Pia	078 818 18 04	pia.consoli@getuniederhasli.ch	{bcrypt}$2a$10$P6bV7JUP4VYWknNZnwRhyucoJ4cgLBPH1htKjgQu40XOtGz23XAEO	\N
680e412e-c1d6-41ca-a780-88061f8c94de	t	f	2022-02-06 00:00:00	\N	lina.atapattu@gmail.com	Atapattu	Lina	072 282 55 57	lina.atapattu@gmail.com	{bcrypt}$2a$10$H86yRlhMzZavhhgqAHRoie7tJAP.QxhUiUuWvUn3ZYcm7/.JFOkay	\N
5d3667e0-681a-4040-b96e-7de551c5c3f4	t	f	2022-02-11 00:00:00	\N	monika-fischer@bluewin.ch	Fischer	Monika	077 412 68 56	monika-fischer@bluewin.ch	{bcrypt}$2a$10$0EQ/9xlMKx7FLF0qzgaJd.fHCR2vz6O5pugzEQdqefIU5v3eGHFAa	d4823f02-6cb8-4537-96ec-d3cc41b4ded6
edd3f015-0bb7-45fe-bccf-a0f63fb97557	t	f	2022-02-12 00:00:00	\N	roland.bertschi@bluewin.ch	Bertschi	Roland	077 777 77 77	roland.bertschi@bluewin.ch	{bcrypt}$2a$10$FPn6wAgBiQzQcLxevVCPx.qYRk3Yec6eof9N14Z6a7Z8isBgrS2j.	4146c7d7-c2f3-4938-bca9-da5f275c2208
6b5eb2d3-956a-47da-b731-fd2017b7434d	t	f	2022-02-03 00:00:00	\N	keiser_cindy@hotmail.com	Keiser	Cindy	076 339 47 30	keiser_cindy@hotmail.com	{bcrypt}$2a$10$RQNQ/rtzKPuKl5rjqxSjbuRdHpn/LiUcSHNFKmu3opps0vUz5eY1u	\N
6c83e7f3-684d-41d9-9304-cba6eaee2b80	t	f	2022-02-03 00:00:00	\N	eva.doll@bluewin.ch	Doll	Eva	079 752 91 18	eva.doll@bluewin.ch	{bcrypt}$2a$10$2rt2YhA.r90mJ4Zkc.CEu.2JXqIMTMCOgPytnllyGR5tm2FHpm6RS	3b596bcf-636f-4b2b-b32d-12715db973db
f87f0f05-54c6-46e9-b36c-7b00ea92cf2a	t	f	2022-02-03 00:00:00	\N	mathilde.schellenberg@gmail.com	Schellenberg	Mathilde	079 898 02 06	mathilde.schellenberg@gmail.com	{bcrypt}$2a$10$Cqv9r1tnVQhwbZgdylPl9uFB.fv3SrQ5X5L7vBvIhc76gr5Ekf6Iu	fe7f9ee0-7b03-4217-b82c-7e55fd5a68f7
57617f49-78df-46d7-bdd8-a9524b4cbe81	t	f	2022-02-12 00:00:00	\N	wilmaschicker@hotmail.com	Huber	Wilma	079 234 64 09	wilmaschicker@hotmail.com	{bcrypt}$2a$10$DupZ9cF3mZfJJviHmp7ldueqfnOzTFhfn2Da1mylja.M9.78MXPf6	5082bf2b-7675-46d7-afc7-20585facdeeb
3646dda9-2cd9-4f0c-afd6-f4ed170f6328	t	f	2022-02-06 00:00:00	\N	ckoma@hispeed.ch	Kocsis	Matthias	079 766 60 93	ckoma@hispeed.ch	{bcrypt}$2a$10$ESxP1POVluVMPWSX8VFPcOpN3Tqez2xlmCkLH4Lg6MiQ/TfJxzCQ6	3d075219-eac9-4ea6-8aca-e27cbf829671
974578c2-33f3-494d-93e6-eea345ef6d22	t	f	2022-01-18 00:00:00	\N	noella_kadi@hotmail.com	Steiner	Noella	079 629 20 69	noella_kadi@hotmail.com	{bcrypt}$2a$10$//E6zLlQakvUWOi7I1E5x.pV9RJM9JcqyKHn4eRvWNS7deNTJsuGS	\N
b476230f-9903-47bb-b2ed-20ec9c1cf194	t	f	2022-02-06 00:00:00	\N	david.kloeti@gmail.com	Klöti	David	079 432 72 48	david.kloeti@gmail.com	{bcrypt}$2a$10$1GUX35m1XOLH6XASLa/LPOxY.I96ra8TLtUvekeIZYgKmu.J9yOrK	550e07d0-2c73-4edb-a5a6-f5ca5ea137a7
8502503a-3bfc-4e21-87b9-dad1b87cdb87	t	f	2022-02-06 00:00:00	\N	janine.eicher@gmx.ch	Eicher	Janine	079 392 04 80	janine.eicher@gmx.ch	{bcrypt}$2a$10$Y6FFyxy2lVQaBD6KLiF9G.lGOqaUh9QpzcTRyqMmi6yk4yOfyBBFi	14463235-281e-4ea0-9358-4d2fa0bbee91
684560d2-5ea3-4076-92e3-35d018968385	t	f	2022-02-06 00:00:00	\N	burti.gadient@gmail.com	Gadient	Martin	079 221 11 50	burti.gadient@gmail.com	{bcrypt}$2a$10$tm96wCz.cilOicGkj1wpcunCB90hQzQQLHoHhoSyRTaTOgwC95rva	\N
fd2e5b8f-2ccf-4f2f-a64b-b667fa2e81d6	t	f	2022-02-06 00:00:00	\N	brunner.patrick95@gmail.com	Brunner	Patrick	079 872 03 79	brunner.patrick95@gmail.com	{bcrypt}$2a$10$KfBfLgmgQ1Tx2isfNVZJg.bhAfp5CAM/ZEKYEPZ1juq1F0X0mMjha	16adde04-8a5e-4b32-93ac-443322f0f76a
1ebef21a-14dd-4b2d-969a-e8e2804fb8d1	t	f	2022-02-12 00:00:00	\N	roxana.koller@gmx.ch	Koller	Roxana	076 303 86 25	roxana.koller@gmx.ch	{bcrypt}$2a$10$ZW0wxv2puPzEdkkNfwFx..ksmrNVair47zFR6V.lEfAdXnSc6yZYu	2bd268ae-226f-43a4-9366-c813abfbcf52
2860c43b-b4f9-4c1f-88ab-584f78c212a1	t	f	2022-02-12 00:00:00	\N	debi_koller@gmx.ch	Koller	Deborah	079 932 81 29	debi_koller@gmx.ch	{bcrypt}$2a$10$/ZNHjWg.kFkvInFn9dG0z.deZQ9FwK2S2S7XScX4IwkXRwFxAJR3a	b8920606-0845-4404-ba4c-134ebee1d855
cc4ce5c0-10db-4043-b4b3-2ce0f5c411c9	t	f	2022-02-08 00:00:00	\N	simone.etschmann@getuniederhasli.ch	Etschmann	Simone	076 455 77 20	simone.etschmann@getuniederhasli.ch	{bcrypt}$2a$10$L3L.hO1F6J1R7BMFS2c/L.ZDga96HPig/ajUP8tQIF/y7cbjhbSNC	200227f5-e8c4-45f2-a74e-6b35e5fd064b
4cc265ad-9660-46bf-9a65-f388d84d1e66	t	f	2022-02-08 00:00:00	\N	nicole.schmalz@getuniederhasli.ch	Schmalz	Nicole	076 467 94 94	nicole.schmalz@getuniederhasli.ch	{bcrypt}$2a$10$1CQKUr18.E3/.CI/BZergeWE6l0BGWpGrgbUmUT8eTChrVZOK0JYK	0f7fddd3-2ef0-400e-bf90-416039022cc9
23c00e1a-a9da-4f1e-a143-949e85b7a153	t	f	2022-02-12 00:00:00	\N	selina.meier95@hispeed.ch	Meier	Selina	078 853 58 42	selina.meier95@hispeed.ch	{bcrypt}$2a$10$eHjkmJdqmjQUObu/ny2jQupUzvwMnVDLiX1wZHcwvhAtjLq6lYVG2	6e1e5b31-6794-4474-92c4-ff47dfe61bab
0cfeac7b-b3c0-4e5f-ad0b-b70323591294	t	f	2022-02-06 00:00:00	\N	mo.mi.weiss@gmx.ch	Weiss	Michi	079 323 45 06	mo.mi.weiss@gmx.ch	{bcrypt}$2a$10$ul9YAv7N7OPCrM8tuk7W/ecFrw0LSzsTuvbyKHVog15aPiJAg/dGy	0b479310-2e29-422d-ac13-5af1133cb775
7f9a3ac4-e86b-4d51-bd2e-2a09ad93fe8a	t	f	2022-02-13 00:00:00	\N	leni-schoen@hotmail.com	Schönenbächler	Leni	079 756 97 38	leni-schoen@hotmail.com	{bcrypt}$2a$10$zQb0kYJBINPY2gRV48VpVOKd1kaH5HH296mrywDFYmd9QugMCCMbW	fb1ba90d-9563-48c9-9b06-8b05f0a084fc
d426b797-6389-4b27-a696-69e1a231abb3	t	f	2022-02-13 00:00:00	\N	rahel.hottinger@mac.com	Rahel	Hottinger	077 438 29 39	rahel.hottinger@mac.com	{bcrypt}$2a$10$qT7XX1FzSrOGzZKd1270NeP3H/DTvAzOFa61QuNW6Al8SNZm1LwJW	79b9af1a-abd5-4642-a810-008b28e524f8
1e8fe38a-aa89-486f-a31a-bebf4219f22e	t	f	2022-02-07 00:00:00	\N	ch.baenziger@outlook.com	Bänziger	Christina	079 789 91 11	ch.baenziger@outlook.com	{bcrypt}$2a$10$D7o88OfZrHoxfESeVTUd9OuaFT8QuoUFHuRcp/k.fyNNAZJ3gD2gC	\N
ae021822-4388-4357-b2be-badd7ad52a12	t	f	2022-02-06 00:00:00	\N	nicolekuendig@hotmail.com	Kündig	Nicole	079 604 51 59	nicolekuendig@hotmail.com	{bcrypt}$2a$10$hRFoHOvToAQPN1LlSwuL3eZmG8Judd5HTYiECSYPQYltma9uvz/pK	ba268763-99ac-48c0-940c-78a537d7c94f
ab740e36-07ac-471c-8a8d-42b004bf2264	t	f	2022-02-09 00:00:00	\N	m.streich73@bluewin.ch	Baumann	Monika	079 710 36 46	m.streich73@bluewin.ch	{bcrypt}$2a$10$GJ0V4DCgvkg2UWU8VUJzoOS3gINe.1D6SHNzTnUj2oabYxQRgN8mS	a0cbdcaf-d276-4f65-b9fa-392068dee982
f5e10ce9-2d10-4d8e-8dcf-a96768fa99ea	t	f	2022-02-09 00:00:00	\N	ianiolaiara@gmx.ch	Durodié	Dominique	079 457 75 67	ianiolaiara@gmx.ch	{bcrypt}$2a$10$SGHrZRmBNFzUkvMC9TEnL.xLE.16llY8ndBDLXKLnmQL.5Qjh6HBS	7bb3a2b5-da0b-4490-ac52-01ca29d1fdf1
9a3ee8f2-8195-4557-8648-26f45f3bb029	t	f	2022-02-09 00:00:00	\N	gabriela99@gmx.ch	Ruckstuhl	Gabriela	079 918 41 08	gabriela99@gmx.ch	{bcrypt}$2a$10$l0KvNo9klAoYymgdsGJp/eu1VGn9RWDkCG6apM5yL.dxPFwEy.AXq	c1b65e88-82f3-4e89-a7dd-9ddecd594317
07452f3c-4607-4430-8c49-2956b2e94176	t	f	2022-02-09 00:00:00	\N	andrea.lopez_92@hotmail.com	Gil-Lopez	Andrea	079 957 43 34	andrea.lopez_92@hotmail.com	{bcrypt}$2a$10$aYnge/8LuyDBiBcSG3SxQuQk27V8IJ6tAKUPEhYLTHwyd2TgLjsrm	\N
5412961e-cf30-44ea-b9a0-7679e5306204	t	f	2022-02-10 00:00:00	\N	andrea.lingenhag@gmail.com	Lingenhag	Andrea	076 545 42 41	andrea.lingenhag@gmail.com	{bcrypt}$2a$10$nwC7ux6Lb5ik2st0r2itNOOChRZq/tkDn2rAXFBcX0vnZJ/KMdYH.	ec2cbb42-db37-4282-9a02-daf8b684ea2d
1a5f4d6f-76de-42e3-9ad5-0356eee2509c	t	f	2022-02-10 00:00:00	\N	p.raeber@gmx.ch	Räber	Patrizia	079 736 19 74	p.raeber@gmx.ch	{bcrypt}$2a$10$n1iJ.f0FK9QK2H7qpu/Jh.Ig9cQJPdFnUCOOKHzmYDSgN/wAIYsum	7396bc3d-0b5b-445e-adc9-042728f4a7a7
0adbd46d-ce5d-4575-9c3b-1d20aab14b6d	t	f	2022-02-11 00:00:00	\N	babastrassmann@yahoo.de	Strassmann	Barbara	078 698 35 46	babastrassmann@yahoo.de	{bcrypt}$2a$10$Gr02xDSmleOW9RnN9KEthO2Fp8KWC1E.h/tSwgeAsUs66LS15hgEi	824683f9-9378-4551-a4eb-2404e5b5d128
f1f88d14-f3d3-4419-800c-c6bb144fd1fb	t	f	2022-02-11 00:00:00	\N	lara.formato@hotmail.ch	Formato	Lara	076 460 60 44	lara.formato@hotmail.ch	{bcrypt}$2a$10$FrKLB1owpqr9YbximSghjODjFgqL0VR8Y1d1V.Is1Voe11ey.31KC	7a373760-da4e-46a5-bf96-fee837cf4354
fcd78ddb-4d5d-4fad-9442-32f1f501aca2	t	f	2022-02-11 00:00:00	\N	maria.picardi@gmx.ch	Picardi	Maria	076 469 45 11	maria.picardi@gmx.ch	{bcrypt}$2a$10$FSK5fzu.BAdJ.ut1mfoFBeAAGXDvhgKdJsMZ27wNxXn0KAqPZcIri	d97f5666-a7bd-4338-86b8-6313e9cfff19
ee1447cd-39fc-4d59-bd89-ac82e9f781dd	t	f	2022-02-13 00:00:00	\N	andreas@getu-eglisau.ch	Hintz	Andreas	079 702 28 97	andreas@getu-eglisau.ch	{bcrypt}$2a$10$XaHIyc3Zn00J1gUR0MqsTem.ldCYeteHQyYHZxLlN45QsrXyj3o/6	\N
68d1b8e8-28fb-4824-a2a9-1272b22749ca	t	f	2022-02-08 00:00:00	\N	karin.helbling@getuniederhasli.ch	Helbling	Karin	079 697 24 25	karin.helbling@getuniederhasli.ch	{bcrypt}$2a$10$9LmPo/sCWi9/GvkAoHH5BOnstxlvpQzMQgnGCLA5IdLRcLGra4psW	db0900f1-ae60-457d-a9f2-3e3c07afa7ba
2b324662-f93a-4017-bda8-48ed46fae70f	t	f	2022-02-02 00:00:00	\N	linus.okle@tvseuzach.ch	Okle	Linus	078 765 53 44	linus.okle@tvseuzach.ch	{bcrypt}$2a$10$fkoaoi.jOzc/TxwKulS9WuCJxfoyDFtVDBX1ZlALoaDZikSmmuYqO	\N
1e7b075f-151f-4b1e-9bbb-93118dbcd972	t	f	2022-02-06 00:00:00	\N	cschnorf@hotmail.ch	Schnorf	Carmen	079 768 93 94	cschnorf@hotmail.ch	{bcrypt}$2a$10$9FA1suw3cSk730BPG8oDkeqSDcVvuSXWAA1JeDq5vrYIjwJoYt.z2	bf3dfbdf-5942-4683-af0d-a984d870440c
c43e58b3-e4b5-4fd5-a470-ad57d7bdf1fe	t	f	2022-02-06 00:00:00	\N	anjalanz.lanz@hotmail.com	Lanz	Anja	079 918 25 63	anjalanz.lanz@hotmail.com	{bcrypt}$2a$10$bnqWQq1ZmW9o5CpIUKhx2.TxLDZVfaupEuSJulItSK3h/N8X03GcO	11d6f19b-dcd4-49d8-8deb-c174bc487bec
3b2954f5-a0c6-419a-8e5b-0e48dc81f042	t	f	2022-02-03 00:00:00	\N	meli.bauert@gmail.com	Bauert	Mélanie	076 816 23 27	meli.bauert@gmail.com	{bcrypt}$2a$10$OZABxd0tgX0qZOlPJZ/i.OrgSMD0tETAcD2CilkaTSWf.YWHw2.X.	8d7c3344-1d86-419a-9fc8-cb772b44b053
e3f8f50b-53c0-4caa-b2a1-042a86971a01	t	f	2022-02-06 00:00:00	\N	sylviagreuter@gmx.ch	Greuter	Sylvia	079 617 61 88	sylviagreuter@gmx.ch	{bcrypt}$2a$10$2i.0qn.TbyiFRg.RkXjM1eUHE4zvsCRETWZJ759KVx53LHU7q0Q7u	a1c62f0f-1c94-4ee3-8151-c7fcdd5415c7
b5eb4c41-78cf-440d-a7f9-0f69b39d6580	t	f	2022-02-05 00:00:00	\N	sha_rei@gmx.ch	Reiser	Sharon	079 912 38 11	sha_rei@gmx.ch	{bcrypt}$2a$10$JMfH7sI9dfoOXkEV5oGtyeio/rArruYQu2HTR3IYPU3t01pi/CZbe	\N
212abe50-e318-4160-b8b3-6a73b90e7db3	t	f	2022-02-08 00:00:00	\N	severine.blumenthal@getuniederhasli.ch	Blumenthal	Séverine	079 455 81 32	severine.blumenthal@getuniederhasli.ch	{bcrypt}$2a$10$OKa7MuDgf3XvWAHMzbq7Neu8cvbsehIEkMmVaDg/f7RV2Kzv3g382	d4a96803-1fc6-43c9-add2-a68f1efdfbc5
34da2c5f-0c4f-401f-b817-de9ce9f25db7	t	f	2022-02-06 00:00:00	\N	tanya.fuchs@matalofy.ch	Fuchs	Tanya	079 266 06 68	tanya.fuchs@matalofy.ch	{bcrypt}$2a$10$AFPt4GJL13YMND3RwPxaRuJ3GeJ2cUJSdZVALOBz/cJZnpWAgnMvS	48b0bdec-4de9-4ce4-8dfe-8f86f79060a6
0619ee4d-c9e3-484d-9bf0-949c6a02a2f2	t	f	2022-02-13 00:00:00	\N	tanja_schindler@hotmail.com	Schindler	Tanja	077 412 42 52	tanja_schindler@hotmail.com	{bcrypt}$2a$10$ZjPKoYv9HDqIUdiEf4.V8eY9cpeVbNv5wPWi0xKVJAksC2l7yb8Aq	d40a1c0d-397e-4861-8353-dd687520cbea
dd98a669-bffb-47f4-9786-517866086534	t	f	2022-02-06 00:00:00	\N	thierry44@hotmail.ch	Brunner	Thierry	079 505 54 53	thierry44@hotmail.ch	{bcrypt}$2a$10$b7D5sUvnsdq9ulOUSSSb6eCv0V5deSsiDaJKK8MlKMtsHOz22llrO	\N
c1257a79-adcc-48ec-97c0-9cbc900d1fcc	t	f	2022-02-07 00:00:00	\N	silvia@rotondi.ch	Rotondi	Silvia	076 720 22 12	silvia@rotondi.ch	{bcrypt}$2a$10$j4GaQB4q6zTuvasQgEGfjuVlav0pE4NkCNGUZ5PykK3Q.qB/N5Pka	8fe75f04-0f0c-4528-86bd-77242f73ea85
4116f11c-1a40-49aa-81a7-c041f218f8d0	t	f	2022-02-07 00:00:00	\N	naemi.orlando@gmx.ch	Orlando	Naëmi	077 430 24 39	naemi.orlando@gmx.ch	{bcrypt}$2a$10$CA.eOFIw/aumRuA5M.PsWefXr0kolMNMI9JRQxiZNgYvqgDKILJoK	393d8d2e-1a96-4a0e-b0ac-3e791bd63c62
49e092ce-b1dd-42af-a38a-b569212485d9	t	f	2022-02-07 00:00:00	\N	ronja.fabech@bluewin.ch	Fabech	Ronja	076 558 16 05	ronja.fabech@bluewin.ch	{bcrypt}$2a$10$umQla5ud7VILl2N9LHSvNuUhRGemSgkpAdKce/BmbxyfvX.tU7O3G	8df88300-cb14-47a4-b561-36052ca6b964
5d832eec-7910-4153-8955-691938064e0d	t	f	2022-02-07 00:00:00	\N	leah.mang.02@gmail.com	Mang	Leah	079 908 65 54	leah.mang.02@gmail.com	{bcrypt}$2a$10$tIrElVpw8o0QqUYQPB9sOuqjEX0pysZ4fdLK1xEetZmpe9f88/liq	2b5576ef-784f-451d-b30e-0735850abc53
18f9b3d2-e879-4158-8c00-389eae8ef91d	t	f	2022-02-09 00:00:00	\N	ambozzi@gmx.ch	Bozzi	Anna Maria	079 747 01 31	ambozzi@gmx.ch	{bcrypt}$2a$10$grCeAd7uXMuwgPaiIQ.YAe.RdL7HUfT9RAlfE0aC75xzHP1GvwPIm	ef6f220f-027a-42fb-a5d3-0e67b8c69339
3e91824b-6148-4d3d-b1f8-d0cd67755424	t	f	2022-02-09 00:00:00	\N	getu_bassersdorf@hotmail.com	Kaufmann	Nadine	079 468 93 37	getu_bassersdorf@hotmail.com	{bcrypt}$2a$10$49RFceWeRBIYGxzNtskvMOla4JxUJy89oOpdttdn5wN8Sbvp8wuU6	c41b7b4d-0153-407b-a660-1fec5cd28603
2444be84-b6d3-4cab-bfbb-3b95432db6a0	t	f	2022-02-12 00:00:00	\N	anneke.klein@bluewin.ch	Klein	Anneke	078 853 56 54	anneke.klein@bluewin.ch	{bcrypt}$2a$10$fZPkRDERoq5CiPCte/CHpuwHEE/7YBkDBa6WZ6QKunysWvo.43zMC	32779ba6-424f-4720-8b3d-fca004c121aa
5f443dae-ef08-40fc-ba1c-46a4ebd4951d	t	f	2022-02-13 00:00:00	\N	beat.kropf@gmx.ch	Kropf	Beat	079 773 75 51	beat.kropf@gmx.ch	{bcrypt}$2a$10$sivV9UBP1GDvMR7XiSaYs.0SRQQta34DmqWNEnlOKOvZSBMiJEmzC	39dcbf9e-287e-4e49-85aa-a00a202cfb75
54362deb-2aa4-495b-927f-1dd37caf0560	t	f	2022-02-10 00:00:00	\N	giuseppe.favale@bluewin.ch	Favale 	Giuseppe 	079 659 90 26	giuseppe.favale@bluewin.ch	{bcrypt}$2a$10$DtFIyaf8s9/JGTRmPDeBUe7KgQFe0MT8d46kge4vqJ8RujzfKmtfO	\N
d864ce4e-2ee9-4185-80a2-f664d3cc5654	t	f	2022-02-11 00:00:00	\N	pfetrapo@bluewin.ch	Pfenninger	Thomas	079 693 71 76	pfetrapo@bluewin.ch	{bcrypt}$2a$10$BjbHbS2dRfdAuHXIosj8s.XqHq7vMzSgMPIfIsSRPeTIuQ2nirJLu	\N
9fd52c08-46a8-4c08-a6e7-4ee7f4995d9d	t	f	2022-02-11 00:00:00	\N	renate.ried@bluewin.ch	Ried	Renate	079 345 04 19	renate.ried@bluewin.ch	{bcrypt}$2a$10$.VFexTPev6wb7J0/XPv53.VU.ofzY3wbxIDRz65KbnNKNVuinIDdW	8341a3ae-dffd-455b-9ce4-d49583315aa5
55debbc1-6e33-4b45-ac93-961f5ce31f33	t	f	2022-02-11 00:00:00	\N	bischof.tanja@bluewin.ch	Bischof	Tanja	079 219 28 84	bischof.tanja@bluewin.ch	{bcrypt}$2a$10$6RhY.cBzng2lJgUUSK4DhOZPsbgcIbPWshtHduWmmk..iAEA2rjBG	3857efdb-e6ac-4158-b7e9-6346790a8abb
122aa0eb-e096-45da-b679-cafebbcd1048	t	f	2022-02-11 00:00:00	\N	maritaruedisuehli@hotmail.com	Rüdisühli-Duschletta	Marita	079 218 36 23	maritaruedisuehli@hotmail.com	{bcrypt}$2a$10$ogOVHEhJhkXR4rnOGJJsXeR7xN5N5l/S8OJB85ANvjVBxHafRUeS2	f53604b7-7877-4fd0-a695-ad3f6fa6f2a3
2aa32e66-2896-465a-9e71-df92dbcbca3e	t	f	2022-02-13 00:00:00	\N	stephanie.1991@bluewin.ch	Von Aesch	Stéphanie	079 585 41 33	stephanie.1991@bluewin.ch	{bcrypt}$2a$10$5oeW4cJSNls0pIiRdkFHie7LZaaVvJgAwWM87rgb65g4OsbzjJVzG	028e3c72-140c-49f0-9c14-4f42d74dce3e
226281fb-6ea8-4920-a507-93f7370bfe50	t	f	2022-02-13 00:00:00	\N	ramina.bachmann@sunrise.ch	Bachmann	Ramina	076 461 22 10	ramina.bachmann@sunrise.ch	{bcrypt}$2a$10$uK4hrMMvdqK5W20xyQzJkujiGdXW.iKikyWxFOiAC3TKm88Vg3BAm	906457ab-370f-49a0-9ebe-d472f1c5979f
a0b2aeeb-9488-48c9-8763-5879c9852478	t	f	2022-02-14 00:00:00	\N	carole.jobin@gmx.ch	Jobin	Carole	076 594 41 74	carole.jobin@gmx.ch	{bcrypt}$2a$10$9icalSPSmdazXqlRnIQaiuUyB4EYi6h/VDYQyvgO/JI544O3pSjkK	dc395047-00b3-435f-a0b8-4360388c25d4
9eae4f57-ddac-436e-8c44-0861545cefe5	t	f	2022-02-14 00:00:00	\N	alessia.kober@gmx.net	Kober	Alessia	076 369 33 32	alessia.kober@gmx.net	{bcrypt}$2a$10$dMmbjcUntESuTZPl5cRMuez7yM8XbkKrsG/0f9FtIqzIbiKzdKUbq	1af6dd67-67a0-44e2-accd-5ac8d10facaf
cf04baca-a6ab-4fa6-93fe-c8037aed6416	t	f	2022-02-14 00:00:00	\N	carmenleemann@hotmail.com	Leemann	Carmen	076 525 89 62	carmenleemann@hotmail.com	{bcrypt}$2a$10$FWp68dvOILM7R./CzV5HMu9E93RiIlxLgTdeQA6H5w62NnofzD6Zq	d4462bf5-69ab-4957-935b-037a9daa05b3
fb74aa81-9b33-44c6-a77f-c961179f8814	t	f	2022-02-14 00:00:00	\N	jlva@hispeed.ch	Schneider	Jlva	079 284 33 94	jlva@hispeed.ch	{bcrypt}$2a$10$wJxWO8//jFiqbmvTU/f7/O7T910Xv6o8yDmdqpDB2QPj4EH77PeS2	60703f75-9b43-4535-967d-9ea2b5775964
c20621d6-69c7-403b-98af-658229c9c45d	t	f	2022-01-18 00:00:00	\N	n.schneider91@hotmail.com	Schneider	Nathalie	079 427 49 01	n.schneider91@hotmail.com	{bcrypt}$2a$10$wfVGDuTYUrYA42HPGH2ksO6W8t17JqpIumfakY5qS95vEcu0OhxVW	344e9477-4618-4142-b09d-39a29ade4bd5
6ea71f63-2e65-4d5e-8ea2-cda595777d49	t	f	2022-02-14 00:00:00	\N	sabrina_haefliger@hotmail.com	Häfliger	Sabrina	076 489 30 48	sabrina_haefliger@hotmail.com	{bcrypt}$2a$10$BT5Ve9B2Tbj5bRO/vs0Xj.zYmEuU9EaIIv.5IyNUwv5pFkElyROw.	5715058a-849e-4e15-931d-27019ef12042
bdc171c6-e2e9-438c-8b12-b2259917ee25	t	f	2022-02-14 00:00:00	\N	werner_hungerbuehler@bluewin.ch	Hungerbühler	Werner	079 720 15 55	werner_hungerbuehler@bluewin.ch	{bcrypt}$2a$10$phpstShi0/iWnIuJKbFrQe/lZvbimUqO5Td5S9AmQiqfIt2IesDuy	\N
\.


--
-- Data for Name: person_anlass_link; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.person_anlass_link (id, aktiv, deleted, change_date, deletion_date, person_id, anlass_id, organisation_id, kommentar) FROM stdin;
df2af5c4-ed32-4abe-bd5e-a90fa6c7fb25	t	f	2022-01-11 00:00:00	\N	e8bb3a4e-ff5b-4d60-8e37-f2358c646077	b7440787-50bd-4e41-b38b-48acf37af0de	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	Falls möglich K5 werten, da ich K6 betreuen muss. 
8fa93f6c-13a3-4e5a-8608-eccf7ff7b3d4	t	f	2022-01-11 00:00:00	\N	86b3a1de-3668-4dcc-97ac-8cc6d2d599d6	b7440787-50bd-4e41-b38b-48acf37af0de	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N
1e7cbb9c-cefa-40a1-8f6d-539c0d290fbe	t	f	2022-01-14 00:00:00	\N	98446f19-e0a5-4c96-853c-2c0b6751a9d2	b7440787-50bd-4e41-b38b-48acf37af0de	a60429c0-6964-454b-8ee1-ddad66957f06	kann als Brevet 1 oder 2 eingesetzt werden, Gesuch für nur einen WR gestellt
c900dd97-44ce-431b-933e-da667ea43ae9	t	f	2022-01-14 00:00:00	\N	b50a9187-40f3-495b-904b-9ac1b0ecddf1	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	\N
4350eb78-23aa-4bb6-b207-e198b6e9930b	t	f	2022-01-17 00:00:00	\N	8fbdbec6-80f0-47a5-94d5-5d02fda96258	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N
8aa67420-fb13-4efa-afca-561806727eb1	t	f	2022-01-17 00:00:00	\N	d716fa96-59e6-46c7-90a1-32583e8a4253	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	Wettkampfleitung
72b0edf2-9636-4045-9cf2-2016e6582d7b	t	f	2022-01-17 00:00:00	\N	af4c71b9-b08d-4099-9fb1-7cf9f23c1786	b7440787-50bd-4e41-b38b-48acf37af0de	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N
d75592e7-1a88-4a5a-8cd4-3b634d35d9b5	t	f	2022-01-17 00:00:00	\N	4ec3c51c-93cf-43cc-9c48-8d588c04211d	b7440787-50bd-4e41-b38b-48acf37af0de	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	Betreut ebenfalls noch unseren Turner vom K2, ich hoffe das geht aneinander vorbei. Sonst bitte melden.
f6061ea9-4e92-4e02-9184-f0eeb96ad42c	t	f	2022-02-01 00:00:00	\N	9fe8a226-1f0f-4646-bffd-dc04159e8afd	b7440787-50bd-4e41-b38b-48acf37af0de	c0a6c2eb-1278-42b5-8aba-0426f3550863	als Brevet 1 möglich
ca7098f4-74b7-468c-a84c-b54fdd5ae7a0	t	f	2022-01-19 00:00:00	\N	e422a46c-df51-4aa4-bb5c-9b5b5f29e67d	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	\N
b6daec27-1750-405c-8a84-b4a8e88d25ea	t	f	2022-02-01 00:00:00	\N	5d0b3959-5174-4530-ba14-b33f686b1b2c	b7440787-50bd-4e41-b38b-48acf37af0de	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	\N
1b09a2b6-608d-4cad-9c90-afc571719ec9	t	f	2022-01-20 00:00:00	\N	17ed84be-4dcd-4fab-baf8-40c3c422dcc0	b7440787-50bd-4e41-b38b-48acf37af0de	81308200-79d0-466c-a19a-ca3fbef6045a	\N
ac2e21a4-71b3-41cb-b58c-934e4b2ed379	t	f	2022-01-22 00:00:00	\N	07a30ce1-69bd-406a-9f46-5b790f2b5f77	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N
4740cbad-b322-4404-bfcf-15a610a8eb28	t	f	2022-01-22 00:00:00	\N	d51f134d-0515-4910-a830-441f701f687e	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N
502e5d08-99d0-4c02-ba3a-97d9b32573d7	t	f	2022-01-22 00:00:00	\N	2d825100-4593-45a1-b486-2670cb27eb1c	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	\N
3ef17816-a379-409a-82a6-72e27cc1c27d	t	f	2022-01-22 00:00:00	\N	db8ee7df-c8f5-4aec-a78f-72ea750ba251	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	\N
ef93cce1-26ee-4d55-a73b-5b16e18fcb17	t	f	2022-02-05 00:00:00	\N	6aa74387-60aa-4e0e-9477-5f4d10d39263	b7440787-50bd-4e41-b38b-48acf37af0de	80c08ccc-c90e-4377-af3b-2de779197c7a	\N
03651ead-49ea-44db-ae99-b2a6662395d8	t	f	2022-01-23 00:00:00	\N	0aa96d4f-62c3-47e3-8b8f-94809f66f05a	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N
8c890fc1-d923-475a-9ab3-e4f0da2ae141	t	f	2022-01-24 00:00:00	\N	061f1886-4c55-442e-8b39-105a494a09ad	b7440787-50bd-4e41-b38b-48acf37af0de	e2438143-6017-4683-a533-6113748d4117	\N
18e6085e-c262-4b5d-8c90-456a2fede68b	t	f	2022-01-24 00:00:00	\N	5027e4f7-6222-46bc-8972-6e76a136c3bd	b7440787-50bd-4e41-b38b-48acf37af0de	e2438143-6017-4683-a533-6113748d4117	betreut K5
ded825f7-c72c-4a66-ba66-0a7a7d065b27	t	f	2022-01-27 00:00:00	\N	b2736bf3-6d33-439a-906b-d19ed002190b	b7440787-50bd-4e41-b38b-48acf37af0de	a5302a2b-d270-49e5-9876-47c84cb38038	\N
07339662-3fb8-4def-ad79-ee1b90117609	t	f	2022-01-28 00:00:00	\N	7e1bb369-f7fd-4182-8a78-60964391c46d	b7440787-50bd-4e41-b38b-48acf37af0de	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	betreut K6
756d6695-f5d1-4d02-9380-bf0493c52177	t	f	2022-01-29 00:00:00	\N	4d82dad7-7c7e-476a-bdb2-7a7a52d7ac6f	b7440787-50bd-4e41-b38b-48acf37af0de	a5302a2b-d270-49e5-9876-47c84cb38038	\N
17f7ed34-d962-4748-a531-fbc92ed61244	t	f	2022-01-29 00:00:00	\N	f255be7f-d6da-42f8-97b0-80aefbbfd52d	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	\N
583d881a-f4cc-4db8-9555-81b04b9fde4e	t	f	2022-01-29 00:00:00	\N	6b94806e-bc8f-4ea0-99b9-5397759bc338	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	\N
1cf6483c-4981-41fb-be23-79e8c6a905ee	t	f	2022-01-19 00:00:00	\N	825576b7-1723-4c59-ab5f-1a4fd04c0d72	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	Leiter K3 Turner, kein Barren und Reck, Danke
91837aad-3d46-4a4e-9e60-2fa73c57cc24	t	f	2022-01-30 00:00:00	\N	6b444e83-c271-4879-8b02-367cf035ca96	b7440787-50bd-4e41-b38b-48acf37af0de	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N
d4d894dd-487a-4dd6-a42a-d790dba7483e	t	f	2022-02-01 00:00:00	\N	55407925-43fe-43cc-aa02-fb647b012dfc	b7440787-50bd-4e41-b38b-48acf37af0de	2fc3365b-34d9-4054-b2d8-aa859c7455e7	Bitte einsetzen, will Brevet 2 machen!
a27139ec-85cf-4367-94f8-bcbc11dd8593	t	f	2022-02-01 00:00:00	\N	e49bf978-0b2a-4156-9d23-f360306d442d	b7440787-50bd-4e41-b38b-48acf37af0de	c0a6c2eb-1278-42b5-8aba-0426f3550863	\N
502d0064-4c0b-48e0-b65d-5c7fd8e98743	t	f	2022-01-22 00:00:00	\N	7a330c16-06a5-428c-a46d-1b70bdd2ec56	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	turnt selber K7 / bitte einsetzen
4785cff0-bf47-4cfd-814a-bc5377f4f1d0	t	f	2022-02-01 00:00:00	\N	77ecdfbf-9452-4404-92c1-fa0841e51591	b7440787-50bd-4e41-b38b-48acf37af0de	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	Statt jeweils einen WR Brevet 11/2 stellen wir wie bisher 2 Brevet, da dies bis anhin so gehandhabt wurde (aufgrund keiner aktuellen Lösung Brevet 2) und 
861cf626-9f0d-487b-9c88-efad58d61deb	t	f	2022-02-02 00:00:00	\N	2e0b35ff-c539-4f6e-995c-f937202c9f88	b7440787-50bd-4e41-b38b-48acf37af0de	d48095c7-3de5-4a8d-b893-b8d432e7c647	bitte K1 oder K2 und wenn möglich NICHT Barren/Reck
342b8bfd-d1a6-4635-a2b7-6f772285822e	t	f	2022-02-02 00:00:00	\N	2155cb46-c288-46f7-afa4-6637e6f35b60	b7440787-50bd-4e41-b38b-48acf37af0de	0a9d4719-903b-4f31-9e00-10fc47c954fd	\N
9d361e48-8d67-41b4-9ab0-e3f17e0c531c	t	f	2022-02-02 00:00:00	\N	1fc9ff0c-1fe2-4028-9db8-818b0fce6e4c	b7440787-50bd-4e41-b38b-48acf37af0de	a3895837-7bb9-48fa-afd0-b88c1edc7a95	\N
1bd5f626-d4dc-445c-9b5e-e6a745797199	t	f	2022-02-02 00:00:00	\N	3f855bcc-e320-4346-b97b-ab7c74bb9e35	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	\N
6f2d81df-da72-4d60-8d11-2a5769da8652	t	f	2022-02-02 00:00:00	\N	675c7652-6162-4b89-bd73-dccb3ab657dc	b7440787-50bd-4e41-b38b-48acf37af0de	cfb35447-962b-479e-af0e-2f95dfbc9fde	Bitte ohne Sprung und Barren
094335ff-85c5-4c62-9be9-858789db39a0	t	f	2022-02-02 00:00:00	\N	3f161f1d-4285-4694-aa13-842425295826	b7440787-50bd-4e41-b38b-48acf37af0de	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N
c0928f93-bb0d-4590-88a6-46f1dfa363cb	t	f	2022-02-02 00:00:00	\N	24f02407-5cf2-4384-8ea3-ec5292ce4a72	b7440787-50bd-4e41-b38b-48acf37af0de	773a0356-9c76-4dfb-8c56-c1693ee2819d	Bitte kein Barren (und auch nicht Sprung, wenn es geht)
ff253a7d-494b-4cce-a2bf-59d43e53da77	t	f	2022-02-05 00:00:00	\N	7d656112-7de1-4c76-80ba-162e24bf4a0a	b7440787-50bd-4e41-b38b-48acf37af0de	08bfbb88-e782-4169-83fd-17b0fd03da18	\N
cc77dde9-ad1f-4788-9053-fe9e3097162c	t	f	2022-02-03 00:00:00	\N	70870a17-d0c2-45be-ab72-3a819b3c7673	b7440787-50bd-4e41-b38b-48acf37af0de	773a0356-9c76-4dfb-8c56-c1693ee2819d	Falls zu wenig WRs vorhanden, könnten wir Leandro Gschwend als 2. WR stellen
08bd781f-d378-4420-b5df-b8b9140d20f7	t	f	2022-02-03 00:00:00	\N	adae4dae-17b4-44cd-8faf-d6a6d6eafb36	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	wenn benötigt einsetzen
c4ff8233-aed9-44a3-8765-dc2bb399d897	t	f	2022-02-03 00:00:00	\N	3680433a-ff79-4a68-9715-44563de86317	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	wenn benötigt einsetzen
03f8a121-3b11-437f-959a-09c0dc1bfe5e	t	f	2022-02-03 00:00:00	\N	ac5bbd7b-726e-494b-8144-50035114a9b5	b7440787-50bd-4e41-b38b-48acf37af0de	6cd2dec1-6466-4eb1-970b-81420914a9ed	\N
9f862e74-a27d-4120-9fcb-e461bbcdbdfe	t	f	2022-02-03 00:00:00	\N	3b2954f5-a0c6-419a-8e5b-0e48dc81f042	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	wenn benötigt einsetzen / KEIN Barren / KEIN Sprung K1
5cc34de9-9d83-40a6-af19-e536328ae092	t	f	2022-02-05 00:00:00	\N	0f817251-d3f2-4616-8ae7-5c6a1c67eb0e	b7440787-50bd-4e41-b38b-48acf37af0de	852ccab3-35f6-4d12-815c-d8b66ff664b7	\N
54690c94-7f17-4d51-b4a9-f54a6d86cdba	t	f	2022-02-05 00:00:00	\N	04d35523-c7ce-47cf-bf63-b9f35e991760	b7440787-50bd-4e41-b38b-48acf37af0de	852ccab3-35f6-4d12-815c-d8b66ff664b7	Kein Sprung!
035abe47-ddf0-47fc-b6de-89a79bb89aaf	t	f	2022-02-05 00:00:00	\N	4b6e6eaa-24d4-4cec-9ed0-be4380718b80	b7440787-50bd-4e41-b38b-48acf37af0de	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N
da4ffb67-c126-4576-a4c0-d0b355a5541f	t	f	2022-02-07 00:00:00	\N	c43e58b3-e4b5-4fd5-a470-ad57d7bdf1fe	b7440787-50bd-4e41-b38b-48acf37af0de	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N
cc904f6e-9751-4ff3-9966-a528eabf6202	t	f	2022-02-07 00:00:00	\N	7da403e9-57fe-4ce7-84c0-27de44901373	b7440787-50bd-4e41-b38b-48acf37af0de	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N
d0f09620-f1bf-4ca1-b5e4-8269641903d4	t	f	2022-02-07 00:00:00	\N	c43e58b3-e4b5-4fd5-a470-ad57d7bdf1fe	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	Betreut K4, turnt KD
4e7af4bc-a901-4c10-b7c7-d79699e0f3c9	t	f	2022-02-07 00:00:00	\N	41caa163-7800-48d8-b8a5-30bedc6d861d	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	Betreut K5
aed8de45-a7df-488e-bcb5-30ccfb8e5261	t	f	2022-02-07 00:00:00	\N	e84bd253-96b9-43d4-846d-3894e82f6f02	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	Betreut K1
9ad061a0-35cd-486c-92ac-0fabbff8433c	t	f	2022-02-07 00:00:00	\N	f262a7de-3583-4ea0-b3f8-9003b8e0ee88	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	Betreut K5 und K6
01c1be1a-87c7-40b3-8068-983dab3280ee	t	f	2022-02-06 00:00:00	\N	3f161f1d-4285-4694-aa13-842425295826	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	Würde gerne noch K3 betreuen (SA Nachmittag würde auch gehen)
1dcd4104-82e4-4c7b-b86d-235d721c5d6e	t	f	2022-02-07 00:00:00	\N	ae021822-4388-4357-b2be-badd7ad52a12	0fa002f3-d432-46d4-a753-991d021db3fa	5ee987b5-deec-4087-b36f-bba4dcaf842f	K5B, wann auch immer diese turnen
5791231f-242e-4d58-bbb3-c76017c8196d	t	f	2022-02-07 00:00:00	\N	6be7499e-9c16-45e1-8741-aac41b19835c	b7440787-50bd-4e41-b38b-48acf37af0de	97cf3158-df81-45c1-b49e-47a692438dca	\N
3c9c0d0f-9f01-4e6d-b463-d8bffd400dd1	t	f	2022-02-07 00:00:00	\N	b476230f-9903-47bb-b2ed-20ec9c1cf194	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	Gerne einfach Sonntag, Töchter turnen K2 und K4
cf0fffad-847f-4d5b-80cc-e7297a0ff682	t	f	2022-02-11 00:00:00	\N	18f9b3d2-e879-4158-8c00-389eae8ef91d	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N
69573f3c-1559-4b4f-aca9-5cd034f9489c	t	f	2022-02-07 00:00:00	\N	8502503a-3bfc-4e21-87b9-dad1b87cdb87	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	Gerne einfach am Samstag. Sie turnt evt noch Kat Damen (Für Regensdorf)
247a6558-8647-4d7e-a4cb-71176148785d	t	f	2022-02-07 00:00:00	\N	4cd13020-4b58-4685-84c8-f1783f45d361	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	Wenn möglich bitte K5
1b66b383-edd3-4339-9d69-b513d94b0013	t	f	2022-02-07 00:00:00	\N	7da403e9-57fe-4ce7-84c0-27de44901373	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	Betreut K1
8e9372da-4728-4296-8239-c12c7144381e	t	f	2022-02-08 00:00:00	\N	c9189cbd-6a02-40a1-8ab0-12f62fe3ab86	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	Turnt selber im K7
22e579cb-18bd-4950-8213-aefedf8301e7	t	f	2022-02-08 00:00:00	\N	3ebfa3a6-812c-4d17-bcf2-9a493fcb7798	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N
13ce9367-b3f2-4c7f-b272-57ecae6f930f	t	f	2022-02-08 00:00:00	\N	35e7e6fe-5d65-4d2c-aa85-f4a127c8a74a	0fa002f3-d432-46d4-a753-991d021db3fa	24510313-6d39-4217-bb3f-0bfa7fbb73d3	\N
00b4bf60-cab2-4728-92cb-a60dc1cec6dd	t	f	2022-02-08 00:00:00	\N	fa0e3750-34e6-493d-b3fc-d93b7506ab14	0fa002f3-d432-46d4-a753-991d021db3fa	24510313-6d39-4217-bb3f-0bfa7fbb73d3	\N
7074e768-4d30-4315-bec2-2f4510cb2e98	t	f	2022-02-08 00:00:00	\N	5d5d4b80-7009-4b03-950a-be4e5e97ac7c	0fa002f3-d432-46d4-a753-991d021db3fa	24510313-6d39-4217-bb3f-0bfa7fbb73d3	\N
92f554f2-a06d-4468-b2e3-2efebad5ae6d	t	f	2022-02-08 00:00:00	\N	34da2c5f-0c4f-401f-b817-de9ce9f25db7	b7440787-50bd-4e41-b38b-48acf37af0de	97cf3158-df81-45c1-b49e-47a692438dca	\N
44f10bde-2bd7-4a7b-bcac-f3e4ea59d04c	t	f	2022-02-08 00:00:00	\N	17f95695-7deb-49cb-b14a-f73e44619c78	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	eher tiefes K, da neu brevetiert, betreut K1 GeTu Mettmenstetten
70376fb9-c9ab-42f0-baf3-f357069a96d2	t	f	2022-02-11 00:00:00	\N	9fd52c08-46a8-4c08-a6e7-4ee7f4995d9d	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	Betreut im K5A
1b66533c-afe7-456d-93a6-81ff1b0227af	t	f	2022-02-08 00:00:00	\N	5446d58f-3a93-41bc-8018-b792df6f463a	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	betreut K5A, frisch brevetiert
bdee0977-41a3-489c-a465-42e859a72dd0	t	f	2022-02-11 00:00:00	\N	9a3ee8f2-8195-4557-8648-26f45f3bb029	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	z.K.: Turnt selber K7
336ac71d-a21e-4294-a17d-53d9bff90404	t	f	2022-02-11 00:00:00	\N	f66694e8-2f3e-492d-b9b4-9a2e5b7066c3	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N
3fbb489c-1118-4bae-922e-efc644541ab8	t	f	2022-02-09 00:00:00	\N	d48a2241-8a41-403a-989c-d408bdbed5e4	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	Betreut K5 und K6
4f58417e-590e-446b-81d9-e28859fe271a	t	f	2022-02-09 00:00:00	\N	9926f56b-418a-4484-8b06-83d8b7dcec50	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N
4b8c81a9-e1ac-463a-bfb4-d4bebab07d4b	t	f	2022-02-09 00:00:00	\N	8fbdbec6-80f0-47a5-94d5-5d02fda96258	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	Betreut K2, Turnt K7
0582f1f6-4b03-4f16-8368-78b56e2c6c1f	t	f	2022-02-09 00:00:00	\N	1c65ffb5-f1ce-4979-a2ce-bb0ac54f6ffc	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	Betreut K3, Turnt K7
6f9da826-99ee-47a5-a4f2-ec3af36f5563	t	f	2022-02-09 00:00:00	\N	d716fa96-59e6-46c7-90a1-32583e8a4253	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	Betreue K1 und K7
b8dc7d4e-2635-4ff3-a179-fe8733a2db71	t	f	2022-02-09 00:00:00	\N	3e91824b-6148-4d3d-b1f8-d0cd67755424	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N
2d892a13-97cb-4294-8224-9a14afa09b48	t	f	2022-02-09 00:00:00	\N	387da566-0489-4a69-afad-5e392ace964c	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N
e98060a2-3819-42f2-baac-29d82d3947cb	t	f	2022-02-09 00:00:00	\N	cc500728-7e8e-4266-a2ea-3b21f26a314a	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N
996e7fea-fb70-46bf-aa49-6c8f41709674	t	f	2022-02-10 00:00:00	\N	413f0fe6-ffc8-49c5-ae71-1ff527b8930b	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N
b262bec5-2c7c-4972-99e8-3674fcb4b01b	t	f	2022-02-10 00:00:00	\N	faf769a3-47fa-4c20-b65c-24ddff3abd01	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N
9b07fb5f-4091-40d0-b975-cb31ab1f6c32	t	f	2022-02-11 00:00:00	\N	086863f5-5162-464d-8399-f3835f80e0c4	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N
6793d40a-b3eb-48b4-8f15-665e3d292727	t	f	2022-02-10 00:00:00	\N	e8bb3a4e-ff5b-4d60-8e37-f2358c646077	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	K5B wäre super, ich muss leider K5A,K6, K7 und KD betreuen
e400afb7-6c40-46d8-bff8-f385ac801726	t	f	2022-02-11 00:00:00	\N	07a30ce1-69bd-406a-9f46-5b790f2b5f77	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N
42134a31-3031-4487-8721-acd8028f0e6d	t	f	2022-02-10 00:00:00	\N	5412961e-cf30-44ea-b9a0-7679e5306204	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	Turnt im KD und betreut K3
1ba949f2-1af2-4dec-8f02-95db8b57229f	t	f	2022-02-10 00:00:00	\N	1a5f4d6f-76de-42e3-9ad5-0356eee2509c	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	betreut K3
43080818-2400-4c34-88f5-798f1eae2995	t	f	2022-02-10 00:00:00	\N	ca42885f-89a4-4adc-bcda-dacb79920c8e	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N
e5e2bec4-0a36-4f9c-8199-96d13e519e1e	t	f	2022-02-10 00:00:00	\N	925ac1e2-e8e7-4054-bb57-5f54a875ccb0	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N
1bb55fff-f3f3-4026-9470-618519526d9c	t	f	2022-02-10 00:00:00	\N	d64acad6-ca2f-4c2b-8407-854d9c3ba060	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	betreue K6
626ad883-909c-4c63-ab9f-50197d3a384f	t	f	2022-02-11 00:00:00	\N	d734e36d-7232-448e-91c5-55fad3c1eee4	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N
5037db19-1751-4651-b3c0-2bae80ae50f9	t	f	2022-02-11 00:00:00	\N	19f95456-20f4-41ac-8d1d-c047fddcd9c6	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N
68ad76a1-1016-419f-af87-6862b41749a0	t	f	2022-02-11 00:00:00	\N	0adbd46d-ce5d-4575-9c3b-1d20aab14b6d	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N
886270b3-5437-464a-9fc5-6cad6d66162d	t	f	2022-02-11 00:00:00	\N	122aa0eb-e096-45da-b679-cafebbcd1048	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N
1d8eb448-dc0a-4f62-9e35-5cc388be8304	t	f	2022-02-12 00:00:00	\N	4b6e6eaa-24d4-4cec-9ed0-be4380718b80	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	Sie turnt im K6
c976aab7-06bb-4500-8bf2-cbcb377a2300	t	f	2022-02-11 00:00:00	\N	be60e1fb-63e3-480e-9209-33d106a95c44	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N
9719a2eb-974d-4635-87c3-25895f7e7bee	t	f	2022-02-11 00:00:00	\N	611a1bed-57b2-4f8e-b0c0-9c7ce15d8719	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	Bitte nur 1 Einsatz, Einsatzzeit ist egal.
8e356174-7b58-4de7-a64a-21c6d9616b3e	t	f	2022-02-12 00:00:00	\N	83e5c48e-15ca-442d-afee-668be11d8226	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	Sie turnt im K5A
ca42eca4-90d9-409d-aab7-d47456dd193b	t	f	2022-02-12 00:00:00	\N	6b444e83-c271-4879-8b02-367cf035ca96	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	Sie turnt im K7
439c1035-8b0d-48a2-95f6-d3efab665327	t	f	2022-02-13 00:00:00	\N	01a7df2f-6a9e-41db-a75e-71f30171f44b	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N
d67d8bff-edf1-4f3f-b299-918f6d9accf1	t	f	2022-02-13 00:00:00	\N	5c5f951c-ba41-40f2-893c-18f00900313a	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N
6e94b134-fc2b-402a-9ded-1bfebe5a6b9e	t	f	2022-02-13 00:00:00	\N	d426b797-6389-4b27-a696-69e1a231abb3	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N
f632f62b-0b42-4a70-b6d7-e1cdee77a5d0	t	f	2022-02-06 00:00:00	\N	24f02407-5cf2-4384-8ea3-ec5292ce4a72	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	Würde gerne noch K5A betreuen (SA Nachmittag würde auch gehen)
b0d53d4c-6380-42c6-96ed-a2c3745250f6	t	f	2022-02-13 00:00:00	\N	5eb2361a-e95f-49ab-8d15-b77d00fc7e1a	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	Würde gerne noch K5A betreuen (SA Nachmittag würde auch gehen)
da660b30-6cca-4ba7-acc0-99decb7c7e34	t	f	2022-02-13 00:00:00	\N	2444be84-b6d3-4cab-bfbb-3b95432db6a0	0fa002f3-d432-46d4-a753-991d021db3fa	a0ea91c8-f018-424b-ac69-1246f657d591	\N
3e2b594a-048a-40e1-b414-b10258e3666e	t	f	2022-02-13 00:00:00	\N	2aa32e66-2896-465a-9e71-df92dbcbca3e	0fa002f3-d432-46d4-a753-991d021db3fa	a0ea91c8-f018-424b-ac69-1246f657d591	\N
0eac64c8-2dd3-464b-a74f-a55e46b0bfec	t	f	2022-02-14 00:00:00	\N	d66be606-f1a2-4202-8b68-41ce7630ac2f	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N
097e5123-5792-4f6b-89c5-6a6e61660fa3	t	f	2022-02-14 00:00:00	\N	d2296a55-2592-4eb9-884d-2ab5fc33b3d6	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	betreut noch K2 vom Getu Bülach!
4ce18dd6-8871-4046-977f-717416c230eb	t	f	2022-02-14 00:00:00	\N	2193264e-d362-4d75-a51b-b319dea02438	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	betreut noch K4 vom Getu Bülach
3e7646df-1fda-48ec-b944-7f563a83e988	t	f	2022-02-14 00:00:00	\N	9381b75b-ffcf-46c5-9485-3de896616db3	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N
2ad86532-88bc-4ef9-825a-5531788f873d	t	f	2022-02-14 00:00:00	\N	e2fd5aa9-6922-4c05-8731-b4481a0e30db	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	nicht gleichzeitig mit K5b
60f8d738-c772-42c9-b56e-c2c8df4a6e43	t	f	2022-02-14 00:00:00	\N	cf04baca-a6ab-4fa6-93fe-c8037aed6416	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	Nur ein Einsatz, entweder Samstagmorgen oder Nachmittag
8c364168-8d02-4e31-b13e-b711e8cea713	t	f	2022-02-14 00:00:00	\N	9eae4f57-ddac-436e-8c44-0861545cefe5	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	Nur ein Einsatz, entweder Sa Morgen oder Sa Nachmittag
cb2105b1-b557-4977-9a4b-178d078b795d	t	f	2022-02-14 00:00:00	\N	a0b2aeeb-9488-48c9-8763-5879c9852478	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	Sie betreut K5b.
d38a94c4-7560-4106-9c40-7820371e8d26	t	f	2022-02-14 00:00:00	\N	3f56cd5a-ed1f-488b-aac7-752be8053a11	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N
16244b18-572d-48ba-8431-6062973fd593	t	f	2022-02-14 00:00:00	\N	e422a46c-df51-4aa4-bb5c-9b5b5f29e67d	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N
44f81af6-cb08-4bb7-84fa-58836898f10f	t	f	2022-02-14 00:00:00	\N	93851cba-8452-4b98-a25c-972fdb42c5cd	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N
fd905cd4-e3d6-4454-b8ba-eaa61a453f77	t	f	2022-02-14 00:00:00	\N	a8528c10-1ca9-4de5-8c0b-54b4e2702872	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	betreut K4 
\.


--
-- Data for Name: rolle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rolle (id, aktiv, deleted, change_date, deletion_date, name, beschreibung) FROM stdin;
80666be2-b9f3-46bd-80e0-1516fdba530f	t	f	2022-01-09 00:00:00	\N	BENUTZER	Basis Rolle
00fd1b3d-1eef-46ad-afc9-fa009ac24bd2	t	f	2022-01-09 00:00:00	\N	ADMINISTRATOR	Administrator
cf79ac25-e412-4561-9bcb-4f392a11ca18	t	f	2022-01-09 00:00:00	\N	VEREINSVERANTWORTLICHER	Kann den Verein verwalten
d3da3664-0d4d-42e6-9581-366691c82ea6	t	f	2022-01-09 00:00:00	\N	ANMELDER	Darf Wettkämpfe anmelden
0f586f41-d58a-4381-936c-0e9f589a2573	t	f	2022-01-09 00:00:00	\N	WERTUNGSRICHTER	Wertungsrichter
\.


--
-- Data for Name: rollen_link; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rollen_link (id, aktiv, deleted, change_date, deletion_date, rollen_id, link_id) FROM stdin;
9f3fc7bb-49a3-482d-9348-35890ff5f5b5	t	f	2022-01-09 00:00:00	\N	00fd1b3d-1eef-46ad-afc9-fa009ac24bd2	d6cc188a-e2e8-4304-a4da-8b8565883a24
8910d717-d130-482b-82b2-7addeabcd365	t	f	2022-01-09 00:00:00	\N	00fd1b3d-1eef-46ad-afc9-fa009ac24bd2	89e2abc1-01ee-497f-a3b5-ecfabacd1299
e6be80ea-09c7-480f-a0f5-1eb796a9bd9b	t	f	2022-01-10 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	5915e3b5-84ad-4cd7-95d4-38a9cf0179af
a5386078-611c-426a-ab03-3d1e6dcd9c42	t	f	2022-01-10 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	5915e3b5-84ad-4cd7-95d4-38a9cf0179af
215f4d2d-6b81-41f6-9bb2-d70e544138d7	t	f	2022-01-10 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	1e5081d2-0287-4a00-bcda-99e1fe1a44b2
444a6700-fd66-45a1-b048-1e8d2d8a4677	t	f	2022-01-11 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	f9a421c3-fe03-4981-be64-9074e2ad2548
cd139961-2487-4dfe-9212-586e0fd8a08f	t	f	2022-01-11 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	f9a421c3-fe03-4981-be64-9074e2ad2548
fbff4afa-2345-49aa-99fb-ae6b88f9e7f3	f	f	2022-01-11 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	9ed5d386-6b81-4a69-82eb-2fc67351d3d3
b1f3ff69-dcf5-4a94-bd0a-81a6803d3cc3	t	f	2022-01-11 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	a96d9cac-e8c6-41f9-a081-99b30d2e05d5
676f9e8b-f3f1-4d7a-a7c3-3d1ecb2a20a3	t	f	2022-01-11 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	a96d9cac-e8c6-41f9-a081-99b30d2e05d5
e1234782-d859-41b1-a370-a45cc5346b24	t	f	2022-01-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	a96d9cac-e8c6-41f9-a081-99b30d2e05d5
2b2b5b6e-59f7-473c-aac6-704889bc89eb	t	f	2022-01-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	c780aba6-de04-41e6-a739-5c4267005dd7
1048c23f-2a11-4d9e-a608-be7f51612ca4	t	f	2022-01-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	432cb098-1725-4ee9-bfd1-32cdb25b2f3d
adf34961-c2cf-4735-b413-c6a038d64c96	t	f	2022-01-11 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	8f4a7d90-862d-4ff3-9670-3073f698950e
33c2c46a-da23-40cf-a6eb-f0a5456143c0	t	f	2022-01-11 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	8f4a7d90-862d-4ff3-9670-3073f698950e
2815321b-8a08-44a5-8a56-a7e1ba1da408	t	f	2022-01-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	33977204-3c0c-49d8-911e-b2746722f627
3036c600-4293-425b-beb7-f9b0dbc10c3f	t	f	2022-01-11 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	33977204-3c0c-49d8-911e-b2746722f627
480adee6-3f92-45c6-92ba-13c11ae3135a	t	f	2022-01-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	8f4a7d90-862d-4ff3-9670-3073f698950e
12984301-8974-4150-8e9b-a6a4c8e64a5a	t	f	2022-01-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	d8ee77f5-1aab-48ae-bf08-a27be72f8b6d
dfcab560-e2fc-48ba-bdf9-2177154a3ce1	t	f	2022-01-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	9358b718-d720-4dd4-b6bf-6bfe6f484574
176541ea-b838-4b75-8c0e-ed3aad7a9d79	t	f	2022-01-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	bfe4df3e-8156-4c4d-9ec8-a7638ebff2ca
622b9d4b-63a9-42e4-99de-bcb860a52087	t	f	2022-01-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	12a647ba-3464-4912-950b-242b1ccbcb99
fcd1ea7e-ff73-4595-96f4-d97581a465ca	t	f	2022-01-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	8286c3c5-bde9-4e0c-bd8e-6dce5b3d5e52
ba51df53-ad02-4976-ac3f-4a9f6beaceb8	t	f	2022-01-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	e53512c1-fbbe-42c9-b2b3-1d23abc2f638
5a7c0458-9dd2-4df9-881d-8f0609d8ac58	t	f	2022-01-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	e6f59633-2135-4198-affe-d2cdf3f04cac
2924ebb5-00f7-4a22-8812-ac5ee74cd9e2	t	f	2022-01-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	166be6dc-d526-4acf-8c2c-62c309dcc701
ec63f3ee-bbcf-4378-88fd-78216fb5f74a	t	f	2022-01-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	bf94e9d5-5d49-4a65-9edb-81b27cff9716
7968af35-23f4-4b2e-8b3d-97dff5ed4c13	t	f	2022-01-11 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	40add39a-c0db-4dee-a1bd-ea1cee30d266
35037de7-9ce4-4b5f-a720-3674a4f9ca70	t	f	2022-01-11 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	40add39a-c0db-4dee-a1bd-ea1cee30d266
2a03a609-8dd4-400e-a7d5-03823bd7f52d	t	f	2022-01-12 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	cb5cbd54-8bb8-4a81-9450-173b5fe7f089
eef36309-8d58-4bef-9893-fcf870262842	t	f	2022-01-12 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	cb5cbd54-8bb8-4a81-9450-173b5fe7f089
95f8f735-27e1-423e-8047-c81378ec9a93	t	f	2022-01-12 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	cb5cbd54-8bb8-4a81-9450-173b5fe7f089
5a49f769-d1c9-4a48-a112-e84aa62b89e7	t	f	2022-01-12 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	8d292d7e-8467-4a36-9b51-9963b15bf858
b7ede41a-fe94-4c4d-8214-52667d9be251	t	f	2022-01-12 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	8d292d7e-8467-4a36-9b51-9963b15bf858
4752bac1-3a45-4b4e-a596-731b42ffc890	t	f	2022-01-12 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	9cf77b37-620f-40da-acfe-9a13e9831168
b5e164ef-42d2-48e4-9dd6-5d39171d0669	t	f	2022-01-12 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	9cf77b37-620f-40da-acfe-9a13e9831168
33e3f0d7-2208-48d0-ac90-e3164334850c	t	f	2022-01-12 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	63bbf548-7a5e-4c36-9019-5aa84a4b7da5
dbba4d17-ffa0-40b1-90b8-915bc20ebac1	t	f	2022-01-12 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	5915e3b5-84ad-4cd7-95d4-38a9cf0179af
aea1f6bb-f411-46db-9e02-911cfe5a179b	t	f	2022-01-13 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	1f609a4b-1735-4af9-b895-32701bf19818
c56f6cdf-f405-4935-8d8b-d963ff578167	t	f	2022-01-13 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	1f609a4b-1735-4af9-b895-32701bf19818
9e664f44-61ff-4c94-9a54-ee7cee258670	t	f	2022-01-13 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	cbcc8ef4-a54b-4989-9010-cd6d5a4c98f0
7b0cb52e-a867-4380-972f-9f2d6f1c9ac8	t	f	2022-01-14 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	8ae012fa-c4b0-4ee3-bfcb-2305217f4508
1cc5b902-06b5-4c8d-add0-c78b0af98557	t	f	2022-01-14 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	8ae012fa-c4b0-4ee3-bfcb-2305217f4508
16d566aa-9424-4896-948d-ab6a433f75ac	t	f	2022-01-14 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	38f191e2-492a-4e86-a8f1-c151cc5357b1
e421e8a2-d9a9-430f-95cb-0b34977cd6aa	t	f	2022-01-14 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	38f191e2-492a-4e86-a8f1-c151cc5357b1
a2b7c6c8-981a-4253-bdf4-d4f89f0af55b	t	f	2022-01-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	38f191e2-492a-4e86-a8f1-c151cc5357b1
b7e3d2fa-024b-424d-90d4-facca18e703d	t	f	2022-01-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	581c4f03-2c82-4e8c-aa21-08ee4582f254
619e5f39-2906-4b06-8a42-e7c46eff17c0	t	f	2022-01-14 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	581c4f03-2c82-4e8c-aa21-08ee4582f254
91df0f46-cbea-4d3c-a02e-f4b682a6fb32	t	f	2022-01-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	350ee796-d7d0-42d7-9874-0d28c52831fb
9ec163b5-531b-42b2-b90e-11c543b9ca00	t	f	2022-01-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	a09628eb-3632-4ebc-96a3-409ad194ca5e
d1aa2cb6-5cdf-4169-859a-cf15906ad5dc	t	f	2022-01-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	12b84c72-db5f-46a7-b485-bcbdfb6aa317
8491d190-e374-4a40-8a19-ac4328435364	t	f	2022-01-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	69ea78ed-d5c3-4542-bb85-a5d86e16570c
311a2191-d617-4daa-b6fc-0982a980d84e	t	f	2022-01-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	521d4aca-ed34-4a24-9a58-2d7957d937d3
60be6cf6-022b-4089-a08e-48af2aefc474	t	f	2022-01-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	3228c93b-2fad-45ab-a9b7-041640bad3f0
a2aadc9c-af02-440a-811f-b2ea4e3eed80	t	f	2022-01-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	811580a0-6b48-4186-9b6e-f27edf41fc49
58212e97-ecb5-4061-bfaa-43ca29b50ca7	t	f	2022-01-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	1214e9aa-648c-4453-a15c-c08ed9db7600
1e1023d1-14bb-4c2b-990f-92f1ed217f13	t	f	2022-01-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	8bf615ca-4619-4d5c-9f80-0170450111ee
760d82f0-5ea3-467e-b7e5-ab2939f2195a	t	f	2022-01-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	3a27ce45-b6d8-4b6c-bb31-cd8fde65c7ed
e9d8e30d-b3d8-47d2-a618-25834050e235	t	f	2022-01-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	78497b7f-aad9-4e8b-86c8-cf68ac2d68ba
80209f39-5d50-496c-956e-79bdb12b608f	t	f	2022-01-16 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	65ed48ce-30b4-4998-849c-3c309c33f7a6
0a07b180-493f-485c-977d-8a089ea71363	t	f	2022-01-16 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	65ed48ce-30b4-4998-849c-3c309c33f7a6
831706ac-3c0e-4b6b-bcd0-26e724e2e92d	t	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	5610263b-1691-49f6-af22-777ff5dbc51f
89078c81-4d12-4468-bd29-2d6654220030	t	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	f2750c32-0223-4384-82d2-4fcdad2f867b
46b9adcf-b697-4088-bfcd-694e98781fb6	t	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	de389304-d790-42f2-86b0-94b98e5ea5b3
b36e6fda-8c45-4e51-9e5c-b430b583bd19	t	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	bf284aad-c4df-436c-a9c5-ae3395d7b481
76cddd66-805d-4700-92ce-6cb50b300e50	t	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	da80b1c3-b6b6-4170-a58c-d3dc279e5a36
f9297c90-31ff-4c3f-9ed3-10676edb8346	t	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	6218d6c1-d190-49cf-b5e2-90fcb49d1632
c29ea1f6-07f5-4c7e-8262-41fe0333c005	t	f	2022-01-17 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	5610263b-1691-49f6-af22-777ff5dbc51f
496e1d3e-5b1f-4bbb-8f32-41c4aa8b2723	t	f	2022-01-17 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	5610263b-1691-49f6-af22-777ff5dbc51f
52f9738b-d4b3-4ab4-b8b5-66d5e01b4c27	t	f	2022-01-17 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	fc9a1b2e-28ea-423a-84d3-70b6c70268d2
27a5bf76-38c3-4035-8833-ecd1cf163dcc	t	f	2022-01-17 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	fc9a1b2e-28ea-423a-84d3-70b6c70268d2
6dc25a83-a618-4d35-8a72-60ed2373561d	t	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	5b774204-c7a3-472d-99da-b3fbdf7efc48
1024a12e-8d6d-41b2-84d4-e364a1f35cab	t	f	2022-01-17 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	abd2935b-5253-47e4-a80f-907fd4ea169f
b8563873-7021-460e-b945-73db62369dc4	t	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	abd2935b-5253-47e4-a80f-907fd4ea169f
3ba5044a-a36c-47ec-b9e0-287903d01589	t	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	7d0fbaa0-89d1-4c99-8b93-5edb561691cc
a3f78b67-1866-42c4-ae31-ca5f39f6ce66	t	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	fc00113c-f6ac-40c3-8448-b753005dff57
25e35adb-c473-46c0-93ab-03f65a5975af	t	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	0a232d4b-5fdc-4097-bf4b-878ca991f348
3c7a6270-07de-4d83-828c-01bce813f9a6	t	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	d572503f-c208-4701-bde0-5ac7524b824f
69fc9190-fc6f-4ae4-a486-24911ccc7862	t	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	affaa614-e361-415b-b9c6-955e47290b03
4ecffada-02d7-4ef6-991a-4cb29fb64b79	t	f	2022-01-17 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	e1f862c7-d57e-4c54-8ff2-71e4a13ded73
73467fbc-50df-4201-817f-f02ee6333470	t	f	2022-01-17 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	e1f862c7-d57e-4c54-8ff2-71e4a13ded73
8fa97fc9-0beb-434b-9748-2dfd53efd418	t	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	e1f862c7-d57e-4c54-8ff2-71e4a13ded73
a7be8de6-e001-424d-9992-8b3889c27530	t	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	e168f0c7-5ded-4d70-8b23-cc2d903a4709
827a9b3c-7dae-48a3-bf28-db272072a40b	t	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	f3f06119-3b39-4dd9-8af5-c09b5dd01e05
f9bc7b3f-027f-42e0-95de-604315cbdd8a	t	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	12dc16f7-18ba-4ebf-81ac-1af7e4f2e771
055e626f-d4fa-46b2-b43d-32c37fac77a2	t	f	2022-01-18 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	3d86255d-d077-40f0-8186-1a91b1386fcf
bee12d92-3d04-4132-ba76-b6b99705233d	f	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	2ae27d51-f415-4a27-9f31-fa4fd15e4a64
d6fe1a69-8d71-4618-91c3-866245e8e39a	t	f	2022-01-18 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	5156a07f-fada-4501-b66c-a1b092091572
eaaa3c9e-5eae-43cf-ace5-31a105cf8c78	t	f	2022-01-18 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	d9e9d3dc-58d6-4db5-93c9-2b89fbf6cd79
9ad1b15a-4790-4d0f-aa21-c3c3ce49461c	t	f	2022-01-18 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	41ce08da-3362-46cb-90e4-8d361359fd7b
bec60f49-6c86-45c2-b8b7-179b06d838a2	t	f	2022-01-18 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	19d9bee9-7c4d-4c5e-8eaa-8ac5051c935e
ef4b406b-c1ed-4f59-bb57-f9ad45fa3894	t	f	2022-01-18 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	fcb2af13-aaac-4317-80eb-c998d203969e
86ec3af8-b0e7-4c1e-9215-5545993dbe50	t	f	2022-01-18 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	5322b62b-d666-4909-bf6e-859c4dc896f3
896f618f-9e84-43db-a30b-f2efd9b53456	t	f	2022-01-18 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	26b16a66-0446-485b-b81b-742031689c66
a8d29a65-9ccb-4e28-b13c-7f5e25db138d	t	f	2022-01-18 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	5fb8b572-ba16-4783-b7a3-0c67fb5318f0
a35d2c73-5dcc-45f3-84b7-6883ff58a709	t	f	2022-01-18 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	44e74cc3-2fc4-4426-b33b-ea6f3def3534
f4484c40-43d5-4749-bec9-412ac33d8aa0	t	f	2022-01-19 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	2a1626c1-e492-4e11-bb7a-a9e011e4055e
7ccc5fc7-b600-4353-a17a-833e09a37889	t	f	2022-01-19 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	2a1626c1-e492-4e11-bb7a-a9e011e4055e
e1ddb857-0306-44d0-9621-42907540d264	t	f	2022-01-20 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	5c595fd8-ec7a-4b34-9d26-e7794b13ba3b
cbe4fa3d-3155-4ab8-b479-9eabfc3e3a90	t	f	2022-01-20 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	5c595fd8-ec7a-4b34-9d26-e7794b13ba3b
35ca0a11-a238-4ac3-ad88-19d746a13a63	t	f	2022-01-20 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	976388b0-2272-47b6-9a47-546cbee65037
ced4ccb9-8fdd-4ca9-b438-c1e0410b9fe2	t	f	2022-01-20 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	8eeca7c2-18f6-4bbf-b5f7-183eb6087e32
ad193b67-35ed-4adf-b92b-d23e43d829bd	t	f	2022-01-20 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	8eeca7c2-18f6-4bbf-b5f7-183eb6087e32
710ab923-2f4e-4952-801d-e50bea685f6e	t	f	2022-01-20 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	e06ae247-6d2d-49cd-8a35-39c2b84a042c
772f10fb-602d-4f2a-88b5-e92fa570267f	t	f	2022-01-20 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	8eeca7c2-18f6-4bbf-b5f7-183eb6087e32
8aa1fe33-b187-44cc-804f-91e42ae109b6	t	f	2022-01-20 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	28a56b32-b102-4576-9aef-765e091efb53
5af2efd5-53b2-4c69-a30e-5f76ef3d5b78	t	f	2022-01-20 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	39fd204d-f2b9-4bf8-9a5a-3e4f6032cf28
a474e7b1-3b01-40ba-ae3f-ee76a990d076	t	f	2022-01-20 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	0da52625-65fe-4ff9-ab26-559be12c133c
bd9ba90b-24ff-42b0-a77a-c659ec71cd56	t	f	2022-01-20 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	13495f4c-b22d-459b-a26f-73581c7bb2f8
4df45b0c-a429-4c80-83b7-1f5e682588cc	t	f	2022-01-20 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	2f5f489f-b8d9-4bcd-a41a-894dce30ab6e
6acc93ac-a578-4c3c-ac6d-95026e045042	t	f	2022-01-20 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	2c712383-08e9-4086-ac52-68573bc7830d
3b926f22-e409-4b5e-9cc6-e60df9a27c25	t	f	2022-01-20 00:00:00	\N	00fd1b3d-1eef-46ad-afc9-fa009ac24bd2	7cfcdf0b-1bb4-4b4e-af69-3b6635048406
b1524955-d430-4af3-8f68-fdfdd1d83b99	t	f	2022-01-20 00:00:00	\N	00fd1b3d-1eef-46ad-afc9-fa009ac24bd2	b268e6e6-cd3a-4780-8ffe-ec0a6f4e74af
c015a622-9ea6-4e23-99c7-144f0dbfcfb8	t	f	2022-01-20 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	d9887dfb-e188-45ee-b9dd-266afeaf35b7
1f0cc1b4-a394-479e-9616-59bb0d816509	t	f	2022-01-20 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	c348e2eb-56d5-4f39-856f-050fde55dea4
c15ea309-21c5-4db0-a0e6-8d647ffef346	t	f	2022-01-20 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	c348e2eb-56d5-4f39-856f-050fde55dea4
1c6bd8e7-fa85-4353-a895-89f2a99b8cfa	t	f	2022-01-20 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	c348e2eb-56d5-4f39-856f-050fde55dea4
973e33e8-8d46-4386-926f-cd6648b1978e	t	f	2022-01-20 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	1abdcb47-935a-452f-a04a-a1b40b403b51
b47c6515-8578-40bc-8179-42f7ff64b5a8	t	f	2022-01-21 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	d689c5f2-37f2-4349-9d49-527b3f09ad30
c2c2970d-50f7-45e1-a49f-d45597a45a1b	t	f	2022-01-21 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	d689c5f2-37f2-4349-9d49-527b3f09ad30
e3af9fb6-b586-4ca4-8647-5f421f478a6c	t	f	2022-01-21 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	d689c5f2-37f2-4349-9d49-527b3f09ad30
7a86a292-56f4-4655-84a9-deff125daf1e	t	f	2022-01-21 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	b3022aec-0be2-4a86-83b0-488f1c608d68
60697888-29ac-4582-9dda-46ae726f0a85	t	f	2022-01-22 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	1c9ab38a-129a-4f33-897f-f6c15d4e9137
e8b3273b-fbd4-4022-a869-5669716991a9	t	f	2022-01-22 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	1c9ab38a-129a-4f33-897f-f6c15d4e9137
b4179adb-e5e7-484d-bee6-741e59e60ea6	t	f	2022-01-22 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	1c9ab38a-129a-4f33-897f-f6c15d4e9137
35823a4f-02dc-41dc-8896-396ca5c38f6d	t	f	2022-01-22 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	e998e276-6ebb-4813-b8bc-753b19a4ad25
56a99d0d-d0a7-4f07-9afe-74a46e039c6a	t	f	2022-01-22 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	83d8ffaa-6c5f-4d21-b885-cb4098e99265
b1609183-846a-4278-848a-0f50973f6a4b	t	f	2022-01-22 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	7bbf3bf0-7729-4936-b372-62051d64b4dd
1fb3ee05-33e8-4eed-a540-11bb35538560	t	f	2022-01-22 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	1bd57e0e-2bb9-4a83-9338-b22c550ad532
f4041f64-8b0a-4067-b4a5-6f60f494308d	t	f	2022-01-22 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	6682a28c-c467-4b7c-95fa-4f716daa2f3d
fe03e8cb-1bb5-4bdc-81e6-3827a28d1b47	t	f	2022-01-22 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	075ac35f-cfdc-4d1c-b299-97f0211a9167
13799bd5-0cb5-43ea-91fb-527ad803293d	t	f	2022-01-22 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	0d6df09f-3198-45a9-94f2-ebe2d844dbfd
6d6f03e4-5efa-4e07-a9b9-af9126b5767f	t	f	2022-01-22 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	0d6df09f-3198-45a9-94f2-ebe2d844dbfd
6a650572-fc95-487e-9a62-c1827dedd311	t	f	2022-01-22 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	021639b4-e8bf-428d-99d1-7e0c85733ef6
d2ce9008-392c-46df-ae9e-ae7b73f0d86f	t	f	2022-01-22 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	9937b264-f2a7-428d-9c4b-5c42eed6b2c5
b8cde576-e13e-4c14-b714-5e35eb4e26e9	t	f	2022-01-22 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	9937b264-f2a7-428d-9c4b-5c42eed6b2c5
37288f22-0fdc-4089-ae94-22d1b190e34c	t	f	2022-01-22 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	9937b264-f2a7-428d-9c4b-5c42eed6b2c5
0ad418fd-019b-4f92-b179-eaa3435c7e01	t	f	2022-01-22 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	9c2e36da-7d86-463c-b874-897164ebcad8
9fd78da1-b40d-4dbd-9c9f-336e88b659c3	t	f	2022-01-22 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	6dddbc60-58d9-4faf-ad06-8e0f4189bb25
e267baa0-7f5b-455d-8097-8199243ce26b	t	f	2022-01-22 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	7457b675-6a95-47de-9d7c-54168be61e9e
b9846d31-a3d2-4363-968c-c1e9e96065e2	t	f	2022-01-23 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	4b125534-5e4d-4b90-9dd7-3c17718bd988
92a07655-3bd3-4379-9a98-544585278a80	t	f	2022-01-23 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	4b125534-5e4d-4b90-9dd7-3c17718bd988
cfa721b6-b984-4f49-a846-b72d8756c868	t	f	2022-01-23 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	e3aae154-1912-42f3-9181-b53fadde0273
7271feba-4363-4ddd-82a5-f34ff1b362a3	t	f	2022-01-23 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	e3aae154-1912-42f3-9181-b53fadde0273
b728d889-1c1f-472a-b888-147ebcb31789	t	f	2022-01-23 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	c75ed0d7-7817-4c4c-9234-e3f690edebb4
6729d6c9-70e3-4535-9834-82d1ebe72807	t	f	2022-01-23 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	d839e50f-e91d-457a-96ee-3a09d592180f
45930b2d-5e1c-4a31-84d9-574253c99dd4	t	f	2022-01-24 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	5de435b6-4d41-4f04-9115-c27c1c0aed6c
322fe4c9-bf03-47df-bdd3-021333ec893e	t	f	2022-01-25 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	d9887dfb-e188-45ee-b9dd-266afeaf35b7
d17b4916-94a1-461b-bd37-4f4406528178	t	f	2022-01-25 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	e06ae247-6d2d-49cd-8a35-39c2b84a042c
2a9dba52-516f-42b7-8f8a-2d9966abb853	t	f	2022-01-25 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	0ee637ce-0f0b-411e-8f1c-40f913f9b355
37003ea3-24a8-469a-a4e7-509a556110e1	t	f	2022-01-26 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	09cf6f33-2689-461d-bb60-9f908092aba2
61fb201d-725b-4ad1-af6f-34d0c9860f79	t	f	2022-01-26 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	09cf6f33-2689-461d-bb60-9f908092aba2
11bfadb8-ecb2-4ad0-8fd9-f3464e54870c	t	f	2022-01-26 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	09cf6f33-2689-461d-bb60-9f908092aba2
96a94b59-a194-4760-b00a-ed484ead6d22	t	f	2022-01-27 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	75d59d93-2b63-4513-b830-e904487f7244
7e96acd9-9ace-4c83-bf82-185432fcc603	t	f	2022-01-27 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	75d59d93-2b63-4513-b830-e904487f7244
9c47b5d5-6f4c-44ec-862e-09eaa565228a	t	f	2022-01-27 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	90e4edae-9c69-4026-a0f1-37f62a5878d4
d5cb8fc3-1329-4bdf-b6f7-47308f048f7f	t	f	2022-01-27 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	6999f6b8-8f5d-46c2-aa7d-beca523e1f28
1b5ec488-99b9-4983-a7fd-67cce8067292	t	f	2022-01-27 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	814871c9-dee5-4834-b5eb-799b23227ed6
df344aba-acae-4806-b278-ca1d4157097a	t	f	2022-01-27 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	86fdb872-2605-453d-b267-a0daefc60f35
e80c6131-7f0f-4d6e-9e22-38e648b5b9bb	t	f	2022-01-27 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	75d59d93-2b63-4513-b830-e904487f7244
fda7b558-2859-484e-930c-d4da9f38a98a	t	f	2022-01-27 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	a936bad0-4d95-4ca3-ba67-888ae0ed8ad1
9fe1a8d9-c142-43d2-aa28-4b5e0e8fb4da	t	f	2022-01-28 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	5b00dbab-ce47-45a5-9b2d-df1c7cd2aad3
399e6665-e571-4194-a65f-99e075e3f13a	t	f	2022-01-28 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	5b00dbab-ce47-45a5-9b2d-df1c7cd2aad3
8e7e8b54-cbc5-4947-bdd1-cd84b9bba925	t	f	2022-01-28 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	449b112b-852d-4d46-bfe8-714b42444f8a
ee7c9ada-023e-4fb7-b881-2a3a8b81ce57	t	f	2022-01-28 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	b114405b-fecc-429d-9e05-0e8e1f4a32a0
1521f1cd-f288-4a32-813b-3618398b5e67	t	f	2022-01-28 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	69b42b7b-d103-4c22-ac7a-221ac6bdef33
4600f02d-a06a-490e-a82e-6d1dee77c7c0	t	f	2022-01-28 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	94537589-44b6-401b-9ad0-3f55a5a038d0
145397d4-26a5-4028-8d1e-3c174e052108	t	f	2022-01-12 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	63bbf548-7a5e-4c36-9019-5aa84a4b7da5
147af2de-d1ae-40d1-84fd-804eed7f4038	t	f	2022-01-28 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	d9887dfb-e188-45ee-b9dd-266afeaf35b7
7825a0ea-a00d-4683-a2e1-cb013329f2c5	t	f	2022-01-28 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	7af26cce-8823-4461-be3b-7e2886b6d746
3d83983a-07f2-4995-9614-0352bab143c0	t	f	2022-01-28 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	7af26cce-8823-4461-be3b-7e2886b6d746
ce672ca3-bb11-41a1-8fc1-5ea26132c162	t	f	2022-01-28 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	7af26cce-8823-4461-be3b-7e2886b6d746
60c4e81d-e3a7-4ff4-b3c7-fa655c1487ae	t	f	2022-01-28 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	bcb23b74-b2c2-428e-8948-81300c94b23a
e417a0ab-1d26-42b3-8ec4-a93e42bc4dd1	t	f	2022-01-28 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	56a9eef4-749b-4ee0-b515-aac52b8b113a
bfe9fb60-3be4-4f61-b937-529141bbf306	t	f	2022-01-28 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	53091396-4d45-4e79-8454-906048ac74f7
ba2c116e-f282-4984-a090-37b2c1879ee9	t	f	2022-01-28 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	850034c1-8da3-4669-992e-33aaee6d8231
459e6a10-2f33-41af-b9a2-95bec17599b7	t	f	2022-01-28 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	4d098039-3d99-4dc9-b124-47cd08240e46
c1c69246-f2aa-4b63-bd43-9f1e3a1cab7d	t	f	2022-01-28 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	a16b1928-0c34-4895-a364-30f4ba943718
4a058cf2-ba03-4cf5-aebf-850ce7b553b9	t	f	2022-01-28 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	fe6275d9-75f9-4214-af86-a2c314052a61
19a3755b-ec24-457e-9a12-be09d6cc94f5	t	f	2022-01-28 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	d82e4ea5-978f-4b9b-b68e-b892d11fde66
c7fa99de-2246-4106-ade4-7c9f70be0f68	t	f	2022-01-28 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	d82e4ea5-978f-4b9b-b68e-b892d11fde66
222d6f9e-7ed8-49ce-ae11-ad2afdd6d939	t	f	2022-01-28 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	f3e0dd16-d46f-4c7a-aaf8-abf1dfb1249e
cea64fab-bb55-4c34-a8d4-fdceef83345e	t	f	2022-01-29 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	34b39613-bc53-46ac-b4c9-bf2b50999784
0d97d8ef-7050-49b7-bd59-a5383d46cc24	t	f	2022-01-29 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	7c50c29c-e9f4-43be-9a4b-8e69480d34b0
af7508b9-9169-4df5-8bd6-cd792ac7b47f	t	f	2022-01-29 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	945d123f-2fdf-46ac-baa1-1f7fa88648ae
80d9badf-56a6-4efb-85f7-9191593157f9	t	f	2022-01-29 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	ef934c7e-22c5-4341-ab82-b837a9a0ba02
16e12cbd-aa8a-4049-87a3-f9f423830981	t	f	2022-01-29 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	c133c0c5-60c4-4a1c-aaf6-4d5ae77ab176
20560c53-de6c-4905-8011-2acde0e789ce	t	f	2022-01-29 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	65ed48ce-30b4-4998-849c-3c309c33f7a6
70624973-9d21-4d25-8941-496535c4936d	t	f	2022-01-29 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	540e44c0-170d-4ab3-afc0-a77ef5e118ef
ca2cdd09-3246-43bf-b13f-93ef0292ebf7	t	f	2022-01-29 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	0eb9e25c-9f59-4dba-a475-4f98d295d4a5
9423f109-7973-43ea-b149-832c21be7d12	t	f	2022-01-29 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	f9643bfe-181d-41b2-abfa-03f859dcb46a
923336bb-4672-47d5-a279-21390476917c	t	f	2022-01-29 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	a6a2f6a8-178e-41c3-a0ee-81bc4f4f62f5
2fd7c781-e4c1-4c0c-8268-566a78b4ca2b	t	f	2022-01-30 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	2ff897a4-2407-4917-aedb-1d16ea9d87f2
8e589af4-9174-4e64-97fb-91b9da2866d9	t	f	2022-01-30 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	2ff897a4-2407-4917-aedb-1d16ea9d87f2
89788863-71ae-47cf-94ee-530265aecea4	t	f	2022-01-30 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	1675fc8e-6714-46eb-8153-ce2ccda25ec8
28cf0606-73af-45b3-b9dd-ac1c82fee41f	t	f	2022-01-30 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	1675fc8e-6714-46eb-8153-ce2ccda25ec8
7f4eacee-44dc-4239-9d02-819b41c63b61	t	f	2022-01-30 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	0a898bcd-8f91-45dd-8676-e0f35aab8031
7bfa88e3-4421-4d14-8492-cacc25f371f1	t	f	2022-01-30 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	6d8abb48-e43b-48ae-b929-1e109919bc5f
b1cea28f-7684-4409-83e1-d7294e26d448	t	f	2022-01-30 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	e3dd948f-7935-48c4-8b01-3ba755741d12
3474c78e-8164-44a0-a300-18f65eb3f42b	t	f	2022-01-30 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	c5d31325-6a0c-4ae1-8a55-cc8450cf033d
75625da8-7410-49d8-8450-94dab23bfc46	t	f	2022-01-30 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	fb52ce66-c821-47d6-9211-c911ea010a35
0dbd319e-d6fc-4f0b-bf2e-bed1106aec17	t	f	2022-01-30 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	a687341d-7f1c-4f3d-af1b-5c91b1b2dbeb
2259e4d7-7f6e-4f6e-91ba-03ff9f3067d4	t	f	2022-01-31 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	a8c21996-630b-40f9-a97c-e45879365581
7aaae7e2-d3a7-4759-9e09-8dc4647dda06	t	f	2022-01-31 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	a8c21996-630b-40f9-a97c-e45879365581
c826a0a8-38c5-4392-92c3-946b4578eb79	t	f	2022-01-31 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	caf6e68d-540a-4b80-b183-a9f753cb0f6a
83baf8ab-91b0-43ec-b7f9-ed7da7b489aa	t	f	2022-01-31 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	caf6e68d-540a-4b80-b183-a9f753cb0f6a
bf0ff630-56e8-41a0-8c5e-0460ac4ecbbb	t	f	2022-01-31 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	99bb3a70-e71e-445c-97df-df5b534e606e
ae2309d0-dc6e-4356-84dd-de760c33e1e9	t	f	2022-01-31 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	afdb2768-ca63-4e25-8849-7d650bfa8e3d
0ff84fc5-6e69-4ad4-af6a-7e081bde5ff8	t	f	2022-01-31 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	cabfd8e3-a9a4-445a-9eba-a6f4fc2f9f02
b808e112-97e4-462b-b41f-39a2bf450d69	t	f	2022-01-31 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	7315fcef-d17c-45b5-a1f3-f48bf695965c
26833526-d1ad-4b39-b064-7e262c7d9e86	t	f	2022-01-31 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	32d3316d-3f99-417b-8497-ad5f83393368
409cfecd-c7a3-4ffb-8988-3e4a1417e41c	t	f	2022-01-31 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	f134a989-3a50-48e8-8f8b-920952333f8e
7beb5d68-9b62-4c3c-87fd-ac4fad210521	t	f	2022-01-31 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	d756e49f-2b9c-47d5-8dbb-52a24d835fd8
1d2f4dd6-80a9-4445-aac1-6d49f42934a9	t	f	2022-02-01 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	40f7bb02-20b6-4d21-a3ff-38187b62b1a7
d5aed354-67d4-4150-80fc-8e3678f2ce99	t	f	2022-02-01 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	53a5db62-2745-459c-9654-8cf8fd985101
df7714be-f08a-4085-989f-b406b0b4b1a0	t	f	2022-02-01 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	53a5db62-2745-459c-9654-8cf8fd985101
a05a3ecb-e93c-44f0-b3ae-6c22adab5b00	t	f	2022-02-01 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	a58f3bef-18a7-4280-a7fb-52ee6f18afb9
83abc200-9e2f-4946-a185-11b19d36680a	t	f	2022-02-01 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	ebe45c81-2317-42bb-a32a-99594764b430
43be7272-341e-4c68-b363-aeae22a3c295	t	f	2022-02-01 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	d5cf5a3c-76af-498e-a3a4-9a31f966c054
13ab71bd-e128-4248-9d65-53e580e21827	t	f	2022-02-01 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	6009ad3d-e7fc-4048-aa9c-635aeddf50d7
0871504d-cda2-4b48-ace2-4cc4688b9269	t	f	2022-02-01 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	5c595fd8-ec7a-4b34-9d26-e7794b13ba3b
d0dcd8c4-bd45-40e0-a5e1-cd73cf491fbd	t	f	2022-02-02 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	33af9058-90cc-4fa0-9f7e-1cca04b28973
1ffb2136-e774-4f90-9174-03e60a63158b	t	f	2022-02-02 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	33af9058-90cc-4fa0-9f7e-1cca04b28973
ed9c0a28-9fe0-4bc1-9f21-5de8f0ff5c7e	t	f	2022-02-02 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	fdcbc4f6-5134-4284-9757-a6d287a162b5
d1fbb8be-9076-48ca-9650-6f4cf93124a8	t	f	2022-02-02 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	fdcbc4f6-5134-4284-9757-a6d287a162b5
986cab0f-70cc-4b77-a53a-9324b65d5df9	t	f	2022-02-02 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	a8c21996-630b-40f9-a97c-e45879365581
430e1a69-f705-4a0d-8b73-6de4d12ae179	t	f	2022-02-02 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	4bc7a297-c56d-4cdc-a8e8-683a1134bd00
4c5a05ca-5295-4082-9bd9-3fea0ab14542	f	f	2022-02-02 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	2ca48d13-4c16-47f0-baae-847b5d744371
37246f85-b57f-4e4d-8c7c-e85c281c516c	f	f	2022-02-02 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	2ca48d13-4c16-47f0-baae-847b5d744371
e8066c04-f6cd-45a0-9c7d-a22d18339c2f	f	f	2022-02-02 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	2ca48d13-4c16-47f0-baae-847b5d744371
a832a892-800f-4d00-a7df-6a7a0e3093ec	t	f	2022-02-02 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	cbeebe90-baec-4e02-ab4e-4740bf9faa29
8564d6ee-5a38-4928-80a7-09813982f801	t	f	2022-02-02 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	cbeebe90-baec-4e02-ab4e-4740bf9faa29
de65b9fe-0c9c-4034-b097-90bc68daf73b	t	f	2022-02-02 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	cbeebe90-baec-4e02-ab4e-4740bf9faa29
9d3f4158-63e4-4d26-a0d8-52dbf84ca463	t	f	2022-02-02 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	41bc64df-a3b3-47e8-b2eb-d3fc52b7516a
6963b604-266d-474e-9729-383451802815	f	f	2022-02-02 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	42969c9b-3e20-40ac-800f-275064d09813
ed79c895-d94f-4205-9f83-7b29ad8c5381	t	f	2022-02-02 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	42969c9b-3e20-40ac-800f-275064d09813
ac695f21-75d8-4cb2-9007-860ef2071cb1	t	f	2022-02-02 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	42969c9b-3e20-40ac-800f-275064d09813
a5381c31-af1e-4668-99ab-b616a0dcadeb	t	f	2022-02-02 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	16100089-537c-4f59-914d-18452ff7c310
5b0006f3-5df0-4d00-bfc7-98282146cde1	t	f	2022-02-02 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	16100089-537c-4f59-914d-18452ff7c310
69e14cf2-6540-4228-8a1f-2cb9c6cac72c	t	f	2022-02-02 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	16100089-537c-4f59-914d-18452ff7c310
a8c567ad-7c5d-47fc-ac98-b93c6f39d138	t	f	2022-02-02 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	d12ec465-a083-4bee-945d-135964e36431
60f14fad-fd13-4f7b-bcfa-0232cb66e236	t	f	2022-02-03 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	dab92035-2330-44b4-b0cb-da26c3ff2751
6e86b6e7-c8cb-4510-93df-042b4f606363	t	f	2022-02-03 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	dab92035-2330-44b4-b0cb-da26c3ff2751
6687fb3a-aac7-4084-83c2-8e604d9c7126	t	f	2022-02-03 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	747c98e1-1958-4517-964b-3662c6ad4ce6
04c78237-6915-4603-b249-73e18441ae50	t	f	2022-02-03 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	747c98e1-1958-4517-964b-3662c6ad4ce6
c9a7bb35-22c6-4c14-913c-5d66b4130ab2	t	f	2022-02-03 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	338ccd7e-6a4f-46d3-820a-c0f8514f76a2
7e418fbb-f70e-40f9-adfa-6e97944e43b5	t	f	2022-02-03 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	b7778ea5-c56a-4bd9-8698-5c020b71fe9b
01c6a730-4d92-42a1-88f7-0f2d98471c3a	t	f	2022-02-03 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	f4187988-5574-42ec-9e25-f5ea8ea2255b
5de94284-df80-46b8-9321-8fcb5da9ec10	t	f	2022-02-03 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	7aa23f98-160e-4556-b599-9a5bdc1cb2f7
2a8066b1-0859-4671-a44f-40482e92a13b	t	f	2022-02-03 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	7aa23f98-160e-4556-b599-9a5bdc1cb2f7
0dc54a23-403e-472f-a8bc-cd5d1b156e09	t	f	2022-02-03 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	3d8c5695-693c-45b0-a4b4-3fc5f7a91b09
34b0ffc9-b59d-403e-a7d6-c3550c139db8	t	f	2022-02-04 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	8f404a51-192c-4c43-be9a-22b3e2079959
533f8ed0-1108-4948-b046-e7cfc5a69579	t	f	2022-02-04 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	8f404a51-192c-4c43-be9a-22b3e2079959
47f2da6e-8719-4414-822d-b28b8e1ee252	t	f	2022-02-05 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	86cbc42e-8e92-434b-b34d-b82316358e9a
ebe45685-1d6e-4ea8-ad73-df4dda2260d7	t	f	2022-02-05 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	86cbc42e-8e92-434b-b34d-b82316358e9a
772b3a49-f3d4-40a5-89c1-8d69edc7efe7	t	f	2022-02-06 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	79c3a4ab-a269-4a60-8e4b-49e1a2407dc2
a7188934-a8eb-4453-b5ec-1b1a439dfca4	t	f	2022-02-06 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	79c3a4ab-a269-4a60-8e4b-49e1a2407dc2
2821f875-1262-4313-81ec-12b04d0d0934	t	f	2022-02-06 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	03cb6f0b-2780-4620-a7ea-c0c1c3302c8c
17eca400-3a98-42b8-bb24-733612155eaf	t	f	2022-02-06 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	c52bca62-e259-4bad-9070-13c945f06299
1f47b455-58c2-4b51-a061-b5b2d48967b1	t	f	2022-02-06 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	23b302cb-7f8f-4118-baef-e9f25b67d7e4
3df2a3df-7a38-4b67-a29a-41b1dc9f1bdd	t	f	2022-02-06 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	23b302cb-7f8f-4118-baef-e9f25b67d7e4
ab08b762-e543-47be-a299-f8a26bdd730c	t	f	2022-02-06 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	c433e07a-7bda-4a5c-99e0-c43ea95d81a8
8b07236e-a096-4bf4-93c8-9f09229e5e83	t	f	2022-02-06 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	c433e07a-7bda-4a5c-99e0-c43ea95d81a8
04956823-844e-4593-b7dd-0ff169c6e1c0	t	f	2022-02-06 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	e252aec7-4164-4f1b-bb74-f98bf2bb2d81
d2ec1005-b950-4ff5-ac3d-c44b69483695	t	f	2022-02-06 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	a46daceb-75ee-42c9-b026-20217e9aa6d3
9eb6b965-7734-4815-bd2a-eb010d64787d	t	f	2022-02-06 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	a46daceb-75ee-42c9-b026-20217e9aa6d3
0c69089e-c997-4f02-b4dc-dec482b498c0	t	f	2022-02-06 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	d8fc4a3f-8d0b-4e5c-9f51-3c7ad188f8f2
5cb839c1-9a74-4fc5-aa13-fa73894d0d60	t	f	2022-02-06 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	952ab15b-130f-426c-881e-9c4c468ad0c7
2a24769a-1f82-4296-9192-b2fd3796a8e6	t	f	2022-02-06 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	ab3bfe36-8cd7-41a8-95e5-11a77537743b
9027c6ca-ba3a-4a70-845e-e95df245e8ca	t	f	2022-02-06 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	e252aec7-4164-4f1b-bb74-f98bf2bb2d81
72d00dcb-c2c0-4204-8b33-f13fd1bb130b	t	f	2022-02-06 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	4b23fc92-177f-4afa-9578-5589f796d3af
5a2c11f6-32f1-4aff-9a3c-dd5fbe2c2eb2	t	f	2022-02-06 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	a1ba548b-658a-4954-a705-77a94dcc36bc
45c75452-12d7-48e6-9fb7-7032a1cd7b24	t	f	2022-02-06 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	a1ba548b-658a-4954-a705-77a94dcc36bc
e5223350-6535-4e16-ae5a-3961ad0eff36	t	f	2022-02-06 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	a1ba548b-658a-4954-a705-77a94dcc36bc
1688297c-5e6c-4c2e-b4d2-e1a2babfb272	t	f	2022-02-06 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	8148ad1a-f9e4-49fa-99ed-f63ae4181d79
a8005fe3-3d6d-4a5f-b1ca-36e3014cb5f9	t	f	2022-02-06 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	9aa54e8a-952d-466f-9f49-d26b252d54d9
781b9178-137d-4b6f-8014-4542f30b8579	t	f	2022-02-06 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	5d8ac5af-988b-41d0-8e0a-9bc24e7a00da
1d1806dd-4cdf-48a7-bcb8-aef08a36c840	t	f	2022-02-06 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	5f060360-f81c-4bf5-be05-bdb1b3fe73ce
087bb8b9-ce52-4cd8-9f9e-17ea73c01c5a	t	f	2022-02-06 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	24d7446b-79a0-4faf-b255-7f6b0e70420c
0e6adbc7-3df4-4151-b708-4e335747b900	t	f	2022-02-07 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	2f51adec-86b2-4a4b-ae5b-b2f1e8cd1691
dfc0b4d0-8379-4c70-8467-043859d91464	t	f	2022-02-07 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	d3b72d3b-4090-41c4-a8f1-062e2c1055f3
cb57d610-b34a-4293-ba07-cb16608b0f74	t	f	2022-02-07 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	8d292d7e-8467-4a36-9b51-9963b15bf858
13f43b0b-dbfe-4536-a2f3-46ec1d5390ed	t	f	2022-02-07 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	f635fbca-21cf-4190-a7e7-5087827bfb86
adfcedf0-bed3-47a3-95ad-5cedcb767f50	t	f	2022-02-07 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	77961b7f-ed81-4a30-8cb4-8ae48fced322
b0ec9478-9981-4169-b6fb-a9da545b4a61	t	f	2022-02-07 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	77961b7f-ed81-4a30-8cb4-8ae48fced322
d7816506-752b-43b5-866c-52ffaa1aa7e4	t	f	2022-02-07 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	f972b03f-4d84-450c-95c4-5a1b18aab697
ec0d1561-df31-427d-ba11-f31e5140486b	t	f	2022-02-07 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	419bd1a9-f711-4c12-8813-a6c00ba57758
7b0fd0f1-4ce3-493e-b99f-ea331f462af6	f	f	2022-02-07 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	e2d41d40-0d0b-46ed-a123-cfc5e53dee94
ae330925-32a5-490f-9d0f-eb55fcdc88a2	f	f	2022-02-07 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	ca88f262-8a4e-44e5-a31c-987421defc9d
91763dd3-7f7f-4bd8-88a1-8cc4d1a7031b	f	f	2022-02-07 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	bec8409c-55e5-49da-87c8-c933a7c0d24f
2b191503-0546-4347-81c8-fc609e7fcfae	t	f	2022-02-07 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	79c3a4ab-a269-4a60-8e4b-49e1a2407dc2
c64c2d0a-7c21-40ae-b411-daa1a6fd3c4c	t	f	2022-02-07 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	4540ed9d-e026-4ec6-a65a-a3b4294922ae
6281087f-f3f7-4bd4-8a88-8fa6b8935103	t	f	2022-02-07 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	6008f9b8-0ddb-4e1b-b2e2-05333da22b44
66e0eca4-8212-4de3-a4c0-9c05384f4294	t	f	2022-02-07 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	c36e8ab8-4878-4af2-b71b-c73e5014eb21
dd86be44-de1c-49bf-bb0e-f33d79264c9a	t	f	2022-02-08 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	7d3c601e-057f-4433-a55b-6e10cae56d1b
c18f53a5-6152-430e-b0c5-03461bb285bd	t	f	2022-02-08 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	7d3c601e-057f-4433-a55b-6e10cae56d1b
029a8040-10f4-4cfd-8872-b3ae16d55e92	t	f	2022-02-08 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	7d3c601e-057f-4433-a55b-6e10cae56d1b
1d98f71c-7d85-44e4-860a-549b775e1400	t	f	2022-02-08 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	1270bf6a-d443-431f-8095-afa03071d780
6dc88894-661f-417f-ad93-ea9267e16c26	t	f	2022-02-08 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	d808a48e-4f19-43d0-b53c-352a0c304b44
66452187-d202-46a2-8e87-e2081c49b2ed	t	f	2022-02-08 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	abbb9ae0-e03a-4e9b-b655-f748722c8f3d
73d70e72-b7cf-4dfb-bb1b-c2308b687065	t	f	2022-02-08 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	8fc56f98-c868-4e74-89ef-0b3083b6d14a
f4beede1-9d9e-4f9c-83a3-60bf327bde40	t	f	2022-02-08 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	a85a097a-287d-41a1-b683-ff3088703986
4fe60bee-ac55-4418-86c1-72718dd96750	t	f	2022-02-09 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	4ddfaba9-65c0-4e97-8864-29e414a20040
94759763-85ca-4c8b-ab1a-6c4565056f6c	t	f	2022-02-09 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	e200fa65-db48-43ce-b222-c495ca26c50a
78ec4b69-79f0-4726-9e74-b2e08daaba6f	t	f	2022-02-09 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	ca9bfcae-501f-41c2-a608-77313889bead
e68448fb-048d-4df0-8ddd-7232129c30fa	t	f	2022-02-09 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	98cb8454-8dd6-4328-b3a5-1dbc6db77996
74e28653-b920-43c4-9601-ef12a583fe11	t	f	2022-02-09 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	54ca306e-be69-4a9e-9d69-623c89f879bd
2085e53f-1d5a-4626-a486-23eae679376d	t	f	2022-02-09 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	21e8d66c-a4d3-4e93-82ab-ca7bdae4a504
a76fb303-cc58-4a49-a524-8c19c0553daf	t	f	2022-02-09 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	21e8d66c-a4d3-4e93-82ab-ca7bdae4a504
e4bf9403-d4bd-4bd6-bbe2-d78992198388	t	f	2022-02-09 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	21e8d66c-a4d3-4e93-82ab-ca7bdae4a504
18d41d73-6aa9-4a72-803d-f3fc9571842a	t	f	2022-02-09 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	403bede8-313f-4cbf-9a91-cdf72ebda012
5032330a-df7c-4e4f-bcd6-2ea27adf9561	t	f	2022-02-09 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	caf5b2e8-20e6-4058-98df-cfa02a3f1dc3
a0120aa9-d37e-4e3e-a9f6-297ad458a88b	t	f	2022-02-09 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	f4df18a7-2195-44d2-b5a5-2db618b3bff3
640da902-a933-49fd-8075-e1212cd11daa	t	f	2022-02-09 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	316f6891-d980-4086-a89e-66f3c36edc25
e61c8d61-5b92-4531-9c53-99adee28d74f	t	f	2022-02-09 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	316f6891-d980-4086-a89e-66f3c36edc25
1b5c657d-9580-4a56-9e41-18a496941c68	t	f	2022-02-10 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	9482fb14-bb6e-49b3-b735-0080325629f3
ab55b440-9305-4753-98a9-03f23ca68b5d	t	f	2022-02-10 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	9482fb14-bb6e-49b3-b735-0080325629f3
1e257c58-ef6b-4600-828c-e7c71cf1a7da	t	f	2022-02-10 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	234dc711-0bb8-4f7e-a231-45372ecd4537
e4e75824-2f47-403e-956c-7b3fd4b490bd	t	f	2022-02-10 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	47eda5df-9fdc-4d7a-a860-2863ead4856a
528a2f9b-caaf-4774-841d-9a9557d93527	t	f	2022-02-10 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	ff663c09-7972-40cc-b9e4-17af3160a575
76a51a44-c815-47d5-904b-f08f5fa71fa2	t	f	2022-02-11 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	b7a3865f-8bfe-4acc-b24d-9c9bdd110cbf
9edadd52-a8f6-4ca0-af44-a4560ab878dc	t	f	2022-02-11 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	b7a3865f-8bfe-4acc-b24d-9c9bdd110cbf
fce5dad4-ff76-4013-96eb-7f2a77d68f38	t	f	2022-02-11 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	d2704b12-ba37-412b-98a8-ac82c19c2cc0
ba3f7e87-fa06-4294-8ebd-b40368d1a744	t	f	2022-02-11 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	d2704b12-ba37-412b-98a8-ac82c19c2cc0
73342453-52fc-4169-afde-ae4063dcebab	t	f	2022-02-11 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	3dbe75a9-b938-4fc3-a429-0f492f6f08f1
2039e60c-bc46-4405-bb15-2e645c2231ae	t	f	2022-02-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	3dbe75a9-b938-4fc3-a429-0f492f6f08f1
585eba1d-769d-4b56-bb04-f2dd18df1de6	t	f	2022-02-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	c7ac80ba-1ac4-41ea-8384-f20bd920c911
d7d865fe-f814-469c-9f33-595520bf739b	t	f	2022-02-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	85107ceb-456c-44e3-8a83-386202cf4347
069dd864-5f4a-45d0-9da7-a2890af4cffd	t	f	2022-02-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	cf715378-a833-43eb-aa78-b32992b4cb11
5a9c15c7-b37c-4a28-81a4-888264471436	t	f	2022-02-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	861d50fd-f99a-4496-bfcd-8bc43429d67c
3bc8342b-756d-4a41-8058-478b3b17c38b	t	f	2022-02-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	994258bc-b95d-4876-93c6-7f64f9db7e9b
b66311d4-bbec-46c9-af5e-9257bf465dde	t	f	2022-02-11 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	8f404a51-192c-4c43-be9a-22b3e2079959
17ec05f9-4053-4628-aa17-877321466b64	t	f	2022-02-12 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	d2704b12-ba37-412b-98a8-ac82c19c2cc0
5d7c534e-5d24-4d42-ba79-f2f2414363d6	t	f	2022-02-12 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	1fc90bb5-f3bc-4b64-b519-b6338495bddd
f281e4aa-743e-4aa6-a11e-3649ffb4962f	t	f	2022-02-12 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	571848af-348b-4c41-be80-d4fc6ee7322e
815a280d-4db9-4df1-9d20-f68ccce32bc7	t	f	2022-02-12 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	1ec78f9f-e642-4807-aeed-cf03352068c5
48986153-e934-4080-814e-a4db17213352	t	f	2022-02-12 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	1ec78f9f-e642-4807-aeed-cf03352068c5
a0673184-af29-4a16-94d9-97b2ab2e2049	t	f	2022-02-12 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	57afda38-ce4a-44e5-aed1-8e125afac642
0f8f82c1-fd94-45a7-b926-3df054f29f7e	t	f	2022-02-12 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	57afda38-ce4a-44e5-aed1-8e125afac642
9704b2f3-81e4-4c07-b818-75efad7fefc0	t	f	2022-02-12 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	61c3fc5d-e131-430e-86ef-168826be20b9
ccf115ed-8c02-45b9-8a33-c8bed06044ea	t	f	2022-02-12 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	4b06786d-a900-41dd-aab6-f66884607aef
6717c6da-6a3f-4e3d-b17f-3386ca58df63	t	f	2022-02-12 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	f4f338e5-7193-4868-b5a6-f719bd671f32
e411d3f7-e487-4399-853b-f6c3958ab1c1	t	f	2022-02-12 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	ac736a64-dc11-4763-b53a-cfe1ea7c6546
b6dd3806-ad3e-44ec-af43-f75efa1712f0	t	f	2022-02-13 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	86d589ad-4383-4f7a-ad9f-50bf1118cf48
2c669159-3056-484f-806e-fdb181e09bed	t	f	2022-02-13 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	86d589ad-4383-4f7a-ad9f-50bf1118cf48
938c4706-6e3f-46d5-8c90-6724a79afa86	t	f	2022-02-13 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	cbe7672b-d4ac-412d-a584-f5f4372fe744
e38798d3-a8e1-48b6-b931-1c90c817fd5d	t	f	2022-02-13 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	01964cce-b26a-43b8-9f32-eb667b6f65ba
f1b20ec4-07fe-4d27-baff-ca7c5514f00a	t	f	2022-02-13 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	161a2d6b-6b3d-4c14-bbdb-5c8fa07fa1f2
e0ef9001-d01c-4254-a10e-ae5c21d0c8a5	t	f	2022-02-13 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	6913fe9f-674c-4118-9d76-df576c06abfe
2d17db3e-9ae6-49ad-8329-ab2b2d05745d	t	f	2022-02-13 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	4426d626-388d-4b9a-b0dc-c362d30fda6d
e9d0fab3-4763-4b47-92d3-38fc0b4cb155	t	f	2022-02-13 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	5b96b0eb-7013-4b1c-9525-18dab3af893a
67b3aeea-a69e-4e44-a0eb-f1bf6e03d523	t	f	2022-02-13 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	1ec78f9f-e642-4807-aeed-cf03352068c5
ff621acd-4d68-4ce4-a491-67e28c945c40	t	f	2022-02-13 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	beaa63fd-b5ec-4801-b79d-a7eb9ce5aab4
d9700355-2bab-49f6-82a7-53ba30db12d7	t	f	2022-02-13 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	cff6ca6a-7dee-41b4-bd72-ac3534c8aa26
a7e50430-8e7b-4ccc-ba0f-9a5560e374e3	t	f	2022-02-13 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	902335c6-cea7-4f06-b8a5-070e519ef34e
8c3c0534-517d-4b2f-8cf2-86087991e6be	t	f	2022-02-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	6cde9caa-122e-4f73-aa3d-9e3668a17ab2
9e6da2fa-2dba-4262-8ad6-d23e9ef2bd92	t	f	2022-02-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	8a0a9175-a2bf-4e0a-b1d2-1ddc537de0aa
78d9054e-7ac5-4c0e-a2c2-7cc41f429939	t	f	2022-02-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	f2cadb4f-8b47-48be-8854-cc9af9f596b8
7c91b02d-a1d3-44b3-8a88-ca68e686ff4b	t	f	2022-02-14 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	c4d41587-9eaa-42fd-99f4-0bf2dc85866d
cf61a233-8920-4850-89f8-9f60c8d4e0c9	t	f	2022-02-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	c4d41587-9eaa-42fd-99f4-0bf2dc85866d
143bed9a-bfea-4931-81a9-a164dd5bc36b	t	f	2022-02-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	19d9bee9-7c4d-4c5e-8eaa-8ac5051c935e
3e4ae4db-d95c-451c-a3b3-3feb4e64a20f	t	f	2022-02-14 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	77fee69c-6002-4d37-baf7-b7bea62f96bc
8fe278b5-664c-4fce-ac1a-d53d0bd2f850	t	f	2022-02-14 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	77fee69c-6002-4d37-baf7-b7bea62f96bc
34f994ee-28f9-460e-8c47-dfde41fc6af6	t	f	2022-02-14 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	77fee69c-6002-4d37-baf7-b7bea62f96bc
82337121-974a-4045-973c-e8557b0d50b4	t	f	2022-02-14 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	2f40997b-527f-4536-9754-bf84b2f536c2
81efb28d-72f5-4b14-9654-e014d2495d43	t	f	2022-02-14 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	2f40997b-527f-4536-9754-bf84b2f536c2
\.


--
-- Data for Name: teilnehmer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teilnehmer (id, aktiv, deleted, change_date, deletion_date, name, vorname, jahrgang, stv_nummer, ti_tu, organisation_id, dirty) FROM stdin;
c393226b-5ae1-44a7-b76b-455d9c0757c7	f	f	2022-01-11 00:00:00	\N	Buchmann	Jeanine	1993	\N	0	7647310f-d340-4dc7-b6d8-bda7a5716728	f
8f6e628f-13e7-4bf8-a661-7776005d8247	f	f	2022-01-10 00:00:00	\N	Mollet	Reuban	2009	\N	1	2fc3365b-34d9-4054-b2d8-aa859c7455e7	f
964f1a26-1db4-4d92-ace7-e1e8d1040fe7	f	f	2022-01-29 00:00:00	\N	Wüest	Philipp	1995	564018	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
15d210c8-1e12-46ee-8aea-cf05f9932a53	f	f	2022-01-13 00:00:00	\N	Hofmann	Anders	2012	3162944	1	a60429c0-6964-454b-8ee1-ddad66957f06	f
fabdde8b-a5df-451a-b5c6-c63989a96845	f	f	2022-01-13 00:00:00	\N	Nagel	Gian-Andri	2013	3382383	1	a60429c0-6964-454b-8ee1-ddad66957f06	f
8ce8b225-cfbc-48dc-8ec0-ff766f8af8ba	f	f	2022-01-11 00:00:00	\N	muster	hans	0	131313	1	89e47949-21f1-4855-a397-20c3bc3426d7	f
97e40a84-12ab-4196-9a07-251795684d05	f	f	2022-01-11 00:00:00	\N	meier	fritz	5	141414	1	89e47949-21f1-4855-a397-20c3bc3426d7	f
790611fd-e9c6-4d75-833d-f0bef82646c4	f	f	2022-01-11 00:00:00	\N	\N	\N	0	\N	1	89e47949-21f1-4855-a397-20c3bc3426d7	f
6054e9bf-9754-4ff1-b893-d434aa8c9c14	f	f	2022-01-11 00:00:00	\N	müller	felix	10	121212	1	89e47949-21f1-4855-a397-20c3bc3426d7	f
daa197bf-60ea-41fb-af9b-2d48c57d9d6e	f	f	2022-01-11 00:00:00	\N	Balmer	Benjamin	2008	3060839	1	205d3aed-6ce7-4cd3-8f6d-8d222d9d59b0	f
64deb490-e1c3-4564-a332-65cec17d5d9a	f	f	2022-01-11 00:00:00	\N	Balmer	Damian	2006	3005117	1	205d3aed-6ce7-4cd3-8f6d-8d222d9d59b0	f
24d83ab7-2161-4bdd-8c73-ca2eb83e2f41	f	f	2022-01-13 00:00:00	\N	Schnitter	Leon	2012	3162965	1	a60429c0-6964-454b-8ee1-ddad66957f06	f
31c0e81b-0100-473b-8b83-b166c58d30c0	f	f	2022-01-13 00:00:00	\N	Eggimann	Luca	2012	3162940	1	a60429c0-6964-454b-8ee1-ddad66957f06	f
b0e9fd0b-d7e8-4f37-8a42-f2854901aedc	f	f	2022-01-13 00:00:00	\N	Maier	Patrice	2010	3036147	1	a60429c0-6964-454b-8ee1-ddad66957f06	f
5828b5e1-f4c0-469d-99b2-1d63dc7b663c	f	f	2022-01-20 00:00:00	\N	Schmid	Julian	2012	2254045	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
191b7c4a-462a-48ad-a967-12dd83e31dca	f	f	2022-01-20 00:00:00	\N	Lüthi	Jannis	2009	2063949	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
9dbb066d-047c-41ed-b241-2c58091e6817	f	f	2022-02-08 00:00:00	\N	Muntwyler 	Jaël	2014	3448478	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
1b4854d8-20ad-4930-b1c3-3240dc956831	f	f	2022-01-14 00:00:00	\N	Grau	Cédric	2013	2463794	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
a4c163f6-6304-413b-aa87-71140b7ee6c5	f	f	2022-02-02 00:00:00	\N	Wüest	Robin	2012	3411868	1	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	f
b3f9bd7c-c964-484f-ba2a-eed971e6302e	f	f	2022-01-14 00:00:00	\N	Grau	Marc	2015	2587071	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
355bba95-fd6a-4508-874f-4b12b4ac7259	f	f	2022-02-08 00:00:00	\N	Kara	Nelejoline	2013	3448466	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
af92249a-5a95-4e07-8ad2-2eadfb148c3d	f	f	2022-02-08 00:00:00	\N	Walter	Aliena	2013	3448463	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
c1811d92-27e1-4af9-aadf-c37c470d786f	f	f	2022-02-08 00:00:00	\N	Hug	Leandra	2013	3374230	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
dacbe400-de12-41ae-b085-1539b49f1d84	f	f	2022-01-14 00:00:00	\N	Lüthi	Laurin	2014	2463787	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
481a3cb4-cb26-4227-8463-ee717c8db0ac	f	f	2022-02-08 00:00:00	\N	Kessler	Melissa	2011	3448480	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
1ae54287-50bc-45bc-9b79-1b5f19f5d85b	f	f	2022-01-14 00:00:00	\N	Williner	Yago	2014	2463774	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
92613163-8bfc-4490-aa2d-af64c7a4fc72	f	f	2022-02-08 00:00:00	\N	Fierz	Anja	2012	3448473	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
e4565881-aa88-4903-88fe-5cbbae005638	f	f	2022-02-08 00:00:00	\N	Müller	Emma	2012	3281474	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
719b1561-8685-475a-9a8e-c4ae01c947ee	f	f	2022-02-08 00:00:00	\N	Müller	Frida	2012	3253620	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
0a2ba450-116d-4b86-828e-8d848a39de40	f	f	2022-02-08 00:00:00	\N	Waldvogel	Larissa	2010	3253617	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
75a9b37c-1f59-4dbc-8ef0-64397367e520	f	f	2022-02-08 00:00:00	\N	Sulzberger	Anik	2014	3490223	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
8f5bdaeb-1b7f-4994-a0e0-6094b5c58ead	f	f	2022-02-08 00:00:00	\N	Egli	Chiara	2010	3091287	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
3d826b0d-3d90-4afe-85ad-b4c14ad92e98	f	f	2022-02-08 00:00:00	\N	Guarnuto	Diana	2011	3152485	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
4454075d-3ef8-4fed-b3a6-a0970872c13d	f	f	2022-02-12 00:00:00	\N	Leibundgut	Elin	2014	3479157	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
3b53d27e-8915-44f0-a835-3d09a6e0cf53	f	f	2022-02-08 00:00:00	\N	Hug	Annina	2011	3253612	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
a49caede-ef45-4644-8651-e0c20981003a	f	f	2022-02-08 00:00:00	\N	Ward	Shayanne	2011	3152488	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
a51724a5-36ba-4443-a13e-c708ae7a6238	f	f	2022-02-08 00:00:00	\N	Schoch	Leonie	2008	3024917	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
15b80964-2809-4c3b-9325-f20ae4930434	f	f	2022-02-08 00:00:00	\N	Muntwyler	Lena	2010	3137547	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
4704aded-5bfb-4e70-b381-cf912524859a	f	f	2022-02-08 00:00:00	\N	Tribastone	Luana	2004	880225	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
d629ae8e-527f-43bb-9acb-1de7b10ca838	f	f	2022-02-08 00:00:00	\N	Schätti	Anina	2005	843290	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
4360e314-ea32-496c-8657-c9bb8058b0ea	f	f	2022-02-08 00:00:00	\N	Müller	Alice	1995	663738	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
b8fb2865-aa6b-4391-aeee-8db904eedf28	f	f	2022-02-08 00:00:00	\N	Huber	Michelle	2008	996779	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
8c8c1d3b-60d8-4b8d-9489-2303f5e7830c	f	f	2022-02-08 00:00:00	\N	Nicoli	Sabrina	2004	661748	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
208cba42-90ab-4392-a889-770f7e5371a5	f	f	2022-01-11 00:00:00	\N	Breitrück	Cornelius	2009	3448483	1	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
6c96f71b-45c5-437b-88e2-cf38bfa5cead	f	f	2022-01-11 00:00:00	\N	Waldvogel	Kilian	2012	3253627	1	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
ce7cef74-724f-47d5-8b37-61dec7354c21	f	f	2022-01-11 00:00:00	\N	Breitrück	Marius	2014	3526270	1	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
43d79d88-2bfb-4899-9635-87db5b1ebb4d	f	f	2022-01-11 00:00:00	\N	Seeli	Laurin	2010	3109365	1	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
6699bdaf-f027-45bd-9f8e-cc9e1596e57e	f	f	2022-01-11 00:00:00	\N	Mezger	Sven	2012	3252622	1	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
136d2b74-98c9-41c3-85cb-b41c62d7c2cc	f	f	2022-01-11 00:00:00	\N	Huber	Dominic	2012	3149037	1	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
1ace9385-c200-4162-b8f2-ee20a21de12b	f	f	2022-01-11 00:00:00	\N	Zuppiger	Leandro	2011	3152487	1	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
ecd18d1b-5ff9-402b-acb0-a7c024d7405a	f	f	2022-01-11 00:00:00	\N	Jaussi	Silvan	2004	880226	1	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
a0cfcf47-0969-4b2c-982f-b7707c2c0a53	f	f	2022-02-08 00:00:00	\N	Nyffenegger	Elisa	1997	549621	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
804ce147-8367-45a2-b4a4-6109ebdbfff3	f	f	2022-02-08 00:00:00	\N	Walser	Jana	2008	3076606	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
75b7f508-ab0d-4b64-ae47-bc251362c013	f	f	2022-02-08 00:00:00	\N	Zarth	Naomi	2000	564758	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
2ac66196-815d-4cd6-a58c-3971dc45f786	f	f	2022-02-12 00:00:00	\N	Lanz	Samira	2012	3366464	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
6c810567-a2ec-4bf7-82a4-892f8090e500	f	f	2022-02-12 00:00:00	\N	Bilal	Zena	2013	3547177	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
526638ae-ea16-4fa2-bdbc-0923158a8e5c	f	f	2022-02-12 00:00:00	\N	Gerber	Ayline	2014	3479031	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
7a245c56-9eca-4ee0-91a8-2f3f7ab2a382	f	f	2022-02-12 00:00:00	\N	Ilg	Nila	2012	3381506	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
bb382f68-3f86-4ac9-b4f8-47793df347cf	f	f	2022-01-12 00:00:00	\N	Rufli	Nalu	2011	\N	1	2fc3365b-34d9-4054-b2d8-aa859c7455e7	f
2a9bb7bd-52fb-45dc-a9fd-1a360472fa78	f	f	2022-01-12 00:00:00	\N	Knöpfli	Miles	1999	\N	1	2fc3365b-34d9-4054-b2d8-aa859c7455e7	f
846a1295-b969-4696-9aa3-490d714ed495	f	f	2022-01-13 00:00:00	\N	Schälchli	Tim	2003	616073	1	a60429c0-6964-454b-8ee1-ddad66957f06	f
722205f8-f2c6-450f-a9e0-66090af8cef2	f	f	2022-01-13 00:00:00	\N	Von Ow	Raphael	2011	3158265	1	a60429c0-6964-454b-8ee1-ddad66957f06	f
d47e529c-488c-4d0a-8701-4660764839a4	f	f	2022-01-13 00:00:00	\N	Thalmann	Kymani	2010	3275688	1	a60429c0-6964-454b-8ee1-ddad66957f06	f
f823ade5-ba29-4694-95b2-96fe94ae61f3	f	f	2022-01-13 00:00:00	\N	Leandri	Noah	2003	933153	1	a60429c0-6964-454b-8ee1-ddad66957f06	f
e8ea8830-17ab-4cf1-9857-fb7eb356d545	f	f	2022-01-13 00:00:00	\N	Maier	Orlando	2008	832681	1	a60429c0-6964-454b-8ee1-ddad66957f06	f
44cd2080-cd4d-4cc7-b3d0-59049ec6a039	f	f	2022-01-13 00:00:00	\N	Eggimann	Nico	2010	3158258	1	a60429c0-6964-454b-8ee1-ddad66957f06	f
3ff268d4-5f14-47c2-b97c-6dd626e6d5f7	f	f	2022-01-13 00:00:00	\N	Leandri	Dan	2009	3072815	1	a60429c0-6964-454b-8ee1-ddad66957f06	f
f37982fe-3e6d-4eda-abda-8ac5755df352	f	f	2022-01-14 00:00:00	\N	Williner	Rafael	2008	999794	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
888068e0-53b7-42c4-9319-4fb353fc71d4	f	f	2022-01-20 00:00:00	\N	Krauer	Mike	2014	3556149	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
74927bd5-9b9f-4a96-b2ec-d6f9ec65ea4d	f	f	2022-01-20 00:00:00	\N	Trudel	Alain	2013	3556164	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
df9f5dbf-f29e-4db3-bde6-5ae08bd902c9	f	f	2022-01-20 00:00:00	\N	Netuschil	Kilian	2014	3556155	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
625b0f35-302b-4ef3-99c4-8d61475bcbdd	f	f	2022-01-21 00:00:00	\N	Möckli	Levin	2011	3042701	1	e2438143-6017-4683-a533-6113748d4117	f
b7cfcd59-bb9b-4e1d-b59f-e9522d84ead8	f	f	2022-02-05 00:00:00	\N	Crola	Edda	2011	3276472	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
26636a78-0791-4c4d-87fb-5e6a1027c123	f	f	2022-01-20 00:00:00	\N	Hintermann	Nils	2012	2332786	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
5d0f0123-6f6f-43dc-8946-60b03375a87d	f	f	2022-02-05 00:00:00	\N	Rüegg	Sonja	1999	697997	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
fa9887e0-680c-479a-8ac7-3c8f2e3f4769	f	f	2022-01-20 00:00:00	\N	Grenacher	Oskar	2011	2063959	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
c89c90ff-9a8c-4b8c-94fe-f21a96938dd9	f	f	2022-02-05 00:00:00	\N	Senn	Ninetta	2007	3016475	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
25718b42-a27c-4fb2-b9a3-0a012e44f6c3	f	f	2022-01-20 00:00:00	\N	Murgo	Ilyas	2012	2521932	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
fcd79d30-7590-46b9-b332-b0f30f373753	f	f	2022-01-20 00:00:00	\N	Stergiou	Jannis	2012	2254046	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
7339e402-4a3a-4298-ae18-c97cf15433d1	f	f	2022-02-05 00:00:00	\N	Torriani	Emilia	2006	3041046	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
4c44b26b-75b5-454a-9523-d1a13668c60b	f	f	2022-02-05 00:00:00	\N	Di Vito	Loredana	1996	664255	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
ad2f61d2-31e6-4bb8-b6c6-23d4df98a103	f	f	2022-02-05 00:00:00	\N	Von Arx	Cosima	2004	915146	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
e6c51a7f-2f1f-44d2-8974-f3a222018f30	f	f	2022-02-05 00:00:00	\N	Da Costa	Soraia	2014	3366800	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
f15aa673-3039-494a-8187-47745bf73bdb	f	f	2022-02-05 00:00:00	\N	Studer	Paciane Bo	1995	470912	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
ff7b1805-07a7-40d6-9cba-f57d8141a730	f	f	2022-02-05 00:00:00	\N	Gassmann	Sibylle	1999	664270	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
0485d367-39ac-444f-8256-530e2248c9e0	f	f	2022-02-05 00:00:00	\N	Caiocca	Matilde	2012	3366794	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
0af9f6c2-0b45-4f0f-a0cf-41da23b67aeb	f	f	2022-02-05 00:00:00	\N	Gut	Mara	2011	3167774	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
d95b8556-fa44-41e0-a8d1-e0cb288ea4cd	f	f	2022-02-05 00:00:00	\N	Schneider	Nina	1985	928631	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
6a85cf8d-0978-4534-9bfb-669006f092b6	f	f	2022-02-08 00:00:00	\N	Vögeli	Mael	2013	\N	1	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
ba61a7bb-2162-4e6d-8951-f97e8972fb03	f	f	2022-01-17 00:00:00	\N	Blaser	Yanis	2005	682619	1	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
dbfa3cb3-f422-4d5b-a506-e745ef4f8ac5	f	f	2022-01-17 00:00:00	\N	Wieland	Mike	2013	3333502	1	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
691c3b72-32c7-4c84-bac6-025d7afc2654	f	f	2022-01-17 00:00:00	\N	Britt	Niwes	2010	3153517	1	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
6247b048-7eff-40f7-a159-0a799e31b694	f	f	2022-01-17 00:00:00	\N	Enzler	Naviin	2011	3197559	1	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
5f6d8771-f6b1-482f-9e6c-87448c63dfdc	f	f	2022-01-17 00:00:00	\N	Britt	Fionn	2014	3512177	1	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
2fac7e69-8bcc-44f6-aa39-17c3ca51a89c	f	f	2022-01-17 00:00:00	\N	Sieber	Louis	2011	3426640	1	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
e49aadfa-195f-4c25-b698-812bfdadb682	f	f	2022-01-17 00:00:00	\N	Eichenberger	Yves	2009	3046138	1	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
57454bda-dac9-44db-96a5-0912760e67bc	f	f	2022-01-17 00:00:00	\N	Bruderer	Nico	2006	893118	1	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
73edd0ac-2789-415c-9a52-25b554526e8e	f	f	2022-01-17 00:00:00	\N	Britt	Levin	2008	3046137	1	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
451ddc55-c9c9-41de-b0b7-b3e99481c753	f	f	2022-02-05 00:00:00	\N	Gyenes	Leonie	2012	3276497	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
d937d2c4-390f-4509-835b-0f8a2a0ec53d	f	f	2022-01-17 00:00:00	\N	Hufnagel	Kai	2007	3024636	1	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
f2de432e-1b6e-437c-9804-09b688998682	f	f	2022-01-17 00:00:00	\N	Akveld	Tim	2010	3159037	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
27316a2b-be20-426c-b73f-ff55d3b38cc7	f	f	2022-01-17 00:00:00	\N	Schlund	Kai	2013	3466585	1	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
1c879e28-9222-40db-85b6-79be066fc9e0	f	f	2022-02-06 00:00:00	\N	Unternährer	Bella	2011	3137545	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
7ce8a50a-6d45-46ac-847e-85f3c47afce5	f	f	2022-02-06 00:00:00	\N	Jud	Sinja	2012	3351759	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
b3851896-99a8-409e-933e-f8d3d9ff018f	f	f	2022-02-05 00:00:00	\N	Hering	Noa	2006	964674	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
c04c3b69-b53a-4134-b259-8d42af89df98	f	f	2022-02-05 00:00:00	\N	Heinz	Sanja	2007	964669	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
0985ba77-7d82-42ac-b749-b4038d98499b	f	f	2022-02-05 00:00:00	\N	Ouattara	July-Mae	2010	3041045	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
4cfc24a3-1f5b-4aad-bc7c-3a9b25338fc0	f	f	2022-02-05 00:00:00	\N	Hunziker	Luana	2007	964671	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
6be7d65d-fba8-42a4-89b7-2c666d713306	f	f	2022-02-05 00:00:00	\N	Hunziker	Naomi	2005	915137	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
4beded93-5981-417a-81ff-9b895474383f	f	f	2022-01-17 00:00:00	\N	D'Altri	Fynn	2013	3344883	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
52844f4d-5604-4615-b371-6fb99a57c626	f	f	2022-02-05 00:00:00	\N	Morbach	Elena	2002	664307	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
f11b1e27-f72d-49a1-8a81-f74047503942	f	f	2022-02-05 00:00:00	\N	Horber	Helena	2000	664279	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
8b34d423-ada0-4bec-9cc8-d47e9e220780	f	f	2022-02-05 00:00:00	\N	Heeb	Natalie	2001	664277	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
9d777b94-b5f8-4fc8-8c84-b1898de938e0	f	f	2022-02-08 00:00:00	\N	Köppel	Chiara	2012	3055418	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
8d2c0dc4-2b4e-4019-8a1d-ff480e879d3e	f	f	2022-02-05 00:00:00	\N	Molin	Virginia	1999	664304	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
2f8bf907-d6f0-416b-abe2-46560b143b06	f	f	2022-01-17 00:00:00	\N	Covelli	Livio	2007	3018113	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
7fbef750-5342-46de-a37a-56293f421ce8	f	f	2022-02-05 00:00:00	\N	Hintermann	Aisha	1999	664278	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
384e4454-f2f9-4765-969b-b97210848672	f	f	2022-02-05 00:00:00	\N	Ruosch	Melanie	1988	445019	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
877359bb-d323-4184-b585-65c4c84a72b5	f	f	2022-02-05 00:00:00	\N	Krauer	Soé	2014	3556151	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
1feccc39-8bfc-4843-964e-76d4bb345bd2	f	f	2022-01-17 00:00:00	\N	Moser	Felix	2010	3276523	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
8c213cc6-47a1-4a94-9800-7e050e398ca9	f	f	2022-02-05 00:00:00	\N	Pfenninger	Juno Leah	2011	3276527	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
68cf41f0-88d3-4d35-bb68-c02b8150bc3c	f	f	2022-01-17 00:00:00	\N	Schaffhauser	Thomas	1991	561128	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
cf92e3e7-201f-4998-9415-af34fe635aea	f	f	2022-02-05 00:00:00	\N	Richter	Greta	2014	3422036	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
76b99e2d-c1f5-457f-bace-a59f6f019dc6	f	f	2022-01-17 00:00:00	\N	Schärer	Noel	2004	915221	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
b1857a1f-6ce6-4c3e-ab1b-603a6d854d43	f	f	2022-01-17 00:00:00	\N	Flückiger	Severin	2002	664267	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
9ae29252-dfb9-4f54-b9bf-acd7f963280f	f	f	2022-02-05 00:00:00	\N	Quarta	Lina	2015	3556159	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
46ad8cc8-c402-4b31-876d-4d903dbf0bc4	f	f	2022-02-05 00:00:00	\N	Woytschak	Miyu	2009	3107865	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
77328ed8-39ea-41b6-899e-beb5f9861380	f	f	2022-02-05 00:00:00	\N	Wyniger	Ylenia	2010	3276553	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
23c379ab-5c86-479c-94e0-e1cbd5164acc	f	f	2022-02-05 00:00:00	\N	Tondi	Timea	1993	3010148	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
20d2b026-f247-40fd-86fa-b8079c8810e6	f	f	2022-02-05 00:00:00	\N	Suter-Arnold	Cloé	2009	3060155	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
512512f6-b606-46a2-b179-0040cc97b7ab	f	f	2022-02-06 00:00:00	\N	Dietz	Marie	2010	3014878	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
8a0d12f6-8d55-4523-8978-a785258dffc5	f	f	2022-02-06 00:00:00	\N	Oesch	Lisa	2011	3160388	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
bb077b48-974d-419f-a9e1-1a65a339e00a	f	f	2022-02-06 00:00:00	\N	Lüchinger	Norah	2011	3292616	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
e9588bcb-50c5-4d6c-806c-f3afbd3124ed	f	f	2022-01-17 00:00:00	\N	Sciskala	Stanislaw	2014	3466343	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
127bc2eb-3b88-4e28-b285-da2c87200b9b	f	f	2022-01-17 00:00:00	\N	Wolski	Lucian	2012	3344887	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
20008481-36db-4a92-83a6-458b77440a2e	f	f	2022-01-17 00:00:00	\N	Rohner	Timo	2003	664333	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
07160725-0859-4a58-9d65-89677de3c1ee	f	f	2022-01-22 00:00:00	\N	Rechsteiner	Lukas	2012	3338171	1	1d2a9859-0137-4da2-8390-6cd570385ec4	f
789248f0-b4fe-4be9-b27d-9bd16788a41e	f	f	2022-02-06 00:00:00	\N	Kocher	Jasmin	2003	921625	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
c6fb9e89-a866-4d37-8a3b-483e342056a8	f	f	2022-01-18 00:00:00	\N	Häberling	Fabian	2015	3491154	1	688a34cb-72f2-4920-aeb3-89325956de26	f
ba20fbb0-c246-414d-958f-7bf181d37c99	f	f	2022-02-02 00:00:00	\N	Monterastelli	Massimo	2005	912410	1	0a9d4719-903b-4f31-9e00-10fc47c954fd	f
e4a7eb54-db20-4a74-a741-944bca117acb	f	f	2022-01-20 00:00:00	\N	Frach	Niklas	2010	2111997	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
d45f228f-96f1-47de-9612-775222437b36	f	f	2022-01-20 00:00:00	\N	Hintermann	Nik	2014	2463792	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
5976ff8a-30e4-4941-8240-f63393169543	f	f	2022-01-18 00:00:00	\N	Bär	Nino	2012	3327126	1	688a34cb-72f2-4920-aeb3-89325956de26	f
59342cf9-fc49-476d-8c45-3854bd896c8a	f	f	2022-02-05 00:00:00	\N	Winkler	Lia	1999	664577	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
6d124e5a-4eb3-41e7-96c4-81e10bc865d5	f	f	2022-01-20 00:00:00	\N	Koch	Nino	2014	2587121	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
2406b2cf-4329-4b6c-9160-336c7a46e0f4	f	f	2022-02-06 00:00:00	\N	Graullera	Annika	2004	911031	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
a054e6d4-5694-492b-a84c-49d8bd1f9ee9	f	f	2022-01-18 00:00:00	\N	Borst	Filip	2010	3149719	1	688a34cb-72f2-4920-aeb3-89325956de26	f
b58f7905-996a-4d8d-a05a-da9026a920eb	f	f	2022-01-20 00:00:00	\N	Ragaz	Mitchell	2009	1866348	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
6f4cf34f-bfe3-49ac-963f-dc31bb85dc66	f	f	2022-01-18 00:00:00	\N	Häberling	Timo	2011	3039059	1	688a34cb-72f2-4920-aeb3-89325956de26	f
161d55b8-8da0-4a96-8494-f18bfa41aeac	f	f	2022-01-25 00:00:00	\N	Fejk	Nelly	2015	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
ed16ea6c-1df1-4643-9ed8-5f91c3f07c38	f	f	2022-01-18 00:00:00	\N	Schlienger	Matteo	2011	3309180	1	688a34cb-72f2-4920-aeb3-89325956de26	f
8b49f6f9-d79a-4897-a200-4b386fe350e3	f	f	2022-01-20 00:00:00	\N	Stadtmann	Noah	2006	1755488	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
1d6c2970-01e1-4731-bee7-ad90613533db	f	f	2022-01-18 00:00:00	\N	Burkhard	Janis	2009	3102492	1	688a34cb-72f2-4920-aeb3-89325956de26	f
86533780-84ec-4dcb-9c25-646030b3ebb5	f	f	2022-02-06 00:00:00	\N	Rinderknecht	Livia	2005	993711	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
27021346-5559-4115-93c3-6d701d79d793	f	f	2022-01-18 00:00:00	\N	Gerber	Kimo	2010	3147914	1	688a34cb-72f2-4920-aeb3-89325956de26	f
6aa7f3bb-08af-43c9-b598-a5e601884639	f	f	2022-02-06 00:00:00	\N	Graullera	Sara	2005	896595	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
f863d3da-aad8-4606-ba98-0a69ce2535f2	f	f	2022-01-18 00:00:00	\N	Schlienger	Nicola	2009	3054060	1	688a34cb-72f2-4920-aeb3-89325956de26	f
8523bc16-1315-4f92-b0d3-486f136fb743	f	f	2022-02-06 00:00:00	\N	Weyermann	Lea	2006	981505	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
062d0f21-91aa-4219-8f38-7d89acb1413b	f	f	2022-01-18 00:00:00	\N	Klaming	Phynn	2006	3016973	1	688a34cb-72f2-4920-aeb3-89325956de26	f
7825ac07-0605-4a5d-80c9-2dc3482d812d	f	f	2022-02-06 00:00:00	\N	Kuipers	Femke	2005	3327008	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
7efe5df5-da80-47f3-bb9f-a1c79089d1ba	f	f	2022-01-18 00:00:00	\N	Schär	Simon	2007	3016974	1	688a34cb-72f2-4920-aeb3-89325956de26	f
44ba48c7-9ef2-4f89-b040-b69ad23df045	f	f	2022-02-06 00:00:00	\N	Budai	Anna	2012	3351748	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
a4ba36d3-c94f-4be7-abe2-be781a91a4c7	f	f	2022-01-18 00:00:00	\N	Schär	Sven	2007	3017306	1	688a34cb-72f2-4920-aeb3-89325956de26	f
bbeb3d70-1dd8-4e90-8d76-88c96cdac44e	f	f	2022-01-20 00:00:00	\N	Dobmann	Dominik	1975	079723	1	81308200-79d0-466c-a19a-ca3fbef6045a	f
fc1b9b26-2fdb-4bd2-9a3f-b8c411f4b2bd	f	f	2022-02-06 00:00:00	\N	Seiler	Anna-Lena	2010	3111835	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
01030c92-61c5-4f79-8212-3a55173d20a2	f	f	2022-01-20 00:00:00	\N	Vogel	Tobias	1989	446843	1	81308200-79d0-466c-a19a-ca3fbef6045a	f
fc45aeb9-281a-4482-bc18-c35b35b2bace	f	f	2022-02-14 00:00:00	\N	Häberling	Elaina	2015	3488311	0	688a34cb-72f2-4920-aeb3-89325956de26	f
8d15484c-5014-42c7-b493-f0b6579978c2	f	f	2022-01-20 00:00:00	\N	Kummer	Basil	2009	3132909	1	81308200-79d0-466c-a19a-ca3fbef6045a	f
8e63a2c2-4fd9-4dd8-9953-a8dc48d06499	f	f	2022-02-06 00:00:00	\N	Scholl	Selina	2010	3160409	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
585af38c-93c7-4785-a962-fd318479e7f5	f	f	2022-01-20 00:00:00	\N	Nötzli	Benno	2011	3351766	1	81308200-79d0-466c-a19a-ca3fbef6045a	f
cf20aa88-3cea-4e29-b8c9-89c3b3e99c2e	f	f	2022-02-14 00:00:00	\N	Notarnicola	Romina	2012	3275180	0	688a34cb-72f2-4920-aeb3-89325956de26	f
7873ed2d-df5d-4541-987d-3d6d401e990c	f	f	2022-01-20 00:00:00	\N	Chlebny	Aleksander	2011	3094115	1	81308200-79d0-466c-a19a-ca3fbef6045a	f
a8f835d0-ca20-485c-bdf0-8ecc488ab1e4	f	f	2022-02-06 00:00:00	\N	Schmutz	Deborah	2010	3160393	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
3409cfd5-f7e4-4c8c-925d-ee2ddba3cf14	f	f	2022-01-20 00:00:00	\N	Soland	Levin	2011	3085762	1	81308200-79d0-466c-a19a-ca3fbef6045a	f
45f0ea41-9d32-47c3-bb8d-f59195846d41	f	f	2022-02-14 00:00:00	\N	Meier	Sara	2013	3458054	0	688a34cb-72f2-4920-aeb3-89325956de26	f
e4b88a97-f310-4b22-8af8-d33c896dabf0	f	f	2022-01-20 00:00:00	\N	Berg	Theodor	2012	3509796	1	81308200-79d0-466c-a19a-ca3fbef6045a	f
19eb3b8c-2a9c-4909-a852-48153ac9785d	f	f	2022-02-06 00:00:00	\N	Renggli	Mailin	2010	3160405	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
b82f2f24-5c23-4249-9413-02783705d856	f	f	2022-01-20 00:00:00	\N	Weber	Tim	2013	3337099	1	81308200-79d0-466c-a19a-ca3fbef6045a	f
8538e068-d62d-43c5-ae21-0c47a5c568c4	f	f	2022-02-14 00:00:00	\N	Widmer	Fiona	2012	3458056	0	688a34cb-72f2-4920-aeb3-89325956de26	f
d0d9e4f4-95cc-4611-b99e-27dcfe523783	f	f	2022-02-14 00:00:00	\N	Fanger	Shirin	2011	3141384	0	688a34cb-72f2-4920-aeb3-89325956de26	f
e11fac57-6be1-4244-9c9d-361177f235ac	f	f	2022-02-14 00:00:00	\N	Huber	Chantal	2011	3147480	0	688a34cb-72f2-4920-aeb3-89325956de26	f
15cd7097-57e7-4d29-8e1c-fe1f3b1c301f	f	f	2022-02-14 00:00:00	\N	Burkart	Lea	2008	3003340	0	688a34cb-72f2-4920-aeb3-89325956de26	f
61696721-1964-4ed9-93c6-231b89375d77	f	f	2022-02-14 00:00:00	\N	Berli	Lena	2009	927648	0	688a34cb-72f2-4920-aeb3-89325956de26	f
b9998e65-2891-487d-ba52-e4e239c39e7b	f	f	2022-02-14 00:00:00	\N	Leutert	Lina	2008	927643	0	688a34cb-72f2-4920-aeb3-89325956de26	f
c13629c4-97b8-4cee-81a6-bceb003bf8f7	f	f	2022-02-14 00:00:00	\N	Viskovic	Paula	2009	3142963	0	688a34cb-72f2-4920-aeb3-89325956de26	f
711698fa-5e0a-4dec-9168-b6dfe10f077c	f	f	2022-02-14 00:00:00	\N	Häberling	Leonie	2009	3094749	0	688a34cb-72f2-4920-aeb3-89325956de26	f
9dad4acd-c835-4711-9a5a-d1d1e6d86dfe	f	f	2022-02-14 00:00:00	\N	Rüegg	Lea	2008	3040408	0	688a34cb-72f2-4920-aeb3-89325956de26	f
30b8423b-989b-4118-94a9-25cc5c87dc07	f	f	2022-02-14 00:00:00	\N	Rohner	Nathalie	2009	3101043	0	688a34cb-72f2-4920-aeb3-89325956de26	f
bb41ec26-b1b4-407b-98b1-9d17bcb11f11	f	f	2022-02-14 00:00:00	\N	Bleuler	Tanja	1996	869465	0	688a34cb-72f2-4920-aeb3-89325956de26	f
ea44538b-9ca4-4d50-b2d3-beddf6836c75	f	f	2022-02-14 00:00:00	\N	Schaub	Alisha	2003	869475	0	688a34cb-72f2-4920-aeb3-89325956de26	f
2284a70c-0a8f-41dc-8074-6650ab9bba41	f	f	2022-02-14 00:00:00	\N	Zwicky	Anina	2008	3040402	0	688a34cb-72f2-4920-aeb3-89325956de26	f
5ea6fa08-0baa-4f4d-b3be-418c6a9a52a8	f	f	2022-01-18 00:00:00	\N	Accola	Cyril	2001	677072	1	688a34cb-72f2-4920-aeb3-89325956de26	f
0196ce81-9179-4c8f-83c4-d89d66d2532c	f	f	2022-01-19 00:00:00	\N	Bühlmann	Ean	2015	3555306	1	688a34cb-72f2-4920-aeb3-89325956de26	f
e40fe43e-d429-406b-8a46-9720bec4f297	f	f	2022-01-19 00:00:00	\N	Häberling	Nico	2013	3455916	1	688a34cb-72f2-4920-aeb3-89325956de26	f
92148697-c598-405e-bdd0-16a81d328b20	f	f	2022-01-19 00:00:00	\N	Jurik	Lukas	2013	3455916	1	688a34cb-72f2-4920-aeb3-89325956de26	f
c4805559-715e-4683-a517-a30714a7c295	f	f	2022-01-19 00:00:00	\N	Käppeli	Janis	2014	3455919	1	688a34cb-72f2-4920-aeb3-89325956de26	f
91caefba-e34c-4bba-b3b8-f80a1aed5a9a	f	f	2022-01-19 00:00:00	\N	Ochsner	Noé	2013	3555318	1	688a34cb-72f2-4920-aeb3-89325956de26	f
87247b7e-c974-4fe9-b496-38049c3b8231	f	f	2022-01-19 00:00:00	\N	Sinkovec	David	2003	686884	1	854e7b58-34dc-4ed5-ac6c-f233476b1e9e	f
8828320f-f23b-40fb-9868-520849448037	f	f	2022-01-19 00:00:00	\N	Heule	Fabio	2005	857381	1	854e7b58-34dc-4ed5-ac6c-f233476b1e9e	f
17a7016b-6228-4a34-809d-39402d6845c4	f	f	2022-02-08 00:00:00	\N	Bielmann	Kathaliya	2001	629345	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
4182b334-d25c-442d-85cd-af5c553cb91b	f	f	2022-01-21 00:00:00	\N	Vetter	Jann	2004	873030	1	e2438143-6017-4683-a533-6113748d4117	f
52629669-ed1c-4fe7-b9cb-9c89a48230b5	f	f	2022-02-08 00:00:00	\N	Auböck	Tiia	2014	3431056	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
7e84e7b5-869e-4a32-9b18-c94008af3c9c	f	f	2022-02-06 00:00:00	\N	Toggenburger	Sondang	2008	969255	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
5308ed6a-e60f-491a-9b2c-26da8e2cfa8e	f	f	2022-01-22 00:00:00	\N	Graf	Janis	2007	3006385	1	1d2a9859-0137-4da2-8390-6cd570385ec4	f
807e9b34-f62d-4c23-84ba-ad68f278bbe2	f	f	2022-02-02 00:00:00	\N	Forster	Nino	2007	3033303	1	0a9d4719-903b-4f31-9e00-10fc47c954fd	f
162dceab-8d0a-4e66-8cf2-7ec51717b40e	f	f	2022-01-22 00:00:00	\N	Jakobs	Gabriel	2015	3519226	1	1d2a9859-0137-4da2-8390-6cd570385ec4	f
048ae246-167f-4b2d-a737-9b9c236f002b	f	f	2022-01-22 00:00:00	\N	Kleger	Miron	2013	3522443	1	1d2a9859-0137-4da2-8390-6cd570385ec4	f
7b642841-1f01-4f84-845f-261f0fb2acda	f	f	2022-01-22 00:00:00	\N	Wisotzki	Tim	1999	321156	1	1d2a9859-0137-4da2-8390-6cd570385ec4	f
39cca78d-0cd2-4bcf-873a-912aa1f89f6e	f	f	2022-01-25 00:00:00	\N	Jankovic	Eva	2015	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
be43843b-d939-4151-8595-a42bc28e9ee3	f	f	2022-01-25 00:00:00	\N	Schneider	Juli	2013	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
ea2f0d01-e31a-4838-9997-bf6b51bf1773	f	f	2022-01-23 00:00:00	\N	Cides	Cintia	2010	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
ad3de164-62aa-489b-807e-6a8d74bc62a6	f	f	2022-02-02 00:00:00	\N	Bärlocher 	Lars	2009	3112303	1	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	f
e8cba3a1-5869-49ce-9c43-4a8224c7e2a3	f	f	2022-01-23 00:00:00	\N	Furter	Jennifer	2011	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
1a427459-e70c-4f00-bd79-85af371a4509	f	f	2022-01-23 00:00:00	\N	Iwasaki	Janina	2003	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
ba0b968d-7d83-4265-b0f5-9032be1fe45e	f	f	2022-01-28 00:00:00	\N	Widmann	Carl	2010	3102478	1	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
a55af759-b519-4b84-929d-d41846d49851	f	f	2022-01-23 00:00:00	\N	Vogt	Felix	2015	\N	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
f2a48eb7-c251-45ce-bfc4-ad3553161069	f	f	2022-02-02 00:00:00	\N	Schwarz 	Noah	2011	3297769	1	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	f
6b4dd7dc-ece8-4433-9d23-16a2928e8829	f	f	2022-01-22 00:00:00	\N	Thoma	Thierry	2012	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
354b2ec6-febd-4c82-8ce0-cb8abc99262a	f	f	2022-01-22 00:00:00	\N	Cadosch	Laurin	2010	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
00eecc59-5b8b-407d-b7cb-a3a65af878be	f	f	2022-01-23 00:00:00	\N	Perdrizat	Jan	2012	3203861	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
dbf71678-6772-4c24-8d95-2966f0afad08	f	f	2022-01-22 00:00:00	\N	Mengelt	Fabio	2008	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
88d08af0-f65d-424f-93df-8c35b8743060	f	f	2022-02-08 00:00:00	\N	Fischer	Kiana	2012	3350919	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
d6efaffe-3aa9-44b0-b5a8-1750ca799e8c	f	f	2022-02-08 00:00:00	\N	Fraccalvieri	Viola	2011	3250429	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
00c6b0c3-6141-4eec-b065-3a2d5bc9f3f3	f	f	2022-02-10 00:00:00	\N	Odermatt	Mia	2015	3502775	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
7c9b0b76-97b9-4d5e-b052-b84f1394a088	f	f	2022-02-10 00:00:00	\N	Perrenoud	Estelle	2014	3365688	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
aa86fac4-eb31-4716-89c6-dc8fdc834ae0	f	f	2022-02-10 00:00:00	\N	Temperli	Leandra	2012	3365664	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
0745244f-f816-40c0-9b1a-102fb6634fb7	f	f	2022-02-10 00:00:00	\N	Bosshard	Julia	2012	3291652	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
226cec1e-312b-42ad-bb62-7e582e7d590d	f	f	2022-02-10 00:00:00	\N	Brey	Sofia	2012	3291668	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
748aac10-5d59-4a9d-850f-942198fdae91	f	f	2022-02-10 00:00:00	\N	Holzer	Selina	2012	3333379	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
4486774f-d237-4013-b8a3-4505f52634b2	f	f	2022-02-10 00:00:00	\N	Truninger	Ladina	2011	3187216	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
2a8b0a61-8a51-47cc-840d-bb8f2df430a9	f	f	2022-01-28 00:00:00	\N	Köble	Mika	2006	960299	1	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
9b1b0d17-faa2-4e32-a7bb-ae13d77ca0fe	f	f	2022-02-10 00:00:00	\N	Christinger	Nora	2009	3124982	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
3eba3044-7c1e-482a-8eeb-a7afa3b81910	f	f	2022-01-26 00:00:00	\N	Bruggmann	Adrian	1998	542535	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
cc1458e2-677d-483e-a491-d4f268e9e405	f	f	2022-01-26 00:00:00	\N	Pommarel	Loann	1989	3483452	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
a5bd5afb-944a-4c17-9497-aa955d2a8548	f	f	2022-02-10 00:00:00	\N	Jäger	Julia	2008	3026212	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
ebf7ab72-5ca6-4aad-b3c2-544447752169	f	f	2022-01-28 00:00:00	\N	Biser	David	2008	3087086	1	86a39d76-71ed-4890-82ec-ce2a48d32627	f
25ea10eb-fe1e-4c2d-a389-478ade1ec4bf	f	f	2022-01-28 00:00:00	\N	Chenevard	Julien	2010	3196331	1	86a39d76-71ed-4890-82ec-ce2a48d32627	f
5ebd82a3-cdde-4437-a80c-93c4e71c80d4	f	f	2022-02-10 00:00:00	\N	Meier	Anouk	2009	3124984	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
98412219-6445-40a2-b56a-f7f38a4b16ff	f	f	2022-01-28 00:00:00	\N	Rüegg	Joey	2005	933993	1	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
e94538bb-c604-4b5b-bb82-de73bed9fc43	f	f	2022-01-27 00:00:00	\N	Truninger	Nico	2009	3110786	1	a5302a2b-d270-49e5-9876-47c84cb38038	f
3772babe-b218-4435-8620-ca6aa766ee13	f	f	2022-01-27 00:00:00	\N	Meier	Nils	2006	866897	1	a5302a2b-d270-49e5-9876-47c84cb38038	f
77cf5de8-333f-47de-b9a3-14e4e00fa69a	f	f	2022-01-27 00:00:00	\N	Jäger	Sascha	2006	930033	1	a5302a2b-d270-49e5-9876-47c84cb38038	f
54cf958b-d32f-4f4a-ad2c-8631dcb02d4c	f	f	2022-01-27 00:00:00	\N	Gretler	Jannik	2007	973898	1	a5302a2b-d270-49e5-9876-47c84cb38038	f
56472a30-b319-4304-a86b-0eced54ede6c	f	f	2022-01-27 00:00:00	\N	Müller	Gian	2013	3365668	1	a5302a2b-d270-49e5-9876-47c84cb38038	f
90cb95a6-01df-4d57-82c3-6c852dc0989a	f	f	2022-01-27 00:00:00	\N	Flisch	Andrin	2006	930012	1	a5302a2b-d270-49e5-9876-47c84cb38038	f
932c4b6f-eb11-4965-9328-2c7ba3dad7ab	f	f	2022-02-10 00:00:00	\N	Hochuli	Nina	2008	3026208	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
ab7d9af9-f436-4167-9504-bd973e5f2855	f	f	2022-02-10 00:00:00	\N	Gretler	Alina	2005	707782	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
b8044329-1d25-4c31-9f42-ca73102f3396	f	f	2022-02-12 00:00:00	\N	Huber	Norina	2014	3541194	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
b4c08eda-6c89-4078-bca0-5e994bb233ad	f	f	2022-01-29 00:00:00	\N	Eicher	Robin	2013	\N	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
adcce6c1-2fe3-4199-9f9d-222464c36ef5	f	f	2022-01-29 00:00:00	\N	Fankhauser	Finn	2010	981917	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
c5190daa-724d-4e95-b36c-b6b8401181e1	f	f	2022-02-12 00:00:00	\N	Derungs	Elisa	2013	3479005	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
3ccaf659-c761-4618-a3a9-2d25a1b3b0ea	f	f	2022-02-12 00:00:00	\N	Tüscher	Liv	2014	3541198	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
872953fe-6548-4728-80ef-25e66b8e8edc	f	f	2022-02-12 00:00:00	\N	Reuter	Amélie	2016	3438782	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
37d27df3-0635-4f62-8259-3badb1627eb9	f	f	2022-02-14 00:00:00	\N	Meyer	Celine	2014	3476042	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
a4cf5270-3435-49d8-a4d7-40b070f1c4ab	f	f	2022-01-29 00:00:00	\N	Keller	Claudio	2006	930826	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
699c9855-119d-4bd7-9e00-61aff964bc39	f	f	2022-01-29 00:00:00	\N	Kunz	Andreas	2013	3116499	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
44ef5cf2-c181-48cc-acaf-1d4d4600f5d5	f	f	2022-02-14 00:00:00	\N	Spandel	Svenja	2014	3476059	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
b7dcdcf8-3950-4a59-a3da-4c670c5dd8cb	f	f	2022-02-14 00:00:00	\N	Rica Rodriguez	Adriana	2012	3476055	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
c889dac3-63c1-46bc-a3b3-7e6cf4e5dd48	f	f	2022-02-14 00:00:00	\N	Graf	Tindra	2013	3378705	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
8dce089f-221a-4603-950b-29d30d67dd32	f	f	2022-02-14 00:00:00	\N	Fünfschilling 	Tara	2011	3175468	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
75c0768e-754b-4683-9721-c0a4a7964a74	f	f	2022-02-14 00:00:00	\N	Vincenti	Chiara	2012	3293086	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
4d9eeece-35cb-4d9c-8163-b4285abccaab	f	f	2022-02-14 00:00:00	\N	Flace	Siria	2010	3378704	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
a9c6afa4-bc6b-416d-82d5-b9464c41a98b	f	f	2022-02-14 00:00:00	\N	Siegrist	Fiona	2010	3175476	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
0a086872-16f7-44f0-840b-117b7903f985	f	f	2022-02-14 00:00:00	\N	Guyer	Sarina	2009	3124795	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
119aa0b4-98bc-4323-ba79-ffe4b341702e	f	f	2022-02-14 00:00:00	\N	Minocchieri	Anina	2010	3124796	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
fd260ab3-e112-4b4d-baf9-ce4b8829fd58	f	f	2022-02-14 00:00:00	\N	Trapl	Helena	2011	3293076	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
32860ba8-3a33-489d-8aff-9bb9b183dee0	f	f	2022-02-08 00:00:00	\N	Volkart	Lorena	2004	629280	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
93415e0e-0c3f-490b-9a56-51cd145b192f	f	f	2022-02-02 00:00:00	\N	Lazzarotto	Chris	2004	1455625	1	0a9d4719-903b-4f31-9e00-10fc47c954fd	f
9fc87fff-2510-4327-9c0e-7a05f3085dd8	f	f	2022-02-08 00:00:00	\N	Maier	Elin	2013	3431047	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
5ba9bebb-f42b-4cf6-8f72-33440f811075	f	f	2022-01-22 00:00:00	\N	Röhl	Joel	2005	905973	1	1d2a9859-0137-4da2-8390-6cd570385ec4	f
d43d9929-5474-410d-be56-2e0858b14f23	f	f	2022-02-08 00:00:00	\N	Zuka	Inara	2014	3514076	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
6a6cbadd-e5f8-44da-bd2e-ff472f2411be	f	f	2022-02-06 00:00:00	\N	Dogu	Aleyna	2011	3160427	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
0124ca13-e5bc-4aa9-a952-eaa5dac28170	f	f	2022-02-06 00:00:00	\N	Borioni	Noana	2008	3056648	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
f769707d-eab4-4f6c-acfb-f5ec0ccf5265	f	f	2022-01-25 00:00:00	\N	Kolk	Nele	2015	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
f917de79-0c46-4ee7-8d8d-5188b811ed2f	f	f	2022-01-25 00:00:00	\N	Peterhans	Juna	2014	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
820d720b-c897-4ab9-8c4a-b42008ecba02	f	f	2022-02-08 00:00:00	\N	Saado	Eléa	2014	3431054	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
e4bf8718-c22f-4d12-a204-b1f80a6bda49	f	f	2022-02-08 00:00:00	\N	Gross	Giuliana	2004	853063	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
b437e6cc-1184-44f5-ba23-558e718213a4	f	f	2022-01-22 00:00:00	\N	Caminada	Nico	2008	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
e39700e8-07a8-4fd5-9bc3-b128ee229568	f	f	2022-01-22 00:00:00	\N	Caviezel	Tiziano	2007	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
d5c1bd8a-e192-4e5d-9006-9d4a6ac3512d	f	f	2022-01-27 00:00:00	\N	Schiesser	Viviane	2000	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
12452659-e21d-48c7-8f95-ead28d3f8040	f	f	2022-01-23 00:00:00	\N	Cides	Dani	2003	706740	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
c49e6c4c-a355-4993-aa0c-425282edc247	f	f	2022-01-23 00:00:00	\N	Odermatt	Lian	2010	3075189	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
3481528b-0476-4851-87cc-56138eb7d80b	f	f	2022-01-23 00:00:00	\N	Ngauv	Dustin	2004	716452	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
f43391a6-c3a4-4712-933c-2738f2c3930c	f	f	2022-01-25 00:00:00	\N	Karlen	Emylia	2015	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
5a16c40e-58cb-409b-8a10-e64555b3a757	f	f	2022-01-26 00:00:00	\N	Furger	Jari	2014	3261643	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
de0d5c86-4883-4f47-ad70-a6aa4dfea332	f	f	2022-01-25 00:00:00	\N	Hänni	Maurus	2007	\N	1	2fc3365b-34d9-4054-b2d8-aa859c7455e7	f
4e732183-e839-4bcf-9a5b-e507bb5f9a03	f	f	2022-01-28 00:00:00	\N	Violetti	Sämi	2003	705154	1	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
64e32826-941e-4a21-b418-505b0e56fda2	f	f	2022-01-26 00:00:00	\N	Bucher	Andrin	2011	3243445	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
a5782e2d-3217-4d6c-9700-f5d13cce0b68	f	f	2022-02-08 00:00:00	\N	Rickenbach	Nina	2014	3114590	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
73d1c77a-a7bf-4b00-9ddf-7056f107817e	f	f	2022-02-08 00:00:00	\N	Walser	Sarina	2011	3110349	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
8bca5f87-48cf-4df8-851a-f17791ca27f3	f	f	2022-01-26 00:00:00	\N	Smoron	Damian	2010	3095433	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
a20a71d7-7882-42b2-855a-641b66a39208	f	f	2022-02-14 00:00:00	\N	Fasser	Lia	2015	3431155	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
b0e58619-9fdd-4bd0-bbf2-1cec57bf0267	f	f	2022-02-10 00:00:00	\N	Angst	Romy 	2011	3240608	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
d01fcdbe-4deb-4c39-bfea-aee0e3b915b5	f	f	2022-02-10 00:00:00	\N	Kämpfer	Janina	2012	3291673	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
1c8eb3d9-4190-4f9d-bb86-9800a8557b88	f	f	2022-01-26 00:00:00	\N	Carrel	Micha	2001	571392	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
29ffbb9b-dcc7-4571-8087-4c08ef784bc3	f	f	2022-02-10 00:00:00	\N	Eglseer	Aline	2011	3187271	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
dee1d772-12cb-43fb-9ddf-f671fdc2b9b0	f	f	2022-01-26 00:00:00	\N	Pfaller	Raffael	1998	566383	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
a5790b87-a247-4938-8f62-d854f2953fc1	f	f	2022-02-10 00:00:00	\N	Furrer	Livia	2012	3187224	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
3318206c-684c-4038-9ec5-798f9f0b6e1e	f	f	2022-02-12 00:00:00	\N	Chiasserini	Mia	2011	3366462	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
6f5edf06-9cbc-4d08-a7b1-88f0e8d8ae35	f	f	2022-02-10 00:00:00	\N	Perrenoud	Mina	2011	3291701	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
19e3f121-7083-44cd-8c12-7c44f05fe500	f	f	2022-01-28 00:00:00	\N	Volkart	Yannick	2001	629281	1	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
a13d3bbe-79d2-4ead-a9ed-ee5fa1198b59	f	f	2022-02-14 00:00:00	\N	Bertschinger	Livia	2005	3562107	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
78096179-2af4-4450-b4a6-8d8898d86292	f	f	2022-02-14 00:00:00	\N	Wolf	Nora	2012	3406726	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
d5e46bba-7a13-487c-9aea-180157fd8a02	f	f	2022-02-10 00:00:00	\N	Berger	Ladina	2010	930705	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
4e8cb30e-2ec4-45f5-8b3a-c64e308fbb92	f	f	2022-02-10 00:00:00	\N	Bernhard	Mia	2006	930023	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
ca588032-b5f0-4e01-b110-d2604ac0e738	f	f	2022-01-28 00:00:00	\N	Morgenegg	Luca	2012	3250435	1	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
482b3c30-5be6-4492-a5cb-7ad1f89150f7	f	f	2022-02-10 00:00:00	\N	Camenzind	Seraina	2006	930026	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
4444edf2-534e-42cf-8d1f-48b31c60e90d	f	f	2022-02-10 00:00:00	\N	Ochsenbein	Lara	1999	707791	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
9ac6942e-af1a-4ac4-8208-e529cc05ac3f	f	f	2022-02-14 00:00:00	\N	Wietlisbach	Emma-Rose	2015	3476984	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
74ca681f-08b0-49df-8ebd-20e38011e269	f	f	2022-01-28 00:00:00	\N	Leisi	Max	2011	3425584	1	86a39d76-71ed-4890-82ec-ce2a48d32627	f
8eff3577-8500-4dff-93a5-faa4d33fa2e3	f	f	2022-01-28 00:00:00	\N	Kurz	Juan	2010	3220317	1	86a39d76-71ed-4890-82ec-ce2a48d32627	f
4cd54a77-8a8a-4bba-a33a-78c4be46eaab	f	f	2022-02-14 00:00:00	\N	Martin	Isabel	2014	3476978	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
255f7854-e5ef-46cf-8bb5-9df68b75b232	f	f	2022-01-29 00:00:00	\N	Baumann	Elias	2009	\N	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
da5feae4-a7ea-4ed8-9749-94f7ada45d59	f	f	2022-02-14 00:00:00	\N	Hanimann	Sandrina	2009	3043628	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
4a9ef47d-7a3a-4c9f-9761-a5c7422fef1c	f	f	2022-01-29 00:00:00	\N	Hirzel	Jelle	2008	3286590	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
a272147d-82d6-4b86-9d4e-5076494a6500	f	f	2022-02-14 00:00:00	\N	Fünfschilling	Tatjana	2014	3476029	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
c6e64f28-0606-482c-9190-ef875a83f9a7	f	f	2022-02-14 00:00:00	\N	Prakash	Ramona	2011	3293074	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
717ef780-9fcf-4658-9db6-693e62764908	f	f	2022-01-29 00:00:00	\N	Nock	Rico	1997	679874	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
3375fcba-0144-4efa-ac46-160742fef0aa	f	f	2022-01-29 00:00:00	\N	Meyer	Lorin	2010	3072773	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
688c540f-f846-437b-9884-875d19b83002	f	f	2022-01-29 00:00:00	\N	Meyer	Joel	2006	930860	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
f4baa885-6558-49ee-961c-2460d24b90fa	f	f	2022-02-14 00:00:00	\N	Guyer	Leandra	2011	3293070	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
28ab6e33-9ef1-46f6-b2ef-82a2d3089947	f	f	2022-01-29 00:00:00	\N	Schoch	Sven	2001	679904	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
4eb11125-35a5-4152-8aeb-8f6721e69f32	f	f	2022-02-14 00:00:00	\N	Ricciardi	Valeria Jamie	2011	3175472	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
113ef945-991a-401f-ba5b-25e02bceaa13	f	f	2022-02-14 00:00:00	\N	Alaoui	Sara	2008	3075350	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
3079af91-3596-46e2-91ea-aa04659babd2	f	f	2022-02-14 00:00:00	\N	Trapl	Theresa	2011	3293081	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
c33749e2-6b2a-40cf-a699-fbaa97c1a492	f	f	2022-01-29 00:00:00	\N	Seeberger	Fabrizio	1995	679906	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
72afd313-31ba-4a08-b737-fa602d694892	f	f	2022-01-29 00:00:00	\N	Schuppli	Dario	2014	\N	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
29418401-87df-43e9-9901-12848ab49f09	f	f	2022-01-29 00:00:00	\N	Studer	Singto	2013	\N	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
1fcb183f-192a-477a-822b-1628def7bf3b	f	f	2022-01-29 00:00:00	\N	Waldvogel	Remo	2011	3283131	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
afe3bbf8-c9d3-46af-9e74-0542ec131d89	f	f	2022-01-29 00:00:00	\N	Tramontana	Lorenzo	2012	3514926	1	80c08ccc-c90e-4377-af3b-2de779197c7a	f
8a7f4911-b143-4c6b-9cda-40c426158f0d	f	f	2022-01-30 00:00:00	\N	Maurer	Jeremy	2011	3269631	1	1030974d-cffe-46d6-b6ea-79c8839cf2ea	f
e6ab3234-26db-4ab3-9597-3a7eca95d380	f	f	2022-02-08 00:00:00	\N	Berini	Laura	2010	3169940	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
46849279-dfbe-494c-a436-b7ab726d075d	f	f	2022-02-08 00:00:00	\N	Hunyady	Milla	2010	3151157	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
0519f83a-fe03-474f-a300-5807cfcfe32b	f	f	2022-02-06 00:00:00	\N	Schnorf	Carmen	1991	982875	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
dabd45d7-46d4-4eac-b12c-5665fcb3b089	f	f	2022-02-06 00:00:00	\N	Hirzel	Isabel	1999	647065	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
02a156d2-3f1d-4371-b9ed-2e9cdc2a1905	f	f	2022-01-22 00:00:00	\N	Baur	Philipp	2008	3047041	1	1d2a9859-0137-4da2-8390-6cd570385ec4	f
d07fba0a-40a9-4b74-a6f8-e8227e6f47e1	f	f	2022-02-05 00:00:00	\N	Tanner	Luca	2013	3472956	1	80c08ccc-c90e-4377-af3b-2de779197c7a	f
6daae379-0879-4ccd-8690-b64aebc2d7d6	f	f	2022-02-06 00:00:00	\N	Beerli	Svenja	2007	994192	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
4c077309-01dd-4031-a3a1-5bb961e44456	f	f	2022-01-25 00:00:00	\N	Perotto	Anna	2014	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
2a5040fd-e605-40e5-96da-7b86da83c9f6	f	f	2022-02-08 00:00:00	\N	Marsella	Valerie	2012	3501911	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
fad485ef-5f14-4a7e-b330-eb8b3277b4d8	f	f	2022-01-25 00:00:00	\N	Schädeli	Mea	2016	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
b4dc29c0-a537-41b1-9f13-a6dd38e7725d	f	f	2022-01-23 00:00:00	\N	Odermatt	Robin	2007	850850	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
b1e4025d-1ba5-4fb4-b21c-00c8e74c1db5	f	f	2022-01-23 00:00:00	\N	Stuker	Neilo	2011	3069590	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
81acf225-0226-4232-b5be-2691aa4fc5f8	f	f	2022-01-22 00:00:00	\N	Maissen	Gianluca	2006	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
970554d5-e2bb-4a11-9b3b-4d5f21f3c044	f	f	2022-01-25 00:00:00	\N	Schlatter	Mina	2013	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
e4bf521f-e7b9-40c3-95e3-d2e43966ca55	f	f	2022-01-25 00:00:00	\N	Kehrli	Max	2011	\N	1	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
aaa1c9c5-c724-45eb-93ea-f84da94414d4	f	f	2022-02-08 00:00:00	\N	Oertig	Lea	2014	3514074	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
cf890313-5432-4db1-a371-2ddbc6fd2b03	f	f	2022-01-28 00:00:00	\N	Forster	Emanuel	1995	855571	1	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
d2d3bfd6-d7e9-4074-a64b-dca909758826	f	f	2022-01-28 00:00:00	\N	Hutmacher	Nick	2011	3141911	1	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
e0d4a99d-16e6-4e8d-b2b3-897d3c13c5e0	f	f	2022-02-08 00:00:00	\N	Horisberger	Emily	2015	3514081	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
43991b09-dc91-4ec5-85c2-812d4fda208b	f	f	2022-02-08 00:00:00	\N	Hurter	Yael	2015	3514079	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
056b99cb-c46d-4a05-aa6a-efbca6a73941	f	f	2022-02-03 00:00:00	\N	Sigrist	Rafael	2013	3554494	1	1d2a9859-0137-4da2-8390-6cd570385ec4	f
f4b75c50-054e-4da8-8350-1d84232b6441	f	f	2022-01-25 00:00:00	\N	Meier	Nick	2008	984444	1	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
fb96c26d-e059-4953-93f3-1edb8537c221	f	f	2022-02-08 00:00:00	\N	Joosten	Mia	2013	3431049	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
ee8bd0f6-ef50-4835-b432-d9772ee52836	f	f	2022-02-08 00:00:00	\N	Pfanner	Mara	2014	3536236	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
7e3f0c97-7735-411d-903d-dd8b4faa323c	f	f	2022-02-08 00:00:00	\N	Hutmacher	Sven	2012	3383256	1	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
fc09e934-9292-407f-9d99-ce981c8b18ea	f	f	2022-01-25 00:00:00	\N	Kapp	Gorian	0	\N	1	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
99047440-a28d-4a9e-98c9-8a5a5b2d7517	f	f	2022-02-08 00:00:00	\N	Lichtsteiner	Simon	2012	3383262	1	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
7eb4ca01-299a-444a-8123-0c8f553d0718	f	f	2022-01-25 00:00:00	\N	Dubs	Janick	2008	984439	1	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
7cbd7c2a-ea74-4cb2-92b2-639c5c240c05	f	f	2022-02-12 00:00:00	\N	Hueber	Melina	2015	3541196	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
329b27f5-9daf-4ead-a213-4450a26db0a4	f	f	2022-01-26 00:00:00	\N	Näf	Noé	2012	3044734	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
c1358ce6-29dc-41a3-a780-a5c48ae1b56f	f	f	2022-02-10 00:00:00	\N	Frei	Julia	2014	3365677	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
f76c2109-3f86-4463-b6c3-57caca3c80b0	f	f	2022-02-10 00:00:00	\N	Temperli	Selina	2010	3291710	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
ddc5d1c7-f3d8-4321-a137-f344eab4ad9a	f	f	2022-01-26 00:00:00	\N	Pfaller	Florian	2010	3141555	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
80afde5c-229d-4a0c-820f-8c383eb323c3	f	f	2022-02-10 00:00:00	\N	Furrer	Leonie	2010	3125737	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
7c25b5c2-b0f8-4e54-8169-7b5c2c99796a	f	f	2022-01-26 00:00:00	\N	Krebs	Jonas	2011	959718	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
5b95f7b0-3a83-4080-8185-77f995be163b	f	f	2022-02-10 00:00:00	\N	Mannhard	Enya	2009	3291719	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
97df0cc6-12d7-4f17-b20b-0f4cba6d9e77	f	f	2022-01-26 00:00:00	\N	Milz	Jannis	2006	593412	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
e9708e57-9005-42cc-8cc1-6e0997818651	f	f	2022-02-10 00:00:00	\N	Christinger	Lea	2006	930025	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
6a361cdd-1a65-4bbe-b3ac-678e202493a6	f	f	2022-01-26 00:00:00	\N	Schmid	Riccardo	2003	517968	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
81d5230e-58d7-4d37-bf60-291fab6f512b	f	f	2022-02-10 00:00:00	\N	Häringer	Ina	2008	3026211	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
69e1bb2b-070f-4040-b8ef-efb8c540e48b	f	f	2022-02-10 00:00:00	\N	Schmid	Jessica	2007	3026199	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
06301f4d-1a1d-470f-8a59-cce725273087	f	f	2022-02-12 00:00:00	\N	Huber	Erin	2014	3541192	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
288bf42c-3a48-490f-be92-896fa147a5dd	f	f	2022-02-10 00:00:00	\N	Truninger	Andrina	2004	707793	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
19f82a37-8d51-4782-a8e9-d863103be5e5	f	f	2022-02-10 00:00:00	\N	Pavesi	Fabienne	1994	609499	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
1a8edb59-237a-4d99-8418-f74975fe3f25	f	f	2022-02-12 00:00:00	\N	Uhlmann	Neva	2013	3281676	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
a6493824-cca4-4c7c-a202-3dd0a04b1f3e	f	f	2022-01-28 00:00:00	\N	Schnitzler	Felix	2001	629357	1	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
a0f3f7b1-957f-4390-92e5-64c5c8729e94	f	f	2022-01-28 00:00:00	\N	Volkart	Timo	2006	960297	1	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
ef0c9179-4406-4457-a6d9-0d169f39aa12	f	f	2022-02-12 00:00:00	\N	Wanner	Taina	2010	3007828	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
b62a15ae-bb28-4457-b078-8abcb6245e7c	f	f	2022-01-28 00:00:00	\N	Studer	Fabian	2007	3074491	1	86a39d76-71ed-4890-82ec-ce2a48d32627	f
ec9a0640-39c3-4a97-9f1d-63acf4630589	f	f	2022-02-14 00:00:00	\N	Schmidli	Lorena	2008	956040	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
0c5561bd-4984-4715-b885-ad7f957d7a78	f	f	2022-02-14 00:00:00	\N	Müller	Anna	2011	3146126	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
9e151d5e-fc95-4cb0-b122-32dd2428977e	f	f	2022-02-14 00:00:00	\N	Flüglister	Lara	2013	3309777	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
9ed30a96-af19-43db-89f3-73ca4df8b908	f	f	2022-01-28 00:00:00	\N	Denzler	Silvan	2007	966394	1	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
519ef3f1-fde8-4c15-8bf0-ddf1908a8dac	f	f	2022-02-14 00:00:00	\N	Tunkli	Jàzmin	2012	3293084	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
0f28a350-d776-47da-8cec-e1897a044f8c	f	f	2022-02-14 00:00:00	\N	von Treskow	Clara	2013	3230046	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
a5d567e3-5134-4a77-a739-019c4b90404a	f	f	2022-01-29 00:00:00	\N	Bodenmann	Falk	2007	3118478	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
f24aa5e9-e827-45a8-9644-2745b5a1d6dd	f	f	2022-01-29 00:00:00	\N	Bischofberger	Levi	2012	\N	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
600aed34-2b3f-4b2f-b994-c88cc057fa1f	f	f	2022-02-14 00:00:00	\N	Ricciardi	Alessia Josie	2009	3124797	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
b1633444-8257-4756-8073-6db26001c999	f	f	2022-02-14 00:00:00	\N	Meier	Jana	2006	920765	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
8d849044-eaf0-45cd-bdb2-6fb2c61d0f51	f	f	2022-01-29 00:00:00	\N	Kühne	Leandro	2007	1683736	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
43f462b2-d838-4f31-a4ee-2814fb879e0f	f	f	2022-02-14 00:00:00	\N	Arnold	Jasmin	2007	984470	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
b1ce1724-b0cd-412f-b359-8539992a2cdc	f	f	2022-01-29 00:00:00	\N	Schoch	Nico	2002	679902	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
12274a9f-83e7-4247-9c43-a01d7cd613fc	f	f	2022-01-29 00:00:00	\N	Keller	Julian	2005	930830	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
7f322799-cd31-402a-b52f-e49d01f09993	f	f	2022-01-29 00:00:00	\N	Long	Oliver	2012	3388692	1	80c08ccc-c90e-4377-af3b-2de779197c7a	f
ecb1f79f-955a-4f6c-b384-9a4bafff1d35	f	f	2022-01-30 00:00:00	\N	Djebrit	Aissa	2013	3459765	1	1030974d-cffe-46d6-b6ea-79c8839cf2ea	f
96f979f4-2153-47dd-9ecb-87641f8f0749	f	f	2022-01-30 00:00:00	\N	Weeks	Nikola	2014	3558121	1	1030974d-cffe-46d6-b6ea-79c8839cf2ea	f
ed4e39f4-57d9-4005-9be0-dea0858e0281	f	f	2022-01-30 00:00:00	\N	Weeks	Nemanja	2012	3558119	1	1030974d-cffe-46d6-b6ea-79c8839cf2ea	f
4854fa23-b4e4-48d6-840e-54088b5b0f72	f	f	2022-01-21 00:00:00	\N	Landolt	Maurice	2013	\N	1	e2438143-6017-4683-a533-6113748d4117	f
51141fff-f4ec-4329-86d0-3d364981b666	f	f	2022-02-06 00:00:00	\N	Beaton	Zoe	2009	3132855	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
eaf4e0de-e70e-40ab-9d96-f534465d0a1d	f	f	2022-02-06 00:00:00	\N	Chlebny	Helena	2014	3422879	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
1f2c9273-0d7b-48c3-80f1-e332bfa394a5	f	f	2022-02-06 00:00:00	\N	Brombacher	Emma	2010	3125093	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
e4f09bb0-eef8-4a1a-8b21-cba9bb7910c3	f	f	2022-01-22 00:00:00	\N	Hoch	Cedric	2011	3227881	1	1d2a9859-0137-4da2-8390-6cd570385ec4	f
df4a26ac-5018-45bf-9df8-52070b216dac	f	f	2022-02-06 00:00:00	\N	Jäger	Lenya	2009	3107725	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
f1e4f67e-c63b-4de7-b53d-ffb0b975c9aa	f	f	2022-01-25 00:00:00	\N	Finocchio	Tara	2012	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
08b408c6-3097-43bb-b67e-091451c7f1e0	f	f	2022-02-06 00:00:00	\N	Kuipers	Nienke	2010	3351761	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
cf654f83-de82-4d41-a843-2dde0799e14a	f	f	2022-02-08 00:00:00	\N	Gagaine	Emija	2008	3009074	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
af32f4b2-a4e5-4fad-be72-f947b978f9f7	f	f	2022-02-05 00:00:00	\N	Vicente	Emily	2014	3466354	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
a1c3ceae-a308-4b08-8298-f00bff2a654a	f	f	2022-02-06 00:00:00	\N	Zängeler	Celina	2008	3056657	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
a49ea6a6-30e5-482e-962c-458b747f23a8	f	f	2022-02-06 00:00:00	\N	Straus	Kim	2009	3149366	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
88a07c39-d9a1-4c44-a9f9-b42bb4e603cd	f	f	2022-02-06 00:00:00	\N	Pfyl	Jessica	2009	3053717	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
51ba98e7-d5a9-4647-ad29-274b2c02437e	f	f	2022-02-06 00:00:00	\N	Oesch	Nura	2008	993309	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
c8da0297-b38a-4b15-8cf1-e621a9b319af	f	f	2022-02-06 00:00:00	\N	Pletscher	Ronja	2010	3107729	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
8be21209-74dc-43f2-90ae-899edab1754e	f	f	2022-02-06 00:00:00	\N	Jorns	Alina	2009	3351755	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
b0b84556-1154-49ae-b24c-d48601a68237	f	f	2022-01-21 00:00:00	\N	Kaussen	Isabel	2011	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
2fdb9ffd-a9d6-42ce-a6ac-cfe5b0f947cd	f	f	2022-02-06 00:00:00	\N	Stocker	Jil	2010	3291644	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
121df43d-4074-45a0-9e24-89d43c0ff9ee	f	f	2022-01-25 00:00:00	\N	Arnold	Damian	2005	851429	1	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
2c7dbbd4-245d-427b-8736-aaf4057255c9	f	f	2022-02-06 00:00:00	\N	Widmer	Louisa	2011	3152145	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
27a8a796-f642-43df-862a-d6918cc9ca50	f	f	2022-02-06 00:00:00	\N	Meier	Haily	2011	3152136	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
3e48b69f-527a-4e13-bb7a-25dc5943ecc3	f	f	2022-01-26 00:00:00	\N	Pfaller	Philip	2010	3141557	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
0c2aa755-6cfc-4ed3-93af-1c84919de12d	f	f	2022-02-06 00:00:00	\N	Eichenberger	Sophie	2011	3152132	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
f66e79e7-bc77-4efe-a823-9253e5cbc9c8	f	f	2022-01-26 00:00:00	\N	Häberli	Nico	2004	542994	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
8caf591f-960a-40fb-9963-39b42a8484c6	f	f	2022-01-22 00:00:00	\N	Gisi	Lukas	1999	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
74843001-070e-4620-9e01-b86ab5970a9f	f	f	2022-02-14 00:00:00	\N	Zaugg	Michelle	2014	3562114	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
af4f44cd-0ac8-4782-9beb-4817b40dbf42	f	f	2022-01-22 00:00:00	\N	Tschalèr	Danik	2009	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
b26369da-8a80-4bf2-85e7-6f89ee0f5df2	f	f	2022-02-14 00:00:00	\N	Müller	Lina	2013	3406711	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
d18b15cc-8213-4292-aafb-6a7a87597f08	f	f	2022-01-22 00:00:00	\N	Maissen	Rico	2008	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
2a495017-a1ec-4997-b0ff-b5f5b1292eaa	f	f	2022-01-22 00:00:00	\N	Thoma	Fabrice	2009	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
a7efed26-f4ec-4d7b-aa45-ce138c08d8b5	f	f	2022-01-23 00:00:00	\N	Mostak	Elias	2011	3146125	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
15d35492-6126-46c1-a8ec-6d61cc113be1	f	f	2022-01-23 00:00:00	\N	Dette	Laurenz	2013	3480247	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
1cfd9655-d0a7-41c5-b3b2-10fd42f07084	f	f	2022-01-23 00:00:00	\N	Schmidli	Fabio	2005	623594	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
81141c69-6869-4cfe-8e99-48e56e882f71	f	f	2022-01-23 00:00:00	\N	Tunesi	Dario	2011	3146129	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
2e968f4d-61d5-4b5c-a7e3-3de96e5e6657	f	f	2022-02-06 00:00:00	\N	Wettenschwiler	Mia	2011	3152144	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
da115d88-2870-45bc-9739-f9c6728097b2	f	f	2022-01-25 00:00:00	\N	Benz	Maximilian	2009	1979436	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
23f6b48b-fc39-42e8-a995-948ba22a5750	f	f	2022-01-27 00:00:00	\N	Truninger	Gian	2013	3365671	1	a5302a2b-d270-49e5-9876-47c84cb38038	f
ea49f3ca-5003-4032-ab34-d722cfda87ab	f	f	2022-02-06 00:00:00	\N	Grossenbacher	Cheyenne	2010	3152134	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
5cdcf9db-8780-4d70-b7e6-c55041131f31	f	f	2022-02-06 00:00:00	\N	Britt	Leni	2012	3291078	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
b2b033c1-ae1e-46c1-a971-2ffdb7a4118a	f	f	2022-01-21 00:00:00	\N	Ammann	Max	2013	\N	1	e2438143-6017-4683-a533-6113748d4117	f
637639e0-eab2-49e9-aaf5-d25d31995a30	f	f	2022-02-06 00:00:00	\N	Grauf	Naima	2011	3291617	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
b1e9adff-9671-4584-9e01-71f73814ad78	f	f	2022-01-21 00:00:00	\N	Aeberhard	Silvan	2003	869426	1	e2438143-6017-4683-a533-6113748d4117	f
e7bd8211-f920-4efa-a97f-bd9aca38014b	f	f	2022-02-06 00:00:00	\N	Cuppone	Giuliana	2012	3351752	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
fab019bc-a424-439d-bcc5-9f3ff55bc25e	f	f	2022-01-21 00:00:00	\N	Brandenberger	Jori	2012	5215414	1	e2438143-6017-4683-a533-6113748d4117	f
91a3f77c-3ba9-4c07-823a-627fead3c2a5	f	f	2022-02-06 00:00:00	\N	Weber	Therese	2012	3317510	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
daf319cf-daf5-4172-861a-d0d8af80bd76	f	f	2022-01-21 00:00:00	\N	Halbritter	Julien	2013	3385157	1	e2438143-6017-4683-a533-6113748d4117	f
1891d952-6085-437f-8848-0821670cafbe	f	f	2022-02-06 00:00:00	\N	Jorns	Elea	2012	3351757	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
90a30b6c-edaf-468d-a96d-b9439e5e4c16	f	f	2022-02-06 00:00:00	\N	Budai	Emma	2012	3351750	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
73fa3706-776e-4728-bffb-a0bdf5542431	f	f	2022-02-06 00:00:00	\N	Marrero	Ayleen	2012	3325919	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
57554ab0-0176-4a04-926e-a9c6c85fec2d	f	f	2022-02-06 00:00:00	\N	Schneider	Jalina	2012	3456405	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
c37872ea-37e8-47f1-9af3-16a2cfbc474e	f	f	2022-02-06 00:00:00	\N	Brombacher	Anabel	2014	3340571	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
7af09c92-0722-4781-99bd-4061b9c4a23a	f	f	2022-02-06 00:00:00	\N	Weber	Alexandra	2014	3351771	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
35ef02f5-6e0d-4b15-a261-0c04aefd8dcc	f	f	2022-02-06 00:00:00	\N	Ryffel	Elina	2014	3456403	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
6ccc065f-7240-440e-9984-bf06ce6abd72	f	f	2022-02-06 00:00:00	\N	Howard	Holly	2013	3456388	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
2b950d2f-e455-4479-a2c0-87a7cb06265e	f	f	2022-02-06 00:00:00	\N	Öncü	Serenay	2014	3456398	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
19bfa43e-bd2a-418f-9561-57f708c74bba	f	f	2022-02-06 00:00:00	\N	Rupp	Emily	2014	3409564	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
ef1cb3e8-e586-45bd-9858-b9f7f0edc56f	f	f	2022-02-06 00:00:00	\N	Dietz	Lily	2006	962259	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
6f9ec879-5961-4840-877e-b9de6defcde7	f	f	2022-02-14 00:00:00	\N	Feuerlein	Dana	2009	3224382	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
e491e655-63e1-40ed-b732-a733a78f3e00	f	f	2022-02-06 00:00:00	\N	Seiler	Hannah	2012	3292612	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
0cb847e6-92fd-416b-9497-7711594bb569	f	f	2022-02-14 00:00:00	\N	Greub	Yuna	2015	3476976	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
248f71cf-e0ab-43df-ac4d-27a5f4de3c8d	f	f	2022-02-06 00:00:00	\N	Safian	Carla	2012	3466581	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
51991c27-abb9-4e54-94a3-7ef5bf932dc8	f	f	2022-02-14 00:00:00	\N	Bertschinger	Zoe	2008	3075092	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
89381afc-46d6-4e04-a11c-de0320fbfc78	f	f	2022-02-14 00:00:00	\N	Umbricht	Mia	2013	3378706	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
ee28252a-ed46-4f20-ac8d-b4668af7a11a	f	f	2022-02-14 00:00:00	\N	Hofmann	Ronja	2009	3175409	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
58f975ec-5698-4901-a51b-2ed21231a06b	f	f	2022-02-14 00:00:00	\N	Rossbach	Alicia	2010	3124798	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
02df6e15-dc3b-4178-aa36-6143fd599b1a	f	f	2022-02-14 00:00:00	\N	Rossbach	Noelia	2006	955933	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
3c9f3b45-0056-4218-8d92-9315134151fe	f	f	2022-01-30 00:00:00	\N	Riesen	Colin	2014	3481652	1	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
48bc951f-879f-41b0-af57-1817fd5a32ab	f	f	2022-01-30 00:00:00	\N	Utz	Elia	2014	\N	1	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
10b52c4b-af2d-4754-8291-1d05c5e206bc	f	f	2022-02-02 00:00:00	\N	Peyer	Janis	2010	3169598	1	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	f
bed78fb6-a0d8-4214-b76c-9a20c023e09d	f	f	2022-01-30 00:00:00	\N	Lamprecht	Maurus	2011	3174112	1	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
584dce6b-51c3-4e4f-92ce-988b3020d7de	f	f	2022-02-02 00:00:00	\N	Madumere	Ikenna	2013	3442230	1	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	f
645f1e3e-fc8e-4aad-a4fa-cddf26df1a51	f	f	2022-01-30 00:00:00	\N	Meister	Joël	2009	3481650	1	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
3efeaf18-c1f1-4693-83ce-5d74f9e84d6b	f	f	2022-02-02 00:00:00	\N	Matter	David	2014	3523800	1	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	f
aa43a930-a178-47ee-a402-b64fbe2277d7	f	f	2022-02-02 00:00:00	\N	Hamburger	Sebastian	2004	664625	1	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
5e719734-7f45-4f74-bdaa-7df5db084f24	f	f	2022-02-02 00:00:00	\N	Neukom	Yanis	2015	3523951	1	a3895837-7bb9-48fa-afd0-b88c1edc7a95	f
fea4703a-9366-43db-a55f-33abfdd873f5	f	f	2022-02-02 00:00:00	\N	Angst	Kilian 	2009	3127212	1	a3895837-7bb9-48fa-afd0-b88c1edc7a95	f
bc0b61f7-f7b6-41cb-8e30-0875d044f2d8	f	f	2022-02-06 00:00:00	\N	Bleisch	Elin	2007	3107724	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
e3f00761-8a54-4a8d-bde1-59b31beb5f65	f	f	2022-02-02 00:00:00	\N	Bachmann	Marc	2011	2127233	1	fe6fd149-2231-415b-95c0-c4194aaf56a1	f
cf8f99ec-f95c-4291-9650-43dc03689ad5	f	f	2022-02-02 00:00:00	\N	Bachmann	Julien	2009	2003804	1	fe6fd149-2231-415b-95c0-c4194aaf56a1	f
b1c38bb8-d4e3-48bc-acb5-c3290a7ebd18	f	f	2022-02-02 00:00:00	\N	Schmitt	Levin	2009	1921028	1	fe6fd149-2231-415b-95c0-c4194aaf56a1	f
932ed276-a66c-407f-ad32-4e9796ae012d	f	f	2022-02-05 00:00:00	\N	Steiner	Noella	1990	498058	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
6ae5f224-0fa0-4b2d-9f63-31543847b18e	f	f	2022-02-08 00:00:00	\N	Matic	Milica	2009	3103932	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
80c04547-e962-4aba-8dfb-2b248cde50c0	f	f	2022-02-02 00:00:00	\N	Karmilov	Kirill	2005	883843	1	cfb35447-962b-479e-af0e-2f95dfbc9fde	f
c441f78b-b96d-4e73-b3f1-3c4e7e0b530b	f	f	2022-02-02 00:00:00	\N	Collins	Dylan	2010	3338244	1	cfb35447-962b-479e-af0e-2f95dfbc9fde	f
84e606b6-2732-4906-96bb-43ad01c3fdd8	f	f	2022-02-02 00:00:00	\N	Freeman	Ayden	2013	3447328	1	cfb35447-962b-479e-af0e-2f95dfbc9fde	f
78eed132-0f15-437e-ad6e-acd28388d2b0	f	f	2022-02-02 00:00:00	\N	Knecht	Nicolas	2013	3454750	1	cfb35447-962b-479e-af0e-2f95dfbc9fde	f
2403f85e-2c91-46fa-8259-7dca8da93625	f	f	2022-02-02 00:00:00	\N	Lucca	Elia	2014	3513620	1	cfb35447-962b-479e-af0e-2f95dfbc9fde	f
6a691bf4-2914-45a0-9f4c-b9c2c49d3b6d	f	f	2022-02-02 00:00:00	\N	Troppan	Stefanie	2005	884143	0	cfb35447-962b-479e-af0e-2f95dfbc9fde	f
5c653891-7bff-439e-838c-419fc44f9d47	f	f	2022-02-02 00:00:00	\N	Schneider	Valerie	2000	588706	0	cfb35447-962b-479e-af0e-2f95dfbc9fde	f
53ba0604-8d91-460a-b7c7-e586a40d5fa2	f	f	2022-02-02 00:00:00	\N	Wicki	Anja	2004	689092	0	cfb35447-962b-479e-af0e-2f95dfbc9fde	f
07e16816-0ca8-48ef-aeda-8fac182ad1dc	f	f	2022-02-03 00:00:00	\N	Correira	Luciana	2013	3516913	0	28f767de-cc97-4d11-9c40-6888376971a6	f
42c67482-c91b-42d9-8e6d-0f9b84c48b51	f	f	2022-02-03 00:00:00	\N	Heusser	Leonie	2016	3516924	0	28f767de-cc97-4d11-9c40-6888376971a6	f
e67571f2-49b9-4dc7-a11e-8d468e4e6463	f	f	2022-02-03 00:00:00	\N	Pauly	Nora	2014	3544091	0	28f767de-cc97-4d11-9c40-6888376971a6	f
451bb410-2e19-4f55-8c12-2c9216bf305e	f	f	2022-02-03 00:00:00	\N	Ettlin	Joline	2015	3516917	0	28f767de-cc97-4d11-9c40-6888376971a6	f
96890589-7dc1-4706-af25-6cf6556420a3	f	f	2022-02-03 00:00:00	\N	Huber	Isabel	2014	3516928	0	28f767de-cc97-4d11-9c40-6888376971a6	f
61f297e1-3c38-4bde-b2d5-f5fba1823ba8	f	f	2022-02-03 00:00:00	\N	Grob	Kajsa	2015	3516921	0	28f767de-cc97-4d11-9c40-6888376971a6	f
c62d70a1-a284-43d5-b460-b45037fc6c0a	f	f	2022-02-03 00:00:00	\N	Stalder	Betina	2012	3332644	0	28f767de-cc97-4d11-9c40-6888376971a6	f
d15c9c0d-c6ea-4df4-913f-3afbb68c8b49	f	f	2022-02-03 00:00:00	\N	WeberDa	Dana	2013	3437475	0	28f767de-cc97-4d11-9c40-6888376971a6	f
99873ae7-6462-4c65-8cf3-a4f38af19ac0	f	f	2022-02-03 00:00:00	\N	Sousa Rocha	Anna	2013	3437468	0	28f767de-cc97-4d11-9c40-6888376971a6	f
367918a4-e7e4-4f94-a133-6db15b38b31a	f	f	2022-02-03 00:00:00	\N	Fröhlich	Nora	2012	3239629	0	28f767de-cc97-4d11-9c40-6888376971a6	f
2198fa86-7fe4-40f4-8b5b-a920dcb8c217	f	f	2022-02-03 00:00:00	\N	Teccuchi	Nina	2011	3277023	0	28f767de-cc97-4d11-9c40-6888376971a6	f
a45426c7-2948-43a2-a2da-70ff4049379b	f	f	2022-02-03 00:00:00	\N	De Boer	Yael	2010	3239625	0	28f767de-cc97-4d11-9c40-6888376971a6	f
dbe23d2f-d624-4f0b-b933-34e22ea1e310	f	f	2022-02-03 00:00:00	\N	Meier	Smilla	2009	3239634	0	28f767de-cc97-4d11-9c40-6888376971a6	f
b361dc77-52ca-4973-949c-d999599ddb2f	f	f	2022-02-03 00:00:00	\N	Fornallaz	Kim	2011	3239618	0	28f767de-cc97-4d11-9c40-6888376971a6	f
4685ddfe-e88b-4db9-8f96-857f4bd0b6fb	f	f	2022-02-03 00:00:00	\N	Meili	Arina	2009	3239620	0	28f767de-cc97-4d11-9c40-6888376971a6	f
d1bc8c4d-f85c-489a-9fda-49b21465a6e4	f	f	2022-02-03 00:00:00	\N	Stalder	Vera	2009	3152140	0	28f767de-cc97-4d11-9c40-6888376971a6	f
470363ea-6a64-4e15-9676-5c33123a976a	f	f	2022-02-03 00:00:00	\N	Largiader	Loretta	2013	3437482	0	28f767de-cc97-4d11-9c40-6888376971a6	f
f32af29b-5601-41fe-b788-71910b0c5bb4	f	f	2022-02-03 00:00:00	\N	Largiader	Andrina	2010	3147490	0	28f767de-cc97-4d11-9c40-6888376971a6	f
9448eb4e-3590-4268-8b6d-4d8e311a51e1	f	f	2022-02-03 00:00:00	\N	Künzle	Marc	2011	3129227	1	6cd2dec1-6466-4eb1-970b-81420914a9ed	f
c0a6871d-9a19-4f04-8178-d5e4be1a3d24	f	f	2022-02-03 00:00:00	\N	Blum	Justin	2012	3400585	1	6cd2dec1-6466-4eb1-970b-81420914a9ed	f
ec14beea-aa21-4427-9aee-924a94491c51	f	f	2022-02-03 00:00:00	\N	Wiebe	Ely	2012	\N	1	6cd2dec1-6466-4eb1-970b-81420914a9ed	f
ee697d2c-bbd5-492f-a279-af4dd54398cb	f	f	2022-02-03 00:00:00	\N	Lehmann	Manuel	2014	\N	1	6cd2dec1-6466-4eb1-970b-81420914a9ed	f
9d3e9766-8ea7-4377-9484-b413aa10aec1	f	f	2022-02-03 00:00:00	\N	Eigenmann	Livio	2014	\N	1	6cd2dec1-6466-4eb1-970b-81420914a9ed	f
bc60c2c8-4434-4bf0-a6e4-c473c13b6aef	f	f	2022-02-03 00:00:00	\N	Fäh	Leon	2014	\N	1	6cd2dec1-6466-4eb1-970b-81420914a9ed	f
07423944-a56c-44b8-a95b-7b41c69f710d	f	f	2022-02-03 00:00:00	\N	Gasparevic	Gabriel	2014	\N	1	6cd2dec1-6466-4eb1-970b-81420914a9ed	f
b558433b-d91b-44d0-a7da-83307567eb6e	f	f	2022-02-03 00:00:00	\N	Norrmann	Samuel	2014	\N	1	6cd2dec1-6466-4eb1-970b-81420914a9ed	f
680189b1-5546-4f12-a027-5917222ba245	f	f	2022-02-03 00:00:00	\N	Rüegg	Fiona	2007	967988	0	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
cff63d0c-ae9d-4adf-9b81-2205a472fec6	f	f	2022-02-03 00:00:00	\N	Ruf	Sarina	2005	3015332	0	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
e49767e5-e379-4956-87b9-3cba8e1768bd	f	f	2022-02-03 00:00:00	\N	Schönbächler	Mara	2009	3063520	0	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
3b41fb4d-6eda-45b5-b126-ed23beb89f21	f	f	2022-02-03 00:00:00	\N	Sommer	Aline	2007	971303	0	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
c4e392c8-ff1f-44a0-916c-3af1123252c1	f	f	2022-02-03 00:00:00	\N	Stutz	Luana	2011	3149059	0	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
69dd0f0e-ba86-4cf1-b643-0009188ce041	f	f	2022-02-03 00:00:00	\N	Schumacher 	Alessia	2009	3090176	0	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
03d7f838-d395-474e-a042-589ae11d91c7	f	f	2022-02-03 00:00:00	\N	Graf	Anna	2008	3273342	0	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
93d3d0cc-a259-4248-912f-958e7a9cb49e	f	f	2022-02-03 00:00:00	\N	Felder	Marvin	2015	3560577	1	08bfbb88-e782-4169-83fd-17b0fd03da18	f
08158e42-4f58-406e-9e19-02eccb6efeca	f	f	2022-02-04 00:00:00	\N	Bänziger	Amy	2009	3192998	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
566b0b7d-ab5d-45e3-920f-3c204101a66b	f	f	2022-02-04 00:00:00	\N	Blättler	Fiona	2012	3403514	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
8e251377-15e3-4564-a8a4-0d65b04fe444	f	f	2022-02-04 00:00:00	\N	Cica	Elina	2012	3193009	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
64331cf0-ef5a-43fe-a713-22f26e0929de	f	f	2022-02-04 00:00:00	\N	Bänz	Kim	2008	3077565	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
230d0b4c-756f-4610-8a3f-8eb5d18726cf	f	f	2022-02-04 00:00:00	\N	Baur	Delali	2014	3507606	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
b2eca0ec-f91c-46e7-bcdb-18dc3b5ab8af	f	f	2022-02-04 00:00:00	\N	Hegenbarth	Zoe	2008	3077566	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
283ec0cf-d5b6-4959-a06a-55cd3eadcd0b	f	f	2022-02-04 00:00:00	\N	Gibilisco	India	2011	3248455	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
31344218-8092-49e8-a0f5-6d238febbb8e	f	f	2022-02-04 00:00:00	\N	Kathriner	Keana	2013	2593405	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
8e56faeb-9069-41e6-b604-8f8ac2b7f900	f	f	2022-02-04 00:00:00	\N	Jenni	Linda	2011	3107626	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
1628ec16-f2c0-4ac7-b0c4-65f49ebacc5f	f	f	2022-02-04 00:00:00	\N	Baur	Chiara	2011	3227857	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
3a9b24c2-ddb9-4669-b2e1-83609a0a2fba	f	f	2022-02-02 00:00:00	\N	Reutemann 	Silvio	2006	912413	1	0a9d4719-903b-4f31-9e00-10fc47c954fd	f
d9a42722-adf8-4213-8f61-aed363a414d0	f	f	2022-01-30 00:00:00	\N	Wirth	Nino	2013	3481654	1	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
1022eb37-6cdf-4028-beff-91395e4d2105	f	f	2022-01-30 00:00:00	\N	Flacher	Neil	2008	3013399	1	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
d636693e-1b48-4d33-a1c1-e9646e08aef6	f	f	2022-02-08 00:00:00	\N	Osifo	Noëmi	2008	3083919	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
21e88cf6-63bd-4b12-af51-eb7c53f22ef4	f	f	2022-01-30 00:00:00	\N	Kistler	Rodin	2007	931914	1	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
1074b4b9-55ae-416a-9acf-848384f549c8	f	f	2022-02-02 00:00:00	\N	Manz	Janis	2009	3169632	1	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	f
03d40032-ff06-439a-ac1a-6eb2edac789b	f	f	2022-01-31 00:00:00	\N	Keller	Adrian	1994	861062	1	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
15893769-e87c-4759-a5ed-a8afb9a3f4c9	f	f	2022-02-05 00:00:00	\N	Walker	Sara	1995	664574	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
9ec91ef3-a237-4d52-89e2-880be63da77c	f	f	2022-02-02 00:00:00	\N	Hess	Mike	2014	3523802	1	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	f
677a7384-4469-4efa-ba81-bd76607f11ab	f	f	2022-02-05 00:00:00	\N	Metzger	Amelie	2012	\N	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
876f8554-387b-4622-bb05-a517d0721369	f	f	2022-02-05 00:00:00	\N	Freiermuth	Merrin	2014	\N	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
1961ba04-49f3-4e85-bbeb-bf035f77e4e5	f	f	2022-02-02 00:00:00	\N	Siegrist	Tiago	2014	3256189	1	a3895837-7bb9-48fa-afd0-b88c1edc7a95	f
87b31861-73b3-4b21-a924-1b33f8e3880c	f	f	2022-02-01 00:00:00	\N	Pontiggia	Daniele	2010	\N	1	2fc3365b-34d9-4054-b2d8-aa859c7455e7	f
6e2c58dc-2e14-4efe-bc44-22a7b279bc74	f	f	2022-02-02 00:00:00	\N	Meier	Roman	2015	3523945	1	a3895837-7bb9-48fa-afd0-b88c1edc7a95	f
989578c4-efe6-4482-9ef7-6da2c9f7c60e	f	f	2022-02-06 00:00:00	\N	\N	\N	0	\N	0	80200590-2e5d-4900-bc9b-cf4d6f5d7265	t
5c4140a0-02e2-4d2e-8a0d-529a1d4783ba	f	f	2022-02-02 00:00:00	\N	Angst	Maurin	2015	3523957	1	a3895837-7bb9-48fa-afd0-b88c1edc7a95	f
c8b6daa8-126a-442f-95fb-ced981f4a3da	f	f	2022-02-01 00:00:00	\N	Etzensperger	Collin	2015	\N	1	2fc3365b-34d9-4054-b2d8-aa859c7455e7	f
807c7656-f973-4abf-b23f-88521024be01	f	f	2022-02-01 00:00:00	\N	Bohner	Eric	2015	\N	1	2fc3365b-34d9-4054-b2d8-aa859c7455e7	f
e91e3f27-c159-44ca-87dc-b11d8a38e6c8	f	f	2022-02-01 00:00:00	\N	Oeker	Vincent	2014	\N	1	2fc3365b-34d9-4054-b2d8-aa859c7455e7	f
8489421a-ed87-4838-a5fa-5a23f2681b27	f	f	2022-02-01 00:00:00	\N	Schmid	Raphael	2015	\N	1	2fc3365b-34d9-4054-b2d8-aa859c7455e7	f
9c1abd67-ea14-4486-80a2-6fc2ec64cec1	f	f	2022-02-01 00:00:00	\N	Walder	Ursin	2007	\N	1	2fc3365b-34d9-4054-b2d8-aa859c7455e7	f
a488a0d0-1687-4968-835c-e1c30b0e7480	f	f	2022-02-01 00:00:00	\N	Hug	Florian	2006	\N	1	2fc3365b-34d9-4054-b2d8-aa859c7455e7	f
daf3d279-5168-4822-bbf9-0f0abdac8753	f	f	2022-02-02 00:00:00	\N	Wuggenig	Raphael	2014	3523968	1	a3895837-7bb9-48fa-afd0-b88c1edc7a95	f
b4aa1b44-e169-4d11-b3b9-6823652eacbe	f	f	2022-02-01 00:00:00	\N	Rauber	Stella Maria	2013	\N	0	c0a6c2eb-1278-42b5-8aba-0426f3550863	f
1cee29a6-77fc-4827-9fae-bd34d1544a5a	f	f	2022-02-02 00:00:00	\N	Guerra	Enea	2014	3435693	1	a3895837-7bb9-48fa-afd0-b88c1edc7a95	f
2a0c66e7-6071-43c0-b222-7b792f7f51ae	f	f	2022-02-01 00:00:00	\N	Egli	Henri	2014	\N	1	c0a6c2eb-1278-42b5-8aba-0426f3550863	f
0c22fed8-41f4-44fe-b6c1-d7a142f8c1e1	f	f	2022-02-01 00:00:00	\N	Kusnierczak	Mario	2013	3115358	1	c0a6c2eb-1278-42b5-8aba-0426f3550863	f
609ecf98-aa95-40b1-b4e6-e913c176d9ae	f	f	2022-02-02 00:00:00	\N	Lamprecht	Ben	2014	3523953	1	a3895837-7bb9-48fa-afd0-b88c1edc7a95	f
48dec3a8-3c36-4cbb-a4ea-07125399b0ae	f	f	2022-02-01 00:00:00	\N	Lebert	Cyril	2013	3175385	1	c0a6c2eb-1278-42b5-8aba-0426f3550863	f
575f5dff-ce37-4662-bf47-97966800d333	f	f	2022-02-01 00:00:00	\N	Wilhelm	Michael	2011	3176937	1	c0a6c2eb-1278-42b5-8aba-0426f3550863	f
73be97d9-25ba-46f8-8374-2403b7b69bc5	f	f	2022-02-02 00:00:00	\N	Strässle	Aril	2013	3343950	1	a3895837-7bb9-48fa-afd0-b88c1edc7a95	f
8efdb23d-23a4-4a67-94e9-73ad25bd85ac	f	f	2022-02-01 00:00:00	\N	Konetzka	Mischa	2009	3219936	1	c0a6c2eb-1278-42b5-8aba-0426f3550863	f
603a232c-f458-4a91-8c13-24a7baba45cc	f	f	2022-02-01 00:00:00	\N	Keller	Lior	2009	859874	1	c0a6c2eb-1278-42b5-8aba-0426f3550863	f
4974c554-ec5f-46e2-9745-4a07a2c242a2	f	f	2022-02-02 00:00:00	\N	Lamprecht	Leo	2013	3343945	1	a3895837-7bb9-48fa-afd0-b88c1edc7a95	f
0a6d2003-0cb1-44dc-93c8-dc4ecc18bbe2	f	f	2022-02-01 00:00:00	\N	Studer	Pascal	2004	667424	1	c0a6c2eb-1278-42b5-8aba-0426f3550863	f
b04f2ff1-014d-4a9e-9428-bccc6dd68d73	f	f	2022-02-01 00:00:00	\N	Stalder	Alex	1998	667419	1	c0a6c2eb-1278-42b5-8aba-0426f3550863	f
4be21568-ba9c-4307-87b4-a00685db7771	f	f	2022-02-02 00:00:00	\N	Schmidt	Eli	2012	3471346	1	a3895837-7bb9-48fa-afd0-b88c1edc7a95	f
94fa4cd0-1003-47f7-810b-8751e4759d2b	f	f	2022-02-01 00:00:00	\N	Kunz	Joel	2002	861778	1	c0a6c2eb-1278-42b5-8aba-0426f3550863	f
acfc2517-b14d-44d3-9ed8-0de7b5575d65	f	f	2022-02-01 00:00:00	\N	Manser	Michael	1997	667397	1	c0a6c2eb-1278-42b5-8aba-0426f3550863	f
9957b8ed-a854-4035-9515-75d9d373f23a	f	f	2022-02-02 00:00:00	\N	Bachmann	Gian	2012	2415995	1	fe6fd149-2231-415b-95c0-c4194aaf56a1	f
16031877-4a3e-4136-a468-2f14598ed967	f	f	2022-02-01 00:00:00	\N	Dal	Timur	2014	\N	1	c0a6c2eb-1278-42b5-8aba-0426f3550863	f
921d472d-3b59-4be2-a8d6-7fc371ce6cae	f	f	2022-02-02 00:00:00	\N	Nüssli	Tim	2003	878895	1	fe6fd149-2231-415b-95c0-c4194aaf56a1	f
e7472b5b-871c-4b06-89ad-531e521c3622	f	f	2022-02-02 00:00:00	\N	Furrer	Joel	1997	878844	1	fe6fd149-2231-415b-95c0-c4194aaf56a1	f
4bc55af8-760c-4c4d-b57e-586998a18f87	f	f	2022-02-01 00:00:00	\N	Wiesmann	Moritz	2009	3041445	1	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	f
8365d382-9fa0-46a9-b49c-230c51ce0917	f	f	2022-02-01 00:00:00	\N	Morach	Jeremias	2009	986731	1	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	f
562b5c3d-0cb9-412d-812f-67d3fd6ce49a	f	f	2022-02-01 00:00:00	\N	Angst	Dario	2011	2063094	1	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	f
5419169e-c782-4ef0-9938-38f4b939f51b	f	f	2022-02-01 00:00:00	\N	Knöpfel	Leon	2010	3100583	1	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	f
4efc7709-ad79-4c9c-b840-2dff2d35e317	f	f	2022-02-01 00:00:00	\N	Ott	Thierry	2010	2058083	1	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	f
c4e5ba66-68d1-46e8-b121-d7d058a32e8a	f	f	2022-02-01 00:00:00	\N	Marquordt	Simon	2009	3115266	1	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	f
acf729cf-2364-4caf-880f-b2289151e5c1	f	f	2022-02-01 00:00:00	\N	Trümpy	Leon	2007	3014706	1	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	f
79f13a1b-bc55-43fd-a774-66c93f4e3430	f	f	2022-02-02 00:00:00	\N	Spillmann	Tamara	2003	834719	0	cfb35447-962b-479e-af0e-2f95dfbc9fde	f
4321f498-2c55-49db-bcb3-26437cb50b5b	f	f	2022-02-01 00:00:00	\N	Berni	Leandro	2008	985516	1	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	f
7260eb0d-53a0-4378-9a89-d51dd1722d3a	f	f	2022-02-01 00:00:00	\N	Vögeli	Colin	2008	985519	1	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	f
86b6d80d-f12e-48e1-b608-32ee22b14f09	f	f	2022-02-02 00:00:00	\N	Fiorillo	Chiara	2008	3220776	0	cfb35447-962b-479e-af0e-2f95dfbc9fde	f
10d5ee9f-5fac-465f-a090-81add0973145	f	f	2022-02-01 00:00:00	\N	Regamey	Marius	2006	724303	1	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	f
c99ec0b3-4bd7-4dd0-98a4-1361f10a4a4e	f	f	2022-02-02 00:00:00	\N	Grosjean	Lynn	2006	883840	0	cfb35447-962b-479e-af0e-2f95dfbc9fde	f
504b47bc-3a0b-4dfe-bee1-9d559e840ab9	f	f	2022-02-01 00:00:00	\N	Sellan	Lean	2006	859350	1	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	f
fbf3b211-2499-4179-ad81-b0334b0dd8b1	f	f	2022-02-02 00:00:00	\N	Spillmann	Myriam	2002	834718	0	cfb35447-962b-479e-af0e-2f95dfbc9fde	f
5f0ee901-fd26-4dea-ae33-ff5d416b614e	f	f	2022-02-01 00:00:00	\N	Streit	Corsin	2006	3059386	1	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	f
40a91614-683a-4d6f-8926-d9f236d1f750	f	f	2022-02-01 00:00:00	\N	Hess	Yannick	2011	911953	1	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	f
2f8928e8-2848-4023-ba26-3109fa771cbe	f	f	2022-02-01 00:00:00	\N	Arnet	Livio	2004	709987	1	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	f
660f9915-13f5-4dc9-b2dc-eaff217555d5	f	f	2022-02-01 00:00:00	\N	Harder	Tim	2002	690877	1	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	f
c7370c27-c8c6-4685-88ff-2c67ae4ad4c0	f	f	2022-02-02 00:00:00	\N	Nicola	Graf	2015	2655998	1	0a9d4719-903b-4f31-9e00-10fc47c954fd	f
c81d2841-7dfb-4fe3-b524-6dd69dfd65f0	f	f	2022-02-02 00:00:00	\N	Banyard	Erwan	2010	3100188	1	0a9d4719-903b-4f31-9e00-10fc47c954fd	f
e0f367b6-7649-4d78-a28f-d8f213727886	f	f	2022-02-03 00:00:00	\N	Ecker	Jolinne	2012	3437464	0	28f767de-cc97-4d11-9c40-6888376971a6	f
5f0adebc-2e93-446e-86da-317b08e55b67	f	f	2022-02-02 00:00:00	\N	Reutemann	Laurin	2004	636015	1	0a9d4719-903b-4f31-9e00-10fc47c954fd	f
803d890a-0230-43a8-8399-c1d342f9dda8	f	f	2022-02-03 00:00:00	\N	Serafini	Valentina	2012	3332642	0	28f767de-cc97-4d11-9c40-6888376971a6	f
cdd1d088-de7e-4be9-9e6f-a4e94e93ad59	f	f	2022-02-04 00:00:00	\N	Demuth	Ria	2012	3227870	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
b00e68b1-4594-46c9-a1e4-c80822992e23	f	f	2022-02-04 00:00:00	\N	Aerne	Malin	2008	978764	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
96ed28a8-8a79-46bf-9e57-b10105c181bd	f	f	2022-02-08 00:00:00	\N	Koller	Vanessa	2000	629322	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
f1a8ee6f-9677-428a-ad4b-e9a44d85e364	f	f	2022-02-06 00:00:00	\N	Narancic	Nikolina	2005	921577	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
6a132251-4656-4114-84f9-2cac374e37ae	f	f	2022-02-05 00:00:00	\N	Ammann	Shirin	2012	3264260	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
9e6700d6-af25-4a9a-8368-4eb12c8cae24	f	f	2022-02-08 00:00:00	\N	Jeremic	Anja	2008	3103929	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
9e35a675-4977-44e9-8fbf-c79e16dc7044	f	f	2022-02-05 00:00:00	\N	Bader	Elin	2012	3436730	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
003866ff-9991-4cc0-85ee-6c8d7186f0b9	f	f	2022-02-06 00:00:00	\N	Vogler	Kerstin	2008	3037457	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
49fdf5db-a765-4cbb-b38e-aab59154cd48	f	f	2022-02-05 00:00:00	\N	Bosshard	Elin	2011	3144255	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
aaf4f808-c320-4b2b-b000-2cc026e3556b	f	f	2022-02-08 00:00:00	\N	Chiarolini	Sarah	1999	629318	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
fa8c47e8-129f-4986-a347-8f08a5fbc16c	f	f	2022-02-08 00:00:00	\N	Vogelsanger	Jarina	2012	3350921	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
2c557d64-a861-44ce-810b-93df7f255b79	f	f	2022-02-05 00:00:00	\N	Egli	Ramona	2008	3102120	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
e339b5c5-44f8-4c26-b6f7-ea44ae3a1ee8	f	f	2022-02-05 00:00:00	\N	Egli	Melanie	2008	3102119	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
0922884e-c036-4ba8-8d62-424ae6cfef2b	f	f	2022-02-07 00:00:00	\N	Cuencas	Flavia	2009	3064892	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
776838e9-5c0f-43a4-bc64-dd60128fde6d	f	f	2022-02-05 00:00:00	\N	Richner	Joana	2008	3123748	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
008a526e-49f5-4c38-b320-69f083b04685	f	f	2022-02-08 00:00:00	\N	Ringger	Larina	2012	3437905	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
cd09f7e7-de64-45a4-a45a-537c0409e9b3	f	f	2022-02-05 00:00:00	\N	Weiss	Noemi	2010	3144240	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
ba2eb5c7-8ee3-4207-b5f6-237568af5b2f	f	f	2022-02-05 00:00:00	\N	Bachmann	Kiera	2008	3036797	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
9e8edb06-d2c9-442b-b90c-d97fe2f6f9d4	f	f	2022-02-08 00:00:00	\N	Kuhn	Larina	2011	3243456	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
ef926970-8ba0-459f-a3cc-c71f43ab69d5	f	f	2022-02-05 00:00:00	\N	Bleuler	Fiona	2007	961471	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
97d15dac-c844-49fd-8ec6-2ef6dbcc109a	f	f	2022-02-08 00:00:00	\N	Hartmann	Elodie	2013	3383253	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
d830cb5e-8784-4fd6-aad6-ee6e62013555	f	f	2022-02-05 00:00:00	\N	Pfister	Denise	2006	961475	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
f637b27e-8172-4652-88f0-351fac4b0c3c	f	f	2022-02-08 00:00:00	\N	Scherer	Lena	2010	3388083	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
6cbf98c0-dd62-44d7-9bc2-afb114b868c3	f	f	2022-02-05 00:00:00	\N	Hofmann	Gioia	2003	708320	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
6262902e-08a7-4f47-8475-bdf77949da48	f	f	2022-02-08 00:00:00	\N	Gossmann	Freia	2010	3141914	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
f16b5f6f-588e-4698-a5f1-ddc889a32627	f	f	2022-02-05 00:00:00	\N	Vollenweider	Emma	2014	\N	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
935e39f4-ba58-42b9-9e43-1fb77a5d37b0	f	f	2022-02-08 00:00:00	\N	Werder	Anouk	2011	3141915	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
644fcb3e-40f4-409a-ba6f-5e0e52235c09	f	f	2022-02-08 00:00:00	\N	Pelenk	Noemi	2008	3058657	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
cba507f2-49b2-49f4-981d-b753ee908bdd	f	f	2022-02-08 00:00:00	\N	Wyss	Lana	2010	3162328	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
38eea91a-46c2-4570-823c-63eb1c1c8b9e	f	f	2022-02-08 00:00:00	\N	Vollenweider	Noelia	2006	920707	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
1482f0ae-d2ed-448b-9bdc-f44a332e9e59	f	f	2022-02-08 00:00:00	\N	Prechtl	Sofie	2009	3062638	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
805a5d59-f07d-4cb8-8b0b-b61c8d887f1f	f	f	2022-02-08 00:00:00	\N	Romeo	Aurora	2007	3102497	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
147fd022-8747-43a5-8ab2-4f574c486f9e	f	f	2022-02-12 00:00:00	\N	Rizzolli	Amy	2012	3366468	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
1f22b066-d2b4-4941-abef-5c56348cdb18	f	f	2022-02-12 00:00:00	\N	Chiasserini	Arwen	2011	3366460	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
5735461b-bd9a-41ce-866f-a9dbde723840	f	f	2022-02-10 00:00:00	\N	Ngakpa	Khando	2011	3384958	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
5ae93910-ae7d-480c-b9da-4f43453229a9	f	f	2022-02-10 00:00:00	\N	Leukart	Leni	2011	3386273	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
817de2dd-5eb4-4a38-9802-4425f236ab49	f	f	2022-02-10 00:00:00	\N	Urfer	Anouk	2011	3386296	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
2143ebe3-012f-46a1-8520-3bdbe40856ef	f	f	2022-02-10 00:00:00	\N	Cositore	Lina	2014	\N	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
7a701496-f709-4924-ab6c-e45b339fac35	f	f	2022-02-10 00:00:00	\N	Ditz	Lilien	2011	3386294	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
7393a238-61c8-49c4-9f7c-d67fe1f6c93f	f	f	2022-02-12 00:00:00	\N	Kündig	Dilara	2011	3266367	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
2689bbb2-b8e0-4c7a-8e67-bab35df6b0e5	f	f	2022-02-12 00:00:00	\N	Zingg	Salome	2013	3333528	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
a33b819f-72c9-48ac-a5d6-ef5cfc24dd66	f	f	2022-02-12 00:00:00	\N	Romann	Julia	2012	3214591	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
21c9ca00-b1fb-4878-b9e6-9c938c96a0ba	f	f	2022-02-05 00:00:00	\N	Frei	Alessia	2015	3513601	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
b01af131-9bf7-4431-b135-dde1c25cdb01	f	f	2022-02-05 00:00:00	\N	Colat	Anisha	2007	3006366	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
3dd34170-b1ee-4c11-b467-667f3b77caad	f	f	2022-02-05 00:00:00	\N	Merrel	Etta	2013	3502257	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
61fc2523-3cbf-481e-af00-f7044779db15	f	f	2022-02-05 00:00:00	\N	Zimmermann	Mia	2013	3367555	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
5899f15e-118f-4407-82ef-90bfd257480a	f	f	2022-02-05 00:00:00	\N	Sägesser	Alena	2013	3489580	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
d917c4ad-65d6-4417-8377-00c1a641d3eb	f	f	2022-02-05 00:00:00	\N	Rollo	Lian	2016	3560579	1	08bfbb88-e782-4169-83fd-17b0fd03da18	f
cb66704e-8124-45c8-b19a-11699c0e8d86	f	f	2022-02-05 00:00:00	\N	El Hahi	Amal	2013	3560609	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
f6657870-35b3-4109-ba7e-3c8ad7d23d64	f	f	2022-02-05 00:00:00	\N	Karavolas	Kalliopi	2014	3560575	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
173017eb-2b57-4554-81aa-abd86f0a6317	f	f	2022-02-05 00:00:00	\N	Perez	Leonie	2012	3560591	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
4354bf27-d4e0-4d35-945c-8a7e616676a9	f	f	2022-02-05 00:00:00	\N	Hess	Sara	2013	3463247	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
0dc65f91-a46c-4b79-9dcb-7f45a00806ec	f	f	2022-02-05 00:00:00	\N	Escolano	Julia	2014	3363123	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
6f253d67-6470-4a33-9834-887f02a596e0	f	f	2022-02-05 00:00:00	\N	Dünner	Melina	2012	3364955	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
a0ca5465-ad71-4cbb-adb0-35b4c253d3e6	f	f	2022-02-05 00:00:00	\N	Sangameswaran	Maya	2014	3560581	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
65fbf2e5-e263-4de4-8e9d-e729cec70a46	f	f	2022-02-05 00:00:00	\N	Fiammengo	Sofia	2012	3363125	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
4c1baf81-3492-4c80-9fa1-25e54c6d3932	f	f	2022-02-05 00:00:00	\N	Müller	Svea	2013	3294952	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
2a38003d-fb1a-4b62-8710-e2e31705fa78	f	f	2022-02-05 00:00:00	\N	Schmid	Anina	2012	3350178	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
0e25ca57-1e79-4368-918e-9bca6e741797	f	f	2022-02-05 00:00:00	\N	Fischer	Mira	2011	3560601	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
812b99c6-1d51-457c-964a-608f0abd4b36	f	f	2022-02-05 00:00:00	\N	Künzi	Emilie	2012	3294948	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
3e6c9f16-8211-4f5f-9a90-c39e7d748c3a	f	f	2022-02-05 00:00:00	\N	Bergamin	Vanessa	2008	3133152	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
337bdf27-d828-4f86-a780-4156bc47aa72	f	f	2022-02-05 00:00:00	\N	Bosshard	Leisha	2010	3196685	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
d8865f4d-5673-4d98-a1c6-fd9506614a4c	f	f	2022-02-05 00:00:00	\N	\N	\N	0	\N	0	08bfbb88-e782-4169-83fd-17b0fd03da18	t
1d053095-6b7f-464b-9c4f-b1d107b82ab7	f	f	2022-02-05 00:00:00	\N	Krebser	Mona	2010	3103487	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
75f3f20f-08b5-4445-b4fe-d48317339124	f	f	2022-02-05 00:00:00	\N	Brogle	Lina	2005	856141	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
f6174f2e-3183-4f5f-a667-bca15362f31b	f	f	2022-02-05 00:00:00	\N	Lienhard	Carina	2004	843457	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
4a4976cf-47a4-41be-8928-0a6605663061	f	f	2022-02-05 00:00:00	\N	Scherer	Aline	2003	3029414	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
b553f3be-1141-4e96-9e47-8c22000f2737	f	f	2022-02-08 00:00:00	\N	Correia	Leonor	2010	3169907	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
4dc9d6cc-58b4-45f7-b0ce-f3436dc8ed6f	f	f	2022-02-04 00:00:00	\N	Knapp	Julia	2009	3036941	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
b89bedf7-addb-42dd-b397-12162982a6b1	f	f	2022-02-05 00:00:00	\N	Frempong	Alisha	2013	\N	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
ee70a146-7693-4419-a609-d9d55232168d	f	f	2022-02-06 00:00:00	\N	Käser	Jana	2007	968325	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
18a1debe-75d0-4866-9e07-be25264169c7	f	f	2022-02-05 00:00:00	\N	Gisler	Xenia	2009	3264266	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
36321c27-96ca-40fe-8d4a-52b66ab41ef1	f	f	2022-02-08 00:00:00	\N	Freiermuth	Arwen	2012	3383248	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
622f243a-2ece-40bf-b68f-8e524b32511c	f	f	2022-02-06 00:00:00	\N	Wüthrich	Leonie	2006	968363	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
11683a79-a522-4653-8f58-6748d2d13477	f	f	2022-02-08 00:00:00	\N	Pelenk	Aaliyah	2009	3102494	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
f9d8955c-4b1b-4130-935a-521d0cc7d06b	f	f	2022-02-06 00:00:00	\N	Burth	Soleya	2009	3067544	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
f8eb8924-55af-4f52-867e-e6ffbad2752c	f	f	2022-02-08 00:00:00	\N	Eisenegger	Jana	2005	855615	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
ccfcf749-8860-48e3-87a6-277461c9c4c7	f	f	2022-02-06 00:00:00	\N	Berger	Joy	2010	3104732	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
35c52cd3-41b5-4fa0-bfdb-4e88e111b8c2	f	f	2022-02-05 00:00:00	\N	Herrmann	Luisa	2014	\N	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
1f69f963-e030-42b3-97ea-4cadfb599c70	f	f	2022-02-08 00:00:00	\N	Widmer	Alani	2007	966634	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
5958587d-7ab9-4eef-aa84-20d46bd309dd	f	f	2022-02-05 00:00:00	\N	Haab	Timea	2012	\N	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
f4f81e47-d7ad-4073-8298-2f583e84a78c	f	f	2022-02-05 00:00:00	\N	Meier	Luana	2014	\N	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
61023019-4b6b-4953-a011-aa48d807642c	f	f	2022-02-06 00:00:00	\N	Werlen	Livia	2009	3103181	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
3851d97c-9b65-4c71-aa16-268ff751199f	f	f	2022-02-06 00:00:00	\N	Kammerlander	Dana	2008	3067531	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
ad9e373b-c563-4dc3-8b50-0094beadba29	f	f	2022-02-06 00:00:00	\N	Schülé	Mila	2010	3160472	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
a2b1e085-3c64-4662-a037-25ea43ed9977	f	f	2022-02-10 00:00:00	\N	Kohler	Liana	2013	3157244	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
0b511065-ff49-4830-a027-347847dcfdc2	f	f	2022-02-10 00:00:00	\N	Rollo	Mia	2016	\N	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
40f7307a-5cd3-411d-84b5-1754dacedaab	f	f	2022-02-10 00:00:00	\N	Brühwiler	Viola	2016	\N	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
13e3e43d-cda8-4ed5-b15b-0999e959778f	f	f	2022-02-10 00:00:00	\N	German	Sina	2010	3281834	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
a22b1442-2149-4a96-a6c1-2bf970f31f20	f	f	2022-02-10 00:00:00	\N	Comminot	Leandra	2015	\N	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
4896af5f-29f2-4b18-bbf3-f48f07b2412a	f	f	2022-02-12 00:00:00	\N	Jörger	Mila	2014	3479120	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
985ca012-7c32-467b-8337-c21c10214c1d	f	f	2022-02-10 00:00:00	\N	Pittet	Amélie	2013	\N	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
f055d55b-d15c-4924-8b79-e8e5a0f0e548	f	f	2022-02-10 00:00:00	\N	Monhart	Mirella	2014	\N	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
5b07a88a-e6c5-4fbb-a79f-c28768afbcc4	f	f	2022-02-10 00:00:00	\N	Azeri	Edita	2013	\N	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
8e24bcac-1f7f-446b-a4db-726a7071f0e0	f	f	2022-02-12 00:00:00	\N	Rango	Sophia	2013	\N	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
5f102c07-df52-4f46-81fe-e19370cb2654	f	f	2022-02-10 00:00:00	\N	Günter	Nele	2015	\N	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
4b66944f-2591-48b8-9d51-c8e0084371ab	f	f	2022-02-05 00:00:00	\N	Ganz	Yara	2007	943573	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
cdc6ed58-24c7-40b7-beb7-ae3a236508be	f	f	2022-02-12 00:00:00	\N	Albayrak	Banu	2013	3385194	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
c9ac77a1-9e78-43a1-8b51-3a6853bff825	f	f	2022-02-12 00:00:00	\N	Zürrer	Jolina	2011	3105740	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
44a02a54-04de-4951-9600-124e30eb6cf3	f	f	2022-02-12 00:00:00	\N	Senn	Tabea	2010	987130	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
7a541e06-c5bd-4e26-8d2a-7e8ee3c46f21	f	f	2022-02-05 00:00:00	\N	Ott	Kim	2014	3421365	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
b266fb3d-df37-48e9-841d-10768a14491d	f	f	2022-02-05 00:00:00	\N	Schweizer	Annik	2015	3522447	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
9e4e56f4-3b2b-4e6b-9f72-f15b80c7a219	f	f	2022-02-05 00:00:00	\N	Spühler	Amira	2004	851562	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
4fb1a6f0-f462-4ef7-b9fa-fc51472fcf21	f	f	2022-02-05 00:00:00	\N	Zürcher	Sophia	2007	971399	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
3e44bd05-ade2-46c7-848c-136cbd862e4b	f	f	2022-02-05 00:00:00	\N	Alibrandi	Elisa	2015	3560573	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
54637b95-7fc2-4799-a061-3becbbe67190	f	f	2022-02-05 00:00:00	\N	Koyutürk	Kayra	2016	3560857	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
f01acabd-5a6e-4976-9ebb-f07fc4652269	f	f	2022-02-05 00:00:00	\N	Dal Din	Larissa	2009	3139480	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
63f7f5c6-1f79-414b-84ad-e36a75fa520e	f	f	2022-02-05 00:00:00	\N	Blum	Aline	2011	3196705	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
09e80d56-216e-4361-81e2-e81616965878	f	f	2022-02-05 00:00:00	\N	Spichtig	Isabelle	2011	3363136	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
29587c56-34af-47e2-a560-5075e76ce6f1	f	f	2022-02-05 00:00:00	\N	Rollo	Gioia	2012	3363132	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
77a19008-3bdd-4134-871f-15c1f754ee4a	f	f	2022-02-05 00:00:00	\N	Gasser	Selina	2010	3294936	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
1855507d-23e8-4043-836d-f63c1700a8bc	f	f	2022-02-05 00:00:00	\N	Lippuner	Emma	2011	3196676	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
95b6e10f-eaed-4be5-969e-0debbe709bb4	f	f	2022-02-05 00:00:00	\N	Escolano	Sara	2008	3463266	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
851be911-9a10-4c69-b1d8-d3d5beb49fb6	f	f	2022-02-05 00:00:00	\N	Sprecher	Zoe	2010	3312490	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
b8c6ede6-ce99-4fef-a4f6-39569316f00c	f	f	2022-02-05 00:00:00	\N	Ulli	Céline	2010	3196695	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
2dbe9fd7-6381-48c9-be13-ecca9eba1781	f	f	2022-02-05 00:00:00	\N	Senesi	Enéh	2010	3196681	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
b0b8cacb-804f-425a-b423-fe707649117c	f	f	2022-02-05 00:00:00	\N	Renk	Angela	2002	675564	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
9ca911c4-512f-4989-a1f5-3770138cca9e	f	f	2022-02-05 00:00:00	\N	Seiler	Noemi	2004	675568	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
01112ea1-b842-4253-9308-42ee29921bdf	f	f	2022-02-05 00:00:00	\N	Lienert	Yara	2008	684108	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
b79ebef6-165c-4f86-979e-43fc5ed30b2f	f	f	2022-02-05 00:00:00	\N	Brogle	Clivia	2008	684108	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
ff96c360-1ec7-4f45-8d7b-8735849eea4a	f	f	2022-02-05 00:00:00	\N	Wüst	Sara	2007	909598	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
3f383324-1dc0-4815-a8fb-4347c9678916	f	f	2022-02-06 00:00:00	\N	Badal	Nuria	2006	715349	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
003e4dc3-ff55-400a-92aa-3dbe4c597946	f	f	2022-02-06 00:00:00	\N	Öncü	Derya	1989	488510	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
86ebbdce-89ed-48da-ac59-e3d2ee05d1a5	f	f	2022-02-06 00:00:00	\N	Mattli	Nicole	1986	386962	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
d5985104-172a-4289-9e53-9ec951bbb635	f	f	2022-02-06 00:00:00	\N	Disch	Elena	1997	646778	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
dad4798e-62b0-48eb-9a9a-1fc20661f511	f	f	2022-02-06 00:00:00	\N	Stegmayer	Joleen	2003	964334	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
41882def-df1b-4ef9-b750-f748d42a08bf	f	f	2022-02-06 00:00:00	\N	Landert	Joleen	2005	896602	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
b7f118be-23cb-4a4e-97c3-68bbdfa6d993	f	f	2022-02-06 00:00:00	\N	Beti	Natalie	2003	3107722	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
8d3d32c8-9c40-4838-9743-306435725143	f	f	2022-02-06 00:00:00	\N	Füllemann	Mary Lynn	2006	969250	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
404b262a-57ad-404d-bd38-26979ce5715d	f	f	2022-02-06 00:00:00	\N	Stadelmann	Nina	2008	3009080	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
7e7fd560-3ebc-4765-be45-24fc0f4f35d3	f	f	2022-02-06 00:00:00	\N	Gentilini	Chiara	2007	3003344	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
d7db5199-4be7-40d0-9428-a41df05d3f4d	f	f	2022-02-06 00:00:00	\N	Lutz	Tamara	2007	3010243	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
2f2eadc6-58fb-4495-bedf-681816ad717e	f	f	2022-02-06 00:00:00	\N	Ernst	Lucy	2009	3056114	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
98c0ead9-1a8a-46f9-9f0d-95cebeb3fa4d	f	f	2022-02-06 00:00:00	\N	Hintermann	Aylin	2008	3053710	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
9136f058-3ebb-4285-bb85-a5a8ddd4b79e	f	f	2022-02-06 00:00:00	\N	Schelldorfer	Laura	2009	3056113	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
aca3a9c8-0e5e-46cf-a109-cceb87cea869	f	f	2022-02-06 00:00:00	\N	Burth	Marleika	2009	3067543	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
8b392bd1-f7a8-44c5-8d4d-9b1dff443803	f	f	2022-02-04 00:00:00	\N	Indelicato	Silvia	2012	3248458	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
7465fedb-8e4b-4b22-a109-97a70591da87	f	f	2022-02-04 00:00:00	\N	Lüthi	Ann-Lea	2011	3107628	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
c66798f3-c365-42bc-a1a0-4312e976e6d9	f	f	2022-02-04 00:00:00	\N	Preiss	Carmen	2010	3273348	0	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
b7458a95-2be2-4c77-87bc-865ecf84c997	f	f	2022-02-04 00:00:00	\N	Studerus	Linda	2010	3201761	0	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
9ed9cc1e-c97a-4c5a-9d32-7e2c6382673c	f	f	2022-02-04 00:00:00	\N	Castelberg	Cyntia	2010	3273353	0	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
a4d8d200-1aee-4467-9228-bcc9c97a4df1	f	f	2022-02-04 00:00:00	\N	Strauss	Mila	2011	3371128	0	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
fe64f4db-9f3e-4cb5-b3d6-9030904820e5	f	f	2022-02-04 00:00:00	\N	Meili 	Rhiana	2006	926597	0	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
40bcbc4a-f1a8-42be-801d-551fba13bd79	f	f	2022-02-04 00:00:00	\N	Kroh	Svenja	2012	3544743	0	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
c65ee55d-bc0a-4cbe-ac36-55294a50aeaa	f	f	2022-02-04 00:00:00	\N	Signer	Anika	2012	3304306	0	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
f3c28b31-3023-4fd7-901f-9af7550e8820	f	f	2022-02-04 00:00:00	\N	Zeindler	Bigna	2013	3405696	0	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
d535df31-ab21-42d7-99f5-1403b1242e27	f	f	2022-02-04 00:00:00	\N	Schoch	Jann	2005	933996	1	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
0022b704-7799-4a90-a02b-dca9af107858	f	f	2022-02-04 00:00:00	\N	Schoch	Rees	2006	938605	1	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
8678e111-0e0a-48cb-b1ca-e9777a3965fb	f	f	2022-02-04 00:00:00	\N	Ruf	Mischa	2006	966406	1	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
9fd3b6a1-8f3f-4f69-bfe5-894e78919ac3	f	f	2022-02-04 00:00:00	\N	Strehler	Elias	2007	3015334	1	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
2625ed66-833e-44ab-9b42-22400bc11d62	f	f	2022-02-04 00:00:00	\N	Schönbächler	Livio	2012	3273357	1	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
9dba2037-7e9a-489b-9870-f473a9171b64	f	f	2022-02-04 00:00:00	\N	Beretta	Dario	2011	3273360	1	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
39ad1b91-c8aa-44e1-8a1e-817cba27ab9e	f	f	2022-02-04 00:00:00	\N	Neyer	Joel	2010	3371133	1	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
55423e0f-af86-44cd-a74b-8c0555019f19	f	f	2022-02-04 00:00:00	\N	Schönmann	Marc	2011	3168718	1	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
4c3c6ab3-6e9a-40b8-9c21-cb3c6273a7c7	f	f	2022-02-04 00:00:00	\N	Müller	Eline	2012	3248476	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
27b32639-a0d2-4e20-9deb-723622ddeb23	f	f	2022-02-04 00:00:00	\N	Schmid	Olivia	2010	3107631	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
aa15546c-b684-43dc-872f-bdab3ac0c745	f	f	2022-02-04 00:00:00	\N	Zollinger	Fiona	2012	3248490	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
fad7f65a-0ddd-44bc-b380-872b8c09dcf4	f	f	2022-02-04 00:00:00	\N	Schwarz	Elin	2015	\N	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
ebf57613-57f2-433c-9387-058a8e774c47	f	f	2022-02-04 00:00:00	\N	Weber	Lou	2010	3107632	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
9f5e2981-5b89-4a19-af06-8f478e22e9aa	f	f	2022-02-04 00:00:00	\N	Wüthrich	Lucy	2012	3291568	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
af55583a-525b-47d7-9eac-b598612fc001	f	f	2022-02-04 00:00:00	\N	Beutler	Selina	2013	3410252	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
cc9fa917-676a-4667-a998-ed57c6d804e9	f	f	2022-02-04 00:00:00	\N	Kuhn 	Alina	2013	3310460	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
f30069d3-1749-46ad-bf8a-bf30a4b56a63	f	f	2022-02-04 00:00:00	\N	Muehl	Helena	2014	3242264	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
62249475-c7de-45f2-851b-bd039f872653	f	f	2022-02-04 00:00:00	\N	Neff	Gina	2014	3427592	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
4d51e33e-fb0d-4427-af99-44efe1c8ed07	f	f	2022-02-04 00:00:00	\N	Sbalchiero	Alicia	2013	3260182	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
b8c000b2-1de0-40ea-ae29-be219b76c023	f	f	2022-02-04 00:00:00	\N	Toschini	Elina	2013	3260187	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
58246350-5bb9-4f69-afab-bf9bd5aa0820	f	f	2022-02-04 00:00:00	\N	Wennemer	Mina	2013	3345289	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
9d1d9eda-e0df-4d05-9c54-33fa148ac71f	f	f	2022-02-04 00:00:00	\N	Kägi	Sarah	2011	3103989	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
7a7f15a5-dde0-401c-8d13-a5ff9ff2432f	f	f	2022-02-04 00:00:00	\N	Leuthold	Noelia	2011	3160777	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
677c4446-93c2-4e24-879a-2797ed431307	f	f	2022-02-04 00:00:00	\N	Meier	Moana	2012	3151191	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
4613e34b-f33f-4d6e-b32b-93d2e1c0a01a	f	f	2022-02-04 00:00:00	\N	Nüssli	Leana	2011	3260176	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
452a5ebd-f90c-49fc-884f-7e3b6de3d5f4	f	f	2022-02-04 00:00:00	\N	Nüssli	Lia	2013	3321834	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
89ad5b6d-d920-48d4-be5b-1a48637c2023	f	f	2022-02-04 00:00:00	\N	van Galen	Michelle	2011	3067047	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
8753f33f-3b8e-455b-af53-bec11985bc3a	f	f	2022-02-04 00:00:00	\N	Bangerter	Mara	2012	3103981	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
7c6e9af7-6938-427b-b01a-d8ff0a92bd80	f	f	2022-02-04 00:00:00	\N	Berner	Melina	2010	3150168	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
aca03f38-2932-4b84-989d-a9cf67c254e7	f	f	2022-02-04 00:00:00	\N	Dluha	Vanessa	2010	3103984	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
9762b60e-318a-4312-9be1-f787e41a824f	f	f	2022-02-04 00:00:00	\N	Gambs	Jarina	2010	3067029	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
0288ba94-fcdb-48c7-a61d-e81e09de45eb	f	f	2022-02-04 00:00:00	\N	Studer	Ladina	2010	3091498	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
29b6cb70-9ae4-4b65-bc9a-17645a2a3647	f	f	2022-02-04 00:00:00	\N	Eberhard	Caitlin	2009	3067028	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
c4827954-a566-4997-9605-74693e2af71e	f	f	2022-02-04 00:00:00	\N	Engler	Nina	2007	3260726	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
4f5e1ac1-23c5-4e6d-baa3-94a839c24540	f	f	2022-02-04 00:00:00	\N	Mauch	Nele	2009	3067038	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
67852033-a261-466e-8c78-b5749ce92f4c	f	f	2022-02-04 00:00:00	\N	Schnyder	Laura	2007	3022616	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
bc9fa9fd-46ca-4e79-ab3f-9e81a670432f	f	f	2022-02-04 00:00:00	\N	Eberhard	Isabel	2010	3095689	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
4eeb51d4-d821-40c5-a5c9-fa198a977abd	f	f	2022-02-04 00:00:00	\N	Ried	Sarah	2007	898943	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
9fc388f4-4e78-47a6-9da6-c31cdfe9ab84	f	f	2022-02-04 00:00:00	\N	Rüdisühli	Jael	2008	973990	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
a48fd210-ec0f-46d0-9f63-cb0227d93096	f	f	2022-02-04 00:00:00	\N	Brägger	Jasmine	2006	918149	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
663e698c-2eff-44f2-8b35-b64d66b86b33	f	f	2022-02-04 00:00:00	\N	Formato	Lara	2001	625072	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
832fc4d9-6460-426a-a36b-0465f875493b	f	f	2022-02-04 00:00:00	\N	Germann	Bellaria	2005	918155	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
95bbb9a5-5cdf-47cf-bf24-78bc1bc80c61	f	f	2022-02-04 00:00:00	\N	Henke	Lena	2005	973928	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
c985ee16-07ee-4d29-a0bd-25f188d6ca59	f	f	2022-02-04 00:00:00	\N	Hodel	Lea	2007	918160	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
453c19ae-3f24-490f-ae52-74ea45cd6546	f	f	2022-02-04 00:00:00	\N	Hodel	Mia	2004	848912	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
5ba6892f-4513-45cf-8814-0f799febed47	f	f	2022-02-04 00:00:00	\N	Müller	Fabienne	2001	625131	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
a3d2f743-b6de-4e62-a0a4-edf3303c8013	f	f	2022-02-04 00:00:00	\N	Strassmann	Nina	2006	973999	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
4f22c62d-f383-4933-971a-f7fefac3a6f3	f	f	2022-02-04 00:00:00	\N	Stahl	Daria	2005	862039	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
ca126ca9-7c49-4030-b9fd-ec9d54d87bef	f	f	2022-02-04 00:00:00	\N	Zorzi	Gaia	2001	625427	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
954aba8d-443c-4a0e-b527-160002a0c1c8	f	f	2022-02-04 00:00:00	\N	Corti	Lenia	2015	3535226	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
e025a25d-2a64-4da7-9889-06214d75686a	f	f	2022-02-04 00:00:00	\N	Eberhard	Amelie	2015	3489555	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
c270b5e8-aa5c-4f7e-8bc2-80a8baa9b31b	f	f	2022-02-04 00:00:00	\N	Muñoz Cabrera	Kiara	2014	3475895	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
8d1b2bc1-10ea-49fb-a0b1-102b97780d6c	f	f	2022-02-04 00:00:00	\N	Nef	Alina	2014	3431011	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
7d29e6a3-343e-4a55-b568-b0b328f1824a	f	f	2022-02-04 00:00:00	\N	Pfister	Leya Sophie	2015	3446137	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
21a5c403-3df8-4d71-ace9-0caa17755601	f	f	2022-02-04 00:00:00	\N	Puntillo	Noelia	2014	3347998	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
5b7ba28a-d957-4555-9336-06df2df08547	f	f	2022-02-04 00:00:00	\N	Seiler	Elin	2014	3358803	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
11b38d14-aabe-41dc-ad9b-84088214f714	f	f	2022-02-04 00:00:00	\N	Albrecht	Leonie	2011	3263801	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
54b689dc-9aa3-43f8-9561-08becceb99c5	f	f	2022-02-05 00:00:00	\N	Bucheli	Babette	2010	3107826	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
cb21ee21-052c-46cc-a234-80b7930f82e7	f	f	2022-02-05 00:00:00	\N	Brichet	Felice	2010	3276465	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
95f4fd85-29e4-44f2-a8db-c8295819a339	f	f	2022-02-05 00:00:00	\N	Gassmann	Nadine	2002	664269	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
a882acde-5494-41cd-99e4-b0a2a1f1eef4	f	f	2022-02-05 00:00:00	\N	Baur	Zoë	2009	3466255	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
6e648320-a8bc-4ce8-80ff-7c0fc4fc7c17	f	f	2022-02-05 00:00:00	\N	Akveld	Lena	2013	3276386	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
6e92ebdf-7eaa-4d9f-b82d-bdc647c19670	f	f	2022-02-05 00:00:00	\N	Businger	Laura	2013	3466278	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
9101091b-5a65-4a04-8b23-9deacce2a7ac	f	f	2022-02-05 00:00:00	\N	Crola	Gianna	2009	3107827	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
60c12a90-e350-4fe9-8130-0597344f2f0c	f	f	2022-02-07 00:00:00	\N	Bommeli	Norina	2008	3125808	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
398998d8-6cea-46bd-8057-0c57599aa7b1	f	f	2022-02-05 00:00:00	\N	Kunz	Andrina	2012	\N	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
1d21f9ad-95c6-44f6-bc7b-64fd18021037	f	f	2022-02-08 00:00:00	\N	Ferrari	Stella	2013	3394926	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
3a1d7ba8-c9fb-4083-8ee8-ca4e6f4e56e2	f	f	2022-02-05 00:00:00	\N	Nebel	Alisa	2013	\N	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
3641b75d-bec4-4222-832b-66c576193e57	f	f	2022-02-08 00:00:00	\N	Muri	Michelle	2007	3016646	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
285fb3f0-72cb-410d-babc-64037abcd3a8	f	f	2022-02-05 00:00:00	\N	Sigg	Ronja	2014	\N	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
cd47417e-5749-4472-b58b-cedaa9b171f6	f	f	2022-02-08 00:00:00	\N	Meier	Michelle	2006	928157	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
87006be8-8fdf-4a02-b483-6cf0b50b1520	f	f	2022-02-05 00:00:00	\N	Kunz	Sina	2014	\N	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
d8765998-8c5a-4bc1-8399-816e336cd625	f	f	2022-02-08 00:00:00	\N	Eisenegger	Simea	2006	966628	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
d268d94c-46ae-4a23-af88-e70c2846b39e	f	f	2022-02-05 00:00:00	\N	Kröger 	Liara	2014	\N	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
db88e30b-f348-4b6e-90e2-21821fff0df9	f	f	2022-02-08 00:00:00	\N	Meier	Janice	2008	3017532	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
1ec334ea-43ef-4f44-ac41-ff73311b75f6	f	f	2022-02-08 00:00:00	\N	Brun	Larina	2009	3102454	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
08fb2a70-1689-44d7-bdfd-02881cf17010	f	f	2022-02-08 00:00:00	\N	Suter	Julia	2010	3162303	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
7676576c-1502-448f-bbc4-c5ef0fbdb32c	f	f	2022-02-10 00:00:00	\N	Fabech	Ronja	2001	656281	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
da19d612-9d5d-49bf-b17c-63032fa142da	f	f	2022-02-05 00:00:00	\N	Zürcher	Leana	2004	708343	0	9562c508-9b9f-4852-af78-acd45d6f5d8d	f
104f2c1a-e00e-4f96-9f45-d36f985982f3	f	f	2022-02-10 00:00:00	\N	Klötzli	Marla	2014	\N	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
36c823d3-7d2b-491c-ab1b-b0782936e463	f	f	2022-02-10 00:00:00	\N	Mustafai	Lorena	2011	3386167	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
27c80e65-1769-499d-9daf-28b240a6c9f7	f	f	2022-02-05 00:00:00	\N	Lebherz	Theresa	2014	\N	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
a0eb2cf7-dcc6-4f59-b377-6689836eb8a2	f	f	2022-02-05 00:00:00	\N	Büchi	Mia	2016	\N	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
5e8c99c6-45f0-4710-9431-6a0ad8800da5	f	f	2022-02-12 00:00:00	\N	Balogh	Michelle	1999	560052	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
8d961428-620f-4d0c-8fba-1ba3ac4cdff5	f	f	2022-02-12 00:00:00	\N	Ali	Lalsh	2007	3281712	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
de86c2a4-b5dc-4735-9cae-6d242d15f723	f	f	2022-02-12 00:00:00	\N	Bernhard	Leonie	2013	3438773	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
88fb21eb-b89d-44dc-8386-95ca3fa75ce6	f	f	2022-02-05 00:00:00	\N	Harisberger	Leonie	2011	3227879	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
2b93ce32-e665-4721-a9a8-ba003a3d9013	f	f	2022-02-05 00:00:00	\N	Dradova	Amalia	2010	3101127	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
86f9114d-baf3-4a39-bd15-113fbefdc0a0	f	f	2022-02-05 00:00:00	\N	Helbling	Leonie	2010	3166702	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
5e227106-e41c-4136-a01f-518d2fd94c80	f	f	2022-02-05 00:00:00	\N	Meili	Anja	2009	3101132	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
bc1a0c32-55ad-4081-96a7-e3a2410573fa	f	f	2022-02-05 00:00:00	\N	Matzinger	Nina	2014	3522445	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
f396fa3c-b30c-4d06-885e-739fa7b2e020	f	f	2022-02-05 00:00:00	\N	Mächler	Neola	2015	3513586	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
8143ce55-e397-4273-a7a4-a36654897ee9	f	f	2022-02-05 00:00:00	\N	Kleger	Louisa	2010	3079275	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
219fbd3d-a0dd-425e-b210-1285f9ee8ba7	f	f	2022-02-05 00:00:00	\N	Kleger	Aylin	2009	3079273	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
61f3f63a-d30b-4fce-9fb8-f97c32bbf320	f	f	2022-02-05 00:00:00	\N	Külling	Michaela	2007	3006372	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
5baa134f-7915-4c02-9dc6-a15c44b84985	f	f	2022-02-05 00:00:00	\N	Merk	Amanda	2013	3513588	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
ed750a97-b437-4386-b69a-d1b315811b4c	f	f	2022-02-05 00:00:00	\N	Neukom 	Mia	2008	3154998	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
f7863350-e449-4b3e-9214-63105cc0de2a	f	f	2022-02-05 00:00:00	\N	Mendez	Isabella	2012	3430663	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
7b2f00b3-fd13-4dd6-a56a-19cd5a57af12	f	f	2022-02-05 00:00:00	\N	Ott	Lina	2012	3217118	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
27d3b1fa-ddde-4a54-94b5-354b0171df9d	f	f	2022-02-05 00:00:00	\N	Stauber	Lynn	2010	3151472	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
9917ca61-05d1-4b76-8f9e-012dc81c4fab	f	f	2022-02-05 00:00:00	\N	Spühler	Eva	2011	3070949	0	1d2a9859-0137-4da2-8390-6cd570385ec4	f
058ddf9c-9670-43d7-8fac-7d735575a817	f	f	2022-02-05 00:00:00	\N	Furrer	Levi	2015	3476028	1	08bfbb88-e782-4169-83fd-17b0fd03da18	f
8aaf21f5-d830-4d7c-b9c1-c5272fb4d12f	f	f	2022-02-05 00:00:00	\N	Ulli	Florian	2012	3196699	1	08bfbb88-e782-4169-83fd-17b0fd03da18	f
cc431f52-fc40-45a2-9ed5-8ce6c0acf380	f	f	2022-02-05 00:00:00	\N	Sollberger	Sandro	2015	3560585	1	08bfbb88-e782-4169-83fd-17b0fd03da18	f
1422a8aa-e185-4b22-9530-8a1694f600ea	f	f	2022-02-05 00:00:00	\N	Wanner	Robin	2014	3463262	1	08bfbb88-e782-4169-83fd-17b0fd03da18	f
8deab9e3-7cb8-4e7f-8e47-9d36e310dfe4	f	f	2022-02-05 00:00:00	\N	Lieberherr	Mike	2011	3463270	1	08bfbb88-e782-4169-83fd-17b0fd03da18	f
cd839c1f-28c4-4e9a-adc5-6ff053811313	f	f	2022-02-05 00:00:00	\N	Wüst	Ben	2012	3196691	1	08bfbb88-e782-4169-83fd-17b0fd03da18	f
3c41b0e3-67eb-4478-bd60-153660f16d09	f	f	2022-02-05 00:00:00	\N	Sprecher	Timo	2012	3294956	1	08bfbb88-e782-4169-83fd-17b0fd03da18	f
65b14f26-9cab-4c0e-b456-01993aecfd2f	f	f	2022-02-05 00:00:00	\N	Ramp	Yanik	2004	675534	1	08bfbb88-e782-4169-83fd-17b0fd03da18	f
38d34c77-87a6-4a42-947b-e97300b73f78	f	f	2022-02-05 00:00:00	\N	Müller	Nilo	2011	3133151	1	08bfbb88-e782-4169-83fd-17b0fd03da18	f
eea7d4fa-dd0e-4394-809e-291e2385f779	f	f	2022-02-05 00:00:00	\N	Melliger	Janis	2006	3064054	1	08bfbb88-e782-4169-83fd-17b0fd03da18	f
16227a91-e2ec-4a69-89d6-7c3bc748d903	f	f	2022-02-05 00:00:00	\N	Künzi	Julie	2014	3563966	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
e3ae6a1a-6043-4abf-8721-a3760cd5b542	f	f	2022-02-05 00:00:00	\N	Keller	Mira	2012	3560605	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
922f6a8d-3a9a-4310-ac08-51a3faf038c6	f	f	2022-02-05 00:00:00	\N	Kramer	Leah	2013	3294946	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
0382e9ac-3425-462e-87e7-0e19e9723102	f	f	2022-02-05 00:00:00	\N	Marbot	Enya	2009	3064052	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
9365ca6a-1b0b-4e8d-9c54-21370ada42f3	f	f	2022-02-05 00:00:00	\N	Jenni	Alenka	2010	3098502	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
1df8457d-8ebf-4397-bf5f-ca3722127558	f	f	2022-02-05 00:00:00	\N	Kramer	Jael	2011	3074674	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
fe492f71-7ebb-473b-9c78-b4ccf2b4a346	f	f	2022-02-05 00:00:00	\N	Brogle	Julie	2005	856138	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
048ce912-294c-4a13-86b8-f9e1000edbad	f	f	2022-02-05 00:00:00	\N	Kober	Ronja	2002	675553	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
ae8b5599-f97e-4b5c-88af-edb0a9f0583b	f	f	2022-02-05 00:00:00	\N	Bolliger	Kajsa	2009	3029411	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
e51e7908-db73-4f9a-adba-304237fe0e8a	f	f	2022-02-05 00:00:00	\N	Wagner	Yasmine	2007	3029413	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
aea409b1-4d88-49e1-91e9-d9ce8c969f5a	f	f	2022-02-05 00:00:00	\N	Matos	Marisa	2005	909561	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
9d02d41f-6fb9-4671-8c53-2fff4ca65cac	f	f	2022-02-05 00:00:00	\N	Pfister	Carla	1997	675561	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
1df95b51-01ef-4384-a38f-7b874e6ad5c3	f	f	2022-02-06 00:00:00	\N	Schülé	Charlotte	2012	3369879	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
95a92229-f0fd-434d-848e-6f8c2c724ed0	f	f	2022-02-08 00:00:00	\N	Wigger	Mara	2001	629355	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
51f89c33-4584-4eea-83d3-ca3b7422b930	f	f	2022-02-08 00:00:00	\N	Gitsas	Eleni	2011	3142902	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
995e4d72-b66a-4fe4-9307-0912ae1454d4	f	f	2022-02-08 00:00:00	\N	Müller	Yael	2013	3519943	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
293d2c31-582b-41f1-855f-da90f1ba5e0c	f	f	2022-02-12 00:00:00	\N	Baumann	Melina	2004	982822	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
77d0eb16-980f-4177-8c19-cf535354d005	f	f	2022-02-08 00:00:00	\N	Stanik	Eunice	2013	3433693	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
0d07d37c-6aca-4fb5-8093-05953c2efe1d	f	f	2022-02-08 00:00:00	\N	Haab	Zoé	2014	3469554	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
f8506c25-ad5d-49c4-b171-288dc0910844	f	f	2022-02-08 00:00:00	\N	Ferrari	Solea	2015	3566779	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
6a6d966a-d9a0-4428-8eea-96836a8088d3	f	f	2022-02-08 00:00:00	\N	Büchi	Laura	2014	3383224	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
e6d1234f-bd9b-4018-aa13-091932b86e44	f	f	2022-02-08 00:00:00	\N	Cavelti	Lin	2011	3162266	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
84d3e0bf-f621-42b0-8e83-90f53144f546	f	f	2022-02-09 00:00:00	\N	Birrer	Lucie	2012	3240624	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
dce03d98-82a3-4cb8-9428-9307f75778b8	f	f	2022-02-12 00:00:00	\N	Griesser	Olivia	2005	917081	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
5e72eccc-7864-4fbc-98b9-ad967584a82f	f	f	2022-02-09 00:00:00	\N	Enzler	Lielle	2008	3140504	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
175c3252-a96f-4b48-9a19-ea7e4a0d3860	f	f	2022-02-09 00:00:00	\N	Ramsauer	Kim	2005	893106	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
a7494748-9add-4ab7-99b8-dc3547e6b5f5	f	f	2022-02-12 00:00:00	\N	Hürzeler	Claudia	2004	852672	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
e0fb5e2a-93a2-453d-97d8-c94c897e0d8b	f	f	2022-02-09 00:00:00	\N	Bachmann	Anja	2002	655249	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
204f36db-73fe-487e-86a3-f022a325b543	f	f	2022-02-09 00:00:00	\N	Henderson	Leslie	2014	3482823	0	0f604f34-370f-4593-8173-cd24234cff78	f
bda6ecda-4fba-458d-b20a-69d163bcf157	f	f	2022-02-12 00:00:00	\N	Kühne	Naja	2001	628135	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
2879dab9-0765-48e3-8266-5d3dde056016	f	f	2022-02-09 00:00:00	\N	Lanker	Elina	2013	3437764	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
99494421-4307-4024-a6c4-3222f834d5fa	f	f	2022-02-09 00:00:00	\N	Aciktepe	Ceren	2011	3301022	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
198eef1c-28fa-4e28-bc7d-85f42496a204	f	f	2022-02-12 00:00:00	\N	Maurer	Julia	2005	650937	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
211eec35-3413-4465-9ba2-17697e22207c	f	f	2022-02-12 00:00:00	\N	Rindlisbacher	Jasmin	2004	691454	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
2e10e068-f8a0-4121-860e-f17eb67934b9	f	f	2022-02-09 00:00:00	\N	Flieg	Talya	2010	3155077	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
d1f8b4c8-f6a4-43cb-9a5a-0612780a3320	f	f	2022-02-09 00:00:00	\N	Gavrilovic	Ena	2010	3155105	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
4b0c8fbb-7305-4fa1-8d35-8c322fa03c15	f	f	2022-02-12 00:00:00	\N	Schläpfer	Ivy	2004	650919	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
6f7a4cda-a44d-46c2-beb6-523eddd25730	f	f	2022-02-09 00:00:00	\N	Romer	Luana	2010	3279218	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
b9c08f20-895f-446b-b84b-fadb763488df	f	f	2022-02-09 00:00:00	\N	Steinegger	Xenia	2008	3025271	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
fa8ac1e1-892c-4438-8c62-775c7e3aab58	f	f	2022-02-12 00:00:00	\N	Steiner	Tamara	2003	608499	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
9f4ff3b5-8a2d-4e0e-998b-dec909e9b36b	f	f	2022-02-09 00:00:00	\N	Bieri	Sarina	2008	3108999	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
bd708929-fd1e-403a-9d98-353a713931cd	f	f	2022-02-09 00:00:00	\N	Burri	Nadja	2008	3048954	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
6307e108-3115-48ee-95e7-868a93ac694b	f	f	2022-02-12 00:00:00	\N	Zahn	Ylva	2005	852662	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
975e5c2a-f88f-4883-bd57-e41d435db782	f	f	2022-02-09 00:00:00	\N	Flieg	Ylana	2007	3048956	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
abd525ac-e2dc-4ab7-86d5-3f9344060026	f	f	2022-02-12 00:00:00	\N	Eigenheer	Joelle	2006	942005	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
23aaf841-20e3-44fc-826d-0187337d8e6f	f	f	2022-02-09 00:00:00	\N	Gysel	Annina	2007	3027194	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
4eeaa412-2086-4ec0-9649-833434bca94e	f	f	2022-02-12 00:00:00	\N	Flacher	Viola	2012	3180742	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
5ecd5bf2-2f69-484a-8fba-53a5f8fcce6c	f	f	2022-02-09 00:00:00	\N	Leu	Enya	2007	3048957	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
5b90193a-b167-4710-96ef-b39a9fb33831	f	f	2022-02-09 00:00:00	\N	Storz	Alessa	2009	3099224	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
00ed216f-46d8-4ab5-bdb3-86db4a2389f4	f	f	2022-02-09 00:00:00	\N	Keller	Sina	2002	648668	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
9c989432-9e16-43d7-9119-7f1785b7fad1	f	f	2022-02-09 00:00:00	\N	Schönenberger	Karin	2005	880682	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
632d1973-de46-491a-b715-daf09ce5e1fc	f	f	2022-02-09 00:00:00	\N	Consoli	Daria	2001	648604	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
6490634f-2694-4818-b943-b5b4246b8073	f	f	2022-02-11 00:00:00	\N	Gubser	Aina	2015	\N	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
0861b110-9c87-455c-89b5-46463a38958b	f	f	2022-02-12 00:00:00	\N	Hess	Nina	2013	3489900	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
3eb3f4e8-7292-4717-99da-901eef821181	f	f	2022-02-12 00:00:00	\N	Kabac	Linda	2013	\N	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
1302994a-f60b-4969-a007-e66a722ac07b	f	f	2022-02-12 00:00:00	\N	Winkler	Jana	2012	3312966	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
e796e9a7-0489-4028-b68a-3ca83ec7dbac	f	f	2022-02-12 00:00:00	\N	Flacher	Priyanka	2013	3481658	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
ed602fb3-23bf-45b3-b1b7-86f121283e6e	f	f	2022-02-12 00:00:00	\N	Bruderer	Nadine	2010	3312941	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
56ed6c2f-620d-4970-bbe5-c0a0da72c432	f	f	2022-02-12 00:00:00	\N	Braun	Selina	2011	3193442	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
541b9cd6-6455-430e-8edf-f3e377764122	f	f	2022-02-12 00:00:00	\N	Etter	Emilia	2013	3400598	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
829254bc-6b3e-4967-851d-4e0c3e418481	f	f	2022-02-12 00:00:00	\N	Alberola	Nerea	2008	984463	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
2e3f545a-4685-4584-b57c-fef634110555	f	f	2022-02-12 00:00:00	\N	Kaufmann	Svenja	2003	620046	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
50713d40-05da-4b24-97ff-9965bb0c811d	f	f	2022-02-12 00:00:00	\N	Merlo	Danisha	2001	648410	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
ce72f6ce-42db-47a4-a20b-aead03f563f7	f	f	2022-02-12 00:00:00	\N	Haldemann	Lina	2015	\N	0	e2438143-6017-4683-a533-6113748d4117	f
34fa2d0d-9821-482f-974d-75360c2f3253	f	f	2022-02-12 00:00:00	\N	Traber	Sophie	2012	\N	0	e2438143-6017-4683-a533-6113748d4117	f
8c67d5c9-a4bc-4160-b020-353b5d927d0b	f	f	2022-02-12 00:00:00	\N	Gentsch	Alexandra	2004	873005	0	e2438143-6017-4683-a533-6113748d4117	f
f34da9b4-6687-4468-a3fa-4f799bee9653	f	f	2022-02-12 00:00:00	\N	Akeret	Yara	2016	3475975	0	e2438143-6017-4683-a533-6113748d4117	f
f44189a0-caaa-49e4-9f81-a3f43b98c1aa	f	f	2022-02-12 00:00:00	\N	Giuliani	Flavia	2005	630343	0	e2438143-6017-4683-a533-6113748d4117	f
1cd79060-b588-4f16-86f1-02e10b9c1936	f	f	2022-02-12 00:00:00	\N	Kleibusch	Anna-Lena	2004	932521	0	e2438143-6017-4683-a533-6113748d4117	f
7c7af252-16e7-42cb-ab4d-958a5293d826	f	f	2022-02-12 00:00:00	\N	Gut	Flavia	2009	3121167	0	e2438143-6017-4683-a533-6113748d4117	f
79e7d469-dcc6-4e98-b1d1-582d6e64c931	f	f	2022-02-12 00:00:00	\N	Tanner	Elea	2009	3121174	0	e2438143-6017-4683-a533-6113748d4117	f
2c03d22e-ff21-4d07-aed6-39d1ab816588	f	f	2022-02-12 00:00:00	\N	Gut	Kristina	2014	3475979	0	e2438143-6017-4683-a533-6113748d4117	f
b3e2d484-dd24-4bc9-afc1-debae1ef4a5e	f	f	2022-02-12 00:00:00	\N	Halbritter	Amélie	2015	3475981	0	e2438143-6017-4683-a533-6113748d4117	f
3883d7dd-538a-4a63-a387-e1dcf06063eb	f	f	2022-02-12 00:00:00	\N	Hagen	Anna	2012	3414168	0	e2438143-6017-4683-a533-6113748d4117	f
fdda92b1-b284-44ad-8cf2-f1036e2dcbc6	f	f	2022-02-13 00:00:00	\N	Camarillo	Maya	2009	3087075	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
769cb8cf-b4d0-4843-9fc1-32e3c925b054	f	f	2022-02-13 00:00:00	\N	Stössel	Selina	2011	3222113	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
1e74800f-9898-45b5-8543-3d77d6109111	f	f	2022-02-13 00:00:00	\N	Bachmann	Ramina	2001	591034	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
6a3ae2f5-3bc5-4490-aa8b-ac8b3f09d2c2	f	f	2022-02-13 00:00:00	\N	Luzi	Kim	2013	3123504	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
2e8918ec-79f4-4f6e-b40d-144456de1bb1	f	f	2022-02-13 00:00:00	\N	Feger	Anna-Lena	2013	3507554	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
806b10d9-e677-40ed-9176-d92814453928	f	f	2022-02-06 00:00:00	\N	Scholl	Anike	2013	3466589	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
549f5d94-0496-4769-b379-d9c544362f42	f	f	2022-02-08 00:00:00	\N	Fuchs	Elisa	2010	3151151	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
4e24cbec-ce75-4754-9f9e-b3350d852f7c	f	f	2022-02-06 00:00:00	\N	Jesus Oliveira	Nathalia	2012	3466583	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
f38d087e-f090-480c-acd6-f83c03d978e5	f	f	2022-02-08 00:00:00	\N	Marucci	Alissa	2010	3102872	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
b3500eb4-cfb3-4306-8255-8b65c7032fdb	f	f	2022-02-08 00:00:00	\N	Rickenbach	Aline	2011	3141561	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
906fdabf-c26f-4a51-99b0-a893497ed8e1	f	f	2022-02-12 00:00:00	\N	Aschwanden	Niamh	2011	3266351	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
db78f9a5-5edb-458e-858b-597a3d88f37e	f	f	2022-02-08 00:00:00	\N	Ramoni	Laura	2011	3243441	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
b9a251bf-2d34-4d2a-940b-889084d71586	f	f	2022-02-08 00:00:00	\N	Stöckli	Elin	2011	3305967	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
8f075f1e-145c-4ab0-b138-ef421301a02a	f	f	2022-02-12 00:00:00	\N	Beutler	Dominique	2002	582669	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
7ae28e60-3832-4922-8cc6-1e1a8d62733b	f	f	2022-02-08 00:00:00	\N	Näf	Lia	2010	959800	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
b0e9652e-344b-4d76-aa75-197f4376c796	f	f	2022-02-08 00:00:00	\N	Kuljici	Larisa	2006	896215	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
e9629839-5cd8-4533-9eb0-db75f06ae1db	f	f	2022-02-12 00:00:00	\N	Diana	Ambra	2004	669825	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
c9bd5703-664f-43d5-a219-697e091d6f03	f	f	2022-02-08 00:00:00	\N	Rohner	Giulia	2007	3005386	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
ec9dfa4c-de2d-497d-a937-033fc874d694	f	f	2022-02-08 00:00:00	\N	Hirni	Sina	2006	896089	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
ecd0e170-2509-4e0f-b007-3ce6da469751	f	f	2022-02-08 00:00:00	\N	Meier	Elina	2012	3262683	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
8027cedf-0442-4091-83e4-0ffbdf93ba73	f	f	2022-02-08 00:00:00	\N	Dieziger	Delia	2012	3383245	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
d844b85d-ea44-46ac-9217-e717b2c17c96	f	f	2022-02-12 00:00:00	\N	Haas	Michelle	1999	512525	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
39448a37-5e1d-4f05-b487-635e1da93b4a	f	f	2022-02-09 00:00:00	\N	Rey	Milena	2009	3088669	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
a82bcd07-7321-4a64-becb-e6c3d2b565b0	f	f	2022-02-12 00:00:00	\N	Huber	Leonie	2004	650911	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
d2fc486c-f7fc-45ca-89eb-871905c8a728	f	f	2022-02-09 00:00:00	\N	Jucker	Carla	2009	3153494	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
573bf4ec-43a4-4603-890e-b67fcb8ec1c5	f	f	2022-02-09 00:00:00	\N	Isaak	Lynn	2004	893125	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
424962c9-693b-4e41-8077-0a9ccaec49c0	f	f	2022-02-12 00:00:00	\N	Locher	Nadine	2000	648607	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
773fb237-0f8a-468b-9b5c-54e5141e274d	f	f	2022-02-09 00:00:00	\N	Kienast	Milena	2012	3522566	0	0f604f34-370f-4593-8173-cd24234cff78	f
f2f7bc5c-197f-4dab-916c-3865c0d3edfb	f	f	2022-02-09 00:00:00	\N	Schiopu	Alexia	2013	3485799	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
d2ab70ca-7995-47f6-be7c-108c232378df	f	f	2022-02-12 00:00:00	\N	Schaps	Denise	1990	509397	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
38592602-8c64-48ef-b22d-f78e6648765a	f	f	2022-02-09 00:00:00	\N	Banzer	Amélie	2013	\N	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
0a4dd1cd-5d47-4e4e-9d89-39d5c7ab461a	f	f	2022-02-09 00:00:00	\N	Curiale	Gemma	2013	\N	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
9bbea901-cf25-4a62-a959-44373ecdc7dd	f	f	2022-02-12 00:00:00	\N	Schürch	Michelle	2003	572021	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
5db5bcb8-e81b-4400-98c1-9c407c90fe18	f	f	2022-02-09 00:00:00	\N	Kannanur	Devna	2012	3381370	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
0fba3e4c-1f55-4936-9fea-2ec5f0fa52d3	f	f	2022-02-09 00:00:00	\N	Wildhaber	Alea	2007	3048959	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
280ba59f-ed89-40e8-a0b8-a73652483618	f	f	2022-02-12 00:00:00	\N	Abdelgawwad	Dina	2007	912501	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
5a11d4ce-fb3d-4538-a191-199e997326dd	f	f	2022-02-10 00:00:00	\N	Özcan	Gizem	2014	3511335	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
4159ae02-4eda-48b3-9040-b122aeabfa86	f	f	2022-02-11 00:00:00	\N	Werffeli	Pia	2015	\N	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
0c4d0153-5b05-41e8-96e9-5acf39d8126d	f	f	2022-02-12 00:00:00	\N	Besson	Jaël	2009	3040768	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
834672cd-b483-4919-91a7-b0b5e030a276	f	f	2022-02-12 00:00:00	\N	Bindschädler	Alesha	2010	3112435	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
65f95fec-c983-4d64-bebd-f346c9d9814a	f	f	2022-02-12 00:00:00	\N	Engeler	Alessa	2015	3542572	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
b40cbb1a-0d52-4eb0-a488-4c50617017d9	f	f	2022-02-12 00:00:00	\N	Fehr	Alina	2007	912510	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
b7cd2bf7-d4af-498f-a0a7-072150669fe4	f	f	2022-02-12 00:00:00	\N	Fehr	Shania	2007	912511	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
b9b25b7a-d938-42a1-a32d-b07313391377	f	f	2022-02-12 00:00:00	\N	Frauenfelder	Chiara	2008	3054575	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
c92a962e-8a60-4e50-aa51-0db4457c63eb	f	f	2022-02-12 00:00:00	\N	Giammarresi	Selina	2014	3390349	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
d366b36c-2a31-40f8-999a-c9463e6e3d3e	f	f	2022-02-12 00:00:00	\N	Moser	Amelie	2012	\N	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
1642eea4-aac0-4b5f-91fa-10893e51989a	f	f	2022-02-12 00:00:00	\N	Huber	Sara	2012	3297998	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
fa653d18-2080-4a81-a639-6b675ca032bc	f	f	2022-02-12 00:00:00	\N	Walter	Lina	2013	3298014	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
4ad3ea2e-5e13-4cdd-bab2-55cf219ab6df	f	f	2022-02-12 00:00:00	\N	Werenfels	 Mara	2012	\N	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
312b27c5-ad2c-451b-bbcd-c125baa6347d	f	f	2022-02-12 00:00:00	\N	Egli	Muriel	2007	3025764	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
717d0dcb-c431-4105-a990-ce7c1ec6d31f	f	f	2022-02-12 00:00:00	\N	Maitland	Poppy	2004	3031854	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
4999e2ee-d748-4aad-8336-5ec68e0a93ab	f	f	2022-02-12 00:00:00	\N	Lienhard	Timea	2009	3121177	0	e2438143-6017-4683-a533-6113748d4117	f
114106e5-365c-4335-9870-2d7239a5435f	f	f	2022-02-12 00:00:00	\N	Urscheler	Maren	2008	3198024	0	e2438143-6017-4683-a533-6113748d4117	f
f9808c47-bbe3-4f2a-a53d-170f20dced96	f	f	2022-02-12 00:00:00	\N	Falk	Nina	2010	3294923	0	e2438143-6017-4683-a533-6113748d4117	f
d79ee0d3-3499-4f4a-b25a-48103e95f385	f	f	2022-02-13 00:00:00	\N	Dümmel	Julia	2011	3178845	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
108c49fd-03b0-4c06-825b-18790061930c	f	f	2022-02-13 00:00:00	\N	Meier	Elodie	2009	3221696	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
277f27a3-1d1f-49e5-ae0e-b8602a0447be	f	f	2022-02-13 00:00:00	\N	Spasic	Lara	2013	3426749	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
37016bfb-9a4a-443e-ad94-cfee88a08f65	f	f	2022-02-13 00:00:00	\N	Schüpbach	Romina	2011	3153720	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
199a82f4-fbb3-450b-999b-d0425aab8ac9	f	f	2022-02-13 00:00:00	\N	Sgubin	Joana	2012	3426746	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
e94ba6f3-88b7-4a9a-912c-424bbb4ac291	f	f	2022-02-13 00:00:00	\N	Bünter 	Eva	2003	718812	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
d015169c-ef5c-41f0-b273-9564999d2bb1	f	f	2022-02-13 00:00:00	\N	Ciger	Sophia	2013	3507552	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
b08c1e37-9a9c-40fe-bf32-3d4fbb96962a	f	f	2022-02-13 00:00:00	\N	Merlo	Elina	2013	3336916	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
97f2d74d-78f5-44d3-aca0-57650dedc3cd	f	f	2022-02-13 00:00:00	\N	Rozanska	Mia	2013	3507549	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
8987f318-8ee9-4d96-8a01-cdd2fef52fe0	f	f	2022-02-13 00:00:00	\N	Jäckle	Fabienne	2000	609316	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
c46fa5a7-7da7-4d1b-a621-379f06624c18	f	f	2022-02-14 00:00:00	\N	Bieri	Mia	2015	3434936	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
fe75f546-fbda-4359-99a5-bf7a2d199473	f	f	2022-02-14 00:00:00	\N	Grob	Mara	2014	3434923	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
95e9bc4b-3193-44bf-83ac-a2210f0539d1	f	f	2022-02-14 00:00:00	\N	Heim	Melia	2015	3331869	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
19a090dc-b4ad-4423-b6f6-3f02439c2ce7	f	f	2022-02-14 00:00:00	\N	Wietlisbach	Anna-May	2013	3224390	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
a410c2d8-8006-498b-9fef-92580de60544	f	f	2022-02-14 00:00:00	\N	David	Aliz	2012	3221364	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
95329cf9-5086-41db-b633-f1ed7d5ee273	f	f	2022-02-14 00:00:00	\N	Morf	Timea	2013	3140838	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
565f5c49-58f6-4922-be69-3b86ecb19717	f	f	2022-02-14 00:00:00	\N	Balta	Elif	2011	3267291	0	42933e50-7306-4a54-b42a-276813e8b03a	f
c6868e81-4725-4808-ae6e-24a16384674b	f	f	2022-02-14 00:00:00	\N	Balta	Ayse	2015	3477873	0	42933e50-7306-4a54-b42a-276813e8b03a	f
2f6e9c37-c69e-4f6d-acff-b169b8273f7c	f	f	2022-02-06 00:00:00	\N	Locatelli	Lorina	2013	3466589	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
cca9c568-dd1b-4b8c-bc90-fc898f9e2c6d	f	f	2022-02-08 00:00:00	\N	von Felten	Melanie	2008	3250409	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
d9eec293-c0b5-4772-b7c2-e1c72676ea8b	f	f	2022-02-13 00:00:00	\N	Frey	Emilia	2013	3429305	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
de243a58-337b-4a8b-8322-7af814da9593	f	f	2022-02-08 00:00:00	\N	Egli	Carlina	2012	3143416	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
a83e3ac8-1b7e-4a3c-99b0-3d0043781c87	f	f	2022-02-12 00:00:00	\N	Blattmann	Melanie	2012	3266360	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
6ca7f798-3700-4f38-bb11-34708b47de39	f	f	2022-02-08 00:00:00	\N	Mazza	Clara	2008	3356310	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
f88ee1a3-98cc-49f8-8c47-09a337263324	f	f	2022-02-08 00:00:00	\N	Olthof	Jolina	2007	3005384	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
855aeab7-def6-4f8b-84bc-3d80db8fb369	f	f	2022-02-12 00:00:00	\N	Beutler	Nina	2006	852687	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
50d97ea9-48c1-43ca-be4a-2f0d5e9de270	f	f	2022-02-08 00:00:00	\N	Glaus	Mirja	2005	845434	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
81e2b506-943d-4973-8bc2-5c0959cf9f61	f	f	2022-02-08 00:00:00	\N	Etter	Camille	2004	842680	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
5622ed0d-348b-4428-831e-ac063dfb802f	f	f	2022-02-08 00:00:00	\N	Schüepp	Aomi	2009	3104201	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
637aeb75-b0ba-4664-8404-cb4f000cc0d9	f	f	2022-02-12 00:00:00	\N	Riesen	Ariana	2015	\N	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
9d446514-789d-4ce4-a346-ae16fc95e783	f	f	2022-02-08 00:00:00	\N	Laurino	Delia	2005	905040	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
2ef89bca-f01a-45f8-a471-873aec2cb4c8	f	f	2022-02-08 00:00:00	\N	Werder	Linnéa	2012	3383283	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
eb5cc30e-35bf-4d4a-bd29-bc51d63bfc0d	f	f	2022-02-08 00:00:00	\N	Roth	Braida	2012	3383269	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
6001ed44-1a9e-4aa0-b318-3b4e2d08d4ae	f	f	2022-02-08 00:00:00	\N	Kapatos	Janis	2014	3345179	1	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
4ffa7016-2aa3-4aa2-92b5-62d9f7bd8208	f	f	2022-02-09 00:00:00	\N	Grob	Noelia	2009	3153501	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
2a4293e1-0c0c-4cb2-856f-0c874c6a91f0	f	f	2022-02-12 00:00:00	\N	Rigaud	Louise	2011	3303896	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
03f98ac2-a789-49de-a7cb-48d9915ce1ea	f	f	2022-02-09 00:00:00	\N	Zappa	Giulia	2013	3565670	0	0f604f34-370f-4593-8173-cd24234cff78	f
da97544a-370d-47cf-ae2f-c0d710a58698	f	f	2022-02-09 00:00:00	\N	Schläpfer	Amanda	2014	3440725	0	0f604f34-370f-4593-8173-cd24234cff78	f
feeefcc4-ade1-4521-a378-a113b5e5566d	f	f	2022-02-12 00:00:00	\N	Oswald	Franziska	1995	673722	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
0758a15c-592b-4563-944c-d0acafc554bc	f	f	2022-02-12 00:00:00	\N	Friedrich	Finja	2013	\N	0	e2438143-6017-4683-a533-6113748d4117	f
96740fd3-e0e7-4422-b172-4155b2d2000b	f	f	2022-02-09 00:00:00	\N	Sen	Lara	2011	3499755	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
bdadb6f5-caee-4164-9086-0d66b53bfe7f	f	f	2022-02-09 00:00:00	\N	Lercher	Leonie	2011	3147771	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
1b5761cf-f7a1-4726-af53-395b614dbd81	f	f	2022-02-09 00:00:00	\N	Hintermann	Alessia	2013	3474179	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
2b737aac-8319-4f2c-a1a4-45ecfd716afc	f	f	2022-02-09 00:00:00	\N	Piron	Sarah	2007	3027209	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
21053e9f-2717-44fc-b549-8fc1d3052260	f	f	2022-02-09 00:00:00	\N	Schläpfer	Stefanie	2006	963542	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
23e5d9c7-73fb-4f8b-b02b-317551081449	f	f	2022-02-09 00:00:00	\N	Senn	Leila	2005	963557	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
6293e75a-17ba-4ca8-bebb-e72ea901b4a0	f	f	2022-02-09 00:00:00	\N	Korca	Buna	2013	\N	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
369dc04d-4bbe-4d2f-b201-c1b1cabaa8ee	f	f	2022-02-10 00:00:00	\N	Pfeffer	Lisa	2001	3005664	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
681afc77-c5a5-43dd-80c4-f64c73fb7d36	f	f	2022-02-10 00:00:00	\N	Räber	Siona	2011	3365277	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
b93fde1c-4ba9-4be8-9d0f-09e61b6ed38e	f	f	2022-02-12 00:00:00	\N	Zweidler	Leyla	2015	\N	0	e2438143-6017-4683-a533-6113748d4117	f
84f3b872-e15b-4ba5-8b59-81eedc7514ff	f	f	2022-02-10 00:00:00	\N	Ramsauer	Andrina	2014	3511337	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
10bf05eb-3d95-45de-a973-134a321e5e7b	f	f	2022-02-12 00:00:00	\N	Ropcevic	Dora	2009	3198026	0	e2438143-6017-4683-a533-6113748d4117	f
9982bbb2-4b4e-4ebc-a2b9-86801153170e	f	f	2022-02-10 00:00:00	\N	Schmidt	Sophia	2012	3488386	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
78e72594-35c8-499c-90c3-d615fbb605e0	f	f	2022-02-12 00:00:00	\N	Tanner	Yael	2011	3198016	0	e2438143-6017-4683-a533-6113748d4117	f
34390b7a-9094-4989-9474-98d859b806de	f	f	2022-02-10 00:00:00	\N	Snoussi	Meryem	2013	3511339	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
454ad479-09e9-4f77-875c-9748519cfb1a	f	f	2022-02-12 00:00:00	\N	Wenger	Alessia	2008	3062599	0	e2438143-6017-4683-a533-6113748d4117	f
a2233224-1f91-4fc0-ae2c-ec1d77bf3c2f	f	f	2022-02-10 00:00:00	\N	Trassin	Louise	2013	3365279	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
8e2a873d-ac22-4344-bfa5-2ba8ab1306f0	f	f	2022-02-10 00:00:00	\N	Vertudes	Ria	2015	3511341	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
04b3c670-8ffa-4df7-a023-1ec850d25f3f	f	f	2022-02-10 00:00:00	\N	Vögelin	Marisa	2010	3235054	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
8eee7799-88ee-42a4-b9d4-688a019f05a2	f	f	2022-02-13 00:00:00	\N	Rüthy	Lennja	2015	3552102	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
ff3ca3fb-edc8-49e6-be65-bf3e1705fd9e	f	f	2022-02-10 00:00:00	\N	von Groll	Anouk	2004	658136	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
01f8c8f9-f840-48c1-9113-f24ac2519bfa	f	f	2022-02-13 00:00:00	\N	Krawczonek	Nina	2011	3203824	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
0d39d031-e0ec-449e-9bd8-c4366b8b18c3	f	f	2022-02-10 00:00:00	\N	von Groll	Joana	2004	658145	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
c0f48b50-3ce3-4c67-9cb8-3ec8753bdd99	f	f	2022-02-11 00:00:00	\N	Sebregondi	Norea	2012	3403539	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
2773fb52-7b8d-4da3-8ff5-d8af8fb3c700	f	f	2022-02-13 00:00:00	\N	Burnier	Laetitia	2013	3447433	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
f77633f3-538d-4848-95df-a90cf82282e0	f	f	2022-02-13 00:00:00	\N	Eggenschwiler	Vivien	2014	3222303	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
96eac89e-2194-4d47-918b-20bc1b9898a1	f	f	2022-02-13 00:00:00	\N	Gomes	Ana-Leticia	2012	3507556	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
602aca19-8836-4523-a334-a4e5ef086dc7	f	f	2022-02-13 00:00:00	\N	Mühl	Carolina	2013	3367370	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
27071f63-625b-40cb-b90c-0d3965d58a26	f	f	2022-02-14 00:00:00	\N	Hagena	Coco	2012	3523036	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
8d2e3f23-b9a1-4f42-976f-507dbe752c0f	f	f	2022-02-14 00:00:00	\N	Murer	Alina	2014	3522345	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
d6d6aba3-0f7b-4eac-94ca-89395eced0c2	f	f	2022-02-14 00:00:00	\N	Keller	Larina	2006	888088	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
3930671f-c62e-4e1a-bbcc-372d6c4375e8	f	f	2022-02-14 00:00:00	\N	Morf	Lia	2012	3114582	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
677dcd6c-0415-493f-86c3-783d7679391a	f	f	2022-02-14 00:00:00	\N	Schweizer	Lily	2012	3221370	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
c4c14e85-61d5-4d7b-a40a-382fbeca63ee	f	f	2022-02-14 00:00:00	\N	Stierli	Malou	2011	3221372	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
6f002a8b-ee2d-43a9-a405-0bab808471a3	f	f	2022-02-14 00:00:00	\N	Hamburger	Julia	2009	3017336	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
637882c0-1a02-4a3c-90d2-ca343eb28a71	f	f	2022-02-14 00:00:00	\N	Kern	Yael	2009	3089148	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
296d0e54-a91b-4be1-9cd0-5e5f4010df58	f	f	2022-02-14 00:00:00	\N	Abt	Jael	2009	3014876	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
5fdef84b-8f50-4e5c-b99b-8c143310f915	f	f	2022-02-14 00:00:00	\N	Pastorella	Lorena	2003	685735	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
ba43651c-081b-4f97-a380-bdcc56f00f7b	f	f	2022-02-14 00:00:00	\N	Rey	Meret	2002	849036	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
91097d2d-6422-4617-be59-1cf37ddf58e2	f	f	2022-02-14 00:00:00	\N	Schöpfer	Noemi	2005	921060	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
516bc84a-6327-481e-a2d1-cddc3cc93b1d	f	f	2022-02-14 00:00:00	\N	Steiner	Rebekka	2002	665743	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
21fe8a9a-ae8b-4450-83f4-ed2bccc11130	f	f	2022-02-14 00:00:00	\N	Kober	Kim	2001	664716	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
ef335b15-f870-4033-aebf-f2846307eaf9	f	f	2022-02-14 00:00:00	\N	Chappuis	Léonie	2007	950789	0	42933e50-7306-4a54-b42a-276813e8b03a	f
09e1f5dd-381f-4263-900f-0c2938c0a0c6	f	f	2022-02-14 00:00:00	\N	Derungs	Lisa	2006	881520	0	42933e50-7306-4a54-b42a-276813e8b03a	f
e67bef54-dd18-4907-8476-36383319c724	f	f	2022-02-14 00:00:00	\N	Hager	Livia	2009	3197760	0	42933e50-7306-4a54-b42a-276813e8b03a	f
6882126c-5047-4c1d-b6ec-08310888d2b2	f	f	2022-02-12 00:00:00	\N	Hanselmann	Fiona	2005	852689	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
fcfa6fac-ad43-4ce7-84e5-ffc9373086f5	f	f	2022-02-10 00:00:00	\N	Sterchi	Jani	2007	\N	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
9968c3c6-6624-4fbe-bd63-0fb7c67526cd	f	f	2022-02-06 00:00:00	\N	Steiner	Evelina	2013	3473081	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
6f06796c-ee1b-4121-ab91-beb0e8daec20	f	f	2022-02-06 00:00:00	\N	Erni	Ella	2012	5217276	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
8e6f5cd7-45da-4904-8e25-6caec080e74d	f	f	2022-02-06 00:00:00	\N	von Virág	Marie-Lou	2014	3473089	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
9538da6f-63a3-4636-986a-42ce94676e55	f	f	2022-02-06 00:00:00	\N	Stuhner	Alma	2014	3473087	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
9862a8bc-e5ff-442c-8b24-ed68b5b921b6	f	f	2022-02-06 00:00:00	\N	Bürge	Malea	2013	3473070	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
af0259a4-5b74-4920-be86-24253a49b5df	f	f	2022-02-06 00:00:00	\N	Richle	Corabelle	2013	3473077	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
c09e5f75-f639-4a1f-9fdc-66d0ac7afa1b	f	f	2022-02-06 00:00:00	\N	Eugster	Meret	2013	3379928	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
feea2974-5e14-425c-8d55-c5b1306922e0	f	f	2022-02-06 00:00:00	\N	Zgraggen	Lou	2011	3379959	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
323ebe70-a430-4fb2-a6f1-c55dcf4043b8	f	f	2022-02-06 00:00:00	\N	Störi	Binia	2013	3306342	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
730cd9c8-376f-4ede-82f2-f2d260318cb0	f	f	2022-02-06 00:00:00	\N	Mesot	Vivi	2013	3329599	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
da926c50-9d0b-4407-872b-b2c29c4a920e	f	f	2022-02-06 00:00:00	\N	Kümin	Lina	2014	3379955	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
3232a4ee-1e57-4aba-852e-c96d18e17723	f	f	2022-02-06 00:00:00	\N	Bürge	Arianna	2010	3473062	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
a0ff3547-1a31-45dc-924f-05befa26ab2d	f	f	2022-02-06 00:00:00	\N	Bürge	Yelina	2010	3194259	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
c44235f1-617b-43be-8aa8-69572967ad46	f	f	2022-02-06 00:00:00	\N	Karrer	Leonie	2009	3379951	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
c87b5036-1cc1-470f-8d59-9b44c30236c9	f	f	2022-02-06 00:00:00	\N	Frei	Viola	2011	3473073	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
a3fb6040-aab2-48b6-8f46-e38b93d92997	f	f	2022-02-06 00:00:00	\N	Metzger	Livia	2010	3379963	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
8e264292-3e2b-4f59-88fb-173330c1c20f	f	f	2022-02-06 00:00:00	\N	Schubiger	Livia	2010	3164481	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
66fe8b79-f2df-4082-af61-f17a076ce9dd	f	f	2022-02-06 00:00:00	\N	Weishaupt	Marlene	2011	3473091	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
d9cd5fdf-5aa4-4c42-a741-b4e6a3e2978a	f	f	2022-02-06 00:00:00	\N	Müller	Irina	2010	3168067	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
c8b2e25d-65ad-449c-9d08-39a841affe30	f	f	2022-02-06 00:00:00	\N	Steiner	Tilda	2011	3473093	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
2f51dc51-4db9-4c2d-aef8-87376424af1d	f	f	2022-02-06 00:00:00	\N	Stäger	Annina	2010	3119104	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
aa58405f-46bb-4000-9a01-976dc532e9ba	f	f	2022-02-06 00:00:00	\N	Mesot	Elina	2010	3306226	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
b668083c-9f54-4787-8b7a-09b866ba5e19	f	f	2022-02-06 00:00:00	\N	Houben	Stella	2010	3379942	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
f35613ea-fe14-4b4a-8fd3-b2b5648ed805	f	f	2022-02-06 00:00:00	\N	Cubello	Mina	2009	3164441	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
c233cbe9-f869-43db-b7b0-63f14fef45d8	f	f	2022-02-06 00:00:00	\N	Baumann	Arwen	2007	3379899	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
dc7f9cc6-3f93-4f57-bce7-8e259c6b315c	f	f	2022-02-06 00:00:00	\N	Guyer	Ava	2009	3116590	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
3ce4b32c-a049-4312-a865-553ef84eb731	f	f	2022-02-06 00:00:00	\N	Moreno	Camila	2007	3379968	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
00707149-4813-430e-b24b-9d3cc2e3017f	f	f	2022-02-06 00:00:00	\N	Niederberger	Rebecca	2010	3164477	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
e304694e-103c-4895-99d7-a38433dfa6f2	f	f	2022-02-06 00:00:00	\N	Sievers	Emma	2009	3168086	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
24cde7d0-cf95-4432-9523-ef30e7c2c868	f	f	2022-02-06 00:00:00	\N	Löhrer	Nora	2011	3164464	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
1100f1d4-c172-46b6-b03c-485efb044fbe	f	f	2022-02-06 00:00:00	\N	Troxler	Louise	2008	3119094	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
4ff65ac1-7911-46df-8f4f-f00eb6150034	f	f	2022-02-06 00:00:00	\N	Jäggi	Charlotte	2003	585836	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
8e389645-3f36-494b-ba07-a521b8d1b8c7	f	f	2022-02-06 00:00:00	\N	Drechsler	Julia	2007	3064125	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
4af6334b-167a-4d37-b145-87fd0426bde6	f	f	2022-02-06 00:00:00	\N	Sonderegger	Elisa	2005	860237	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
5f68ea28-7127-4240-b27e-0b15274ec1cf	f	f	2022-02-06 00:00:00	\N	König	Zoe	2004	3064836	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
4136931e-f752-4ee6-96e9-70d462756015	f	f	2022-02-06 00:00:00	\N	Cathomen	Lina	2006	909378	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
9660b37c-45c7-4e5b-850d-e04b931fbe17	f	f	2022-02-06 00:00:00	\N	Büttler	Mia	2003	875385	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
2f4b980f-0b31-492f-9b44-17d13e340f15	f	f	2022-02-06 00:00:00	\N	Graf	Lynne	2007	858354	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
37499c09-b6c5-4093-9f6a-0a5891eee754	f	f	2022-02-06 00:00:00	\N	Kamm	Jasmine	2007	853893	0	4c850776-1fc1-4201-9490-c1e848cd0f00	f
4cce7dce-f8df-41df-b83d-1364d287519e	f	f	2022-02-06 00:00:00	\N	Presente	Kevin	2008	3050078	1	a47c9fe9-9d46-47c6-8cc8-b9728464daa2	f
302f3b2b-f023-4a41-b818-58e3a765d14d	f	f	2022-02-06 00:00:00	\N	Grütter	Giosch	2014	3489570	1	97cf3158-df81-45c1-b49e-47a692438dca	f
db509a37-d829-4279-a640-6406e6db0371	f	f	2022-02-06 00:00:00	\N	Baumann	Livio	2007	913578	1	a47c9fe9-9d46-47c6-8cc8-b9728464daa2	f
396298b2-b01c-4322-a11c-f85b54470c82	f	f	2022-02-06 00:00:00	\N	Schlup	Noah	2008	832588	1	a47c9fe9-9d46-47c6-8cc8-b9728464daa2	f
a2746d6f-49c6-40ee-b2d5-dd9d7688177c	f	f	2022-02-06 00:00:00	\N	Schälchli	Henry	2014	3489564	1	97cf3158-df81-45c1-b49e-47a692438dca	f
3f36bfed-e8f6-45a8-b0e1-dca6bde66a2d	f	f	2022-02-06 00:00:00	\N	Fügli	Marlon	2013	3489568	1	97cf3158-df81-45c1-b49e-47a692438dca	f
9c18056d-a4cd-4303-ac0f-8f7c73bd4dca	f	f	2022-02-06 00:00:00	\N	Chicini	Ethan	2014	3489566	1	97cf3158-df81-45c1-b49e-47a692438dca	f
48a6fde1-a0f5-4440-a5e9-1d2962225446	f	f	2022-02-06 00:00:00	\N	Grütter	Laurin	2012	3489568	1	97cf3158-df81-45c1-b49e-47a692438dca	f
d7b4f6fc-ae1b-4ac0-9b22-14013025b255	f	f	2022-02-06 00:00:00	\N	Kamm	Cedric	2011	3399036	1	97cf3158-df81-45c1-b49e-47a692438dca	f
f416bed7-3854-4767-b63d-1c7def39fa9d	f	f	2022-02-06 00:00:00	\N	Stalder	Tobias	2007	909244	1	97cf3158-df81-45c1-b49e-47a692438dca	f
71af71e4-2389-4b16-aff3-709e7f29a947	f	f	2022-02-06 00:00:00	\N	Hort	Tobias	2012	3272719	1	97cf3158-df81-45c1-b49e-47a692438dca	f
0f7d2904-bdf5-4ad5-9c00-966cda0ef71d	f	f	2022-02-06 00:00:00	\N	Fuchs 	Fyn	2005	720278	1	97cf3158-df81-45c1-b49e-47a692438dca	f
dbdc1840-c23a-480b-8a11-64d42e58a8b2	f	f	2022-02-06 00:00:00	\N	Brunner	Thierry	1999	641152	1	97cf3158-df81-45c1-b49e-47a692438dca	f
22bb800e-a85e-4447-9e1e-a4b960bdb539	f	f	2022-02-06 00:00:00	\N	Brunner	Patrick	1995	641150	1	97cf3158-df81-45c1-b49e-47a692438dca	f
216002ea-ff29-46ea-9f31-61c0d0857b14	f	f	2022-02-06 00:00:00	\N	Spano	Elisa	2004	704244	0	a47c9fe9-9d46-47c6-8cc8-b9728464daa2	f
0caf4310-307a-426e-9f44-671ba92fd994	f	f	2022-02-06 00:00:00	\N	Bürgin	Nora	2007	941789	0	a47c9fe9-9d46-47c6-8cc8-b9728464daa2	f
7d497da0-4661-45f4-ba04-f4e67e4451aa	f	f	2022-02-06 00:00:00	\N	Keller	Magali	2006	882522	0	a47c9fe9-9d46-47c6-8cc8-b9728464daa2	f
e2ef80cc-ce59-4cfc-8e89-035f44e94aeb	f	f	2022-02-06 00:00:00	\N	Menzi	Selina	2001	3311668	0	a47c9fe9-9d46-47c6-8cc8-b9728464daa2	f
ec4fd90c-dc60-46a0-b96d-f5683dd7e3e1	f	f	2022-02-06 00:00:00	\N	Schindler	Nicki	2003	631821	1	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
1cf3987f-f6cc-49db-9c5d-ab9db5eadcf0	f	f	2022-02-06 00:00:00	\N	Heiniger	Sophie	2008	966145	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
629aaf31-432d-4ac4-a6c1-0c3d342b5543	f	f	2022-02-06 00:00:00	\N	Emini	Alina	2011	3226528	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
1df94105-d4bf-40f8-a429-a239325fa8d3	f	f	2022-02-06 00:00:00	\N	Hermann	Anja	2000	619940	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
e91242ad-85e9-4096-baa1-1adaf23543a1	f	f	2022-02-06 00:00:00	\N	Bhend	Ariane	2012	3103547	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
59c2fca2-88c2-49c8-a0e9-e7af3ff1ecfa	f	f	2022-02-07 00:00:00	\N	Spitz	Amélie	2014	3439670	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
cc13adc4-bdb6-4afe-9e2d-7405884d627b	f	f	2022-02-08 00:00:00	\N	Moryl Delort	Chiara	2009	3472952	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
f2d7bd24-578c-4c58-acc0-274800e48233	f	f	2022-02-06 00:00:00	\N	Büeler	Aurelia	2013	3396526	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
5a8a0bca-dcb9-4eec-8786-f8d52f541541	f	f	2022-02-08 00:00:00	\N	Meier	Lou	2008	3014863	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
76afa072-7cec-4906-8b4c-ded09ff90a2a	f	f	2022-02-08 00:00:00	\N	Tobler	Jana	2011	3006879	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
4931e7c7-737f-4d58-a523-2f625aca002b	f	f	2022-02-12 00:00:00	\N	Kasper	Elin	2003	582673	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
fad4171c-4b16-4139-9479-f9334e9ece6b	f	f	2022-02-08 00:00:00	\N	Schmid	Alessia	2005	896108	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
145a7105-873c-41a3-a83e-b5483de2aedc	f	f	2022-02-08 00:00:00	\N	Scriva	Francesca	2007	304925	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
a106014b-f468-4f15-99bd-20719ff73925	f	f	2022-02-08 00:00:00	\N	Matter	Irina	2005	863399	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
50302e7d-da81-40e9-9888-6ad4c36e053b	f	f	2022-02-08 00:00:00	\N	Olthof	Ruby	2006	959115	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
c9e893ba-2a06-42b3-98f7-6817c953192a	f	f	2022-02-08 00:00:00	\N	Pfaller	Lara	2004	863401	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
511211bf-522b-4cc5-a3d8-aea51b383cfb	f	f	2022-02-08 00:00:00	\N	Camenzind	Sina	2012	3383229	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
a54641dc-b451-42eb-b5c0-aba908e68127	f	f	2022-02-08 00:00:00	\N	Winkler	Leonie	2008	3058660	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
68b1e2fc-b799-4aff-9939-322b89f16232	f	f	2022-02-12 00:00:00	\N	Neukom	Svenja	2004	626249	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
f799bc5c-7670-469b-9585-5bf150bfd1ac	f	f	2022-02-09 00:00:00	\N	Nydegger	Samira	2014	3426644	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
f715ffa9-6a2a-4eea-b5f4-254b3c200e11	f	f	2022-02-09 00:00:00	\N	Bucher	Enja	2013	3333337	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
2b37ad9f-20c6-4140-b9cb-70f7d697e064	f	f	2022-02-12 00:00:00	\N	Venica	Giulia	2005	912519	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
6d744ad4-680f-4d14-b3e5-0b82885ff15f	f	f	2022-02-09 00:00:00	\N	Lisibach	Brea	2011	3240669	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
88f89f31-9cf3-49d9-8b05-1156200bd4cd	f	f	2022-02-09 00:00:00	\N	Oberbeck	Sandrine	2007	3046139	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
5160cd8b-755e-4148-b4aa-8a0be24f1a24	f	f	2022-02-12 00:00:00	\N	Christen	Melanie	2012	3180732	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
a65f24a9-63a6-4a05-ab77-b9e43d6d3083	f	f	2022-02-09 00:00:00	\N	Stutz	Soraya	2005	893121	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
575ab127-cb82-40c1-8c52-6ca88e579c52	f	f	2022-02-12 00:00:00	\N	Braun	Jana	2013	3415467	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
498e0556-c0ab-4182-ad84-760f8a03e926	f	f	2022-02-09 00:00:00	\N	Collenberg	Iida	2014	3381607	0	0f604f34-370f-4593-8173-cd24234cff78	f
a375381b-fa1b-4cad-b813-8b0cb1a49192	f	f	2022-02-09 00:00:00	\N	Bachmann	Alicia	2013	3214543	0	0f604f34-370f-4593-8173-cd24234cff78	f
c833131a-b95d-4597-96ac-8d60b3763aa7	f	f	2022-02-12 00:00:00	\N	Meli	Tanja	2002	620014	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
43e91170-02ca-4554-a0c7-d4acda61f644	f	f	2022-02-09 00:00:00	\N	Alhamadani	Lana	2009	3381609	0	0f604f34-370f-4593-8173-cd24234cff78	f
48b04d65-471d-48bd-9975-9bcc96c323c9	f	f	2022-02-12 00:00:00	\N	Frei	Magalie	2014	\N	0	e2438143-6017-4683-a533-6113748d4117	f
6a8764e7-5bc3-4daa-ab90-c47eeb7c4d7f	f	f	2022-02-09 00:00:00	\N	Rüegg	Janina	2012	3280365	0	0f604f34-370f-4593-8173-cd24234cff78	f
2df1b468-d92c-428b-8535-ff5222abfd01	f	f	2022-02-09 00:00:00	\N	Bunge	Carmen	2010	3482813	0	0f604f34-370f-4593-8173-cd24234cff78	f
9cf5cf03-87df-4421-a9b5-7b1eedb3bef1	f	f	2022-02-09 00:00:00	\N	Zumbühl	Nicoletta	2011	3198000	0	0f604f34-370f-4593-8173-cd24234cff78	f
0baf392c-69a4-4ef9-b5ec-a98c8c13b55e	f	f	2022-02-09 00:00:00	\N	Näf	Pascale	2009	3381616	0	0f604f34-370f-4593-8173-cd24234cff78	f
14a46695-e8de-4479-bf94-ab902d9dd17b	f	f	2022-02-09 00:00:00	\N	Hunziker	Sarina	2011	3077007	0	0f604f34-370f-4593-8173-cd24234cff78	f
af4daa16-8933-4a4e-b858-fb98e95b1150	f	f	2022-02-09 00:00:00	\N	Hunziker	Annika	2009	3028709	0	0f604f34-370f-4593-8173-cd24234cff78	f
35df4fd5-9fce-4557-8591-157234e6a0db	f	f	2022-02-12 00:00:00	\N	Rudolph	Chiara	2013	\N	0	e2438143-6017-4683-a533-6113748d4117	f
cc913582-3cc2-4563-98f1-af9738ac3e1d	f	f	2022-02-12 00:00:00	\N	Keller	Shania	2008	964576	0	e2438143-6017-4683-a533-6113748d4117	f
69bedece-f464-42f8-aa51-7d65b6fc5114	f	f	2022-02-12 00:00:00	\N	Roth	Nora	2010	3108554	0	e2438143-6017-4683-a533-6113748d4117	f
ee997d20-cbf8-4e4a-8f30-ff227b885e0c	f	f	2022-02-12 00:00:00	\N	Maurer	Nicole	2011	3197963	0	e2438143-6017-4683-a533-6113748d4117	f
2e0694e4-580b-4692-b201-5ad5f5de6baa	f	f	2022-02-09 00:00:00	\N	Kienast	Malin	2009	3097827	0	0f604f34-370f-4593-8173-cd24234cff78	f
191aff52-3772-4c34-a749-03b536136330	f	f	2022-02-09 00:00:00	\N	Ruckstuhl	Gabriela	2099	646527	0	0f604f34-370f-4593-8173-cd24234cff78	f
f22125af-64dd-4c86-acd5-a5145dbf656a	f	f	2022-02-12 00:00:00	\N	Vogel	Ramona	2014	3502466	0	e2438143-6017-4683-a533-6113748d4117	f
70c0d37a-52fe-459d-9ba9-0762869ec297	f	f	2022-02-13 00:00:00	\N	Stössel	Leonie	2009	3268776	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
46c33a8f-7ce0-4a3d-81ff-a90074dcc4b2	f	f	2022-02-09 00:00:00	\N	Zaccagnino	Sofia	2013	3485797	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
6b0a59f9-a8fc-44ff-9355-52747cbf1570	f	f	2022-02-09 00:00:00	\N	Fuchs	Emilia	2013	3440336	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
be4e10de-77e4-406e-8b91-a83fbc783ecd	f	f	2022-02-09 00:00:00	\N	Diggelmann	Lais	2011	3499757	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
a82fb749-a3a3-4222-8d60-f6a16ba79290	f	f	2022-02-09 00:00:00	\N	Kaufmann	Lina	2011	3358884	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
66edb884-d7b4-4e91-889d-c0fb53f5e3bd	f	f	2022-02-13 00:00:00	\N	Eggenschwiler	Amely	2010	3049121	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
11cd1202-ca0b-4b2e-a05c-081cf91769af	f	f	2022-02-09 00:00:00	\N	Motta	Alyssa	2012	3474194	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
816e65e0-0c76-4cfb-a2a6-b37232b4f7e3	f	f	2022-02-09 00:00:00	\N	Putyra	Zuzanna	2014	\N	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
5f53d428-d811-42bf-a564-d109b96f74ea	f	f	2022-02-09 00:00:00	\N	Brem	Selina	2011	3279170	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
5f062d48-528b-4532-9a62-da45d6fe9bc2	f	f	2022-02-13 00:00:00	\N	Schaffitel	Luana	2013	3140704	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
78c5f925-079f-4e02-902f-bbd580f2dd1d	f	f	2022-02-09 00:00:00	\N	Schmalz	Ayleen	2008	963546	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
f4c5cc8c-b891-4b93-b6f3-9456eb4cf1bd	f	f	2022-02-13 00:00:00	\N	Thöne	Linda	2007	838471	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
dedf07ba-48e9-4b60-815a-a4b544ed7d2e	f	f	2022-02-09 00:00:00	\N	Tüscher	Lena	2006	963558	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
3737f7df-faae-4aa9-8797-2c0f906f34f1	f	f	2022-02-10 00:00:00	\N	Stalder	Elin	2010	3351623	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
c9d881b9-c367-48ee-832e-c827d79b4ab4	f	f	2022-02-11 00:00:00	\N	Nunan	Adelaine	2015	\N	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
b9e67fa0-6e6b-488d-9700-7c09db0c7f00	f	f	2022-02-14 00:00:00	\N	Kaiser	Marlene	2013	3434938	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
9b4fbc30-a935-4da7-8370-505f032abe04	f	f	2022-02-14 00:00:00	\N	Odermatt	Méline	2005	832290	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
3b9ad9f0-4857-4d42-b3c8-fd2892aca400	f	f	2022-02-14 00:00:00	\N	Berger	Dana	2009	3279172	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
53f9eaab-dda1-46a3-879e-262f0faf794f	f	f	2022-02-14 00:00:00	\N	Märki	Jessica	2009	3089185	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
f8d1fb04-480a-4f59-bc9c-34ec9006e93c	f	f	2022-02-14 00:00:00	\N	McLeod	Kirra	2010	3059062	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
4df2f22c-42b5-4b99-b474-7a84902b1d3d	f	f	2022-02-14 00:00:00	\N	Oreccio	Bianca	2008	3350389	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
e1a462f1-5330-406f-9728-26e08b3227f8	f	f	2022-02-14 00:00:00	\N	Hartmann	Lea	2001	3017337	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
a1e7eeae-606a-43c7-8de3-7ad2ba5b5214	f	f	2022-02-14 00:00:00	\N	Romer	Carla	2005	849841	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
218d26c4-423a-4ed5-b66a-f1cf081fd2aa	f	f	2022-02-14 00:00:00	\N	Trinkner	Alea	2006	942822	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
84865f0d-2a03-4347-ae2f-1513aca7db68	f	f	2022-02-14 00:00:00	\N	Chappuis	Noémie	2008	3039103	0	42933e50-7306-4a54-b42a-276813e8b03a	f
2d2dc0a6-3524-428c-88ea-2e391b95967f	f	f	2022-02-14 00:00:00	\N	Dürmüller	Ramona	2008	3104903	0	42933e50-7306-4a54-b42a-276813e8b03a	f
1da77c6d-b2a4-4be2-b369-7294eb94f01f	f	f	2022-02-14 00:00:00	\N	Gjura	Anisa	2014	3514247	0	42933e50-7306-4a54-b42a-276813e8b03a	f
f0d5dc56-4663-4f1f-b2c0-29fb09a52493	f	f	2022-02-14 00:00:00	\N	Jung	Elea	2011	3227636	0	42933e50-7306-4a54-b42a-276813e8b03a	f
1bf2c4fa-42da-4072-8f5d-3e880b3d169c	f	f	2022-02-14 00:00:00	\N	Rechsteiner	Lara	2003	920772	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
df3501e6-5b5a-480b-b598-b656d951bfcf	f	f	2022-02-06 00:00:00	\N	von Boddien	Benita	2009	3054796	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
e9a2bba1-2e3e-45bc-91bd-a6cb4f780516	f	f	2022-02-08 00:00:00	\N	Meier	Ava	2010	3014887	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
6977d335-b759-4911-95ff-26a2a3a0853b	f	f	2022-02-12 00:00:00	\N	Bänninger	Amea	2011	3070942	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
95ea7cde-1201-43f9-98ee-225176ad5aed	f	f	2022-02-08 00:00:00	\N	Goldammer	Marie	2010	3141551	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
0da10916-38bf-4e77-8642-6c6b142cf6fa	f	f	2022-02-08 00:00:00	\N	Essig	Malea	2013	3469650	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
4697faaa-5bc2-4e09-aa2c-a0b78cae045c	f	f	2022-02-08 00:00:00	\N	Hug	Elin	2011	3388075	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
56f7e538-74f0-4790-bb00-32932649a286	f	f	2022-02-09 00:00:00	\N	Freimann	Cloe	2014	3512167	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
2a6f9197-e7e3-4d14-a82d-ca7ae7e36743	f	f	2022-02-12 00:00:00	\N	Frauenfelder	Lia	2011	3281674	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
df1211c9-9fc3-48c7-a78f-a8847890b43a	f	f	2022-02-09 00:00:00	\N	Neela	Rolli	2013	3512179	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
02757861-08c6-4f8d-bac4-37786e2afee5	f	f	2022-02-09 00:00:00	\N	Nydegger	Anja	2012	3426642	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
faa5d672-c6dd-43b0-9e67-d216a6b0112f	f	f	2022-02-12 00:00:00	\N	Reolon	Selma	2011	3481660	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
af527263-42fd-4900-9505-f43fe1dde4a6	f	f	2022-02-09 00:00:00	\N	Enzler	Suani	2014	3426648	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
3f07567b-ca02-42f6-9835-2b4a52a4dd81	f	f	2022-02-09 00:00:00	\N	Birrer	Valerie	2007	3013301	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
a7671c51-9970-495c-a2d7-f23c5cef5c42	f	f	2022-02-12 00:00:00	\N	Wenger	Tamina	1999	620064	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
b959f2f1-f0b6-48b2-aeaa-b8178c506214	f	f	2022-02-09 00:00:00	\N	Grob	Dahlia	2004	988080	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
ecc7ee7a-df9d-44bb-9379-7f4e927d9835	f	f	2022-02-12 00:00:00	\N	Bötschi	Mila	2016	\N	0	e2438143-6017-4683-a533-6113748d4117	f
8abdc7e1-6da1-4b19-aa85-3dda0e478d58	f	f	2022-02-09 00:00:00	\N	Despont	Denise	2003	893132	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
46a5d751-8412-4cc0-b2ab-e669b2f62bba	f	f	2022-02-09 00:00:00	\N	Baumann	Amélie	2011	3180507	0	0f604f34-370f-4593-8173-cd24234cff78	f
fc4757fb-dba2-4c57-b3b7-b4dd3aced628	f	f	2022-02-09 00:00:00	\N	Dall'O	Aline	2008	3077006	0	0f604f34-370f-4593-8173-cd24234cff78	f
b6a049a3-2b7c-4fa6-b4ef-9c3bd65d2b8b	f	f	2022-02-09 00:00:00	\N	Kienast	Rebecca	2009	3114966	0	0f604f34-370f-4593-8173-cd24234cff78	f
362e2fb2-b855-4847-9027-d486924b1931	f	f	2022-02-09 00:00:00	\N	Erb	Marisa	2003	669859	0	0f604f34-370f-4593-8173-cd24234cff78	f
984056b2-958c-4d85-9179-6b926177eae7	f	f	2022-02-12 00:00:00	\N	Vetterli	Anika	2015	\N	0	e2438143-6017-4683-a533-6113748d4117	f
a5d71c7d-045d-4289-899d-cb32155b1f7d	f	f	2022-02-12 00:00:00	\N	Lüscher	Sina	2010	3148554	0	e2438143-6017-4683-a533-6113748d4117	f
89866ee8-71da-4414-8002-dfdeb9b1e4a8	f	f	2022-02-12 00:00:00	\N	Schär	Romina	2011	3108555	0	e2438143-6017-4683-a533-6113748d4117	f
db3ef6ba-db1f-42ba-8be6-7a34f4a40a02	f	f	2022-02-13 00:00:00	\N	Settelen	Lily-Anna	2008	3014155	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
336dde87-5b6a-41df-a521-74567452a82a	f	f	2022-02-09 00:00:00	\N	Muntwyler	Mia	2010	3358878	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
8b6df291-23fe-4ee0-bec8-42401c7efad9	f	f	2022-02-09 00:00:00	\N	Soares	Eva	2011	3358872	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
d80b2f02-058c-46f2-b545-604f7ba64506	f	f	2022-02-09 00:00:00	\N	Franz	Lara	2012	3261553	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
bb78620a-ca2c-4cae-85da-3bc695a10e0c	f	f	2022-02-09 00:00:00	\N	Elcarpar	Olivia	2009	3261549	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
f43725b3-cb38-4c05-a536-901f069f3a66	f	f	2022-02-09 00:00:00	\N	Germann	Vanessa	2011	3261545	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
229aff2f-1193-449f-bc77-7ce5e1b3515a	f	f	2022-02-13 00:00:00	\N	Frey	Valeria	2011	3095043	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
0199cf95-40f2-4ea5-b4d3-27a08184f4d7	f	f	2022-02-09 00:00:00	\N	Romer	Alia	2013	3474198	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
22c44a92-0118-4408-b4a7-70eadb2b626d	f	f	2022-02-09 00:00:00	\N	Zacheo	Aurora	2013	\N	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
5296801b-1130-40d0-b370-39250adbb5b4	f	f	2022-02-13 00:00:00	\N	Grüneberg	Emily	2007	3042433	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
9af601a8-ce5d-4636-9927-bac6db01a068	f	f	2022-02-09 00:00:00	\N	Burri	Maja	2011	3343056	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
ec3bf925-a3cc-4d8f-bf48-5b2f0dcf0865	f	f	2022-02-09 00:00:00	\N	Hintermann	Jil	2006	999162	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
a2040de4-3233-4eaf-8bdd-62cc5c588fcc	f	f	2022-02-13 00:00:00	\N	Schmid	Nora	2014	3137160	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
bc9ac325-760b-46f8-a618-fa8e9d479491	f	f	2022-02-09 00:00:00	\N	Righetti	Cinzia	2003	690908	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
ba6702bf-fb31-4d63-85c4-87d1844df49d	f	f	2022-02-09 00:00:00	\N	Streiff	Yara	2005	914307	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
733fd6c1-6d74-4c8a-92e0-eb7b8616fb53	f	f	2022-02-14 00:00:00	\N	Spielmann	Sarah	2013	3332655	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
b82921da-9814-487b-9ceb-c7fbee2bcd4a	f	f	2022-02-10 00:00:00	\N	Lingenhag	Andrea	1979	3355766	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
dbeccae4-484a-48dd-9a20-4176dad974bb	f	f	2022-02-11 00:00:00	\N	Hersche	Soé	2010	3014880	0	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
2ad972e6-5f71-4889-88e6-1b159d394540	f	f	2022-02-14 00:00:00	\N	Chiabotti	Vera	2013	3350371	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
9a88ca4b-fd7d-4b5d-ae9e-6ea7a5057a72	f	f	2022-02-14 00:00:00	\N	Ihmor Bullon	Brisa Tais	2012	3346418	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
2da35814-095b-4e74-97b1-b188de8fa1a3	f	f	2022-02-14 00:00:00	\N	Rudin	Mina Luisa	2013	3099309	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
2147bb17-f1c7-4cc8-86a9-e7a5b55bd09a	f	f	2022-02-14 00:00:00	\N	Radecke	Jael	2013	3562110	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
5bf0671b-b72d-461a-9be2-a04844344f8e	f	f	2022-02-14 00:00:00	\N	Märki	Céline	2006	942802	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
6b995fe5-cce8-4fdb-b503-9b98de3011df	f	f	2022-02-14 00:00:00	\N	Tanner	Ayana	2005	903048	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
f9babbe8-296f-4769-b8cc-bd05f1e44629	f	f	2022-02-14 00:00:00	\N	Kober	Alessia	1995	664697	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
501b5ce7-844c-4731-b8a4-9ade671616f8	f	f	2022-02-14 00:00:00	\N	Heidelberger	Rina	2009	3100231	0	42933e50-7306-4a54-b42a-276813e8b03a	f
51527a9d-87a4-4a67-8ecd-2d0dc9359a9d	f	f	2022-02-14 00:00:00	\N	Egger	Malea	2012	3197758	0	42933e50-7306-4a54-b42a-276813e8b03a	f
7b529414-1739-40e9-b54b-d702d6e6a585	f	f	2022-02-14 00:00:00	\N	Egger	Raina	2008	3104901	0	42933e50-7306-4a54-b42a-276813e8b03a	f
396e3836-ec41-4749-9e4c-f1d9d427234b	f	f	2022-02-14 00:00:00	\N	Muratovic	Lejla	2012	3243723	0	42933e50-7306-4a54-b42a-276813e8b03a	f
9fda6d76-73da-4f37-9855-5ababdfd8bb0	f	f	2022-02-14 00:00:00	\N	Wachter	Tamara	2010	3112787	0	42933e50-7306-4a54-b42a-276813e8b03a	f
f94b2325-95b4-4161-8c58-ff8503f29809	f	f	2022-02-14 00:00:00	\N	Reinstadler	Laura	2014	3514222	0	42933e50-7306-4a54-b42a-276813e8b03a	f
34a05f66-e24a-4ab2-a4a5-0b06670599c5	f	f	2022-02-14 00:00:00	\N	Torma	Livia	2014	3514249	0	42933e50-7306-4a54-b42a-276813e8b03a	f
15408319-a0f2-4b30-bdaf-2de2d07bb731	f	f	2022-02-14 00:00:00	\N	Zollinger	Ivana	2003	651232	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
d16e18b7-e9c7-4d0e-8f71-73220c7f7dc9	f	f	2022-02-14 00:00:00	\N	Burgat	Marie	2014	3384417	0	688a34cb-72f2-4920-aeb3-89325956de26	f
1e906a1f-dde2-425a-9823-5a1a875edf7b	f	f	2022-02-14 00:00:00	\N	Berliat	Jael	2013	3141372	0	688a34cb-72f2-4920-aeb3-89325956de26	f
af66922d-dc0b-4a1b-b91b-31e7009aef4a	f	f	2022-02-14 00:00:00	\N	Kull	Chloé	2009	3102493	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
7de2e045-f7ff-4636-b005-f374de49838f	f	f	2022-02-06 00:00:00	\N	Graf	Cheyenne	2013	3439541	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
5cd71bb1-2c02-45a6-928a-91d41774231a	f	f	2022-02-06 00:00:00	\N	Meier	Fabienne	2005	834275	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
601cea8b-2321-4666-9409-6d910b843cc8	f	f	2022-02-06 00:00:00	\N	Graber	Joy	2001	619855	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
95ed01ae-10f2-4b6c-8ccf-7c211815a956	f	f	2022-02-06 00:00:00	\N	Böllenrücher	Julie	2011	3439522	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
f259343a-0c09-483d-b3c7-7c5b0395618b	f	f	2022-02-08 00:00:00	\N	Toussaint	Liona	2011	3383271	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
5850c6e0-ec0a-4631-a324-b5ec98cfffa7	f	f	2022-02-06 00:00:00	\N	Eigenmann	Ladina	2011	3226530	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
fad2955f-46c3-4f55-ac54-5d87b3f91f06	f	f	2022-02-06 00:00:00	\N	Ademi	Lena	2011	3226526	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
9403ffe9-b27e-42eb-83ce-8301955e1e52	f	f	2022-02-06 00:00:00	\N	Hanselmann	Lenja	2011	3226532	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
a2ab38ab-0c73-42db-bfd4-6758e3be9505	f	f	2022-02-06 00:00:00	\N	Meier	Linda	2010	3081143	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
60f70e2e-6978-4e6b-b95b-7b56f4cf94cf	f	f	2022-02-06 00:00:00	\N	Oberfranz	Marlene	2010	3095869	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
f4f15fb5-372f-4f19-b473-bd42f628b0b1	f	f	2022-02-06 00:00:00	\N	Tüfekci	Melisa	2013	3496458	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
bcaad1d0-181a-4d1d-8e70-eaba23f8a120	f	f	2022-02-06 00:00:00	\N	Weiss	Meret	2007	966146	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
fc64e539-6ca6-4782-99a6-9b6294d8ba9f	f	f	2022-02-06 00:00:00	\N	Schmid	Naomi	2003	3010388	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
3b52d222-eb36-45b2-8aa4-d751b2867483	f	f	2022-02-06 00:00:00	\N	Herzig	Ronja	2003	966150	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
eefbb597-5d31-46c0-8410-4298f308e081	f	f	2022-02-06 00:00:00	\N	Beutler	Sanne-Lisa	2009	3095861	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
fe5928f5-b863-4e8a-b170-de189592be4a	f	f	2022-02-06 00:00:00	\N	Greuter	Sarina	2011	3128626	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
6c68c776-7076-4db3-b8f5-572eb6fd81ba	f	f	2022-02-06 00:00:00	\N	Köchli	Sarina	2011	3137918	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
4a26fee1-2e72-4c02-a2da-a48208956430	f	f	2022-02-06 00:00:00	\N	Gonnet	Lisa Lotta	2013	3366831	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
69630e2c-e72c-4954-98aa-25cf15e2ae37	f	f	2022-02-06 00:00:00	\N	Tüfekci	Selin	2011	3496456	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
3124b8d3-ade4-40b3-8a5d-7cf85cb837cc	f	f	2022-02-06 00:00:00	\N	Bollinger	Sini	2008	3067971	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
3a391648-4655-45a0-a4ca-b5c46395833e	f	f	2022-02-06 00:00:00	\N	Pfister	Svenja	2010	3137919	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
bac724ef-d37a-4e35-8e10-bac91f44434f	f	f	2022-02-06 00:00:00	\N	Meier	Yasmine	2007	966144	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
5c86765e-a768-45ea-b859-c95bab72c88d	f	f	2022-02-06 00:00:00	\N	Greuter	Sindri	2008	958969	1	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
762454e5-c01f-4320-b36f-b62d5a1d25ce	f	f	2022-02-06 00:00:00	\N	Greuter	Teijo	2007	902076	1	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
d927b569-8246-4cb6-aa6e-4c54ca3f7aff	f	f	2022-02-07 00:00:00	\N	Fux	Benjamin	2012	3479398	1	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
0854718f-c29f-415e-83dd-56397cd430ce	f	f	2022-02-07 00:00:00	\N	Fux	Tobias	2013	3479402	1	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
bae3a9db-b953-4384-9967-b6a695a40b35	f	f	2022-02-07 00:00:00	\N	Lanz	Anja	2000	724277	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
60e7088d-9afe-437c-990d-73bfd9ba2ecd	f	f	2022-02-07 00:00:00	\N	Welti	Sanna	2014	3535324	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
0ca06129-a9e4-44da-b066-b524c8b12fbd	f	f	2022-02-07 00:00:00	\N	Schmied	Mira	2014	3553048	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
408133b2-4da0-4b73-8501-1fb5b1022518	f	f	2022-02-07 00:00:00	\N	Sengstag	Solène	2013	3436639	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
fe97a510-36b1-4a5d-baf8-2990bc46b6c0	f	f	2022-02-07 00:00:00	\N	Schicker 	Binja	2013	3343923	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
9f019d48-0aaa-463f-a64d-75d6c2862e1c	f	f	2022-02-07 00:00:00	\N	Glauser	Larina	2014	3553048	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
1a6d1157-b4bc-48a4-a145-348e39ce7a83	f	f	2022-02-07 00:00:00	\N	Meier 	Leonie	2013	3343930	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
d59f58c9-abd6-4ef4-9d90-6b0f59be660b	f	f	2022-02-07 00:00:00	\N	Dietz	Léanne	2010	3158273	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
41f510b9-0caa-4e56-b98d-d1a56663576c	f	f	2022-02-07 00:00:00	\N	Wild 	Yara	2009	3090983	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
e8598f8f-a3b0-459a-ba77-1b4266769ef6	f	f	2022-02-07 00:00:00	\N	Délitroz	Lilou	2012	3280363	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
e63e5adb-ca59-406f-9cd6-88f18f2c6a59	f	f	2022-02-07 00:00:00	\N	Bachmann	Noee	2010	3152325	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
82f13411-54a6-4504-bbbb-a706199d08c1	f	f	2022-02-07 00:00:00	\N	Durrer	Catrina	2010	3108208	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
d1109f3f-4e2f-47c0-a4f0-236f94cf79f1	f	f	2022-02-07 00:00:00	\N	Bumann	Lorena	2009	3108211	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
c2c819ae-2b2b-4e74-a660-c195ed605462	f	f	2022-02-07 00:00:00	\N	Rüegg	Kim	2010	3280361	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
926b606f-e318-43ad-a853-25bb243a12da	f	f	2022-02-07 00:00:00	\N	Walder	Livia	2008	3024918	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
65defd6a-70b4-4777-b527-3aa4e941d7f3	f	f	2022-02-07 00:00:00	\N	Bachmann	Leana	2008	3059586	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
91e7b868-0592-41ca-ae34-deb04382d5a4	f	f	2022-02-07 00:00:00	\N	Soriano	Amber	2009	3090978	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
d0145586-7803-4c27-aa73-e93e6b6f088f	f	f	2022-02-07 00:00:00	\N	Schmid	Lina	2010	3108218	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
570eb7dd-9e21-49fc-b120-1d28af720b1b	f	f	2022-02-07 00:00:00	\N	Sunier	Elin	2009	3038221	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
60cc1f98-66f1-4276-9b86-909635e50da9	f	f	2022-02-07 00:00:00	\N	Clauss	Hannah	2005	835087	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
559848ae-1d2c-4c52-bd0a-8cc8e997b4ad	f	f	2022-02-07 00:00:00	\N	Schuler	Livia	2003	693198	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
a7a1b9da-83a5-4c35-93c9-4dd2c3b4c213	f	f	2022-02-07 00:00:00	\N	Pettermand	Sinja	2006	934127	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
8e55fb70-64b6-4821-866c-196bd9b9620e	f	f	2022-02-07 00:00:00	\N	Schnyder 	Gianna	2007	965781	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
7125f643-a7ee-44e5-8019-6bab5ff00941	f	f	2022-02-07 00:00:00	\N	Weingart	Lindsey	2013	3553055	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
1b551c76-9304-4df8-8958-759b76f694ac	f	f	2022-02-07 00:00:00	\N	Cristini	Salome	2007	965891	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
25760240-0ed1-4364-9e21-1e4372c89a54	f	f	2022-02-07 00:00:00	\N	Schwyter	Nicolas	2004	644354	1	97cf3158-df81-45c1-b49e-47a692438dca	f
23e029ae-c87e-42c5-a094-49d7044012bb	f	f	2022-02-07 00:00:00	\N	Frieden	Ladina	2015	3439537	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
cdbfd901-1a61-40a8-9942-11db49f742db	f	f	2022-02-07 00:00:00	\N	Heusser	Elea	2015	3524501	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
4a9134cd-58b9-4afe-9226-f6e02009054a	f	f	2022-02-07 00:00:00	\N	Bär	Madlaina	2015	3524498	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
17ca6bc9-f89b-4c5c-8429-b4ab7d7374c8	f	f	2022-02-07 00:00:00	\N	Gross	Mona	2014	3486151	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
bea146f0-eb58-4986-ba4d-32459162ad63	f	f	2022-02-07 00:00:00	\N	Kirchhofer 	Sara	2015	3439640	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
0349417e-046b-4721-b8a9-cb9bcbce7a81	f	f	2022-02-07 00:00:00	\N	Linder	Melina	2014	3345189	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
c8fb410a-e5ca-4f2a-b755-aa4d995545bb	f	f	2022-02-07 00:00:00	\N	Keller	Tracy	2012	3060991	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
3e64f178-827a-4e4c-8e00-b77622444ead	f	f	2022-02-07 00:00:00	\N	Zgraggen	Selen	2011	3524509	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
edc320f3-afba-4898-9258-b56f2cc6f550	f	f	2022-02-07 00:00:00	\N	Graf	Victoria	2015	3345167	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
a13a0f23-b879-4676-a29c-0dbc27f17091	f	f	2022-02-07 00:00:00	\N	Maier	Josephine	2015	3439650	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
2c0cd97b-3ac2-40df-9cd8-9774e1391d70	f	f	2022-02-07 00:00:00	\N	Bächli	Jonas	2014	3229318	1	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
57643c03-4f39-4b9c-8cfc-219b1079e7a2	f	f	2022-02-07 00:00:00	\N	Köpfer	Julian	2014	3524505	1	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
5d55fb78-0714-4db0-a257-13a8d36ad255	f	f	2022-02-08 00:00:00	\N	Mante	Adrienne	2012	3388710	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
2d6d06b6-34a8-4715-bee2-1494b58208af	f	f	2022-02-07 00:00:00	\N	Fiocchi	Chayenne	2009	3108224	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
0e1aabcc-4b60-4f73-a4ed-f2e2575187e6	f	f	2022-02-08 00:00:00	\N	Kobler	Jessica	2012	3403518	0	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
a2d598f4-edad-4d89-aaad-21f28e2a5f4b	f	f	2022-02-07 00:00:00	\N	Züger 	Michelle	2007	3011331	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
40ccb443-9e71-4f3c-937d-eb6d1d336e26	f	f	2022-02-08 00:00:00	\N	Kessler	Isabel	2013	3448470	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
301d5f40-82df-4dad-8a88-7255e5d3d6ae	f	f	2022-02-08 00:00:00	\N	Ineichen	Malia	2012	3383258	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
e9f38374-85c7-4711-b28a-6939bba04433	f	f	2022-02-09 00:00:00	\N	Müller	Ronja	2014	3512169	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
e4dad8c7-714b-4bca-b473-799a067031b2	f	f	2022-02-09 00:00:00	\N	Jucker	Lynn	2012	3333369	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
e0175681-9347-4edc-881f-5f40ad1ab89e	f	f	2022-02-09 00:00:00	\N	Artho	Samira	2012	3240613	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
aba788b3-5a3d-4156-9c7b-70925836daed	f	f	2022-02-09 00:00:00	\N	Artho	Alicia	2006	955816	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
59b79a17-b50d-4e34-aef1-7856d3a110c8	f	f	2022-02-12 00:00:00	\N	Gmür	Aline	2004	856900	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
cbfb4fdd-147a-4c57-a163-fafb5ae24939	f	f	2022-02-12 00:00:00	\N	Altorfer	Lea	2005	908701	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
216f5fda-c407-43cc-a656-8a2a5c4f6094	f	f	2022-02-12 00:00:00	\N	Girschweiler	Nuria	2010	3103834	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
0021e65a-9804-4f1d-baa0-f5b9b3a6e74a	f	f	2022-02-09 00:00:00	\N	Barwisch	Jael	2010	3140888	0	0f604f34-370f-4593-8173-cd24234cff78	f
9cb726ae-bffe-4525-a99a-36bccb678572	f	f	2022-02-09 00:00:00	\N	Baumann	Annika	2010	3077005	0	0f604f34-370f-4593-8173-cd24234cff78	f
69a35b84-983a-4d7d-a8d8-13ecabf87b02	f	f	2022-02-12 00:00:00	\N	Oertle	Nadine	2002	659885	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
fd157308-f07e-406c-b230-efcb274a0ebd	f	f	2022-02-12 00:00:00	\N	Limburg	Silvia	2003	694795	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
ce31658a-2589-493f-8273-f2d530cb8fe0	f	f	2022-02-12 00:00:00	\N	Mendes	Melanie	2010	3104591	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
be976a99-c795-4d35-a2d5-0ba7b80684be	f	f	2022-02-12 00:00:00	\N	Jörger	Ella	2012	3266365	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
d8b0f2f3-a349-4fbe-bf4c-30d4d216cf0d	f	f	2022-02-12 00:00:00	\N	Leuenberger	Nadja	2008	3057634	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
2b3839f2-2c30-429e-af91-a44e4b062ffe	f	f	2022-02-12 00:00:00	\N	Gnädinger	Enya	2016	3488284	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
80a78f58-b3d6-42fe-8ee4-749bd5100573	f	f	2022-02-09 00:00:00	\N	Müller	Flavia	2011	3261555	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
2ac403d7-94ea-43e7-89bf-c08928b4926f	f	f	2022-02-09 00:00:00	\N	Rosenthaler	Zoë	2008	3054554	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
14ab2d8e-9f84-423a-ad22-bff072d3905d	f	f	2022-02-12 00:00:00	\N	Graf	Selina	2015	3542562	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
9f1c043f-6208-4a02-b32a-d0ca0859b1ac	f	f	2022-02-09 00:00:00	\N	Steinmann	Valeria	2014	\N	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
3992d366-b49a-4ff4-894a-403791df4cc5	f	f	2022-02-09 00:00:00	\N	Steinmann	Lucy	2012	3474202	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
249bec16-ff0a-4c64-865b-9bf3bb9b5d4b	f	f	2022-02-12 00:00:00	\N	Gross	Celina	2008	3007819	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
e060f3ea-8450-4bd8-af10-37b2db1570c6	f	f	2022-02-09 00:00:00	\N	Storz	Samira	2014	\N	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
d73b30fe-8026-4f08-b384-58e7a59e03b7	f	f	2022-02-12 00:00:00	\N	Gujer	Amélie	2012	3281697	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
a0c32142-d7b1-491c-9f65-1e72c6e4c1b3	f	f	2022-02-09 00:00:00	\N	Lodato	Lea	2011	3343060	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
a9708c95-0b25-4e8f-b279-e10f7bc71636	f	f	2022-02-12 00:00:00	\N	Hauser	Simea	2014	3494888	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
42bae48a-3ce8-4214-8e26-7748a70b9f06	f	f	2022-02-09 00:00:00	\N	Marsura	Chiara	2011	3279199	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
36bd4fb3-8a50-4fe9-83cd-d35c0fa69515	f	f	2022-02-10 00:00:00	\N	Ambrosio	Giada	2012	3209395	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
aeb97e02-734a-453d-8656-6f30fc81e12a	f	f	2022-02-12 00:00:00	\N	Brotzer	Eline	2011	3191375	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
01cff387-1e90-4441-b813-1a7402afcdb0	f	f	2022-02-10 00:00:00	\N	Aysheshim	Liya	2009	3235050	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
cb338f4f-23d7-4970-993b-aef8e8b8bdbb	f	f	2022-02-10 00:00:00	\N	Baldassar	Siana	2013	3365267	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
d615fce7-57d4-4450-a43c-5917a973f2d4	f	f	2022-02-12 00:00:00	\N	Giger	Sina	1999	620044	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
068175b5-8305-4c61-8d62-4d7fd41236d3	f	f	2022-02-10 00:00:00	\N	Berber	Nisa	2011	3365269	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
30198e78-e28d-41e6-afd3-8432d259b803	f	f	2022-02-10 00:00:00	\N	Bulatovic	Nea	2011	3365271	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
c6a8e41b-9da6-49af-afd0-54b3ea9c28ff	f	f	2022-02-10 00:00:00	\N	Jäger	Olivia	2014	3365691	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
535efc10-af68-4510-ad59-2766119e3e65	f	f	2022-02-12 00:00:00	\N	Strasser	Sina	2014	\N	0	e2438143-6017-4683-a533-6113748d4117	f
afbdaec8-eb62-421c-ba81-e924ec18b04d	f	f	2022-02-13 00:00:00	\N	Duss	Nathalia	2004	911616	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
9be2dbb4-7670-4c7a-a8ce-c1a03e6e904c	f	f	2022-02-13 00:00:00	\N	Grüneberg	Rebecca	2009	3087813	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
8174f79b-8a2a-48c5-b88e-aefb4bbdfae7	f	f	2022-02-13 00:00:00	\N	Tratar	Nerea	2007	987503	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
9040fb01-f219-4dd9-b54e-2fc02ece5aa7	f	f	2022-02-13 00:00:00	\N	Junger	Simone	2006	874855	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
201d3923-d7b9-4b0e-9fc7-9d1525970245	f	f	2022-02-13 00:00:00	\N	Kitanovski	Leoni	2011	3346317	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
7e39b71c-23cf-4dc2-89b7-1887d72cc3b8	f	f	2022-02-13 00:00:00	\N	Thoma	Lynn	2006	842320	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
00f85482-195f-4094-bf12-2106c49eab50	f	f	2022-02-14 00:00:00	\N	Bieri	Fiona	2013	3221357	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
091d5e4f-def6-40fb-9852-442f548f86fe	f	f	2022-02-14 00:00:00	\N	Giunchi	Zora	2013	3350373	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
257d9583-316d-43ce-a086-2e017e4751bc	f	f	2022-02-14 00:00:00	\N	Heim	Sina	2013	3184336	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
ec897b52-2315-4648-92c3-3111c5725355	f	f	2022-02-14 00:00:00	\N	von Euw	Alea	2008	3043632	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
a8b593b4-b511-4cd8-9525-61302cd859fc	f	f	2022-02-14 00:00:00	\N	Mischler	Selina	2015	3340997	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
31268dc0-7ddd-40e9-916e-cfbb6efe33de	f	f	2022-02-14 00:00:00	\N	Minder	Laurine	2007	3083101	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
fb6b8547-bea1-4899-9794-4d6ac786bab7	f	f	2022-02-14 00:00:00	\N	Schöpfer	Aline	2005	851383	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
0c3e225a-ee87-4e8e-a877-93145ba5e999	f	f	2022-02-14 00:00:00	\N	Keller	Maya	1993	704239	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
6f740e3e-dbdb-4e85-966a-bb5dd8b83fd0	f	f	2022-02-14 00:00:00	\N	Moll	Lena	2014	3339213	0	42933e50-7306-4a54-b42a-276813e8b03a	f
bb258c4e-0d29-4b50-a481-7e7cc241fdb9	f	f	2022-02-14 00:00:00	\N	Moll	Nina	2009	3011041	0	42933e50-7306-4a54-b42a-276813e8b03a	f
e3a2aa9f-8c35-4ed7-a079-e6049c53f6cb	f	f	2022-02-14 00:00:00	\N	Porta Luri	Amely	2015	3514244	0	42933e50-7306-4a54-b42a-276813e8b03a	f
77a3bee4-12e0-41ac-95e6-85fac0da56ec	f	f	2022-02-14 00:00:00	\N	Senn	Alysha	2003	3039108	0	42933e50-7306-4a54-b42a-276813e8b03a	f
c41fc079-8bca-46aa-8e75-e92d8cf93f84	f	f	2022-02-14 00:00:00	\N	Tirinzoni	Lina	2008	3109558	0	42933e50-7306-4a54-b42a-276813e8b03a	f
1cb8f581-6c81-4ee9-b47b-c89bac12c2e2	f	f	2022-02-14 00:00:00	\N	Stadler	Vanora	2013	3488319	0	688a34cb-72f2-4920-aeb3-89325956de26	f
35ed5aaa-25ab-4977-9b13-3fa6e4c9f5ec	f	f	2022-02-07 00:00:00	\N	Durrer	Adriana	2008	3038221	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
17c3f3db-7ccf-49fc-aee7-dd509d6c3cad	f	f	2022-02-14 00:00:00	\N	Egger	Talisha	2009	3104900	0	42933e50-7306-4a54-b42a-276813e8b03a	f
66293eb4-35de-4de2-a4a7-a83b6c1151d4	f	f	2022-02-08 00:00:00	\N	Pomier	Aylin	2014	3527058	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
a1a9d8d1-440c-4dca-ac15-7a072d6bb21b	f	f	2022-02-07 00:00:00	\N	Ochsner	Michèle	2004	3343932	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
802d96bc-3b72-4f17-9c41-0d9aebf1daf7	f	f	2022-02-12 00:00:00	\N	Altorfer	Annika	2007	839564	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
8cdbfd75-a49b-48f1-affe-a51c06981495	f	f	2022-02-08 00:00:00	\N	Starcevic	Julia	2015	3527068	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
c79b38bc-b783-42ae-b939-131743168a25	f	f	2022-02-12 00:00:00	\N	Huber	Sarina	2012	3266363	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
b3d038cd-f30d-40cb-8f06-0b4dc6290af6	f	f	2022-02-08 00:00:00	\N	Serafin	Emilia	2014	3129400	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
b611df06-6517-4a13-a70a-6dbe3ed8eae2	f	f	2022-02-08 00:00:00	\N	Nussbaumer	Vanessa	2015	3526262	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
e6def881-4e19-406b-8674-ffbf9f1a03dc	f	f	2022-02-08 00:00:00	\N	Kübler	Karla	2008	3058654	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
4559d80c-304a-47b8-b7bd-93e1c731fb70	f	f	2022-02-09 00:00:00	\N	Leuzinger	Emilia	2014	3512171	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
6b2ba3a4-8901-444b-8478-4893793221f3	f	f	2022-02-12 00:00:00	\N	Hiltbrunner	Seraina	2014	3542570	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
cdf0fbbf-574e-4b60-b48f-569d4f6628f0	f	f	2022-02-09 00:00:00	\N	Karakoc	Cansu	2013	3430329	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
0091ad64-77de-4e7d-858b-f1b3aa439c20	f	f	2022-02-09 00:00:00	\N	Blaser	Alexa	2001	655247	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
f2206a00-7dd9-4bdc-b0fe-de4ecee7a577	f	f	2022-02-12 00:00:00	\N	Fritschi	Lenja	2011	3297996	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
4d56147f-59e0-42a3-83f1-3e3d8b47594d	f	f	2022-02-09 00:00:00	\N	Bahloul	Aisha	2009	3028705	0	0f604f34-370f-4593-8173-cd24234cff78	f
5ed8cab4-eb0b-4522-b615-4a3154244cd6	f	f	2022-02-09 00:00:00	\N	Thum	Jil	2009	3077011	0	0f604f34-370f-4593-8173-cd24234cff78	f
52a93100-fdf0-4802-8f8b-14ff488ee048	f	f	2022-02-12 00:00:00	\N	Reiser	Elin	2012	3298006	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
0a20fa2f-3a56-45a5-8fe0-6412c826eab6	f	f	2022-02-09 00:00:00	\N	Widmer	Lisa	2009	3097828	0	0f604f34-370f-4593-8173-cd24234cff78	f
c661822f-3f9b-4644-bc3b-c786ee1aeecb	f	f	2022-02-12 00:00:00	\N	Binder	Lisa	2011	3103984	0	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	f
1984714f-3b14-4e8a-b8b8-aa60564f7618	f	f	2022-02-09 00:00:00	\N	Furter	Lynn	2005	900871	0	0f604f34-370f-4593-8173-cd24234cff78	f
66faab68-b4a5-4d15-9f33-3cec1130ed45	f	f	2022-02-09 00:00:00	\N	Rosenthaler	Jana	2010	3171189	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
05fa4b36-4e75-47db-b231-da941e301da5	f	f	2022-02-13 00:00:00	\N	Afriyie	Nanahemma	2012	3268770	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
5517aa50-4303-493f-9c22-fd23153128b4	f	f	2022-02-09 00:00:00	\N	Bieri	Milena	2012	3343054	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
a833c742-8409-4392-9cbd-3827c5b826d2	f	f	2022-02-13 00:00:00	\N	Camarillo	Isabella	2014	3340192	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
74cd19ee-bfbf-4796-8f4c-2321db746ec6	f	f	2022-02-10 00:00:00	\N	Ellermeier	Nicole	2011	3123454	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
d109d353-687f-4aef-8500-626ff2eba3f7	f	f	2022-02-10 00:00:00	\N	Healy	Enya	2011	3488371	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
d9f53238-33b5-4b14-b57a-364bff864fa9	f	f	2022-02-10 00:00:00	\N	Idrizi	Menesa	2013	3365273	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
2b9e4db8-12c5-46d8-b6f1-93f458ba7787	f	f	2022-02-13 00:00:00	\N	Cicchino	Alisea	2014	3426738	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
324aede9-ff62-4842-b7b2-ad18b7a0b544	f	f	2022-02-10 00:00:00	\N	Korda	Nancy	2006	949318	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
7348a3d9-d2f8-4966-b266-c3bdd25b540f	f	f	2022-02-13 00:00:00	\N	Ezzema	Liana	2011	3135542	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
3cc19294-8c07-4e8b-8e87-99eeb196fdef	f	f	2022-02-10 00:00:00	\N	Lingenhag	Nevia	2012	3378514	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
6300dd83-55ef-47bb-a821-291cb19cc21b	f	f	2022-02-13 00:00:00	\N	Müntener	Lara	2011	3222117	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
a32f4bd9-9849-48bd-96ca-7224bdec26db	f	f	2022-02-13 00:00:00	\N	Schack	Linn	2010	3050113	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
4040561f-f9ed-47ef-8708-7a983e4c0ff6	f	f	2022-02-10 00:00:00	\N	Nicolaus	Elina	2013	3488384	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
d1bd04b4-398d-48b5-9ec2-a6350c81e85a	f	f	2022-02-10 00:00:00	\N	Mathys	Jaelle	2015	3511333	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
d727f5fe-e7d2-4577-b489-4d354161de5e	f	f	2022-02-10 00:00:00	\N	Brey	Leonie	2014	3365675	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
a35592f4-42ba-4a9a-9975-474d5ab2ccbc	f	f	2022-02-13 00:00:00	\N	Kropf	Ladina	2003	517381	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
37cd7dbf-615b-42c0-9921-82619309eb75	f	f	2022-02-13 00:00:00	\N	Kropf	Seraina	2005	592196	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
fa8a399a-3369-4fd2-9e08-041c3a75d6c7	f	f	2022-02-13 00:00:00	\N	Thoma	Anouk	2008	890383	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
e61ff2cd-18b2-4740-970f-43aeeceb6cfa	f	f	2022-02-14 00:00:00	\N	Schlottig	Saskia	2012	3350383	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
ce06fe1b-36b4-4ee5-95fc-0e7548c4a753	f	f	2022-02-14 00:00:00	\N	von Dielingen	Emma	2013	3346444	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
9f897303-76c4-48cf-83dd-ab8c8e12ea53	f	f	2022-02-14 00:00:00	\N	Feuerlein	Alena	2007	3146124	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
2b8fbc3c-0944-41e4-bc34-f525a6a02d5a	f	f	2022-02-14 00:00:00	\N	Schlottig	Maike	2014	3523051	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
41b9e113-369d-4afb-853e-b10d2dcfd1ba	f	f	2022-02-14 00:00:00	\N	Orsatti	Tea	2013	3523059	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
6ff941e9-6b8a-4c6e-987f-2ad4ccc3f22f	f	f	2022-02-14 00:00:00	\N	Rey	Aïcha	2002	839838	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
5fe0cd48-8201-426a-802b-5710dc0faaac	f	f	2022-02-14 00:00:00	\N	Schneider	Nathalie	1991	557672	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
3e12dab2-955c-4c27-8fc9-5b24013e3333	f	f	2022-02-14 00:00:00	\N	Tirinzoni	Elin	2010	3267281	0	42933e50-7306-4a54-b42a-276813e8b03a	f
434e5d65-019d-4c6c-a886-f6431c0fb1c2	f	f	2022-02-14 00:00:00	\N	Bosshard	Selina	1999	646664	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
94884068-05ac-422c-9a1c-ab52873f43ea	f	f	2022-02-14 00:00:00	\N	Meister	Jolene	2007	962669	0	688a34cb-72f2-4920-aeb3-89325956de26	f
328524d2-a693-4bf5-ab73-f3f37046035b	f	f	2022-02-07 00:00:00	\N	Megliola 	Viviana	2007	958649	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
ab12d4b7-2e55-4d99-99cf-58d6e42ab7fb	f	f	2022-02-08 00:00:00	\N	Delort-Brazee	Freja	2013	3527040	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
c623ec2a-e96c-469a-be6c-8cfa166cfe46	f	f	2022-02-08 00:00:00	\N	Plaz	Jaël	2013	3448476	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
92f57cee-d46b-4050-ad58-23de93dec16e	f	f	2022-02-08 00:00:00	\N	Thalmann	Anja	2011	3110350	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
eb51fd48-d583-4ddd-978c-5bf071632954	f	f	2022-02-08 00:00:00	\N	Prechtl	Hanna	2006	3058658	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
54c646ec-c26f-4a44-b2b0-48dfe8a38e8d	f	f	2022-02-09 00:00:00	\N	Manes	Giulia	2012	3151189	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
7541cd2d-202f-4969-a8ab-3e7f7e14f642	f	f	2022-02-12 00:00:00	\N	Gubler	Melanie	2008	3057632	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
a4d8f446-a1dc-493e-b308-b920d966e3c3	f	f	2022-02-09 00:00:00	\N	Camenzind	Lena	2011	3240647	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
13d1f58d-ef04-44c7-bfe2-95f168e40543	f	f	2022-02-12 00:00:00	\N	Rieder	Alina	2008	3057637	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
073b72ad-e8c7-455b-a3e3-c170a74c8e32	f	f	2022-02-09 00:00:00	\N	von Allmen	Maëlle	2010	3426650	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
00feb41b-c00b-4402-8c9d-f0b610fe308c	f	f	2022-02-12 00:00:00	\N	Lehmann	Kaya	2008	3057634	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
91dbc1dc-b4db-4398-becf-e3100c240ac4	f	f	2022-02-09 00:00:00	\N	Raum	Arwen	2010	3426652	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
c478a6de-6d00-42eb-9b99-0ad2d7e4d044	f	f	2022-02-09 00:00:00	\N	\N	\N	0	\N	0	43812428-ee9e-486f-81d1-8e38da69c9c4	t
f5775e0c-2a97-4e14-9809-a95a186b785d	f	f	2022-02-12 00:00:00	\N	Irminger	Ladina	2011	3150173	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
ce176f61-3285-41fc-8e37-b8499ca8400e	f	f	2022-02-09 00:00:00	\N	Graf	Lina	2014	3381611	0	0f604f34-370f-4593-8173-cd24234cff78	f
90e4e52f-1a8c-4656-af4b-8fb99ca37cec	f	f	2022-02-12 00:00:00	\N	Stiefel	Nora	2007	979042	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
f576a66b-a996-45b2-bca3-5af4982f7311	f	f	2022-02-09 00:00:00	\N	Tauro	Ambra	2013	3338330	0	0f604f34-370f-4593-8173-cd24234cff78	f
2bdbed89-f4ac-4d14-bc1a-04506ddaaac1	f	f	2022-02-12 00:00:00	\N	Werz	Sara	2009	3150180	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
74fdc348-773d-4d75-b34c-1df86b926f7c	f	f	2022-02-09 00:00:00	\N	Ganz	Zoe	2015	3482819	0	0f604f34-370f-4593-8173-cd24234cff78	f
f0b0e0ed-5725-4e21-85f9-c489fac2c67b	f	f	2022-02-12 00:00:00	\N	Hollenstein	Seraina	2008	3054585	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
29a29eba-35d5-482a-9e53-73c1a432dedd	f	f	2022-02-12 00:00:00	\N	Toribio	Sofia	2012	3298011	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
aec1b462-d01b-48e9-91eb-c61a84e66055	f	f	2022-02-12 00:00:00	\N	Erni	Priscilla	2009	3025765	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
bcf0bf79-8a94-4f8e-8c78-f52eb49ac1b8	f	f	2022-02-12 00:00:00	\N	Lienert	Eleonora	2006	3030611	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
629d829e-d7e8-4ab4-a1d5-3839124166c5	f	f	2022-02-12 00:00:00	\N	Niederer	Luana	2010	3117544	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
e621c97a-37b8-43c6-8120-1d7a09068eba	f	f	2022-02-09 00:00:00	\N	Widmer	Anina	2009	3097829	0	0f604f34-370f-4593-8173-cd24234cff78	f
87fe0420-043a-437e-830c-4b75b7afdc3f	f	f	2022-02-12 00:00:00	\N	Prister	Lene	2010	3117552	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
9a756b35-cad5-4eb6-8eee-d8f194a9682c	f	f	2022-02-09 00:00:00	\N	Barwisch	Noemi	2009	3089689	0	0f604f34-370f-4593-8173-cd24234cff78	f
f5c85169-308c-47bb-8532-caaa48c3a89f	f	f	2022-02-09 00:00:00	\N	Baumann	Svenja	2008	3028706	0	0f604f34-370f-4593-8173-cd24234cff78	f
5d3381c9-77ae-4537-bb4d-5d1a8f49c559	f	f	2022-02-12 00:00:00	\N	Akeret	Ruby	2013	3385174	0	e2438143-6017-4683-a533-6113748d4117	f
007ef232-cb00-4789-b7d5-d19e1b5ea2b8	f	f	2022-02-09 00:00:00	\N	Zimmermann	Estelle	2011	3171187	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
44cbf6a2-05c1-4894-b393-84876d8b27c9	f	f	2022-02-09 00:00:00	\N	Giannini	Moira	2009	3096254	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
d6d65a51-b0ef-48ca-ab91-c5e0c8afdd10	f	f	2022-02-09 00:00:00	\N	Cajamarca	Jael	2008	3101826	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
28495d1b-cf8d-4b0d-8e01-c278f09b29ef	f	f	2022-02-09 00:00:00	\N	Marthaler	Alin	2011	3279206	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
8c725467-a115-43b2-b23e-fc9c95cbe032	f	f	2022-02-13 00:00:00	\N	Brack	Emma	2010	3067282	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
d3936da7-63ea-49f5-9924-328d7da24313	f	f	2022-02-09 00:00:00	\N	Zenger	Isabelle	2011	3343065	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
7693377f-42ee-416d-aa32-ef8fe50352e8	f	f	2022-02-10 00:00:00	\N	Furrer	Ronja	2013	3428170	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
ede4c2ec-19f9-40c8-af23-af4b38a748a0	f	f	2022-02-10 00:00:00	\N	Kaminski	Dina	2012	3365275	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
da48b40b-40f6-4fcb-a3f2-e8c458dfab53	f	f	2022-02-10 00:00:00	\N	Lecaj	Ajlina	2013	3488382	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
bf0d7211-7857-4513-b3ac-36be142d5f74	f	f	2022-02-10 00:00:00	\N	Lingenhag	Tiara	2010	3235052	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
94ff7338-7eb0-4867-a8bd-c5544feaac2b	f	f	2022-02-10 00:00:00	\N	Aeppli	Laura	2009	3125734	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
da6c2a23-8e75-4d7b-bad1-35a0d022b31c	f	f	2022-02-13 00:00:00	\N	Rotter	Hannah	2011	3203832	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
909a25c7-3483-492d-856c-aca554ab6b3e	f	f	2022-02-13 00:00:00	\N	Pfefferle	Violetta	2010	3153714	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
679b18ed-ce86-49f2-a845-2fde19f00def	f	f	2022-02-13 00:00:00	\N	Hintz	Stefanie	2009	3061830	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
c5b6a9fe-67f7-4b23-bd00-fb22ae25f23f	f	f	2022-02-13 00:00:00	\N	Hulmann	Solange	2013	3333522	0	e7e33831-c7ee-4aca-97b1-d2c32b102d58	f
b7347c5a-09fe-441d-81e5-b830867b4fc8	f	f	2022-02-13 00:00:00	\N	Kutter	Lisa	2012	3346319	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
b0bd5a66-810e-4964-a956-8579c3b19e3f	f	f	2022-02-13 00:00:00	\N	Tratar	Laura	2009	3072052	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
6f468d7c-bdfd-479a-b79a-511d22c646ee	f	f	2022-02-13 00:00:00	\N	Vazquez	Kaira	2009	3001581	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
78a1d671-cb0c-4665-9098-d1171422eb1a	f	f	2022-02-13 00:00:00	\N	Tonini	Micol	2013	3428047	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
8a2beba1-5c91-4d73-9d78-b6e6c02fde48	f	f	2022-02-13 00:00:00	\N	Suess	Noemi	2013	3101809	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
f7f3255f-d289-4358-828b-cd1c3baf6ff3	f	f	2022-02-13 00:00:00	\N	Amstad	Alessia	2008	3091102	0	a0ea91c8-f018-424b-ac69-1246f657d591	f
9687bf7d-448d-478c-a972-7f53345260d3	f	f	2022-02-14 00:00:00	\N	Bagorda	Eleni	2011	3321359	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
b0842845-56ea-4663-844e-9b7652074fa7	f	f	2022-02-14 00:00:00	\N	Dos Santos	Maria Paula	2013	3523066	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
39c7fa6e-dcb0-41f8-a3c6-c34f7a511fcf	f	f	2022-02-14 00:00:00	\N	Perdrizat	Livia	2012	3203859	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
2fc03927-c3b6-4bba-8578-12a4a6d99081	f	f	2022-02-14 00:00:00	\N	Schlottig	Tessa	2014	352062	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
308f1b9f-4ef7-42b8-8ba1-c1387edeab5f	f	f	2022-02-14 00:00:00	\N	Grob	Leona	2012	3221366	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
f7d9c4a8-4175-4879-90d9-d0aeea11b932	f	f	2022-02-14 00:00:00	\N	Mentner	Jenny	1997	664749	0	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	f
ac31fcde-be01-4498-894f-a4d4fccbd786	f	f	2022-02-14 00:00:00	\N	Ntogantzis	Nefeli	2016	3514242	0	42933e50-7306-4a54-b42a-276813e8b03a	f
14899b67-d0a2-4a8b-936b-6a2d4391067a	f	f	2022-02-14 00:00:00	\N	Bulliard	Su	2014	3488303	0	688a34cb-72f2-4920-aeb3-89325956de26	f
a3465cbe-1901-4046-a46a-67ff2cdf590a	f	f	2022-02-14 00:00:00	\N	\N	\N	0	\N	0	465cb8a9-3909-4d55-beab-ca76d490081e	t
a79d430f-c64b-4c02-aac4-ccf6ccd0f6e1	f	f	2022-02-07 00:00:00	\N	Sunier 	Kyra	2006	3004525	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
f03dc8d9-9990-40de-8939-005eae51dc59	f	f	2022-02-07 00:00:00	\N	Würmli	Julia	2008	870738	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
cd825fef-d4a7-41e3-8686-ff661082ded7	f	f	2022-02-08 00:00:00	\N	Matulik	Liliana	2015	3527051	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
f927df83-a6e2-4397-8912-3fcbbd640ebb	f	f	2022-02-08 00:00:00	\N	Barry	Lisette	2014	3394144	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
939b658d-0f6e-4961-a2e5-844c154e1c46	f	f	2022-02-13 00:00:00	\N	Schoch	Florence	2012	3296508	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
28ebb368-6f6e-42b3-9974-c2fd74426f7c	f	f	2022-02-13 00:00:00	\N	Schack	Mara	2008	3014124	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
72a901e3-f708-4862-9c0c-9899614a8c33	f	f	2022-02-13 00:00:00	\N	Bachmann	Zora	2005	971203	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
917293a7-f95c-416a-b302-b96ce31133da	f	f	2022-02-13 00:00:00	\N	Rischke	Lilian	2007	972855	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
64295098-b959-4ee2-98f5-0a744702ed7a	f	f	2022-02-07 00:00:00	\N	Ilic	Nina	2014	3427028	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
09c2f84d-0349-4390-9cc9-c56f3feb1aaf	f	f	2022-02-07 00:00:00	\N	Dubler	Leana	2014	3492282	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
5fab3e8c-2d84-4cf9-9437-6cc3f02c0d53	f	f	2022-02-07 00:00:00	\N	Hofer	Nya	2014	3515951	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
7da99a41-60b7-487b-aaee-28785c2ad111	f	f	2022-02-07 00:00:00	\N	Banas	Alicja	2014	3515948	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
76ec3ae7-9c3b-4e22-9bed-4c9fb606506d	f	f	2022-02-07 00:00:00	\N	Bürgin 	Fabienne	2015	3440681	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
d77d6a91-3bb7-414f-9280-176d4bf0b1ea	f	f	2022-02-07 00:00:00	\N	Schnurrenberger	Jara	2014	3511828	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
535aa577-84a9-4fb3-9f74-c6b3a4db6f4e	f	f	2022-02-07 00:00:00	\N	Lienhard	Lia	2014	3346355	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
4e352882-165d-451a-9e98-24fc4da3b585	f	f	2022-02-07 00:00:00	\N	Lopez Naira	Naira	2014	3425209	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
be5c35d5-b53e-4d63-bd7f-e401977b624c	f	f	2022-02-07 00:00:00	\N	Koyotürk	Zeynep	2012	3515955	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
4ffc6756-ef8c-4fc2-83be-556f03df49f2	f	f	2022-02-07 00:00:00	\N	Staub	Nyah	2015	3427024	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
74a0429e-9a75-40f9-89ce-9124580e92be	f	f	2022-02-07 00:00:00	\N	Meier	Fabienne	2014	3227451	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
77bcb01b-a107-4cc4-baaa-afcf41cb24ce	f	f	2022-02-07 00:00:00	\N	Nedanoska	Adriana	2015	3511320	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
fcc579cd-84ed-495d-a64c-6e66f8ac647d	f	f	2022-02-07 00:00:00	\N	Suhner	Sara	2012	3346348	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
50e41b3f-33a8-4d90-a7fa-25f7d7ceb86f	f	f	2022-02-07 00:00:00	\N	Preuss	Feline	2012	3515957	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
b2ed96ff-0785-48e6-9fab-3b56478dbe5b	f	f	2022-02-07 00:00:00	\N	Lienhard	Anja	2012	3346353	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
6bd0fcda-e6c5-49ff-8cd3-eca6284ec8ed	f	f	2022-02-07 00:00:00	\N	Studer	Jessica	2010	3230014	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
b0824277-60c5-4b51-95f3-85fd499f3230	f	f	2022-02-07 00:00:00	\N	Weiersmüller 	Jael	2012	3346350	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
941a27f3-7870-426f-a22c-fbfcb094097a	f	f	2022-02-07 00:00:00	\N	Lopez	Zoe	2012	3227454	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
3245faa2-3511-4ae4-b995-08911bfd736c	f	f	2022-02-07 00:00:00	\N	Danuschewske	Marie	2011	3141780	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
162f3015-3281-46cb-ba71-41c2f6f0ddae	f	f	2022-02-07 00:00:00	\N	Gercegin	Celin	2011	3141783	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
041c344c-5c7d-4c9e-a9b1-478d5990d9b5	f	f	2022-02-07 00:00:00	\N	Apollonio	Valeria	2007	3096508	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
d2b82c0c-c2bc-4b2d-84e8-f7e33d084196	f	f	2022-02-07 00:00:00	\N	Lienhard	Lisa	2011	3227458	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
f0ca7fdc-3076-40cd-ae10-590096c8ea2f	f	f	2022-02-07 00:00:00	\N	Mazenauer	Nuala	2007	961384	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
266f5bd3-966e-439a-b675-215b3a31f976	f	f	2022-02-07 00:00:00	\N	Wohlgemuth	Fay	2008	3055495	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
bb11cca0-d64c-4c97-b747-1b7459293dcd	f	f	2022-02-07 00:00:00	\N	Stucki	Lynn	2009	3141807	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
e1f441cc-951a-4c2a-879e-63e1825b902c	f	f	2022-02-07 00:00:00	\N	Wagner	Lisa	2007	961395	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
67ed9c9c-7e6b-419d-9a4a-32234377403c	f	f	2022-02-07 00:00:00	\N	Joos	Anouk	2007	961361	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
b1427975-7b61-42f9-a677-5ccf675d2eb5	f	f	2022-02-07 00:00:00	\N	Keller	Julia	2007	961366	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
5034bf64-09c9-4ddf-b432-66f1c1a0963a	f	f	2022-02-07 00:00:00	\N	Joos	Flavia	2005	961362	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
011485d3-16c0-40e4-947e-fd96f16e0a8f	f	f	2022-02-07 00:00:00	\N	Gassmann	Mia	2008	3055497	0	dc8ff971-5522-45bf-b501-ff65ecb46db9	f
cd236b71-101b-46ee-83dd-6ef5b64d3621	f	f	2022-02-07 00:00:00	\N	Müller	Alina	2008	3176439	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
c061d703-74e3-44b6-a374-ddb4ad7d98e7	f	f	2022-02-07 00:00:00	\N	Scrivano	Elisa	2006	912289	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
806ed6d9-5c8e-455f-bd95-9f641dc306a2	f	f	2022-02-07 00:00:00	\N	Müller	Simona	2007	954438	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
464aa6fb-4e31-40fa-9c77-1547e32685df	f	f	2022-02-07 00:00:00	\N	Brühlmann	Leonie	2009	3064898	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
133d564b-e9dd-4f84-ba27-45ca1681441e	f	f	2022-02-07 00:00:00	\N	Hartmann	Viviane	2003	713011	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
d76e2d0b-481e-4bf8-a71c-3072a67eb3d4	f	f	2022-02-07 00:00:00	\N	Stieger	Alina	2009	3123163	0	5ee987b5-deec-4087-b36f-bba4dcaf842f	f
716ef128-20c5-4045-9a62-1dcb10d7e45b	f	f	2022-02-07 00:00:00	\N	Hofmann	Larissa	2014	3345175	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
1c4f3619-0081-4624-bc37-7240afa81012	f	f	2022-02-07 00:00:00	\N	Dunger	Matilda	2013	3345157	0	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	f
1e3e49b7-86a2-49b4-90eb-38f5885cdb20	f	f	2022-02-08 00:00:00	\N	Barudzija	Milijana	2004	980018	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
5f6c8cce-6b15-4ead-8acf-d64cceff2401	f	f	2022-02-08 00:00:00	\N	Küderli	Mia	2002	867785	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
3850372b-c892-443d-bb59-c9e33b049ace	f	f	2022-02-08 00:00:00	\N	Strübin	Alisha	2008	3143229	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
f9e451b9-680d-4fdd-a526-180e02ad2d6b	f	f	2022-02-08 00:00:00	\N	Jaggi	Amy	2007	986413	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
0ba09400-8e84-4cd3-aed9-ff2256464c82	f	f	2022-02-08 00:00:00	\N	Semenova	Daria	2005	3014117	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
8f0c89de-7549-484c-8505-f993a4525f98	f	f	2022-02-08 00:00:00	\N	Wacker	Neea	2007	993729	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
31f1108b-83f9-4c78-b629-80ec5ca2fc39	f	f	2022-02-08 00:00:00	\N	Tribolet	Luciana	2008	3472964	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
283f64a1-3500-466f-aeb2-a434ef3dbc50	f	f	2022-02-08 00:00:00	\N	Devos	Isabelle	2008	3158739	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
ea6b3433-5711-41c1-9fc1-8702d01488e2	f	f	2022-02-08 00:00:00	\N	Howard	Isabella	2009	3143210	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
475265e6-286a-4de1-913f-82263b96efcf	f	f	2022-02-08 00:00:00	\N	Brändli	Isabel	2009	3206587	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
6ccd21cc-acde-4ecd-bd85-55fd7b93f187	f	f	2022-02-08 00:00:00	\N	Strübin	Leona	2010	3206626	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
8a0fbc8d-a8ae-4e3b-90e0-e66ad10cae02	f	f	2022-02-08 00:00:00	\N	Schneller	Olivia	2009	3233081	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
f339f03a-ef02-4131-bd54-68769fc61178	f	f	2022-02-08 00:00:00	\N	Cotton	Liva	2009	3128672	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
2be3c806-de4f-45be-bdde-5c35af908a08	f	f	2022-02-08 00:00:00	\N	Yakoubi	Alicja	2009	3113340	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
ea82ed6a-094a-4439-83b8-0d5335ef06e3	f	f	2022-02-08 00:00:00	\N	Acurio	Rumi	2012	3473202	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
fdbb0c72-b76c-4ee9-99f3-07398f239bf7	f	f	2022-02-08 00:00:00	\N	Fäs	Sarina	2012	3472962	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
ce975f85-8101-4cfc-a5f6-35825ec515fa	f	f	2022-02-08 00:00:00	\N	Mante	Janine	2010	3233071	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
4fd9210b-2b45-47b7-aeec-15b1bf2d934b	f	f	2022-02-08 00:00:00	\N	Bircher	Hannah	2009	3233069	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
07512d78-fb0a-4b3e-8611-7782d109a2c5	f	f	2022-02-08 00:00:00	\N	Bekk	Akela	2011	3473751	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
9137ee87-55b1-46fa-9f6b-03ca66d06d5c	f	f	2022-02-08 00:00:00	\N	Tekeste	Diyana	2011	3388390	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
8b6304d3-8c2c-4986-a819-5a03668077fe	f	f	2022-02-08 00:00:00	\N	Muhametaj	Hena	2012	3354994	0	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
497a8eac-0bc3-416a-93bc-fc063eab0fcf	f	f	2022-02-08 00:00:00	\N	Huber	Joelle	2014	3448468	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
1514bb8f-72fe-43b3-8cca-47af497fa9fe	f	f	2022-02-08 00:00:00	\N	Herrmann	Mara	2011	3162287	0	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
14317636-c140-4094-baa5-d82f3241f8c4	f	f	2022-02-12 00:00:00	\N	Peter	Sue	2012	3266369	0	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	f
ccaf2874-9a43-484d-bf7a-011a6794ef45	f	f	2022-02-09 00:00:00	\N	Kuhn	Julia	2012	3333343	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
4cf8e7af-95c3-4858-8d58-2be4dc4dc2b2	f	f	2022-02-12 00:00:00	\N	Huber	Joline	2010	3070945	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
71543d35-90fd-487d-89c0-9500aab414ea	f	f	2022-02-09 00:00:00	\N	Furrer	Alyssa	2010	3268761	0	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
f8635296-d310-41ae-b55b-0fa695804348	f	f	2022-02-09 00:00:00	\N	Comminot	Larina	2013	3482817	0	0f604f34-370f-4593-8173-cd24234cff78	f
66d71487-91db-4ae4-8b32-f418e0d76db0	f	f	2022-02-12 00:00:00	\N	Huber	Lina	2012	3390360	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
ce0a1f6f-50f1-4247-9a26-9f37d0db310e	f	f	2022-02-08 00:00:00	\N	Götz	Noemi	2011	3406749	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
d11d1bf8-96e4-4b73-b3b1-fa8ead50aa50	f	f	2022-02-08 00:00:00	\N	Naas	Filippa	2010	3388704	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
e86b94e4-a210-4fd0-a1f4-24088fa2e269	f	f	2022-02-08 00:00:00	\N	Reis	Amelia	2010	3514919	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
f0dbf813-4daa-4557-9b60-6c5770fdafb3	f	f	2022-02-08 00:00:00	\N	Ehrler	Zoë	2013	3514911	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
e69677a2-61e1-4f4f-a5cd-81457d6f45de	f	f	2022-02-08 00:00:00	\N	Zimmermann	Jolien	2014	3340566	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
4babe487-99a1-4e0c-b2c2-77e2f45d94c7	f	f	2022-02-08 00:00:00	\N	Maurer	Alena	2011	3472948	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
17b9db44-1cbf-4569-9dc3-cd5b409087dc	f	f	2022-02-08 00:00:00	\N	Giselbrecht	Nicole	2014	3310724	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
9e010d42-2dd7-41d3-9869-ec85454ca0f5	f	f	2022-02-08 00:00:00	\N	Meylan	Alicia	2013	3472950	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
9f08602c-43ab-4d17-84e8-5f3df48f1cb3	f	f	2022-02-08 00:00:00	\N	Eberle	Linda	2010	3514924	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
74e2ac1f-3276-47fd-810f-ecf705fcac58	f	f	2022-02-08 00:00:00	\N	Bircher	Rebecca	2015	3514915	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
a35cce08-9cfa-4f8e-9ba1-0f5258991449	f	f	2022-02-08 00:00:00	\N	Moya	Elena	2012	3514913	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
4ec17ceb-1002-4608-9120-9376ecf9266d	f	f	2022-02-09 00:00:00	\N	Gioritto	Aurelia	2014	3437801	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
713b4ffa-63d8-430f-8fbc-6fc4dc3de498	f	f	2022-02-12 00:00:00	\N	Keller	Yuna	2016	3438780	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
74dae1cd-5868-4a6a-99ab-fbcb7780288a	f	f	2022-02-09 00:00:00	\N	Pelado	Virginia	2005	3483048	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
f2356d31-10c0-4f6b-8268-aec867416b0d	f	f	2022-02-09 00:00:00	\N	Heyland	Anna	2006	3004637	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
0cf6855b-b7c3-4f5d-bc5e-fe8dc569280b	f	f	2022-02-09 00:00:00	\N	Soliman	Amira	2008	3054556	0	83a5507a-c2fc-4171-8af4-fb4d8d45c889	f
1173dede-94b5-4651-a164-a295f98de032	f	f	2022-02-12 00:00:00	\N	Kesseli	Sophia	2016	3542566	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
1af32c38-ef0a-47af-9bbd-dc2de2e1101d	f	f	2022-02-09 00:00:00	\N	Zenger	Gabriela	2010	3279226	0	a7f39754-f6ec-4934-9c2e-6bb84f8be764	f
2fd65ab6-5dc4-4591-aa05-72380670f7e4	f	f	2022-02-10 00:00:00	\N	Hofer	Livia	2010	3138309	0	b0574726-8fed-4a1f-aac3-09f61225548d	f
7d267e77-4449-469e-8118-4fbe2f6761ce	f	f	2022-02-10 00:00:00	\N	Bühler	Sandra	2003	669068	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
e4bf911c-db18-4cac-9200-a3d7640881e8	f	f	2022-02-12 00:00:00	\N	Kindhauser	Lina	2009	3070946	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
4deb6c1b-1aaf-4847-96e4-9c31061a9677	f	f	2022-02-12 00:00:00	\N	Langhart	Lena	2011	3504295	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
2b9274e6-f21e-4ec2-8ceb-0e4899a0f303	f	f	2022-02-12 00:00:00	\N	Meier	Emma	2014	3438778	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
77143eb8-805c-4c69-a3c6-087b5e35c964	f	f	2022-02-12 00:00:00	\N	Nijland	Lorelei	2009	3241434	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
3530944c-31de-48ae-a95e-c275af988ff2	f	f	2022-02-12 00:00:00	\N	Noseda	Andrina	2010	3112443	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
6cdeaa17-213a-496b-8747-014b2de11ab4	f	f	2022-02-12 00:00:00	\N	Noseda	Julia	2014	3390358	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
f4636b6d-8b45-416b-b703-43f2938b17a7	f	f	2022-02-12 00:00:00	\N	Noseda	Livia	2014	3390356	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
0dabee6d-3832-4404-965c-370b1861f109	f	f	2022-02-12 00:00:00	\N	Notter	Sophia	2009	3120273	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
922fedbe-65d1-42fe-afc8-cea539464846	f	f	2022-02-12 00:00:00	\N	Obst	Lina	2016	3542564	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
591b6268-85f6-4541-a3a0-34bba7b73b00	f	f	2022-02-12 00:00:00	\N	Oertli	Lenja	2009	3092168	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
23c70849-a8c6-4adc-b6a7-d177f02dfc3d	f	f	2022-02-12 00:00:00	\N	Ott	Giuliana	2013	3390365	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
31fe1b86-6f4e-4019-b29a-d97b3a7d67c9	f	f	2022-02-12 00:00:00	\N	Reichel	Linnea	2009	3182857	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
c86a9609-fca3-472a-a92f-887e5c2bc8ae	f	f	2022-02-12 00:00:00	\N	Saller	Sereina	2007	852686	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
292995a1-8f2f-42c6-ac91-bfde428bdaae	f	f	2022-02-12 00:00:00	\N	Schäppi	Cathleen	2013	3390367	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
ab0b49d6-7cd9-41e1-bb69-4f27b6dc4786	f	f	2022-02-12 00:00:00	\N	Scheibli	Eva	2014	3390363	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
2db43a74-1b37-47ae-8b3c-8d83216f0996	f	f	2022-02-12 00:00:00	\N	Schmid	Alexa	2009	3120276	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
cb752530-0c47-43e4-b682-3ffbfdf32946	f	f	2022-02-12 00:00:00	\N	Schnellmann	Luna	2011	3180759	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
c9bf4bd3-fe04-4ffa-8167-11eeeb28ef8b	f	f	2022-02-12 00:00:00	\N	Schwarzenbach	Jael	2009	3007822	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
df06a883-3e31-4342-a59c-b1754fcbad0b	f	f	2022-02-12 00:00:00	\N	Steiner	Giulia	2016	3542560	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
463f5a6e-52bf-42f7-b603-c28d9cf35a2d	f	f	2022-02-12 00:00:00	\N	Von Reitzenstein	Liel	2010	3070951	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
2ea85b08-27b6-4ace-a451-5747c57bbeac	f	f	2022-02-12 00:00:00	\N	Von Reitzenstein	Simea	2008	912521	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
168f1e57-7f3a-4a11-bded-9508ba1305d5	f	f	2022-02-12 00:00:00	\N	Walt	Fiona	2007	3112455	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
e1cc6891-f926-448a-9d36-e52d93139468	f	f	2022-02-12 00:00:00	\N	Wanner	Silja	2008	3007835	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
671aa4c4-e34a-4a31-9212-d238aeb66104	f	f	2022-02-12 00:00:00	\N	Wegmann	Mia	2016	3542577	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
68e01579-9062-463c-864a-f7fb9346ab0f	f	f	2022-02-12 00:00:00	\N	Winkler	Alissa	2011	3327148	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
54b727f1-80d5-42f1-a838-168bf3dc7836	f	f	2022-02-12 00:00:00	\N	Zingg	Adriana	2016	3438784	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
64962a91-5632-474a-b889-b24dfa24d96e	f	f	2022-02-12 00:00:00	\N	Zingg	Leandra	2011	3222107	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
d1690823-6b6f-4e55-a46a-8bc73fa0d6fe	f	f	2022-02-12 00:00:00	\N	Zürrer	Laraina	2016	3438786	0	1ef47e57-2af3-4027-8cd6-427f30a63792	f
c79954ff-50d5-4509-ad43-a625f2e6eec4	f	f	2022-02-12 00:00:00	\N	Camenzind	Celia	2011	3297994	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
e93480ba-88a8-48a2-95fb-90041edf2bcb	f	f	2022-02-12 00:00:00	\N	Flacher	Rania	2011	3116961	0	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
a0001b52-3ee5-4b3a-88dd-2542b0933711	f	f	2022-02-12 00:00:00	\N	Ganz	Naima	2006	3198018	0	e2438143-6017-4683-a533-6113748d4117	f
b910832d-458a-4d53-b1b9-ffe8e01fcc43	f	f	2022-02-12 00:00:00	\N	Galvan	Viviane	2006	3020342	0	e2438143-6017-4683-a533-6113748d4117	f
826f246f-0262-48bf-a939-683564d8aaaa	f	f	2022-02-13 00:00:00	\N	Giselbrecht	Julia	2011	3142715	0	80c08ccc-c90e-4377-af3b-2de779197c7a	f
\.


--
-- Data for Name: teilnehmer_anlass_link; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teilnehmer_anlass_link (id, aktiv, deleted, change_date, deletion_date, kategorie, teilnehmer_id, anlass_id, organisation_id, startnummer, abteilung, anlage, startgeraet, melde_status, lauflisten_container_id) FROM stdin;
d7e63925-a268-4181-b5ca-0caca45b80af	t	f	2022-02-09 00:00:00	\N	KEIN_START	632d1973-de46-491a-b715-daf09ce5e1fc	0fa002f3-d432-46d4-a753-991d021db3fa	a7f39754-f6ec-4934-9c2e-6bb84f8be764	\N	\N	\N	\N	STARTET	\N
f56666a7-353d-4122-88d9-4b3d73780e17	t	f	2022-02-10 00:00:00	\N	K3	ede4c2ec-19f9-40c8-af23-af4b38a748a0	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
54ed3944-ad4b-46dc-b75c-e5826ba7eaac	t	f	2022-02-10 00:00:00	\N	K2	34390b7a-9094-4989-9474-98d859b806de	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
9ff16f77-8b41-45a0-8634-48048bb299ba	t	f	2022-02-10 00:00:00	\N	K6	0d39d031-e0ec-449e-9bd8-c4366b8b18c3	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
3f5d70e4-904c-4bc4-aeaa-70e7dd1d6e3e	t	f	2022-02-10 00:00:00	\N	K1	9538da6f-63a3-4636-986a-42ce94676e55	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
19138f8f-f3dd-47c8-b321-a61bb1ad731a	t	f	2022-02-10 00:00:00	\N	K2	c09e5f75-f639-4a1f-9fdc-66d0ac7afa1b	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
f024b576-e2be-40a7-8400-d35607fcef4e	t	f	2022-02-10 00:00:00	\N	K3	a3fb6040-aab2-48b6-8f46-e38b93d92997	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
9d1457f5-28e2-47b4-a6ae-153d0de8a6c7	t	f	2022-02-11 00:00:00	\N	K2	498e0556-c0ab-4182-ad84-760f8a03e926	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
171643d4-bd1e-42da-8043-d3dd16282613	t	f	2022-02-11 00:00:00	\N	K3	0baf392c-69a4-4ef9-b5ec-a98c8c13b55e	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
d9a52f28-30c5-44c0-a6ab-b23943c450e5	t	f	2022-02-11 00:00:00	\N	K5A	2e0694e4-580b-4692-b201-5ad5f5de6baa	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
c3cbdded-6c59-4fa6-8ca9-1d2cad61757a	t	f	2022-02-11 00:00:00	\N	K4	fc4757fb-dba2-4c57-b3b7-b4dd3aced628	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
d7762955-f0ce-48d0-9e52-a8d94b37521b	t	f	2022-01-28 00:00:00	\N	K4	b62a15ae-bb28-4457-b078-8abcb6245e7c	b7440787-50bd-4e41-b38b-48acf37af0de	86a39d76-71ed-4890-82ec-ce2a48d32627	133	\N	\N	\N	STARTET	\N
92015701-b53b-4a7e-8545-e199afec2b4b	t	f	2022-01-29 00:00:00	\N	K4	e94538bb-c604-4b5b-bb82-de73bed9fc43	b7440787-50bd-4e41-b38b-48acf37af0de	a5302a2b-d270-49e5-9876-47c84cb38038	134	\N	\N	\N	STARTET	\N
d132fda2-5e62-444d-9dc8-dec8734f0fa3	t	f	2022-01-27 00:00:00	\N	K1	23f6b48b-fc39-42e8-a995-948ba22a5750	b7440787-50bd-4e41-b38b-48acf37af0de	a5302a2b-d270-49e5-9876-47c84cb38038	135	\N	\N	\N	STARTET	\N
ba942068-9577-4b82-bfa1-32b4f364bffb	t	f	2022-01-29 00:00:00	\N	K5	a4cf5270-3435-49d8-a4d7-40b070f1c4ab	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	136	\N	\N	\N	STARTET	\N
b763cae7-b683-4b9d-89e9-83fa46ff4159	t	f	2022-01-29 00:00:00	\N	K7	717ef780-9fcf-4658-9db6-693e62764908	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	137	\N	\N	\N	STARTET	\N
dc4f6a20-217d-403b-ba20-53e42dda2153	f	f	2022-01-12 00:00:00	\N	KEIN_START	2a9bb7bd-52fb-45dc-a9fd-1a360472fa78	b7440787-50bd-4e41-b38b-48acf37af0de	2fc3365b-34d9-4054-b2d8-aa859c7455e7	\N	\N	\N	\N	\N	\N
5f8a8dc9-2a64-4b34-9808-4502d0d496d1	t	f	2022-01-29 00:00:00	\N	K4	3375fcba-0144-4efa-ac46-160742fef0aa	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	138	\N	\N	\N	STARTET	\N
309ca7fd-928f-47a5-a9a1-5bf3357f39a8	t	f	2022-01-29 00:00:00	\N	K3	1fcb183f-192a-477a-822b-1628def7bf3b	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	139	\N	\N	\N	STARTET	\N
df034126-8844-45cd-b49d-2f07d1b9fb7f	t	f	2022-01-29 00:00:00	\N	K6	28ab6e33-9ef1-46f6-b2ef-82a2d3089947	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	140	\N	\N	\N	STARTET	\N
8283949e-7d43-4934-951f-4e164bac235d	t	f	2022-01-30 00:00:00	\N	K3	ecb1f79f-955a-4f6c-b384-9a4bafff1d35	b7440787-50bd-4e41-b38b-48acf37af0de	1030974d-cffe-46d6-b6ea-79c8839cf2ea	141	\N	\N	\N	STARTET	\N
b96e82e7-9ad7-4347-a8df-88f445e5ccc7	t	f	2022-01-30 00:00:00	\N	K3	645f1e3e-fc8e-4aad-a4fa-cddf26df1a51	b7440787-50bd-4e41-b38b-48acf37af0de	4e9262a1-fef9-4701-9c91-1b3016ee971d	142	\N	\N	\N	STARTET	\N
dbf1eee8-9e81-4c34-9783-e2beb6617676	t	f	2022-02-11 00:00:00	\N	K5A	0a20fa2f-3a56-45a5-8fe0-6412c826eab6	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
f766384b-ee81-436e-81d5-dff3a2e549ee	t	f	2022-02-11 00:00:00	\N	K6	50302e7d-da81-40e9-9888-6ad4c36e053b	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
b5201c0e-ec91-47c0-aedc-4702ba7921bc	t	f	2022-02-11 00:00:00	\N	K5A	145a7105-873c-41a3-a83e-b5483de2aedc	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
7d0bc2a7-eb80-4536-a4f4-ef0ed626cf9f	t	f	2022-02-11 00:00:00	\N	K6	9d446514-789d-4ce4-a346-ae16fc95e783	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
a43e5731-6218-43dd-990a-d80cf46801be	t	f	2022-02-11 00:00:00	\N	K5A	5622ed0d-348b-4428-831e-ac063dfb802f	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
7119b87a-2c4a-4d3b-a9d8-cd3e584f1063	t	f	2022-02-11 00:00:00	\N	K5B	50d97ea9-48c1-43ca-be4a-2f0d5e9de270	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
ec930ca1-bcd6-4acc-9183-db3859941966	t	f	2022-02-11 00:00:00	\N	K5B	c9bd5703-664f-43d5-a219-697e091d6f03	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
3b52089a-d0f3-41e1-8c1c-c90780017432	t	f	2022-02-11 00:00:00	\N	K4	7ae28e60-3832-4922-8cc6-1e1a8d62733b	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
42bc4b89-69fb-44da-a94c-ba11562afc45	t	f	2022-02-11 00:00:00	\N	K3	b3500eb4-cfb3-4306-8255-8b65c7032fdb	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
435b1500-dede-4097-92bf-f04926084cbc	t	f	2022-02-11 00:00:00	\N	KEIN_START	995e4d72-b66a-4fe4-9307-0912ae1454d4	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
07f95f97-fbf1-4eae-8cc1-a32877b5a24b	t	f	2022-02-11 00:00:00	\N	K2	1df95b51-01ef-4384-a38f-7b874e6ad5c3	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
41831d73-a663-45f3-bf7c-ae884699de9c	t	f	2022-02-11 00:00:00	\N	K1	f30069d3-1749-46ad-bf8a-bf30a4b56a63	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
eea30409-3e1a-4011-bd29-6e74cf4544f8	t	f	2022-02-11 00:00:00	\N	K4	0288ba94-fcdb-48c7-a61d-e81e09de45eb	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
36c98b37-d2b8-4478-89fc-e109ece12e91	t	f	2022-02-11 00:00:00	\N	K1	954aba8d-443c-4a0e-b527-160002a0c1c8	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
ec35fb55-5c04-494d-8450-1b4a9259b43a	t	f	2022-02-12 00:00:00	\N	K6	e9629839-5cd8-4533-9eb0-db75f06ae1db	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
89a7d996-2297-4a88-9075-815688688738	t	f	2022-01-22 00:00:00	\N	K5	5308ed6a-e60f-491a-9b2c-26da8e2cfa8e	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	89	\N	\N	\N	STARTET	\N
abc21fd6-8481-4f4b-8842-bc8c973133ca	t	f	2022-02-06 00:00:00	\N	K3	b7cfcd59-bb9b-4e1d-b59f-e9522d84ead8	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
e6fe63fe-09d0-48f7-abb5-bb0b98bbe180	t	f	2022-02-06 00:00:00	\N	K4	0af9f6c2-0b45-4f0f-a0cf-41da23b67aeb	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
64627e79-d2ff-441f-b410-3d8fe7b087b0	t	f	2022-02-06 00:00:00	\N	K7	95f4fd85-29e4-44f2-a8db-c8295819a339	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
4bab2471-a0f5-4a06-843f-8abd75f0ba80	t	f	2022-02-06 00:00:00	\N	K6	c04c3b69-b53a-4134-b259-8d42af89df98	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
48931ebb-5cb3-4c9d-a35c-a69c91d09e72	t	f	2022-02-06 00:00:00	\N	K5A	20d2b026-f247-40fd-86fa-b8079c8810e6	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
c4540ad4-6fea-4405-85cd-cf3b3720c043	t	f	2022-02-07 00:00:00	\N	K2	e8598f8f-a3b0-459a-ba77-1b4266769ef6	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
bb793b33-c5d1-444d-9cb3-0548a08673cd	t	f	2022-02-07 00:00:00	\N	K4	41f510b9-0caa-4e56-b98d-d1a56663576c	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
313f759c-791f-4299-96f3-ca0240cb67a6	t	f	2022-02-07 00:00:00	\N	K6	8e55fb70-64b6-4821-866c-196bd9b9620e	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
96f01258-e594-4952-9e8d-c0135ee018ae	t	f	2022-02-07 00:00:00	\N	K1	5fab3e8c-2d84-4cf9-9437-6cc3f02c0d53	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
84cd3ea6-c239-4162-95e9-efe9143ea82d	t	f	2022-02-07 00:00:00	\N	K2	50e41b3f-33a8-4d90-a7fa-25f7d7ceb86f	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
f203c401-7dbe-4285-9b0f-7814074dcd34	t	f	2022-02-07 00:00:00	\N	K3	941a27f3-7870-426f-a22c-fbfcb094097a	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
942a64f3-4294-4c7a-aa24-f8feaa180ace	t	f	2022-02-07 00:00:00	\N	K4	3245faa2-3511-4ae4-b995-08911bfd736c	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
0f7429a1-5710-4e27-b7a3-9c82d6330603	t	f	2022-02-07 00:00:00	\N	K5B	b1427975-7b61-42f9-a677-5ccf675d2eb5	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
7971d990-7893-4439-82fa-d8b047b5060f	t	f	2022-02-07 00:00:00	\N	K5B	011485d3-16c0-40e4-947e-fd96f16e0a8f	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
1fc411e3-034c-439b-8be6-22efa5ca3ca5	t	f	2022-02-07 00:00:00	\N	K3	5ae93910-ae7d-480c-b9da-4f43453229a9	0fa002f3-d432-46d4-a753-991d021db3fa	5ee987b5-deec-4087-b36f-bba4dcaf842f	\N	\N	\N	\N	STARTET	\N
a4f184da-405c-4dd3-b485-0f9dad75af40	t	f	2022-02-07 00:00:00	\N	K2	7a701496-f709-4924-ab6c-e45b339fac35	0fa002f3-d432-46d4-a753-991d021db3fa	5ee987b5-deec-4087-b36f-bba4dcaf842f	\N	\N	\N	\N	STARTET	\N
c43e0c58-11be-484c-a55d-d333a1906376	t	f	2022-02-07 00:00:00	\N	K2	13e3e43d-cda8-4ed5-b15b-0999e959778f	0fa002f3-d432-46d4-a753-991d021db3fa	5ee987b5-deec-4087-b36f-bba4dcaf842f	\N	\N	\N	\N	STARTET	\N
55a38ed8-4764-4401-b506-47c78a56846e	f	f	2022-01-18 00:00:00	\N	KEIN_START	a054e6d4-5694-492b-a84c-49d8bd1f9ee9	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	\N	\N
d2fcbca1-ab72-4f83-a34d-9e27197d050a	t	f	2022-02-07 00:00:00	\N	K3	d76e2d0b-481e-4bf8-a71c-3072a67eb3d4	0fa002f3-d432-46d4-a753-991d021db3fa	5ee987b5-deec-4087-b36f-bba4dcaf842f	\N	\N	\N	\N	STARTET	\N
d491686a-55ac-4229-9178-df2f79f44e2d	t	f	2022-02-07 00:00:00	\N	K3	60c12a90-e350-4fe9-8130-0597344f2f0c	0fa002f3-d432-46d4-a753-991d021db3fa	5ee987b5-deec-4087-b36f-bba4dcaf842f	\N	\N	\N	\N	STARTET	\N
b253cd95-d329-4756-8685-341acff64d92	t	f	2022-02-07 00:00:00	\N	K6	22bb800e-a85e-4447-9e1e-a4b960bdb539	b7440787-50bd-4e41-b38b-48acf37af0de	97cf3158-df81-45c1-b49e-47a692438dca	184	\N	\N	\N	STARTET	\N
157dc38f-4c7a-4aef-8ef2-d3670d3f70a1	t	f	2022-02-07 00:00:00	\N	K1	0854718f-c29f-415e-83dd-56397cd430ce	b7440787-50bd-4e41-b38b-48acf37af0de	1fe6d9ce-05bf-4a02-81c4-53d731398880	185	\N	\N	\N	STARTET	\N
ce7222d6-40d8-4dc6-9eb9-b79f94e51378	t	f	2022-01-11 00:00:00	\N	K7	64deb490-e1c3-4564-a332-65cec17d5d9a	b7440787-50bd-4e41-b38b-48acf37af0de	205d3aed-6ce7-4cd3-8f6d-8d222d9d59b0	1	\N	\N	\N	\N	\N
d9519100-fb99-4d3e-93ef-01a56eefc676	t	f	2022-02-10 00:00:00	\N	K1	9dbb066d-047c-41ed-b241-2c58091e6817	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
bb47ff1e-eed5-48c6-a491-ee54ffd781dd	t	f	2022-01-20 00:00:00	\N	K3	b58f7905-996a-4d8d-a05a-da9026a920eb	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	63	\N	\N	\N	\N	\N
cf05908b-79ae-4b7b-be30-cbc50d93a3d9	t	f	2022-02-10 00:00:00	\N	K2	0a2ba450-116d-4b86-828e-8d848a39de40	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
feb04b3b-ba26-4200-b828-30d10749fef4	t	f	2022-02-10 00:00:00	\N	K5A	804ce147-8367-45a2-b4a4-6109ebdbfff3	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
ab70d8eb-2faf-4dd0-b953-2e1965f858e5	t	f	2022-02-10 00:00:00	\N	KD	a0cfcf47-0969-4b2c-982f-b7707c2c0a53	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
fa85acd0-5f3e-4d10-8df2-afef5a08968a	t	f	2022-02-10 00:00:00	\N	KD	b82921da-9814-487b-9ceb-c7fbee2bcd4a	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
5d4aa97c-13b9-4f40-ad05-69f47e76d547	t	f	2022-02-10 00:00:00	\N	K2	6f06796c-ee1b-4121-ab91-beb0e8daec20	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
2e7751d3-0ab4-4641-a6a0-ec394d98f0eb	t	f	2022-02-10 00:00:00	\N	K2	feea2974-5e14-425c-8d55-c5b1306922e0	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
324c18ac-bebf-4710-b56e-22093b9e73aa	t	f	2022-02-10 00:00:00	\N	K3	c44235f1-617b-43be-8aa8-69572967ad46	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
f8f6f203-dc4e-4901-8197-1e22a5236bb2	t	f	2022-02-10 00:00:00	\N	K3	d9cd5fdf-5aa4-4c42-a741-b4e6a3e2978a	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
520840d0-44a8-403f-9f1a-a5ecf8c7768a	t	f	2022-02-10 00:00:00	\N	K3	aa58405f-46bb-4000-9a01-976dc532e9ba	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
92a6b192-0929-4b70-9b7d-1db6a23a410f	t	f	2022-01-28 00:00:00	\N	K5	a0f3f7b1-957f-4390-92e5-64c5c8729e94	b7440787-50bd-4e41-b38b-48acf37af0de	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	143	\N	\N	\N	STARTET	\N
1e358d4b-9275-48b0-84c7-ad67f550fd26	t	f	2022-01-28 00:00:00	\N	K3	ebf7ab72-5ca6-4aad-b3c2-544447752169	b7440787-50bd-4e41-b38b-48acf37af0de	86a39d76-71ed-4890-82ec-ce2a48d32627	144	\N	\N	\N	STARTET	\N
9fb875f0-2f25-4872-8734-791c0ee3e37d	t	f	2022-01-28 00:00:00	\N	K1	74ca681f-08b0-49df-8ebd-20e38011e269	b7440787-50bd-4e41-b38b-48acf37af0de	86a39d76-71ed-4890-82ec-ce2a48d32627	145	\N	\N	\N	STARTET	\N
41c4394d-e682-469a-bef5-63ed654f6cbd	t	f	2022-01-29 00:00:00	\N	K5	3772babe-b218-4435-8620-ca6aa766ee13	b7440787-50bd-4e41-b38b-48acf37af0de	a5302a2b-d270-49e5-9876-47c84cb38038	146	\N	\N	\N	STARTET	\N
b6e3ac55-100e-440a-88eb-a20cbb9734eb	t	f	2022-01-29 00:00:00	\N	K4	255f7854-e5ef-46cf-8bb5-9df68b75b232	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	147	\N	\N	\N	STARTET	\N
1cbfc2d8-482a-4dfd-83c7-fb1cf9288c0b	t	f	2022-01-29 00:00:00	\N	K4	8d849044-eaf0-45cd-bdb2-6fb2c61d0f51	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	148	\N	\N	\N	STARTET	\N
77847b59-2927-43f0-909b-8dc40eb000b7	t	f	2022-01-29 00:00:00	\N	K2	29418401-87df-43e9-9901-12848ab49f09	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	149	\N	\N	\N	STARTET	\N
0b1bb21e-2ab3-4a99-85ec-5913f1eac710	t	f	2022-01-29 00:00:00	\N	K2	afe3bbf8-c9d3-46af-9e74-0542ec131d89	b7440787-50bd-4e41-b38b-48acf37af0de	80c08ccc-c90e-4377-af3b-2de779197c7a	150	\N	\N	\N	STARTET	\N
2c57cb2f-3f0f-4895-a6af-1f51eb6d61d0	t	f	2022-01-30 00:00:00	\N	K2	96f979f4-2153-47dd-9ecb-87641f8f0749	b7440787-50bd-4e41-b38b-48acf37af0de	1030974d-cffe-46d6-b6ea-79c8839cf2ea	151	\N	\N	\N	STARTET	\N
5aa36089-8655-409e-8ad5-081f3e21ecc4	t	f	2022-01-30 00:00:00	\N	K1	d9a42722-adf8-4213-8f61-aed363a414d0	b7440787-50bd-4e41-b38b-48acf37af0de	4e9262a1-fef9-4701-9c91-1b3016ee971d	152	\N	\N	\N	STARTET	\N
57c5c581-da0a-4dec-8f7b-f283a9a51d77	t	f	2022-02-11 00:00:00	\N	K2	43e91170-02ca-4554-a0c7-d4acda61f644	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
69780160-e546-473c-a2ba-c44947793364	t	f	2022-02-11 00:00:00	\N	K2	6a8764e7-5bc3-4daa-ab90-c47eeb7c4d7f	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
4531e34b-3d2c-466a-9cbc-89560732e575	t	f	2022-02-11 00:00:00	\N	K7	191aff52-3772-4c34-a749-03b536136330	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
6857fb62-e975-4d26-8bf2-44d0a075abe9	t	f	2022-02-11 00:00:00	\N	K7	362e2fb2-b855-4847-9027-d486924b1931	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
3295c961-c4ae-410c-9704-6f41e7011444	t	f	2022-02-11 00:00:00	\N	K6	1984714f-3b14-4e8a-b8b8-aa60564f7618	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
d0ac8510-f311-41dc-a55c-336b6a30ffc3	t	f	2022-02-11 00:00:00	\N	K5A	9a756b35-cad5-4eb6-8eee-d8f194a9682c	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
c3bfa2f0-6f8a-4002-9634-2e1aae347140	t	f	2022-01-22 00:00:00	\N	KEIN_START	048ae246-167f-4b2d-a737-9b9c236f002b	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	87	\N	\N	\N	STARTET	\N
9803092b-e433-4a12-9007-de6229d086c5	t	f	2022-02-06 00:00:00	\N	K5A	7339e402-4a3a-4298-ae18-c97cf15433d1	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
a20a03cf-cf1c-486e-b9eb-3a239cd719d3	t	f	2022-02-06 00:00:00	\N	K5A	9101091b-5a65-4a04-8b23-9deacce2a7ac	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
b0492f82-22d7-4c5a-9897-6dfafde4360c	t	f	2022-02-06 00:00:00	\N	K5A	4cfc24a3-1f5b-4aad-bc7c-3a9b25338fc0	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
1599edef-7007-40f3-8e9f-659c6d1c7136	t	f	2022-02-06 00:00:00	\N	K3	6e648320-a8bc-4ce8-80ff-7c0fc4fc7c17	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
53563010-3f5c-44ad-8ded-1840906ae3da	t	f	2022-02-06 00:00:00	\N	K1	877359bb-d323-4184-b585-65c4c84a72b5	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
f77be05e-0c34-4514-9eb3-bc49a4bd11b2	t	f	2022-02-07 00:00:00	\N	K1	408133b2-4da0-4b73-8501-1fb5b1022518	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
f9b86d4f-205b-49a6-b548-e34032f543a9	t	f	2022-02-07 00:00:00	\N	K4	d59f58c9-abd6-4ef4-9d90-6b0f59be660b	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
adde6adc-ee1d-4252-827a-1368ae00f4b1	t	f	2022-02-07 00:00:00	\N	K4	e63e5adb-ca59-406f-9cd6-88f18f2c6a59	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
10aed76d-07b5-484a-abbe-2b2bafda25c3	t	f	2022-02-07 00:00:00	\N	K4	82f13411-54a6-4504-bbbb-a706199d08c1	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
d4529c59-c782-4bcc-a27e-8c823b5a604f	t	f	2022-02-07 00:00:00	\N	K4	926b606f-e318-43ad-a853-25bb243a12da	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
cffa5367-c224-4bbf-a38f-b5ea43c3c322	t	f	2022-02-07 00:00:00	\N	K6	a7a1b9da-83a5-4c35-93c9-4dd2c3b4c213	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
db90d30a-3646-4892-8512-cbb9d1df760f	t	f	2022-02-07 00:00:00	\N	K6	a2d598f4-edad-4d89-aaad-21f28e2a5f4b	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
c0a8d9f9-4ea3-402f-9fea-f7b91c42726c	t	f	2022-02-07 00:00:00	\N	K4	f03dc8d9-9990-40de-8939-005eae51dc59	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
a16f6cf2-a459-44d4-a170-976b087b7c75	t	f	2022-02-07 00:00:00	\N	K1	77bcb01b-a107-4cc4-baaa-afcf41cb24ce	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
990d7ea9-517e-4f32-91ea-521a7ccd9afb	t	f	2022-02-07 00:00:00	\N	K2	fcc579cd-84ed-495d-a64c-6e66f8ac647d	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
50af417a-0385-4351-af72-a269610d5ed1	t	f	2022-02-07 00:00:00	\N	K3	b0824277-60c5-4b51-95f3-85fd499f3230	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
768b2a02-6341-4df8-b6a6-186e5e43695c	t	f	2022-02-07 00:00:00	\N	K4	d2b82c0c-c2bc-4b2d-84e8-f7e33d084196	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
863e43be-33bc-4129-843e-63b2cdfadd32	t	f	2022-02-07 00:00:00	\N	K5A	bb11cca0-d64c-4c97-b747-1b7459293dcd	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
b9508dae-07bf-4975-938b-57e8264ef340	t	f	2022-02-07 00:00:00	\N	K2	535aa577-84a9-4fb3-9f74-c6b3a4db6f4e	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
7e062d4f-09b3-4755-aa24-ce7385760071	t	f	2022-02-07 00:00:00	\N	K4	cd236b71-101b-46ee-83dd-6ef5b64d3621	0fa002f3-d432-46d4-a753-991d021db3fa	5ee987b5-deec-4087-b36f-bba4dcaf842f	\N	\N	\N	\N	STARTET	\N
b6a4abb7-0b41-4663-b289-598b0a97e81d	t	f	2022-02-07 00:00:00	\N	K5B	133d564b-e9dd-4f84-ba27-45ca1681441e	0fa002f3-d432-46d4-a753-991d021db3fa	5ee987b5-deec-4087-b36f-bba4dcaf842f	\N	\N	\N	\N	STARTET	\N
95e3f5b7-66d8-4894-a351-fd2ed4283b86	t	f	2022-02-07 00:00:00	\N	K3	464aa6fb-4e31-40fa-9c77-1547e32685df	0fa002f3-d432-46d4-a753-991d021db3fa	5ee987b5-deec-4087-b36f-bba4dcaf842f	\N	\N	\N	\N	STARTET	\N
4d4b0143-3eb1-4b9a-8d7c-4feae93f9b8f	t	f	2022-02-07 00:00:00	\N	K2	817de2dd-5eb4-4a38-9802-4425f236ab49	0fa002f3-d432-46d4-a753-991d021db3fa	5ee987b5-deec-4087-b36f-bba4dcaf842f	\N	\N	\N	\N	STARTET	\N
3c9cd14b-3424-4a99-9fcc-74c0198d8a30	t	f	2022-02-07 00:00:00	\N	K2	36c823d3-7d2b-491c-ab1b-b0782936e463	0fa002f3-d432-46d4-a753-991d021db3fa	5ee987b5-deec-4087-b36f-bba4dcaf842f	\N	\N	\N	\N	STARTET	\N
a48176cd-7804-47e6-ad13-2e8146df0bd7	t	f	2022-02-07 00:00:00	\N	K2	95ed01ae-10f2-4b6c-8ccf-7c211815a956	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
572c9e36-d92c-4844-b408-6f933ca5ad69	t	f	2022-02-07 00:00:00	\N	K3	f2d7bd24-578c-4c58-acc0-274800e48233	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
3dbc7580-e74f-4f74-ae18-07d731c4f92a	t	f	2022-02-07 00:00:00	\N	K3	629aaf31-432d-4ac4-a6c1-0c3d342b5543	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
50a904ac-0472-4a58-993e-5fda78ced72a	t	f	2022-02-07 00:00:00	\N	K4	eefbb597-5d31-46c0-8410-4298f308e081	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
7fa5b41f-b098-4127-ae85-71db73969f2b	t	f	2022-02-07 00:00:00	\N	K3	60f70e2e-6978-4e6b-b95b-7b56f4cf94cf	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
de8c48eb-2572-4bfa-bac5-e0c2fe637851	t	f	2022-02-07 00:00:00	\N	K4	a2ab38ab-0c73-42db-bfd4-6758e3be9505	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
84776cef-46c4-446f-ade8-a944603c0304	t	f	2022-02-07 00:00:00	\N	K2	6c68c776-7076-4db3-b8f5-572eb6fd81ba	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
6354da41-3359-4738-a749-18ba2d71ffd2	t	f	2022-02-07 00:00:00	\N	K3	69630e2c-e72c-4954-98aa-25cf15e2ae37	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
e731bd04-1e0a-4ab4-9902-22a1a22f50de	t	f	2022-02-01 00:00:00	\N	K1	807c7656-f973-4abf-b23f-88521024be01	b7440787-50bd-4e41-b38b-48acf37af0de	2fc3365b-34d9-4054-b2d8-aa859c7455e7	210	\N	\N	\N	STARTET	\N
98023282-ff5c-482f-875a-d5c8bdd31b4d	t	f	2022-02-10 00:00:00	\N	K2	c1811d92-27e1-4af9-aadf-c37c470d786f	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
33061b51-0ef3-4e70-b99f-de0e1b3f1e47	t	f	2022-01-20 00:00:00	\N	K3	fcd79d30-7590-46b9-b332-b0f30f373753	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	64	\N	\N	\N	\N	\N
fcddd93f-6b16-4c59-8fad-17c803d5d325	t	f	2022-02-10 00:00:00	\N	K1	af92249a-5a95-4e07-8ad2-2eadfb148c3d	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
31dccdfd-bb9f-487b-acac-8613eb068807	t	f	2022-02-10 00:00:00	\N	K3	3d826b0d-3d90-4afe-85ad-b4c14ad92e98	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
74ec253e-4c67-4abb-9b14-928c38aa1ab5	t	f	2022-02-10 00:00:00	\N	K1	b611df06-6517-4a13-a70a-6dbe3ed8eae2	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
be14ef1c-2f35-44cf-b3a0-cc67d5295075	t	f	2022-02-10 00:00:00	\N	K3	92f57cee-d46b-4050-ad58-23de93dec16e	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
dd192cc7-b4d0-4eb1-b697-5cb5bed98953	t	f	2022-02-10 00:00:00	\N	K6	d629ae8e-527f-43bb-9acb-1de7b10ca838	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
d81473a3-2f09-4232-b5bd-d7c7e2ea8082	t	f	2022-02-10 00:00:00	\N	K1	00c6b0c3-6141-4eec-b065-3a2d5bc9f3f3	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
37bd1812-cf4c-4921-83b0-e7f63dbea152	t	f	2022-02-10 00:00:00	\N	K2	7c9b0b76-97b9-4d5e-b052-b84f1394a088	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
d32fe80c-91f3-4dcb-904e-b6a4728dba66	t	f	2022-01-28 00:00:00	\N	K5	2a8b0a61-8a51-47cc-840d-bb8f2df430a9	b7440787-50bd-4e41-b38b-48acf37af0de	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	153	\N	\N	\N	STARTET	\N
b6c674b7-3f7d-4dd2-8f73-333cee2df38c	t	f	2022-01-28 00:00:00	\N	K3	25ea10eb-fe1e-4c2d-a389-478ade1ec4bf	b7440787-50bd-4e41-b38b-48acf37af0de	86a39d76-71ed-4890-82ec-ce2a48d32627	154	\N	\N	\N	STARTET	\N
3ec0ae77-c8d8-41b7-bb4b-dcac58254a3f	t	f	2022-01-28 00:00:00	\N	K2	8eff3577-8500-4dff-93a5-faa4d33fa2e3	b7440787-50bd-4e41-b38b-48acf37af0de	86a39d76-71ed-4890-82ec-ce2a48d32627	155	\N	\N	\N	STARTET	\N
84ae15e4-fa2c-411c-b323-bca2191ee9cf	t	f	2022-01-29 00:00:00	\N	K1	56472a30-b319-4304-a86b-0eced54ede6c	b7440787-50bd-4e41-b38b-48acf37af0de	a5302a2b-d270-49e5-9876-47c84cb38038	156	\N	\N	\N	STARTET	\N
27aff250-3410-4481-b23d-5ef0e67559b9	t	f	2022-01-29 00:00:00	\N	K5	a5d567e3-5134-4a77-a739-019c4b90404a	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	157	\N	\N	\N	STARTET	\N
3a8deea6-b016-4800-b70a-cef3e8061c73	t	f	2022-01-29 00:00:00	\N	K5	688c540f-f846-437b-9884-875d19b83002	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	158	\N	\N	\N	STARTET	\N
9da78c70-d1bc-422f-ba58-83d2b2cdef99	t	f	2022-01-29 00:00:00	\N	K2	7f322799-cd31-402a-b52f-e49d01f09993	b7440787-50bd-4e41-b38b-48acf37af0de	80c08ccc-c90e-4377-af3b-2de779197c7a	159	\N	\N	\N	STARTET	\N
270fb37a-9443-4ae7-8fed-842fa949f6cf	t	f	2022-02-10 00:00:00	\N	K2	0745244f-f816-40c0-9b1a-102fb6634fb7	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
57da2f0d-b2af-4c59-8c59-47de488cc90f	t	f	2022-01-30 00:00:00	\N	K5	21e88cf6-63bd-4b12-af51-eb7c53f22ef4	b7440787-50bd-4e41-b38b-48acf37af0de	4e9262a1-fef9-4701-9c91-1b3016ee971d	161	\N	\N	\N	STARTET	\N
938ce6fd-b0f2-4b10-afbe-97707a471695	t	f	2022-02-10 00:00:00	\N	K2	748aac10-5d59-4a9d-850f-942198fdae91	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
1503f402-ef14-4e11-a9c6-834f81bfbc68	t	f	2022-02-10 00:00:00	\N	K5A	81d5230e-58d7-4d37-bf60-291fab6f512b	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
ba1ed808-371e-4c91-8658-ac8bfd9adb61	t	f	2022-02-10 00:00:00	\N	K1	9968c3c6-6624-4fbe-bd63-0fb7c67526cd	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
7abe604f-0f8f-4d0d-9e08-75c7f2fbce2d	t	f	2022-02-10 00:00:00	\N	K2	730cd9c8-376f-4ede-82f2-f2d260318cb0	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
3d2956dd-5d3c-4f17-b96c-fc2bb7b6ac62	t	f	2022-02-10 00:00:00	\N	K3	a0ff3547-1a31-45dc-924f-05befa26ab2d	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
0cfd0227-9d7e-4602-b3be-9edd2aa37a1a	t	f	2022-02-10 00:00:00	\N	K3	c8b2e25d-65ad-449c-9d08-39a841affe30	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
efef26cd-1eb5-4178-8426-80ace7d0c436	t	f	2022-02-10 00:00:00	\N	KEIN_START	b668083c-9f54-4787-8b7a-09b866ba5e19	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
ad2f6fa1-6716-4fc6-ba26-6f3fab268556	t	f	2022-02-11 00:00:00	\N	K1	03f98ac2-a789-49de-a7cb-48d9915ce1ea	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
8735f25d-fb10-4824-9f16-6eeb2ebf2b6b	t	f	2022-02-11 00:00:00	\N	K4	14a46695-e8de-4479-bf94-ab902d9dd17b	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
c3bc33ed-cfb3-4162-8354-998aa47d8bc5	t	f	2022-02-11 00:00:00	\N	K4	b6a049a3-2b7c-4fa6-b4ef-9c3bd65d2b8b	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
af826147-4cf2-4fbf-8e8b-02995bb4d655	t	f	2022-02-11 00:00:00	\N	K1	74fdc348-773d-4d75-b34c-1df86b926f7c	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
a0852bb5-27db-49e2-8bd0-2217db4db474	t	f	2022-02-11 00:00:00	\N	K4	fc1b9b26-2fdb-4bd2-9a3f-b8c411f4b2bd	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
563b661f-fc4d-4b6e-bbc0-bed6bdc3117b	t	f	2022-02-11 00:00:00	\N	K4	3851d97c-9b65-4c71-aa16-268ff751199f	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
f1a366d1-5ee7-45c7-be4d-cb2b3d89b0f2	t	f	2022-01-22 00:00:00	\N	K1	056b99cb-c46d-4a05-aa6a-efbca6a73941	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	88	\N	\N	\N	STARTET	\N
6be00e2f-9835-4585-b4ca-8d7e2bf800d4	t	f	2022-02-07 00:00:00	\N	KEIN_START	7676576c-1502-448f-bbc4-c5ef0fbdb32c	0fa002f3-d432-46d4-a753-991d021db3fa	5ee987b5-deec-4087-b36f-bba4dcaf842f	\N	\N	\N	\N	STARTET	\N
a680ce55-fdb8-4ce2-8a7d-ef253cacb987	t	f	2022-02-06 00:00:00	\N	K1	cf92e3e7-201f-4998-9415-af34fe635aea	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
d40a1f22-16c5-48d6-b515-069250647344	t	f	2022-02-06 00:00:00	\N	K3	0485d367-39ac-444f-8256-530e2248c9e0	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
ed90b454-adee-4328-adad-bbae52cd7ea9	t	f	2022-02-06 00:00:00	\N	K3	451ddc55-c9c9-41de-b0b7-b3e99481c753	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
21c85dba-a8b8-4b44-93a6-de255689ee7e	t	f	2022-02-06 00:00:00	\N	K7	f15aa673-3039-494a-8187-47745bf73bdb	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
49fd25ca-438c-42e8-a389-e5e7e5c8a1c3	t	f	2022-02-06 00:00:00	\N	K5A	a882acde-5494-41cd-99e4-b0a2a1f1eef4	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
6a3569c6-06d1-4903-9c35-b23aca145932	t	f	2022-02-07 00:00:00	\N	K1	60e7088d-9afe-437c-990d-73bfd9ba2ecd	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
3218543d-66a8-4ac8-918d-379c615c57d9	t	f	2022-02-07 00:00:00	\N	K6	a1a9d8d1-440c-4dca-ac15-7a072d6bb21b	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
263c2a77-3a74-439e-b04a-c239af0d50d7	t	f	2022-02-07 00:00:00	\N	K4	1b551c76-9304-4df8-8958-759b76f694ac	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
b0c03dae-36ec-4872-844a-f6a821e7e54f	t	f	2022-02-07 00:00:00	\N	K1	d77d6a91-3bb7-414f-9280-176d4bf0b1ea	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
8a54b27e-14df-4d17-8d2d-4ab442c39e51	t	f	2022-02-07 00:00:00	\N	K1	4e352882-165d-451a-9e98-24fc4da3b585	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
2905772f-e4ef-46d6-a9a1-0bbdf5b70adc	t	f	2022-02-07 00:00:00	\N	K5B	041c344c-5c7d-4c9e-a9b1-478d5990d9b5	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
cbbe8510-e77d-4c27-a0fd-dbee2a2b91a4	t	f	2022-02-07 00:00:00	\N	K5B	f0ca7fdc-3076-40cd-ae10-590096c8ea2f	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
91bf600d-3376-498c-ac5d-4acbe60de5b8	t	f	2022-02-07 00:00:00	\N	K4	0922884e-c036-4ba8-8d62-424ae6cfef2b	0fa002f3-d432-46d4-a753-991d021db3fa	5ee987b5-deec-4087-b36f-bba4dcaf842f	\N	\N	\N	\N	STARTET	\N
f0faae55-66d8-49f9-ba18-366d8d23af5d	t	f	2022-02-07 00:00:00	\N	K3	806ed6d9-5c8e-455f-bd95-9f641dc306a2	0fa002f3-d432-46d4-a753-991d021db3fa	5ee987b5-deec-4087-b36f-bba4dcaf842f	\N	\N	\N	\N	STARTET	\N
022e7e07-a7f0-458d-85cc-1d6e156a0a4f	t	f	2022-02-07 00:00:00	\N	K2	a2b1e085-3c64-4662-a037-25ea43ed9977	0fa002f3-d432-46d4-a753-991d021db3fa	5ee987b5-deec-4087-b36f-bba4dcaf842f	\N	\N	\N	\N	STARTET	\N
0239267e-94d4-413f-a070-c5eb8c287419	t	f	2022-02-07 00:00:00	\N	K2	7de2e045-f7ff-4636-b005-f374de49838f	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
6b59c5d6-2dee-40c1-b07e-dd892d81fc28	t	f	2022-02-07 00:00:00	\N	K6	601cea8b-2321-4666-9409-6d910b843cc8	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
c672c6ae-823a-4b7e-a78b-85b67cb0f8c3	t	f	2022-02-07 00:00:00	\N	K5A	df3501e6-5b5a-480b-b598-b656d951bfcf	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
424d78ee-0f42-4d40-9a14-cd7d47203300	t	f	2022-02-07 00:00:00	\N	K1	23e029ae-c87e-42c5-a094-49d7044012bb	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
032d79d7-8cdc-4184-b409-459c33c40132	t	f	2022-02-07 00:00:00	\N	K5A	bcaad1d0-181a-4d1d-8e70-eaba23f8a120	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
85575da7-6dcc-49c8-8016-20c26700251a	t	f	2022-02-07 00:00:00	\N	K2	f4f15fb5-372f-4f19-b473-bd42f628b0b1	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
41b12cb8-b08b-41ad-ab15-f44423e90282	t	f	2022-02-07 00:00:00	\N	K1	bea146f0-eb58-4986-ba4d-32459162ad63	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
76a60ee2-4a7f-414e-8b1e-0dbd111334ba	t	f	2022-02-07 00:00:00	\N	K4	fe5928f5-b863-4e8a-b170-de189592be4a	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
756aef62-8aca-4714-a5ec-f91bf89fb0c5	t	f	2022-02-07 00:00:00	\N	K2	3e64f178-827a-4e4c-8e00-b77622444ead	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
599e7f1c-9272-4f6a-a9a8-c024227cafaf	t	f	2022-02-07 00:00:00	\N	K5A	1cf3987f-f6cc-49db-9c5d-ab9db5eadcf0	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
578b9fed-f452-451b-9670-e8b21d556ca8	t	f	2022-02-07 00:00:00	\N	K5B	328524d2-a693-4bf5-ab73-f3f37046035b	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
fc1cf727-e9b7-4cd4-b0d5-0638df5991a4	t	f	2022-01-31 00:00:00	\N	K7	03d40032-ff06-439a-ac1a-6eb2edac789b	b7440787-50bd-4e41-b38b-48acf37af0de	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	226	\N	\N	\N	STARTET	\N
53222b82-71f5-4eda-bb4c-176ce0c52869	t	f	2022-02-10 00:00:00	\N	K2	92613163-8bfc-4490-aa2d-af64c7a4fc72	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
113d0b97-eb43-4755-b7a9-63b765215505	t	f	2022-02-10 00:00:00	\N	K3	8f5bdaeb-1b7f-4994-a0e0-6094b5c58ead	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
9960a161-d112-4ad2-a0dc-e44cd235a7a1	t	f	2022-02-06 00:00:00	\N	KD	23c379ab-5c86-479c-94e0-e1cbd5164acc	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
86636bbe-3fee-456e-958e-d1b2c265d33b	t	f	2022-02-10 00:00:00	\N	K5A	b8fb2865-aa6b-4391-aeee-8db904eedf28	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
9d822c4e-a6ac-4ef6-a02e-7298c1555a17	t	f	2022-02-10 00:00:00	\N	K1	40ccb443-9e71-4f3c-937d-eb6d1d336e26	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
e18b4dce-7b2e-487d-a8ea-9c01e67b7369	t	f	2022-02-10 00:00:00	\N	K1	f927df83-a6e2-4397-8912-3fcbbd640ebb	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
a0c1a69a-33c9-4899-a9fb-ad1f90dee071	t	f	2022-02-10 00:00:00	\N	K1	c6a8e41b-9da6-49af-afd0-54b3ea9c28ff	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
53b0b6ee-7a13-4247-9d92-e9d59be6173f	t	f	2022-01-28 00:00:00	\N	K6	19e3f121-7083-44cd-8c12-7c44f05fe500	b7440787-50bd-4e41-b38b-48acf37af0de	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	162	\N	\N	\N	STARTET	\N
a0e0f526-9894-45dd-980e-6aac5d9289e3	t	f	2022-01-29 00:00:00	\N	K5	54cf958b-d32f-4f4a-ad2c-8631dcb02d4c	b7440787-50bd-4e41-b38b-48acf37af0de	a5302a2b-d270-49e5-9876-47c84cb38038	164	\N	\N	\N	STARTET	\N
2d9ecbc5-9c65-407d-81d1-dfd9cf2dc2e4	t	f	2022-01-29 00:00:00	\N	K1	b4c08eda-6c89-4078-bca0-5e994bb233ad	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	165	\N	\N	\N	STARTET	\N
5a1d9765-f438-480a-8b58-9eb7631e7978	t	f	2022-01-29 00:00:00	\N	K2	d07fba0a-40a9-4b74-a6f8-e8227e6f47e1	b7440787-50bd-4e41-b38b-48acf37af0de	80c08ccc-c90e-4377-af3b-2de779197c7a	166	\N	\N	\N	STARTET	\N
c6ee25ba-a58e-4cf8-b090-1cffc1800b29	t	f	2022-01-30 00:00:00	\N	K3	bed78fb6-a0d8-4214-b76c-9a20c023e09d	b7440787-50bd-4e41-b38b-48acf37af0de	4e9262a1-fef9-4701-9c91-1b3016ee971d	167	\N	\N	\N	STARTET	\N
a4583186-6676-4009-bc4e-87d069f57888	t	f	2022-02-10 00:00:00	\N	K2	226cec1e-312b-42ad-bb62-7e582e7d590d	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
ab2f6702-4868-4477-b880-6ff23353a68c	t	f	2022-02-10 00:00:00	\N	K2	d01fcdbe-4deb-4c39-bfea-aee0e3b915b5	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
71f62881-fc48-447c-a726-fb2121c39f09	t	f	2022-02-10 00:00:00	\N	K3	a5790b87-a247-4938-8f62-d854f2953fc1	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
009bdb84-75fa-4966-beab-bf730e3a4b35	t	f	2022-02-10 00:00:00	\N	K4	6f5edf06-9cbc-4d08-a7b1-88f0e8d8ae35	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
270f8bcf-dc17-4543-a0d5-024abb094c76	t	f	2022-02-10 00:00:00	\N	K4	5b95f7b0-3a83-4080-8185-77f995be163b	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
90626c6e-e81c-45fa-b6fe-84b5709ef76f	t	f	2022-02-10 00:00:00	\N	K5B	d5e46bba-7a13-487c-9aea-180157fd8a02	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
0778527b-c627-4b4b-8464-7f41be4341a5	t	f	2022-02-10 00:00:00	\N	K5B	a5bd5afb-944a-4c17-9497-aa955d2a8548	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
ded64c4d-7ce7-4f0c-a0cf-ddb0da84e473	t	f	2022-02-10 00:00:00	\N	K5A	5ebd82a3-cdde-4437-a80c-93c4e71c80d4	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
2dbb708c-587b-4dce-9804-1831eb712bdc	t	f	2022-02-10 00:00:00	\N	K5A	482b3c30-5be6-4492-a5cb-7ad1f89150f7	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
4ed2add7-d4cf-4fae-855d-92ee57bc3eeb	t	f	2022-02-10 00:00:00	\N	K1	8e6f5cd7-45da-4904-8e25-6caec080e74d	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
6b325e45-5c0e-4ea7-995d-7992fc9701e0	t	f	2022-02-10 00:00:00	\N	K3	3232a4ee-1e57-4aba-852e-c96d18e17723	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
fe12069e-f685-45fc-81a9-946d38d123a7	t	f	2022-02-10 00:00:00	\N	K3	66fe8b79-f2df-4082-af61-f17a076ce9dd	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
e24ab80a-aa57-4e00-8ce8-b68828b3266b	t	f	2022-02-11 00:00:00	\N	K1	773fb237-0f8a-468b-9b5c-54e5141e274d	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
4bc236ec-f280-4090-a2c5-bfd4421afb7d	t	f	2022-02-11 00:00:00	\N	K4	af4daa16-8933-4a4e-b858-fb98e95b1150	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
e3dd96d3-8bc3-4443-9943-4cb3c384dba3	t	f	2022-02-11 00:00:00	\N	K4	0021e65a-9804-4f1d-baa0-f5b9b3a6e74a	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
7b7e049e-7178-4497-bfbd-446392f49278	t	f	2022-02-11 00:00:00	\N	K5A	e621c97a-37b8-43c6-8120-1d7a09068eba	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
e3fef206-bc30-4d4f-acdf-aec5a4251a8c	t	f	2022-02-11 00:00:00	\N	K4	512512f6-b606-46a2-b179-0040cc97b7ab	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
52f20f7d-4138-4940-acf6-d0dd2cd6bce4	t	f	2022-02-11 00:00:00	\N	K3	e491e655-63e1-40ed-b732-a733a78f3e00	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
ee3a18fe-8666-473c-8b74-e4235a7c4843	t	f	2022-02-11 00:00:00	\N	K4	ccfcf749-8860-48e3-87a6-277461c9c4c7	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
931c5df6-0792-4939-bd38-554ca3bc2651	t	f	2022-01-28 00:00:00	\N	K5	9ed30a96-af19-43db-89f3-73ca4df8b908	b7440787-50bd-4e41-b38b-48acf37af0de	852ccab3-35f6-4d12-815c-d8b66ff664b7	163	\N	\N	\N	STARTET	\N
02b8077b-84ff-470b-8f55-93b1a5cdbe01	t	f	2022-01-28 00:00:00	\N	K5	98412219-6445-40a2-b56a-f7f38a4b16ff	b7440787-50bd-4e41-b38b-48acf37af0de	852ccab3-35f6-4d12-815c-d8b66ff664b7	169	\N	\N	\N	STARTET	\N
88702ebb-e184-45a2-9083-cede0e52eaec	t	f	2022-02-06 00:00:00	\N	K3	8c213cc6-47a1-4a94-9800-7e050e398ca9	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
84e55027-e761-4a88-9ff9-af284e14fc4f	t	f	2022-02-06 00:00:00	\N	K2	af32f4b2-a4e5-4fad-be72-f947b978f9f7	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
31fcdac4-6523-4ca5-af5d-bac5ada71f04	t	f	2022-02-06 00:00:00	\N	K4	cb21ee21-052c-46cc-a234-80b7930f82e7	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
1aecd405-35e3-4ea4-8533-ff6476b6fb81	t	f	2022-02-06 00:00:00	\N	K7	4c44b26b-75b5-454a-9523-d1a13668c60b	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
e6ec997d-acee-4739-8850-66b3a44cc40f	t	f	2022-02-06 00:00:00	\N	K2	4a26fee1-2e72-4c02-a2da-a48208956430	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
0bbad991-56ba-47e6-a611-334b50e4e9dd	t	f	2022-02-06 00:00:00	\N	K1	9ae29252-dfb9-4f54-b9bf-acd7f963280f	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
8cf1969e-3695-4448-bbbf-dd677426eac6	t	f	2022-02-06 00:00:00	\N	K5A	46ad8cc8-c402-4b31-876d-4d903dbf0bc4	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
41b104c6-8ff5-4258-8c47-36fa5560fe82	t	f	2022-02-06 00:00:00	\N	K5A	c89c90ff-9a8c-4b8c-94fe-f21a96938dd9	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
4c26a637-96a3-4c01-ba86-f71928a7f025	t	f	2022-02-07 00:00:00	\N	K1	9f019d48-0aaa-463f-a64d-75d6c2862e1c	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
d0953d05-ea66-4c63-83db-39cdcce3f3bc	t	f	2022-02-07 00:00:00	\N	K6	60cc1f98-66f1-4276-9b86-909635e50da9	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
c5890889-fa8e-4768-b096-7fd2ca1d9f7f	t	f	2022-02-07 00:00:00	\N	K1	7da99a41-60b7-487b-aaee-28785c2ad111	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
530ebe90-91ce-46ea-86b2-cb9cfb0f8e98	t	f	2022-02-07 00:00:00	\N	K1	4ffc6756-ef8c-4fc2-83be-556f03df49f2	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
95406ba8-667c-4dc3-b814-328980756190	t	f	2022-02-07 00:00:00	\N	K3	6bd0fcda-e6c5-49ff-8cd3-eca6284ec8ed	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
a16eb770-802f-4214-b674-2f69d66b0703	t	f	2022-02-07 00:00:00	\N	K5B	266f5bd3-966e-439a-b675-215b3a31f976	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
4b7ca48e-482f-41c6-87a2-821eea13967d	t	f	2022-02-07 00:00:00	\N	K5B	a79d430f-c64b-4c02-aac4-ccf6ccd0f6e1	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
09ec9135-09eb-4745-84b2-6a138ac91794	t	f	2022-02-01 00:00:00	\N	K4	87b31861-73b3-4b21-a924-1b33f8e3880c	b7440787-50bd-4e41-b38b-48acf37af0de	2fc3365b-34d9-4054-b2d8-aa859c7455e7	248	\N	\N	\N	STARTET	\N
501c7fef-8f57-42e2-9034-f6cdccb61bef	t	f	2022-01-20 00:00:00	\N	K5	8b49f6f9-d79a-4897-a200-4b386fe350e3	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	65	\N	\N	\N	\N	\N
63ee5118-04aa-4c24-8452-687944252a73	t	f	2022-01-20 00:00:00	\N	K6	4e732183-e839-4bcf-9a5b-e507bb5f9a03	b7440787-50bd-4e41-b38b-48acf37af0de	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	66	\N	\N	\N	\N	\N
87f9c6d6-4ef7-4fb2-8f27-11082d569531	t	f	2022-01-20 00:00:00	\N	KH	bbeb3d70-1dd8-4e90-8d76-88c96cdac44e	b7440787-50bd-4e41-b38b-48acf37af0de	81308200-79d0-466c-a19a-ca3fbef6045a	67	\N	\N	\N	\N	\N
0aeb5c6a-613f-4cbe-9194-7f299a5a8162	t	f	2022-01-20 00:00:00	\N	KH	01030c92-61c5-4f79-8212-3a55173d20a2	b7440787-50bd-4e41-b38b-48acf37af0de	81308200-79d0-466c-a19a-ca3fbef6045a	68	\N	\N	\N	\N	\N
0f97ecf5-4c2a-4401-920d-aab5ce871d4b	t	f	2022-01-20 00:00:00	\N	K3	8d15484c-5014-42c7-b493-f0b6579978c2	b7440787-50bd-4e41-b38b-48acf37af0de	81308200-79d0-466c-a19a-ca3fbef6045a	69	\N	\N	\N	\N	\N
51741fca-c0a4-403e-9d41-43905c83fc66	t	f	2022-01-20 00:00:00	\N	K3	3409cfd5-f7e4-4c8c-925d-ee2ddba3cf14	b7440787-50bd-4e41-b38b-48acf37af0de	81308200-79d0-466c-a19a-ca3fbef6045a	70	\N	\N	\N	\N	\N
cb04a3f3-8d10-4059-a476-36f55dd237e8	t	f	2022-01-20 00:00:00	\N	K3	e4b88a97-f310-4b22-8af8-d33c896dabf0	b7440787-50bd-4e41-b38b-48acf37af0de	81308200-79d0-466c-a19a-ca3fbef6045a	71	\N	\N	\N	\N	\N
8326ae41-4438-4448-9e6c-be7611ac489d	t	f	2022-01-20 00:00:00	\N	K1	b82f2f24-5c23-4249-9413-02783705d856	b7440787-50bd-4e41-b38b-48acf37af0de	81308200-79d0-466c-a19a-ca3fbef6045a	72	\N	\N	\N	\N	\N
dcae4301-ee71-4b60-a84e-73bef41e132f	t	f	2022-01-22 00:00:00	\N	K5	b437e6cc-1184-44f5-ba23-558e718213a4	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	73	\N	\N	\N	\N	\N
f777a164-7a4e-4f63-8649-a5501c75cb36	t	f	2022-01-22 00:00:00	\N	K3	6b4dd7dc-ece8-4433-9d23-16a2928e8829	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	74	\N	\N	\N	\N	\N
09a5fbd4-939c-4c9f-8011-26ce6e657975	t	f	2022-01-22 00:00:00	\N	K5	e39700e8-07a8-4fd5-9bc3-b128ee229568	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	75	\N	\N	\N	\N	\N
230e2fea-30c8-4bbe-8e61-03b554e67ad9	t	f	2022-01-22 00:00:00	\N	K3	354b2ec6-febd-4c82-8ce0-cb8abc99262a	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	76	\N	\N	\N	\N	\N
9e71cdf4-5684-4641-b804-3e0bd4c58d24	t	f	2022-01-22 00:00:00	\N	K5	2a495017-a1ec-4997-b0ff-b5f5b1292eaa	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	77	\N	\N	\N	\N	\N
2fe9f830-6c7a-4a26-87eb-74cdd96ebf0e	t	f	2022-02-10 00:00:00	\N	K2	e4565881-aa88-4903-88fe-5cbbae005638	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
3fd7a400-a1a4-4df8-ae16-1c3a6243f828	t	f	2022-02-10 00:00:00	\N	K2	75a9b37c-1f59-4dbc-8ef0-64397367e520	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
96e741bc-03b0-4b92-9845-501b909900e2	t	f	2022-02-10 00:00:00	\N	K3	a49caede-ef45-4644-8651-e0c20981003a	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
fd9df68e-1d69-4f7f-86b0-48650e319142	t	f	2022-02-10 00:00:00	\N	K6	4704aded-5bfb-4e70-b381-cf912524859a	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
70ae7914-78a8-4af7-a6e1-82f7a358d7d9	t	f	2022-02-10 00:00:00	\N	K7	75b7f508-ab0d-4b64-ae47-bc251362c013	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
5d6adc88-69e6-4e5b-aa46-f01b6d9ebc5e	t	f	2022-02-10 00:00:00	\N	K2	c1358ce6-29dc-41a3-a780-a5c48ae1b56f	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
e47afb3d-ba95-495e-a55e-a9f8a3d420a1	t	f	2022-02-10 00:00:00	\N	K3	29ffbb9b-dcc7-4571-8087-4c08ef784bc3	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
9a46d58a-ead9-408d-8d97-c530460d172a	t	f	2022-02-10 00:00:00	\N	K4	80afde5c-229d-4a0c-820f-8c383eb323c3	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
36e6c6e9-acc9-4e83-86d3-364a25957a57	t	f	2022-02-10 00:00:00	\N	K5B	9b1b0d17-faa2-4e32-a7bb-ae13d77ca0fe	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
a93240df-14dd-49a8-b9dc-f0779186202e	t	f	2022-01-28 00:00:00	\N	K3	ca588032-b5f0-4e01-b110-d2604ac0e738	b7440787-50bd-4e41-b38b-48acf37af0de	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	168	\N	\N	\N	STARTET	\N
b57f32ab-9051-41af-92a7-7a971ab46b77	t	f	2022-01-29 00:00:00	\N	K2	f24aa5e9-e827-45a8-9644-2745b5a1d6dd	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	170	\N	\N	\N	STARTET	\N
ac2a8dba-6480-4a52-afa2-48742d7d7434	t	f	2022-01-29 00:00:00	\N	K4	adcce6c1-2fe3-4199-9f9d-222464c36ef5	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	171	\N	\N	\N	STARTET	\N
a1810fe3-9c11-485e-adda-6004d2d27190	t	f	2022-01-29 00:00:00	\N	K6	b1ce1724-b0cd-412f-b359-8539992a2cdc	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	172	\N	\N	\N	STARTET	\N
64b2656e-4fb1-4047-a773-5f019403714b	t	f	2022-01-29 00:00:00	\N	K7	c33749e2-6b2a-40cf-a699-fbaa97c1a492	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	173	\N	\N	\N	STARTET	\N
0f8a6273-5bd7-42a6-804b-41832c968e24	t	f	2022-01-30 00:00:00	\N	K3	8a7f4911-b143-4c6b-9cda-40c426158f0d	b7440787-50bd-4e41-b38b-48acf37af0de	1030974d-cffe-46d6-b6ea-79c8839cf2ea	174	\N	\N	\N	STARTET	\N
870d7588-21a0-47af-86f2-35219802bb05	t	f	2022-01-30 00:00:00	\N	K5	1022eb37-6cdf-4028-beff-91395e4d2105	b7440787-50bd-4e41-b38b-48acf37af0de	4e9262a1-fef9-4701-9c91-1b3016ee971d	175	\N	\N	\N	STARTET	\N
03e7e9c4-bc39-48b8-9542-705011e041e2	t	f	2022-01-11 00:00:00	\N	K5	daa197bf-60ea-41fb-af9b-2d48c57d9d6e	b7440787-50bd-4e41-b38b-48acf37af0de	205d3aed-6ce7-4cd3-8f6d-8d222d9d59b0	2	\N	\N	\N	\N	\N
4fe407e2-b458-4e0a-9097-3d1d6cf64846	t	f	2022-01-11 00:00:00	\N	K3	43d79d88-2bfb-4899-9635-87db5b1ebb4d	b7440787-50bd-4e41-b38b-48acf37af0de	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	3	\N	\N	\N	\N	\N
4e875274-dcb8-4cf7-a815-a859ab8769c6	t	f	2022-01-11 00:00:00	\N	K3	208cba42-90ab-4392-a889-770f7e5371a5	b7440787-50bd-4e41-b38b-48acf37af0de	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	4	\N	\N	\N	\N	\N
af78d590-5852-4f0b-b4f0-a3bec4cf07a4	t	f	2022-01-11 00:00:00	\N	K3	6c96f71b-45c5-437b-88e2-cf38bfa5cead	b7440787-50bd-4e41-b38b-48acf37af0de	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	5	\N	\N	\N	\N	\N
a6da34a8-72ae-454c-a373-d15077882780	t	f	2022-01-11 00:00:00	\N	K3	6699bdaf-f027-45bd-9f8e-cc9e1596e57e	b7440787-50bd-4e41-b38b-48acf37af0de	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	6	\N	\N	\N	\N	\N
95311922-6784-4d41-8159-2e94013f6444	t	f	2022-01-11 00:00:00	\N	K3	1ace9385-c200-4162-b8f2-ee20a21de12b	b7440787-50bd-4e41-b38b-48acf37af0de	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	7	\N	\N	\N	\N	\N
a25cd90b-73eb-4761-a287-405299206e19	t	f	2022-01-11 00:00:00	\N	K6	ecd18d1b-5ff9-402b-acb0-a7c024d7405a	b7440787-50bd-4e41-b38b-48acf37af0de	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	8	\N	\N	\N	\N	\N
2f437dd4-2682-45d9-97a3-3ae285397510	t	f	2022-01-11 00:00:00	\N	K7	964f1a26-1db4-4d92-ace7-e1e8d1040fe7	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	9	\N	\N	\N	\N	\N
40dcf79d-d660-478d-8e48-ca3bef7f8a4c	t	f	2022-01-11 00:00:00	\N	K4	6054e9bf-9754-4ff1-b893-d434aa8c9c14	b7440787-50bd-4e41-b38b-48acf37af0de	89e47949-21f1-4855-a397-20c3bc3426d7	10	\N	\N	\N	\N	\N
16532e6d-542d-47a2-bd37-4e81559c8f6a	t	f	2022-01-11 00:00:00	\N	K7	97e40a84-12ab-4196-9a07-251795684d05	b7440787-50bd-4e41-b38b-48acf37af0de	89e47949-21f1-4855-a397-20c3bc3426d7	11	\N	\N	\N	\N	\N
8e3df435-f40f-4493-8a03-f3fdc0c38eec	t	f	2022-01-11 00:00:00	\N	K5	8ce8b225-cfbc-48dc-8ec0-ff766f8af8ba	b7440787-50bd-4e41-b38b-48acf37af0de	89e47949-21f1-4855-a397-20c3bc3426d7	12	\N	\N	\N	\N	\N
68e756f8-5243-407d-8a70-a84d970120ce	t	f	2022-01-18 00:00:00	\N	K4	27021346-5559-4115-93c3-6d701d79d793	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	13	\N	\N	\N	\N	\N
50a10158-eefd-4398-a70f-a2aa5f866e78	t	f	2022-01-18 00:00:00	\N	K1	c6fb9e89-a866-4d37-8a3b-483e342056a8	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	14	\N	\N	\N	\N	\N
99d384db-58bc-4496-aab3-50c0811819ed	t	f	2022-01-13 00:00:00	\N	K4	3ff268d4-5f14-47c2-b97c-6dd626e6d5f7	b7440787-50bd-4e41-b38b-48acf37af0de	a60429c0-6964-454b-8ee1-ddad66957f06	15	\N	\N	\N	\N	\N
457d8b84-e7e3-4013-8d46-9b9f1d4a89e5	t	f	2022-01-13 00:00:00	\N	K2	31c0e81b-0100-473b-8b83-b166c58d30c0	b7440787-50bd-4e41-b38b-48acf37af0de	a60429c0-6964-454b-8ee1-ddad66957f06	16	\N	\N	\N	\N	\N
924ec5d6-245d-4c2f-bef3-e043f195ddf4	t	f	2022-01-13 00:00:00	\N	K6	846a1295-b969-4696-9aa3-490d714ed495	b7440787-50bd-4e41-b38b-48acf37af0de	a60429c0-6964-454b-8ee1-ddad66957f06	17	\N	\N	\N	\N	\N
78c654bc-fdac-4778-9785-6525033266e9	t	f	2022-01-13 00:00:00	\N	K3	44cd2080-cd4d-4cc7-b3d0-59049ec6a039	b7440787-50bd-4e41-b38b-48acf37af0de	a60429c0-6964-454b-8ee1-ddad66957f06	18	\N	\N	\N	\N	\N
ac9880e0-abdc-4698-8ff8-cbb0ad29f30e	t	f	2022-01-13 00:00:00	\N	K6	f823ade5-ba29-4694-95b2-96fe94ae61f3	b7440787-50bd-4e41-b38b-48acf37af0de	a60429c0-6964-454b-8ee1-ddad66957f06	20	\N	\N	\N	\N	\N
bf16e180-dd88-4f4d-8413-f113d5b695c2	t	f	2022-01-13 00:00:00	\N	K2	24d83ab7-2161-4bdd-8c73-ca2eb83e2f41	b7440787-50bd-4e41-b38b-48acf37af0de	a60429c0-6964-454b-8ee1-ddad66957f06	21	\N	\N	\N	\N	\N
fa75a809-367c-4847-aec7-13e5f0d5c9dc	t	f	2022-01-13 00:00:00	\N	K2	15d210c8-1e12-46ee-8aea-cf05f9932a53	b7440787-50bd-4e41-b38b-48acf37af0de	a60429c0-6964-454b-8ee1-ddad66957f06	22	\N	\N	\N	\N	\N
90409784-0f18-401b-846c-31f1af143b40	t	f	2022-01-14 00:00:00	\N	K2	1b4854d8-20ad-4930-b1c3-3240dc956831	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	23	\N	\N	\N	\N	\N
4e4bcb83-954a-4870-b98b-6a4dd096dece	t	f	2022-01-14 00:00:00	\N	K1	b3f9bd7c-c964-484f-ba2a-eed971e6302e	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	24	\N	\N	\N	\N	\N
8e46b400-5854-4c08-b194-7819d3918c77	t	f	2022-01-14 00:00:00	\N	K3	5828b5e1-f4c0-469d-99b2-1d63dc7b663c	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	25	\N	\N	\N	\N	\N
af15fa03-3abf-40c8-9e4a-c968517b624f	t	f	2022-01-14 00:00:00	\N	K4	191b7c4a-462a-48ad-a967-12dd83e31dca	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	26	\N	\N	\N	\N	\N
7a246b48-6a46-4df2-a7ea-7ed627856611	t	f	2022-01-18 00:00:00	\N	K2	5976ff8a-30e4-4941-8240-f63393169543	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	27	\N	\N	\N	\N	\N
a1131bf0-f2ca-437c-9ba4-9388402ef5ee	t	f	2022-01-18 00:00:00	\N	K4	1d6c2970-01e1-4731-bee7-ad90613533db	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	28	\N	\N	\N	\N	\N
2f67f7ba-1a15-4063-8c04-ed4e0d7ce560	t	f	2022-01-14 00:00:00	\N	K1	1ae54287-50bc-45bc-9b79-1b5f19f5d85b	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	29	\N	\N	\N	\N	\N
c9f1c823-1235-47a3-a318-5b5a06da4fac	t	f	2022-01-14 00:00:00	\N	K2	dacbe400-de12-41ae-b085-1539b49f1d84	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	30	\N	\N	\N	\N	\N
ab996989-a59d-44b6-90c8-babe0e099207	t	f	2022-01-14 00:00:00	\N	K4	f37982fe-3e6d-4eda-abda-8ac5755df352	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	31	\N	\N	\N	\N	\N
98c45d7c-82c4-4f8e-bf23-44bb98c482c9	t	f	2022-01-17 00:00:00	\N	K1	5f6d8771-f6b1-482f-9e6c-87448c63dfdc	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	32	\N	\N	\N	\N	\N
6b28aba7-470d-48bc-8dcd-3914911c6c29	t	f	2022-01-17 00:00:00	\N	K4	6247b048-7eff-40f7-a159-0a799e31b694	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	33	\N	\N	\N	\N	\N
0b4868c8-1017-49f8-aee0-2867825637b3	t	f	2022-01-17 00:00:00	\N	K5	ba61a7bb-2162-4e6d-8951-f97e8972fb03	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	34	\N	\N	\N	\N	\N
628f5d12-759e-44cc-b342-6afc0a61713f	t	f	2022-01-17 00:00:00	\N	K5	57454bda-dac9-44db-96a5-0912760e67bc	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	35	\N	\N	\N	\N	\N
7565541b-c50f-44c4-a38a-c22b4ea68c84	t	f	2022-01-17 00:00:00	\N	K4	73edd0ac-2789-415c-9a52-25b554526e8e	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	36	\N	\N	\N	\N	\N
35ee38df-4b40-4161-acb4-ca4a530e61ec	t	f	2022-01-17 00:00:00	\N	K3	2fac7e69-8bcc-44f6-aa39-17c3ca51a89c	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	37	\N	\N	\N	\N	\N
02ef5c2c-3d23-4da3-83e9-123f05c44e3f	t	f	2022-01-17 00:00:00	\N	K4	691c3b72-32c7-4c84-bac6-025d7afc2654	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	38	\N	\N	\N	\N	\N
00e80666-07cb-4115-8219-2dfe6d2e8870	t	f	2022-01-17 00:00:00	\N	K4	e49aadfa-195f-4c25-b698-812bfdadb682	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	39	\N	\N	\N	\N	\N
57a671cd-e981-44d1-a751-01472ed22c3b	t	f	2022-01-17 00:00:00	\N	K3	dbfa3cb3-f422-4d5b-a506-e745ef4f8ac5	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	40	\N	\N	\N	\N	\N
b3ed9214-162c-4541-bc62-8509aaeae980	t	f	2022-01-17 00:00:00	\N	K5	d937d2c4-390f-4509-835b-0f8a2a0ec53d	b7440787-50bd-4e41-b38b-48acf37af0de	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	41	\N	\N	\N	\N	\N
1e00ea56-5261-4b1b-9c1b-14e1e3f30340	t	f	2022-01-17 00:00:00	\N	K2	27316a2b-be20-426c-b73f-ff55d3b38cc7	b7440787-50bd-4e41-b38b-48acf37af0de	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	42	\N	\N	\N	\N	\N
8099e9b6-128e-49c4-99d0-75baf3d5bab9	t	f	2022-01-18 00:00:00	\N	K1	0196ce81-9179-4c8f-83c4-d89d66d2532c	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	43	\N	\N	\N	\N	\N
d1a8cc5e-90dd-4c8b-952c-a974dbab4521	t	f	2022-01-18 00:00:00	\N	K3	6f4cf34f-bfe3-49ac-963f-dc31bb85dc66	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	44	\N	\N	\N	\N	\N
c9f8bef9-6b3c-497e-8a87-09f3191921d6	t	f	2022-01-18 00:00:00	\N	K3	ed16ea6c-1df1-4643-9ed8-5f91c3f07c38	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	45	\N	\N	\N	\N	\N
1e95ec22-128e-4d52-a554-4bfd2d993840	t	f	2022-01-18 00:00:00	\N	K4	f863d3da-aad8-4606-ba98-0a69ce2535f2	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	46	\N	\N	\N	\N	\N
a097c55d-6d23-47cc-8f70-54259888f7d0	t	f	2022-01-18 00:00:00	\N	K2	92148697-c598-405e-bdd0-16a81d328b20	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	47	\N	\N	\N	\N	\N
99793333-157b-48d5-b6c9-3d650562dd85	t	f	2022-01-18 00:00:00	\N	K2	e40fe43e-d429-406b-8a46-9720bec4f297	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	48	\N	\N	\N	\N	\N
1b7d4299-e39d-4a07-9720-a45ddbd4b2b8	t	f	2022-01-13 00:00:00	\N	KEIN_START	d47e529c-488c-4d0a-8701-4660764839a4	b7440787-50bd-4e41-b38b-48acf37af0de	a60429c0-6964-454b-8ee1-ddad66957f06	19	\N	\N	\N	STARTET	\N
01bd1829-87fb-47f3-81bd-e2d8850b31fd	t	f	2022-02-01 00:00:00	\N	K4	bb382f68-3f86-4ac9-b4f8-47793df347cf	b7440787-50bd-4e41-b38b-48acf37af0de	2fc3365b-34d9-4054-b2d8-aa859c7455e7	273	\N	\N	\N	STARTET	\N
95338092-5204-4837-a9ad-631cdca8a1ec	t	f	2022-01-18 00:00:00	\N	K5	7efe5df5-da80-47f3-bb9f-a1c79089d1ba	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	49	\N	\N	\N	\N	\N
bceb81e1-e61a-4bc8-9067-04aed90069b5	t	f	2022-01-18 00:00:00	\N	K5	062d0f21-91aa-4219-8f38-7d89acb1413b	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	50	\N	\N	\N	\N	\N
60e2bd39-f070-4721-aefa-f2285277d62a	t	f	2022-01-18 00:00:00	\N	K5	a4ba36d3-c94f-4be7-abe2-be781a91a4c7	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	51	\N	\N	\N	\N	\N
aaf0ccab-2fa6-4e32-bf0e-6d144f99b123	t	f	2022-01-18 00:00:00	\N	K6	5ea6fa08-0baa-4f4d-b3be-418c6a9a52a8	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	52	\N	\N	\N	\N	\N
27ec8246-dfb1-4cec-9b01-4232515a75c3	t	f	2022-01-19 00:00:00	\N	K1	c4805559-715e-4683-a517-a30714a7c295	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	53	\N	\N	\N	\N	\N
242bfac8-8e80-46b8-aed5-b57730395821	t	f	2022-01-19 00:00:00	\N	K2	91caefba-e34c-4bba-b3b8-f80a1aed5a9a	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	54	\N	\N	\N	\N	\N
561c2e65-54a0-4ebf-af84-188afca6aec9	t	f	2022-01-20 00:00:00	\N	K1	d45f228f-96f1-47de-9612-775222437b36	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	55	\N	\N	\N	\N	\N
06ffe66a-b402-4201-9067-1e3d7982652e	t	f	2022-01-19 00:00:00	\N	K7	8828320f-f23b-40fb-9868-520849448037	b7440787-50bd-4e41-b38b-48acf37af0de	854e7b58-34dc-4ed5-ac6c-f233476b1e9e	56	\N	\N	\N	\N	\N
2a449255-7606-4a77-b31f-1f7f0e01926c	t	f	2022-01-19 00:00:00	\N	K7	87247b7e-c974-4fe9-b496-38049c3b8231	b7440787-50bd-4e41-b38b-48acf37af0de	854e7b58-34dc-4ed5-ac6c-f233476b1e9e	57	\N	\N	\N	\N	\N
d5d30b27-9671-4299-a2a7-8cc858d8656f	t	f	2022-01-20 00:00:00	\N	K1	26636a78-0791-4c4d-87fb-5e6a1027c123	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	58	\N	\N	\N	\N	\N
ad88b19c-c48c-4023-b995-6f8a14776ddd	t	f	2022-01-20 00:00:00	\N	K4	e4a7eb54-db20-4a74-a741-944bca117acb	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	59	\N	\N	\N	\N	\N
84411f19-79f5-4f76-8807-66896f3d6e89	t	f	2022-01-20 00:00:00	\N	K3	fa9887e0-680c-479a-8ac7-3c8f2e3f4769	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	60	\N	\N	\N	\N	\N
40bdd840-f587-4b5f-b357-f21b80027b68	t	f	2022-01-20 00:00:00	\N	K1	6d124e5a-4eb3-41e7-96c4-81e10bc865d5	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	61	\N	\N	\N	\N	\N
bceb48cd-e891-4ba2-b10f-497af1972f80	t	f	2022-01-20 00:00:00	\N	K2	25718b42-a27c-4fb2-b9a3-0a012e44f6c3	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	62	\N	\N	\N	\N	\N
c4d178d0-72f9-42f3-a77f-0be997b721fa	t	f	2022-01-22 00:00:00	\N	K6	8caf591f-960a-40fb-9963-39b42a8484c6	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	78	\N	\N	\N	\N	\N
84b46cbd-4093-4f0a-81f1-70a81a9a8aca	t	f	2022-01-22 00:00:00	\N	K5	af4f44cd-0ac8-4782-9beb-4817b40dbf42	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	79	\N	\N	\N	\N	\N
23212a99-8184-4b5c-b67c-6a03660d44c7	t	f	2022-01-22 00:00:00	\N	K5	dbf71678-6772-4c24-8d95-2966f0afad08	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	80	\N	\N	\N	\N	\N
afa2c5d3-5e2c-44c1-a112-ad823ab11ce8	t	f	2022-01-22 00:00:00	\N	KEIN_START	81acf225-0226-4232-b5be-2691aa4fc5f8	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	81	\N	\N	\N	\N	\N
21745be8-4627-46cf-95cd-43f85b46194b	t	f	2022-01-22 00:00:00	\N	KEIN_START	d18b15cc-8213-4292-aafb-6a7a87597f08	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	82	\N	\N	\N	\N	\N
6bb1d0a3-bbe9-4492-82af-f79376bd8c85	t	f	2022-01-22 00:00:00	\N	K4	02a156d2-3f1d-4371-b9ed-2e9cdc2a1905	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	84	\N	\N	\N	\N	\N
b8175947-953b-409b-89a0-775b78eb1cf6	t	f	2022-01-22 00:00:00	\N	K3	e4f09bb0-eef8-4a1a-8b21-cba9bb7910c3	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	85	\N	\N	\N	\N	\N
6829253f-0186-4e32-a3bb-4ea2b2c0d53d	t	f	2022-01-22 00:00:00	\N	K1	162dceab-8d0a-4e66-8cf2-7ec51717b40e	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	86	\N	\N	\N	\N	\N
354aa449-5edd-4bfb-8692-d88137b20935	t	f	2022-02-10 00:00:00	\N	K2	355bba95-fd6a-4508-874f-4b12b4ac7259	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
d2013fde-b09d-488b-91c4-9cf2a77cfa36	t	f	2022-02-10 00:00:00	\N	K3	3b53d27e-8915-44f0-a835-3d09a6e0cf53	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
3848982f-2da7-49b0-a43d-5457ce389fe5	t	f	2022-02-10 00:00:00	\N	K5A	a51724a5-36ba-4443-a13e-c708ae7a6238	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
7d828932-1cb9-409a-8bb5-6dca1909c5e0	t	f	2022-01-23 00:00:00	\N	K4	c49e6c4c-a355-4993-aa0c-425282edc247	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	90	\N	\N	\N	\N	\N
3e9dc560-cb33-4435-958e-ec86dca13dea	t	f	2022-01-23 00:00:00	\N	K5	12452659-e21d-48c7-8f95-ead28d3f8040	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	91	\N	\N	\N	\N	\N
59e76e6c-72e7-4d05-9919-647a473368fc	t	f	2022-01-23 00:00:00	\N	K5	3481528b-0476-4851-87cc-56138eb7d80b	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	92	\N	\N	\N	\N	\N
c520ae93-6ac5-40e5-a23a-f287414adedf	t	f	2022-01-23 00:00:00	\N	K4	b4dc29c0-a537-41b1-9f13-a6dd38e7725d	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	93	\N	\N	\N	\N	\N
cbb86123-c3bf-4838-84b1-3b118704c499	t	f	2022-01-23 00:00:00	\N	K5	1cfd9655-d0a7-41c5-b3b2-10fd42f07084	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	94	\N	\N	\N	\N	\N
6131ead1-6c79-471d-8890-942812722564	t	f	2022-01-23 00:00:00	\N	K4	b1e4025d-1ba5-4fb4-b21c-00c8e74c1db5	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	95	\N	\N	\N	\N	\N
d12e54d1-4e16-4ab0-a9d5-7412a1895911	t	f	2022-01-23 00:00:00	\N	K3	81141c69-6869-4cfe-8e99-48e56e882f71	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	96	\N	\N	\N	\N	\N
276a9f90-78c0-4962-8265-d3f15932fe67	t	f	2022-01-23 00:00:00	\N	K3	a7efed26-f4ec-4d7b-aa45-ce138c08d8b5	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	97	\N	\N	\N	\N	\N
54238b56-7347-45ea-a4d4-85dda3aa85be	t	f	2022-01-23 00:00:00	\N	K2	15d35492-6126-46c1-a8ec-6d61cc113be1	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	98	\N	\N	\N	\N	\N
8f69c94b-1920-4c54-8a0a-60c63a411194	t	f	2022-01-23 00:00:00	\N	K2	00eecc59-5b8b-407d-b7cb-a3a65af878be	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	99	\N	\N	\N	\N	\N
d82dbdf2-60da-4825-bd3e-73c4cac12c6f	t	f	2022-01-24 00:00:00	\N	K2	4854fa23-b4e4-48d6-840e-54088b5b0f72	b7440787-50bd-4e41-b38b-48acf37af0de	e2438143-6017-4683-a533-6113748d4117	100	\N	\N	\N	\N	\N
46087146-bd11-449c-a7a3-1093bbd6f8ed	t	f	2022-01-24 00:00:00	\N	K2	625b0f35-302b-4ef3-99c4-8d61475bcbdd	b7440787-50bd-4e41-b38b-48acf37af0de	e2438143-6017-4683-a533-6113748d4117	101	\N	\N	\N	\N	\N
98a6a345-21a0-402f-a43a-25688d2ceec7	t	f	2022-01-24 00:00:00	\N	K5	4182b334-d25c-442d-85cd-af5c553cb91b	b7440787-50bd-4e41-b38b-48acf37af0de	e2438143-6017-4683-a533-6113748d4117	102	\N	\N	\N	\N	\N
fbf272f1-dd1c-43a0-a078-7d72ccb80a25	t	f	2022-01-24 00:00:00	\N	KEIN_START	b2b033c1-ae1e-46c1-a971-2ffdb7a4118a	b7440787-50bd-4e41-b38b-48acf37af0de	e2438143-6017-4683-a533-6113748d4117	103	\N	\N	\N	\N	\N
6bcf15d7-9537-4d2b-9d1c-71129aa16b65	t	f	2022-01-24 00:00:00	\N	K5	b1e9adff-9671-4584-9e01-71f73814ad78	b7440787-50bd-4e41-b38b-48acf37af0de	e2438143-6017-4683-a533-6113748d4117	104	\N	\N	\N	\N	\N
c8eb1b50-8af3-4c69-8162-15aada40bfce	t	f	2022-01-24 00:00:00	\N	KEIN_START	fab019bc-a424-439d-bcc5-9f3ff55bc25e	b7440787-50bd-4e41-b38b-48acf37af0de	e2438143-6017-4683-a533-6113748d4117	105	\N	\N	\N	\N	\N
3ca0c89b-adbb-4bca-bdc2-634da6dfffd4	t	f	2022-01-24 00:00:00	\N	K2	daf319cf-daf5-4172-861a-d0d8af80bd76	b7440787-50bd-4e41-b38b-48acf37af0de	e2438143-6017-4683-a533-6113748d4117	106	\N	\N	\N	\N	\N
3a100d66-58a8-4fb3-9005-e071438d3c14	t	f	2022-01-25 00:00:00	\N	K3	e4bf521f-e7b9-40c3-95e3-d2e43966ca55	b7440787-50bd-4e41-b38b-48acf37af0de	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	107	\N	\N	\N	\N	\N
115d0c58-f77b-4c73-b2a4-49fabaf05fd3	t	f	2022-01-25 00:00:00	\N	K4	ba0b968d-7d83-4265-b0f5-9032be1fe45e	b7440787-50bd-4e41-b38b-48acf37af0de	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	108	\N	\N	\N	\N	\N
98658c5d-d627-4673-be74-69418cc8f402	t	f	2022-01-25 00:00:00	\N	K2	99047440-a28d-4a9e-98c9-8a5a5b2d7517	b7440787-50bd-4e41-b38b-48acf37af0de	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	109	\N	\N	\N	\N	\N
b1ee9179-e975-4240-819b-6b85905798c4	t	f	2022-01-25 00:00:00	\N	K2	7e3f0c97-7735-411d-903d-dd8b4faa323c	b7440787-50bd-4e41-b38b-48acf37af0de	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	110	\N	\N	\N	\N	\N
bae753fe-4f73-4ed4-b66e-7aef17dd30f1	t	f	2022-01-25 00:00:00	\N	K3	d2d3bfd6-d7e9-4074-a64b-dca909758826	b7440787-50bd-4e41-b38b-48acf37af0de	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	111	\N	\N	\N	\N	\N
dabd5904-1c52-4df7-b138-a1c7cc27f35d	t	f	2022-01-25 00:00:00	\N	K3	da115d88-2870-45bc-9739-f9c6728097b2	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	112	\N	\N	\N	\N	\N
ec713ee7-ac53-4c87-a968-e11a10ab1059	t	f	2022-02-10 00:00:00	\N	K3	15b80964-2809-4c3b-9325-f20ae4930434	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
02b44384-df88-4ed5-b565-e8e143f2045e	t	f	2022-01-25 00:00:00	\N	KEIN_START	de0d5c86-4883-4f47-ad70-a6aa4dfea332	b7440787-50bd-4e41-b38b-48acf37af0de	2fc3365b-34d9-4054-b2d8-aa859c7455e7	114	\N	\N	\N	STARTET	\N
e5521b4e-c4aa-42f9-aa23-a5b30ae71c80	t	f	2022-01-25 00:00:00	\N	K5	121df43d-4074-45a0-9e24-89d43c0ff9ee	b7440787-50bd-4e41-b38b-48acf37af0de	d48095c7-3de5-4a8d-b893-b8d432e7c647	115	\N	\N	\N	STARTET	\N
a143c796-aa6a-4e5a-981d-9345afce4692	t	f	2022-01-25 00:00:00	\N	K4	f4b75c50-054e-4da8-8350-1d84232b6441	b7440787-50bd-4e41-b38b-48acf37af0de	d48095c7-3de5-4a8d-b893-b8d432e7c647	116	\N	\N	\N	STARTET	\N
5c2a71a2-8517-4d3a-baf1-ea8579fd5e51	t	f	2022-01-25 00:00:00	\N	K4	7eb4ca01-299a-444a-8123-0c8f553d0718	b7440787-50bd-4e41-b38b-48acf37af0de	d48095c7-3de5-4a8d-b893-b8d432e7c647	117	\N	\N	\N	STARTET	\N
d9e27449-ffa3-41e4-9f72-444faf8bf83c	t	f	2022-01-26 00:00:00	\N	K3	64e32826-941e-4a21-b418-505b0e56fda2	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	119	\N	\N	\N	STARTET	\N
863e0c09-96bc-491e-bdfe-f866543d6e79	t	f	2022-01-26 00:00:00	\N	K3	7c25b5c2-b0f8-4e54-8169-7b5c2c99796a	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	120	\N	\N	\N	STARTET	\N
e47d9ccb-2316-425c-98fa-db4c645c5bb2	t	f	2022-01-26 00:00:00	\N	K3	3e48b69f-527a-4e13-bb7a-25dc5943ecc3	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	121	\N	\N	\N	STARTET	\N
1c0169ce-2a01-4544-863c-398c537d24d4	t	f	2022-01-26 00:00:00	\N	K3	ddc5d1c7-f3d8-4321-a137-f344eab4ad9a	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	122	\N	\N	\N	STARTET	\N
f7e8a14a-ce65-401c-a4dc-ab84a95582ef	t	f	2022-01-26 00:00:00	\N	K3	8bca5f87-48cf-4df8-851a-f17791ca27f3	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	123	\N	\N	\N	STARTET	\N
809c2e3d-3b9d-46cc-bacc-ac94388ef9d0	t	f	2022-01-26 00:00:00	\N	K6	1c8eb3d9-4190-4f9d-bb86-9800a8557b88	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	124	\N	\N	\N	STARTET	\N
cac6b42b-8058-44cf-97e0-f7cab11ffbc6	t	f	2022-01-26 00:00:00	\N	K6	3eba3044-7c1e-482a-8eeb-a7afa3b81910	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	125	\N	\N	\N	STARTET	\N
a4ff8852-ea73-484d-8afc-9b1c45a08fcb	t	f	2022-01-26 00:00:00	\N	K5	f66e79e7-bc77-4efe-a823-9253e5cbc9c8	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	126	\N	\N	\N	STARTET	\N
d71dea4c-6b8b-4b23-8f94-c8bcd555c91a	t	f	2022-01-26 00:00:00	\N	K5	97df0cc6-12d7-4f17-b20b-0f4cba6d9e77	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	127	\N	\N	\N	STARTET	\N
63b52066-bdc4-469b-b6ff-4518f9879787	t	f	2022-01-25 00:00:00	\N	KEIN_START	fc09e934-9292-407f-9d99-ce981c8b18ea	b7440787-50bd-4e41-b38b-48acf37af0de	d48095c7-3de5-4a8d-b893-b8d432e7c647	118	\N	\N	\N	STARTET	\N
457c4e89-04a2-4bd4-a8b6-1b52bbf678ca	t	f	2022-01-22 00:00:00	\N	KEIN_START	07160725-0859-4a58-9d65-89677de3c1ee	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	83	\N	\N	\N	STARTET	\N
4284d63c-8d5c-4e29-a5f0-2729fd6414d4	t	f	2022-01-26 00:00:00	\N	K6	6a361cdd-1a65-4bbe-b3ac-678e202493a6	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	128	\N	\N	\N	STARTET	\N
5a0ffab3-747c-4694-8f4f-8ec571fdef63	t	f	2022-01-26 00:00:00	\N	K7	dee1d772-12cb-43fb-9ddf-f671fdc2b9b0	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	129	\N	\N	\N	STARTET	\N
05394544-4fed-4c83-927e-8227185e1c91	t	f	2022-01-26 00:00:00	\N	KH	cc1458e2-677d-483e-a491-d4f268e9e405	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	130	\N	\N	\N	STARTET	\N
3d7624f4-8d38-4711-a097-8d2b37a86dd7	t	f	2022-01-26 00:00:00	\N	K1	329b27f5-9daf-4ead-a213-4450a26db0a4	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	131	\N	\N	\N	STARTET	\N
2da4fe52-e309-4406-876d-041a5d3418ab	t	f	2022-01-26 00:00:00	\N	KEIN_START	cf890313-5432-4db1-a371-2ddbc6fd2b03	b7440787-50bd-4e41-b38b-48acf37af0de	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	132	\N	\N	\N	STARTET	\N
00aa8447-8ac1-4336-b649-8ef4a3491d1d	t	f	2022-02-10 00:00:00	\N	K2	481a3cb4-cb26-4227-8463-ee717c8db0ac	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
fc687091-402c-4598-92db-ea2f545c3b1a	t	f	2022-02-10 00:00:00	\N	K2	719b1561-8685-475a-9a8e-c4ae01c947ee	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
17c2b303-bf85-41fa-b45c-cfd14000bec3	t	f	2022-02-10 00:00:00	\N	K7	4360e314-ea32-496c-8657-c9bb8058b0ea	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
d8621915-0c73-4496-92a2-e46c80c4ab07	t	f	2022-02-10 00:00:00	\N	K3	73d1c77a-a7bf-4b00-9ddf-7056f107817e	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
d6762206-6e44-465b-88cf-5ad61c4b4fe0	t	f	2022-02-10 00:00:00	\N	K1	c623ec2a-e96c-469a-be6c-8cfa166cfe46	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
2c300082-b5a9-4459-9226-4df983f6e79e	t	f	2022-02-10 00:00:00	\N	K2	d727f5fe-e7d2-4577-b489-4d354161de5e	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
5dff4734-d41f-4635-be0a-5f6f9d2da50b	t	f	2022-02-10 00:00:00	\N	K3	f76c2109-3f86-4463-b6c3-57caca3c80b0	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
aceaaed9-3838-4a78-b044-b9997d019037	t	f	2022-02-10 00:00:00	\N	K5B	94ff7338-7eb0-4867-a8bd-c5544feaac2b	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
146f4824-fa6e-4f93-8a9e-2dc81594d0e1	t	f	2022-01-28 00:00:00	\N	K6	a6493824-cca4-4c7c-a202-3dd0a04b1f3e	b7440787-50bd-4e41-b38b-48acf37af0de	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	176	\N	\N	\N	STARTET	\N
cacae4f8-7f63-4d53-ac81-1ec66dc9f7d4	t	f	2022-01-29 00:00:00	\N	K5	90cb95a6-01df-4d57-82c3-6c852dc0989a	b7440787-50bd-4e41-b38b-48acf37af0de	a5302a2b-d270-49e5-9876-47c84cb38038	177	\N	\N	\N	STARTET	\N
ac2f05fa-9933-451d-a4a2-4021a3097bdc	t	f	2022-01-29 00:00:00	\N	K5	12274a9f-83e7-4247-9c43-a01d7cd613fc	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	178	\N	\N	\N	STARTET	\N
0069a830-6ea7-4d05-b13f-04e152fea195	t	f	2022-01-29 00:00:00	\N	K2	699c9855-119d-4bd7-9e00-61aff964bc39	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	179	\N	\N	\N	STARTET	\N
a632f002-2c1e-40a5-914b-51fe93da76ba	t	f	2022-01-29 00:00:00	\N	K4	4a9ef47d-7a3a-4c9f-9761-a5c7422fef1c	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	180	\N	\N	\N	STARTET	\N
2f6cb656-3841-4360-a78c-6e1f4a9d1ab6	t	f	2022-01-29 00:00:00	\N	K1	72afd313-31ba-4a08-b737-fa602d694892	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	181	\N	\N	\N	STARTET	\N
bbcfc4c7-d1f4-4736-ab07-8b0136f0fa89	t	f	2022-01-30 00:00:00	\N	K2	ed4e39f4-57d9-4005-9be0-dea0858e0281	b7440787-50bd-4e41-b38b-48acf37af0de	1030974d-cffe-46d6-b6ea-79c8839cf2ea	182	\N	\N	\N	STARTET	\N
3e92f29e-5d02-40c3-bf31-1668d95d32a8	t	f	2022-01-30 00:00:00	\N	K1	3c9f3b45-0056-4218-8d92-9315134151fe	b7440787-50bd-4e41-b38b-48acf37af0de	4e9262a1-fef9-4701-9c91-1b3016ee971d	183	\N	\N	\N	STARTET	\N
f628db01-0358-411e-b68c-7814d135b754	t	f	2022-01-10 00:00:00	\N	K4	8f6e628f-13e7-4bf8-a661-7776005d8247	b7440787-50bd-4e41-b38b-48acf37af0de	2fc3365b-34d9-4054-b2d8-aa859c7455e7	113	\N	\N	\N	STARTET	\N
7c230375-daa3-471b-aecb-16354cd244db	t	f	2022-02-10 00:00:00	\N	K5A	932c4b6f-eb11-4965-9328-2c7ba3dad7ab	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
4112411c-8c4a-451b-bc13-34b00c86a05d	t	f	2022-02-10 00:00:00	\N	K5A	288bf42c-3a48-490f-be92-896fa147a5dd	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
aa4675cf-cf4e-4924-9e04-98902805317b	t	f	2022-02-10 00:00:00	\N	K4	f35613ea-fe14-4b4a-8fd3-b2b5648ed805	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
07215da1-c195-4bb1-8be0-1a8835dbcde7	t	f	2022-02-10 00:00:00	\N	K4	24cde7d0-cf95-4432-9523-ef30e7c2c868	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
dd9e3f50-5c1f-491a-8e64-e35ac0ab8db6	t	f	2022-02-11 00:00:00	\N	K2	a375381b-fa1b-4cad-b813-8b0cb1a49192	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
3c029ddd-a400-4031-8314-6a6517367b27	t	f	2022-02-11 00:00:00	\N	K3	9cf5cf03-87df-4421-a9b5-7b1eedb3bef1	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
05098cf2-b957-4d97-a3fa-167949da4d66	t	f	2022-02-11 00:00:00	\N	K4	4d56147f-59e0-42a3-83f1-3e3d8b47594d	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
16349528-29e3-4769-9dba-8e0a8476726e	t	f	2022-02-11 00:00:00	\N	K1	f576a66b-a996-45b2-bca3-5af4982f7311	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
ad9a3ceb-f8fa-4e76-ae48-d6282bbf1a30	t	f	2022-02-11 00:00:00	\N	K1	f8635296-d310-41ae-b55b-0fa695804348	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
46fef451-5bc1-4805-90e2-d973bdfd3dc0	t	f	2022-02-11 00:00:00	\N	K7	dabd45d7-46d4-4eac-b12c-5665fcb3b089	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
e86a0261-f87c-4bd4-84a4-ac5ee347eb6f	t	f	2022-02-11 00:00:00	\N	K3	8a0d12f6-8d55-4523-8978-a785258dffc5	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
b329ccfc-8f4f-45b5-b094-49b0190e5088	t	f	2022-02-11 00:00:00	\N	K3	ad9e373b-c563-4dc3-8b50-0094beadba29	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
4ecfcee2-e555-4562-9984-d37b6626029e	t	f	2022-02-11 00:00:00	\N	K3	7a7f15a5-dde0-401c-8d13-a5ff9ff2432f	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
994a272d-6385-441b-8f34-33d047902bfc	t	f	2022-02-11 00:00:00	\N	K3	89ad5b6d-d920-48d4-be5b-1a48637c2023	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
04f82784-4f49-4a49-bf30-2e055b9491d8	t	f	2022-02-11 00:00:00	\N	K2	b8c000b2-1de0-40ea-ae29-be219b76c023	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
5a7e609f-0df6-4ab4-bd09-9e062c998555	t	f	2022-02-06 00:00:00	\N	K5A	0985ba77-7d82-42ac-b749-b4038d98499b	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
9c19439d-006a-440e-b521-fdddf752cc13	t	f	2022-02-06 00:00:00	\N	K5A	54b689dc-9aa3-43f8-9561-08becceb99c5	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
cee1e14b-e31c-4322-93dc-45aabe1e95b1	t	f	2022-02-06 00:00:00	\N	K2	6e92ebdf-7eaa-4d9f-b82d-bdc647c19670	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
616c2640-670b-467a-8f68-7e06b9f9aec7	t	f	2022-02-06 00:00:00	\N	K6	6be7d65d-fba8-42a4-89b7-2c666d713306	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
8da1e7af-167a-4084-ac1a-0f0ab97e1b14	t	f	2022-02-06 00:00:00	\N	KD	d95b8556-fa44-41e0-a8d1-e0cb288ea4cd	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
faea544d-8741-4dd7-a50c-420cf15c3f69	t	f	2022-02-06 00:00:00	\N	K2	e6c51a7f-2f1f-44d2-8974-f3a222018f30	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
51609486-22c1-44e9-b954-62b7918a709f	t	f	2022-02-06 00:00:00	\N	K4	77328ed8-39ea-41b6-899e-beb5f9861380	0fa002f3-d432-46d4-a753-991d021db3fa	773a0356-9c76-4dfb-8c56-c1693ee2819d	\N	\N	\N	\N	STARTET	\N
3ec1c3eb-a68c-4e95-8438-4ca3f0cc82c9	t	f	2022-02-07 00:00:00	\N	K1	0ca06129-a9e4-44da-b066-b524c8b12fbd	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
86177548-250b-4b12-b5cf-c38bd9b3a157	t	f	2022-02-07 00:00:00	\N	K2	1a6d1157-b4bc-48a4-a145-348e39ce7a83	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
57d7c6e4-cd96-4091-b170-7999afe44652	t	f	2022-02-07 00:00:00	\N	K4	d1109f3f-4e2f-47c0-a4f0-236f94cf79f1	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
f9badbc7-912f-4c5f-a960-758a922c4936	t	f	2022-02-07 00:00:00	\N	K4	c2c819ae-2b2b-4e74-a660-c195ed605462	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
260f5200-7d3c-4b67-8ff0-609d8cda6edc	t	f	2022-02-07 00:00:00	\N	K1	76ec3ae7-9c3b-4e22-9bed-4c9fb606506d	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
03a930a2-edf8-438b-9953-2cacea82b679	t	f	2022-02-07 00:00:00	\N	K1	64295098-b959-4ee2-98f5-0a744702ed7a	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
194e6d92-363d-48c3-8d3b-cbc205a8d065	t	f	2022-02-07 00:00:00	\N	K1	09c2f84d-0349-4390-9cc9-c56f3feb1aaf	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
a000b6de-a51c-4d9f-951b-c3baad900450	t	f	2022-02-07 00:00:00	\N	K2	be5c35d5-b53e-4d63-bd7f-e401977b624c	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
0b0408e5-8a3a-4e0b-896f-8384f150c15c	t	f	2022-02-07 00:00:00	\N	K2	74a0429e-9a75-40f9-89ce-9124580e92be	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
ac6536a6-a2f7-46aa-9c07-cb9f8c27d2e3	t	f	2022-02-07 00:00:00	\N	K3	b2ed96ff-0785-48e6-9fab-3b56478dbe5b	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
b533047a-2250-4a1c-ac2e-aa40489e2270	t	f	2022-02-07 00:00:00	\N	K4	162f3015-3281-46cb-ba71-41c2f6f0ddae	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
ee647ea4-d731-446b-9e37-554b5f63b486	t	f	2022-02-07 00:00:00	\N	K5B	67ed9c9c-7e6b-419d-9a4a-32234377403c	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
f726af01-bee6-4ae7-b841-0ad2697f6fdc	t	f	2022-02-07 00:00:00	\N	K6	5034bf64-09c9-4ddf-b432-66f1c1a0963a	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
15f45d8e-87cd-4e85-b8e8-292f5fa40e24	t	f	2022-02-07 00:00:00	\N	K5B	e1f441cc-951a-4c2a-879e-63e1825b902c	0fa002f3-d432-46d4-a753-991d021db3fa	dc8ff971-5522-45bf-b501-ff65ecb46db9	\N	\N	\N	\N	STARTET	\N
ab92ac9b-7d0d-4fb9-8d3b-d5c0d71819ee	t	f	2022-02-07 00:00:00	\N	K5B	c061d703-74e3-44b6-a374-ddb4ad7d98e7	0fa002f3-d432-46d4-a753-991d021db3fa	5ee987b5-deec-4087-b36f-bba4dcaf842f	\N	\N	\N	\N	STARTET	\N
c635796a-1f9c-48c2-ae64-1f61b2d6fda5	t	f	2022-02-07 00:00:00	\N	K2	3737f7df-faae-4aa9-8797-2c0f906f34f1	0fa002f3-d432-46d4-a753-991d021db3fa	5ee987b5-deec-4087-b36f-bba4dcaf842f	\N	\N	\N	\N	STARTET	\N
3ee670b8-3531-4b68-bf1b-f52198ecf085	t	f	2022-02-01 00:00:00	\N	K4	8efdb23d-23a4-4a67-94e9-73ad25bd85ac	b7440787-50bd-4e41-b38b-48acf37af0de	c0a6c2eb-1278-42b5-8aba-0426f3550863	282	\N	\N	\N	STARTET	\N
90f3afd4-67b0-42ea-bd54-8faf02377844	t	f	2022-02-07 00:00:00	\N	K5A	bac724ef-d37a-4e35-8e10-bac91f44434f	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
86682f0a-691c-4004-bb8c-7942dc82beea	t	f	2022-02-10 00:00:00	\N	K6	8c8c1d3b-60d8-4b8d-9489-2303f5e7830c	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
94eee80d-3db0-432c-9b2a-90faf604383d	t	f	2022-02-10 00:00:00	\N	K1	497a8eac-0bc3-416a-93bc-fc063eab0fcf	0fa002f3-d432-46d4-a753-991d021db3fa	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	\N	\N	\N	\N	STARTET	\N
68221f0d-bd04-4fa2-878a-a206604d99c2	t	f	2022-02-10 00:00:00	\N	K2	aa86fac4-eb31-4716-89c6-dc8fdc834ae0	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
f19008b6-23e1-44f2-a7c4-8f167fb25907	t	f	2022-02-10 00:00:00	\N	K2	b0e58619-9fdd-4bd0-bbf2-1cec57bf0267	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
703a02e2-93cf-4e65-9713-87f8bc86c613	t	f	2022-02-10 00:00:00	\N	K5B	4e8cb30e-2ec4-45f5-8b3a-c64e308fbb92	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
85173b75-5387-4e1f-b3ea-722b0f03e4b2	t	f	2022-02-10 00:00:00	\N	K4	dc7f9cc6-3f93-4f57-bce7-8e259c6b315c	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
45517dfe-8f82-4efb-adf8-60f18b8ce6b2	t	f	2022-02-10 00:00:00	\N	K6	4ff65ac1-7911-46df-8f4f-f00eb6150034	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
d2988b88-d10b-435a-b629-4802670ac2d0	t	f	2022-02-10 00:00:00	\N	K5A	2f4b980f-0b31-492f-9b44-17d13e340f15	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
878faad0-7979-4c93-98e4-cbd17b3a9a3b	t	f	2022-02-11 00:00:00	\N	K3	2df1b468-d92c-428b-8535-ff5222abfd01	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
11d75a50-3a41-49e9-ba79-e8a3fdf71469	t	f	2022-02-11 00:00:00	\N	K2	46a5d751-8412-4cc0-b2ab-e669b2f62bba	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
bde769f3-0a8f-4b74-ab81-d7a850fe1d42	t	f	2022-02-11 00:00:00	\N	K1	ce176f61-3285-41fc-8e37-b8499ca8400e	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
0dae7c89-713f-4767-bce5-124437d564b8	t	f	2022-02-11 00:00:00	\N	K3	8e63a2c2-4fd9-4dd8-9953-a8dc48d06499	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
382f377e-02c7-498c-b103-b0afec9a483d	t	f	2022-02-11 00:00:00	\N	K5A	ee70a146-7693-4419-a609-d9d55232168d	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
69f60ec7-5b0c-4b5f-92cb-c4bd05e88f2c	t	f	2022-02-11 00:00:00	\N	K3	bb077b48-974d-419f-a9e1-1a65a339e00a	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
07bb929e-9414-4a90-ab4b-683d4285f94a	t	f	2022-02-11 00:00:00	\N	K2	2f6e9c37-c69e-4f6d-acff-b169b8273f7c	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
3023a5c1-e6f6-4497-8949-92cb7dbe4037	t	f	2022-02-11 00:00:00	\N	K4	7c6e9af7-6938-427b-b01a-d8ff0a92bd80	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
1674d0a3-e587-4d26-94c0-67752f1ef5db	t	f	2022-02-11 00:00:00	\N	K3	9d1d9eda-e0df-4d05-9c54-33fa148ac71f	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
38c96eb0-823a-4bd1-9714-06980a009e8a	t	f	2022-02-11 00:00:00	\N	K3	4613e34b-f33f-4d6e-b32b-93d2e1c0a01a	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
375a62be-1507-403b-8ee4-770066222e58	t	f	2022-02-11 00:00:00	\N	K3	677c4446-93c2-4e24-879a-2797ed431307	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
3b9e5d0d-8470-4dfb-9c33-9089a7d1e931	t	f	2022-02-11 00:00:00	\N	K6	c985ee16-07ee-4d29-a0bd-25f188d6ca59	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
e3f566e3-84fb-4901-bca2-5657b9a94ba3	t	f	2022-02-11 00:00:00	\N	K5A	4eeb51d4-d821-40c5-a5c9-fa198a977abd	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
36270fd9-a020-417c-9e9e-ef8877aaa5d9	t	f	2022-02-11 00:00:00	\N	K6	a48fd210-ec0f-46d0-9f63-cb0227d93096	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
032e0c00-7a5a-4db0-a521-d78f883769d2	t	f	2022-02-11 00:00:00	\N	K6	453c19ae-3f24-490f-ae52-74ea45cd6546	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
32fc9cbf-29a2-4103-b49f-394d188535c4	t	f	2022-02-11 00:00:00	\N	K1	7d29e6a3-343e-4a55-b568-b0b328f1824a	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
a3495a36-c951-4afd-a63c-8a8f1b666177	t	f	2022-02-12 00:00:00	\N	K5A	855aeab7-def6-4f8b-84bc-3d80db8fb369	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
39aaf484-1717-4733-85e1-23883683667b	t	f	2022-02-12 00:00:00	\N	K2	6977d335-b759-4911-95ff-26a2a3a0853b	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
cc67f175-fe92-4d2f-b0a9-92c4052b54dd	t	f	2022-02-12 00:00:00	\N	K4	0c4d0153-5b05-41e8-96e9-5acf39d8126d	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
495962db-23e5-47ac-b470-51aa3caf4128	t	f	2022-02-12 00:00:00	\N	K4	b9b25b7a-d938-42a1-a32d-b07313391377	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
a71c6370-3c80-4d95-a1ba-ec4caa08db76	t	f	2022-02-12 00:00:00	\N	K5A	b7cd2bf7-d4af-498f-a0a7-072150669fe4	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
c8c17432-8e59-4876-b5aa-5ceb92274fc1	t	f	2022-02-12 00:00:00	\N	K1	14ab2d8e-9f84-423a-ad22-bff072d3905d	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
b85c81a7-25d9-440c-a4a3-c7a3caaacc38	t	f	2022-02-12 00:00:00	\N	K1	6b2ba3a4-8901-444b-8478-4893793221f3	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
9055665f-a3e4-4b5d-a1b0-c3f9f29f6dbc	t	f	2022-02-12 00:00:00	\N	K4	f0b0e0ed-5725-4e21-85f9-c489fac2c67b	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
2244eecc-5156-4f09-84aa-72419f5baad0	t	f	2022-02-12 00:00:00	\N	K5B	a7494748-9add-4ab7-99b8-dc3547e6b5f5	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
bebd08d5-0b06-4fb5-97c9-a30d2f97af5c	t	f	2022-02-12 00:00:00	\N	K6	a82bcd07-7321-4a64-becb-e6c3d2b565b0	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
336f1cfd-d11a-4529-8a46-af1b1c28b593	t	f	2022-02-12 00:00:00	\N	K1	1173dede-94b5-4651-a164-a295f98de032	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
10800d5c-d94f-4066-a011-87f0fa56451d	t	f	2022-02-12 00:00:00	\N	K1	66d71487-91db-4ae4-8b32-f418e0d76db0	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
4903ec56-b974-43b2-8ff9-2153fe1e27d9	t	f	2022-02-12 00:00:00	\N	K1	2b9274e6-f21e-4ec2-8ceb-0e4899a0f303	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
3910983e-70a6-484c-bf9f-0e62419f12f1	t	f	2022-02-12 00:00:00	\N	K1	6cdeaa17-213a-496b-8747-014b2de11ab4	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
e488a7d8-f88b-4093-ba49-bf76c7124095	t	f	2022-02-12 00:00:00	\N	K6	211eec35-3413-4465-9ba2-17697e22207c	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
a43aa9da-066a-4cbe-b0ed-c87cfcf9d9a2	t	f	2022-02-12 00:00:00	\N	K1	23c70849-a8c6-4adc-b6a7-d177f02dfc3d	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
bab1f2d6-fb59-43fe-afa7-4378ac924ffd	t	f	2022-02-12 00:00:00	\N	K1	922fedbe-65d1-42fe-afc8-cea539464846	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
f3d6e638-5987-4ca7-b67b-bd66e697afa5	t	f	2022-02-12 00:00:00	\N	K5A	c86a9609-fca3-472a-a92f-887e5c2bc8ae	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
6de260f0-c030-4df3-b778-59d106c2db4f	t	f	2022-02-12 00:00:00	\N	K1	292995a1-8f2f-42c6-ac91-bfde428bdaae	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
9292bb3f-2232-4296-821f-cb6cdc196226	t	f	2022-02-12 00:00:00	\N	K6	2b37ad9f-20c6-4140-b9cb-70f7d697e064	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
07c30666-1a51-44f1-9406-7be878300f78	t	f	2022-02-12 00:00:00	\N	K2	1a8edb59-237a-4d99-8418-f74975fe3f25	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
09b63b3f-5b17-413b-8b54-8862bf8d0f7c	t	f	2022-02-12 00:00:00	\N	K1	df06a883-3e31-4342-a59c-b1754fcbad0b	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
6b2d2ce5-e272-4eec-8c1e-817b00e0a009	t	f	2022-02-12 00:00:00	\N	K1	671aa4c4-e34a-4a31-9212-d238aeb66104	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
af6db6fe-197c-4226-901b-4f6e779e7285	t	f	2022-02-12 00:00:00	\N	K2	68e01579-9062-463c-864a-f7fb9346ab0f	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
990acb14-61c3-4a4c-8643-5cef6ba0a2e6	t	f	2022-02-12 00:00:00	\N	K2	64962a91-5632-474a-b889-b24dfa24d96e	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
bdeaa4d6-9f4e-499c-965d-24193741ec32	t	f	2022-02-12 00:00:00	\N	K2	ed602fb3-23bf-45b3-b1b7-86f121283e6e	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
f93b0de5-983d-4edf-8cb3-13bfe2edf1ea	t	f	2022-02-12 00:00:00	\N	K2	2a4293e1-0c0c-4cb2-856f-0c874c6a91f0	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
beb05fb5-9174-44d5-a6c4-31d4eac6735b	t	f	2022-02-12 00:00:00	\N	K5B	312b27c5-ad2c-451b-bbcd-c125baa6347d	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
7817b2e9-99b5-4bd1-9dea-43446a2d8c97	t	f	2022-02-12 00:00:00	\N	K6	5ba6892f-4513-45cf-8814-0f799febed47	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
051cca46-847c-4901-9913-07d95041a683	t	f	2022-02-12 00:00:00	\N	K4	c661822f-3f9b-4644-bc3b-c786ee1aeecb	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
58d82323-f354-4f61-9ddb-5a83cdccf66d	t	f	2022-02-12 00:00:00	\N	K1	f34da9b4-6687-4468-a3fa-4f799bee9653	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
5226a644-57dc-46e1-b50b-6850f4e3a26e	t	f	2022-02-12 00:00:00	\N	K5B	a0001b52-3ee5-4b3a-88dd-2542b0933711	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
a907f966-23fd-4333-b1ef-18a119e7d171	t	f	2022-02-12 00:00:00	\N	K1	b3e2d484-dd24-4bc9-afc1-debae1ef4a5e	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
c421ebec-21e8-4b1d-b6f2-ffec84091c71	t	f	2022-02-12 00:00:00	\N	K3	ee997d20-cbf8-4e4a-8f30-ff227b885e0c	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
1b5676cc-407f-4519-bbf7-5b049a3d8715	t	f	2022-02-12 00:00:00	\N	K1	34fa2d0d-9821-482f-974d-75360c2f3253	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
f6c84bb7-dcdc-488e-a2ee-6b220d8e74d1	t	f	2022-02-12 00:00:00	\N	K1	b93fde1c-4ba9-4be8-9d0f-09e61b6ed38e	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
8a8a9af9-9910-4738-92dc-c508cf74e363	t	f	2022-02-07 00:00:00	\N	K2	3a391648-4655-45a0-a4ca-b5c46395833e	0fa002f3-d432-46d4-a753-991d021db3fa	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	\N	\N	\N	\N	STARTET	\N
43989da1-becf-4030-9977-d1f2b155fe07	t	f	2022-02-07 00:00:00	\N	K2	5cdcf9db-8780-4d70-b7e6-c55041131f31	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
b2297dcb-3e6c-4a60-935e-146a8088e79c	t	f	2022-02-07 00:00:00	\N	K2	1891d952-6085-437f-8848-0821670cafbe	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
1edb8f96-1c57-4317-8442-2c61a23b6cd2	t	f	2022-02-07 00:00:00	\N	K2	73fa3706-776e-4728-bffb-a0bdf5542431	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
8c5a9e70-b861-48e2-ac78-3ecd6a794e03	t	f	2022-02-07 00:00:00	\N	K2	91a3f77c-3ba9-4c07-823a-627fead3c2a5	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
153d1eec-58d7-4b84-80a1-39825e0128a8	t	f	2022-02-07 00:00:00	\N	K2	44ba48c7-9ef2-4f89-b040-b69ad23df045	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
5cdfa02a-4f9b-4592-9e83-fc0f088a2741	t	f	2022-02-07 00:00:00	\N	K2	e7bd8211-f920-4efa-a97f-bd9aca38014b	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
cec4bcaa-b0dc-4483-8ba3-567c0b104dbd	t	f	2022-02-07 00:00:00	\N	K1	19bfa43e-bd2a-418f-9561-57f708c74bba	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
a7f29f77-55aa-44bc-92cf-afdb7a632458	t	f	2022-02-07 00:00:00	\N	K1	35ef02f5-6e0d-4b15-a261-0c04aefd8dcc	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
c96765a2-2a8d-4b19-9f34-86dd5db23b7e	t	f	2022-02-07 00:00:00	\N	K2	c37872ea-37e8-47f1-9af3-16a2cfbc474e	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
349efba0-803e-4e75-add1-7bbe17204ba1	t	f	2022-02-07 00:00:00	\N	K1	7af09c92-0722-4781-99bd-4061b9c4a23a	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
ac296ea0-04d4-4372-b6e9-9486ee086a6e	t	f	2022-02-07 00:00:00	\N	KEIN_START	eaf4e0de-e70e-40ab-9d96-f534465d0a1d	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
f882eed5-c5e2-4e31-93ad-4770fb902a87	t	f	2022-02-07 00:00:00	\N	K2	90a30b6c-edaf-468d-a96d-b9439e5e4c16	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
199e3e07-60d6-434f-acbe-7813a7673bc3	t	f	2022-02-07 00:00:00	\N	K1	6ccc065f-7240-440e-9984-bf06ce6abd72	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
1f5781ca-4138-48ab-8384-9bbb281d03f1	t	f	2022-02-07 00:00:00	\N	K1	57554ab0-0176-4a04-926e-a9c6c85fec2d	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
6629f9c6-7a69-485c-8e4e-48a1321a4bb2	t	f	2022-02-07 00:00:00	\N	K1	2b950d2f-e455-4479-a2c0-87a7cb06265e	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
4eecf416-33dd-4e2b-8c79-1280135bd78d	t	f	2022-02-07 00:00:00	\N	K3	0c2aa755-6cfc-4ed3-93af-1c84919de12d	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
0fe35f0b-41d3-417d-811d-17df81ffee75	t	f	2022-02-07 00:00:00	\N	K3	27a8a796-f642-43df-862a-d6918cc9ca50	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
7b95f739-df52-4b1f-9e69-a15c59873a40	t	f	2022-02-07 00:00:00	\N	K4	1f2c9273-0d7b-48c3-80f1-e332bfa394a5	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
1a660e67-560e-48eb-ad70-106d55289a07	t	f	2022-02-07 00:00:00	\N	K4	08b408c6-3097-43bb-b67e-091451c7f1e0	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
be6c0573-349a-48d2-8824-bf17dec9ca4d	t	f	2022-02-07 00:00:00	\N	K4	2fdb9ffd-a9d6-42ce-a6ac-cfe5b0f947cd	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
3a299c47-bfe3-49c6-ab09-c225fb895b7d	t	f	2022-02-07 00:00:00	\N	K4	b0b84556-1154-49ae-b24c-d48601a68237	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
e7fc7133-b8b1-4cbd-a389-9791263c8341	t	f	2022-02-07 00:00:00	\N	K4	51141fff-f4ec-4329-86d0-3d364981b666	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
b3170c26-38d4-4d3c-9940-23f6d4859ed6	t	f	2022-02-07 00:00:00	\N	K5B	8be21209-74dc-43f2-90ae-899edab1754e	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
c003307c-80af-413f-86bb-2ca20f4a364d	t	f	2022-02-07 00:00:00	\N	K4	df4a26ac-5018-45bf-9df8-52070b216dac	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
cc8fae1c-2455-4f84-af52-9fa818f5a0d7	t	f	2022-02-07 00:00:00	\N	K5B	6daae379-0879-4ccd-8690-b64aebc2d7d6	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
6fcbd275-c2b4-4f26-81a4-80ac025badc0	t	f	2022-02-07 00:00:00	\N	K5B	bc0b61f7-f7b6-41cb-8e30-0875d044f2d8	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
e2c501d9-e4d3-4f37-92e8-9720ef1c9cdc	t	f	2022-02-07 00:00:00	\N	K5B	404b262a-57ad-404d-bd38-26979ce5715d	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
90591ab3-8062-47f7-81fa-eaa3e0977c0f	t	f	2022-02-07 00:00:00	\N	K5B	88a07c39-d9a1-4c44-a9f9-b42bb4e603cd	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
41a4b84e-af1a-4232-9e22-7f2afe135586	t	f	2022-02-07 00:00:00	\N	K5B	c8da0297-b38a-4b15-8cf1-e621a9b319af	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
7dd021d0-00fb-462b-b6bf-13e474d4f896	t	f	2022-02-07 00:00:00	\N	K5B	9136f058-3ebb-4285-bb85-a5a8ddd4b79e	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
e323f9c4-2e0e-47a1-b277-56fe54b018d5	t	f	2022-02-07 00:00:00	\N	K5B	7e84e7b5-869e-4a32-9b18-c94008af3c9c	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
d2cb91ee-ce81-43ec-a1db-9cc12b127d3c	t	f	2022-02-07 00:00:00	\N	K5B	a49ea6a6-30e5-482e-962c-458b747f23a8	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
9fe0a2ab-ac04-45d1-9dc2-93b3be7b0238	t	f	2022-02-07 00:00:00	\N	K5A	0124ca13-e5bc-4aa9-a952-eaa5dac28170	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
98ef2e3a-6bda-42af-b2d1-fe6d149146a6	t	f	2022-02-07 00:00:00	\N	K5A	2f2eadc6-58fb-4495-bedf-681816ad717e	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
91a90579-c5a7-4249-8c8d-8019250c2409	t	f	2022-02-07 00:00:00	\N	K5A	3f383324-1dc0-4815-a8fb-4347c9678916	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
8e125416-cc16-42c7-aa0b-f88968fc5f61	t	f	2022-02-07 00:00:00	\N	K5A	7e7fd560-3ebc-4765-be45-24fc0f4f35d3	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
048606af-c803-4c58-8d7e-ea85b6cd541f	t	f	2022-02-07 00:00:00	\N	K5A	98c0ead9-1a8a-46f9-9f0d-95cebeb3fa4d	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
69ff9631-2cc6-472b-923b-ea766451c18c	t	f	2022-02-07 00:00:00	\N	K5A	7825ac07-0605-4a5d-80c9-2dc3482d812d	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
e4d9e6cb-6658-49e7-a3c7-333a38bead00	t	f	2022-02-07 00:00:00	\N	K5A	8523bc16-1315-4f92-b0d3-486f136fb743	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
9e0fe6e5-622f-4c26-b80b-cb96e0fe0c55	t	f	2022-02-07 00:00:00	\N	K6	41882def-df1b-4ef9-b750-f748d42a08bf	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
ebe3e18a-1268-46b6-8732-be81ec9b21ff	t	f	2022-02-07 00:00:00	\N	K6	dad4798e-62b0-48eb-9a9a-1fc20661f511	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
b0ead7f7-7ef0-4af0-a0a1-6fbc8e7af4ce	t	f	2022-02-07 00:00:00	\N	KD	86ebbdce-89ed-48da-ac59-e3d2ee05d1a5	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
3737cfbe-ef1c-4643-81a0-8a287fe015f9	t	f	2022-02-07 00:00:00	\N	KD	003e4dc3-ff55-400a-92aa-3dbe4c597946	0fa002f3-d432-46d4-a753-991d021db3fa	81308200-79d0-466c-a19a-ca3fbef6045a	\N	\N	\N	\N	STARTET	\N
ecf3754c-c3a2-4a09-b08c-fc412c299976	t	f	2022-02-08 00:00:00	\N	K6	1e3e49b7-86a2-49b4-90eb-38f5885cdb20	0fa002f3-d432-46d4-a753-991d021db3fa	80c08ccc-c90e-4377-af3b-2de779197c7a	\N	\N	\N	\N	STARTET	\N
06e32e49-1a2f-4e88-8397-8871a2423614	t	f	2022-02-08 00:00:00	\N	K6	5f6c8cce-6b15-4ead-8acf-d64cceff2401	0fa002f3-d432-46d4-a753-991d021db3fa	80c08ccc-c90e-4377-af3b-2de779197c7a	\N	\N	\N	\N	STARTET	\N
9d041ef1-b63b-4300-bfb1-e746e226e86f	t	f	2022-02-10 00:00:00	\N	K3	068175b5-8305-4c61-8d62-4d7fd41236d3	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
9a15fb36-9588-4efa-9f94-b412b1304e80	t	f	2022-01-30 00:00:00	\N	K1	48bc951f-879f-41b0-af57-1817fd5a32ab	b7440787-50bd-4e41-b38b-48acf37af0de	4e9262a1-fef9-4701-9c91-1b3016ee971d	160	\N	\N	\N	STARTET	\N
9ff35a81-9264-468d-916f-c65809b74d7c	t	f	2022-02-08 00:00:00	\N	K4	6ae5f224-0fa0-4b2d-9f63-31543847b18e	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
e15cffd1-17e1-437e-9146-9d6a33dfde01	t	f	2022-02-08 00:00:00	\N	K6	32860ba8-3a33-489d-8aff-9bb9b183dee0	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
a9f5dedb-a5fc-41be-b39c-cb46f702251a	t	f	2022-02-08 00:00:00	\N	K7	96ed28a8-8a79-46bf-9e57-b10105c181bd	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
55c6b2a9-0aed-44f5-aa65-9dae58f405d5	t	f	2022-02-08 00:00:00	\N	K4	cf654f83-de82-4d41-a843-2dde0799e14a	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
4fe798c4-ac07-4bf6-ab5c-6991f5f9f4b0	t	f	2022-02-08 00:00:00	\N	K6	17a7016b-6228-4a34-809d-39402d6845c4	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
86fa96d3-1968-4051-b358-40a95156935e	t	f	2022-02-08 00:00:00	\N	K3	d6efaffe-3aa9-44b0-b5a8-1750ca799e8c	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
ab426b7a-2944-4c02-82a7-762dc49975a3	t	f	2022-02-08 00:00:00	\N	K2	9fc87fff-2510-4327-9c0e-7a05f3085dd8	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
fd5d152d-83ad-4fcb-8867-d4d1963510c5	t	f	2022-02-08 00:00:00	\N	K3	b553f3be-1141-4e96-9e47-8c22000f2737	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
826da15f-8011-4980-973e-eca2f1666b81	t	f	2022-02-08 00:00:00	\N	K2	52629669-ed1c-4fe7-b9cb-9c89a48230b5	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
9d607d74-3930-4cab-ac31-40d5dbee60c6	t	f	2022-02-08 00:00:00	\N	K4	549f5d94-0496-4769-b379-d9c544362f42	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
0b79a1e4-d577-4eae-93f0-45ad93b7f782	t	f	2022-02-08 00:00:00	\N	K4	46849279-dfbe-494c-a436-b7ab726d075d	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
7c39785b-4377-4b38-857b-5904e841ba6b	t	f	2022-02-08 00:00:00	\N	K4	f38d087e-f090-480c-acd6-f83c03d978e5	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
77fbd300-3b23-4252-b0b3-cfebf34f5fcc	t	f	2022-02-08 00:00:00	\N	K4	cca9c568-dd1b-4b8c-bc90-fc898f9e2c6d	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
c7595d1a-cc7b-4737-b4e9-99f80cdd801b	t	f	2022-02-08 00:00:00	\N	K6	e4bf8718-c22f-4d12-a204-b1f80a6bda49	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
254b8a66-25bd-42e6-8a97-4933f35f4118	t	f	2022-02-08 00:00:00	\N	K2	2a5040fd-e605-40e5-96da-7b86da83c9f6	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
0e50571d-7ea3-402d-9fca-14ac56366a79	t	f	2022-02-10 00:00:00	\N	K3	36bd4fb3-8a50-4fe9-83cd-d35c0fa69515	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
a5ae83f8-4be7-4db0-ba0c-2cc04d3c1978	t	f	2022-02-10 00:00:00	\N	K5B	324aede9-ff62-4842-b7b2-ad18b7a0b544	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
9b8c3a51-a355-42c3-a0ba-cfee1c44a9d2	t	f	2022-02-10 00:00:00	\N	K4	bf0d7211-7857-4513-b3ac-36be142d5f74	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
42f01d0f-2253-451a-a768-36616db9cbb9	t	f	2022-02-10 00:00:00	\N	K1	5a11d4ce-fb3d-4538-a191-199e997326dd	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
e9a7558c-8aad-4802-9d76-d0386ff5c85f	t	f	2022-02-10 00:00:00	\N	K3	a2233224-1f91-4fc0-ae2c-ec1d77bf3c2f	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
87a0f976-009b-43ed-a2c0-84b1c81d966e	t	f	2022-02-10 00:00:00	\N	K1	d1bd04b4-398d-48b5-9ec2-a6350c81e85a	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
c5848266-f607-4f53-8a91-cc96c8ff84d0	t	f	2022-02-10 00:00:00	\N	K3	4486774f-d237-4013-b8a3-4505f52634b2	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
9f4c4e35-1cb3-4c38-8413-1bd145a7cd1f	t	f	2022-02-10 00:00:00	\N	K4	3ce4b32c-a049-4312-a865-553ef84eb731	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
77989e26-a80b-45b4-a12b-69f49e585b15	t	f	2022-02-10 00:00:00	\N	K4	1100f1d4-c172-46b6-b03c-485efb044fbe	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
d33b2665-1a9a-4443-9b25-06cb137a5cf1	t	f	2022-02-10 00:00:00	\N	K5A	37499c09-b6c5-4093-9f6a-0a5891eee754	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
9412bec1-ffc7-420f-8c8b-a4269aa5693a	t	f	2022-02-11 00:00:00	\N	K4	ebf57613-57f2-433c-9387-058a8e774c47	0fa002f3-d432-46d4-a753-991d021db3fa	24510313-6d39-4217-bb3f-0bfa7fbb73d3	\N	\N	\N	\N	STARTET	\N
bf7def13-206d-45cc-b7c2-28f157e4428a	t	f	2022-02-11 00:00:00	\N	K3	19eb3b8c-2a9c-4909-a852-48153ac9785d	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
46ddc4f8-9b72-4c88-a7a3-fc90f4eb0f1c	t	f	2022-02-11 00:00:00	\N	K5A	622f243a-2ece-40bf-b68f-8e524b32511c	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
f299a8cd-7e53-4f05-87fa-7371fff98cb0	t	f	2022-02-11 00:00:00	\N	K2	248f71cf-e0ab-43df-ac4d-27a5f4de3c8d	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
8bf734ab-edbc-47da-b776-946e1b5b86e3	t	f	2022-02-11 00:00:00	\N	K2	806b10d9-e677-40ed-9176-d92814453928	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
0518f583-3a73-4c7e-bab8-a63f563981db	t	f	2022-02-11 00:00:00	\N	K4	8753f33f-3b8e-455b-af53-bec11985bc3a	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
73e1b7bb-2913-437d-91f4-e22f073690e3	t	f	2022-02-11 00:00:00	\N	K5A	bc9fa9fd-46ca-4e79-ab3f-9e81a670432f	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
f77d0359-cf30-4066-9a9d-25bb24ddba1b	t	f	2022-02-11 00:00:00	\N	K6	95bbb9a5-5cdf-47cf-bf24-78bc1bc80c61	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
86a37193-75dc-403d-ad62-e4b6984826d7	t	f	2022-02-11 00:00:00	\N	K5B	c4827954-a566-4997-9605-74693e2af71e	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
33b8e810-224d-4377-9358-39033c2c3803	t	f	2022-02-11 00:00:00	\N	K1	5b7ba28a-d957-4555-9336-06df2df08547	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
c5839e91-736e-48f2-a547-cd621199d395	t	f	2022-02-11 00:00:00	\N	K1	21a5c403-3df8-4d71-ace9-0caa17755601	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
78e3bd3f-92a2-4ac4-81bc-aa409db568b0	t	f	2022-02-12 00:00:00	\N	K6	293d2c31-582b-41f1-855f-da90f1ba5e0c	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
cbeae8a1-439a-45aa-b065-c7f3ccb8ae0b	t	f	2022-02-12 00:00:00	\N	K1	de86c2a4-b5dc-4735-9cae-6d242d15f723	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
402243f4-4884-4516-9f58-00d9930c1239	t	f	2022-02-12 00:00:00	\N	K1	65f95fec-c983-4d64-bebd-f346c9d9814a	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
499ce38b-d56a-4488-b67b-6ff08ca739b8	t	f	2022-02-12 00:00:00	\N	K2	2a6f9197-e7e3-4d14-a82d-ca7ae7e36743	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
137909a7-876e-43dc-ae20-b2d330101873	t	f	2022-02-12 00:00:00	\N	K1	a9708c95-0b25-4e8f-b279-e10f7bc71636	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
39489e67-5177-4cb6-a4ef-af8166fe3ce9	t	f	2022-02-12 00:00:00	\N	K6	4931e7c7-737f-4d58-a523-2f625aca002b	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
6b05029e-d1cc-454a-9389-e366f5b110e6	t	f	2022-02-12 00:00:00	\N	K5B	68b1e2fc-b799-4aff-9939-322b89f16232	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
ffa6e076-f093-45e0-80f4-39a664ef24fd	t	f	2022-02-12 00:00:00	\N	K4	e4bf911c-db18-4cac-9200-a3d7640881e8	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
b7586f1b-9b38-48a8-8e74-3acb67108405	t	f	2022-02-12 00:00:00	\N	K1	f4636b6d-8b45-416b-b703-43f2938b17a7	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
f4dd03d9-cf78-4356-a140-259f9c98fcef	t	f	2022-02-12 00:00:00	\N	K4	591b6268-85f6-4541-a3a0-34bba7b73b00	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
71a802db-6584-45fc-bbde-9740379a7355	t	f	2022-02-12 00:00:00	\N	K4	c9bf4bd3-fe04-4ffa-8167-11eeeb28ef8b	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
e6f42b4f-19d5-466c-85b1-85e019927d18	t	f	2022-02-12 00:00:00	\N	K4	e1cc6891-f926-448a-9d36-e52d93139468	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
3ef24a36-ae0e-4a9c-b1bf-47534a978305	t	f	2022-02-12 00:00:00	\N	K2	ef0c9179-4406-4457-a6d9-0d169f39aa12	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
03051fcf-bdb4-4843-b6a3-5104064a85bb	t	f	2022-02-12 00:00:00	\N	K1	2689bbb2-b8e0-4c7a-8e67-bab35df6b0e5	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
efdc619a-b2fa-45b2-b119-7c5ae3114914	t	f	2022-02-12 00:00:00	\N	K1	3eb3f4e8-7292-4717-99da-901eef821181	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
909c7607-f764-4cba-9d2c-cd94557c6a8b	t	f	2022-02-12 00:00:00	\N	K1	e796e9a7-0489-4028-b68a-3ca83ec7dbac	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
f225a597-4c0f-4412-a3f2-ad9aa57b99a7	t	f	2022-02-12 00:00:00	\N	K2	1642eea4-aac0-4b5f-91fa-10893e51989a	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
aa70d6b8-cfee-444f-9a21-0f8ff75f79fb	t	f	2022-02-12 00:00:00	\N	K4	c79954ff-50d5-4509-ad43-a625f2e6eec4	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
e59ab9a6-68a0-408a-9af0-5b2270dcf6ca	t	f	2022-02-12 00:00:00	\N	K4	629d829e-d7e8-4ab4-a1d5-3839124166c5	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
af5fb0d7-b1cf-490b-a9ad-7be3745c5c03	t	f	2022-02-12 00:00:00	\N	K5A	c833131a-b95d-4597-96ac-8d60b3763aa7	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
ee3e4a44-fa79-48fe-bd4a-8cf345531bce	t	f	2022-02-12 00:00:00	\N	K7	d615fce7-57d4-4450-a43c-5917a973f2d4	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
b61d53d4-fe07-4d6d-b68d-5da22cb8d75a	t	f	2022-02-12 00:00:00	\N	K6	a7671c51-9970-495c-a2d7-f23c5cef5c42	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
d741fef8-99d4-4e3d-be80-595ee72098b3	t	f	2022-02-12 00:00:00	\N	K1	48b04d65-471d-48bd-9975-9bcc96c323c9	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
fd215f52-a0ef-49ba-88a8-a01a09fc4ab9	t	f	2022-02-12 00:00:00	\N	K1	ecc7ee7a-df9d-44bb-9379-7f4e927d9835	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
530d8405-c27a-47b8-8d4a-744d61943d61	t	f	2022-02-12 00:00:00	\N	K5B	b910832d-458a-4d53-b1b9-ffe8e01fcc43	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
c91e929f-a5e0-4238-8af2-44dc43c50bc7	t	f	2022-02-12 00:00:00	\N	K1	2c03d22e-ff21-4d07-aed6-39d1ab816588	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
e25d3b0b-d704-4c9f-a4e8-dbd79ed9c287	t	f	2022-02-12 00:00:00	\N	K4	cc913582-3cc2-4563-98f1-af9738ac3e1d	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
43a57934-41ea-409a-99bf-f79b6e3f024d	t	f	2022-02-12 00:00:00	\N	K4	4999e2ee-d748-4aad-8336-5ec68e0a93ab	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
2b434044-b879-4bd7-9912-801525d825ad	t	f	2022-02-12 00:00:00	\N	K5B	1cd79060-b588-4f16-86f1-02e10b9c1936	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
898e9a56-0c13-4b81-bbaf-798576864a93	t	f	2022-02-12 00:00:00	\N	K4	114106e5-365c-4335-9870-2d7239a5435f	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
8a1fc0a3-6d12-46cc-8456-4f0e850cdc8b	t	f	2022-02-12 00:00:00	\N	K3	89866ee8-71da-4414-8002-dfdeb9b1e4a8	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
f489534a-ee7d-4ca6-bc7c-47f8b2df34ee	t	f	2022-02-12 00:00:00	\N	K3	454ad479-09e9-4f77-875c-9748519cfb1a	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
02828639-54cd-4702-8822-b95975a582e9	t	f	2022-02-12 00:00:00	\N	K1	984056b2-958c-4d85-9179-6b926177eae7	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
bb1f6c15-309f-40ea-a75d-c3a332df638e	t	f	2022-02-12 00:00:00	\N	K1	4454075d-3ef8-4fed-b3a6-a0970872c13d	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
88b3abde-cf89-45de-8622-4beb89355bd9	t	f	2022-02-12 00:00:00	\N	K2	2ac66196-815d-4cd6-a58c-3971dc45f786	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
16d5f501-eaab-428c-b397-60d43202a17c	t	f	2022-02-12 00:00:00	\N	K3	14317636-c140-4094-baa5-d82f3241f8c4	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
4b47861d-ed07-4c98-b7ac-653c5608e437	t	f	2022-02-12 00:00:00	\N	K5A	7541cd2d-202f-4969-a8ab-3e7f7e14f642	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
896bba85-ef41-4511-bb1a-c14323811120	t	f	2022-02-13 00:00:00	\N	K2	cc13adc4-bdb6-4afe-9e2d-7405884d627b	0fa002f3-d432-46d4-a753-991d021db3fa	80c08ccc-c90e-4377-af3b-2de779197c7a	\N	\N	\N	\N	STARTET	\N
1ebeed8a-691f-487c-b1d2-a6e89d66e2fc	t	f	2022-02-08 00:00:00	\N	K7	aaf4f808-c320-4b2b-b000-2cc026e3556b	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
b28e4a22-5f9c-4155-aed5-fed322f3e22d	t	f	2022-02-08 00:00:00	\N	K2	fb96c26d-e059-4953-93f3-1edb8537c221	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
33f3fc99-eff4-46d8-a775-daaec0c0fbdd	t	f	2022-02-10 00:00:00	\N	K3	30198e78-e28d-41e6-afd3-8432d259b803	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
38938784-43a3-4882-929c-b34fa33a3285	t	f	2022-02-10 00:00:00	\N	K2	7693377f-42ee-416d-aa32-ef8fe50352e8	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
785b3447-6b8a-426a-aac7-bb17d60a13ea	t	f	2022-02-10 00:00:00	\N	K2	84f3b872-e15b-4ba5-8b59-81eedc7514ff	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
28d2e0ab-2797-4b7d-bb5e-b5d7e807ff40	t	f	2022-02-10 00:00:00	\N	K5B	e9708e57-9005-42cc-8cc1-6e0997818651	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
b079c981-80bf-48a2-a6b6-388f90e9e3ef	t	f	2022-02-10 00:00:00	\N	K5A	69e1bb2b-070f-4040-b8ef-efb8c540e48b	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
fea448cf-fda7-41da-bc71-7661cd610ad2	t	f	2022-02-10 00:00:00	\N	K6	7d267e77-4449-469e-8118-4fbe2f6761ce	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
71ce2daa-ab23-4b99-a87b-f30880251cf5	t	f	2022-02-10 00:00:00	\N	K6	ab7d9af9-f436-4167-9504-bd973e5f2855	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
f6578286-0fa6-4e40-80b4-e2877fd1df64	t	f	2022-02-10 00:00:00	\N	K4	fcfa6fac-ad43-4ce7-84e5-ffc9373086f5	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
937cbd85-2e14-4c26-8407-83bc77f3d191	t	f	2022-02-10 00:00:00	\N	K6	9660b37c-45c7-4e5b-850d-e04b931fbe17	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
02617db4-bac8-43d7-af3f-47553d31963e	t	f	2022-02-10 00:00:00	\N	K2	4040561f-f9ed-47ef-8708-7a983e4c0ff6	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
ea495027-7bee-4eef-9d88-3de270a0984a	t	f	2022-02-11 00:00:00	\N	K1	b3d038cd-f30d-40cb-8f06-0b4dc6290af6	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
b1c7816b-c156-4d07-91f9-29c008e48ce0	t	f	2022-02-11 00:00:00	\N	K6	ec9dfa4c-de2d-497d-a937-033fc874d694	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
6c3a5398-bd2d-46e3-9905-2e790f89b809	t	f	2022-02-11 00:00:00	\N	K2	008a526e-49f5-4c38-b320-69f083b04685	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
13a9c292-c00f-45c2-b44c-6b9193dcd938	t	f	2022-02-11 00:00:00	\N	K5A	f1a8ee6f-9677-428a-ad4b-e9a44d85e364	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
87ce2ae3-2a51-4a49-b4ee-ef7aa281535d	t	f	2022-02-11 00:00:00	\N	K2	58246350-5bb9-4f69-afab-bf9bd5aa0820	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
2421ef26-0baf-478a-ae89-da8abfecf1da	t	f	2022-02-11 00:00:00	\N	K3	452a5ebd-f90c-49fc-884f-7e3b6de3d5f4	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
c6715636-f726-45d6-89bf-01d0dae89c01	t	f	2022-02-11 00:00:00	\N	K5B	67852033-a261-466e-8c78-b5749ce92f4c	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
6bbe569b-587e-4d5f-8819-a1fbbf61ab13	t	f	2022-02-11 00:00:00	\N	K4	9762b60e-318a-4312-9be1-f787e41a824f	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
ba296cbb-2f01-4260-8b37-f105b11f731d	t	f	2022-02-11 00:00:00	\N	K5B	4f5e1ac1-23c5-4e6d-baa3-94a839c24540	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
9d9ae3da-6163-46c5-9177-9f576af0200c	t	f	2022-02-11 00:00:00	\N	K1	8d1b2bc1-10ea-49fb-a0b1-102b97780d6c	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
f42de6f4-9cb5-4be0-ae72-9c98aff1c03b	t	f	2022-02-11 00:00:00	\N	K1	e025a25d-2a64-4da7-9889-06214d75686a	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
040a02e2-003c-4d50-b299-d509c322df71	t	f	2022-02-12 00:00:00	\N	K4	8d961428-620f-4d0c-8fba-1ba3ac4cdff5	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
c188a5a8-388b-4199-842b-4d1fcd3bc598	t	f	2022-02-12 00:00:00	\N	K2	834672cd-b483-4919-91a7-b0b5e030a276	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
0565420a-06b1-4221-9a1f-49b859c93f74	t	f	2022-02-12 00:00:00	\N	K2	4eeaa412-2086-4ec0-9649-833434bca94e	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
86deae78-95c1-4736-b477-6b1176efbff8	t	f	2022-02-12 00:00:00	\N	K2	d73b30fe-8026-4f08-b384-58e7a59e03b7	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
204188bb-e94f-4eff-a44f-9f70d814d0db	t	f	2022-02-12 00:00:00	\N	K7	bda6ecda-4fba-458d-b20a-69d163bcf157	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
ad394397-4b69-4cc3-b9c0-a82670a8f425	t	f	2022-02-12 00:00:00	\N	K1	713b4ffa-63d8-430f-8fbc-6fc4dc3de498	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
124d8411-2641-4991-aaed-7481530e8397	t	f	2022-02-12 00:00:00	\N	K2	3530944c-31de-48ae-a95e-c275af988ff2	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
b44c47ae-477b-4c5d-89d4-14a47d840ef1	t	f	2022-02-12 00:00:00	\N	K4	31fe1b86-6f4e-4019-b29a-d97b3a7d67c9	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
9e171da8-44e9-4a31-901a-5fa873159e68	t	f	2022-02-12 00:00:00	\N	K4	2db43a74-1b37-47ae-8b3c-8d83216f0996	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
87e07807-98cd-4065-b3d4-0028f698e4d9	t	f	2022-02-12 00:00:00	\N	K2	463f5a6e-52bf-42f7-b603-c28d9cf35a2d	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
e338cacc-7681-41ba-a5a2-7633333bf249	t	f	2022-02-12 00:00:00	\N	K1	d1690823-6b6f-4e55-a46a-8bc73fa0d6fe	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
ad9caafb-95b4-46fe-bdda-134477abf242	t	f	2022-02-12 00:00:00	\N	K2	56ed6c2f-620d-4970-bbe5-c0a0da72c432	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
3edf01b8-abef-4eb8-adea-b6912a15da70	t	f	2022-02-12 00:00:00	\N	K1	1302994a-f60b-4969-a007-e66a722ac07b	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
0438cfac-763f-4875-9a38-805790c24ee1	t	f	2022-02-12 00:00:00	\N	K3	f2206a00-7dd9-4bdc-b0fe-de4ecee7a577	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
b8fa06da-913f-43b2-87cf-366b872b7255	t	f	2022-02-12 00:00:00	\N	K3	52a93100-fdf0-4802-8f8b-14ff488ee048	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
7208b7fe-2971-4ab5-8b63-cdfcde81195b	t	f	2022-02-12 00:00:00	\N	K4	a33b819f-72c9-48ac-a5d6-ef5cfc24dd66	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
44dfb93d-67dc-4e12-b6e3-8f820de96de7	t	f	2022-02-12 00:00:00	\N	K5A	feeefcc4-ade1-4521-a378-a113b5e5566d	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
8df52deb-9812-45e7-9123-abcc31d3d9a4	t	f	2022-02-12 00:00:00	\N	K5B	829254bc-6b3e-4967-851d-4e0c3e418481	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
c6c080a8-cfcc-4008-8e14-c27bd8bf535e	t	f	2022-02-11 00:00:00	\N	KEIN_START	663e698c-2eff-44f2-8b35-b64d66b86b33	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
4beab88e-9eea-4305-a511-1e26a4e7f316	t	f	2022-02-12 00:00:00	\N	KEIN_START	f9808c47-bbe3-4f2a-a53d-170f20dced96	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
4724a6ca-d189-4ae9-97a4-9bb0bf1accfa	t	f	2022-02-12 00:00:00	\N	K3	7c7af252-16e7-42cb-ab4d-958a5293d826	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
153e85ab-b78f-40ae-b988-f12ac1492d6e	t	f	2022-02-12 00:00:00	\N	K3	10bf05eb-3d95-45de-a973-134a321e5e7b	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
89fc3eb2-dedb-487c-90e7-f6f3422b0b20	t	f	2022-02-12 00:00:00	\N	K2	79e7d469-dcc6-4e98-b1d1-582d6e64c931	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
0b6db4b9-c4e6-475d-934e-9c9238eb1e10	t	f	2022-02-12 00:00:00	\N	K1	6c810567-a2ec-4bf7-82a4-892f8090e500	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
4a87ad70-f274-40e4-ba3f-84e8f8ed8461	t	f	2022-02-12 00:00:00	\N	K1	526638ae-ea16-4fa2-bdbc-0923158a8e5c	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
e9a365e2-0d40-4afd-9cad-b0d37a5d21f4	t	f	2022-02-12 00:00:00	\N	K6	cbfb4fdd-147a-4c57-a163-fafb5ae24939	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
89c99128-a81d-45ea-8804-a915ec1d1466	t	f	2022-02-12 00:00:00	\N	K1	7cbd7c2a-ea74-4cb2-92b2-639c5c240c05	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
7a742273-4146-40c8-9236-037aaf4309bb	t	f	2022-02-12 00:00:00	\N	K2	4896af5f-29f2-4b18-bbf3-f48f07b2412a	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
53f073cf-2b99-44b3-962c-df2148cc7834	t	f	2022-02-12 00:00:00	\N	K2	147fd022-8747-43a5-8ab2-4f574c486f9e	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
6ae077c6-3ed0-4686-8d4b-ceb5b67aee07	t	f	2022-02-12 00:00:00	\N	K2	7393a238-61c8-49c4-9f7c-d67fe1f6c93f	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
6df0c6fb-cd5f-46ea-882a-32fa69ec059c	t	f	2022-02-12 00:00:00	\N	K1	3ccaf659-c761-4618-a3a9-2d25a1b3b0ea	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
390e6696-491b-4282-9961-6d34a8a6ecdf	t	f	2022-02-12 00:00:00	\N	K2	1f22b066-d2b4-4941-abef-5c56348cdb18	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
0d5bf7fb-aa38-4b3d-9e41-836586299115	t	f	2022-02-12 00:00:00	\N	K3	c79b38bc-b783-42ae-b939-131743168a25	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
302252cc-ddf7-4b91-8da3-64c12c1f23c2	t	f	2022-02-12 00:00:00	\N	K6	59b79a17-b50d-4e34-aef1-7856d3a110c8	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
37b3b239-b0a4-4578-8458-93365a5b4ce1	t	f	2022-02-12 00:00:00	\N	K3	216f5fda-c407-43cc-a656-8a2a5c4f6094	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
0a211283-4d50-4bb3-a64b-a6ad6fc70186	t	f	2022-02-12 00:00:00	\N	K3	be976a99-c795-4d35-a2d5-0ba7b80684be	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
91782f3a-e81a-41b1-9dc0-a34818d897e7	t	f	2022-02-12 00:00:00	\N	K3	d8b0f2f3-a349-4fbe-bf4c-30d4d216cf0d	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
b971e1b4-1a52-4836-8e2b-dd5eb49d4ba8	t	f	2022-02-12 00:00:00	\N	K3	ce31658a-2589-493f-8273-f2d530cb8fe0	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
2ce40eb3-0e76-48b2-b22b-1efffd42f30c	t	f	2022-02-08 00:00:00	\N	K3	e6ab3234-26db-4ab3-9597-3a7eca95d380	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
1eefcbc0-aed1-4ae4-a955-3647bc7818f7	t	f	2022-02-10 00:00:00	\N	K3	cb338f4f-23d7-4970-993b-aef8e8b8bdbb	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
82ffb84c-153d-4c67-b757-f8572db42e82	t	f	2022-02-10 00:00:00	\N	K3	d9f53238-33b5-4b14-b57a-364bff864fa9	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
1df6353a-1af9-48c6-9168-f7782b9626f6	t	f	2022-02-10 00:00:00	\N	K6	369dc04d-4bbe-4d2f-b201-c1b1cabaa8ee	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
6ee1696b-1a7c-4b86-81d2-178ffc3d9542	t	f	2022-02-10 00:00:00	\N	K1	8e2a873d-ac22-4344-bfa5-2ba8ab1306f0	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
0a8a847f-889a-41a6-9e27-0e4f20994d40	t	f	2022-02-10 00:00:00	\N	KD	4444edf2-534e-42cf-8d1f-48b31c60e90d	0fa002f3-d432-46d4-a753-991d021db3fa	a5302a2b-d270-49e5-9876-47c84cb38038	\N	\N	\N	\N	STARTET	\N
72a3d4c7-8a48-4433-b3a0-f26b6da9ad51	t	f	2022-02-10 00:00:00	\N	K4	c233cbe9-f869-43db-b7b0-63f14fef45d8	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
27328b93-bb72-4a27-8fc7-ce44cb897121	t	f	2022-02-10 00:00:00	\N	K4	e304694e-103c-4895-99d7-a38433dfa6f2	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
a9e257a0-66d6-4c6b-b87b-7140525cd852	t	f	2022-02-11 00:00:00	\N	K1	ab12d4b7-2e55-4d99-99cf-58d6e42ab7fb	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
0de1beae-eb21-4cd1-806d-78374cf9f4a8	t	f	2022-02-11 00:00:00	\N	K4	95ea7cde-1201-43f9-98ee-225176ad5aed	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
b3f5b37c-154a-4bef-80b9-ecd8c5262514	t	f	2022-02-11 00:00:00	\N	K4	76afa072-7cec-4906-8b4c-ded09ff90a2a	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
4e234376-3a71-4bf7-b893-e551e2da5a2d	t	f	2022-02-11 00:00:00	\N	K5B	6ca7f798-3700-4f38-bb11-34708b47de39	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
625746f1-3731-4516-b008-a4a87c96b806	t	f	2022-02-11 00:00:00	\N	K3	db78f9a5-5edb-458e-858b-597a3d88f37e	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
1cf64d09-da06-4f54-a5cc-8f8b8e822a3b	t	f	2022-02-11 00:00:00	\N	K2	9e8edb06-d2c9-442b-b90c-d97fe2f6f9d4	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
f2237c61-64b7-4840-a1fa-6d07906bde1e	t	f	2022-02-11 00:00:00	\N	K5A	dbeccae4-484a-48dd-9a20-4176dad974bb	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
e18889af-e4b7-4e5f-9cb7-6e5fbbd0b847	t	f	2022-02-11 00:00:00	\N	K2	4e24cbec-ce75-4754-9f9e-b3350d852f7c	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
326f83e7-a56f-4a0b-bf8d-f3eb69f04980	t	f	2022-02-11 00:00:00	\N	K2	cc9fa917-676a-4667-a998-ed57c6d804e9	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
9fb312e3-3b9e-4b2d-9dcf-aad2e9d22d7d	t	f	2022-02-11 00:00:00	\N	K2	62249475-c7de-45f2-851b-bd039f872653	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
e7089573-0efa-4c41-ae6e-9ea9b9302ef3	t	f	2022-02-11 00:00:00	\N	K6	832fc4d9-6460-426a-a36b-0465f875493b	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
6f4187e5-9756-4e3d-8207-c9ef2e70864f	t	f	2022-02-11 00:00:00	\N	K5B	29b6cb70-9ae4-4b65-bc9a-17645a2a3647	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
dbc1cb1d-5e97-4959-873f-2aec14d27466	t	f	2022-02-11 00:00:00	\N	K5A	9fc388f4-4e78-47a6-9da6-c31cdfe9ab84	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
3028a3df-ebdd-48cd-9045-ab6b55fbeedb	t	f	2022-02-11 00:00:00	\N	K6	a3d2f743-b6de-4e62-a0a4-edf3303c8013	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
ee782114-44b8-444d-96d9-ed078dd435ab	t	f	2022-02-12 00:00:00	\N	K5A	ef1cb3e8-e586-45bd-9858-b9f7f0edc56f	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
335270ca-45b1-42d9-90a0-e1cd6ae38b70	t	f	2022-02-12 00:00:00	\N	K5B	280ba59f-ed89-40e8-a0b8-a73652483618	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
26b964e4-2ed9-4448-aa2a-87afa5554b4a	t	f	2022-02-12 00:00:00	\N	K5B	abd525ac-e2dc-4ab7-86d5-3f9344060026	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
8240db62-d5e9-4b66-ad38-f3f03ed56419	t	f	2022-02-12 00:00:00	\N	K6	6882126c-5047-4c1d-b6ec-08310888d2b2	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
bb78c8e2-d00e-4220-b634-abaeb8617b18	t	f	2022-02-12 00:00:00	\N	K1	2b3839f2-2c30-429e-af91-a44e4b062ffe	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
984a48d4-2aa4-4915-a416-1d8555631b8e	t	f	2022-02-12 00:00:00	\N	KD	424962c9-693b-4e41-8077-0a9ccaec49c0	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
b739d3ce-1172-462f-bd89-0184b4aac473	t	f	2022-02-12 00:00:00	\N	K2	7a245c56-9eca-4ee0-91a8-2f3f7ab2a382	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
2fdf128a-b94d-4a04-b7bc-3705ada9969b	t	f	2022-02-12 00:00:00	\N	K2	4deb6c1b-1aaf-4847-96e4-9c31061a9677	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
3a5f4616-9f47-48e5-8480-23110a088438	t	f	2022-02-12 00:00:00	\N	K6	4b0c8fbb-7305-4fa1-8d35-8c322fa03c15	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
93199a7e-3cc9-4105-93ee-d26bbe5d4abd	t	f	2022-02-12 00:00:00	\N	K1	872953fe-6548-4728-80ef-25e66b8e8edc	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
0b13b245-b123-4fc0-bc6b-b818bfd53768	t	f	2022-02-12 00:00:00	\N	K1	ab0b49d6-7cd9-41e1-bb69-4f27b6dc4786	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
b44d2e4e-a95f-4057-9c65-bd40936a314f	t	f	2022-02-12 00:00:00	\N	K2	cb752530-0c47-43e4-b682-3ffbfdf32946	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
a91f84b3-4cda-4edf-af45-090d7019263d	t	f	2022-02-12 00:00:00	\N	K5A	2ea85b08-27b6-4ace-a451-5747c57bbeac	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
4edec722-4122-4ee9-abfa-f950736999ae	t	f	2022-02-12 00:00:00	\N	K1	54b727f1-80d5-42f1-a838-168bf3dc7836	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
70db7bfc-5f48-47af-aa8d-abe940552bd4	t	f	2022-02-12 00:00:00	\N	K1	0861b110-9c87-455c-89b5-46463a38958b	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
feb05b10-ba26-44a0-8bc1-e06252919764	t	f	2022-02-12 00:00:00	\N	K1	575ab127-cb82-40c1-8c52-6ca88e579c52	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
2eeb5b39-8e6f-4eee-b9aa-615256348f0c	t	f	2022-02-12 00:00:00	\N	K2	faa5d672-c6dd-43b0-9e67-d216a6b0112f	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
e8733b5c-4a50-48ff-a957-a03ed12984c8	t	f	2022-02-12 00:00:00	\N	K4	aec1b462-d01b-48e9-91eb-c61a84e66055	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
433164a6-ba34-4aae-88a8-9bb2aedfe71d	t	f	2022-02-12 00:00:00	\N	K4	87fe0420-043a-437e-830c-4b75b7afdc3f	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
6a4055f0-4e45-4bcc-b7be-b2aefcc09ade	t	f	2022-02-12 00:00:00	\N	K4	c9ac77a1-9e78-43a1-8b51-3a6853bff825	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
59fa1ec5-5b7f-4bf1-8ccf-6a2fc45a9280	t	f	2022-02-12 00:00:00	\N	K5A	2e3f545a-4685-4584-b57c-fef634110555	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
584b4826-2232-4ab6-8474-ddbc1e58684d	t	f	2022-02-12 00:00:00	\N	K5A	50713d40-05da-4b24-97ff-9965bb0c811d	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
800440f0-b427-49e3-bac9-7b1e58e4a7bd	t	f	2022-02-12 00:00:00	\N	K2	5d3381c9-77ae-4537-bb4d-5d1a8f49c559	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
ed2ddd0a-b8ec-4eb5-92ff-711f39d6c1cf	t	f	2022-02-12 00:00:00	\N	K1	ce72f6ce-42db-47a4-a20b-aead03f563f7	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
9b4fc963-14ca-4348-8ee2-205a195a010f	t	f	2022-02-12 00:00:00	\N	K3	69bedece-f464-42f8-aa51-7d65b6fc5114	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
c22bec32-21a6-4706-9cf0-d51027a158f5	t	f	2022-02-12 00:00:00	\N	K1	535efc10-af68-4510-ad59-2766119e3e65	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
a45dbde3-c2eb-480d-aa39-7431c4bdc83e	t	f	2022-02-12 00:00:00	\N	K2	f22125af-64dd-4c86-acd5-a5145dbf656a	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
1bb568fa-829d-4aa0-a02d-3ecffe2f42a9	t	f	2022-02-12 00:00:00	\N	KEIN_START	8c67d5c9-a4bc-4160-b020-353b5d927d0b	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
76c2c188-f73e-4c96-a459-dc2750dbe923	t	f	2022-02-12 00:00:00	\N	K1	c5190daa-724d-4e95-b36c-b6b8401181e1	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
70e5e69f-aa72-4150-9db8-72fb16f1c589	t	f	2022-02-12 00:00:00	\N	K1	b8044329-1d25-4c31-9f42-ca73102f3396	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
456c72a6-f4e3-43bf-9492-cc241c4a0eb5	t	f	2022-02-12 00:00:00	\N	K2	3318206c-684c-4038-9ec5-798f9f0b6e1e	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
0d55754a-d43e-4098-bc85-3b014afa983e	t	f	2022-02-12 00:00:00	\N	K3	a83e3ac8-1b7e-4a3c-99b0-3d0043781c87	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
01fadf1b-0d6f-429a-8554-9a04aad5f1d8	t	f	2022-02-12 00:00:00	\N	K3	f5775e0c-2a97-4e14-9809-a95a186b785d	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
625131a2-edb9-4d08-8226-36d0a18a42d6	t	f	2022-02-12 00:00:00	\N	K3	2bdbed89-f4ac-4d14-bc1a-04506ddaaac1	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
723167ce-47dd-4eee-9eac-c434c8394c84	t	f	2022-02-12 00:00:00	\N	K5A	90e4e52f-1a8c-4656-af4b-8fb99ca37cec	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
ca09d221-1fe4-43ee-81ad-62b4da2abc19	t	f	2022-02-12 00:00:00	\N	KEIN_START	c92a962e-8a60-4e50-aa51-0db4457c63eb	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
11d617b1-8f36-4e06-9cb2-6d63118499d9	t	f	2022-02-13 00:00:00	\N	K5A	31f1108b-83f9-4c78-b629-80ec5ca2fc39	0fa002f3-d432-46d4-a753-991d021db3fa	80c08ccc-c90e-4377-af3b-2de779197c7a	\N	\N	\N	\N	STARTET	\N
655b0278-90bc-4b6f-a246-f2ad94a7dbad	t	f	2022-02-13 00:00:00	\N	K4	a32f4bd9-9849-48bd-96ca-7224bdec26db	0fa002f3-d432-46d4-a753-991d021db3fa	80c08ccc-c90e-4377-af3b-2de779197c7a	\N	\N	\N	\N	STARTET	\N
1a43be7a-2d3b-45e6-a7ca-2f4a9d43e668	t	f	2022-02-13 00:00:00	\N	K4	28ebb368-6f6e-42b3-9974-c2fd74426f7c	0fa002f3-d432-46d4-a753-991d021db3fa	80c08ccc-c90e-4377-af3b-2de779197c7a	\N	\N	\N	\N	STARTET	\N
e0dd7279-eeb2-4c22-8a61-6bf9ae12d82e	t	f	2022-02-08 00:00:00	\N	K3	fa8c47e8-129f-4986-a347-8f08a5fbc16c	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
30794c94-8ad4-45b7-8f8c-70272326eb20	t	f	2022-02-10 00:00:00	\N	K4	01cff387-1e90-4441-b813-1a7402afcdb0	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
a8e3c02d-a668-4470-901a-4dbcc3c30ccc	t	f	2022-02-10 00:00:00	\N	K2	d109d353-687f-4aef-8500-626ff2eba3f7	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
c0eb73b8-0131-44f3-a4b2-49adfaf75a9e	t	f	2022-02-10 00:00:00	\N	K4	2fd65ab6-5dc4-4591-aa05-72380670f7e4	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
b56152e7-1dcc-4d6a-be48-d72c950103d9	t	f	2022-02-10 00:00:00	\N	K3	681afc77-c5a5-43dd-80c4-f64c73fb7d36	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
2cf9527e-b05a-4898-b3c3-c03464d22d9f	t	f	2022-02-10 00:00:00	\N	K6	ff3ca3fb-edc8-49e6-be65-bf3e1705fd9e	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
9c6ee212-eb31-4b14-8edd-c74d197bd17c	t	f	2022-02-10 00:00:00	\N	K2	9862a8bc-e5ff-442c-8b24-ed68b5b921b6	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
6d4b2470-1784-4fe0-b2b1-fd23b8e1ede7	t	f	2022-02-10 00:00:00	\N	K2	da926c50-9d0b-4407-872b-b2c29c4a920e	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
c64a57c1-8f9e-419b-ac8d-a5db8ed56c35	t	f	2022-02-10 00:00:00	\N	K3	8e264292-3e2b-4f59-88fb-173330c1c20f	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
98481f37-57c3-4ecf-ab7f-a0af3504f8ea	t	f	2022-02-10 00:00:00	\N	K4	00707149-4813-430e-b24b-9d3cc2e3017f	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
75a2d8e0-cecb-4297-98a4-fd09a875b7b4	t	f	2022-02-10 00:00:00	\N	K6	5f68ea28-7127-4240-b27e-0b15274ec1cf	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
2921db98-2c3b-4a41-81c9-ab1a8325b7c2	t	f	2022-02-11 00:00:00	\N	K1	cd825fef-d4a7-41e3-8686-ff661082ded7	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
003bfa4b-dbe4-49e9-a62f-d0c87f333830	t	f	2022-02-11 00:00:00	\N	K2	8b6304d3-8c2c-4986-a819-5a03668077fe	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
db4c3458-1a1e-4dca-9e60-17fff2ff50a3	t	f	2022-02-08 00:00:00	\N	K1	8cdbfd75-a49b-48f1-affe-a51c06981495	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
2d3d9ecf-0857-493b-adbf-1f8fdc2f3ff7	t	f	2022-02-11 00:00:00	\N	K6	a106014b-f468-4f15-99bd-20719ff73925	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
61877867-a999-4811-b689-e5d665ddd8d2	t	f	2022-02-11 00:00:00	\N	K5B	fad4171c-4b16-4139-9479-f9334e9ece6b	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
78184382-a6ab-4f77-b57c-a329f08da186	t	f	2022-02-11 00:00:00	\N	K5B	81e2b506-943d-4973-8bc2-5c0959cf9f61	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
354bc02c-61f9-4a1b-9388-786cd76f0c34	t	f	2022-02-11 00:00:00	\N	K5B	f88ee1a3-98cc-49f8-8c47-09a337263324	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
3f4da85a-e174-4b65-b4b8-33bbe9718dd6	t	f	2022-02-11 00:00:00	\N	K3	de243a58-337b-4a8b-8322-7af814da9593	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
04a82917-b4fb-4150-adcc-4f2f5b08413f	t	f	2022-02-11 00:00:00	\N	K5B	b0e9652e-344b-4d76-aa75-197f4376c796	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
70f1e0cc-1859-4d26-babf-8a3e031b23e2	t	f	2022-02-11 00:00:00	\N	K3	b9a251bf-2d34-4d2a-940b-889084d71586	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
3544c50b-6cf0-473e-bf54-4e5f73e930c2	t	f	2022-02-11 00:00:00	\N	K2	77d0eb16-980f-4177-8c19-cf535354d005	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
e1c80548-e399-4f7e-8350-81c7bbbe194c	t	f	2022-02-11 00:00:00	\N	K2	51f89c33-4584-4eea-83d3-ca3b7422b930	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
4e6fe6f7-310d-4473-b708-6eef202b61b0	t	f	2022-02-11 00:00:00	\N	K2	a5782e2d-3217-4d6c-9700-f5d13cce0b68	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
4bec2250-9833-41f0-8d15-9f2c144dd265	t	f	2022-02-11 00:00:00	\N	K2	9d777b94-b5f8-4fc8-8c84-b1898de938e0	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
df46b74e-acc1-40cc-9bea-49749925cba1	t	f	2022-02-11 00:00:00	\N	K3	6a6cbadd-e5f8-44da-bd2e-ff472f2411be	0fa002f3-d432-46d4-a753-991d021db3fa	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	\N	\N	\N	\N	STARTET	\N
a59ca8e7-6f69-4c50-899f-87ff85842168	t	f	2022-02-11 00:00:00	\N	K2	af55583a-525b-47d7-9eac-b598612fc001	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
080edd25-358e-4393-afb8-e463f3f57be0	t	f	2022-02-11 00:00:00	\N	K2	4d51e33e-fb0d-4427-af99-44efe1c8ed07	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
268aa369-a825-4a44-9d77-0ae7c42ffa07	t	f	2022-02-11 00:00:00	\N	K1	c270b5e8-aa5c-4f7e-8bc2-80a8baa9b31b	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
1ae51329-4fef-4740-98ad-c6cecfee4415	t	f	2022-02-12 00:00:00	\N	K7	5e8c99c6-45f0-4710-9431-6a0ad8800da5	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
15fd0abf-328c-4b11-aa45-13c945421e48	t	f	2022-02-12 00:00:00	\N	K7	8f075f1e-145c-4ab0-b138-ef421301a02a	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
7bc75ac1-96a0-4bff-9cc1-21b74ffebe61	t	f	2022-02-12 00:00:00	\N	K2	5160cd8b-755e-4148-b4aa-8a0be24f1a24	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
c2786f78-e674-4ff6-8a35-3313389bb31c	t	f	2022-02-12 00:00:00	\N	K5A	b40cbb1a-0d52-4eb0-a488-4c50617017d9	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
13ad28fa-a216-4586-9703-2d43d8ef00b2	t	f	2022-02-12 00:00:00	\N	K5B	dce03d98-82a3-4cb8-9428-9307f75778b8	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
187465a1-3a1c-4d53-bc79-e72476eee0e2	t	f	2022-02-12 00:00:00	\N	K4	249bec16-ff0a-4c64-865b-9bf3bb9b5d4b	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
5912548d-7d53-43cd-af15-b5ea0b9aa635	t	f	2022-02-12 00:00:00	\N	K6	198eef1c-28fa-4e28-bc7d-85f42496a204	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
29c95ccc-f58e-47bc-abf9-facf8e97fb38	t	f	2022-02-12 00:00:00	\N	K4	4cf8e7af-95c3-4858-8d58-2be4dc4dc2b2	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
735833bf-7aad-413b-9370-6d021001e5ea	t	f	2022-02-12 00:00:00	\N	K4	77143eb8-805c-4c69-a3c6-087b5e35c964	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
1c881799-5a7f-481c-8202-95bd288f17d4	t	f	2022-02-12 00:00:00	\N	K4	0dabee6d-3832-4404-965c-370b1861f109	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
c04d88b6-5286-4ac0-9644-85744ebd5643	t	f	2022-02-12 00:00:00	\N	K6	fa8ac1e1-892c-4438-8c62-775c7e3aab58	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
004d4118-b032-4cd7-b4ce-95277ed23045	t	f	2022-02-12 00:00:00	\N	K5A	168f1e57-7f3a-4a11-bded-9508ba1305d5	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
64f22413-0105-4533-afe7-61454bc8d0c7	t	f	2022-02-12 00:00:00	\N	K5B	6307e108-3115-48ee-95e7-868a93ac694b	0fa002f3-d432-46d4-a753-991d021db3fa	1ef47e57-2af3-4027-8cd6-427f30a63792	\N	\N	\N	\N	STARTET	\N
9f5e1259-96f1-4657-bf2d-95200ad7bfbb	t	f	2022-02-12 00:00:00	\N	K1	cdc6ed58-24c7-40b7-beb7-ae3a236508be	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
9867e666-7613-41aa-9ae0-9df6cd185165	t	f	2022-02-12 00:00:00	\N	K1	4ad3ea2e-5e13-4cdd-bab2-55cf219ab6df	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
52815132-ce36-460d-b8bd-e3f805723814	t	f	2022-02-12 00:00:00	\N	K2	541b9cd6-6455-430e-8edf-f3e377764122	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
01365d08-4a42-4941-b40c-4ac0795893ae	t	f	2022-02-12 00:00:00	\N	K3	29a29eba-35d5-482a-9e53-73c1a432dedd	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
d32edace-f7e8-4b56-8d47-a233b95b67b8	t	f	2022-02-12 00:00:00	\N	K4	e93480ba-88a8-48a2-95fb-90041edf2bcb	0fa002f3-d432-46d4-a753-991d021db3fa	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N	\N	\N	\N	STARTET	\N
dd86e952-5079-47b6-8c79-6cbce2bd74bb	t	f	2022-02-11 00:00:00	\N	KEIN_START	aca03f38-2932-4b84-989d-a9cf67c254e7	0fa002f3-d432-46d4-a753-991d021db3fa	5a6f2128-fca7-4fc5-a2ce-125755e3a2e6	\N	\N	\N	\N	STARTET	\N
b61fbd88-2bd7-46a0-8df8-62317008c3b9	t	f	2022-02-12 00:00:00	\N	K1	0758a15c-592b-4563-944c-d0acafc554bc	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
ceebda6d-5022-4ec7-a9bd-f8b2b5d51868	t	f	2022-02-12 00:00:00	\N	K5B	f44189a0-caaa-49e4-9f81-a3f43b98c1aa	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
6827db02-7028-4878-b037-3ea16c07ae4c	t	f	2022-02-12 00:00:00	\N	K2	3883d7dd-538a-4a63-a387-e1dcf06063eb	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
4853627c-afef-4d57-a4ee-8f2b703b7d56	t	f	2022-02-12 00:00:00	\N	K2	a5d71c7d-045d-4289-899d-cb32155b1f7d	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
1cfd7ac5-3079-4c16-ace3-c35d1359d761	t	f	2022-02-12 00:00:00	\N	K3	78e72594-35c8-499c-90c3-d615fbb605e0	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
64b6e3aa-3bd9-4ae6-a1e3-b6d23f79dd6f	t	f	2022-02-12 00:00:00	\N	K1	35df4fd5-9fce-4557-8591-157234e6a0db	0fa002f3-d432-46d4-a753-991d021db3fa	e2438143-6017-4683-a533-6113748d4117	\N	\N	\N	\N	STARTET	\N
d5e51230-8a46-4301-984e-884fb8e7bcb2	t	f	2022-02-12 00:00:00	\N	K1	06301f4d-1a1d-470f-8a59-cce725273087	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
eeaf651e-787a-4219-8b60-da3cd297c453	t	f	2022-02-12 00:00:00	\N	K3	906fdabf-c26f-4a51-99b0-a893497ed8e1	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
294618e9-0369-4d9e-b5b1-7f97809da368	t	f	2022-02-12 00:00:00	\N	K4	00feb41b-c00b-4402-8c9d-f0b610fe308c	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
c16e60cf-c8c2-457e-b71b-d12995732526	t	f	2022-02-12 00:00:00	\N	K5A	13d1f58d-ef04-44c7-bfe2-95f168e40543	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
32eb07d9-1b4c-4eab-b530-a0a6de4d82b7	t	f	2022-02-12 00:00:00	\N	K5A	802d96bc-3b72-4f17-9c41-0d9aebf1daf7	0fa002f3-d432-46d4-a753-991d021db3fa	e4ed5cdd-1ee3-4e15-a45e-48435bdc5464	\N	\N	\N	\N	STARTET	\N
f0063323-876a-43a1-abfa-2227046fbf16	t	f	2022-02-13 00:00:00	\N	K5A	3850372b-c892-443d-bb59-c9e33b049ace	0fa002f3-d432-46d4-a753-991d021db3fa	80c08ccc-c90e-4377-af3b-2de779197c7a	\N	\N	\N	\N	STARTET	\N
7682cb07-68dc-44e6-a181-1c63283c498c	t	f	2022-02-13 00:00:00	\N	K1	e69677a2-61e1-4f4f-a5cd-81457d6f45de	0fa002f3-d432-46d4-a753-991d021db3fa	80c08ccc-c90e-4377-af3b-2de779197c7a	\N	\N	\N	\N	STARTET	\N
17d233dd-d0ac-48b0-92fe-2a8f11286cf8	t	f	2022-02-08 00:00:00	\N	K6	95a92229-f0fd-434d-848e-6f8c2c724ed0	0fa002f3-d432-46d4-a753-991d021db3fa	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET	\N
3f77050b-c7e8-424f-9af4-69dfef00c4b8	t	f	2022-02-08 00:00:00	\N	K3	4c3c6ab3-6e9a-40b8-9c21-cb3c6273a7c7	0fa002f3-d432-46d4-a753-991d021db3fa	24510313-6d39-4217-bb3f-0bfa7fbb73d3	\N	\N	\N	\N	STARTET	\N
5aa27eb3-d8d7-4fe1-b514-793484a3a2c1	t	f	2022-02-08 00:00:00	\N	K4	8e56faeb-9069-41e6-b604-8f8ac2b7f900	0fa002f3-d432-46d4-a753-991d021db3fa	24510313-6d39-4217-bb3f-0bfa7fbb73d3	\N	\N	\N	\N	STARTET	\N
07e27e80-3ce6-472e-9645-bba3b3cd20af	t	f	2022-02-08 00:00:00	\N	K2	8b392bd1-f7a8-44c5-8d4d-9b1dff443803	0fa002f3-d432-46d4-a753-991d021db3fa	24510313-6d39-4217-bb3f-0bfa7fbb73d3	\N	\N	\N	\N	STARTET	\N
dd7b35d8-a6a5-4009-a407-f3365ecdf2cd	t	f	2022-02-08 00:00:00	\N	K2	566b0b7d-ab5d-45e3-920f-3c204101a66b	0fa002f3-d432-46d4-a753-991d021db3fa	24510313-6d39-4217-bb3f-0bfa7fbb73d3	\N	\N	\N	\N	STARTET	\N
0c48b2b4-3c2a-4bc2-9959-3993411da9a0	t	f	2022-02-08 00:00:00	\N	K4	27b32639-a0d2-4e20-9deb-723622ddeb23	0fa002f3-d432-46d4-a753-991d021db3fa	24510313-6d39-4217-bb3f-0bfa7fbb73d3	\N	\N	\N	\N	STARTET	\N
306ff0f3-2543-4c9c-8c78-be2fca4ccdfb	t	f	2022-02-08 00:00:00	\N	K5A	b2eca0ec-f91c-46e7-bcdb-18dc3b5ab8af	0fa002f3-d432-46d4-a753-991d021db3fa	24510313-6d39-4217-bb3f-0bfa7fbb73d3	\N	\N	\N	\N	STARTET	\N
d603e17d-a2a8-4d74-b1a4-26de79838824	t	f	2022-02-08 00:00:00	\N	K2	aa15546c-b684-43dc-872f-bdab3ac0c745	0fa002f3-d432-46d4-a753-991d021db3fa	24510313-6d39-4217-bb3f-0bfa7fbb73d3	\N	\N	\N	\N	STARTET	\N
846f9256-a400-44ad-b0aa-b8fd0ccd835d	t	f	2022-02-08 00:00:00	\N	K1	fad7f65a-0ddd-44bc-b380-872b8c09dcf4	0fa002f3-d432-46d4-a753-991d021db3fa	24510313-6d39-4217-bb3f-0bfa7fbb73d3	\N	\N	\N	\N	STARTET	\N
314ebb7b-551c-4fbf-aee3-1948c92098d5	t	f	2022-02-08 00:00:00	\N	K4	e9a2bba1-2e3e-45bc-91bd-a6cb4f780516	0fa002f3-d432-46d4-a753-991d021db3fa	24510313-6d39-4217-bb3f-0bfa7fbb73d3	\N	\N	\N	\N	STARTET	\N
1d5fd844-b722-4378-a138-189a3a198ca3	t	f	2022-02-08 00:00:00	\N	K1	0e1aabcc-4b60-4f73-a4ed-f2e2575187e6	0fa002f3-d432-46d4-a753-991d021db3fa	24510313-6d39-4217-bb3f-0bfa7fbb73d3	\N	\N	\N	\N	STARTET	\N
bc0d94fb-bc83-455f-99fa-8ed018394c16	t	f	2022-02-08 00:00:00	\N	K5A	5a8a0bca-dcb9-4eec-8786-f8d52f541541	0fa002f3-d432-46d4-a753-991d021db3fa	24510313-6d39-4217-bb3f-0bfa7fbb73d3	\N	\N	\N	\N	STARTET	\N
3460def5-c3e0-429b-a97c-a447d51be6be	t	f	2022-02-08 00:00:00	\N	KD	bae3a9db-b953-4384-9967-b6a695a40b35	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
81a86227-f425-474f-a3b1-87f33523fa59	t	f	2022-02-07 00:00:00	\N	K5A	91e7b868-0592-41ca-ae34-deb04382d5a4	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
11f69e6a-6e7b-45d8-beff-e1a277b2d120	t	f	2022-02-07 00:00:00	\N	K5B	35ed5aaa-25ab-4977-9b13-3fa6e4c9f5ec	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
f48f91b1-cb18-4860-ba35-32eb58f421ac	t	f	2022-02-07 00:00:00	\N	K5A	d0145586-7803-4c27-aa73-e93e6b6f088f	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
4aa3004b-9a64-4ee1-88a1-fd87d731dfc1	t	f	2022-02-07 00:00:00	\N	K5B	570eb7dd-9e21-49fc-b120-1d28af720b1b	0fa002f3-d432-46d4-a753-991d021db3fa	1fe6d9ce-05bf-4a02-81c4-53d731398880	\N	\N	\N	\N	STARTET	\N
4588dffb-2e42-4f7b-b721-6322b19af82c	t	f	2022-02-08 00:00:00	\N	K1	f8506c25-ad5d-49c4-b171-288dc0910844	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
18913513-5433-4442-9e91-90b2ee3873d6	t	f	2022-02-08 00:00:00	\N	K1	876f8554-387b-4622-bb05-a517d0721369	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
7ef79e71-4989-4863-b2c4-f4338a70ad16	t	f	2022-02-08 00:00:00	\N	K1	f16b5f6f-588e-4698-a5f1-ddc889a32627	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
180c6231-cd5f-4850-9cca-ea9ff2618a5e	t	f	2022-02-08 00:00:00	\N	K1	5958587d-7ab9-4eef-aa84-20d46bd309dd	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
027db28f-f7cd-465b-a50b-a35ebbd98740	t	f	2022-02-08 00:00:00	\N	K1	35c52cd3-41b5-4fa0-bfdb-4e88e111b8c2	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
e509c694-734a-4b16-8bba-cd2559858d3c	t	f	2022-02-08 00:00:00	\N	K1	0d07d37c-6aca-4fb5-8093-05953c2efe1d	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
c3150fa7-8273-4a61-b2d8-a7164571f0c0	t	f	2022-02-08 00:00:00	\N	K1	f4f81e47-d7ad-4073-8298-2f583e84a78c	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
e8f7b53f-9ee1-4fc3-a1c5-6a1f5a5d7cf2	t	f	2022-02-08 00:00:00	\N	K1	a0eb2cf7-dcc6-4f59-b377-6689836eb8a2	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
7bf22a7a-7e77-4405-9f46-8e9d9e53f62a	t	f	2022-02-08 00:00:00	\N	K1	1d21f9ad-95c6-44f6-bc7b-64fd18021037	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
e5ae5a9c-d86b-4d9e-a570-c0afe95d375c	t	f	2022-02-08 00:00:00	\N	K1	27c80e65-1769-499d-9daf-28b240a6c9f7	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
66973bdd-e3eb-4238-8d75-50e5ef9fd7e8	t	f	2022-02-08 00:00:00	\N	K2	ecd0e170-2509-4e0f-b007-3ce6da469751	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
d4b780e8-a91a-4dde-a4a2-d853d9a33828	t	f	2022-02-08 00:00:00	\N	K2	511211bf-522b-4cc5-a3d8-aea51b383cfb	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
9339a4da-69e5-49a8-a4de-10ae20f05e15	t	f	2022-02-08 00:00:00	\N	K2	97d15dac-c844-49fd-8ec6-2ef6dbcc109a	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
8809c134-5e32-4ee3-a2bb-9705d0a72431	t	f	2022-02-08 00:00:00	\N	K2	0da10916-38bf-4e77-8642-6c6b142cf6fa	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
480f496c-f413-4a57-95fa-d5b1e01e0695	t	f	2022-02-08 00:00:00	\N	K2	2ef89bca-f01a-45f8-a471-873aec2cb4c8	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
a51f223c-fbd7-4ffc-8baf-395d1c5d9e60	t	f	2022-02-08 00:00:00	\N	K2	36321c27-96ca-40fe-8d4a-52b66ab41ef1	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
4187c181-9cab-47ee-b379-c618bc2b824b	t	f	2022-02-08 00:00:00	\N	K2	f259343a-0c09-483d-b3c7-7c5b0395618b	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
9a54924b-bbff-4b3d-85a5-ea34d82b4184	t	f	2022-02-08 00:00:00	\N	K2	8027cedf-0442-4091-83e4-0ffbdf93ba73	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
43c38cac-fbaf-4f8f-976f-6b9877741901	t	f	2022-02-08 00:00:00	\N	K2	301d5f40-82df-4dad-8a88-7255e5d3d6ae	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
864f8f1d-751a-406b-b204-d606419b3f0e	t	f	2022-02-08 00:00:00	\N	K2	6a6d966a-d9a0-4428-8eea-96836a8088d3	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
5a83c772-23b3-4be9-a400-8248c8ef7867	t	f	2022-02-08 00:00:00	\N	K2	eb5cc30e-35bf-4d4a-bd29-bc51d63bfc0d	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
a1411c60-2f3e-4510-bd43-e94cb9de4a3f	t	f	2022-02-08 00:00:00	\N	K3	08fb2a70-1689-44d7-bdfd-02881cf17010	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
573f5f3c-8e4b-4e65-8143-bf182d6468ec	t	f	2022-02-08 00:00:00	\N	K3	4697faaa-5bc2-4e09-aa2c-a0b78cae045c	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
f9c88cb8-c477-490e-a095-44dcad419270	t	f	2022-02-08 00:00:00	\N	K3	e6d1234f-bd9b-4018-aa13-091932b86e44	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
f2e9097b-c3ab-45ec-a428-4ce747d2a1a5	t	f	2022-02-08 00:00:00	\N	K3	f637b27e-8172-4652-88f0-351fac4b0c3c	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
a7550e4f-8396-4f77-bcc7-4153cec8a152	t	f	2022-02-08 00:00:00	\N	K3	6262902e-08a7-4f47-8475-bdf77949da48	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
9a271d8c-2826-4ac4-a89a-4805fd14e962	t	f	2022-02-08 00:00:00	\N	K3	cba507f2-49b2-49f4-981d-b753ee908bdd	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
d7650c5d-861b-4823-98dc-ff42e3c84bec	t	f	2022-02-08 00:00:00	\N	K4	1514bb8f-72fe-43b3-8cca-47af497fa9fe	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
56947540-355f-4d5a-9fa0-273993a7a662	t	f	2022-02-08 00:00:00	\N	K4	11683a79-a522-4653-8f58-6748d2d13477	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
16bdbf20-16db-4118-b734-1d2a1058e8c6	t	f	2022-02-08 00:00:00	\N	K5A	a54641dc-b451-42eb-b5c0-aba908e68127	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
5206e8d6-bf1b-48f7-90bc-09f34a98fead	t	f	2022-02-08 00:00:00	\N	K5A	38eea91a-46c2-4570-823c-63eb1c1c8b9e	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
bab05040-dce2-4e3f-8c19-8e363b37dc35	t	f	2022-02-08 00:00:00	\N	K6	f8eb8924-55af-4f52-867e-e6ffbad2752c	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
e2d4bd10-e314-43ae-8d0d-b0c07e644e9c	t	f	2022-02-08 00:00:00	\N	K5A	db88e30b-f348-4b6e-90e2-21821fff0df9	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
65f76946-b17e-4482-b761-3f2da4c1368e	t	f	2022-02-08 00:00:00	\N	K5B	cd47417e-5749-4472-b58b-cedaa9b171f6	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
d2f82096-a8db-40a4-8949-14d8da85cd32	t	f	2022-02-08 00:00:00	\N	K5B	d8765998-8c5a-4bc1-8399-816e336cd625	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
2f0ae126-05d3-4331-8cfe-0867e66b8fe8	t	f	2022-02-08 00:00:00	\N	K5B	1f69f963-e030-42b3-97ea-4cadfb599c70	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
3931680e-fd30-45a7-9844-c832e09bb8e4	t	f	2022-02-08 00:00:00	\N	K5A	644fcb3e-40f4-409a-ba6f-5e0e52235c09	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
4ca25f74-d9d5-4589-b05b-ddfa473648f3	t	f	2022-02-08 00:00:00	\N	K5A	e6def881-4e19-406b-8674-ffbf9f1a03dc	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
ac9d038e-9828-45cd-97bd-599d97cb642a	t	f	2022-02-08 00:00:00	\N	K1	66293eb4-35de-4de2-a4a7-a83b6c1151d4	0fa002f3-d432-46d4-a753-991d021db3fa	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N	\N	\N	\N	STARTET	\N
4e820e1e-bce1-42ac-8c5e-9dc55cbbdc87	t	f	2022-02-08 00:00:00	\N	K5B	805a5d59-f07d-4cb8-8b0b-b61c8d887f1f	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
53631a2d-2905-4ca1-92fe-cf49b4189645	t	f	2022-02-08 00:00:00	\N	K5B	3641b75d-bec4-4222-832b-66c576193e57	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
f91cc6fd-8467-4861-bb38-22f80a88af11	t	f	2022-02-08 00:00:00	\N	K5B	1ec334ea-43ef-4f44-ac41-ff73311b75f6	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
1906badb-c947-48c3-b6f3-78e0a7f10b3a	t	f	2022-02-08 00:00:00	\N	K5A	eb51fd48-d583-4ddd-978c-5bf071632954	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
e54d7bcb-b0b6-44bb-b1f9-bbd49fc03a2a	t	f	2022-02-09 00:00:00	\N	K1	f799bc5c-7670-469b-9585-5bf150bfd1ac	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
bfe7ecb5-eded-40a4-a9c2-33e7bb5d62bc	t	f	2022-02-09 00:00:00	\N	K1	56f7e538-74f0-4790-bb00-32932649a286	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
df68ae69-922f-4857-b328-02a93ff3e30b	t	f	2022-02-09 00:00:00	\N	K1	e9f38374-85c7-4711-b28a-6939bba04433	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
cf91e240-ba8f-4b93-8aeb-22837e1b3887	t	f	2022-02-09 00:00:00	\N	K1	4559d80c-304a-47b8-b7bd-93e1c731fb70	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
3c8d3bb7-adb3-4a8b-ba41-4622d87b71d1	t	f	2022-02-09 00:00:00	\N	K1	54c646ec-c26f-4a44-b2b0-48dfe8a38e8d	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
df69320a-4e20-4a8b-85af-558e888c3470	t	f	2022-02-09 00:00:00	\N	K1	cdf0fbbf-574e-4b60-b48f-569d4f6628f0	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
3ccb8299-819d-4bd0-a93d-b114b7e133fd	t	f	2022-02-09 00:00:00	\N	K1	df1211c9-9fc3-48c7-a78f-a8847890b43a	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
e6d7f4c9-b0ee-478e-8d95-ca4372ca589a	t	f	2022-02-09 00:00:00	\N	K2	e4dad8c7-714b-4bca-b473-799a067031b2	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
cf6ac1a0-8a38-433a-aadc-ac80cf44ab7a	t	f	2022-02-09 00:00:00	\N	K2	02757861-08c6-4f8d-bac4-37786e2afee5	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
0846ca2a-309e-4f05-a505-419c7c1abeb5	t	f	2022-02-09 00:00:00	\N	K2	f715ffa9-6a2a-4eea-b5f4-254b3c200e11	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
74d1e37e-1ea5-419c-874f-6ea973207701	t	f	2022-02-09 00:00:00	\N	K2	af527263-42fd-4900-9505-f43fe1dde4a6	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
a8335dbd-be75-42e9-a0e9-1fd7e85cd4be	t	f	2022-02-09 00:00:00	\N	K3	e0175681-9347-4edc-881f-5f40ad1ab89e	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
075b15ce-594b-4a6f-93ea-bfc97aa906b1	t	f	2022-02-09 00:00:00	\N	K3	a4d8f446-a1dc-493e-b308-b920d966e3c3	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
4f44d436-970d-4299-bb31-71c248b851ff	t	f	2022-02-09 00:00:00	\N	K3	6d744ad4-680f-4d14-b3e5-0b82885ff15f	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
ec0d832d-6800-49b1-bbed-e071ec501082	t	f	2022-02-09 00:00:00	\N	K3	073b72ad-e8c7-455b-a3e3-c170a74c8e32	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
99e63c78-3d7a-4f13-9ad3-6d9934f3b49c	t	f	2022-02-09 00:00:00	\N	K3	91dbc1dc-b4db-4398-becf-e3100c240ac4	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
18f324ef-2a10-4a4a-971d-ae9bcf5e719f	t	f	2022-02-09 00:00:00	\N	K4	ccaf2874-9a43-484d-bf7a-011a6794ef45	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
a5e0cd83-ccc1-43aa-82b4-e5edab691215	t	f	2022-02-09 00:00:00	\N	K4	84d3e0bf-f621-42b0-8e83-90f53144f546	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
8003f154-43fa-4ddf-83a1-591c58192ae1	t	f	2022-02-09 00:00:00	\N	K4	71543d35-90fd-487d-89c0-9500aab414ea	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
d22abee1-a84f-46c6-8d38-a46d663695a1	t	f	2022-02-09 00:00:00	\N	K4	39448a37-5e1d-4f05-b487-635e1da93b4a	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
17168d8d-3978-4b3c-b3bd-ebb3a331f5a9	t	f	2022-02-09 00:00:00	\N	K5A	5e72eccc-7864-4fbc-98b9-ad967584a82f	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
0cd7de26-2c56-4153-a55b-3fe521f8623e	t	f	2022-02-09 00:00:00	\N	K5A	4ffa7016-2aa3-4aa2-92b5-62d9f7bd8208	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
8e7ae4df-587b-45e5-95a3-cc96db9745d4	t	f	2022-02-09 00:00:00	\N	K5A	d2fc486c-f7fc-45ca-89eb-871905c8a728	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
50c71c20-deff-4144-b9a0-fa08387d453e	t	f	2022-02-09 00:00:00	\N	K5A	88f89f31-9cf3-49d9-8b05-1156200bd4cd	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
b608158f-8d39-4b68-abe6-27876dd6c8ba	t	f	2022-02-09 00:00:00	\N	K5A	3f07567b-ca02-42f6-9835-2b4a52a4dd81	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
f0cb0cd4-5bb8-4151-9dca-d9a5c59fb371	t	f	2022-02-09 00:00:00	\N	K5A	aba788b3-5a3d-4156-9c7b-70925836daed	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
0dd3ff04-3ff1-4930-8c56-0abef3fbfac2	t	f	2022-02-09 00:00:00	\N	K5A	a65f24a9-63a6-4a05-ab77-b9e43d6d3083	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
c79d20a7-cb9b-4f07-bb9a-02aaee870af6	t	f	2022-02-09 00:00:00	\N	K6	b959f2f1-f0b6-48b2-aeaa-b8178c506214	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
07a318ee-f23c-4beb-abcf-82e14c57951e	t	f	2022-02-09 00:00:00	\N	K6	8abdc7e1-6da1-4b19-aa85-3dda0e478d58	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
3ecf0288-868d-4b98-a7aa-0eeb9c66b809	t	f	2022-02-09 00:00:00	\N	K6	573bf4ec-43a4-4603-890e-b67fcb8ec1c5	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
81add7ea-1feb-4727-a0e2-971cd890ad41	t	f	2022-02-09 00:00:00	\N	K6	175c3252-a96f-4b48-9a19-ea7e4a0d3860	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
3c0afe74-6537-4f6d-af01-6d99f0852675	t	f	2022-02-09 00:00:00	\N	K7	e0fb5e2a-93a2-453d-97d8-c94c897e0d8b	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
60dfdcd2-448d-4e8f-ba20-a6bda8f9254b	t	f	2022-02-09 00:00:00	\N	K7	0091ad64-77de-4e7d-858b-f1b3aa439c20	0fa002f3-d432-46d4-a753-991d021db3fa	e3df7bcf-4e86-48a6-92de-474fa94729a3	\N	\N	\N	\N	STARTET	\N
f1748f54-05c1-40d9-a103-212e8ed07313	t	f	2022-02-09 00:00:00	\N	K2	bdadb6f5-caee-4164-9086-0d66b53bfe7f	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
aaca0c46-69b2-48cb-9c79-2abf720f3ec8	t	f	2022-02-09 00:00:00	\N	K1	96740fd3-e0e7-4422-b172-4155b2d2000b	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
3cadce56-f6be-4d84-ae2d-5a9283c027f6	t	f	2022-02-09 00:00:00	\N	K1	2879dab9-0765-48e3-8266-5d3dde056016	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
bcb02438-acfd-49d4-b4c4-7a03a6bdd9df	t	f	2022-02-09 00:00:00	\N	K1	f2f7bc5c-197f-4dab-916c-3865c0d3edfb	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
e290d871-432a-4548-b350-db4fbe417181	t	f	2022-02-09 00:00:00	\N	K1	46c33a8f-7ce0-4a3d-81ff-a90074dcc4b2	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
7d9b5a62-f2fd-4376-84d9-2b3fbb055b1b	t	f	2022-02-09 00:00:00	\N	K2	99494421-4307-4024-a6c4-3222f834d5fa	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
0d884235-042f-4c14-8750-fc5bc7011978	t	f	2022-02-09 00:00:00	\N	K2	6b0a59f9-a8fc-44ff-9355-52747cbf1570	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
64a6e35b-dfbc-4374-aa53-bf272348f793	t	f	2022-02-09 00:00:00	\N	K3	bb78620a-ca2c-4cae-85da-3bc695a10e0c	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
afb26714-aa30-42ef-bcf2-561fd1b78ae5	t	f	2022-02-09 00:00:00	\N	K2	a82fb749-a3a3-4222-8d60-f6a16ba79290	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
df0ada11-a210-43f4-8f14-983e62e789f4	t	f	2022-02-09 00:00:00	\N	K2	d80b2f02-058c-46f2-b545-604f7ba64506	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
8456dbe0-029a-45fe-a67e-90a479f12d5e	t	f	2022-02-09 00:00:00	\N	K2	be4e10de-77e4-406e-8b91-a83fbc783ecd	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
4fdf5682-d34d-455d-b787-c9d68d3951c0	t	f	2022-02-09 00:00:00	\N	K2	336dde87-5b6a-41df-a521-74567452a82a	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
ed6dacbe-1736-40bc-9e77-6b13ca0cd8c5	t	f	2022-02-09 00:00:00	\N	K2	8b6df291-23fe-4ee0-bec8-42401c7efad9	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
714ab264-96e2-4cf6-ab60-21b22fadfc4f	t	f	2022-02-09 00:00:00	\N	K3	80a78f58-b3d6-42fe-8ee4-749bd5100573	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
8c4b6deb-98f4-4bda-a3e4-f20c02c5a45c	t	f	2022-02-09 00:00:00	\N	K3	f43725b3-cb38-4c05-a536-901f069f3a66	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
bd1ac5ff-96b7-4d85-a2dd-5b67004df9f2	t	f	2022-02-09 00:00:00	\N	K1	4ec17ceb-1002-4608-9120-9376ecf9266d	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
85a630b2-86f7-4909-9af9-71c6eccb1762	t	f	2022-02-09 00:00:00	\N	K4	44cbf6a2-05c1-4894-b393-84876d8b27c9	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
a7614398-0e52-4284-8e8d-35a4d267b26b	t	f	2022-02-09 00:00:00	\N	K3	66faab68-b4a5-4d15-9f33-3cec1130ed45	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
bacfc9d8-3391-4996-8d87-ed5e2abbd3f6	t	f	2022-02-09 00:00:00	\N	K3	007ef232-cb00-4789-b7d5-d19e1b5ea2b8	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
9550c77d-fec2-452c-848c-1496df70ce1b	t	f	2022-02-09 00:00:00	\N	K4	d6d65a51-b0ef-48ca-ab91-c5e0c8afdd10	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
4c2e1b3a-ec6a-44c5-8d92-b80b37108869	t	f	2022-02-09 00:00:00	\N	K3	2ac403d7-94ea-43e7-89bf-c08928b4926f	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
c5b6b462-d75c-443a-94ee-3b16b993d1de	t	f	2022-02-09 00:00:00	\N	K4	74dae1cd-5868-4a6a-99ab-fbcb7780288a	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
aca6c075-501b-44cc-92f1-1dde73e21817	t	f	2022-02-09 00:00:00	\N	K4	0cf6855b-b7c3-4f5d-bc5e-fe8dc569280b	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
fdd6787c-6ecc-46dd-9e20-825ccd7be75e	t	f	2022-02-09 00:00:00	\N	K5B	f2356d31-10c0-4f6b-8268-aec867416b0d	0fa002f3-d432-46d4-a753-991d021db3fa	83a5507a-c2fc-4171-8af4-fb4d8d45c889	\N	\N	\N	\N	STARTET	\N
b3147dcb-edda-45ec-8520-66c006872ebe	t	f	2022-02-01 00:00:00	\N	K1	c8b6daa8-126a-442f-95fb-ced981f4a3da	b7440787-50bd-4e41-b38b-48acf37af0de	2fc3365b-34d9-4054-b2d8-aa859c7455e7	186	\N	\N	\N	STARTET	\N
45c40bea-5554-41ef-a1dd-55e16c114376	t	f	2022-02-01 00:00:00	\N	K4	a488a0d0-1687-4968-835c-e1c30b0e7480	b7440787-50bd-4e41-b38b-48acf37af0de	2fc3365b-34d9-4054-b2d8-aa859c7455e7	187	\N	\N	\N	STARTET	\N
101a0ce3-0025-4c43-b195-c1cb9b2e8d82	t	f	2022-02-01 00:00:00	\N	K5	8365d382-9fa0-46a9-b49c-230c51ce0917	b7440787-50bd-4e41-b38b-48acf37af0de	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	188	\N	\N	\N	STARTET	\N
a2de80bb-69fd-4aaf-8388-f5d0b1c32511	t	f	2022-02-01 00:00:00	\N	K6	2f8928e8-2848-4023-ba26-3109fa771cbe	b7440787-50bd-4e41-b38b-48acf37af0de	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	189	\N	\N	\N	STARTET	\N
dcbcb4c8-326b-490a-9e5d-2237594f7aa2	t	f	2022-02-02 00:00:00	\N	K3	807e9b34-f62d-4c23-84ba-ad68f278bbe2	b7440787-50bd-4e41-b38b-48acf37af0de	0a9d4719-903b-4f31-9e00-10fc47c954fd	190	\N	\N	\N	STARTET	\N
20605c72-1109-4ce7-9dfc-362ab8c49fa0	t	f	2022-02-02 00:00:00	\N	K2	10b52c4b-af2d-4754-8291-1d05c5e206bc	b7440787-50bd-4e41-b38b-48acf37af0de	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	191	\N	\N	\N	STARTET	\N
9f8ef979-084a-4688-88b5-1a7ce1b9e0e4	t	f	2022-02-02 00:00:00	\N	K3	1074b4b9-55ae-416a-9acf-848384f549c8	b7440787-50bd-4e41-b38b-48acf37af0de	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	192	\N	\N	\N	STARTET	\N
283852b7-9eca-488e-a932-4f5543f97a72	t	f	2022-02-02 00:00:00	\N	K2	584dce6b-51c3-4e4f-92ce-988b3020d7de	b7440787-50bd-4e41-b38b-48acf37af0de	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	193	\N	\N	\N	STARTET	\N
dc6b41f6-88a6-439a-a0fd-b647043fdc73	t	f	2022-02-02 00:00:00	\N	K1	9ec91ef3-a237-4d52-89e2-880be63da77c	b7440787-50bd-4e41-b38b-48acf37af0de	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	194	\N	\N	\N	STARTET	\N
a69d77bd-70f5-4d33-9e96-f5218022da5a	t	f	2022-02-02 00:00:00	\N	K2	1cee29a6-77fc-4827-9fae-bd34d1544a5a	b7440787-50bd-4e41-b38b-48acf37af0de	a3895837-7bb9-48fa-afd0-b88c1edc7a95	195	\N	\N	\N	STARTET	\N
d540a23b-b31b-4dfb-91a3-69f94f7191d5	t	f	2022-02-02 00:00:00	\N	K4	fea4703a-9366-43db-a55f-33abfdd873f5	b7440787-50bd-4e41-b38b-48acf37af0de	a3895837-7bb9-48fa-afd0-b88c1edc7a95	196	\N	\N	\N	STARTET	\N
bd8d89f9-75b6-4742-a4ea-6515364eb611	t	f	2022-02-02 00:00:00	\N	K3	e3f00761-8a54-4a8d-bde1-59b31beb5f65	b7440787-50bd-4e41-b38b-48acf37af0de	fe6fd149-2231-415b-95c0-c4194aaf56a1	197	\N	\N	\N	STARTET	\N
a4c8b5a0-da5a-4bc8-b829-81752785cea4	t	f	2022-02-02 00:00:00	\N	K7	e7472b5b-871c-4b06-89ad-531e521c3622	b7440787-50bd-4e41-b38b-48acf37af0de	fe6fd149-2231-415b-95c0-c4194aaf56a1	198	\N	\N	\N	STARTET	\N
83fff8bd-d13d-47fd-908f-803d46303eba	t	f	2022-02-02 00:00:00	\N	K4	1feccc39-8bfc-4843-964e-76d4bb345bd2	b7440787-50bd-4e41-b38b-48acf37af0de	773a0356-9c76-4dfb-8c56-c1693ee2819d	199	\N	\N	\N	STARTET	\N
0855f0e6-5900-482c-b848-7ca46b723316	t	f	2022-02-02 00:00:00	\N	K2	e9588bcb-50c5-4d6c-806c-f3afbd3124ed	b7440787-50bd-4e41-b38b-48acf37af0de	773a0356-9c76-4dfb-8c56-c1693ee2819d	200	\N	\N	\N	STARTET	\N
2ce1468a-73b3-466a-825a-200d8c363be2	t	f	2022-02-02 00:00:00	\N	K1	74927bd5-9b9f-4a96-b2ec-d6f9ec65ea4d	b7440787-50bd-4e41-b38b-48acf37af0de	773a0356-9c76-4dfb-8c56-c1693ee2819d	201	\N	\N	\N	STARTET	\N
4338dfd8-1b34-421d-98d9-6d5cc1deaf46	t	f	2022-02-03 00:00:00	\N	K1	9d3e9766-8ea7-4377-9484-b413aa10aec1	b7440787-50bd-4e41-b38b-48acf37af0de	6cd2dec1-6466-4eb1-970b-81420914a9ed	202	\N	\N	\N	STARTET	\N
0b2f746c-b1b2-4589-abeb-88111c815d42	t	f	2022-02-05 00:00:00	\N	K5	8678e111-0e0a-48cb-b1ca-e9777a3965fb	b7440787-50bd-4e41-b38b-48acf37af0de	852ccab3-35f6-4d12-815c-d8b66ff664b7	203	\N	\N	\N	STARTET	\N
405c4b37-26b9-497a-89bd-1c4077802d6a	t	f	2022-02-05 00:00:00	\N	K2	cd839c1f-28c4-4e9a-adc5-6ff053811313	b7440787-50bd-4e41-b38b-48acf37af0de	08bfbb88-e782-4169-83fd-17b0fd03da18	204	\N	\N	\N	STARTET	\N
b66c7f89-0a17-46b8-9190-bfc8500c04be	t	f	2022-02-05 00:00:00	\N	K1	058ddf9c-9670-43d7-8fac-7d735575a817	b7440787-50bd-4e41-b38b-48acf37af0de	08bfbb88-e782-4169-83fd-17b0fd03da18	205	\N	\N	\N	STARTET	\N
abc7207c-5e0f-4e13-9642-f7778c9358fc	t	f	2022-02-05 00:00:00	\N	K3	38d34c77-87a6-4a42-947b-e97300b73f78	b7440787-50bd-4e41-b38b-48acf37af0de	08bfbb88-e782-4169-83fd-17b0fd03da18	206	\N	\N	\N	STARTET	\N
7992952d-152a-4774-b8c3-1b378051c3be	t	f	2022-02-05 00:00:00	\N	K3	8deab9e3-7cb8-4e7f-8e47-9d36e310dfe4	b7440787-50bd-4e41-b38b-48acf37af0de	08bfbb88-e782-4169-83fd-17b0fd03da18	207	\N	\N	\N	STARTET	\N
330e88cf-cdc7-4036-9de9-1e394fa19e70	t	f	2022-02-06 00:00:00	\N	K4	396298b2-b01c-4322-a11c-f85b54470c82	b7440787-50bd-4e41-b38b-48acf37af0de	a47c9fe9-9d46-47c6-8cc8-b9728464daa2	208	\N	\N	\N	STARTET	\N
bec50ccd-4503-417c-b06f-dd366d8571ad	t	f	2022-02-07 00:00:00	\N	K1	a2746d6f-49c6-40ee-b2d5-dd9d7688177c	b7440787-50bd-4e41-b38b-48acf37af0de	97cf3158-df81-45c1-b49e-47a692438dca	209	\N	\N	\N	STARTET	\N
e81c0fb8-4ff9-4b5e-8566-7a6a6f75762f	t	f	2022-02-01 00:00:00	\N	K4	4bc55af8-760c-4c4d-b57e-586998a18f87	b7440787-50bd-4e41-b38b-48acf37af0de	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	211	\N	\N	\N	STARTET	\N
2fdf31d3-c311-4487-8856-0e4df2760904	t	f	2022-02-01 00:00:00	\N	K5	4321f498-2c55-49db-bcb3-26437cb50b5b	b7440787-50bd-4e41-b38b-48acf37af0de	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	212	\N	\N	\N	STARTET	\N
b0bf7757-e696-43a1-83b6-fb5e29b4fa74	t	f	2022-02-02 00:00:00	\N	K1	c7370c27-c8c6-4685-88ff-2c67ae4ad4c0	b7440787-50bd-4e41-b38b-48acf37af0de	0a9d4719-903b-4f31-9e00-10fc47c954fd	213	\N	\N	\N	STARTET	\N
09e28b26-ea5f-4800-ac7c-a99bb6028d46	t	f	2022-02-02 00:00:00	\N	K3	ad3de164-62aa-489b-807e-6a8d74bc62a6	b7440787-50bd-4e41-b38b-48acf37af0de	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	214	\N	\N	\N	STARTET	\N
1172a1a1-e519-48e1-b642-40da3dc123f8	t	f	2022-02-02 00:00:00	\N	K1	6e2c58dc-2e14-4efe-bc44-22a7b279bc74	b7440787-50bd-4e41-b38b-48acf37af0de	a3895837-7bb9-48fa-afd0-b88c1edc7a95	215	\N	\N	\N	STARTET	\N
b9228849-e9ad-4ff9-b99c-ef5f8c6980f4	t	f	2022-02-02 00:00:00	\N	K6	921d472d-3b59-4be2-a8d6-7fc371ce6cae	b7440787-50bd-4e41-b38b-48acf37af0de	fe6fd149-2231-415b-95c0-c4194aaf56a1	216	\N	\N	\N	STARTET	\N
a851f8c8-d4e2-42b4-bfb8-f1c72a375d4c	t	f	2022-02-02 00:00:00	\N	K4	b1c38bb8-d4e3-48bc-acb5-c3290a7ebd18	b7440787-50bd-4e41-b38b-48acf37af0de	fe6fd149-2231-415b-95c0-c4194aaf56a1	217	\N	\N	\N	STARTET	\N
d9afd111-493d-4b7b-a7cf-9b68d9640940	t	f	2022-02-02 00:00:00	\N	K5	76b99e2d-c1f5-457f-bace-a59f6f019dc6	b7440787-50bd-4e41-b38b-48acf37af0de	773a0356-9c76-4dfb-8c56-c1693ee2819d	218	\N	\N	\N	STARTET	\N
8491c430-815c-4ddb-9ded-5337f795a061	t	f	2022-02-03 00:00:00	\N	K2	ec14beea-aa21-4427-9aee-924a94491c51	b7440787-50bd-4e41-b38b-48acf37af0de	6cd2dec1-6466-4eb1-970b-81420914a9ed	219	\N	\N	\N	STARTET	\N
9fe3865f-ec63-419e-8790-32ecaeefdc6e	t	f	2022-02-05 00:00:00	\N	K3	2625ed66-833e-44ab-9b42-22400bc11d62	b7440787-50bd-4e41-b38b-48acf37af0de	852ccab3-35f6-4d12-815c-d8b66ff664b7	220	\N	\N	\N	STARTET	\N
9f2aaa54-f8e1-4200-b8db-c48a83b68c73	t	f	2022-02-05 00:00:00	\N	K2	8aaf21f5-d830-4d7c-b9c1-c5272fb4d12f	b7440787-50bd-4e41-b38b-48acf37af0de	08bfbb88-e782-4169-83fd-17b0fd03da18	221	\N	\N	\N	STARTET	\N
76abbc63-cb25-45e3-a8f5-1fd3eef849da	t	f	2022-02-06 00:00:00	\N	K2	fabdde8b-a5df-451a-b5c6-c63989a96845	b7440787-50bd-4e41-b38b-48acf37af0de	a60429c0-6964-454b-8ee1-ddad66957f06	222	\N	\N	\N	STARTET	\N
27a7aa84-d9b1-4f1d-a1ed-9ed18e32c524	t	f	2022-02-06 00:00:00	\N	K4	4cce7dce-f8df-41df-b83d-1364d287519e	b7440787-50bd-4e41-b38b-48acf37af0de	a47c9fe9-9d46-47c6-8cc8-b9728464daa2	223	\N	\N	\N	STARTET	\N
e770a911-28e2-4b7c-b910-d908604976e4	t	f	2022-02-07 00:00:00	\N	K1	9c18056d-a4cd-4303-ac0f-8f7c73bd4dca	b7440787-50bd-4e41-b38b-48acf37af0de	97cf3158-df81-45c1-b49e-47a692438dca	224	\N	\N	\N	STARTET	\N
379b9ad9-dd1f-4a21-9836-32decce330af	t	f	2022-02-07 00:00:00	\N	K4	f416bed7-3854-4767-b63d-1c7def39fa9d	b7440787-50bd-4e41-b38b-48acf37af0de	97cf3158-df81-45c1-b49e-47a692438dca	225	\N	\N	\N	STARTET	\N
76d447b0-15c9-4051-9ab4-29d7b27457e2	t	f	2022-02-01 00:00:00	\N	K4	9c1abd67-ea14-4486-80a2-6fc2ec64cec1	b7440787-50bd-4e41-b38b-48acf37af0de	2fc3365b-34d9-4054-b2d8-aa859c7455e7	227	\N	\N	\N	STARTET	\N
ffc37a0d-1c45-4204-a728-8f3d7932be24	t	f	2022-02-01 00:00:00	\N	K4	4efc7709-ad79-4c9c-b840-2dff2d35e317	b7440787-50bd-4e41-b38b-48acf37af0de	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	228	\N	\N	\N	STARTET	\N
530688d6-ce0e-40ae-9abb-d12c67fb2710	t	f	2022-02-01 00:00:00	\N	K6	504b47bc-3a0b-4dfe-bee1-9d559e840ab9	b7440787-50bd-4e41-b38b-48acf37af0de	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	229	\N	\N	\N	STARTET	\N
24ad5350-3652-4343-a203-81c06435dbdd	t	f	2022-02-01 00:00:00	\N	K7	660f9915-13f5-4dc9-b2dc-eaff217555d5	b7440787-50bd-4e41-b38b-48acf37af0de	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	230	\N	\N	\N	STARTET	\N
8c8ffa2b-05f4-43f3-aabd-0419a5bfe8b5	t	f	2022-02-02 00:00:00	\N	K5	5f0adebc-2e93-446e-86da-317b08e55b67	b7440787-50bd-4e41-b38b-48acf37af0de	0a9d4719-903b-4f31-9e00-10fc47c954fd	231	\N	\N	\N	STARTET	\N
5971925f-ae1d-4560-94e5-97d7388ce715	t	f	2022-02-02 00:00:00	\N	K2	f2a48eb7-c251-45ce-bfc4-ad3553161069	b7440787-50bd-4e41-b38b-48acf37af0de	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	232	\N	\N	\N	STARTET	\N
df19c1a1-2196-4409-9da5-9e81b2c84f7f	t	f	2022-02-02 00:00:00	\N	K1	5c4140a0-02e2-4d2e-8a0d-529a1d4783ba	b7440787-50bd-4e41-b38b-48acf37af0de	a3895837-7bb9-48fa-afd0-b88c1edc7a95	233	\N	\N	\N	STARTET	\N
9d0a945b-d73a-4a5e-87c7-e4b0e0b5fbbb	t	f	2022-02-02 00:00:00	\N	K2	4974c554-ec5f-46e2-9745-4a07a2c242a2	b7440787-50bd-4e41-b38b-48acf37af0de	a3895837-7bb9-48fa-afd0-b88c1edc7a95	234	\N	\N	\N	STARTET	\N
ab6776a9-fbe5-44d7-9acd-d90abde06f19	t	f	2022-02-02 00:00:00	\N	K5	80c04547-e962-4aba-8dfb-2b248cde50c0	b7440787-50bd-4e41-b38b-48acf37af0de	cfb35447-962b-479e-af0e-2f95dfbc9fde	235	\N	\N	\N	STARTET	\N
1ebf5a36-8f7d-48af-bb9b-12443daefe79	t	f	2022-02-02 00:00:00	\N	K2	c441f78b-b96d-4e73-b3f1-3c4e7e0b530b	b7440787-50bd-4e41-b38b-48acf37af0de	cfb35447-962b-479e-af0e-2f95dfbc9fde	236	\N	\N	\N	STARTET	\N
8b6e2538-9761-44ef-9de0-38cd6915a9a6	t	f	2022-02-02 00:00:00	\N	K1	888068e0-53b7-42c4-9319-4fb353fc71d4	b7440787-50bd-4e41-b38b-48acf37af0de	773a0356-9c76-4dfb-8c56-c1693ee2819d	237	\N	\N	\N	STARTET	\N
6db000d9-486c-468c-9345-19944b6caf5c	t	f	2022-02-02 00:00:00	\N	K2	127bc2eb-3b88-4e28-b285-da2c87200b9b	b7440787-50bd-4e41-b38b-48acf37af0de	773a0356-9c76-4dfb-8c56-c1693ee2819d	238	\N	\N	\N	STARTET	\N
fa1e3337-00bb-4056-a21b-9cf278309e0a	t	f	2022-02-03 00:00:00	\N	K2	9448eb4e-3590-4268-8b6d-4d8e311a51e1	b7440787-50bd-4e41-b38b-48acf37af0de	6cd2dec1-6466-4eb1-970b-81420914a9ed	239	\N	\N	\N	STARTET	\N
3daecdff-d3c5-4b5a-8a02-329880a5e874	t	f	2022-02-03 00:00:00	\N	K1	b558433b-d91b-44d0-a7da-83307567eb6e	b7440787-50bd-4e41-b38b-48acf37af0de	6cd2dec1-6466-4eb1-970b-81420914a9ed	240	\N	\N	\N	STARTET	\N
da2284de-1f29-4317-89b6-bec7937103ed	t	f	2022-02-05 00:00:00	\N	K3	39ad1b91-c8aa-44e1-8a1e-817cba27ab9e	b7440787-50bd-4e41-b38b-48acf37af0de	852ccab3-35f6-4d12-815c-d8b66ff664b7	241	\N	\N	\N	STARTET	\N
f5bb6d86-c286-4a9b-9c8c-59ff7c45d3e8	t	f	2022-02-05 00:00:00	\N	K3	55423e0f-af86-44cd-a74b-8c0555019f19	b7440787-50bd-4e41-b38b-48acf37af0de	852ccab3-35f6-4d12-815c-d8b66ff664b7	242	\N	\N	\N	STARTET	\N
32d85bd8-c822-4394-b46c-9de76e7fc4ae	t	f	2022-02-05 00:00:00	\N	K1	cc431f52-fc40-45a2-9ed5-8ce6c0acf380	b7440787-50bd-4e41-b38b-48acf37af0de	08bfbb88-e782-4169-83fd-17b0fd03da18	243	\N	\N	\N	STARTET	\N
0e60c446-7831-4d2b-99e2-39482700139e	t	f	2022-02-06 00:00:00	\N	K1	2403f85e-2c91-46fa-8259-7dca8da93625	b7440787-50bd-4e41-b38b-48acf37af0de	cfb35447-962b-479e-af0e-2f95dfbc9fde	244	\N	\N	\N	STARTET	\N
d0107d28-bc67-49f0-8505-c6b3f632c305	t	f	2022-02-06 00:00:00	\N	K4	db509a37-d829-4279-a640-6406e6db0371	b7440787-50bd-4e41-b38b-48acf37af0de	a47c9fe9-9d46-47c6-8cc8-b9728464daa2	245	\N	\N	\N	STARTET	\N
533eaeeb-95a1-45a8-9f88-567d3f1a6a58	t	f	2022-02-07 00:00:00	\N	K1	3f36bfed-e8f6-45a8-b0e1-dca6bde66a2d	b7440787-50bd-4e41-b38b-48acf37af0de	97cf3158-df81-45c1-b49e-47a692438dca	246	\N	\N	\N	STARTET	\N
1a26dc7b-b2a9-46fd-8d4e-9380a7fd3b1b	t	f	2022-02-07 00:00:00	\N	K6	dbdc1840-c23a-480b-8a11-64d42e58a8b2	b7440787-50bd-4e41-b38b-48acf37af0de	97cf3158-df81-45c1-b49e-47a692438dca	247	\N	\N	\N	STARTET	\N
27bea19c-74cd-4b3a-889f-609ac4e5d7df	t	f	2022-02-01 00:00:00	\N	K1	8489421a-ed87-4838-a5fa-5a23f2681b27	b7440787-50bd-4e41-b38b-48acf37af0de	2fc3365b-34d9-4054-b2d8-aa859c7455e7	249	\N	\N	\N	STARTET	\N
3652dd46-0fa0-4419-84a1-2d69285f3e4e	t	f	2022-02-01 00:00:00	\N	K1	2a0c66e7-6071-43c0-b222-7b792f7f51ae	b7440787-50bd-4e41-b38b-48acf37af0de	c0a6c2eb-1278-42b5-8aba-0426f3550863	250	\N	\N	\N	STARTET	\N
0f263690-2172-47b6-93f9-cc8c7ae8f33d	t	f	2022-02-01 00:00:00	\N	K2	0c22fed8-41f4-44fe-b6c1-d7a142f8c1e1	b7440787-50bd-4e41-b38b-48acf37af0de	c0a6c2eb-1278-42b5-8aba-0426f3550863	251	\N	\N	\N	STARTET	\N
b9b9ed2d-010e-4fad-b70c-68649fbcee92	t	f	2022-02-01 00:00:00	\N	K3	575f5dff-ce37-4662-bf47-97966800d333	b7440787-50bd-4e41-b38b-48acf37af0de	c0a6c2eb-1278-42b5-8aba-0426f3550863	252	\N	\N	\N	STARTET	\N
a8c58d76-51c6-41f6-bf0e-f77c23bf2eba	t	f	2022-02-01 00:00:00	\N	K5	0a6d2003-0cb1-44dc-93c8-dc4ecc18bbe2	b7440787-50bd-4e41-b38b-48acf37af0de	c0a6c2eb-1278-42b5-8aba-0426f3550863	253	\N	\N	\N	STARTET	\N
162e6120-501c-4021-8677-dae570210653	t	f	2022-02-01 00:00:00	\N	K6	b04f2ff1-014d-4a9e-9428-bccc6dd68d73	b7440787-50bd-4e41-b38b-48acf37af0de	c0a6c2eb-1278-42b5-8aba-0426f3550863	254	\N	\N	\N	STARTET	\N
c79f015a-f94e-4fc0-933d-a9fcf6d3e06e	t	f	2022-02-01 00:00:00	\N	K6	94fa4cd0-1003-47f7-810b-8751e4759d2b	b7440787-50bd-4e41-b38b-48acf37af0de	c0a6c2eb-1278-42b5-8aba-0426f3550863	255	\N	\N	\N	STARTET	\N
5d01fac8-a783-4b15-a481-f6dc4a663236	t	f	2022-02-01 00:00:00	\N	K4	5419169e-c782-4ef0-9938-38f4b939f51b	b7440787-50bd-4e41-b38b-48acf37af0de	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	256	\N	\N	\N	STARTET	\N
4818878e-8dba-41ab-b28f-4e23e39641ae	t	f	2022-02-01 00:00:00	\N	K6	5f0ee901-fd26-4dea-ae33-ff5d416b614e	b7440787-50bd-4e41-b38b-48acf37af0de	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	257	\N	\N	\N	STARTET	\N
e0f5f3cf-1a09-4474-8171-5b8d33b8be10	t	f	2022-02-02 00:00:00	\N	K4	3a9b24c2-ddb9-4669-b2e1-83609a0a2fba	b7440787-50bd-4e41-b38b-48acf37af0de	0a9d4719-903b-4f31-9e00-10fc47c954fd	258	\N	\N	\N	STARTET	\N
17467458-b4f1-4b49-b7ca-87cdbfb17384	t	f	2022-02-02 00:00:00	\N	K2	a4c163f6-6304-413b-aa87-71140b7ee6c5	b7440787-50bd-4e41-b38b-48acf37af0de	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	259	\N	\N	\N	STARTET	\N
6e4c84fd-e9f9-4a2f-a0f5-86238d49f89c	t	f	2022-02-02 00:00:00	\N	K1	3efeaf18-c1f1-4693-83ce-5d74f9e84d6b	b7440787-50bd-4e41-b38b-48acf37af0de	1cea7eb3-981e-4c6e-bb83-bfcc1578351b	260	\N	\N	\N	STARTET	\N
4447e588-ed76-49d2-ac42-24a8c2c046fe	t	f	2022-02-02 00:00:00	\N	K2	daf3d279-5168-4822-bbf9-0f0abdac8753	b7440787-50bd-4e41-b38b-48acf37af0de	a3895837-7bb9-48fa-afd0-b88c1edc7a95	261	\N	\N	\N	STARTET	\N
91c9bc84-c421-4bf9-8941-626909614c6b	t	f	2022-02-02 00:00:00	\N	K3	4be21568-ba9c-4307-87b4-a00685db7771	b7440787-50bd-4e41-b38b-48acf37af0de	a3895837-7bb9-48fa-afd0-b88c1edc7a95	262	\N	\N	\N	STARTET	\N
d6a18670-77a3-4b43-94cf-972c8ac013c7	t	f	2022-02-02 00:00:00	\N	K1	84e606b6-2732-4906-96bb-43ad01c3fdd8	b7440787-50bd-4e41-b38b-48acf37af0de	cfb35447-962b-479e-af0e-2f95dfbc9fde	263	\N	\N	\N	STARTET	\N
053d98ca-d0b5-4ac0-ad87-a8083b77d3d9	t	f	2022-02-02 00:00:00	\N	K1	78eed132-0f15-437e-ad6e-acd28388d2b0	b7440787-50bd-4e41-b38b-48acf37af0de	cfb35447-962b-479e-af0e-2f95dfbc9fde	264	\N	\N	\N	STARTET	\N
04a4d09c-34c2-4970-8d67-7d0f3f8f49bc	t	f	2022-02-02 00:00:00	\N	K2	4beded93-5981-417a-81ff-9b895474383f	b7440787-50bd-4e41-b38b-48acf37af0de	773a0356-9c76-4dfb-8c56-c1693ee2819d	265	\N	\N	\N	STARTET	\N
7cdfa1d5-a536-4b04-af9e-1c2a05f7d4f6	t	f	2022-02-03 00:00:00	\N	K7	7b642841-1f01-4f84-845f-261f0fb2acda	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	266	\N	\N	\N	STARTET	\N
625a665c-208d-46b9-b93a-43fb9b66d579	t	f	2022-02-03 00:00:00	\N	K1	ee697d2c-bbd5-492f-a279-af4dd54398cb	b7440787-50bd-4e41-b38b-48acf37af0de	6cd2dec1-6466-4eb1-970b-81420914a9ed	267	\N	\N	\N	STARTET	\N
49ddfc50-326f-41ce-a358-9324737d3f74	t	f	2022-02-05 00:00:00	\N	K1	93d3d0cc-a259-4248-912f-958e7a9cb49e	b7440787-50bd-4e41-b38b-48acf37af0de	08bfbb88-e782-4169-83fd-17b0fd03da18	268	\N	\N	\N	STARTET	\N
40753009-673e-4528-b680-df24c034ece9	t	f	2022-02-07 00:00:00	\N	K2	48a6fde1-a0f5-4440-a5e9-1d2962225446	b7440787-50bd-4e41-b38b-48acf37af0de	97cf3158-df81-45c1-b49e-47a692438dca	269	\N	\N	\N	STARTET	\N
8a0a1467-3231-414c-abe4-86f71451c7a2	t	f	2022-02-07 00:00:00	\N	K1	302f3b2b-f023-4a41-b818-58e3a765d14d	b7440787-50bd-4e41-b38b-48acf37af0de	97cf3158-df81-45c1-b49e-47a692438dca	270	\N	\N	\N	STARTET	\N
1485f330-2d70-48e0-b0ed-286aa342bcfe	t	f	2022-02-07 00:00:00	\N	K5	0f7d2904-bdf5-4ad5-9c00-966cda0ef71d	b7440787-50bd-4e41-b38b-48acf37af0de	97cf3158-df81-45c1-b49e-47a692438dca	271	\N	\N	\N	STARTET	\N
e83c2a64-5ed8-49cf-b0b7-66fcac3cf23b	t	f	2022-02-07 00:00:00	\N	K5	25760240-0ed1-4364-9e21-1e4372c89a54	b7440787-50bd-4e41-b38b-48acf37af0de	97cf3158-df81-45c1-b49e-47a692438dca	272	\N	\N	\N	STARTET	\N
281f65dd-55d5-4364-a52d-6d8eef463f43	t	f	2022-02-01 00:00:00	\N	K1	e91e3f27-c159-44ca-87dc-b11d8a38e6c8	b7440787-50bd-4e41-b38b-48acf37af0de	2fc3365b-34d9-4054-b2d8-aa859c7455e7	274	\N	\N	\N	STARTET	\N
b5af0103-780c-4dad-adae-638bdc04981a	t	f	2022-02-01 00:00:00	\N	K2	48dec3a8-3c36-4cbb-a4ea-07125399b0ae	b7440787-50bd-4e41-b38b-48acf37af0de	c0a6c2eb-1278-42b5-8aba-0426f3550863	275	\N	\N	\N	STARTET	\N
78e9485e-f33b-4760-acc6-b95da164fa48	t	f	2022-02-01 00:00:00	\N	K6	acfc2517-b14d-44d3-9ed8-0de7b5575d65	b7440787-50bd-4e41-b38b-48acf37af0de	c0a6c2eb-1278-42b5-8aba-0426f3550863	276	\N	\N	\N	STARTET	\N
91ffda9c-5372-4f10-9b76-7bb81669119f	t	f	2022-02-01 00:00:00	\N	K5	acf729cf-2364-4caf-880f-b2289151e5c1	b7440787-50bd-4e41-b38b-48acf37af0de	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	277	\N	\N	\N	STARTET	\N
4719406b-93c0-457f-9e51-369ef6c24f21	t	f	2022-02-01 00:00:00	\N	K5	7260eb0d-53a0-4378-9a89-d51dd1722d3a	b7440787-50bd-4e41-b38b-48acf37af0de	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	278	\N	\N	\N	STARTET	\N
f4defbb5-7793-498d-87ee-6b2fad79410d	t	f	2022-02-02 00:00:00	\N	K5	aa43a930-a178-47ee-a402-b64fbe2277d7	b7440787-50bd-4e41-b38b-48acf37af0de	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	279	\N	\N	\N	STARTET	\N
b4b0c6af-5a92-4b13-b432-33cb0e3daa67	t	f	2022-02-02 00:00:00	\N	K2	609ecf98-aa95-40b1-b4e6-e913c176d9ae	b7440787-50bd-4e41-b38b-48acf37af0de	a3895837-7bb9-48fa-afd0-b88c1edc7a95	280	\N	\N	\N	STARTET	\N
bc7f11b6-25be-4e4a-ba82-c5aa28b539bf	t	f	2022-02-02 00:00:00	\N	K4	ba20fbb0-c246-414d-958f-7bf181d37c99	b7440787-50bd-4e41-b38b-48acf37af0de	0a9d4719-903b-4f31-9e00-10fc47c954fd	281	\N	\N	\N	STARTET	\N
18af3248-ba89-4443-8336-7a3b6636fe26	t	f	2022-02-01 00:00:00	\N	K4	603a232c-f458-4a91-8c13-24a7baba45cc	b7440787-50bd-4e41-b38b-48acf37af0de	c0a6c2eb-1278-42b5-8aba-0426f3550863	283	\N	\N	\N	STARTET	\N
c091d3c2-bd25-4c13-9845-fe16e7019cff	t	f	2022-02-01 00:00:00	\N	K4	562b5c3d-0cb9-412d-812f-67d3fd6ce49a	b7440787-50bd-4e41-b38b-48acf37af0de	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	284	\N	\N	\N	STARTET	\N
c038dcde-88a9-4f0b-927e-b9489b7e4da6	t	f	2022-02-01 00:00:00	\N	K6	10d5ee9f-5fac-465f-a090-81add0973145	b7440787-50bd-4e41-b38b-48acf37af0de	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	285	\N	\N	\N	STARTET	\N
5d3a8db1-c8f7-48da-8d7c-f6a5cbccf551	t	f	2022-02-02 00:00:00	\N	K3	c81d2841-7dfb-4fe3-b524-6dd69dfd65f0	b7440787-50bd-4e41-b38b-48acf37af0de	0a9d4719-903b-4f31-9e00-10fc47c954fd	286	\N	\N	\N	STARTET	\N
d4899639-1744-4ab2-aa65-cf8d2692dadd	t	f	2022-02-02 00:00:00	\N	K1	1961ba04-49f3-4e85-bbeb-bf035f77e4e5	b7440787-50bd-4e41-b38b-48acf37af0de	a3895837-7bb9-48fa-afd0-b88c1edc7a95	287	\N	\N	\N	STARTET	\N
bc2e2951-0f06-4e08-aec2-28cfc1dbd0cb	t	f	2022-02-02 00:00:00	\N	K1	5e719734-7f45-4f74-bdaa-7df5db084f24	b7440787-50bd-4e41-b38b-48acf37af0de	a3895837-7bb9-48fa-afd0-b88c1edc7a95	288	\N	\N	\N	STARTET	\N
5f702020-99ce-426b-95ed-95750db51896	t	f	2022-02-02 00:00:00	\N	K2	73be97d9-25ba-46f8-8374-2403b7b69bc5	b7440787-50bd-4e41-b38b-48acf37af0de	a3895837-7bb9-48fa-afd0-b88c1edc7a95	289	\N	\N	\N	STARTET	\N
f98696e7-1d86-4c98-86dd-8f419f51e815	t	f	2022-02-02 00:00:00	\N	K4	cf8f99ec-f95c-4291-9650-43dc03689ad5	b7440787-50bd-4e41-b38b-48acf37af0de	fe6fd149-2231-415b-95c0-c4194aaf56a1	290	\N	\N	\N	STARTET	\N
594893ca-8232-44a6-aa0f-bd9eb4e73ec1	t	f	2022-02-02 00:00:00	\N	K3	9957b8ed-a854-4035-9515-75d9d373f23a	b7440787-50bd-4e41-b38b-48acf37af0de	fe6fd149-2231-415b-95c0-c4194aaf56a1	291	\N	\N	\N	STARTET	\N
b843ac45-da84-46c8-83bc-80ada7867b06	t	f	2022-02-02 00:00:00	\N	K4	f2de432e-1b6e-437c-9804-09b688998682	b7440787-50bd-4e41-b38b-48acf37af0de	773a0356-9c76-4dfb-8c56-c1693ee2819d	292	\N	\N	\N	STARTET	\N
0314b892-5e16-41df-b36e-8779cf6ab78b	t	f	2022-02-02 00:00:00	\N	K1	df9f5dbf-f29e-4db3-bde6-5ae08bd902c9	b7440787-50bd-4e41-b38b-48acf37af0de	773a0356-9c76-4dfb-8c56-c1693ee2819d	293	\N	\N	\N	STARTET	\N
4f501548-f84b-482e-a037-8c32e1c734ed	t	f	2022-02-02 00:00:00	\N	K5	2f8bf907-d6f0-416b-abe2-46560b143b06	b7440787-50bd-4e41-b38b-48acf37af0de	773a0356-9c76-4dfb-8c56-c1693ee2819d	294	\N	\N	\N	STARTET	\N
7d4ec58f-6128-48a9-92eb-9ad124f29920	t	f	2022-02-03 00:00:00	\N	K1	bc60c2c8-4434-4bf0-a6e4-c473c13b6aef	b7440787-50bd-4e41-b38b-48acf37af0de	6cd2dec1-6466-4eb1-970b-81420914a9ed	295	\N	\N	\N	STARTET	\N
1ee0f280-1148-4e43-a04d-78855eadfbba	t	f	2022-02-03 00:00:00	\N	K2	c0a6871d-9a19-4f04-8178-d5e4be1a3d24	b7440787-50bd-4e41-b38b-48acf37af0de	6cd2dec1-6466-4eb1-970b-81420914a9ed	296	\N	\N	\N	STARTET	\N
396a0391-e07b-4ad3-806e-2dbb89be21fc	t	f	2022-02-03 00:00:00	\N	K1	07423944-a56c-44b8-a95b-7b41c69f710d	b7440787-50bd-4e41-b38b-48acf37af0de	6cd2dec1-6466-4eb1-970b-81420914a9ed	297	\N	\N	\N	STARTET	\N
d479440c-92ff-43fc-92ac-0444e69de324	t	f	2022-02-05 00:00:00	\N	K3	9dba2037-7e9a-489b-9870-f473a9171b64	b7440787-50bd-4e41-b38b-48acf37af0de	852ccab3-35f6-4d12-815c-d8b66ff664b7	298	\N	\N	\N	STARTET	\N
269576a6-c567-4348-b5fe-e569a884c20d	t	f	2022-02-05 00:00:00	\N	K1	1422a8aa-e185-4b22-9530-8a1694f600ea	b7440787-50bd-4e41-b38b-48acf37af0de	08bfbb88-e782-4169-83fd-17b0fd03da18	299	\N	\N	\N	STARTET	\N
9b926458-3399-4982-8d0f-f1b19f132865	t	f	2022-02-05 00:00:00	\N	K3	3c41b0e3-67eb-4478-bd60-153660f16d09	b7440787-50bd-4e41-b38b-48acf37af0de	08bfbb88-e782-4169-83fd-17b0fd03da18	300	\N	\N	\N	STARTET	\N
c6696ed5-b697-413c-b339-88b2d5ec35c7	t	f	2022-02-07 00:00:00	\N	K2	d7b4f6fc-ae1b-4ac0-9b22-14013025b255	b7440787-50bd-4e41-b38b-48acf37af0de	97cf3158-df81-45c1-b49e-47a692438dca	301	\N	\N	\N	STARTET	\N
6dbad921-eb3e-40a7-9b30-220212dbbff4	t	f	2022-02-07 00:00:00	\N	K3	71af71e4-2389-4b16-aff3-709e7f29a947	b7440787-50bd-4e41-b38b-48acf37af0de	97cf3158-df81-45c1-b49e-47a692438dca	302	\N	\N	\N	STARTET	\N
26bc6a19-a9e6-4d59-b832-b5f653dc402e	t	f	2022-02-07 00:00:00	\N	K2	d927b569-8246-4cb6-aa6e-4c54ca3f7aff	b7440787-50bd-4e41-b38b-48acf37af0de	1fe6d9ce-05bf-4a02-81c4-53d731398880	303	\N	\N	\N	STARTET	\N
2af22711-81c1-4250-823d-de892ea3b5f9	t	f	2022-02-07 00:00:00	\N	K6	ec4fd90c-dc60-46a0-b96d-f5683dd7e3e1	b7440787-50bd-4e41-b38b-48acf37af0de	d701ba83-2b9a-45e4-8c54-ba88cb8e1260	304	\N	\N	\N	STARTET	\N
451deb2e-64cd-4263-9752-51df4462b3fb	t	f	2022-02-08 00:00:00	\N	K1	6a85cf8d-0978-4534-9bfb-669006f092b6	b7440787-50bd-4e41-b38b-48acf37af0de	4e9262a1-fef9-4701-9c91-1b3016ee971d	305	\N	\N	\N	STARTET	\N
e3a15717-db1a-44d5-b432-ecb001897111	t	f	2022-02-10 00:00:00	\N	K5B	74cd19ee-bfbf-4796-8f4c-2321db746ec6	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
129a55a7-d728-46fa-81cf-c94e69f20e0b	t	f	2022-02-10 00:00:00	\N	K3	3cc19294-8c07-4e8b-8e87-99eeb196fdef	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
24c4bed4-84e0-4a2a-9fb5-0d6abf2f180f	t	f	2022-02-10 00:00:00	\N	K1	da48b40b-40f6-4fcb-a3f2-e8c458dfab53	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
02bf2a12-8b81-402e-948e-836357b78d89	t	f	2022-02-10 00:00:00	\N	K1	9982bbb2-4b4e-4ebc-a2b9-86801153170e	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
cab34ae7-a832-43fd-a9d6-29cd5b708528	t	f	2022-02-10 00:00:00	\N	K4	04b3c670-8ffa-4df7-a023-1ec850d25f3f	0fa002f3-d432-46d4-a753-991d021db3fa	b0574726-8fed-4a1f-aac3-09f61225548d	\N	\N	\N	\N	STARTET	\N
aca40c1b-b396-49fd-9ccd-d5e728b8c467	t	f	2022-02-10 00:00:00	\N	K1	af0259a4-5b74-4920-be86-24253a49b5df	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
ae2aa34e-9753-4eec-b36f-9b9c4b0f53f9	t	f	2022-02-10 00:00:00	\N	K2	323ebe70-a430-4fb2-a6f1-c55dcf4043b8	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
66b60554-6164-4fa4-bae2-bc664ee8cb3b	t	f	2022-02-10 00:00:00	\N	K3	c87b5036-1cc1-470f-8d59-9b44c30236c9	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
15a134ab-5e02-42f8-bf04-5d0f797eed21	t	f	2022-02-10 00:00:00	\N	K3	2f51dc51-4db9-4c2d-aef8-87376424af1d	0fa002f3-d432-46d4-a753-991d021db3fa	4c850776-1fc1-4201-9490-c1e848cd0f00	\N	\N	\N	\N	STARTET	\N
3e1c052c-615c-49df-80ae-b0c5c39bbbde	t	f	2022-02-11 00:00:00	\N	K1	204f36db-73fe-487e-86a3-f022a325b543	0fa002f3-d432-46d4-a753-991d021db3fa	0f604f34-370f-4593-8173-cd24234cff78	\N	\N	\N	\N	STARTET	\N
040f3649-55c4-400f-a374-8d5da7af1eee	t	f	2022-02-13 00:00:00	\N	K1	17b9db44-1cbf-4569-9dc3-cd5b409087dc	0fa002f3-d432-46d4-a753-991d021db3fa	80c08ccc-c90e-4377-af3b-2de779197c7a	\N	\N	\N	\N	STARTET	\N
6b57215a-b98e-482f-818d-728d39a20d2e	t	f	2022-02-13 00:00:00	\N	K3	9f08602c-43ab-4d17-84e8-5f3df48f1cb3	0fa002f3-d432-46d4-a753-991d021db3fa	80c08ccc-c90e-4377-af3b-2de779197c7a	\N	\N	\N	\N	STARTET	\N
2a03c54c-f369-454d-92ab-09228fea257a	t	f	2022-02-13 00:00:00	\N	K1	4babe487-99a1-4e0c-b2c2-77e2f45d94c7	0fa002f3-d432-46d4-a753-991d021db3fa	80c08ccc-c90e-4377-af3b-2de779197c7a	\N	\N	\N	\N	STARTET	\N
6c25b741-f692-4aaf-8f59-1ee4c18cad39	t	f	2022-02-13 00:00:00	\N	K1	a35cce08-9cfa-4f8e-9ba1-0f5258991449	0fa002f3-d432-46d4-a753-991d021db3fa	80c08ccc-c90e-4377-af3b-2de779197c7a	\N	\N	\N	\N	STARTET	\N
cc51a0df-3e82-4355-b710-060e13b8b8bc	t	f	2022-02-13 00:00:00	\N	K6	37cd7dbf-615b-42c0-9921-82619309eb75	0fa002f3-d432-46d4-a753-991d021db3fa	a0ea91c8-f018-424b-ac69-1246f657d591	\N	\N	\N	\N	STARTET	\N
bf272b33-cd7f-4a16-9503-42acd3e905a9	t	f	2022-02-13 00:00:00	\N	K7	a35592f4-42ba-4a9a-9975-474d5ab2ccbc	0fa002f3-d432-46d4-a753-991d021db3fa	a0ea91c8-f018-424b-ac69-1246f657d591	\N	\N	\N	\N	STARTET	\N
14490095-c041-4501-9153-30dc446bdf4b	t	f	2022-02-13 00:00:00	\N	K6	e94ba6f3-88b7-4a9a-912c-424bbb4ac291	0fa002f3-d432-46d4-a753-991d021db3fa	a0ea91c8-f018-424b-ac69-1246f657d591	\N	\N	\N	\N	STARTET	\N
515886b1-68e9-45e1-a9d7-7b1c4e2331ee	t	f	2022-02-13 00:00:00	\N	K6	1e74800f-9898-45b5-8543-3d77d6109111	0fa002f3-d432-46d4-a753-991d021db3fa	a0ea91c8-f018-424b-ac69-1246f657d591	\N	\N	\N	\N	STARTET	\N
0450f96a-4393-4a18-98b4-37606f6e3c09	t	f	2022-02-13 00:00:00	\N	K5A	9040fb01-f219-4dd9-b54e-2fc02ece5aa7	0fa002f3-d432-46d4-a753-991d021db3fa	a0ea91c8-f018-424b-ac69-1246f657d591	\N	\N	\N	\N	STARTET	\N
de32d252-2fa5-4837-88db-f92cdb9fe35f	t	f	2022-02-13 00:00:00	\N	K6	8987f318-8ee9-4d96-8a01-cdd2fef52fe0	0fa002f3-d432-46d4-a753-991d021db3fa	a0ea91c8-f018-424b-ac69-1246f657d591	\N	\N	\N	\N	STARTET	\N
8c02790f-ef81-4338-b118-b8da711a0f60	t	f	2022-02-14 00:00:00	\N	K1	39cca78d-0cd2-4bcf-873a-912aa1f89f6e	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
de325dba-754e-45ce-a9b7-c183f92230ce	t	f	2022-02-14 00:00:00	\N	K1	be43843b-d939-4151-8595-a42bc28e9ee3	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
392844cb-6ee6-48c4-af6f-7ca4369387fa	t	f	2022-02-14 00:00:00	\N	K1	f769707d-eab4-4f6c-acfb-f5ec0ccf5265	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
e03b4377-9198-4efa-8552-43eac83ecc35	t	f	2022-02-14 00:00:00	\N	K1	f917de79-0c46-4ee7-8d8d-5188b811ed2f	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
fc4e6727-5d8f-4736-ab32-a093e88402f5	t	f	2022-02-14 00:00:00	\N	K1	fad485ef-5f14-4a7e-b330-eb8b3277b4d8	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
76b23339-223a-4756-922b-9a964d17e7fe	t	f	2022-02-14 00:00:00	\N	K1	f43391a6-c3a4-4712-933c-2738f2c3930c	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
1ef0363c-e182-43dc-9a6c-82f438ea9241	t	f	2022-02-14 00:00:00	\N	K1	970554d5-e2bb-4a11-9b3b-4d5f21f3c044	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
9f199556-fbe0-44cc-b2ca-1be92e0f4508	t	f	2022-02-14 00:00:00	\N	K2	c889dac3-63c1-46bc-a3b3-7e6cf4e5dd48	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
0b911431-f65f-4392-b8e3-9c01c6e8acf8	t	f	2022-02-14 00:00:00	\N	K2	b7dcdcf8-3950-4a59-a3da-4c670c5dd8cb	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
fe8ba249-e512-43c8-b7fd-65fb24035eee	t	f	2022-02-14 00:00:00	\N	K2	37d27df3-0635-4f62-8259-3badb1627eb9	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
c5b6d564-1542-4907-b4c2-600568589bae	t	f	2022-02-14 00:00:00	\N	K2	44ef5cf2-c181-48cc-acaf-1d4d4600f5d5	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
9121a949-1554-47f6-b274-d1b0132e61f4	t	f	2022-02-14 00:00:00	\N	K2	9e151d5e-fc95-4cb0-b122-32dd2428977e	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
11947574-5526-41fa-b79b-c0afb19e2941	t	f	2022-02-14 00:00:00	\N	K2	f1e4f67e-c63b-4de7-b53d-ffb0b975c9aa	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
f3dd75c1-c317-471f-8e20-580576c27100	t	f	2022-02-14 00:00:00	\N	K3	fd260ab3-e112-4b4d-baf9-ce4b8829fd58	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
74ac5832-b44c-46b1-ae06-8076d3d1b2f2	t	f	2022-02-14 00:00:00	\N	K3	3079af91-3596-46e2-91ea-aa04659babd2	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
6b9e9b62-3362-404d-af77-cd935a4c10f8	t	f	2022-02-14 00:00:00	\N	K3	0f28a350-d776-47da-8cec-e1897a044f8c	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
9f972ba3-6fe0-468c-888f-94372e89bfbc	t	f	2022-02-14 00:00:00	\N	K3	519ef3f1-fde8-4c15-8bf0-ddf1908a8dac	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
7ee92e78-ed9c-4e5c-827c-a29921a7433b	t	f	2022-02-14 00:00:00	\N	K3	89381afc-46d6-4e04-a11c-de0320fbfc78	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
fb027d61-3d51-4c04-83d6-def2b04bb76e	t	f	2022-02-14 00:00:00	\N	K4	ee28252a-ed46-4f20-ac8d-b4668af7a11a	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
2a2eb729-7258-4e1f-9a0c-1726b240b520	t	f	2022-02-14 00:00:00	\N	K4	58f975ec-5698-4901-a51b-2ed21231a06b	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
67130b8e-df58-4155-8fa8-fe8ee876e71e	t	f	2022-02-14 00:00:00	\N	K4	f4baa885-6558-49ee-961c-2460d24b90fa	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
c0ee28da-9ca2-4233-9f71-0c64e1313fdb	t	f	2022-02-14 00:00:00	\N	K4	4eb11125-35a5-4152-8aeb-8f6721e69f32	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
d3e3b91e-a6ae-4625-b60f-5c0ce14de542	t	f	2022-02-14 00:00:00	\N	K4	c6e64f28-0606-482c-9190-ef875a83f9a7	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
9b3107f5-e651-4b41-a204-326130b9ab64	t	f	2022-02-14 00:00:00	\N	K4	4d9eeece-35cb-4d9c-8163-b4285abccaab	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
d10ed322-302f-4f97-a941-497ab5d70a39	t	f	2022-02-14 00:00:00	\N	K4	8dce089f-221a-4603-950b-29d30d67dd32	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
0d85b34f-45a8-4dc6-b255-fc77e9c64f3e	t	f	2022-02-14 00:00:00	\N	K4	75c0768e-754b-4683-9721-c0a4a7964a74	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
e87d3174-e3c9-479b-9180-7ba779cd2098	t	f	2022-02-14 00:00:00	\N	K2	c46fa5a7-7da7-4d1b-a621-379f06624c18	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
4ce77405-5dd9-421a-8044-0218ee469c97	t	f	2022-02-14 00:00:00	\N	K5A	600aed34-2b3f-4b2f-b994-c88cc057fa1f	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
5d39ad23-b35d-4d0e-b4b6-a949c204d4d6	t	f	2022-02-14 00:00:00	\N	K2	fe75f546-fbda-4359-99a5-bf7a2d199473	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
a916f587-a6b7-4c5f-93c3-f3b1dc4e5898	t	f	2022-02-14 00:00:00	\N	K2	27071f63-625b-40cb-b90c-0d3965d58a26	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
ad03e1f6-d6b4-4f3a-be0e-f2e9eada243e	t	f	2022-02-14 00:00:00	\N	K5A	119aa0b4-98bc-4323-ba79-ffe4b341702e	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
ff8c93b3-73ca-40d0-9ba6-2d2fdce101d1	t	f	2022-02-14 00:00:00	\N	K5A	0a086872-16f7-44f0-840b-117b7903f985	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
0ab93b26-57b5-4b40-bc25-6aea741e92ac	t	f	2022-02-14 00:00:00	\N	K5A	a9c6afa4-bc6b-416d-82d5-b9464c41a98b	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
08b00e5b-4ea0-46ad-be78-57e6269ba5f5	t	f	2022-02-14 00:00:00	\N	K2	b9e67fa0-6e6b-488d-9700-7c09db0c7f00	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
6a6c520e-c18a-4f75-9449-eee1ce54cf8e	t	f	2022-02-14 00:00:00	\N	K2	733fd6c1-6d74-4c8a-92e0-eb7b8616fb53	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
d9ca07b2-0618-4fcc-8881-c8ea96f5fa53	t	f	2022-02-14 00:00:00	\N	K6	43f462b2-d838-4f31-a4ee-2814fb879e0f	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
e437478e-fdee-49e8-b659-65f832f6f691	t	f	2022-02-14 00:00:00	\N	K6	b1633444-8257-4756-8073-6db26001c999	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
bf0ecc5d-6dce-4c24-a122-c5ed54f93722	t	f	2022-02-14 00:00:00	\N	K6	02df6e15-dc3b-4178-aa36-6143fd599b1a	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
d1a32225-3bf8-4fec-a5f1-970b86bfa28c	t	f	2022-02-14 00:00:00	\N	K3	00f85482-195f-4094-bf12-2106c49eab50	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
32689cbf-aaaf-4dda-97b3-5541d7098d52	t	f	2022-02-14 00:00:00	\N	K3	2ad972e6-5f71-4889-88e6-1b159d394540	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
9368a40b-9c46-4987-9300-e72fa473c894	t	f	2022-02-14 00:00:00	\N	K3	091d5e4f-def6-40fb-9852-442f548f86fe	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
884d8719-0e6b-4503-aaf1-43efa34ab866	t	f	2022-02-14 00:00:00	\N	K3	257d9583-316d-43ce-a086-2e017e4751bc	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
9810d530-19f0-452b-bebe-d643db832648	t	f	2022-02-14 00:00:00	\N	K3	9a88ca4b-fd7d-4b5d-ae9e-6ea7a5057a72	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
4d986596-3ef1-4199-9c39-8fe565092370	t	f	2022-02-14 00:00:00	\N	K3	2da35814-095b-4e74-97b1-b188de8fa1a3	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
395b9b08-31f1-4fd3-9d0c-0e6ec38b0d23	t	f	2022-02-14 00:00:00	\N	K3	e61ff2cd-18b2-4740-970f-43aeeceb6cfa	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
0b663988-e2e8-4031-bb2a-deef875ab1ee	t	f	2022-02-14 00:00:00	\N	K3	ce06fe1b-36b4-4ee5-95fc-0e7548c4a753	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
6a0f7824-b203-4681-b566-9a9641256ac2	t	f	2022-02-14 00:00:00	\N	KEIN_START	9687bf7d-448d-478c-a972-7f53345260d3	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
eb28faf5-7fd1-4a36-add1-e70bf49e702f	t	f	2022-02-14 00:00:00	\N	K1	b0842845-56ea-4663-844e-9b7652074fa7	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
c47f0e71-7966-46aa-8f31-a5e2da8518ad	t	f	2022-02-14 00:00:00	\N	K1	95e9bc4b-3193-44bf-83ac-a2210f0539d1	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
bd2d3975-d4f1-4680-bf40-baa901908a2a	t	f	2022-02-14 00:00:00	\N	K1	8d2e3f23-b9a1-4f42-976f-507dbe752c0f	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
b0ca1866-db13-4990-9d06-516181f13f1b	t	f	2022-02-14 00:00:00	\N	KEIN_START	434e5d65-019d-4c6c-a886-f6431c0fb1c2	0fa002f3-d432-46d4-a753-991d021db3fa	d48095c7-3de5-4a8d-b893-b8d432e7c647	\N	\N	\N	\N	STARTET	\N
3460f18e-6431-49d8-b182-30fcb081f06d	t	f	2022-02-14 00:00:00	\N	K5A	a13d3bbe-79d2-4ead-a9ed-ee5fa1198b59	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
251e0a06-4e19-4745-a333-9c7d93500d42	t	f	2022-02-14 00:00:00	\N	K4	0c5561bd-4984-4715-b885-ad7f957d7a78	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
f0adc987-634e-4b18-9da4-9981fd283a86	t	f	2022-02-14 00:00:00	\N	K1	2147bb17-f1c7-4cc8-86a9-e7a5b55bd09a	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
e78d2738-68bc-4339-8b8b-6e01a7253c31	t	f	2022-02-14 00:00:00	\N	K1	74843001-070e-4620-9e01-b86ab5970a9f	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
0048e641-29e3-46e1-95ab-aa93d0efd12f	t	f	2022-02-14 00:00:00	\N	K2	b26369da-8a80-4bf2-85e7-6f89ee0f5df2	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
fc777ffd-0b0c-40a5-850c-f7d6c612a26e	t	f	2022-02-14 00:00:00	\N	K5B	ec9a0640-39c3-4a97-9f1d-63acf4630589	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
e4772249-9e26-4a95-a7b9-258a6aaea832	t	f	2022-02-14 00:00:00	\N	K1	0cb847e6-92fd-416b-9497-7711594bb569	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
b51292b1-b1cc-4ad0-8659-7ae90cb495b2	t	f	2022-02-14 00:00:00	\N	K1	a8b593b4-b511-4cd8-9525-61302cd859fc	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
cac07844-0959-41f7-8461-9b1a224aa695	t	f	2022-02-14 00:00:00	\N	K1	a20a71d7-7882-42b2-855a-641b66a39208	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
90a3205e-6221-4619-9029-6b141a114c59	t	f	2022-02-14 00:00:00	\N	K4	ea2f0d01-e31a-4838-9997-bf6b51bf1773	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
f95d8720-bd45-4266-ad76-b74e80fe300b	t	f	2022-02-14 00:00:00	\N	K5A	1a427459-e70c-4f00-bd79-85af371a4509	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
fec60ad3-e778-499c-befa-c31a5ce8132c	t	f	2022-02-14 00:00:00	\N	K5A	9b4fbc30-a935-4da7-8370-505f032abe04	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
124496c3-b278-426d-af54-09cfffe44dc7	t	f	2022-02-14 00:00:00	\N	K4	e8cba3a1-5869-49ce-9c43-4a8224c7e2a3	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
c1c9a057-57fb-446a-a2ae-c75ad92f51be	t	f	2022-02-14 00:00:00	\N	K5B	da5feae4-a7ea-4ed8-9749-94f7ada45d59	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
dbc6b33e-6a29-4abd-8fb6-a2a39f5640e9	t	f	2022-02-14 00:00:00	\N	K2	4cd54a77-8a8a-4bba-a33a-78c4be46eaab	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
4684284c-a861-4c52-bb83-c61a4a5f3c4d	t	f	2022-02-14 00:00:00	\N	K5A	d6d6aba3-0f7b-4eac-94ca-89395eced0c2	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
f9272b3d-883d-4bfd-9c10-8e18afa610a7	t	f	2022-02-14 00:00:00	\N	K2	19a090dc-b4ad-4423-b6f6-3f02439c2ce7	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
1afd0be5-fac6-4769-b1e8-faea2c3fbf56	t	f	2022-02-14 00:00:00	\N	K2	39c7fa6e-dcb0-41f8-a3c6-c34f7a511fcf	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
7f89dd52-faf8-43f8-9138-876dbeccf6be	t	f	2022-02-14 00:00:00	\N	K1	9ac6942e-af1a-4ac4-8208-e529cc05ac3f	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
da82a94e-da7f-4b6c-9ff8-163de47f08e2	t	f	2022-02-14 00:00:00	\N	K2	78096179-2af4-4450-b4a6-8d8898d86292	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
058c3792-38d2-4818-b5a0-9c37f90e014f	t	f	2022-02-14 00:00:00	\N	K4	51991c27-abb9-4e54-94a3-7ef5bf932dc8	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
7b2e7171-6034-4258-90aa-f372fa717d31	t	f	2022-02-14 00:00:00	\N	K4	6f9ec879-5961-4840-877e-b9de6defcde7	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
2a8c51cc-81f7-4abb-b47c-c57f41fe8827	t	f	2022-02-14 00:00:00	\N	K5B	ec897b52-2315-4648-92c3-3111c5725355	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
2727a89d-68a1-4114-9a76-0a54aae5a15b	t	f	2022-02-14 00:00:00	\N	K5B	9f897303-76c4-48cf-83dd-ab8c8e12ea53	0fa002f3-d432-46d4-a753-991d021db3fa	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N	\N	\N	\N	STARTET	\N
47fef226-26d3-4d30-ba58-e97e51b46698	t	f	2022-02-14 00:00:00	\N	K1	2fc03927-c3b6-4bba-8578-12a4a6d99081	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
e2003e78-866d-4cbd-9a5a-220d38b6bf49	t	f	2022-02-14 00:00:00	\N	K1	2b8fbc3c-0944-41e4-bc34-f525a6a02d5a	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
13bd9b58-fd06-4ed7-ac05-96bfec37983a	t	f	2022-02-14 00:00:00	\N	K1	41b9e113-369d-4afb-853e-b10d2dcfd1ba	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
c461c603-a063-45c4-9500-4e65a129cab1	t	f	2022-02-14 00:00:00	\N	K4	a410c2d8-8006-498b-9fef-92580de60544	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
880f1e7a-caea-4596-81ec-b2ddf5e24d33	t	f	2022-02-14 00:00:00	\N	K4	95329cf9-5086-41db-b633-f1ed7d5ee273	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
7aff9e83-f27a-4bd1-9948-c38946dd4182	t	f	2022-02-14 00:00:00	\N	K4	308f1b9f-4ef7-42b8-8ba1-c1387edeab5f	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
a0212458-e6f1-4a2e-a164-491a4891e5fd	t	f	2022-02-14 00:00:00	\N	K4	3930671f-c62e-4e1a-bbcc-372d6c4375e8	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
0aaa19f2-40a2-4fc8-b38c-4c3f69319f2c	t	f	2022-02-14 00:00:00	\N	K4	677dcd6c-0415-493f-86c3-783d7679391a	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
e491cb95-6b71-4c76-b0fb-161666bf21cf	t	f	2022-02-14 00:00:00	\N	K4	c4c14e85-61d5-4d7b-a40a-382fbeca63ee	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
9236a733-1fde-4011-9cb2-c4a93b57fdfc	t	f	2022-02-14 00:00:00	\N	K5A	3b9ad9f0-4857-4d42-b3c8-fd2892aca400	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
d3da0141-147a-4d17-b9f9-18e0a1fee61f	t	f	2022-02-14 00:00:00	\N	K5A	6f002a8b-ee2d-43a9-a405-0bab808471a3	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
c703fe72-01fd-4766-b683-a4f6d19589d4	t	f	2022-02-14 00:00:00	\N	K5A	637882c0-1a02-4a3c-90d2-ca343eb28a71	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
0542b74f-47c2-42d2-9423-7a822b3b737a	t	f	2022-02-14 00:00:00	\N	K5A	53f9eaab-dda1-46a3-879e-262f0faf794f	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
42d8e79a-3a1a-4372-bb64-7a7878c2c83c	t	f	2022-02-14 00:00:00	\N	K5A	4df2f22c-42b5-4b99-b474-7a84902b1d3d	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
7ca1085d-ddea-4be1-8e9c-a32ee84a8c08	t	f	2022-02-14 00:00:00	\N	K6	296d0e54-a91b-4be1-9cd0-5e5f4010df58	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
378591a7-8a29-487d-a03d-5540f11f24c5	t	f	2022-02-14 00:00:00	\N	K6	e1a462f1-5330-406f-9728-26e08b3227f8	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
91c30f56-c5b5-420c-a9c2-80f06fc18a52	t	f	2022-02-14 00:00:00	\N	K6	5bf0671b-b72d-461a-9be2-a04844344f8e	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
3971ae10-9446-4a05-a135-b4ad5782cd0e	t	f	2022-02-14 00:00:00	\N	K6	5fdef84b-8f50-4e5c-b99b-8c143310f915	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
d0b25fb8-2161-4a33-b625-b3b300c2110d	t	f	2022-02-14 00:00:00	\N	KEIN_START	31268dc0-7ddd-40e9-916e-cfbb6efe33de	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
5ba04d39-6e84-49e2-b851-cd062f39769a	t	f	2022-02-14 00:00:00	\N	K6	a1e7eeae-606a-43c7-8de3-7ad2ba5b5214	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
8376de05-0a89-4704-8dec-3967557076f9	t	f	2022-02-14 00:00:00	\N	K6	516bc84a-6327-481e-a2d1-cddc3cc93b1d	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
8b2ae63d-08b8-44e2-9c20-0ad5061e5141	t	f	2022-02-14 00:00:00	\N	K6	218d26c4-423a-4ed5-b66a-f1cf081fd2aa	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
1d4dc085-965e-47b2-976c-2108e9972d6d	t	f	2022-02-14 00:00:00	\N	K7	f9babbe8-296f-4769-b8cc-bd05f1e44629	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
0e34956c-65cf-4789-b5c9-18979a38d85b	t	f	2022-02-14 00:00:00	\N	K7	21fe8a9a-ae8b-4450-83f4-ed2bccc11130	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
27069bbf-c3b5-4e92-b3b5-428d33082a7c	t	f	2022-02-14 00:00:00	\N	KD	0c3e225a-ee87-4e8e-a877-93145ba5e999	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
2a3254c1-5719-4062-a624-13923769c42c	t	f	2022-02-14 00:00:00	\N	KD	f7d9c4a8-4175-4879-90d9-d0aeea11b932	0fa002f3-d432-46d4-a753-991d021db3fa	a314f7e1-0d6a-4b32-ac12-3d4910c3c87e	\N	\N	\N	\N	STARTET	\N
d7a0e749-027f-4d5b-89d7-96f9ee15ea55	t	f	2022-02-07 00:00:00	\N	KEIN_START	5735461b-bd9a-41ce-866f-a9dbde723840	0fa002f3-d432-46d4-a753-991d021db3fa	5ee987b5-deec-4087-b36f-bba4dcaf842f	\N	\N	\N	\N	STARTET	\N
a1b71d40-ac72-4a38-95dc-4bc1fd137b59	t	f	2022-02-14 00:00:00	\N	K1	14899b67-d0a2-4a8b-936b-6a2d4391067a	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
266e60cb-80a4-438f-b47a-72132c02e79d	t	f	2022-02-14 00:00:00	\N	K1	d16e18b7-e9c7-4d0e-8f71-73220c7f7dc9	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
0129fb09-2224-48e5-a4ab-a80c50305d61	t	f	2022-02-14 00:00:00	\N	K2	cf20aa88-3cea-4e29-b8c9-89c3b3e99c2e	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
78764b1a-d611-4bf8-abfa-ba621534de92	t	f	2022-02-14 00:00:00	\N	K3	d0d9e4f4-95cc-4611-b99e-27dcfe523783	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
9fa0d888-0997-491d-ab09-6e8f1ea81ec1	t	f	2022-02-14 00:00:00	\N	K1	1cb8f581-6c81-4ee9-b47b-c89bac12c2e2	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
9f562520-0fa0-4c3e-aba9-56312c1d3892	t	f	2022-02-14 00:00:00	\N	K1	fc45aeb9-281a-4482-bc18-c35b35b2bace	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
cf2c3efe-9b8e-4428-a46e-68bfe837766a	t	f	2022-02-14 00:00:00	\N	K5A	9dad4acd-c835-4711-9a5a-d1d1e6d86dfe	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
6a126f6a-8bda-4e25-8cce-374876e87ae8	t	f	2022-02-14 00:00:00	\N	K2	1e906a1f-dde2-425a-9823-5a1a875edf7b	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
8067a95b-1223-441e-bee4-6d58a8c071c8	t	f	2022-02-14 00:00:00	\N	K2	8538e068-d62d-43c5-ae21-0c47a5c568c4	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
6a835eb6-e153-462d-90ba-7c0c27804a72	t	f	2022-02-14 00:00:00	\N	K4	c13629c4-97b8-4cee-81a6-bceb003bf8f7	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
17c3c5c9-2e87-406b-ad08-59040cf2f68f	t	f	2022-02-14 00:00:00	\N	K4	b9998e65-2891-487d-ba52-e4e239c39e7b	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
c1a63147-2293-436d-a0ad-96fb829f0034	t	f	2022-02-14 00:00:00	\N	K5A	94884068-05ac-422c-9a1c-ab52873f43ea	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
bcf62b6a-68fb-442c-b1f9-17845b1e6dee	t	f	2022-02-14 00:00:00	\N	K4	15cd7097-57e7-4d29-8e1c-fe1f3b1c301f	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
2ad1af5c-4476-4023-816b-40fefefeade3	t	f	2022-02-14 00:00:00	\N	K2	45f0ea41-9d32-47c3-bb8d-f59195846d41	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
8d5487ec-442d-48aa-87c1-ff0a8edf6ed9	t	f	2022-02-14 00:00:00	\N	K5A	2284a70c-0a8f-41dc-8074-6650ab9bba41	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
650d14df-d477-4415-bf46-96a7591f5242	t	f	2022-02-14 00:00:00	\N	K4	711698fa-5e0a-4dec-9168-b6dfe10f077c	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
958b86a1-9714-4f82-aa55-4737bcbf2784	t	f	2022-02-14 00:00:00	\N	K3	e11fac57-6be1-4244-9c9d-361177f235ac	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
ade05b67-91c9-4828-a817-b3dc869720bf	t	f	2022-02-14 00:00:00	\N	K4	61696721-1964-4ed9-93c6-231b89375d77	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
ce20171b-88e9-4bd7-a1da-d0f059b1d495	t	f	2022-02-14 00:00:00	\N	K3	30b8423b-989b-4118-94a9-25cc5c87dc07	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
a8cb513b-788f-415a-a8fd-a39cf87939ca	t	f	2022-02-14 00:00:00	\N	K5A	ea44538b-9ca4-4d50-b2d3-beddf6836c75	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
6c822292-fb72-416d-bc46-ece5ab9415a1	t	f	2022-02-14 00:00:00	\N	KD	bb41ec26-b1b4-407b-98b1-9d17bcb11f11	0fa002f3-d432-46d4-a753-991d021db3fa	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	STARTET	\N
739e7406-9523-435e-a9bb-bd1c9680c29c	t	f	2022-02-08 00:00:00	\N	K5B	1482f0ae-d2ed-448b-9bdc-f44a332e9e59	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
920c6f25-7880-4890-a721-0e890664b6c5	t	f	2022-02-14 00:00:00	\N	K5B	af66922d-dc0b-4a1b-b91b-31e7009aef4a	0fa002f3-d432-46d4-a753-991d021db3fa	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	\N	\N	\N	\N	STARTET	\N
\.


--
-- Data for Name: verband; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.verband (id, aktiv, deleted, change_date, deletion_date, verband, verband_long) FROM stdin;
0da6da10-2d26-4285-8e7e-7154ba5447e5	t	f	\N	\N	STV	Schweizer Turnverband
702c2173-19a2-44c5-bb06-4326f779f4d7	t	f	\N	\N	ZTV	Zürcher Turnverband
e804eb0e-ed31-42aa-8154-38cc0ddf2126	t	f	\N	\N	GLZ	Region Glatt- Limmattal und Stadt Zürich
ecd2ee2f-6d5a-4f85-a7eb-b935ef9188c4	t	f	\N	\N	WTU	Region Winterthur und Umgebung
08204af7-4284-468a-8708-efd7fb0b8abb	t	f	\N	\N	AZO	Region Albis, Zürichsee und Oberland
2609279d-2cdb-4071-a129-4754e8e70b90	t	f	\N	\N	UTV	Urner Turnverband
458a69b6-75dd-4c17-a9aa-eeb755e8b3a8	t	f	\N	\N	GRTV	Graubündner Turnverband
b72f2c99-7568-43df-a653-89b52cafa6a3	t	f	\N	\N	SGTV	St. Galler Turnverband
615871dc-2529-4a4e-a93d-b4cb8e402ba8	t	f	\N	\N	TGTV	Thurgauer Turnverband
ac0143a2-ae79-49bb-918e-100b22ec702d	t	f	\N	\N	ATV	Aargauer Turnverband
\.


--
-- Data for Name: wertungsrichter; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wertungsrichter (id, aktiv, deleted, change_date, deletion_date, person_id, brevet, gueltig, letzter_fk) FROM stdin;
6a8f3370-50b4-481e-9463-9703e20fed7b	f	f	2022-01-11 00:00:00	\N	e8bb3a4e-ff5b-4d60-8e37-f2358c646077	1	f	\N
53f7163c-87a5-470d-9c0e-bcd19ddfe0c1	f	f	2022-01-11 00:00:00	\N	faf769a3-47fa-4c20-b65c-24ddff3abd01	0	f	\N
a75781e7-5f8c-4dac-a631-b60a276c4b30	f	f	2022-01-11 00:00:00	\N	413f0fe6-ffc8-49c5-ae71-1ff527b8930b	0	f	\N
1afa03ce-cd61-434a-8bdc-e0ae8350fd52	f	f	2022-01-11 00:00:00	\N	e201e5ef-cac2-465f-9956-4abecdbd08c8	0	f	\N
4d97ad26-a09c-4be8-a5f1-b9c33ec5730d	f	f	2022-01-11 00:00:00	\N	6b5ccf49-c989-4973-8237-95717f010161	0	f	\N
9893bbc2-4128-4457-b86f-a194f887ba74	f	f	2022-01-11 00:00:00	\N	de6d4c3d-283c-478c-87fa-278cac6f692a	0	f	\N
1a6db83c-66bb-4208-aacb-c2b159672696	f	f	2022-01-11 00:00:00	\N	f255be7f-d6da-42f8-97b0-80aefbbfd52d	0	f	\N
e3b14d22-0947-4272-8977-55748ce10ddd	f	f	2022-01-11 00:00:00	\N	f575215f-4eab-4db9-993c-f0a89d64746f	0	f	\N
d4c1cf45-237c-4e0d-90da-3fcb39b92f1f	f	f	2022-01-11 00:00:00	\N	fcbe03a8-fe1c-4a28-892b-9e09eda4820b	0	f	\N
c191f0ca-99b0-4e39-954b-6e65d37914ac	f	f	2022-01-11 00:00:00	\N	6b94806e-bc8f-4ea0-99b9-5397759bc338	1	f	\N
1a6a14f4-a23d-419a-95d8-d2ba29028a46	f	f	2022-01-11 00:00:00	\N	9578f329-e7f1-4839-a676-b5586136a56d	0	f	\N
ea05343f-396a-42b4-9373-eca96e972348	f	f	2022-01-11 00:00:00	\N	c23e3b72-abf0-476c-8c06-98f79cb9e79c	0	f	\N
5792036b-728d-42fe-affd-11c2adbc4ad3	f	f	2022-01-11 00:00:00	\N	86b3a1de-3668-4dcc-97ac-8cc6d2d599d6	0	f	\N
d22267ed-6bae-41ac-bb2a-ac4c7cb8aac6	f	f	2022-01-11 00:00:00	\N	9b6422ac-fd26-44e4-a0a7-6ea980ddf8ef	0	f	\N
11d6f19b-dcd4-49d8-8deb-c174bc487bec	f	f	2022-01-12 00:00:00	\N	c43e58b3-e4b5-4fd5-a470-ad57d7bdf1fe	0	f	\N
335a94c8-2ead-4d79-bde2-460e335ee044	f	f	2022-01-12 00:00:00	\N	f262a7de-3583-4ea0-b3f8-9003b8e0ee88	0	f	\N
c5d649e5-9aa3-4221-a0ec-036d03d1393e	f	f	2022-01-12 00:00:00	\N	55407925-43fe-43cc-aa02-fb647b012dfc	0	f	\N
f524a41e-70a9-4b2a-8943-a126ed2fdd02	f	f	2022-01-22 00:00:00	\N	d51f134d-0515-4910-a830-441f701f687e	0	f	\N
d9c29426-2d8b-4f66-aa06-543b9cc028cb	f	f	2022-01-14 00:00:00	\N	98446f19-e0a5-4c96-853c-2c0b6751a9d2	1	f	\N
55ea0286-12cb-4e01-9d80-18977c599fa6	f	f	2022-01-14 00:00:00	\N	5d5d4b80-7009-4b03-950a-be4e5e97ac7c	1	f	\N
24a295bd-d27e-418b-8e76-e2383d65b70d	f	f	2022-01-14 00:00:00	\N	fa0e3750-34e6-493d-b3fc-d93b7506ab14	0	f	\N
c3b31c6a-fda8-41e1-9136-499c97c526ae	f	f	2022-01-14 00:00:00	\N	3f855bcc-e320-4346-b97b-ab7c74bb9e35	0	f	\N
58d5aaf6-7074-4d36-9c9e-5b62cb99164f	f	f	2022-01-14 00:00:00	\N	f05edd05-f39e-480d-b1dc-c07df0b5639e	1	f	\N
e225f2f3-eef9-4510-8fbf-6349bf41551d	f	f	2022-01-14 00:00:00	\N	474b3b8c-3108-48a6-bc8f-da6ad98a062d	1	f	\N
ace97f48-aae1-4bf6-b31e-078812da26ca	f	f	2022-01-14 00:00:00	\N	6b597911-6386-4da6-a771-d1ae47749e44	0	f	\N
56e7d9ab-ef0c-4b2e-ad5c-60d6824a4f3d	f	f	2022-01-14 00:00:00	\N	f06eddd1-2f48-49c2-b3f8-0671ae727d1a	0	f	\N
bbcd92f1-cd28-4f5f-b0b2-c84295f82f79	f	f	2022-01-14 00:00:00	\N	d1e393de-3fc5-4a5f-9684-10b3f5c4dc38	0	f	\N
752bf431-a64e-431c-85d4-9eb37002907f	f	f	2022-01-14 00:00:00	\N	35e7e6fe-5d65-4d2c-aa85-f4a127c8a74a	0	f	\N
44c9b438-15fb-4a4c-8f97-bb7fec08e0ea	f	f	2022-01-14 00:00:00	\N	df60d1e1-188c-4599-b481-f883bf6e43c9	0	f	\N
9728b74c-5006-40b5-93b0-10f39694dbdc	f	f	2022-01-14 00:00:00	\N	b50a9187-40f3-495b-904b-9ac1b0ecddf1	1	f	\N
9383b3fc-2de7-45b7-8798-f0fc13509057	f	f	2022-01-14 00:00:00	\N	bcf7557d-05e9-4eca-9b8f-f2293b122e6f	0	f	\N
41a2f45c-4b4a-4e59-8b86-f85a22cd90d7	f	f	2022-01-14 00:00:00	\N	d3616962-6b9d-44c8-be54-1d321ea5e511	1	f	\N
9c2ee5f7-9b6a-41ab-ae04-822a115ced50	f	f	2022-01-22 00:00:00	\N	07a30ce1-69bd-406a-9f46-5b790f2b5f77	1	f	\N
1282d53b-1b73-4129-a7b0-4b899ffb77df	f	f	2022-01-17 00:00:00	\N	d48a2241-8a41-403a-989c-d408bdbed5e4	0	f	\N
03cf3b2b-c8e6-453b-93aa-94c033de0a56	f	f	2022-01-17 00:00:00	\N	d716fa96-59e6-46c7-90a1-32583e8a4253	1	f	\N
7f72cfc5-9d91-4f88-97a1-ab0ed4165b40	f	f	2022-01-17 00:00:00	\N	c1ff2734-9478-4747-aa67-d84cf087868e	0	f	\N
5ba3ea8a-76c9-444e-8474-8bb27f40e9af	f	f	2022-01-17 00:00:00	\N	9926f56b-418a-4484-8b06-83d8b7dcec50	0	f	\N
bceab38f-9182-4b20-ba6d-0d84fbeca8ca	f	f	2022-01-17 00:00:00	\N	8fbdbec6-80f0-47a5-94d5-5d02fda96258	0	f	\N
fbc70dd8-a61b-4429-b6d0-3b84375cd9bc	f	f	2022-01-22 00:00:00	\N	21ac6f4c-e6ba-48dd-a8bc-63c8ccd1e158	0	f	\N
808eb6bd-7acf-47e3-a420-6bf5c2b42811	f	f	2022-01-17 00:00:00	\N	1c65ffb5-f1ce-4979-a2ce-bb0ac54f6ffc	0	f	\N
73115c9e-5e76-4f17-9103-cf4bf8b08714	f	f	2022-01-17 00:00:00	\N	4ec3c51c-93cf-43cc-9c48-8d588c04211d	1	f	\N
d7ad36b8-61e3-4791-9d31-5ecfcb7e0a03	f	f	2022-01-17 00:00:00	\N	611a1bed-57b2-4f8e-b0c0-9c7ce15d8719	0	f	\N
f27c009b-aeb2-4060-b219-ee74a3ec5b5f	f	f	2022-01-17 00:00:00	\N	af4c71b9-b08d-4099-9fb1-7cf9f23c1786	0	f	\N
90fac6ee-9e8c-45a2-84bf-a8289e51ed61	f	f	2022-01-17 00:00:00	\N	85679d14-b276-4d13-b9a5-1e9e88d4c76e	0	f	\N
fe431c00-a034-4ea8-a738-5bc416698394	f	f	2022-01-17 00:00:00	\N	19f95456-20f4-41ac-8d1d-c047fddcd9c6	1	f	\N
6c3bf3f7-ec9c-4c38-a408-d6de8a3f666e	f	f	2022-01-17 00:00:00	\N	c471fd65-a76b-4110-bc26-313e58c98491	0	f	\N
106be793-ec83-4a5a-b7c6-f457fd98d94c	f	f	2022-01-17 00:00:00	\N	be60e1fb-63e3-480e-9209-33d106a95c44	0	f	\N
a856e562-9df5-4885-a6fa-a91f8da24394	f	f	2022-01-17 00:00:00	\N	3f161f1d-4285-4694-aa13-842425295826	0	f	\N
54df2396-e9bb-458a-ae79-dfd9e2e489f2	f	f	2022-01-17 00:00:00	\N	4b3d79b0-79a5-4d52-9c25-36e7455097e1	1	f	\N
763783ae-8ace-40b9-9714-31b2b89a1c3e	f	f	2022-01-17 00:00:00	\N	8f9b9fca-0606-4944-a414-3d56b4d43ed6	1	f	\N
782b7207-e567-452c-9222-003e04a9a305	f	f	2022-01-17 00:00:00	\N	5eb2361a-e95f-49ab-8d15-b77d00fc7e1a	1	f	\N
fb731015-616e-413e-99a5-dcd58baaed6c	f	f	2022-01-18 00:00:00	\N	24f02407-5cf2-4384-8ea3-ec5292ce4a72	1	f	\N
0d87abbb-f023-46aa-b54c-0cc9a29b6bab	f	f	2022-01-18 00:00:00	\N	70870a17-d0c2-45be-ab72-3a819b3c7673	0	f	\N
0316605b-ab44-49f8-8f4b-852396cf79c0	f	f	2022-01-18 00:00:00	\N	c403ff2f-1f49-49f8-87b9-2563f163a437	0	f	\N
c0c86210-ac0c-49d3-a972-014220541613	f	f	2022-01-18 00:00:00	\N	06e1270e-8eda-4790-a920-7a4089869c7d	0	f	\N
abe50fa3-2ef4-4d18-96bb-f488174e5010	f	f	2022-01-18 00:00:00	\N	825576b7-1723-4c59-ab5f-1a4fd04c0d72	1	f	\N
a8e3fdb1-84b5-455d-9938-4993a33e7107	f	f	2022-01-18 00:00:00	\N	93851cba-8452-4b98-a25c-972fdb42c5cd	1	f	\N
cb31d7ef-447f-480f-95e0-903acf1a7c2c	f	f	2022-01-18 00:00:00	\N	e422a46c-df51-4aa4-bb5c-9b5b5f29e67d	0	f	\N
9c878988-8ead-4324-97d6-f7816b2da273	f	f	2022-01-18 00:00:00	\N	1a80a988-db22-4991-a676-091f902279c3	0	f	\N
87aa4ad5-0e6f-4ed5-9752-ab3f4032f303	f	f	2022-01-18 00:00:00	\N	3f56cd5a-ed1f-488b-aac7-752be8053a11	0	f	\N
aada2ed2-ff6f-4eba-950f-7bd180a00551	f	f	2022-01-20 00:00:00	\N	5d0b3959-5174-4530-ba14-b33f686b1b2c	0	f	\N
2cb2de79-f430-49b5-acb1-a158d21a4896	f	f	2022-01-20 00:00:00	\N	9a19e2a2-ace7-4d2c-a308-429c76d6d683	0	f	\N
1fe567c7-3e26-414a-b441-fbb0d0dbdeb7	f	f	2022-01-20 00:00:00	\N	2193264e-d362-4d75-a51b-b319dea02438	1	f	\N
5c37c1c8-49e2-4062-86c6-f6a633f55925	f	f	2022-01-20 00:00:00	\N	0e54809f-de03-4ccc-a761-2eb4541d5e01	1	f	\N
7e50de3f-6f98-4307-91d0-fe9f70bed06d	f	f	2022-01-20 00:00:00	\N	2e0b35ff-c539-4f6e-995c-f937202c9f88	0	f	\N
3de4355f-a180-4ddc-9230-7ab2841aa5da	f	f	2022-01-20 00:00:00	\N	d2296a55-2592-4eb9-884d-2ab5fc33b3d6	0	f	\N
03c6aa3d-25a6-4861-a27a-384030324b0e	f	f	2022-01-20 00:00:00	\N	72bcd2da-883c-4119-ad5b-3ac96d75e79c	0	f	\N
cf9a5fa4-2d2c-4985-a410-b05b1358e506	f	f	2022-01-20 00:00:00	\N	d66be606-f1a2-4202-8b68-41ce7630ac2f	0	f	\N
c54b09ba-f4f6-4a78-8984-eb8af0cffed3	f	f	2022-01-20 00:00:00	\N	622ae8b3-d876-4d6c-b4dd-0d6e93ea3df1	0	f	\N
5c30e52f-3061-43f5-b959-fadd42052c3e	f	f	2022-01-20 00:00:00	\N	c0fb2212-c732-4a53-a567-7fc5482381b0	1	f	\N
b21b05fd-6351-4d1d-a594-a60fc8aedd42	f	f	2022-01-21 00:00:00	\N	061f1886-4c55-442e-8b39-105a494a09ad	0	f	\N
9e3fca15-fb7e-4820-8aca-ef73b1b1d1b9	f	f	2022-01-22 00:00:00	\N	0bd1479e-448a-45b9-b655-668fddffe9ab	0	f	\N
931793eb-5168-462a-b924-a350f87d990c	f	f	2022-01-22 00:00:00	\N	7bd09345-9f0b-46b8-8c67-557e2fe1da3c	0	f	\N
a4fba4b2-7521-401d-8a2d-e6a678fa1835	f	f	2022-01-22 00:00:00	\N	086863f5-5162-464d-8399-f3835f80e0c4	0	f	\N
5f1e6040-c9a8-4904-b013-ef95ea0754bd	f	f	2022-01-22 00:00:00	\N	f66694e8-2f3e-492d-b9b4-9a2e5b7066c3	0	f	\N
55d42f0d-2538-4934-96ef-08a6973d28a8	f	f	2022-01-22 00:00:00	\N	2d825100-4593-45a1-b486-2670cb27eb1c	1	f	\N
2b34e952-0e96-4b21-acb7-3909ca15bf36	f	f	2022-01-22 00:00:00	\N	3680433a-ff79-4a68-9715-44563de86317	1	f	\N
40ed7853-4ab7-4ec5-8c76-8234b213f1c2	f	f	2022-01-22 00:00:00	\N	db8ee7df-c8f5-4aec-a78f-72ea750ba251	1	f	\N
c7b16e0c-d58f-453f-87bd-2aa072c4d720	f	f	2022-01-22 00:00:00	\N	7a330c16-06a5-428c-a46d-1b70bdd2ec56	0	f	\N
8d7c3344-1d86-419a-9fc8-cb772b44b053	f	f	2022-01-22 00:00:00	\N	3b2954f5-a0c6-419a-8e5b-0e48dc81f042	0	f	\N
6a117951-ca80-44d0-b363-83982679e70b	f	f	2022-01-23 00:00:00	\N	0aa96d4f-62c3-47e3-8b8f-94809f66f05a	0	f	\N
78a3f485-86a6-4821-be53-4aa2334aa831	f	f	2022-01-23 00:00:00	\N	e2fd5aa9-6922-4c05-8731-b4481a0e30db	0	f	\N
2e8918bc-bc38-420e-be1d-0c78aa3ef6e3	f	f	2022-01-23 00:00:00	\N	9381b75b-ffcf-46c5-9485-3de896616db3	0	f	\N
7b31dfc8-e2fa-4061-8be8-e5ccb99c7845	f	f	2022-02-06 00:00:00	\N	17ed84be-4dcd-4fab-baf8-40c3c422dcc0	0	f	\N
b74db374-8096-4190-ac2e-310b22085b6f	f	f	2022-01-24 00:00:00	\N	5027e4f7-6222-46bc-8972-6e76a136c3bd	1	f	\N
a873f0af-3825-4ab6-a3b7-baa3867bce1f	f	f	2022-01-24 00:00:00	\N	3acca230-7a77-4087-876b-f4fdaeb582e1	0	f	\N
4aac045f-2843-4dc4-a6cb-b178337ac164	f	f	2022-01-25 00:00:00	\N	a8528c10-1ca9-4de5-8c0b-54b4e2702872	0	f	\N
b07ec6bc-6089-49d0-952e-2371d435d639	f	f	2022-01-25 00:00:00	\N	1e1bcb74-bcde-4303-bcec-7902e23a5b77	0	f	\N
7f9e4371-8748-428a-8086-e16eac0f3d86	f	f	2022-01-26 00:00:00	\N	6a37a1d4-593f-425e-8335-a52dcd43391c	0	f	\N
a3be5132-1644-4c26-866c-cb4f872eed77	f	f	2022-01-27 00:00:00	\N	b2736bf3-6d33-439a-906b-d19ed002190b	0	f	\N
117653dc-74a6-41c4-b3cd-23e16f1ec993	f	f	2022-01-27 00:00:00	\N	ca42885f-89a4-4adc-bcda-dacb79920c8e	0	f	\N
1dc074d8-a3ed-4be0-a2cc-36c06635875c	f	f	2022-01-27 00:00:00	\N	ca8a9503-1aa2-4ed2-8dc0-933fbb67d222	0	f	\N
feb0ad38-35ce-4a91-9c38-8a800fce50aa	f	f	2022-01-27 00:00:00	\N	4d82dad7-7c7e-476a-bdb2-7a7a52d7ac6f	1	f	\N
ea0e2ab4-722c-4093-993b-de4ae930cad3	f	f	2022-01-27 00:00:00	\N	d64acad6-ca2f-4c2b-8407-854d9c3ba060	1	f	\N
8ce1e456-6fab-44c0-92b4-3c55bc6ff535	f	f	2022-01-27 00:00:00	\N	925ac1e2-e8e7-4054-bb57-5f54a875ccb0	0	f	\N
71411060-96c1-4947-abe2-e1e4dad875ba	f	f	2022-01-28 00:00:00	\N	5446d58f-3a93-41bc-8018-b792df6f463a	0	f	\N
d5d9dfe1-16aa-45c8-8415-fe66b3f4791f	f	f	2022-01-28 00:00:00	\N	a1ea2681-1d28-4581-b5b3-94fe471976b5	0	f	\N
b59c5523-423f-432a-9af5-803128b90f82	f	f	2022-01-28 00:00:00	\N	e6fecc49-f1aa-42c2-8d13-9a22dd77627d	0	f	\N
4a787979-5165-4ad4-a9b5-b0c9b760cbed	f	f	2022-01-28 00:00:00	\N	7e1bb369-f7fd-4182-8a78-60964391c46d	0	f	\N
05cb103f-33c7-4a60-912e-2cd146996733	f	f	2022-01-28 00:00:00	\N	4190ccc1-1383-488f-946c-cd4bf3f4073c	1	f	\N
1e28f37a-fb5b-41b3-bef2-5e3b54c77e03	f	f	2022-01-28 00:00:00	\N	3ebfa3a6-812c-4d17-bcf2-9a493fcb7798	1	f	\N
ec25b8f6-e2db-47b4-bee6-99589440dc7a	f	f	2022-01-28 00:00:00	\N	b56e5bce-c15c-439a-94dd-988ec063b9fe	1	f	\N
e6a92540-871f-478a-9c34-725e1d43b704	f	f	2022-01-28 00:00:00	\N	22f9861a-28d1-4bdb-8fc8-4f52fb105495	0	f	\N
142d752e-47ba-4992-b700-bd86e29aa9a1	f	f	2022-01-28 00:00:00	\N	f830913d-ad31-40a0-87be-f02e02af340f	0	f	\N
662d5c7e-ff93-4b3f-bc9f-e73098509455	f	f	2022-01-28 00:00:00	\N	eafe70ae-d4f6-4678-93fc-e10d817b0334	0	f	\N
6e405e7e-fbc0-42ad-b00e-37eda73076a8	f	f	2022-01-28 00:00:00	\N	c9189cbd-6a02-40a1-8ab0-12f62fe3ab86	0	f	\N
fd1a3a4d-998a-4076-a5c0-4b8ff3e48bd1	f	f	2022-01-28 00:00:00	\N	47c29583-4a08-4aef-97dd-f999f515aea9	0	f	\N
60757479-15fe-49b9-9b71-ca6ebf8c1484	f	f	2022-01-28 00:00:00	\N	1b74e314-60a0-4d27-8a43-0265b6be2fd5	0	f	\N
2136e0fa-7cef-40e5-bb8d-93317096b081	f	f	2022-01-29 00:00:00	\N	04d35523-c7ce-47cf-bf63-b9f35e991760	0	f	\N
73abcba3-f820-432f-8afd-06d0f9acb239	f	f	2022-01-29 00:00:00	\N	b07891d6-22bb-453c-806c-ddb503bde0c1	1	f	\N
193e5009-17be-4710-83d6-c2c729a51e74	f	f	2022-01-29 00:00:00	\N	0f817251-d3f2-4616-8ae7-5c6a1c67eb0e	1	f	\N
858c1335-8ef9-42ad-ae38-c84a4062bf66	f	f	2022-01-29 00:00:00	\N	4dc2eaaf-22fd-47b3-965b-c50e130cf2bc	0	f	\N
3e7d3ea7-6014-4e50-b22e-3e859147a8ee	f	f	2022-01-29 00:00:00	\N	ccb1b8b9-7393-41ac-81a4-91aee3517aef	0	f	\N
ba22264f-37df-474b-a394-94f75546dd43	f	f	2022-01-29 00:00:00	\N	384f338f-40e3-4330-831e-7a657bff33f8	0	f	\N
e73ecadb-11b7-4709-91aa-a9e5a8d10dc2	f	f	2022-01-29 00:00:00	\N	4d0580dd-a48a-42b4-abdd-85d17500a946	0	f	\N
f42a5925-47af-4d57-a5f4-67a55e9a82b7	f	f	2022-01-29 00:00:00	\N	bc81b02a-b96c-4cd0-99be-7aac90ff269a	0	f	\N
ae8c420f-92f1-47b3-be96-6859ec12a7d3	f	f	2022-01-29 00:00:00	\N	6aa74387-60aa-4e0e-9477-5f4d10d39263	0	f	\N
8932c351-bb01-4da9-96ca-e45b3ec571c3	f	f	2022-01-30 00:00:00	\N	f2b44c2f-7eec-40b8-a7df-0189cefdfb78	0	f	\N
3655bdb1-70cb-4fae-bbcb-85d7a717704c	f	f	2022-01-30 00:00:00	\N	4b6e6eaa-24d4-4cec-9ed0-be4380718b80	1	f	\N
c7e14149-5e49-4a5f-bf37-e7d9767d32e6	f	f	2022-01-30 00:00:00	\N	6b444e83-c271-4879-8b02-367cf035ca96	0	f	\N
9a79a8fc-e478-4736-b119-2df804b6ec22	f	f	2022-01-30 00:00:00	\N	83e5c48e-15ca-442d-afee-668be11d8226	0	f	\N
ad8400aa-5409-4161-a245-407885118514	f	f	2022-01-30 00:00:00	\N	4b382a2d-2d01-491a-8d43-7166a57e3302	0	f	\N
239543ef-de4b-4c88-9f5f-7109cda3297c	f	f	2022-01-30 00:00:00	\N	612da206-6246-4df9-a86e-9f645a6115db	1	f	\N
7f4fd554-63c7-4c17-8411-84d24bd6971b	f	f	2022-01-31 00:00:00	\N	bd872f00-9dea-4026-9711-00439a28b4f4	0	f	\N
4c4c9845-ba3d-4715-abc1-506d42686ce5	f	f	2022-01-31 00:00:00	\N	7d656112-7de1-4c76-80ba-162e24bf4a0a	0	f	\N
c277eb4f-37ae-4b11-867c-5675756a2f29	f	f	2022-01-31 00:00:00	\N	83f8fc6e-1d1b-4d68-aa2c-baf4f4939964	0	f	\N
71f89f96-2ca5-4dfd-9257-643a27e4af56	f	f	2022-01-31 00:00:00	\N	f8cbc6eb-b99a-464a-b9d4-bfb495f70830	0	f	\N
66df5d28-a3d9-4a02-9eab-8d7d10d93e28	f	f	2022-01-31 00:00:00	\N	38b4fe63-43b0-463f-8730-4a5908d0decf	1	f	\N
dbf29cac-3dac-4b53-98ce-79d85b81e743	f	f	2022-01-31 00:00:00	\N	3552e5c0-b13f-4fb2-8a75-ceb6ef4cf677	1	f	\N
316b4b23-7943-472e-9512-58fc92a03023	f	f	2022-01-31 00:00:00	\N	26a9d8c1-3d57-455d-81f1-e25a0fec7c71	1	f	\N
d15dad2e-5df6-4c51-8000-eb3641791718	f	f	2022-02-01 00:00:00	\N	9fe8a226-1f0f-4646-bffd-dc04159e8afd	1	f	\N
ee57b63f-7396-468a-9f60-de48cbd83e0f	f	f	2022-02-01 00:00:00	\N	e49bf978-0b2a-4156-9d23-f360306d442d	1	f	\N
3ec152cd-6dca-4d21-a915-25ca5db72967	f	f	2022-02-01 00:00:00	\N	9910fc55-5bc6-4479-af92-eae7b840f295	0	f	\N
36928f27-08da-49e2-bc17-fa4a17ef9509	f	f	2022-02-01 00:00:00	\N	18102c15-f386-43cd-a84b-86f792e2a3ce	0	f	\N
750e59b8-148a-4f18-bdc3-010a97cda385	f	f	2022-02-01 00:00:00	\N	b22ac014-1a23-4afa-b64c-51d3a5598b40	0	f	\N
0e0b2934-1284-48b8-9b8f-ca77e108e832	f	f	2022-02-01 00:00:00	\N	8bd3e973-5d5a-4f6b-93a2-2c12150667a8	0	f	\N
8f475ece-fa83-4d25-80d8-7acf49bc1695	f	f	2022-02-01 00:00:00	\N	17f95695-7deb-49cb-b14a-f73e44619c78	0	f	\N
da170c3b-3676-479a-aeaa-b7cec94c1f1b	f	f	2022-02-01 00:00:00	\N	77ecdfbf-9452-4404-92c1-fa0841e51591	0	f	\N
0b093ac7-6e25-4bab-aaae-e452371773ab	f	f	2022-02-02 00:00:00	\N	2155cb46-c288-46f7-afa4-6637e6f35b60	0	f	\N
10bc16af-66b4-4e3c-800c-40a42a9d5507	f	f	2022-02-02 00:00:00	\N	1f3938a4-89b5-425d-9e28-497df7df1a28	0	f	\N
128e7321-0737-4920-b4c1-2e9c8d2d0e59	f	f	2022-02-02 00:00:00	\N	5ce1c09e-32cd-4153-811d-283b51f0fb48	0	f	\N
f046d484-deb3-430f-ae6b-07226033604e	f	f	2022-02-02 00:00:00	\N	1fc9ff0c-1fe2-4028-9db8-818b0fce6e4c	0	f	\N
69c7edd8-7d68-4e79-88c7-c5907a712ffc	f	f	2022-02-02 00:00:00	\N	b73c8e58-32a1-4178-9e7d-8b4f472f24e6	0	f	\N
0676b495-b4b1-4457-be3a-4865b462bde6	f	f	2022-02-02 00:00:00	\N	675c7652-6162-4b89-bd73-dccb3ab657dc	0	f	\N
1d7a723d-fd6d-4e41-a889-b611edc669ae	f	f	2022-02-02 00:00:00	\N	bc32d83a-8eb6-42fa-8457-9104fb535a5b	0	f	\N
9dd9c490-6645-431a-b0a9-585054bc3d2c	f	f	2022-02-03 00:00:00	\N	adae4dae-17b4-44cd-8faf-d6a6d6eafb36	0	f	\N
3b596bcf-636f-4b2b-b32d-12715db973db	f	f	2022-02-03 00:00:00	\N	6c83e7f3-684d-41d9-9304-cba6eaee2b80	0	f	\N
fe7f9ee0-7b03-4217-b82c-7e55fd5a68f7	f	f	2022-02-03 00:00:00	\N	f87f0f05-54c6-46e9-b36c-7b00ea92cf2a	0	f	\N
ee4af964-8638-4140-94c9-a6df24132106	f	f	2022-02-03 00:00:00	\N	ac5bbd7b-726e-494b-8144-50035114a9b5	0	f	\N
550e07d0-2c73-4edb-a5a6-f5ca5ea137a7	f	f	2022-02-06 00:00:00	\N	b476230f-9903-47bb-b2ed-20ec9c1cf194	0	f	\N
14463235-281e-4ea0-9358-4d2fa0bbee91	f	f	2022-02-06 00:00:00	\N	8502503a-3bfc-4e21-87b9-dad1b87cdb87	0	f	\N
16adde04-8a5e-4b32-93ac-443322f0f76a	f	f	2022-02-06 00:00:00	\N	fd2e5b8f-2ccf-4f2f-a64b-b667fa2e81d6	0	f	\N
afb25b3d-5212-4cd2-a6db-d4e9003fc938	f	f	2022-02-06 00:00:00	\N	b3388e65-6a0b-41bc-a5e2-ec4a91f604e2	0	f	\N
48b0bdec-4de9-4ce4-8dfe-8f86f79060a6	f	f	2022-02-06 00:00:00	\N	34da2c5f-0c4f-401f-b817-de9ce9f25db7	0	f	\N
bf3dfbdf-5942-4683-af0d-a984d870440c	f	f	2022-02-06 00:00:00	\N	1e7b075f-151f-4b1e-9bbb-93118dbcd972	0	f	\N
3a2ead3a-bf03-4e6e-87d6-3405f931d953	f	f	2022-02-06 00:00:00	\N	7da403e9-57fe-4ce7-84c0-27de44901373	0	f	\N
0b479310-2e29-422d-ac13-5af1133cb775	f	f	2022-02-06 00:00:00	\N	0cfeac7b-b3c0-4e5f-ad0b-b70323591294	0	f	\N
a1c62f0f-1c94-4ee3-8151-c7fcdd5415c7	f	f	2022-02-06 00:00:00	\N	e3f8f50b-53c0-4caa-b2a1-042a86971a01	1	f	\N
b9452e12-ec82-4e27-b5e5-8b189e424557	f	f	2022-02-06 00:00:00	\N	4a78d9be-5fab-4a9a-92cd-9d99a86fcd73	0	f	\N
3b18877c-f520-4b23-a944-eef9bb1bba4f	f	f	2022-02-06 00:00:00	\N	4cd13020-4b58-4685-84c8-f1783f45d361	1	f	\N
f19dd761-47c2-4f4b-a256-c86707b8371f	f	f	2022-02-07 00:00:00	\N	41caa163-7800-48d8-b8a5-30bedc6d861d	0	f	\N
3d075219-eac9-4ea6-8aca-e27cbf829671	f	f	2022-02-06 00:00:00	\N	3646dda9-2cd9-4f0c-afd6-f4ed170f6328	1	f	\N
492130f4-2420-497f-9224-9f4af4f08b27	f	f	2022-02-07 00:00:00	\N	36a9a36f-0208-42ae-b879-eea8ae96d828	0	f	\N
4b87f0dc-a368-43cf-a3b5-25e74433774a	f	f	2022-02-07 00:00:00	\N	e84bd253-96b9-43d4-846d-3894e82f6f02	0	f	\N
8fe75f04-0f0c-4528-86bd-77242f73ea85	f	f	2022-02-07 00:00:00	\N	c1257a79-adcc-48ec-97c0-9cbc900d1fcc	0	f	\N
393d8d2e-1a96-4a0e-b0ac-3e791bd63c62	f	f	2022-02-07 00:00:00	\N	4116f11c-1a40-49aa-81a7-c041f218f8d0	0	f	\N
ba268763-99ac-48c0-940c-78a537d7c94f	f	f	2022-02-07 00:00:00	\N	ae021822-4388-4357-b2be-badd7ad52a12	1	f	\N
2b5576ef-784f-451d-b30e-0735850abc53	f	f	2022-02-07 00:00:00	\N	5d832eec-7910-4153-8955-691938064e0d	0	f	\N
8df88300-cb14-47a4-b561-36052ca6b964	f	f	2022-02-07 00:00:00	\N	49e092ce-b1dd-42af-a38a-b569212485d9	0	f	\N
6ac081ca-9695-4790-8dcd-926a40c835bc	f	f	2022-02-07 00:00:00	\N	6be7499e-9c16-45e1-8741-aac41b19835c	0	f	\N
db0900f1-ae60-457d-a9f2-3e3c07afa7ba	f	f	2022-02-08 00:00:00	\N	68d1b8e8-28fb-4824-a2a9-1272b22749ca	0	f	\N
200227f5-e8c4-45f2-a74e-6b35e5fd064b	f	f	2022-02-08 00:00:00	\N	cc4ce5c0-10db-4043-b4b3-2ce0f5c411c9	0	f	\N
0f7fddd3-2ef0-400e-bf90-416039022cc9	f	f	2022-02-08 00:00:00	\N	4cc265ad-9660-46bf-9a65-f388d84d1e66	0	f	\N
03d8dc57-4c6e-42d7-b6c9-7d3e1ab1a9a9	f	f	2022-02-08 00:00:00	\N	06c4b10e-5d4c-4dbc-8f60-979d116905c3	0	f	\N
5a23cf40-33ab-4e32-a435-5375b1ce2e83	f	f	2022-02-08 00:00:00	\N	b544819d-de0b-4a87-ac1b-f6aeaa6b9a35	0	f	\N
d4a96803-1fc6-43c9-add2-a68f1efdfbc5	f	f	2022-02-08 00:00:00	\N	212abe50-e318-4160-b8b3-6a73b90e7db3	0	f	\N
a0cbdcaf-d276-4f65-b9fa-392068dee982	f	f	2022-02-09 00:00:00	\N	ab740e36-07ac-471c-8a8d-42b004bf2264	0	f	\N
ef6f220f-027a-42fb-a5d3-0e67b8c69339	f	f	2022-02-09 00:00:00	\N	18f9b3d2-e879-4158-8c00-389eae8ef91d	0	f	\N
7bb3a2b5-da0b-4490-ac52-01ca29d1fdf1	f	f	2022-02-09 00:00:00	\N	f5e10ce9-2d10-4d8e-8dcf-a96768fa99ea	1	f	\N
7e2c7fe7-bb24-45d2-a879-e57c2a496e12	f	f	2022-02-09 00:00:00	\N	d734e36d-7232-448e-91c5-55fad3c1eee4	0	f	\N
c1b65e88-82f3-4e89-a7dd-9ddecd594317	f	f	2022-02-09 00:00:00	\N	9a3ee8f2-8195-4557-8648-26f45f3bb029	0	f	\N
c41b7b4d-0153-407b-a660-1fec5cd28603	f	f	2022-02-09 00:00:00	\N	3e91824b-6148-4d3d-b1f8-d0cd67755424	0	f	\N
dda39ab6-2d01-4c52-a189-29fe8bbd2ed2	f	f	2022-02-09 00:00:00	\N	387da566-0489-4a69-afad-5e392ace964c	0	f	\N
a160e28d-a1d7-4a80-806c-6eb8cd7ca3c1	f	f	2022-02-09 00:00:00	\N	cc500728-7e8e-4266-a2ea-3b21f26a314a	0	f	\N
ec2cbb42-db37-4282-9a02-daf8b684ea2d	f	f	2022-02-10 00:00:00	\N	5412961e-cf30-44ea-b9a0-7679e5306204	0	f	\N
7396bc3d-0b5b-445e-adc9-042728f4a7a7	f	f	2022-02-10 00:00:00	\N	1a5f4d6f-76de-42e3-9ad5-0356eee2509c	0	f	\N
8341a3ae-dffd-455b-9ce4-d49583315aa5	f	f	2022-02-11 00:00:00	\N	9fd52c08-46a8-4c08-a6e7-4ee7f4995d9d	1	f	\N
824683f9-9378-4551-a4eb-2404e5b5d128	f	f	2022-02-11 00:00:00	\N	0adbd46d-ce5d-4575-9c3b-1d20aab14b6d	0	f	\N
3857efdb-e6ac-4158-b7e9-6346790a8abb	f	f	2022-02-11 00:00:00	\N	55debbc1-6e33-4b45-ac93-961f5ce31f33	0	f	\N
7a373760-da4e-46a5-bf96-fee837cf4354	f	f	2022-02-11 00:00:00	\N	f1f88d14-f3d3-4419-800c-c6bb144fd1fb	0	f	\N
d97f5666-a7bd-4338-86b8-6313e9cfff19	f	f	2022-02-11 00:00:00	\N	fcd78ddb-4d5d-4fad-9442-32f1f501aca2	0	f	\N
f53604b7-7877-4fd0-a695-ad3f6fa6f2a3	f	f	2022-02-11 00:00:00	\N	122aa0eb-e096-45da-b679-cafebbcd1048	0	f	\N
fd8e0ac4-0e95-40da-8701-65b4aecbaaa2	f	f	2022-02-11 00:00:00	\N	511a53ef-0a61-4e03-98eb-ee55f3310a59	0	f	\N
d4823f02-6cb8-4537-96ec-d3cc41b4ded6	f	f	2022-02-12 00:00:00	\N	5d3667e0-681a-4040-b96e-7de551c5c3f4	1	f	\N
a37163d3-5148-44b3-814c-9c3d316517ed	f	f	2022-02-12 00:00:00	\N	6a3387a9-4f35-4c62-989e-077b9e1366ef	0	f	\N
4146c7d7-c2f3-4938-bca9-da5f275c2208	f	f	2022-02-12 00:00:00	\N	edd3f015-0bb7-45fe-bccf-a0f63fb97557	0	f	\N
5082bf2b-7675-46d7-afc7-20585facdeeb	f	f	2022-02-12 00:00:00	\N	57617f49-78df-46d7-bdd8-a9524b4cbe81	0	f	\N
2bd268ae-226f-43a4-9366-c813abfbcf52	f	f	2022-02-12 00:00:00	\N	1ebef21a-14dd-4b2d-969a-e8e2804fb8d1	0	f	\N
b8920606-0845-4404-ba4c-134ebee1d855	f	f	2022-02-12 00:00:00	\N	2860c43b-b4f9-4c1f-88ab-584f78c212a1	0	f	\N
6e1e5b31-6794-4474-92c4-ff47dfe61bab	f	f	2022-02-12 00:00:00	\N	23c00e1a-a9da-4f1e-a143-949e85b7a153	0	f	\N
e9b0771e-9e48-4c85-b459-cf46a02fe422	f	f	2022-02-13 00:00:00	\N	0eb8b85b-e34e-40a5-a5f8-5eec70082ab5	0	f	\N
fb1ba90d-9563-48c9-9b06-8b05f0a084fc	f	f	2022-02-13 00:00:00	\N	7f9a3ac4-e86b-4d51-bd2e-2a09ad93fe8a	1	f	\N
d40a1c0d-397e-4861-8353-dd687520cbea	f	f	2022-02-13 00:00:00	\N	0619ee4d-c9e3-484d-9bf0-949c6a02a2f2	0	f	\N
cf823f0d-bfb3-482b-a076-7a426262ee07	f	f	2022-02-13 00:00:00	\N	01a7df2f-6a9e-41db-a75e-71f30171f44b	0	f	\N
ebe1b1f1-6d7f-4f7e-826f-a5e30d7f7de0	f	f	2022-02-13 00:00:00	\N	5c5f951c-ba41-40f2-893c-18f00900313a	0	f	\N
79b9af1a-abd5-4642-a810-008b28e524f8	f	f	2022-02-13 00:00:00	\N	d426b797-6389-4b27-a696-69e1a231abb3	0	f	\N
32779ba6-424f-4720-8b3d-fca004c121aa	f	f	2022-02-13 00:00:00	\N	2444be84-b6d3-4cab-bfbb-3b95432db6a0	1	f	\N
39dcbf9e-287e-4e49-85aa-a00a202cfb75	f	f	2022-02-13 00:00:00	\N	5f443dae-ef08-40fc-ba1c-46a4ebd4951d	1	f	\N
028e3c72-140c-49f0-9c14-4f42d74dce3e	f	f	2022-02-13 00:00:00	\N	2aa32e66-2896-465a-9e71-df92dbcbca3e	0	f	\N
906457ab-370f-49a0-9ebe-d472f1c5979f	f	f	2022-02-13 00:00:00	\N	226281fb-6ea8-4920-a507-93f7370bfe50	0	f	\N
dc395047-00b3-435f-a0b8-4360388c25d4	f	f	2022-02-14 00:00:00	\N	a0b2aeeb-9488-48c9-8763-5879c9852478	1	f	\N
1af6dd67-67a0-44e2-accd-5ac8d10facaf	f	f	2022-02-14 00:00:00	\N	9eae4f57-ddac-436e-8c44-0861545cefe5	1	f	\N
d4462bf5-69ab-4957-935b-037a9daa05b3	f	f	2022-02-14 00:00:00	\N	cf04baca-a6ab-4fa6-93fe-c8037aed6416	0	f	\N
60703f75-9b43-4535-967d-9ea2b5775964	f	f	2022-02-14 00:00:00	\N	fb74aa81-9b33-44c6-a77f-c961179f8814	1	f	\N
344e9477-4618-4142-b09d-39a29ade4bd5	f	f	2022-02-14 00:00:00	\N	c20621d6-69c7-403b-98af-658229c9c45d	1	f	\N
5715058a-849e-4e15-931d-27019ef12042	f	f	2022-02-14 00:00:00	\N	6ea71f63-2e65-4d5e-8ea2-cda595777d49	0	f	\N
\.


--
-- Data for Name: wertungsrichter_einsatz; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wertungsrichter_einsatz (id, aktiv, deleted, change_date, deletion_date, person_anlass_link_id, wertungsrichter_slot_id, eingesetzt) FROM stdin;
418060ca-90a9-4adf-9b49-3a6d4b706fc4	t	f	2022-01-11 00:00:00	\N	df2af5c4-ed32-4abe-bd5e-a90fa6c7fb25	d179758b-c473-41bd-9aa9-c037675cca6f	t
3ec8821f-85e4-46d4-b1c0-0607a46999ee	t	f	2022-01-11 00:00:00	\N	8fa93f6c-13a3-4e5a-8608-eccf7ff7b3d4	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
ec53c94c-a05a-4623-b53f-89603b2765e7	t	f	2022-01-12 00:00:00	\N	00df8ae0-b2f5-49f3-9c6b-4f5a36a88de3	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	f
98475d01-44cc-4267-b30b-dc0c9b920308	t	f	2022-01-12 00:00:00	\N	a08b4818-7a3f-4382-8aba-822dc28f9aae	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	f
d6e2c450-d1c7-42eb-99c4-942b91473401	t	f	2022-01-24 00:00:00	\N	18e6085e-c262-4b5d-8c90-456a2fede68b	d179758b-c473-41bd-9aa9-c037675cca6f	t
ef0050db-246e-41d8-8ee1-4d5098114969	t	f	2022-01-12 00:00:00	\N	2eab4d09-f770-44b4-9052-747a8337f73b	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	f
571d005e-a345-4e7f-814d-d49a2a6d221f	t	f	2022-01-14 00:00:00	\N	1e7cbb9c-cefa-40a1-8f6d-539c0d290fbe	d179758b-c473-41bd-9aa9-c037675cca6f	t
c3bf168a-61f7-4ffd-b645-b71701a9a7d7	t	f	2022-01-14 00:00:00	\N	c900dd97-44ce-431b-933e-da667ea43ae9	d179758b-c473-41bd-9aa9-c037675cca6f	t
cadfda32-407b-4103-96a4-ca0b1ea41f5c	t	f	2022-01-17 00:00:00	\N	4350eb78-23aa-4bb6-b207-e198b6e9930b	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
640e34fe-e3ab-4ec1-b816-4c68d7906e4c	t	f	2022-01-17 00:00:00	\N	8aa67420-fb13-4efa-afca-561806727eb1	d179758b-c473-41bd-9aa9-c037675cca6f	t
c3d0d82d-58a4-4fdd-b29a-f04178967b2b	t	f	2022-02-01 00:00:00	\N	b6daec27-1750-405c-8a84-b4a8e88d25ea	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
dff2e954-333f-48ba-afc9-9549548cb626	t	f	2022-02-01 00:00:00	\N	4785cff0-bf47-4cfd-814a-bc5377f4f1d0	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
63ad659c-0235-47fc-9ee1-47c76a2ea74a	t	f	2022-02-02 00:00:00	\N	861cf626-9f0d-487b-9c88-efad58d61deb	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
e336d04b-8678-4029-9837-d4967045277f	t	f	2022-01-17 00:00:00	\N	72b0edf2-9636-4045-9cf2-2016e6582d7b	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
cbd3d8a2-79bc-4ede-83e3-5d0a84e2963b	t	f	2022-01-25 00:00:00	\N	139bda20-16a4-44ef-b6d9-242b83b346e9	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	f
22161a97-0dfd-4214-9ac6-0aa69dd03b79	t	f	2022-01-25 00:00:00	\N	091896fb-bb72-4931-a2cf-f1c0180ea1a6	d179758b-c473-41bd-9aa9-c037675cca6f	f
c08adb50-d9d0-46dc-b618-4c1a1c413645	t	f	2022-01-17 00:00:00	\N	d75592e7-1a88-4a5a-8cd4-3b634d35d9b5	d179758b-c473-41bd-9aa9-c037675cca6f	t
361e1104-a794-4ce5-a57b-496e9e2095ff	t	f	2022-01-25 00:00:00	\N	f83ba5fb-3b88-4f53-ba0d-72651fbb6bf2	d179758b-c473-41bd-9aa9-c037675cca6f	f
4628ac54-8231-4e68-b204-a335f3dcd983	t	f	2022-02-02 00:00:00	\N	342b8bfd-d1a6-4635-a2b7-6f772285822e	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
5f73e10e-d4fd-4c18-8d3c-b2c67b91b6e1	t	f	2022-02-02 00:00:00	\N	e45fda16-56f1-4e70-8933-4d7e8dfa57a5	d179758b-c473-41bd-9aa9-c037675cca6f	f
77e4bed3-37e9-429d-af3f-edcee61b4b56	t	f	2022-01-18 00:00:00	\N	6ac5fdf0-3503-4cbe-981e-cd39b38bf19c	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
4762439b-974f-4077-a1b6-ffdfd9d92867	t	f	2022-01-18 00:00:00	\N	6adc9680-cd78-45b3-b197-59f403ec1d8f	d179758b-c473-41bd-9aa9-c037675cca6f	t
0a2796b4-d7c3-4484-aa54-e03045ac91a4	t	f	2022-01-18 00:00:00	\N	21065ca4-fb26-45c8-9e4a-6dd3b3c9840e	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	f
f82e1962-f229-4640-b057-2f4c22cd378d	t	f	2022-01-19 00:00:00	\N	ca7098f4-74b7-468c-a84c-b54fdd5ae7a0	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
66af23a7-bf99-4eb4-9af4-23e1f54fce63	t	f	2022-01-19 00:00:00	\N	1cf6483c-4981-41fb-be23-79e8c6a905ee	d179758b-c473-41bd-9aa9-c037675cca6f	t
3fd03507-436d-449f-9c4c-91dfa456c2b5	t	f	2022-02-03 00:00:00	\N	c4ff8233-aed9-44a3-8765-dc2bb399d897	d179758b-c473-41bd-9aa9-c037675cca6f	t
265ce904-e9ce-4f49-87b0-d923d54ca377	t	f	2022-01-27 00:00:00	\N	ded825f7-c72c-4a66-ba66-0a7a7d065b27	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
686f78d0-f46e-40be-9b52-13a4de1e9afb	t	f	2022-01-28 00:00:00	\N	c244b702-d772-4df9-8624-923835db1e62	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	f
ddc7b0eb-1471-4ef0-a5c0-8419e7bfeff2	t	f	2022-01-20 00:00:00	\N	aa1bc32c-26c8-42da-b758-e8e4b96b418c	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
0a93b7b5-c3e0-474b-8583-99b887d94826	t	f	2022-01-20 00:00:00	\N	a5871e75-be77-4a74-abf5-769ad475034f	d179758b-c473-41bd-9aa9-c037675cca6f	t
1ee0659d-b9c7-4aa5-a128-7cc227b46afc	t	f	2022-01-28 00:00:00	\N	07339662-3fb8-4def-ad79-ee1b90117609	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
59537a24-1e15-4c02-b906-061d1ae43864	t	f	2022-01-20 00:00:00	\N	1b09a2b6-608d-4cad-9c90-afc571719ec9	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
cef95c7c-935a-47ce-acf2-05ed14d4a391	t	f	2022-01-22 00:00:00	\N	4740cbad-b322-4404-bfcf-15a610a8eb28	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
636ea3f9-660a-413e-b138-00fcc728d0b1	t	f	2022-01-22 00:00:00	\N	ac2e21a4-71b3-41cb-b58c-934e4b2ed379	d179758b-c473-41bd-9aa9-c037675cca6f	t
c43fdd3a-b6b1-4ec6-ad74-22ee61255d98	t	f	2022-01-22 00:00:00	\N	502e5d08-99d0-4c02-ba3a-97d9b32573d7	d179758b-c473-41bd-9aa9-c037675cca6f	t
0773e443-c4f6-46f5-a3fa-152a8baa35a4	t	f	2022-01-22 00:00:00	\N	74cf6023-1f50-4311-86df-ef3a4d39dd6f	d179758b-c473-41bd-9aa9-c037675cca6f	t
42201d71-76a4-459f-aacc-9e22525f1d64	t	f	2022-01-22 00:00:00	\N	3ef17816-a379-409a-82a6-72e27cc1c27d	d179758b-c473-41bd-9aa9-c037675cca6f	t
d83ab60d-64c5-41fc-a717-897bf99d8878	t	f	2022-01-22 00:00:00	\N	502d0064-4c0b-48e0-b65d-5c7fd8e98743	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
726452d0-7048-4b25-9a37-7d335f647023	t	f	2022-01-23 00:00:00	\N	03651ead-49ea-44db-ae99-b2a6662395d8	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
b1162234-31f7-45f5-94df-40b7294d4d65	t	f	2022-01-24 00:00:00	\N	308d445a-e60a-49ab-a2d5-b59678b39f26	d179758b-c473-41bd-9aa9-c037675cca6f	f
8680b151-b16e-4ad4-9746-9b1f47bf19cc	t	f	2022-01-24 00:00:00	\N	b0afc728-896d-48c2-af8f-9d168ea1fa41	d179758b-c473-41bd-9aa9-c037675cca6f	t
69a82847-3e66-46de-b146-2df3a1d27830	t	f	2022-01-24 00:00:00	\N	8c890fc1-d923-475a-9ab3-e4f0da2ae141	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
31338cff-bb97-41cb-a17b-5fcd48760d68	t	f	2022-02-02 00:00:00	\N	561632c8-b56f-4a27-9774-9fac105f2eee	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	f
b206f77d-c285-4f2a-a87e-90641d83f2f6	t	f	2022-01-29 00:00:00	\N	7f2ca847-a39f-4ae8-b9b2-f20f5094d4f0	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
2b167383-6059-4b55-b6eb-577208fd4ddc	t	f	2022-01-29 00:00:00	\N	756d6695-f5d1-4d02-9380-bf0493c52177	d179758b-c473-41bd-9aa9-c037675cca6f	t
bd9097b8-b289-414e-96e3-8b0144771ab5	t	f	2022-01-29 00:00:00	\N	17f7ed34-d962-4748-a531-fbc92ed61244	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
2cccd6a8-0833-48a7-8673-3738dca35719	t	f	2022-01-29 00:00:00	\N	583d881a-f4cc-4db8-9555-81b04b9fde4e	d179758b-c473-41bd-9aa9-c037675cca6f	t
81dc109a-a521-4cac-a78a-4b752ce0d785	t	f	2022-01-29 00:00:00	\N	735b3b2e-2cf3-4090-befe-e41b0b983933	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	f
606d4e31-1a10-4891-bcc1-a511aac8c34c	t	f	2022-01-29 00:00:00	\N	cdd574c4-d259-431a-aa73-e64178cfed2e	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
92ebdebc-ad9e-42a3-b685-8dad6af1156a	t	f	2022-01-30 00:00:00	\N	91837aad-3d46-4a4e-9e60-2fa73c57cc24	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
096ce61e-3c92-4372-8ffe-5959fe28f811	t	f	2022-01-30 00:00:00	\N	0e5afa35-fc54-49c6-b28a-4f8b7aeac138	d179758b-c473-41bd-9aa9-c037675cca6f	f
19c448b2-1af2-4137-836b-07c177f9c2e9	t	f	2022-02-01 00:00:00	\N	d4d894dd-487a-4dd6-a42a-d790dba7483e	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
218e7863-f8bb-4e85-a5ba-25579c384db9	t	f	2022-02-01 00:00:00	\N	f6061ea9-4e92-4e02-9184-f0eeb96ad42c	d179758b-c473-41bd-9aa9-c037675cca6f	t
377263c9-06db-481c-a760-8a39b99b47d7	t	f	2022-02-01 00:00:00	\N	a27139ec-85cf-4367-94f8-bcbc11dd8593	d179758b-c473-41bd-9aa9-c037675cca6f	t
0c2f9938-1077-4d1c-b47e-681df49f2cc1	t	f	2022-02-01 00:00:00	\N	6957a7c9-506a-40cb-90d0-18533f20145a	d179758b-c473-41bd-9aa9-c037675cca6f	f
725d5858-5658-4764-ac00-ecc8a38e3574	t	f	2022-02-02 00:00:00	\N	e04ecddc-65ba-42e9-b882-c3543a9c994d	d179758b-c473-41bd-9aa9-c037675cca6f	f
a44982cb-0ffd-4ce6-9371-47b36dff3333	t	f	2022-02-02 00:00:00	\N	987efc3a-e379-4764-8e91-245e3ba21808	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	f
de3b00b2-89bf-4665-9c11-1bd4bad33816	t	f	2022-02-02 00:00:00	\N	9d361e48-8d67-41b4-9ab0-e3f17e0c531c	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
133a9fb9-b6a0-42b5-b0c2-053da484c74e	t	f	2022-02-02 00:00:00	\N	1bd5f626-d4dc-445c-9b5e-e6a745797199	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
f9e7b66c-bb7a-4fb9-b8d9-d02bd6430640	t	f	2022-02-02 00:00:00	\N	094335ff-85c5-4c62-9be9-858789db39a0	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
899870aa-dabb-47db-a2f2-2a4b6468269b	t	f	2022-02-02 00:00:00	\N	c0928f93-bb0d-4590-88a6-46f1dfa363cb	d179758b-c473-41bd-9aa9-c037675cca6f	t
8865d060-ad0f-459b-93e3-4eaf45e2ffeb	t	f	2022-02-02 00:00:00	\N	6f2d81df-da72-4d60-8d11-2a5769da8652	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
ebb5486f-6c47-4b11-b0b0-0ab675f04316	t	f	2022-02-02 00:00:00	\N	bbde1f7a-8396-4a4a-953a-da2787e34319	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	f
35a73ebf-2278-4dfe-80ea-fcedcd2cc8fd	t	f	2022-02-03 00:00:00	\N	cc77dde9-ad1f-4788-9053-fe9e3097162c	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
29adb306-72fd-4bfd-b46a-1a662f8c7056	t	f	2022-02-03 00:00:00	\N	9f862e74-a27d-4120-9fcb-e461bbcdbdfe	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
16633498-1033-4cce-a196-e4831b0f1246	t	f	2022-02-03 00:00:00	\N	08bd781f-d378-4420-b5df-b8b9140d20f7	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
5c82a143-3700-429a-be82-65bc15481495	t	f	2022-02-03 00:00:00	\N	03f8a121-3b11-437f-959a-09c0dc1bfe5e	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
e9b2a7f1-2268-4491-84d2-cb2ce78763c4	t	f	2022-02-05 00:00:00	\N	54690c94-7f17-4d51-b4a9-f54a6d86cdba	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
25f19793-55bb-475a-9f70-f0f7ca234a76	t	f	2022-02-05 00:00:00	\N	5cc34de9-9d83-40a6-af19-e536328ae092	d179758b-c473-41bd-9aa9-c037675cca6f	t
cf816c2a-ab27-4cc2-b50d-d3a3891ec417	t	f	2022-02-05 00:00:00	\N	035abe47-ddf0-47fc-b6de-89a79bb89aaf	d179758b-c473-41bd-9aa9-c037675cca6f	t
bb25968c-88ee-44dc-a72b-0691ace93c7d	t	f	2022-02-05 00:00:00	\N	ef93cce1-26ee-4d55-a73b-5b16e18fcb17	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
84673967-d26b-4d3d-b0d7-c16cb3cbfa5b	t	f	2022-02-05 00:00:00	\N	ff253a7d-494b-4cce-a2bf-59d43e53da77	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
8ae24437-9215-46de-89a5-c26f977e5a77	t	f	2022-02-06 00:00:00	\N	ba7dee62-b70d-4470-928a-9fcecc81dc76	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
9a900679-0491-4ae6-b179-c9252a67ed26	t	f	2022-02-06 00:00:00	\N	ba7dee62-b70d-4470-928a-9fcecc81dc76	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
179f4681-46e5-4180-a88d-cdcff7107ac8	t	f	2022-02-06 00:00:00	\N	ba7dee62-b70d-4470-928a-9fcecc81dc76	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
2e7b567d-298a-4b43-8790-9fb99a59de3c	t	f	2022-02-06 00:00:00	\N	ba7dee62-b70d-4470-928a-9fcecc81dc76	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
81a187ae-bdcb-463b-aa93-71e0014d078d	t	f	2022-02-06 00:00:00	\N	adfe5ded-8fb3-432e-bfac-862ed7f4cd82	1217e214-ddd3-4552-921d-0f1f38ce560c	f
f29df18a-bb1d-439d-8db0-5d4cc1ae6016	t	f	2022-02-06 00:00:00	\N	adfe5ded-8fb3-432e-bfac-862ed7f4cd82	f6d18808-a19f-495a-8f33-adb4a75870da	f
8025dda4-4e18-4298-b7cf-da36589e5e4c	t	f	2022-02-06 00:00:00	\N	adfe5ded-8fb3-432e-bfac-862ed7f4cd82	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	f
437b4076-80f5-4ff5-87c2-5228bc381751	t	f	2022-02-06 00:00:00	\N	adfe5ded-8fb3-432e-bfac-862ed7f4cd82	c7fbf668-d15a-49f4-994b-f04374e78d4a	f
ba118c67-9569-4443-a6ac-1066a7922019	t	f	2022-02-06 00:00:00	\N	01c1be1a-87c7-40b3-8068-983dab3280ee	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
ffb1a84d-a4c2-413d-afb2-af34c6994a52	t	f	2022-02-07 00:00:00	\N	69aaf7c0-c447-494e-8627-5f6882a82f5a	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	f
7a759efc-eb79-4c71-a2d0-5cecd1829c88	t	f	2022-02-06 00:00:00	\N	01c1be1a-87c7-40b3-8068-983dab3280ee	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
c0cc95ff-fe50-41e0-8f4e-1f2884e7face	t	f	2022-02-07 00:00:00	\N	3c9c0d0f-9f01-4e6d-b463-d8bffd400dd1	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
92259d4f-d4f0-46b4-9f36-6ea9359f953e	t	f	2022-02-06 00:00:00	\N	f632f62b-0b42-4a70-b6d7-e1cdee77a5d0	c7fbf668-d15a-49f4-994b-f04374e78d4a	f
b8404a19-2cf8-43b3-b64a-1db3ec79511b	t	f	2022-02-06 00:00:00	\N	f632f62b-0b42-4a70-b6d7-e1cdee77a5d0	1217e214-ddd3-4552-921d-0f1f38ce560c	t
2a4e66d8-d7a1-4cec-987e-b8ae8c4b367a	t	f	2022-02-07 00:00:00	\N	3c9c0d0f-9f01-4e6d-b463-d8bffd400dd1	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
7ddf71c6-0fcd-4e73-8d62-1c21920e9755	t	f	2022-02-06 00:00:00	\N	01c1be1a-87c7-40b3-8068-983dab3280ee	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
1284b159-952f-4b23-ad27-f6e2a5a7286c	t	f	2022-02-07 00:00:00	\N	3c9c0d0f-9f01-4e6d-b463-d8bffd400dd1	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
268acbd9-cf56-465a-9cbc-28ddc9a89ecc	t	f	2022-02-06 00:00:00	\N	f0828c9d-1d04-4835-9a29-de70c9e75d8a	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	f
7d4052ce-b40d-4735-95a1-d474d9d0e7a2	t	f	2022-02-07 00:00:00	\N	1f43623a-54eb-4ad8-b9e1-7e37d7bd1187	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	f
869c5cc9-3078-46bc-9619-40117784db9d	t	f	2022-02-07 00:00:00	\N	da4ffb67-c126-4576-a4c0-d0b355a5541f	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
53300e4e-f2b4-40f8-bdab-f1f0f855f969	t	f	2022-02-07 00:00:00	\N	d0f09620-f1bf-4ca1-b5e4-8269641903d4	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
3f8a8461-a95a-4ce2-9f7b-73267918386f	t	f	2022-02-07 00:00:00	\N	d0f09620-f1bf-4ca1-b5e4-8269641903d4	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
c7043b2e-2aba-4529-bddc-842e327a266f	t	f	2022-02-07 00:00:00	\N	d0f09620-f1bf-4ca1-b5e4-8269641903d4	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
4ced89c1-a9d4-4087-acda-2826d0ceeabd	t	f	2022-02-07 00:00:00	\N	d0f09620-f1bf-4ca1-b5e4-8269641903d4	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
2964fa09-b0a3-4184-8be5-a090ae30def1	t	f	2022-02-07 00:00:00	\N	4e7af4bc-a901-4c10-b7c7-d79699e0f3c9	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
97706dfe-f829-4b2e-b4c3-c74f2c3991f1	t	f	2022-02-07 00:00:00	\N	4e7af4bc-a901-4c10-b7c7-d79699e0f3c9	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
f44fcc21-a468-4481-9775-33579be90920	t	f	2022-02-07 00:00:00	\N	4e7af4bc-a901-4c10-b7c7-d79699e0f3c9	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
8ea0c34b-4f96-4261-9dd0-b434db66cb67	t	f	2022-02-07 00:00:00	\N	4e7af4bc-a901-4c10-b7c7-d79699e0f3c9	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
ffd345a3-2218-418e-8e28-c258a7a89d88	t	f	2022-02-07 00:00:00	\N	aed8de45-a7df-488e-bcb5-30ccfb8e5261	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
113b3be9-4366-493c-8ccc-32635ca0ef9c	t	f	2022-02-07 00:00:00	\N	aed8de45-a7df-488e-bcb5-30ccfb8e5261	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
cf63c090-cbb3-40ad-8eff-f8e11d57174d	t	f	2022-02-07 00:00:00	\N	aed8de45-a7df-488e-bcb5-30ccfb8e5261	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
6e0ef419-ca82-4d93-8016-b3004cc493e7	t	f	2022-02-07 00:00:00	\N	aed8de45-a7df-488e-bcb5-30ccfb8e5261	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
cfa3b2b6-f164-4f31-81d1-ea3651b7acaf	t	f	2022-02-07 00:00:00	\N	9ad061a0-35cd-486c-92ac-0fabbff8433c	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
d9562a76-62d2-49cc-a918-a7ad2b4ddc5a	t	f	2022-02-07 00:00:00	\N	9ad061a0-35cd-486c-92ac-0fabbff8433c	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
af4b6c79-2850-40a9-8cc6-0a8bd9765120	t	f	2022-02-07 00:00:00	\N	9ad061a0-35cd-486c-92ac-0fabbff8433c	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
45f16e92-f1d0-411e-9e80-a945810ae0ee	t	f	2022-02-07 00:00:00	\N	9ad061a0-35cd-486c-92ac-0fabbff8433c	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
bc746829-eb5d-4370-ab8e-f6e6582b0222	t	f	2022-02-07 00:00:00	\N	cc904f6e-9751-4ff3-9966-a528eabf6202	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
bcca1132-1bca-471b-ae2b-5bfbac722126	t	f	2022-02-06 00:00:00	\N	f632f62b-0b42-4a70-b6d7-e1cdee77a5d0	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	f
45f1b629-08e4-4293-8800-1b589cdf01dd	t	f	2022-02-06 00:00:00	\N	01c1be1a-87c7-40b3-8068-983dab3280ee	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
2c52323c-4876-44be-8f44-acc9499d869f	t	f	2022-02-07 00:00:00	\N	1dcd4104-82e4-4c7b-b86d-235d721c5d6e	1217e214-ddd3-4552-921d-0f1f38ce560c	t
f7b2763e-7031-4298-a7af-bff5dc82ec39	t	f	2022-02-07 00:00:00	\N	1dcd4104-82e4-4c7b-b86d-235d721c5d6e	f6d18808-a19f-495a-8f33-adb4a75870da	t
95fb4cf6-278d-4d78-bc36-cd17a23a207f	t	f	2022-02-07 00:00:00	\N	1dcd4104-82e4-4c7b-b86d-235d721c5d6e	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	t
f282a1cc-0e36-44da-802e-3835f0531fcb	t	f	2022-02-07 00:00:00	\N	1dcd4104-82e4-4c7b-b86d-235d721c5d6e	c7fbf668-d15a-49f4-994b-f04374e78d4a	t
abe79fed-ec9e-4242-af25-74bd95ca1782	t	f	2022-02-07 00:00:00	\N	5e2e1708-1e99-46b4-a73f-80de6b12373d	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
8cbde808-fb33-4561-9a70-20e98c1d6cee	t	f	2022-02-07 00:00:00	\N	5791231f-242e-4d58-bbb3-c76017c8196d	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
7d20f2b2-79a7-419e-83eb-017a10619a93	t	f	2022-02-07 00:00:00	\N	69573f3c-1559-4b4f-aca9-5cd034f9489c	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
1518c528-9814-4cab-92bc-d73833927eca	t	f	2022-02-07 00:00:00	\N	69573f3c-1559-4b4f-aca9-5cd034f9489c	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
0ee93b90-63ff-45dc-abdc-2ff1fc61c564	t	f	2022-02-07 00:00:00	\N	69573f3c-1559-4b4f-aca9-5cd034f9489c	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
a68b5150-186e-4b68-b2d0-aae129bbe10e	t	f	2022-02-08 00:00:00	\N	22e579cb-18bd-4950-8213-aefedf8301e7	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	f
b8b3e8e3-3fba-46bf-a2bf-ef545d71b211	t	f	2022-02-07 00:00:00	\N	69573f3c-1559-4b4f-aca9-5cd034f9489c	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
3b24253d-a9fe-4213-9faf-b1e80b19a276	t	f	2022-02-07 00:00:00	\N	3c9c0d0f-9f01-4e6d-b463-d8bffd400dd1	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
30aef304-0647-48be-9d68-9748311f4e19	t	f	2022-02-07 00:00:00	\N	247a6558-8647-4d7e-a4cb-71176148785d	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	f
8f385531-d697-4e33-ad35-30ff0d03ac66	t	f	2022-02-07 00:00:00	\N	247a6558-8647-4d7e-a4cb-71176148785d	c7fbf668-d15a-49f4-994b-f04374e78d4a	f
837db4d2-c9fc-45d7-a963-08247b8cd051	t	f	2022-02-07 00:00:00	\N	247a6558-8647-4d7e-a4cb-71176148785d	1217e214-ddd3-4552-921d-0f1f38ce560c	t
28bf221b-fc82-4b88-a10f-71ec33444a30	t	f	2022-02-07 00:00:00	\N	247a6558-8647-4d7e-a4cb-71176148785d	f6d18808-a19f-495a-8f33-adb4a75870da	t
8c192cb5-4d08-4f3f-bf30-67ab5f3a3fd8	t	f	2022-02-08 00:00:00	\N	22e579cb-18bd-4950-8213-aefedf8301e7	c7fbf668-d15a-49f4-994b-f04374e78d4a	f
3ef3521b-9452-467a-9331-31f6643daa85	t	f	2022-02-07 00:00:00	\N	1b66b383-edd3-4339-9d69-b513d94b0013	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
dbee8cf3-3359-4715-ad75-182660640eab	t	f	2022-02-07 00:00:00	\N	1b66b383-edd3-4339-9d69-b513d94b0013	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
0a1c4778-9848-4cc3-b9a2-b5080b753dd0	t	f	2022-02-07 00:00:00	\N	1b66b383-edd3-4339-9d69-b513d94b0013	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
f1394196-34f8-4c9a-a00e-60994bf7ceaa	t	f	2022-02-07 00:00:00	\N	1b66b383-edd3-4339-9d69-b513d94b0013	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
f0756d4b-40d8-4ba0-9cc9-33d4f57c27c9	t	f	2022-02-08 00:00:00	\N	8e9372da-4728-4296-8239-c12c7144381e	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
e9548eeb-768f-4d5e-86f0-944b94756ee9	t	f	2022-02-08 00:00:00	\N	8e9372da-4728-4296-8239-c12c7144381e	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
ea64f12e-ebb4-4e86-b572-17de805249bb	t	f	2022-02-08 00:00:00	\N	8e9372da-4728-4296-8239-c12c7144381e	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
d33a88d5-9292-4edc-87ff-056164c989d5	t	f	2022-02-08 00:00:00	\N	8e9372da-4728-4296-8239-c12c7144381e	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
119ed693-fe82-446d-9db0-0e5f9df5c14d	t	f	2022-02-08 00:00:00	\N	22e579cb-18bd-4950-8213-aefedf8301e7	1217e214-ddd3-4552-921d-0f1f38ce560c	t
a5f211db-838d-4823-8230-0dbd50516bf2	t	f	2022-02-08 00:00:00	\N	22e579cb-18bd-4950-8213-aefedf8301e7	f6d18808-a19f-495a-8f33-adb4a75870da	t
b04555d4-5cd4-4731-a772-5302b6717745	t	f	2022-02-08 00:00:00	\N	13ce9367-b3f2-4c7f-b272-57ecae6f930f	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
f14b4761-8c3a-4462-af49-f1eb93b878fa	t	f	2022-02-08 00:00:00	\N	13ce9367-b3f2-4c7f-b272-57ecae6f930f	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
b4106d04-e9d6-4a95-9ceb-9ed72fe5ecdc	t	f	2022-02-08 00:00:00	\N	13ce9367-b3f2-4c7f-b272-57ecae6f930f	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
18f0d692-6085-45af-a0b8-3883685a74e5	t	f	2022-02-08 00:00:00	\N	13ce9367-b3f2-4c7f-b272-57ecae6f930f	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
bac0d81e-b21b-4b20-bd3f-35fa573b5c6c	t	f	2022-02-08 00:00:00	\N	00b4bf60-cab2-4728-92cb-a60dc1cec6dd	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
531be267-5be3-4e39-8f75-8b0be7ac56cf	t	f	2022-02-08 00:00:00	\N	00b4bf60-cab2-4728-92cb-a60dc1cec6dd	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
a66db58e-20de-4cb3-acb4-aff32a4b7ce4	t	f	2022-02-08 00:00:00	\N	00b4bf60-cab2-4728-92cb-a60dc1cec6dd	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
864e3879-7b31-4a9f-996d-572fb450b470	t	f	2022-02-08 00:00:00	\N	00b4bf60-cab2-4728-92cb-a60dc1cec6dd	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
ecfaa62c-36fe-4e3e-a0bf-465cc6c6b62e	t	f	2022-02-08 00:00:00	\N	7074e768-4d30-4315-bec2-2f4510cb2e98	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	f
d88a8ba0-c464-439b-b074-a424347fdef8	t	f	2022-02-08 00:00:00	\N	7074e768-4d30-4315-bec2-2f4510cb2e98	c7fbf668-d15a-49f4-994b-f04374e78d4a	f
0229d39c-91be-430b-be7b-f9acd8ef1615	t	f	2022-02-08 00:00:00	\N	7074e768-4d30-4315-bec2-2f4510cb2e98	1217e214-ddd3-4552-921d-0f1f38ce560c	t
2a56c31d-38f3-4395-8a06-72817dddb1db	t	f	2022-02-08 00:00:00	\N	7074e768-4d30-4315-bec2-2f4510cb2e98	f6d18808-a19f-495a-8f33-adb4a75870da	t
c65fe051-be80-4448-9696-f9753c053057	t	f	2022-02-08 00:00:00	\N	92f554f2-a06d-4468-b2e3-2efebad5ae6d	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
0492c064-48d8-4b4d-802d-4ba0575346d7	t	f	2022-02-08 00:00:00	\N	44f10bde-2bd7-4a7b-bcac-f3e4ea59d04c	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
d24abe2a-3388-4376-ab2b-a5e6efd3ed2f	t	f	2022-02-08 00:00:00	\N	44f10bde-2bd7-4a7b-bcac-f3e4ea59d04c	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
c06b5aa1-f6b5-4e57-ae50-9e5145a55473	t	f	2022-02-08 00:00:00	\N	44f10bde-2bd7-4a7b-bcac-f3e4ea59d04c	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
025b8e52-82fd-4527-8f35-7ab05148c154	t	f	2022-02-08 00:00:00	\N	44f10bde-2bd7-4a7b-bcac-f3e4ea59d04c	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
608f0baf-177e-4193-b1a5-d853e5f69a50	t	f	2022-02-08 00:00:00	\N	1b66533c-afe7-456d-93a6-81ff1b0227af	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
d3a0ace3-a075-481e-93a4-d7ed9d9d9dd8	t	f	2022-02-08 00:00:00	\N	1b66533c-afe7-456d-93a6-81ff1b0227af	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
c17ec14a-a792-48ec-832c-7688c871b1fc	t	f	2022-02-08 00:00:00	\N	1b66533c-afe7-456d-93a6-81ff1b0227af	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
0a5252e2-4c22-499d-9258-c29b787de4a5	t	f	2022-02-08 00:00:00	\N	1b66533c-afe7-456d-93a6-81ff1b0227af	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
79667232-aef0-4f49-a9d6-242859fecc5a	t	f	2022-02-09 00:00:00	\N	6f9da826-99ee-47a5-a4f2-ec3af36f5563	1217e214-ddd3-4552-921d-0f1f38ce560c	t
4c7239db-0dc6-49fa-857e-fbc3492e1b94	t	f	2022-02-09 00:00:00	\N	6f9da826-99ee-47a5-a4f2-ec3af36f5563	f6d18808-a19f-495a-8f33-adb4a75870da	t
214ecea1-79bb-4905-90bf-64fdb10cb19f	t	f	2022-02-09 00:00:00	\N	6f9da826-99ee-47a5-a4f2-ec3af36f5563	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	t
0b555c1b-b8de-4b98-a319-33b9fce46b56	t	f	2022-02-09 00:00:00	\N	6f9da826-99ee-47a5-a4f2-ec3af36f5563	c7fbf668-d15a-49f4-994b-f04374e78d4a	t
84a317e0-72a8-4edb-b019-c532056d8cb3	t	f	2022-02-09 00:00:00	\N	3fbb489c-1118-4bae-922e-efc644541ab8	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
69104448-a8f9-490f-b6ee-4d1100237aa1	t	f	2022-02-09 00:00:00	\N	3fbb489c-1118-4bae-922e-efc644541ab8	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
ea194b35-f19b-40e0-a091-d3e6fdc86d2f	t	f	2022-02-09 00:00:00	\N	3fbb489c-1118-4bae-922e-efc644541ab8	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
e3b5c94d-0255-4b04-a73d-289af5133d35	t	f	2022-02-09 00:00:00	\N	3fbb489c-1118-4bae-922e-efc644541ab8	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
71b1e4c4-ef14-4b17-bcef-62c59bc04eb6	t	f	2022-02-09 00:00:00	\N	4f58417e-590e-446b-81d9-e28859fe271a	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
0f3e1498-40ef-4f75-a8df-90bfb7d10c1e	t	f	2022-02-09 00:00:00	\N	4f58417e-590e-446b-81d9-e28859fe271a	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
3513fdfa-69d7-46fa-8e70-41f99dd292ff	t	f	2022-02-09 00:00:00	\N	4f58417e-590e-446b-81d9-e28859fe271a	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
432b03a0-f079-40d2-994f-0047dff48a11	t	f	2022-02-09 00:00:00	\N	4f58417e-590e-446b-81d9-e28859fe271a	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
47751f03-d242-45a7-8495-1cda85de0463	t	f	2022-02-09 00:00:00	\N	4b8c81a9-e1ac-463a-bfb4-d4bebab07d4b	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
44717951-d722-44c7-8142-34ec3ab5a172	t	f	2022-02-09 00:00:00	\N	4b8c81a9-e1ac-463a-bfb4-d4bebab07d4b	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
1ca13ea6-2aea-4560-bfb7-119faff4f598	t	f	2022-02-09 00:00:00	\N	4b8c81a9-e1ac-463a-bfb4-d4bebab07d4b	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
a75a6026-6ec9-4d46-8d64-6ae327a99844	t	f	2022-02-09 00:00:00	\N	4b8c81a9-e1ac-463a-bfb4-d4bebab07d4b	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
78179c18-8738-4766-a1c9-e331d797b731	t	f	2022-02-09 00:00:00	\N	0582f1f6-4b03-4f16-8368-78b56e2c6c1f	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
57b4819e-0a5b-4a0b-8002-3c3668be5cbb	t	f	2022-02-09 00:00:00	\N	0582f1f6-4b03-4f16-8368-78b56e2c6c1f	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
392c3305-0c7e-4b56-80af-cacda5993bd2	t	f	2022-02-09 00:00:00	\N	0582f1f6-4b03-4f16-8368-78b56e2c6c1f	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
9f58efb4-5c6f-42f4-9864-81420e9b22cf	t	f	2022-02-09 00:00:00	\N	0582f1f6-4b03-4f16-8368-78b56e2c6c1f	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
eacc5b48-5f38-4d03-837b-b683a2fd6c20	t	f	2022-02-09 00:00:00	\N	c9e319c1-0d8e-4c70-a91f-6d901e56c549	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
7402310e-29bd-490e-ae97-e544b7733f77	t	f	2022-02-09 00:00:00	\N	c9e319c1-0d8e-4c70-a91f-6d901e56c549	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
1d533bc0-383c-4f2c-8f6d-baf98134abb9	t	f	2022-02-09 00:00:00	\N	c9e319c1-0d8e-4c70-a91f-6d901e56c549	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
c4a08e0f-292c-428d-8e9b-be65f3adb3d5	t	f	2022-02-09 00:00:00	\N	b8dc7d4e-2635-4ff3-a179-fe8733a2db71	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
b1ffbd71-20c5-4cd9-adb7-49f16e10c5ef	t	f	2022-02-09 00:00:00	\N	b8dc7d4e-2635-4ff3-a179-fe8733a2db71	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
37c24d16-1c00-4e04-a39f-f3a03496e235	t	f	2022-02-09 00:00:00	\N	b8dc7d4e-2635-4ff3-a179-fe8733a2db71	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
71bc90cb-94a6-46b8-a749-ec1e8f937ba0	t	f	2022-02-09 00:00:00	\N	b8dc7d4e-2635-4ff3-a179-fe8733a2db71	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
c5d7cebc-f02e-4d32-8fd3-7c6985043671	t	f	2022-02-09 00:00:00	\N	2d892a13-97cb-4294-8224-9a14afa09b48	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
7fb02f96-69ec-4b1c-a496-3f58ba6b388d	t	f	2022-02-09 00:00:00	\N	2d892a13-97cb-4294-8224-9a14afa09b48	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
292ff606-0578-4341-a8d0-70257ccea057	t	f	2022-02-09 00:00:00	\N	2d892a13-97cb-4294-8224-9a14afa09b48	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
9a9898d8-7399-432c-b99e-71892444f6be	t	f	2022-02-09 00:00:00	\N	2d892a13-97cb-4294-8224-9a14afa09b48	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
a76ce4e2-06de-4eb2-ad34-bb6ffb660411	t	f	2022-02-09 00:00:00	\N	e98060a2-3819-42f2-baac-29d82d3947cb	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
221a3c02-8d75-4ae6-a98d-7672088c678f	t	f	2022-02-09 00:00:00	\N	e98060a2-3819-42f2-baac-29d82d3947cb	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
674e15f9-9879-4b61-8dab-414ab891fe10	t	f	2022-02-09 00:00:00	\N	e98060a2-3819-42f2-baac-29d82d3947cb	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
6c78ec39-9387-4846-a636-633f930fb36f	t	f	2022-02-09 00:00:00	\N	e98060a2-3819-42f2-baac-29d82d3947cb	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
29dced7e-175b-4adf-ab0c-977c69c0d82a	t	f	2022-02-10 00:00:00	\N	996e7fea-fb70-46bf-aa49-6c8f41709674	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
c86b053e-1409-4596-a7ad-793c0882b790	t	f	2022-02-10 00:00:00	\N	996e7fea-fb70-46bf-aa49-6c8f41709674	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
494e6215-733a-4a05-b2e7-aad54b7f7726	t	f	2022-02-10 00:00:00	\N	996e7fea-fb70-46bf-aa49-6c8f41709674	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
adf4dba6-e29c-4f34-a0ed-fb1a9a8ede90	t	f	2022-02-10 00:00:00	\N	996e7fea-fb70-46bf-aa49-6c8f41709674	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
ad809cc3-983b-4710-a25c-85e1b4a98f55	t	f	2022-02-10 00:00:00	\N	b262bec5-2c7c-4972-99e8-3674fcb4b01b	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
58d8d140-e9b7-4d2d-8d2d-bcab1235457e	t	f	2022-02-10 00:00:00	\N	b262bec5-2c7c-4972-99e8-3674fcb4b01b	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
195c30cb-6fa9-4381-b625-79bbaf88a0f2	t	f	2022-02-10 00:00:00	\N	b262bec5-2c7c-4972-99e8-3674fcb4b01b	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
d1fa7ed6-c2d7-435d-9703-93d0df57eb6b	t	f	2022-02-10 00:00:00	\N	b262bec5-2c7c-4972-99e8-3674fcb4b01b	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
1d6df009-fd23-42db-a846-73d0712cfeb8	t	f	2022-02-10 00:00:00	\N	6793d40a-b3eb-48b4-8f15-665e3d292727	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	f
1715a428-5066-41ec-91df-8fb557b7ae0e	t	f	2022-02-10 00:00:00	\N	6793d40a-b3eb-48b4-8f15-665e3d292727	c7fbf668-d15a-49f4-994b-f04374e78d4a	f
67472461-9406-4477-bf02-76756d088016	t	f	2022-02-10 00:00:00	\N	6793d40a-b3eb-48b4-8f15-665e3d292727	1217e214-ddd3-4552-921d-0f1f38ce560c	t
dec14cfe-8bca-4086-a28b-6332b5ec2b45	t	f	2022-02-10 00:00:00	\N	6793d40a-b3eb-48b4-8f15-665e3d292727	f6d18808-a19f-495a-8f33-adb4a75870da	t
6677d1ab-b8d7-40a1-a13a-39e99c80c275	t	f	2022-02-10 00:00:00	\N	42134a31-3031-4487-8721-acd8028f0e6d	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
8fa46113-62ff-431f-b302-107069df6b29	t	f	2022-02-10 00:00:00	\N	42134a31-3031-4487-8721-acd8028f0e6d	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
5d7c3192-51ce-464e-b67d-119a567cfdfb	t	f	2022-02-10 00:00:00	\N	42134a31-3031-4487-8721-acd8028f0e6d	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
debb3441-cee7-4578-ae3e-8ac54dfe11b7	t	f	2022-02-10 00:00:00	\N	6e04c2db-d5bd-4e9a-9dfd-ea0c13ebdf82	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	t
911d36d1-31a3-4385-a44a-32734ee52301	t	f	2022-02-10 00:00:00	\N	42134a31-3031-4487-8721-acd8028f0e6d	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
f4ad9be6-f15d-42c9-91f9-f8d266a9f6fa	t	f	2022-02-10 00:00:00	\N	1ba949f2-1af2-4dec-8f02-95db8b57229f	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
315497bf-0a21-4b1a-81b2-c5ba334c8e33	t	f	2022-02-10 00:00:00	\N	1ba949f2-1af2-4dec-8f02-95db8b57229f	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
8126b25e-ea17-40cf-bd68-ee8e3e99a1bd	t	f	2022-02-10 00:00:00	\N	1ba949f2-1af2-4dec-8f02-95db8b57229f	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
ae8956a6-33a3-4a41-8a11-c1a72b4108a9	t	f	2022-02-10 00:00:00	\N	1ba949f2-1af2-4dec-8f02-95db8b57229f	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
c3768034-e86d-43e7-ab40-f0f301b0e13c	t	f	2022-02-10 00:00:00	\N	43080818-2400-4c34-88f5-798f1eae2995	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
0615e063-f528-41ea-9710-651db7750c36	t	f	2022-02-10 00:00:00	\N	43080818-2400-4c34-88f5-798f1eae2995	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
d39128b8-4860-479b-ae24-4e1fd6e6e750	t	f	2022-02-10 00:00:00	\N	43080818-2400-4c34-88f5-798f1eae2995	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
601693be-3e82-41b1-9131-6f25f6a4be16	t	f	2022-02-10 00:00:00	\N	43080818-2400-4c34-88f5-798f1eae2995	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
a03efc83-68ee-436e-9693-a24022a1963c	t	f	2022-02-10 00:00:00	\N	6e04c2db-d5bd-4e9a-9dfd-ea0c13ebdf82	1217e214-ddd3-4552-921d-0f1f38ce560c	f
2c81cb87-3153-4285-8fbe-24ea794f820a	t	f	2022-02-10 00:00:00	\N	6e04c2db-d5bd-4e9a-9dfd-ea0c13ebdf82	f6d18808-a19f-495a-8f33-adb4a75870da	f
254f6d37-328c-4a69-83c3-e75c1d5dc234	t	f	2022-02-10 00:00:00	\N	6e04c2db-d5bd-4e9a-9dfd-ea0c13ebdf82	c7fbf668-d15a-49f4-994b-f04374e78d4a	t
c2874b4b-299f-441b-8654-4aa885254cfe	t	f	2022-02-10 00:00:00	\N	e5e2bec4-0a36-4f9c-8199-96d13e519e1e	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
d249e78b-18c0-418c-8206-4c31a000dd2e	t	f	2022-02-10 00:00:00	\N	e5e2bec4-0a36-4f9c-8199-96d13e519e1e	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
91c539d4-59b3-488e-82d8-b78aa4bf0d8d	t	f	2022-02-10 00:00:00	\N	e5e2bec4-0a36-4f9c-8199-96d13e519e1e	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
22593820-1b0c-49aa-9020-1cc6539ea5a4	t	f	2022-02-10 00:00:00	\N	e5e2bec4-0a36-4f9c-8199-96d13e519e1e	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
cd299c2b-72ea-4cdf-bff1-76fa9541f13d	t	f	2022-02-10 00:00:00	\N	1bb55fff-f3f3-4026-9470-618519526d9c	1217e214-ddd3-4552-921d-0f1f38ce560c	t
d2d20f57-d6f9-4230-baee-7d1ad987dc7b	t	f	2022-02-10 00:00:00	\N	1bb55fff-f3f3-4026-9470-618519526d9c	f6d18808-a19f-495a-8f33-adb4a75870da	t
bf8d93c0-91ff-4130-9ecc-1cca647bb7ba	t	f	2022-02-10 00:00:00	\N	1bb55fff-f3f3-4026-9470-618519526d9c	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	t
59a62764-4114-4668-ab7d-cb0320c3b4d7	t	f	2022-02-10 00:00:00	\N	1bb55fff-f3f3-4026-9470-618519526d9c	c7fbf668-d15a-49f4-994b-f04374e78d4a	t
32c3002a-3c7f-4883-b596-c81bc2c1fee6	t	f	2022-02-10 00:00:00	\N	04596daf-0ff8-4363-ac93-82a264378e55	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
ce61f5ff-8a69-43ef-824d-3ee3df879dda	t	f	2022-02-10 00:00:00	\N	04596daf-0ff8-4363-ac93-82a264378e55	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
ee132a0a-65ea-4c0a-94d2-414374083750	t	f	2022-02-10 00:00:00	\N	04596daf-0ff8-4363-ac93-82a264378e55	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
91f35342-0b04-4923-b255-ee761654d4a6	t	f	2022-02-10 00:00:00	\N	04596daf-0ff8-4363-ac93-82a264378e55	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
ac7f1587-0857-4e99-947e-88394711d84b	t	f	2022-02-11 00:00:00	\N	626ad883-909c-4c63-ab9f-50197d3a384f	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
bf0a99f5-b464-477d-98b5-4aec6ef4a508	t	f	2022-02-09 00:00:00	\N	c9e319c1-0d8e-4c70-a91f-6d901e56c549	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
0f143760-3927-4253-be59-25c1461e14c1	t	f	2022-02-11 00:00:00	\N	626ad883-909c-4c63-ab9f-50197d3a384f	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
8f7fbe08-5aa6-496e-a6e7-54c1612be58d	t	f	2022-02-11 00:00:00	\N	626ad883-909c-4c63-ab9f-50197d3a384f	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
dbc1263c-2ec7-48f7-b4ed-7ae86c1e8408	t	f	2022-02-11 00:00:00	\N	626ad883-909c-4c63-ab9f-50197d3a384f	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
9c379a04-9871-43ce-be0e-6a3ef3d69619	t	f	2022-02-11 00:00:00	\N	cf0fffad-847f-4d5b-80cc-e7297a0ff682	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
ccf26fe4-92ec-4a02-8f42-15a0d2f4de6b	t	f	2022-02-11 00:00:00	\N	cf0fffad-847f-4d5b-80cc-e7297a0ff682	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
d074bcc5-6dcc-405f-adcf-c74e9789649d	t	f	2022-02-11 00:00:00	\N	cf0fffad-847f-4d5b-80cc-e7297a0ff682	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
793fb5c3-9736-4147-9b35-2054370b73fa	t	f	2022-02-11 00:00:00	\N	cf0fffad-847f-4d5b-80cc-e7297a0ff682	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
de9e9254-ee9c-4c82-9738-d9027047a381	t	f	2022-02-11 00:00:00	\N	bdee0977-41a3-489c-a465-42e859a72dd0	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
c00e666c-6756-4d25-b551-e5aa8a44048c	t	f	2022-02-11 00:00:00	\N	bdee0977-41a3-489c-a465-42e859a72dd0	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
5f87af0d-1e73-452d-8b72-caae92c0a471	t	f	2022-02-11 00:00:00	\N	bdee0977-41a3-489c-a465-42e859a72dd0	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
42b0febe-0d23-46fa-8569-a637e83a3acf	t	f	2022-02-11 00:00:00	\N	bdee0977-41a3-489c-a465-42e859a72dd0	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
6a67e196-2474-4d33-9352-7ea55bf39384	t	f	2022-02-11 00:00:00	\N	336ac71d-a21e-4294-a17d-53d9bff90404	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
e472e5bd-e4a7-4dac-ac19-8cf40a10607a	t	f	2022-02-11 00:00:00	\N	336ac71d-a21e-4294-a17d-53d9bff90404	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
7ad1c63c-8399-46cb-81ae-5af38075765c	t	f	2022-02-11 00:00:00	\N	336ac71d-a21e-4294-a17d-53d9bff90404	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
8a69c170-f8e3-4b7b-a871-514705eee918	t	f	2022-02-11 00:00:00	\N	336ac71d-a21e-4294-a17d-53d9bff90404	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
7a56f54f-5f0d-480f-a4d5-a94d12d502d5	t	f	2022-02-11 00:00:00	\N	9b07fb5f-4091-40d0-b975-cb31ab1f6c32	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
112aa1ed-cf8f-4836-be32-37b409d90d0e	t	f	2022-02-11 00:00:00	\N	9b07fb5f-4091-40d0-b975-cb31ab1f6c32	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
780961ef-4ac4-41be-bc03-bef56e34d36f	t	f	2022-02-11 00:00:00	\N	9b07fb5f-4091-40d0-b975-cb31ab1f6c32	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
9f734cfe-0006-4044-8e7a-6bed604b81ee	t	f	2022-02-11 00:00:00	\N	9b07fb5f-4091-40d0-b975-cb31ab1f6c32	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
3220d94c-f5e2-464b-a2dd-d5cbc10095be	t	f	2022-02-11 00:00:00	\N	e400afb7-6c40-46d8-bff8-f385ac801726	1217e214-ddd3-4552-921d-0f1f38ce560c	t
ceec6815-1c74-488b-8daf-c7531b42aea5	t	f	2022-02-11 00:00:00	\N	e400afb7-6c40-46d8-bff8-f385ac801726	f6d18808-a19f-495a-8f33-adb4a75870da	t
1ce44c6e-96b8-4a09-af9c-089f817c6ae1	t	f	2022-02-11 00:00:00	\N	e400afb7-6c40-46d8-bff8-f385ac801726	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	t
aa22ac4e-1924-4a80-8f2e-542fbd03d8a8	t	f	2022-02-11 00:00:00	\N	e400afb7-6c40-46d8-bff8-f385ac801726	c7fbf668-d15a-49f4-994b-f04374e78d4a	t
387034b6-effd-43ba-9d58-490c2ad5eb89	t	f	2022-02-11 00:00:00	\N	f1b420b5-07e3-46e9-aacd-84bb1cb8f67e	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
89dcb0ce-efcb-4d9f-b5b1-2199deee3ba8	t	f	2022-02-11 00:00:00	\N	f1b420b5-07e3-46e9-aacd-84bb1cb8f67e	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
c505d47e-4854-457d-b405-029ab1066d96	t	f	2022-02-11 00:00:00	\N	f1b420b5-07e3-46e9-aacd-84bb1cb8f67e	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
b48e35b5-071d-493f-b72f-09076f482269	t	f	2022-02-11 00:00:00	\N	f1b420b5-07e3-46e9-aacd-84bb1cb8f67e	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
6ed936b8-ca27-4e58-b70b-8444731c3eb4	t	f	2022-02-11 00:00:00	\N	5037db19-1751-4651-b3c0-2bae80ae50f9	f6d18808-a19f-495a-8f33-adb4a75870da	f
9c10e8ca-5444-4b18-96de-035aa7aa5343	t	f	2022-02-11 00:00:00	\N	5037db19-1751-4651-b3c0-2bae80ae50f9	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	f
b291c5fa-e627-4fb5-8c62-4005adbc6841	t	f	2022-02-11 00:00:00	\N	5037db19-1751-4651-b3c0-2bae80ae50f9	c7fbf668-d15a-49f4-994b-f04374e78d4a	f
8a12e4eb-6721-4c72-9f64-61ff92f1adbe	t	f	2022-02-11 00:00:00	\N	5037db19-1751-4651-b3c0-2bae80ae50f9	1217e214-ddd3-4552-921d-0f1f38ce560c	t
d74d0b50-6a0d-4777-9e23-f815eec5da12	t	f	2022-02-11 00:00:00	\N	d60cbc67-ae78-4296-acb4-f561336c49b0	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
97a06224-f3b5-4c36-936b-f2119e2e8e7a	t	f	2022-02-11 00:00:00	\N	d60cbc67-ae78-4296-acb4-f561336c49b0	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
7f985eb5-b15e-4f5f-a611-c98381816ad7	t	f	2022-02-11 00:00:00	\N	d60cbc67-ae78-4296-acb4-f561336c49b0	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
8f526eeb-e46c-4135-852f-f85b3b6b1e4c	t	f	2022-02-11 00:00:00	\N	d60cbc67-ae78-4296-acb4-f561336c49b0	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
5275973e-3d44-45dd-a94d-6d4f127e8f3d	t	f	2022-02-11 00:00:00	\N	68ad76a1-1016-419f-af87-6862b41749a0	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
96e3452e-9bf0-4517-aa2a-df6cee6b02ea	t	f	2022-02-11 00:00:00	\N	009f6c2f-67d4-42c6-9a2c-cc0330078a80	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
98c11ede-2386-4301-b9dc-c94bf8380ab2	t	f	2022-02-11 00:00:00	\N	68ad76a1-1016-419f-af87-6862b41749a0	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
5e0847ce-681b-4095-a76e-fe4943414c43	t	f	2022-02-11 00:00:00	\N	886270b3-5437-464a-9fc5-6cad6d66162d	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
63e57a1b-8e29-410c-9361-ca303c2bed88	t	f	2022-02-11 00:00:00	\N	886270b3-5437-464a-9fc5-6cad6d66162d	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
ecceaed3-b9cf-44a6-8156-d29ab3a4b053	t	f	2022-02-11 00:00:00	\N	886270b3-5437-464a-9fc5-6cad6d66162d	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
3dd89e5f-5eb4-46bb-8463-fe8e1d813d72	t	f	2022-02-11 00:00:00	\N	886270b3-5437-464a-9fc5-6cad6d66162d	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
1eb5c84c-956d-4611-9629-3d1790298a2a	t	f	2022-02-11 00:00:00	\N	12e81b02-86ea-4b4e-9fc3-5012379149a9	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
db96d953-ac5e-40ae-be0e-2cb33831426a	t	f	2022-02-11 00:00:00	\N	12e81b02-86ea-4b4e-9fc3-5012379149a9	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
ff30ab11-0047-43d5-904f-b3d524ee43cc	t	f	2022-02-11 00:00:00	\N	12e81b02-86ea-4b4e-9fc3-5012379149a9	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
3c2e1130-006d-4aff-a55d-c54eeab8d5ed	t	f	2022-02-11 00:00:00	\N	12e81b02-86ea-4b4e-9fc3-5012379149a9	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
2d3b4ece-5ed5-421f-a54e-dfc20762e3d2	t	f	2022-02-11 00:00:00	\N	009f6c2f-67d4-42c6-9a2c-cc0330078a80	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
a9c215ae-41a5-4d00-b157-d553b6194d51	t	f	2022-02-11 00:00:00	\N	009f6c2f-67d4-42c6-9a2c-cc0330078a80	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
a2ed3129-a456-475a-8f72-359eaf530d01	t	f	2022-02-11 00:00:00	\N	009f6c2f-67d4-42c6-9a2c-cc0330078a80	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
9ade02cf-4895-4a28-8351-0c8d59f03e78	t	f	2022-02-11 00:00:00	\N	60df4214-1ced-49af-913e-b5df48550ed2	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
70854880-090f-40ad-9ffd-e1d56b2869b4	t	f	2022-02-11 00:00:00	\N	60df4214-1ced-49af-913e-b5df48550ed2	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
b65ab442-a6d0-4d08-bac7-e253b3ffcb6d	t	f	2022-02-11 00:00:00	\N	60df4214-1ced-49af-913e-b5df48550ed2	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
7d362041-e1d2-45c7-8a64-2968a14e5aac	t	f	2022-02-11 00:00:00	\N	60df4214-1ced-49af-913e-b5df48550ed2	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
b44ca327-e5d8-4f4c-842c-436b24f8947d	t	f	2022-02-11 00:00:00	\N	c976aab7-06bb-4500-8bf2-cbcb377a2300	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
77851604-7c8f-45b7-9dc8-1cfb02f66014	t	f	2022-02-11 00:00:00	\N	c976aab7-06bb-4500-8bf2-cbcb377a2300	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
d22f11ac-bb3c-4a27-aa8f-de3b384d5ba2	t	f	2022-02-11 00:00:00	\N	9719a2eb-974d-4635-87c3-25895f7e7bee	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
bc087b2b-d44c-43a8-9641-8fff58d45901	t	f	2022-02-11 00:00:00	\N	9719a2eb-974d-4635-87c3-25895f7e7bee	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
17c33c51-a08d-4510-94d6-1a56dbd8443f	t	f	2022-02-11 00:00:00	\N	c976aab7-06bb-4500-8bf2-cbcb377a2300	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
692e8d7a-7c9a-4276-a1fd-55ea4250740b	t	f	2022-02-11 00:00:00	\N	c976aab7-06bb-4500-8bf2-cbcb377a2300	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
a4d988ef-b8f8-4584-bc59-76f4c79135e3	t	f	2022-02-11 00:00:00	\N	9719a2eb-974d-4635-87c3-25895f7e7bee	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
da2b6422-61a5-4246-b4a3-29dbe218f76e	t	f	2022-02-11 00:00:00	\N	9719a2eb-974d-4635-87c3-25895f7e7bee	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
27af694d-7ba8-480b-b40c-4398890294d7	t	f	2022-02-12 00:00:00	\N	1d8eb448-dc0a-4f62-9e35-5cc388be8304	1217e214-ddd3-4552-921d-0f1f38ce560c	t
21154b3d-1862-40fe-8732-dc7b8f9f2c1c	t	f	2022-02-12 00:00:00	\N	1d8eb448-dc0a-4f62-9e35-5cc388be8304	f6d18808-a19f-495a-8f33-adb4a75870da	t
20517f68-9f09-4938-8da7-53798fd673dd	t	f	2022-02-12 00:00:00	\N	ca42eca4-90d9-409d-aab7-d47456dd193b	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
666a9f4f-22d6-4022-8f44-48a4d35c6c46	t	f	2022-02-12 00:00:00	\N	ca42eca4-90d9-409d-aab7-d47456dd193b	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
a5f45a7e-36c1-48e6-b945-199259bc0135	t	f	2022-02-12 00:00:00	\N	ca42eca4-90d9-409d-aab7-d47456dd193b	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
7a71f388-b817-45cd-9a27-25a0ce3ed2cb	t	f	2022-02-12 00:00:00	\N	ca42eca4-90d9-409d-aab7-d47456dd193b	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
98b209be-1607-452a-a3b6-bc8cf2def050	t	f	2022-02-12 00:00:00	\N	8e356174-7b58-4de7-a64a-21c6d9616b3e	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
62fd853f-83dc-4cf7-a29c-39f71d99d418	t	f	2022-02-12 00:00:00	\N	8e356174-7b58-4de7-a64a-21c6d9616b3e	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
054022a2-aa71-40aa-82b1-e7984eb38228	t	f	2022-02-12 00:00:00	\N	8e356174-7b58-4de7-a64a-21c6d9616b3e	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
cd29502a-f400-4837-8d58-4207a7a13f49	t	f	2022-02-12 00:00:00	\N	8e356174-7b58-4de7-a64a-21c6d9616b3e	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
8dcd2145-8231-413e-848b-c8d536a63002	t	f	2022-02-11 00:00:00	\N	70376fb9-c9ab-42f0-baf3-f357069a96d2	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	t
2fd77d43-acc8-47e2-8760-d24cc3f620f4	t	f	2022-02-11 00:00:00	\N	70376fb9-c9ab-42f0-baf3-f357069a96d2	c7fbf668-d15a-49f4-994b-f04374e78d4a	t
5382f5f8-12c8-484e-be25-53106db5d8b2	t	f	2022-02-11 00:00:00	\N	70376fb9-c9ab-42f0-baf3-f357069a96d2	1217e214-ddd3-4552-921d-0f1f38ce560c	f
74561659-c5fa-483d-930a-b7999718ac02	t	f	2022-02-11 00:00:00	\N	70376fb9-c9ab-42f0-baf3-f357069a96d2	f6d18808-a19f-495a-8f33-adb4a75870da	f
c5d072b3-7d58-47b3-8993-e4be1164c863	t	f	2022-02-11 00:00:00	\N	68ad76a1-1016-419f-af87-6862b41749a0	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
70c934da-01cc-41c8-9a7b-610a41e3c09e	t	f	2022-02-12 00:00:00	\N	1d8eb448-dc0a-4f62-9e35-5cc388be8304	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	t
ea0ba3ee-dffa-4e6c-b1b3-1970d15b8002	t	f	2022-02-12 00:00:00	\N	1d8eb448-dc0a-4f62-9e35-5cc388be8304	c7fbf668-d15a-49f4-994b-f04374e78d4a	t
843c67b6-113a-4330-a03b-9c1ecadd537b	t	f	2022-02-14 00:00:00	\N	097e5123-5792-4f6b-89c5-6a6e61660fa3	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
6a00b0cd-d272-43d3-a0fd-c71a86cbf782	t	f	2022-02-11 00:00:00	\N	68ad76a1-1016-419f-af87-6862b41749a0	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
77786cbb-de58-44e7-bae7-6a373b286f66	t	f	2022-02-13 00:00:00	\N	439c1035-8b0d-48a2-95f6-d3efab665327	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
6efc3257-7e76-4ccb-a708-c5a6a4cca2d6	t	f	2022-02-13 00:00:00	\N	439c1035-8b0d-48a2-95f6-d3efab665327	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
9d6d7d95-bb11-49c6-9d83-a7f94d283438	t	f	2022-02-13 00:00:00	\N	439c1035-8b0d-48a2-95f6-d3efab665327	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
555c522d-6acc-4873-a32d-3dcc94b86cae	t	f	2022-02-14 00:00:00	\N	4ce18dd6-8871-4046-977f-717416c230eb	1217e214-ddd3-4552-921d-0f1f38ce560c	f
baa465b7-ff30-4f46-81e7-1dd6012dfb20	t	f	2022-02-14 00:00:00	\N	4ce18dd6-8871-4046-977f-717416c230eb	f6d18808-a19f-495a-8f33-adb4a75870da	f
e9b1c281-39ee-4de6-b32a-e2c6e29a1aa4	t	f	2022-02-14 00:00:00	\N	4ce18dd6-8871-4046-977f-717416c230eb	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	f
3f0240d9-9786-4d79-ab31-de2f4ce6bfd9	t	f	2022-02-13 00:00:00	\N	439c1035-8b0d-48a2-95f6-d3efab665327	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
3d3de2d8-85d9-4f93-9ec7-c1023ed0a1a4	t	f	2022-02-13 00:00:00	\N	d67d8bff-edf1-4f3f-b299-918f6d9accf1	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
57d7a4e7-aeae-43c0-aab4-e4c2af624528	t	f	2022-02-13 00:00:00	\N	d67d8bff-edf1-4f3f-b299-918f6d9accf1	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
ac247b31-f46f-4042-80d1-58b93024add8	t	f	2022-02-14 00:00:00	\N	4ce18dd6-8871-4046-977f-717416c230eb	c7fbf668-d15a-49f4-994b-f04374e78d4a	t
6ee5af49-ea1b-49c2-b829-3387e2590b42	t	f	2022-02-13 00:00:00	\N	d67d8bff-edf1-4f3f-b299-918f6d9accf1	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
901bdbc2-2297-4e69-8326-47182f05c6a7	t	f	2022-02-13 00:00:00	\N	3091e577-a628-4a54-b449-9a4b39757f28	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
df58b24b-e645-4d74-a305-5164258e4bb3	t	f	2022-02-14 00:00:00	\N	0eac64c8-2dd3-464b-a74f-a55e46b0bfec	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
07df143f-9a15-4ae5-bdd7-41cde99b9008	t	f	2022-02-14 00:00:00	\N	0eac64c8-2dd3-464b-a74f-a55e46b0bfec	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
6c8f2eda-4101-4781-8f42-dbfd2d7a4ea5	t	f	2022-02-14 00:00:00	\N	0eac64c8-2dd3-464b-a74f-a55e46b0bfec	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
7ae6896b-fa40-4c5a-a5ac-c3c63649a27f	t	f	2022-02-13 00:00:00	\N	3091e577-a628-4a54-b449-9a4b39757f28	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
3c93e3eb-48a9-45a0-9b0a-f252c59c0bdb	t	f	2022-02-14 00:00:00	\N	0eac64c8-2dd3-464b-a74f-a55e46b0bfec	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
8f5c3340-4eea-4566-8f81-dcbb565627a2	t	f	2022-02-13 00:00:00	\N	3091e577-a628-4a54-b449-9a4b39757f28	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
6ca44cbd-c582-4bf8-8832-e8aea22fd289	t	f	2022-02-13 00:00:00	\N	3091e577-a628-4a54-b449-9a4b39757f28	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
a32c40b5-8d19-43e7-a5bf-368ba39e8e33	t	f	2022-02-13 00:00:00	\N	6e94b134-fc2b-402a-9ded-1bfebe5a6b9e	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
4aa90689-d8b7-420f-9ee9-8400f35c636d	t	f	2022-02-13 00:00:00	\N	6e94b134-fc2b-402a-9ded-1bfebe5a6b9e	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
a5f09c37-ecc8-4d0d-be22-d3eea508a4ad	t	f	2022-02-13 00:00:00	\N	6e94b134-fc2b-402a-9ded-1bfebe5a6b9e	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
81fc5b42-d501-4ef7-abcb-32ec24294e2e	t	f	2022-02-13 00:00:00	\N	6e94b134-fc2b-402a-9ded-1bfebe5a6b9e	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
6de6b7ac-1f23-4cd4-b634-05e676d2180e	t	f	2022-02-13 00:00:00	\N	2665fd37-3ac0-467d-bbf7-7cd659cafc64	f6d18808-a19f-495a-8f33-adb4a75870da	f
808e3999-949c-45a9-9a10-e0e0414882b1	t	f	2022-02-13 00:00:00	\N	2665fd37-3ac0-467d-bbf7-7cd659cafc64	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	f
0b3098b1-1a20-42c5-8421-58124cc99763	t	f	2022-02-13 00:00:00	\N	2665fd37-3ac0-467d-bbf7-7cd659cafc64	c7fbf668-d15a-49f4-994b-f04374e78d4a	f
3d56201c-1b77-49b2-ac76-ea5d0aade7f1	t	f	2022-02-13 00:00:00	\N	2665fd37-3ac0-467d-bbf7-7cd659cafc64	1217e214-ddd3-4552-921d-0f1f38ce560c	f
8e99787a-d79f-4929-8d0a-1fe054a11168	t	f	2022-02-14 00:00:00	\N	2ad86532-88bc-4ef9-825a-5531788f873d	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
0d3f63ce-eea9-4ef6-8ef0-8069dd8fca16	t	f	2022-02-14 00:00:00	\N	3e7646df-1fda-48ec-b944-7f563a83e988	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
3d5bbd29-798a-4dc9-be64-41633fa9bdf4	t	f	2022-02-13 00:00:00	\N	d67d8bff-edf1-4f3f-b299-918f6d9accf1	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
507e7726-f6ae-4cce-954f-0616d3909662	t	f	2022-02-06 00:00:00	\N	f632f62b-0b42-4a70-b6d7-e1cdee77a5d0	f6d18808-a19f-495a-8f33-adb4a75870da	f
a28d7183-dbab-47bc-a64f-594503b328a2	t	f	2022-02-13 00:00:00	\N	b0d53d4c-6380-42c6-96ed-a2c3745250f6	f6d18808-a19f-495a-8f33-adb4a75870da	f
2a6b5316-4fc1-4c5a-b82e-8cec7a753994	t	f	2022-02-13 00:00:00	\N	b0d53d4c-6380-42c6-96ed-a2c3745250f6	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	f
d0a4b196-5acb-4861-87ae-071d7f6d097b	t	f	2022-02-13 00:00:00	\N	b0d53d4c-6380-42c6-96ed-a2c3745250f6	c7fbf668-d15a-49f4-994b-f04374e78d4a	f
096199e5-859d-42e4-95a1-f797739c4230	t	f	2022-02-13 00:00:00	\N	b0d53d4c-6380-42c6-96ed-a2c3745250f6	1217e214-ddd3-4552-921d-0f1f38ce560c	t
2a110d2b-49de-441e-82c8-76b2bcb6a44f	t	f	2022-02-13 00:00:00	\N	da660b30-6cca-4ba7-acc0-99decb7c7e34	1217e214-ddd3-4552-921d-0f1f38ce560c	f
14769663-526f-49e1-b730-145bc4d94d8e	t	f	2022-02-13 00:00:00	\N	da660b30-6cca-4ba7-acc0-99decb7c7e34	f6d18808-a19f-495a-8f33-adb4a75870da	f
0b249a81-baba-4fab-b4f9-64dd2a732f57	t	f	2022-02-13 00:00:00	\N	da660b30-6cca-4ba7-acc0-99decb7c7e34	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	t
921742bb-99c9-4e8a-8ded-f5a15d5f2b21	t	f	2022-02-13 00:00:00	\N	da660b30-6cca-4ba7-acc0-99decb7c7e34	c7fbf668-d15a-49f4-994b-f04374e78d4a	t
2a4f4dda-e3f2-4bb7-9afe-5f1b20376a6c	t	f	2022-02-13 00:00:00	\N	3e2b594a-048a-40e1-b414-b10258e3666e	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
d65069de-e357-494c-80a9-c871ab55b549	t	f	2022-02-13 00:00:00	\N	3e2b594a-048a-40e1-b414-b10258e3666e	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
4cc8b484-e7c1-4990-a44f-227aaff53db3	t	f	2022-02-13 00:00:00	\N	3e2b594a-048a-40e1-b414-b10258e3666e	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
aa9a3590-5d90-4802-ada9-b22fce5be3f5	t	f	2022-02-13 00:00:00	\N	3e2b594a-048a-40e1-b414-b10258e3666e	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
210dca69-2d9c-44ed-9a2f-141c2e8f9506	t	f	2022-02-14 00:00:00	\N	4ffb74ba-1bdd-45f6-898a-2a1290136c7f	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
964dad4f-18be-4815-a7ee-07ede1ab98da	t	f	2022-02-14 00:00:00	\N	4ffb74ba-1bdd-45f6-898a-2a1290136c7f	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
8e7baec0-0c3c-447a-bc39-8b17ac8e2d16	t	f	2022-02-14 00:00:00	\N	4ffb74ba-1bdd-45f6-898a-2a1290136c7f	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
2a7c8474-a9e0-469c-8359-056b87e67a95	t	f	2022-02-14 00:00:00	\N	4ffb74ba-1bdd-45f6-898a-2a1290136c7f	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
4627c0e9-b6f2-416d-a41b-bc1a0c45d305	t	f	2022-02-14 00:00:00	\N	097e5123-5792-4f6b-89c5-6a6e61660fa3	79ce8627-31ce-48e8-8275-c83f9eafe14a	f
f5dbdde0-673f-4985-8e7e-2afd035c32f3	t	f	2022-02-14 00:00:00	\N	097e5123-5792-4f6b-89c5-6a6e61660fa3	88c3c579-cfa1-4057-96c4-855fac75c9bf	f
9123fad3-e4d2-49e4-a7b1-a7b226ba33b3	t	f	2022-02-14 00:00:00	\N	097e5123-5792-4f6b-89c5-6a6e61660fa3	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
a651c61a-852f-490c-a177-1297d7c49f02	t	f	2022-02-14 00:00:00	\N	3e7646df-1fda-48ec-b944-7f563a83e988	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
50f0a868-37a5-40a0-ba1c-963f93698d8b	t	f	2022-02-14 00:00:00	\N	3e7646df-1fda-48ec-b944-7f563a83e988	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
e95c532b-263c-43a8-921e-ee83dd74e873	t	f	2022-02-14 00:00:00	\N	3e7646df-1fda-48ec-b944-7f563a83e988	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
0b9e0f28-63da-4f29-83b3-85ffd3478561	t	f	2022-02-14 00:00:00	\N	cb2105b1-b557-4977-9a4b-178d078b795d	f6d18808-a19f-495a-8f33-adb4a75870da	t
ea74848f-b1d3-43b8-b661-b2d4928b1f17	t	f	2022-02-14 00:00:00	\N	2ad86532-88bc-4ef9-825a-5531788f873d	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
8f082ff8-bdcc-4bab-a1f8-5be6e30d12a3	t	f	2022-02-14 00:00:00	\N	2ad86532-88bc-4ef9-825a-5531788f873d	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
a08dca71-830e-4760-842f-d6ddb9b5b2fe	t	f	2022-02-14 00:00:00	\N	2ad86532-88bc-4ef9-825a-5531788f873d	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
869703a4-8f3e-4307-82de-168a8c8ab3bf	t	f	2022-02-14 00:00:00	\N	8c364168-8d02-4e31-b13e-b711e8cea713	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	f
21515d5b-4962-4442-a8d7-f6525d893f00	t	f	2022-02-14 00:00:00	\N	8c364168-8d02-4e31-b13e-b711e8cea713	c7fbf668-d15a-49f4-994b-f04374e78d4a	f
4e38480f-1a04-480d-9326-fc3adc28a468	t	f	2022-02-14 00:00:00	\N	8c364168-8d02-4e31-b13e-b711e8cea713	1217e214-ddd3-4552-921d-0f1f38ce560c	t
7013af96-c035-462d-97c2-7c93ca49435b	t	f	2022-02-14 00:00:00	\N	8c364168-8d02-4e31-b13e-b711e8cea713	f6d18808-a19f-495a-8f33-adb4a75870da	t
ada876f5-f0c3-497d-a786-b25aa9691d50	t	f	2022-02-14 00:00:00	\N	cb2105b1-b557-4977-9a4b-178d078b795d	1217e214-ddd3-4552-921d-0f1f38ce560c	f
26e71262-04e6-45aa-8f5d-1da637295b07	t	f	2022-02-14 00:00:00	\N	cb2105b1-b557-4977-9a4b-178d078b795d	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	f
7f1a3e25-9317-4d8d-b2be-d6dd5b57ce4c	t	f	2022-02-14 00:00:00	\N	cb2105b1-b557-4977-9a4b-178d078b795d	c7fbf668-d15a-49f4-994b-f04374e78d4a	f
07363635-b264-459b-a9c3-616369bfce50	t	f	2022-02-14 00:00:00	\N	60f8d738-c772-42c9-b56e-c2c8df4a6e43	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	f
977f3ca7-fa23-4e8e-ae2d-203cb9e24620	t	f	2022-02-14 00:00:00	\N	60f8d738-c772-42c9-b56e-c2c8df4a6e43	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
e32db738-c426-487a-9217-cf5198eb508f	t	f	2022-02-14 00:00:00	\N	60f8d738-c772-42c9-b56e-c2c8df4a6e43	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
45f21312-8e4a-4d53-9026-0baba0e37f5f	t	f	2022-02-14 00:00:00	\N	d38a94c4-7560-4106-9c40-7820371e8d26	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
8fd12cf5-cdfd-4091-8ec5-4f8fd587b1fe	t	f	2022-02-14 00:00:00	\N	60f8d738-c772-42c9-b56e-c2c8df4a6e43	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
94bf5fe4-1605-4fc0-bdfb-4362a36febdd	t	f	2022-02-14 00:00:00	\N	d38a94c4-7560-4106-9c40-7820371e8d26	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
da016e1f-18cf-42d5-8553-4aeabbc10bc1	t	f	2022-02-14 00:00:00	\N	d38a94c4-7560-4106-9c40-7820371e8d26	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
9587f9d3-0dc9-4bc8-83c1-bb99dcaad925	t	f	2022-02-14 00:00:00	\N	16244b18-572d-48ba-8431-6062973fd593	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
fdf84cf5-ce88-4ae0-a00f-0b731756e753	t	f	2022-02-14 00:00:00	\N	16244b18-572d-48ba-8431-6062973fd593	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
a9e581a3-3a21-43fd-bddc-737559c1b532	t	f	2022-02-14 00:00:00	\N	16244b18-572d-48ba-8431-6062973fd593	6e04f791-0d9e-4047-96e3-823c7caa94d8	t
c124e859-55d6-4b22-89bf-8294e592b44a	t	f	2022-02-14 00:00:00	\N	44f81af6-cb08-4bb7-84fa-58836898f10f	1217e214-ddd3-4552-921d-0f1f38ce560c	t
2557ce97-dc8c-4ed5-add8-06268439b4a7	t	f	2022-02-14 00:00:00	\N	16244b18-572d-48ba-8431-6062973fd593	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
bb92c5ba-f14f-4c62-b69c-b1d78afcc750	t	f	2022-02-14 00:00:00	\N	d38a94c4-7560-4106-9c40-7820371e8d26	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
a28836c8-c298-4ce3-8c41-e7286d7e8c9a	t	f	2022-02-14 00:00:00	\N	44f81af6-cb08-4bb7-84fa-58836898f10f	f6d18808-a19f-495a-8f33-adb4a75870da	t
208ce24b-4835-4e2a-8200-590f2bb65adf	t	f	2022-02-14 00:00:00	\N	44f81af6-cb08-4bb7-84fa-58836898f10f	3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	t
03e6c1b6-3743-4704-826c-ae4cb1345665	t	f	2022-02-14 00:00:00	\N	44f81af6-cb08-4bb7-84fa-58836898f10f	c7fbf668-d15a-49f4-994b-f04374e78d4a	t
859f61e5-0ea8-4a5f-8b92-5b3790b6f959	t	f	2022-02-14 00:00:00	\N	fd905cd4-e3d6-4454-b8ba-eaa61a453f77	6e04f791-0d9e-4047-96e3-823c7caa94d8	f
2567b715-bf9a-4724-9cec-cb72d2d6c4fd	t	f	2022-02-14 00:00:00	\N	fd905cd4-e3d6-4454-b8ba-eaa61a453f77	79ce8627-31ce-48e8-8275-c83f9eafe14a	t
b75b9611-bab0-4dec-bf65-b641d8a0ca0c	t	f	2022-02-14 00:00:00	\N	fd905cd4-e3d6-4454-b8ba-eaa61a453f77	88c3c579-cfa1-4057-96c4-855fac75c9bf	t
954a9383-87de-49b5-b507-d6b4861acaf4	t	f	2022-02-14 00:00:00	\N	fd905cd4-e3d6-4454-b8ba-eaa61a453f77	48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t
\.


--
-- Data for Name: wertungsrichter_slot; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wertungsrichter_slot (id, aktiv, deleted, change_date, deletion_date, anlass_id, reihenfolge, brevet, tag, start_zeit, end_zeit, beschreibung) FROM stdin;
f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t	f	2022-01-09 00:00:00	\N	b7440787-50bd-4e41-b38b-48acf37af0de	0	0	\N	\N	\N	SO Morgen
d179758b-c473-41bd-9aa9-c037675cca6f	t	f	2022-01-09 00:00:00	\N	b7440787-50bd-4e41-b38b-48acf37af0de	1	1	\N	\N	\N	SO Mittag
1217e214-ddd3-4552-921d-0f1f38ce560c	t	f	\N	\N	0fa002f3-d432-46d4-a753-991d021db3fa	1	1	\N	\N	\N	SA Morgen
f6d18808-a19f-495a-8f33-adb4a75870da	t	f	\N	\N	0fa002f3-d432-46d4-a753-991d021db3fa	2	1	\N	\N	\N	SA Mittag
3b1f5d9c-a9dd-47c6-8848-c98d5c8d7424	t	f	\N	\N	0fa002f3-d432-46d4-a753-991d021db3fa	3	1	\N	\N	\N	SO Morgen
c7fbf668-d15a-49f4-994b-f04374e78d4a	t	f	\N	\N	0fa002f3-d432-46d4-a753-991d021db3fa	4	1	\N	\N	\N	SO Mittag
79ce8627-31ce-48e8-8275-c83f9eafe14a	t	f	\N	\N	0fa002f3-d432-46d4-a753-991d021db3fa	5	0	\N	\N	\N	SA Morgen
88c3c579-cfa1-4057-96c4-855fac75c9bf	t	f	\N	\N	0fa002f3-d432-46d4-a753-991d021db3fa	6	0	\N	\N	\N	SA Mittag
48a87a9e-e5d5-4ef1-a45e-04f3e73c7caf	t	f	\N	\N	0fa002f3-d432-46d4-a753-991d021db3fa	7	0	\N	\N	\N	SO Morgen
6e04f791-0d9e-4047-96e3-823c7caa94d8	t	f	\N	\N	0fa002f3-d432-46d4-a753-991d021db3fa	8	0	\N	\N	\N	SO Mittag
\.


--
-- Name: anlass anlass_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.anlass
    ADD CONSTRAINT anlass_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: laufliste laufliste_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laufliste
    ADD CONSTRAINT laufliste_pkey PRIMARY KEY (id);


--
-- Name: lauflisten_container lauflisten_container_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lauflisten_container
    ADD CONSTRAINT lauflisten_container_pkey PRIMARY KEY (id);


--
-- Name: organisation_anlass_link organisation_anlass_link_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_anlass_link
    ADD CONSTRAINT organisation_anlass_link_pkey PRIMARY KEY (id);


--
-- Name: organisation_person_link organisation_person_link_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_person_link
    ADD CONSTRAINT organisation_person_link_pkey PRIMARY KEY (id);


--
-- Name: organisation organisation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation
    ADD CONSTRAINT organisation_pkey PRIMARY KEY (id);


--
-- Name: person_anlass_link person_anlass_link_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person_anlass_link
    ADD CONSTRAINT person_anlass_link_pkey PRIMARY KEY (id);


--
-- Name: person person_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- Name: rolle rolle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rolle
    ADD CONSTRAINT rolle_pkey PRIMARY KEY (id);


--
-- Name: rollen_link rollen_link_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rollen_link
    ADD CONSTRAINT rollen_link_pkey PRIMARY KEY (id);


--
-- Name: teilnehmer_anlass_link teilnehmer_anlass_link_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teilnehmer_anlass_link
    ADD CONSTRAINT teilnehmer_anlass_link_pkey PRIMARY KEY (id);


--
-- Name: teilnehmer teilnehmer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teilnehmer
    ADD CONSTRAINT teilnehmer_pkey PRIMARY KEY (id);


--
-- Name: teilnehmer_anlass_link unique_anlass_startnummer; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teilnehmer_anlass_link
    ADD CONSTRAINT unique_anlass_startnummer UNIQUE (anlass_id, startnummer);


--
-- Name: person unique_benutzername; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT unique_benutzername UNIQUE (benutzername);


--
-- Name: verband verband_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verband
    ADD CONSTRAINT verband_pkey PRIMARY KEY (id);


--
-- Name: wertungsrichter_einsatz wertungsrichter_einsatz_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wertungsrichter_einsatz
    ADD CONSTRAINT wertungsrichter_einsatz_pkey PRIMARY KEY (id);


--
-- Name: wertungsrichter wertungsrichter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wertungsrichter
    ADD CONSTRAINT wertungsrichter_pkey PRIMARY KEY (id);


--
-- Name: wertungsrichter_slot wertungsrichter_slot_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wertungsrichter_slot
    ADD CONSTRAINT wertungsrichter_slot_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: idx_anlass_aktiv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_anlass_aktiv ON public.anlass USING btree (aktiv);


--
-- Name: idx_anlass_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_anlass_deleted ON public.anlass USING btree (deleted);


--
-- Name: idx_anlass_ti_tu; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_anlass_ti_tu ON public.anlass USING btree (ti_tu);


--
-- Name: idx_laufliste_checked; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_laufliste_checked ON public.laufliste USING btree (checked);


--
-- Name: idx_laufliste_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_laufliste_deleted ON public.laufliste USING btree (deleted);


--
-- Name: idx_laufliste_erfasst; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_laufliste_erfasst ON public.laufliste USING btree (erfasst);


--
-- Name: idx_laufliste_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_laufliste_key ON public.laufliste USING btree (key);


--
-- Name: idx_lauflisten_container_anlass_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lauflisten_container_anlass_id ON public.lauflisten_container USING btree (anlass_id);


--
-- Name: idx_lauflisten_container_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lauflisten_container_deleted ON public.lauflisten_container USING btree (deleted);


--
-- Name: idx_organisation_anlass_link_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_organisation_anlass_link_deleted ON public.organisation_anlass_link USING btree (deleted);


--
-- Name: idx_organisation_anlass_link_organisation_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_organisation_anlass_link_organisation_id ON public.organisation_anlass_link USING btree (organisation_id);


--
-- Name: idx_organisation_anlass_link_person_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_organisation_anlass_link_person_id ON public.organisation_anlass_link USING btree (anlass_id);


--
-- Name: idx_organisation_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_organisation_deleted ON public.organisation USING btree (deleted);


--
-- Name: idx_organisation_person_link_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_organisation_person_link_deleted ON public.organisation_person_link USING btree (deleted);


--
-- Name: idx_organisation_person_link_organisation_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_organisation_person_link_organisation_id ON public.organisation_person_link USING btree (organisation_id);


--
-- Name: idx_organisation_person_link_person_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_organisation_person_link_person_id ON public.organisation_person_link USING btree (person_id);


--
-- Name: idx_person_aktiv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_person_aktiv ON public.person USING btree (aktiv);


--
-- Name: idx_person_anlass_link_anlass_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_person_anlass_link_anlass_id ON public.person_anlass_link USING btree (anlass_id);


--
-- Name: idx_person_anlass_link_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_person_anlass_link_deleted ON public.person_anlass_link USING btree (deleted);


--
-- Name: idx_person_anlass_link_organisation_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_person_anlass_link_organisation_id ON public.person_anlass_link USING btree (organisation_id);


--
-- Name: idx_person_anlass_link_person_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_person_anlass_link_person_id ON public.person_anlass_link USING btree (person_id);


--
-- Name: idx_person_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_person_deleted ON public.person USING btree (deleted);


--
-- Name: idx_person_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_person_email ON public.person USING btree (email);


--
-- Name: idx_rolle_aktiv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rolle_aktiv ON public.rolle USING btree (aktiv);


--
-- Name: idx_rolle_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rolle_deleted ON public.rolle USING btree (deleted);


--
-- Name: idx_rolle_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rolle_name ON public.rolle USING btree (name);


--
-- Name: idx_rollen_link_aktiv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rollen_link_aktiv ON public.rollen_link USING btree (aktiv);


--
-- Name: idx_rollen_link_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rollen_link_deleted ON public.rollen_link USING btree (deleted);


--
-- Name: idx_rollen_link_link_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rollen_link_link_id ON public.rollen_link USING btree (link_id);


--
-- Name: idx_rollen_link_rollen_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rollen_link_rollen_id ON public.rollen_link USING btree (rollen_id);


--
-- Name: idx_teilnehmer_aktiv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_teilnehmer_aktiv ON public.teilnehmer USING btree (aktiv);


--
-- Name: idx_teilnehmer_anlass_link_anlass_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_teilnehmer_anlass_link_anlass_id ON public.teilnehmer_anlass_link USING btree (anlass_id);


--
-- Name: idx_teilnehmer_anlass_link_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_teilnehmer_anlass_link_deleted ON public.teilnehmer_anlass_link USING btree (deleted);


--
-- Name: idx_teilnehmer_anlass_link_organisation_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_teilnehmer_anlass_link_organisation_id ON public.teilnehmer_anlass_link USING btree (organisation_id);


--
-- Name: idx_teilnehmer_anlass_link_teilnehmer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_teilnehmer_anlass_link_teilnehmer_id ON public.teilnehmer_anlass_link USING btree (teilnehmer_id);


--
-- Name: idx_teilnehmer_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_teilnehmer_deleted ON public.teilnehmer USING btree (deleted);


--
-- Name: idx_teilnehmer_dirty; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_teilnehmer_dirty ON public.teilnehmer USING btree (dirty);


--
-- Name: idx_teilnehmer_name_vorname; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_teilnehmer_name_vorname ON public.teilnehmer USING btree (name, vorname);


--
-- Name: idx_teilnehmer_organisation_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_teilnehmer_organisation_id ON public.teilnehmer USING btree (organisation_id);


--
-- Name: idx_teilnehmer_ti_tu; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_teilnehmer_ti_tu ON public.teilnehmer USING btree (ti_tu);


--
-- Name: idx_verband_aktiv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_verband_aktiv ON public.verband USING btree (aktiv);


--
-- Name: idx_verband_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_verband_deleted ON public.verband USING btree (deleted);


--
-- Name: idx_verband_verband; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_verband_verband ON public.verband USING btree (verband);


--
-- Name: idx_wertungsrichter_aktiv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wertungsrichter_aktiv ON public.wertungsrichter USING btree (aktiv);


--
-- Name: idx_wertungsrichter_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wertungsrichter_deleted ON public.wertungsrichter USING btree (deleted);


--
-- Name: idx_wertungsrichter_einsatz_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wertungsrichter_einsatz_deleted ON public.wertungsrichter_einsatz USING btree (deleted);


--
-- Name: idx_wertungsrichter_einsatz_person_anlass_link_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wertungsrichter_einsatz_person_anlass_link_id ON public.wertungsrichter_einsatz USING btree (person_anlass_link_id);


--
-- Name: idx_wertungsrichter_slot_anlass_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wertungsrichter_slot_anlass_id ON public.wertungsrichter_slot USING btree (anlass_id);


--
-- Name: idx_wertungsrichter_slot_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wertungsrichter_slot_deleted ON public.wertungsrichter_slot USING btree (deleted);


--
-- Name: idx_wertungsrichter_slot_reihenfolge; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_wertungsrichter_slot_reihenfolge ON public.wertungsrichter_slot USING btree (reihenfolge);


--
-- Name: uidx_laufliste; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uidx_laufliste ON public.laufliste USING btree (id);


--
-- Name: uidx_lauflisten_container; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uidx_lauflisten_container ON public.lauflisten_container USING btree (id);


--
-- Name: uidx_organisation_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uidx_organisation_name ON public.organisation USING btree (name);


--
-- PostgreSQL database dump complete
--

