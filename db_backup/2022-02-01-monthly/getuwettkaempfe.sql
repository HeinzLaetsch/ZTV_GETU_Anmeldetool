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
    melde_status character varying(20)
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
b7440787-50bd-4e41-b38b-48acf37af0de	t	f	\N	\N	Frühlings%wettkampf	Kloten	im Feld	TV Kloten	2022-04-03 00:00:00	2022-04-03 00:00:00	Tu	K1	K7	2022-01-10 00:00:00	2022-02-06 00:00:00	2022-02-06 00:00:00	2022-02-06 00:00:00	2022-03-30 00:00:00	t	CH54 0070 0110 0050 8467 0	Turnverein Kloten, 8302 Kloten	ZKB, 8302 Kloten	f	f	f
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
\.


--
-- Data for Name: organisation_anlass_link; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organisation_anlass_link (id, aktiv, deleted, change_date, deletion_date, organisation_id, anlass_id, verlaengerungs_date) FROM stdin;
3efe02eb-a70e-4729-b36a-b6be4cac01be	t	f	2022-01-10 00:00:00	\N	2fc3365b-34d9-4054-b2d8-aa859c7455e7	b7440787-50bd-4e41-b38b-48acf37af0de	\N
7808b525-9247-479a-8ace-358fe2113886	t	f	2022-01-11 00:00:00	\N	205d3aed-6ce7-4cd3-8f6d-8d222d9d59b0	b7440787-50bd-4e41-b38b-48acf37af0de	\N
cc7c4985-0d21-4884-823c-9d1f900b7936	t	f	2022-01-11 00:00:00	\N	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	b7440787-50bd-4e41-b38b-48acf37af0de	\N
f6098bf1-a1bd-4517-80af-5bf2d74f2dab	t	f	2022-01-11 00:00:00	\N	7647310f-d340-4dc7-b6d8-bda7a5716728	b7440787-50bd-4e41-b38b-48acf37af0de	\N
a11d58fb-54f9-4963-8838-a455e9e278ef	t	f	2022-01-11 00:00:00	\N	89e47949-21f1-4855-a397-20c3bc3426d7	b7440787-50bd-4e41-b38b-48acf37af0de	\N
265e3c9a-1447-4db3-8a6c-9d2b87c238d3	f	f	2022-01-12 00:00:00	\N	1fe6d9ce-05bf-4a02-81c4-53d731398880	b7440787-50bd-4e41-b38b-48acf37af0de	\N
e2d1aecf-df19-4e91-af0d-b66ca5a7bd2e	t	f	2022-01-13 00:00:00	\N	a60429c0-6964-454b-8ee1-ddad66957f06	b7440787-50bd-4e41-b38b-48acf37af0de	\N
b5fa726a-622e-46e6-9704-1403b541c596	t	f	2022-01-14 00:00:00	\N	24510313-6d39-4217-bb3f-0bfa7fbb73d3	b7440787-50bd-4e41-b38b-48acf37af0de	\N
dd86270b-ce3e-4684-a820-bcf21894f78b	t	f	2022-01-17 00:00:00	\N	e3df7bcf-4e86-48a6-92de-474fa94729a3	b7440787-50bd-4e41-b38b-48acf37af0de	\N
3bdff40b-9f83-4bfd-9023-b6bb92786683	t	f	2022-01-17 00:00:00	\N	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	b7440787-50bd-4e41-b38b-48acf37af0de	\N
6656ce9d-c8a1-46c6-8482-8d4b114d7838	t	f	2022-01-18 00:00:00	\N	773a0356-9c76-4dfb-8c56-c1693ee2819d	b7440787-50bd-4e41-b38b-48acf37af0de	\N
0391fd65-0bc1-4d59-988b-67840a038784	t	f	2022-01-12 00:00:00	\N	688a34cb-72f2-4920-aeb3-89325956de26	b7440787-50bd-4e41-b38b-48acf37af0de	\N
d2fe71a6-a21e-470a-849d-8c02a7489ad9	t	f	2022-01-19 00:00:00	\N	854e7b58-34dc-4ed5-ac6c-f233476b1e9e	b7440787-50bd-4e41-b38b-48acf37af0de	\N
b5205393-37a3-456d-9b8b-1c3f19df11a5	t	f	2022-01-20 00:00:00	\N	46e7e0a1-afa0-447b-b1a7-52302b1c5ce6	b7440787-50bd-4e41-b38b-48acf37af0de	\N
eb0307c8-5254-4ec0-8590-789c53e06bb9	t	f	2022-01-22 00:00:00	\N	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	b7440787-50bd-4e41-b38b-48acf37af0de	\N
36231896-91d1-4612-9775-c20b78db5ed2	t	f	2022-01-22 00:00:00	\N	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	b7440787-50bd-4e41-b38b-48acf37af0de	\N
fd7583ac-34c2-463d-8f37-3ba81dfb7b8a	t	f	2022-01-22 00:00:00	\N	1d2a9859-0137-4da2-8390-6cd570385ec4	b7440787-50bd-4e41-b38b-48acf37af0de	\N
3e3b719d-6d5e-4a15-8c7e-d7b35ecb9379	t	f	2022-01-23 00:00:00	\N	b490aa6f-84cd-4be3-95da-7e230d5f645e	b7440787-50bd-4e41-b38b-48acf37af0de	\N
d0edd2c5-1d76-4d04-86c8-dead036cff31	t	f	2022-01-20 00:00:00	\N	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	b7440787-50bd-4e41-b38b-48acf37af0de	\N
a42819e1-636b-4b61-aa94-e825846d82cd	t	f	2022-01-25 00:00:00	\N	d48095c7-3de5-4a8d-b893-b8d432e7c647	b7440787-50bd-4e41-b38b-48acf37af0de	\N
dfea56b7-f871-4c9f-9e86-ab7baa6a40a7	t	f	2022-01-20 00:00:00	\N	81308200-79d0-466c-a19a-ca3fbef6045a	b7440787-50bd-4e41-b38b-48acf37af0de	\N
ef99880f-0098-4f46-a9dd-7beff3aa8625	t	f	2022-01-27 00:00:00	\N	a5302a2b-d270-49e5-9876-47c84cb38038	b7440787-50bd-4e41-b38b-48acf37af0de	\N
7b35028a-8619-41e9-a6fc-128f34142989	t	f	2022-01-28 00:00:00	\N	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	b7440787-50bd-4e41-b38b-48acf37af0de	\N
7a441273-1a93-4d9c-b258-01bc5ec0354c	t	f	2022-01-28 00:00:00	\N	86a39d76-71ed-4890-82ec-ce2a48d32627	b7440787-50bd-4e41-b38b-48acf37af0de	\N
a015c1ff-0525-4863-9e1b-44048f7d704a	t	f	2022-01-21 00:00:00	\N	e2438143-6017-4683-a533-6113748d4117	b7440787-50bd-4e41-b38b-48acf37af0de	\N
3c1c436e-77fc-4d35-8f5d-25a2a8b008bc	t	f	2022-01-12 00:00:00	\N	852ccab3-35f6-4d12-815c-d8b66ff664b7	b7440787-50bd-4e41-b38b-48acf37af0de	\N
36b58997-c7e9-4fc3-a503-729e0beb61bc	t	f	2022-01-29 00:00:00	\N	80c08ccc-c90e-4377-af3b-2de779197c7a	b7440787-50bd-4e41-b38b-48acf37af0de	\N
25289562-aed4-4d6c-b222-e3d6211b5e7e	t	f	2022-01-30 00:00:00	\N	1030974d-cffe-46d6-b6ea-79c8839cf2ea	b7440787-50bd-4e41-b38b-48acf37af0de	\N
7aebf22e-1213-4f27-b00c-0fa1558daa0f	t	f	2022-01-30 00:00:00	\N	4e9262a1-fef9-4701-9c91-1b3016ee971d	b7440787-50bd-4e41-b38b-48acf37af0de	\N
b639917d-1033-49f3-b94c-d6fcdce6f48c	t	f	2022-01-31 00:00:00	\N	08bfbb88-e782-4169-83fd-17b0fd03da18	b7440787-50bd-4e41-b38b-48acf37af0de	\N
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
941bbd43-2df8-491b-a667-c7e455a8a49d	t	f	2022-01-14 00:00:00	\N	getuegg@gmail.com	Gut	Tina	078 646 34 28	getuegg@gmail.com	{bcrypt}$2a$10$aW5xGyXtg8SZPLdhTGeHJOs6hCWjs88GygbRJGSlu56KoqRTvtxRe	\N
5d5d4b80-7009-4b03-950a-be4e5e97ac7c	t	f	2022-01-14 00:00:00	\N	nicolegrau@bluewin.ch	Grau	Nicole	079 376 16 61	nicolegrau@bluewin.ch	{bcrypt}$2a$10$o7JZG/G2ZUuNV3l.JWnphujGD44Kfr1a6RZwBRrBoK7Ww.fJ9chbq	55ea0286-12cb-4e01-9d80-18977c599fa6
fa0e3750-34e6-493d-b3fc-d93b7506ab14	t	f	2022-01-14 00:00:00	\N	fritschi.reto@bluewin.ch	Fritschi	Reto	077 421 88 77	fritschi.reto@bluewin.ch	{bcrypt}$2a$10$OE5sSWAPZlGyP3A7rh4LVeGFS8TzxkHURaUdO5qgyvh8iEn3yZOJ2	24a295bd-d27e-418b-8e76-e2383d65b70d
3f855bcc-e320-4346-b97b-ab7c74bb9e35	t	f	2022-01-14 00:00:00	\N	marti_andreas@hotmail.com	Marti	Andreas	076 446 18 67	marti_andreas@hotmail.com	{bcrypt}$2a$10$jNIuGC.21ZfyzCC722H1ZOZMXukMQQqUf7eWF1A2XqQ01mIHd9xx2	c3b31c6a-fda8-41e1-9136-499c97c526ae
f05edd05-f39e-480d-b1dc-c07df0b5639e	t	f	2022-01-14 00:00:00	\N	nathalie_zatti@gmx.ch	Marti	Nathalie	079 734 42 84	nathalie_zatti@gmx.ch	{bcrypt}$2a$10$bLmTwDnIekcT4wi3JO6GHekNM7cKF0zVhR39OVS0arh3TegsKIsU2	58d5aaf6-7074-4d36-9c9e-5b62cb99164f
474b3b8c-3108-48a6-bc8f-da6ad98a062d	t	f	2022-01-14 00:00:00	\N	andrea-muellergraf@sunrise.ch	Müller	Andrea	078 880 06 40	andrea-muellergraf@sunrise.ch	{bcrypt}$2a$10$4Bg12WLo37VJgnzeLE7iAOvtruznqdf/w1cHzn.iOLLdPPki8mgLi	e225f2f3-eef9-4510-8fbf-6349bf41551d
a6c1e6df-5338-4dc4-b661-f6875b327517	t	f	2022-01-11 00:00:00	\N	balmer.marcel@gmx.ch	Balmer	Marcel	078 779 03 34	balmer.marcel@gmx.ch	{bcrypt}$2a$10$Fx3Lrlq7dXkXSxdvQlDRbueThfYJfplZ0SUa2yh3z.uW6TrdUoWDC	\N
4cbc430f-44fe-4482-8298-e8f859552e29	t	f	2022-01-12 00:00:00	\N	m.haeberling@tvobfelden.ch	Häberling	Martin	079 731 52 66	m.haeberling@tvobfelden.ch	{bcrypt}$2a$10$5P15seAI296ekdybf08FEOO5WEiy5kT26eO2JNFtIZsYbrrgFpIau	\N
ef8e38e0-7caf-4e07-87f6-8a70b77c1ff1	t	f	2022-01-12 00:00:00	\N	michi_164@hotmail.com	Rüegg	Michael	079 507 41 65	michi_164@hotmail.com	{bcrypt}$2a$10$vN9XgGr0TgARTP.0256vOe6/jyutvoNFEHL0dDBw1QT69f6fatiNG	\N
c43e58b3-e4b5-4fd5-a470-ad57d7bdf1fe	t	f	2022-01-13 00:00:00	\N	anjalanz.lanz@hotmail.com	Lanz	Anja	079 918 25 63	anjalanz.lanz@hotmail.com	{bcrypt}$2a$10$5QJK5zC3nWWCO6iPrLC6WeVWaJpHIWBheEWi92hpsUwbwSlIJ0ici	11d6f19b-dcd4-49d8-8deb-c174bc487bec
41caa163-7800-48d8-b8a5-30bedc6d861d	t	f	2022-01-13 00:00:00	\N	fisjas@bluewin.ch	Fischbacher	Jasmin	079 291 73 99	fisjas@bluewin.ch	{bcrypt}$2a$10$AFt5WDasBeS4UGduyqxQseHAMgjSsnUuodU43x1B.J./bNCyauB2S	\N
36a9a36f-0208-42ae-b879-eea8ae96d828	t	f	2022-01-13 00:00:00	\N	b.schnorf@gmail.com	Schnorf	Bettina	077 403 12 45	b.schnorf@gmail.com	{bcrypt}$2a$10$xNvrJt4fBjxhIOP/UcIS7OCXASSkE8ZPPVnr8w./pBv49j8PsiXzS	\N
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
d48a2241-8a41-403a-989c-d408bdbed5e4	t	f	2022-01-17 00:00:00	\N	beilstein@bluewin.ch	Beilstein	Marcel	079 771 55 70	beilstein@bluewin.ch	{bcrypt}$2a$10$8f7SRiKHsop8TTfJQyRhaOX9kBXRSfE9GX8VFBB53XgsBiQVAk6cC	1282d53b-1b73-4129-a7b0-4b899ffb77df
42b40986-b948-471f-9844-be6cd45e64e7	t	f	2022-01-30 00:00:00	\N	martina.gut@bluewin.ch	Gut	Martina	079 338 58 71	martina.gut@bluewin.ch	{bcrypt}$2a$10$jDifVrH9mXoEj0822bsvNuec7tev2bGETb2PMd/7X.mLQYYwgZL/G	\N
1c65ffb5-f1ce-4979-a2ce-bb0ac54f6ffc	t	f	2022-01-17 00:00:00	\N	alexa.blaser@hispeed.ch	Blaser	Alexa	079 849 05 09	alexa.blaser@hispeed.ch	{bcrypt}$2a$10$2Yj7oXmCi8lxM.8QF6lbFe/Xwsqc2pEm6.AZ3E000rHAYjTvcLCXG	808eb6bd-7acf-47e3-a420-6bf5c2b42811
d716fa96-59e6-46c7-90a1-32583e8a4253	t	f	2022-01-17 00:00:00	\N	daniel.blaser@hispeed.ch	Blaser	Daniel	079 238 38 68	daniel.blaser@hispeed.ch	{bcrypt}$2a$10$ro6hMzkqIkuKsEvgXOXA7OCk1Ui/NAyMfj1SZzvP24upHmvcItOii	03cf3b2b-c8e6-453b-93aa-94c033de0a56
c1ff2734-9478-4747-aa67-d84cf087868e	t	f	2022-01-17 00:00:00	\N	katja.berger@bluewin.ch	Berger	Katja	079 827 75 80	katja.berger@bluewin.ch	{bcrypt}$2a$10$8wWDW0N8nEfjEd/o5z2NL.PcPbDxN28FezW3x4p33aQ4zGaC/vox6	7f72cfc5-9d91-4f88-97a1-ab0ed4165b40
4aafd813-b46a-4496-a5c1-6104cf8511dd	t	f	2022-01-17 00:00:00	\N	dani.bucher5@gmx.ch	Bucher	Daniel	076 323 31 05	dani.bucher5@gmx.ch	{bcrypt}$2a$10$Qif5PSl9AzVUxKH8zx8oOuWWpa8xnrYhnZGerWIWw4g058qmQjoie	a269e0d3-5d9c-4255-b717-587ca45d1e1e
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
f7aa7d0a-58c8-4781-b8bd-0af1bf4615bd	t	f	2022-01-18 00:00:00	\N	loredana.divito@gmx.ch	Di Vito	Loredana	078 899 69 35	loredana.divito@gmx.ch	{bcrypt}$2a$10$6v4MnmiDy7bQU41ngbpfZ.KuCH3PumAzMB53OA6oXT6W1CS2jyIQK	bd223d1e-cedf-4857-b987-db2cf873adc6
70870a17-d0c2-45be-ab72-3a819b3c7673	t	f	2022-01-18 00:00:00	\N	leandro.gschwend@gmail.com	Gschwend	Leandro	076 534 81 88	leandro.gschwend@gmail.com	{bcrypt}$2a$10$l9xv5WtsdTCTuiw972T84.qm2gqVMUWzpTavGs583iE1q6ERIMGLm	0d87abbb-f023-46aa-b54c-0cc9a29b6bab
974578c2-33f3-494d-93e6-eea345ef6d22	t	f	2022-01-18 00:00:00	\N	noella_kadi@hotmail.com	Steiner	Noella	079 629 20 69	noella_kadi@hotmail.com	{bcrypt}$2a$10$//E6zLlQakvUWOi7I1E5x.pV9RJM9JcqyKHn4eRvWNS7deNTJsuGS	bddf55dd-9387-43b5-861d-b5e1e359865a
c403ff2f-1f49-49f8-87b9-2563f163a437	t	f	2022-01-18 00:00:00	\N	molin.virginia@gmail.com	Molin	Virginia	078 821 15 53	molin.virginia@gmail.com	{bcrypt}$2a$10$cqWjWY0FS3Fk38z/9KR0vOcRb6hVDUdmCZWO15eS.vYqocq3W9LkS	0316605b-ab44-49f8-8f4b-852396cf79c0
06e1270e-8eda-4790-a920-7a4089869c7d	t	f	2022-01-18 00:00:00	\N	winkler.lia@gmail.com	Winkler	Lia	076 514 69 80	winkler.lia@gmail.com	{bcrypt}$2a$10$TNBBdOjMGRreGZEhUwOQf.OeAaE9yfloxCS/LvG6Ki8Cozf8P.8uC	c0c86210-ac0c-49d3-a972-014220541613
0aa96d4f-62c3-47e3-8b8f-94809f66f05a	t	f	2022-01-23 00:00:00	\N	f.odi@hispeed.ch	Odermatt-Paratte	Fabienne	079 340 30 03	f.odi@hispeed.ch	{bcrypt}$2a$10$VAxqvxmvDIfnmTtOr0MKWOFQ5WJYYuers23wS/u7sgZ3suCxg5Nu6	6a117951-ca80-44d0-b363-83982679e70b
17ed84be-4dcd-4fab-baf8-40c3c422dcc0	t	f	2022-01-23 00:00:00	\N	cschnorf@hotmail.com	Schnorf	Carmen	079 768 93 94	cschnorf@hotmail.com	{bcrypt}$2a$10$UBvSGftj24KAGgft3ulwA./FVbtkn002PgZGLtaZE97DpeAGDaREq	7b31dfc8-e2fa-4061-8be8-e5ccb99c7845
c20621d6-69c7-403b-98af-658229c9c45d	t	f	2022-01-18 00:00:00	\N	n.schneider91@hotmail.com	Schneider	Nathalie	079 427 49 01	n.schneider91@hotmail.com	{bcrypt}$2a$10$wfVGDuTYUrYA42HPGH2ksO6W8t17JqpIumfakY5qS95vEcu0OhxVW	\N
825576b7-1723-4c59-ab5f-1a4fd04c0d72	t	f	2022-01-18 00:00:00	\N	m.niederhauser@drobfelden.ch	Häberling	Melanie	079 675 46 64	m.niederhauser@drobfelden.ch	{bcrypt}$2a$10$dmFIm96/pzO3IRLkstuSxOMPZKQxbo8BSEySSiPVbdK0dRbNjnRWy	abe50fa3-2ef4-4d18-96bb-f488174e5010
93851cba-8452-4b98-a25c-972fdb42c5cd	t	f	2022-01-18 00:00:00	\N	stephan.nie@bluewin.ch	Niederhäuser	Stephan	079 207 59 37	stephan.nie@bluewin.ch	{bcrypt}$2a$10$uneFrIHJ94Eybcv15hEq1OerifBRZ.6ReZT9Fmu86hVuIKEvwCHwq	a8e3fdb1-84b5-455d-9938-4993a33e7107
e422a46c-df51-4aa4-bb5c-9b5b5f29e67d	t	f	2022-01-18 00:00:00	\N	nico.nussbaumer@bluewin.ch	Nussbaumer	Nico	079 890 57 10	nico.nussbaumer@bluewin.ch	{bcrypt}$2a$10$xCwEyOqkyPk8UbTKnDe25O6X1LK1BUW.ixHELJcqH2vAHLbJxUmOa	cb31d7ef-447f-480f-95e0-903acf1a7c2c
3f56cd5a-ed1f-488b-aac7-752be8053a11	t	f	2022-01-18 00:00:00	\N	corina.stutz1997@hotmail.com	Stutz	Corina	078 894 88 98	corina.stutz1997@hotmail.com	{bcrypt}$2a$10$81mm1Y8Qftnoz6IWFveyc.TGMwBCZzXntHGyHAo8g/XjGGhv6rtma	87aa4ad5-0e6f-4ed5-9752-ab3f4032f303
b07891d6-22bb-453c-806c-ddb503bde0c1	t	f	2022-01-29 00:00:00	\N	roland_denzler@bluewin.ch	Denzler	Roland	079 729 19 93	roland_denzler@bluewin.ch	{bcrypt}$2a$10$Wo.W7N4wnhaoLdiYsc2/Ley0hNHMyg/nfF9HqFkvIoeT96hgrNlJ.	73abcba3-f820-432f-8afd-06d0f9acb239
1a80a988-db22-4991-a676-091f902279c3	t	f	2022-01-19 00:00:00	\N	i-sennhauser@datazug.ch	Sennhauser	Ilona	079 844 24 14	i-sennhauser@datazug.ch	{bcrypt}$2a$10$34/Whdwom7q3FVnIc2qIW.T7WudnuG/HZ1ci8wK6kLpzVAJM0FXlu	9c878988-8ead-4324-97d6-f7816b2da273
7f800a3c-a073-45e2-9a19-88cbb30d409b	t	f	2022-01-19 00:00:00	\N	m.c.heule@bluewin.ch	Heule	Marco	079 289 30 60	m.c.heule@bluewin.ch	{bcrypt}$2a$10$InAnCaWXFuI8Znim6M.ocOiTiptOtbj2fg5QHoPwUywZoLUyYeoVC	\N
77ecdfbf-9452-4404-92c1-fa0841e51591	t	f	2022-01-20 00:00:00	\N	mischim@gmx.ch	Meier	Michel	079 306 27 41	mischim@gmx.ch	{bcrypt}$2a$10$iuIkod8zHs440IWRjQQDJOxq40gkrm7iAtGUzczaNRDgfx6vNq5bO	\N
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
2155cb46-c288-46f7-afa4-6637e6f35b60	t	f	2022-01-31 00:00:00	\N	Svenja.riedo@tv-rheinau.ch	Riedo	Svenja	079 132 08 48	Svenja.riedo@tv-rheinau.ch	{bcrypt}$2a$10$7RE3bKL/PiaYNjwQm8xxUup3auxiFfwCQyNuOY85T8ZR2nyocauUe	\N
bd872f00-9dea-4026-9711-00439a28b4f4	t	f	2022-01-31 00:00:00	\N	liv.hoch@gmail.com	Hoch	Livia	076 391 08 50	liv.hoch@gmail.com	{bcrypt}$2a$10$yHzid06okB9H2SW.AkY0pOhst7/ILF2mfGuw.yMb/xr9uqMwlsCJq	7f4fd554-63c7-4c17-8411-84d24bd6971b
f8cbc6eb-b99a-464a-b9d4-bfb495f70830	t	f	2022-01-31 00:00:00	\N	angela.renk@bluewin.ch	Renk	Angela	079 643 32 63	angela.renk@bluewin.ch	{bcrypt}$2a$10$5693mvAg.cifLl3u39f0TuzCCxN8UXakffLkblDxLOemBgMG9cgkW	71f89f96-2ca5-4dfd-9257-643a27e4af56
38b4fe63-43b0-463f-8730-4a5908d0decf	t	f	2022-01-31 00:00:00	\N	khaenni@bluewin.ch	Hänni	Karin	079 728 39 69	khaenni@bluewin.ch	{bcrypt}$2a$10$.ZcCzIYgtw6Y4M3wy2acy.UHDzTVxOEH4fDSlhAf2n4VmufP3U5W2	66df5d28-a3d9-4a02-9eab-8d7d10d93e28
3552e5c0-b13f-4fb2-8a75-ceb6ef4cf677	t	f	2022-01-31 00:00:00	\N	carla.pfister@bluewin.ch	Pfister	Carla	077 412 04 83	carla.pfister@bluewin.ch	{bcrypt}$2a$10$HMk8qRz/Q28ZwC5F4GnFJuqiOJOrfuI8iG5rfVgZlVFNIutBfHeq2	dbf29cac-3dac-4b53-98ce-79d85b81e743
26a9d8c1-3d57-455d-81f1-e25a0fec7c71	t	f	2022-01-31 00:00:00	\N	se.pfister@bluewin.ch	Pfister	Selina	077 414 24 79	se.pfister@bluewin.ch	{bcrypt}$2a$10$Feq3m33iCeTNfnd8rin/yuCxpGMpwbX0UJ88.TUl3GVQ5rGzoNWoK	316b4b23-7943-472e-9512-58fc92a03023
3ec16c8b-1656-4c98-83f2-92de26adba79	t	f	2022-01-22 00:00:00	\N	getu.bonaduz@gmail.com	Schoop	Seraina	079 541 20 40	getu.bonaduz@gmail.com	{bcrypt}$2a$10$ROIN.axDnFTAfDKlC8f8huIBYOcrflMHzM9kUcBoJEKf8eTA4vQoS	\N
2d825100-4593-45a1-b486-2670cb27eb1c	t	f	2022-01-22 00:00:00	\N	fetzfrei@bluewin.ch	Frei	Cornelia	079 548 65 36	fetzfrei@bluewin.ch	{bcrypt}$2a$10$DpLABFj.lcnThZMHx0TDROZuhiOC2HqseEpwpxk5iudUDaUcJ9.Wq	55d42f0d-2538-4934-96ef-08a6973d28a8
3680433a-ff79-4a68-9715-44563de86317	t	f	2022-01-22 00:00:00	\N	steinkamp.dagmar@t-online.de	Steinkamp	Dagmar	077 458 37 56	steinkamp.dagmar@t-online.de	{bcrypt}$2a$10$sLdm3bdP7xQ2SfQQVsMcA.0qzKzaquB0Rr6LPEDm8fRr4R0zkF9LG	2b34e952-0e96-4b21-acb7-3909ca15bf36
db8ee7df-c8f5-4aec-a78f-72ea750ba251	t	f	2022-01-22 00:00:00	\N	michaelsteinkamp@gmx.net	Steinkamp	Michael	078 734 15 50	michaelsteinkamp@gmx.net	{bcrypt}$2a$10$S9bYV/l83KBB/sq7AHQhj.q27RrWAh6b1daOu0oaWWk2AKdwCgweu	40ed7853-4ab7-4ec5-8c76-8234b213f1c2
7a330c16-06a5-428c-a46d-1b70bdd2ec56	t	f	2022-01-22 00:00:00	\N	tim.wisotzki@protonmail.com	Wisotzki	Tim	077 427 87 61	tim.wisotzki@protonmail.com	{bcrypt}$2a$10$Fq7Xlo0tblr8zQBrSXFt/ev9eejUiXpsOqGYQe34b.6x2pUJgPz6i	c7b16e0c-d58f-453f-87bd-2aa072c4d720
3b2954f5-a0c6-419a-8e5b-0e48dc81f042	t	f	2022-01-22 00:00:00	\N	meli.bauert@gmail.com	Bauert	Mélanie	076 816 23 27	meli.bauert@gmail.com	{bcrypt}$2a$10$OZABxd0tgX0qZOlPJZ/i.OrgSMD0tETAcD2CilkaTSWf.YWHw2.X.	8d7c3344-1d86-419a-9fc8-cb772b44b053
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
ca7098f4-74b7-468c-a84c-b54fdd5ae7a0	t	f	2022-01-19 00:00:00	\N	e422a46c-df51-4aa4-bb5c-9b5b5f29e67d	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	\N
1b09a2b6-608d-4cad-9c90-afc571719ec9	t	f	2022-01-20 00:00:00	\N	17ed84be-4dcd-4fab-baf8-40c3c422dcc0	b7440787-50bd-4e41-b38b-48acf37af0de	81308200-79d0-466c-a19a-ca3fbef6045a	\N
ac2e21a4-71b3-41cb-b58c-934e4b2ed379	t	f	2022-01-22 00:00:00	\N	07a30ce1-69bd-406a-9f46-5b790f2b5f77	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N
4740cbad-b322-4404-bfcf-15a610a8eb28	t	f	2022-01-22 00:00:00	\N	d51f134d-0515-4910-a830-441f701f687e	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	\N
502e5d08-99d0-4c02-ba3a-97d9b32573d7	t	f	2022-01-22 00:00:00	\N	2d825100-4593-45a1-b486-2670cb27eb1c	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	\N
3ef17816-a379-409a-82a6-72e27cc1c27d	t	f	2022-01-22 00:00:00	\N	db8ee7df-c8f5-4aec-a78f-72ea750ba251	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	\N
502d0064-4c0b-48e0-b65d-5c7fd8e98743	t	f	2022-01-22 00:00:00	\N	7a330c16-06a5-428c-a46d-1b70bdd2ec56	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	turnt selber K7
03651ead-49ea-44db-ae99-b2a6662395d8	t	f	2022-01-23 00:00:00	\N	0aa96d4f-62c3-47e3-8b8f-94809f66f05a	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	\N
8c890fc1-d923-475a-9ab3-e4f0da2ae141	t	f	2022-01-24 00:00:00	\N	061f1886-4c55-442e-8b39-105a494a09ad	b7440787-50bd-4e41-b38b-48acf37af0de	e2438143-6017-4683-a533-6113748d4117	\N
18e6085e-c262-4b5d-8c90-456a2fede68b	t	f	2022-01-24 00:00:00	\N	5027e4f7-6222-46bc-8972-6e76a136c3bd	b7440787-50bd-4e41-b38b-48acf37af0de	e2438143-6017-4683-a533-6113748d4117	betreut K5
139bda20-16a4-44ef-b6d9-242b83b346e9	t	f	2022-01-25 00:00:00	\N	35e7e6fe-5d65-4d2c-aa85-f4a127c8a74a	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	\N
ded825f7-c72c-4a66-ba66-0a7a7d065b27	t	f	2022-01-27 00:00:00	\N	b2736bf3-6d33-439a-906b-d19ed002190b	b7440787-50bd-4e41-b38b-48acf37af0de	a5302a2b-d270-49e5-9876-47c84cb38038	\N
07339662-3fb8-4def-ad79-ee1b90117609	t	f	2022-01-28 00:00:00	\N	7e1bb369-f7fd-4182-8a78-60964391c46d	b7440787-50bd-4e41-b38b-48acf37af0de	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	betreut K6
756d6695-f5d1-4d02-9380-bf0493c52177	t	f	2022-01-29 00:00:00	\N	4d82dad7-7c7e-476a-bdb2-7a7a52d7ac6f	b7440787-50bd-4e41-b38b-48acf37af0de	a5302a2b-d270-49e5-9876-47c84cb38038	\N
17f7ed34-d962-4748-a531-fbc92ed61244	t	f	2022-01-29 00:00:00	\N	f255be7f-d6da-42f8-97b0-80aefbbfd52d	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	\N
583d881a-f4cc-4db8-9555-81b04b9fde4e	t	f	2022-01-29 00:00:00	\N	6b94806e-bc8f-4ea0-99b9-5397759bc338	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	\N
cdd574c4-d259-431a-aa73-e64178cfed2e	t	f	2022-01-29 00:00:00	\N	ccb1b8b9-7393-41ac-81a4-91aee3517aef	b7440787-50bd-4e41-b38b-48acf37af0de	80c08ccc-c90e-4377-af3b-2de779197c7a	\N
1cf6483c-4981-41fb-be23-79e8c6a905ee	t	f	2022-01-19 00:00:00	\N	825576b7-1723-4c59-ab5f-1a4fd04c0d72	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	Leiter K3 Turner, kein Barren und Reck, Danke
91837aad-3d46-4a4e-9e60-2fa73c57cc24	t	f	2022-01-30 00:00:00	\N	6b444e83-c271-4879-8b02-367cf035ca96	b7440787-50bd-4e41-b38b-48acf37af0de	4e9262a1-fef9-4701-9c91-1b3016ee971d	\N
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
bee12d92-3d04-4132-ba76-b6b99705233d	t	f	2022-01-17 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	2ae27d51-f415-4a27-9f31-fa4fd15e4a64
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
a92dc1ad-550c-4c97-8862-2792494d1fbe	t	f	2022-01-18 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	ca88f262-8a4e-44e5-a31c-987421defc9d
d6fe1a69-8d71-4618-91c3-866245e8e39a	t	f	2022-01-18 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	5156a07f-fada-4501-b66c-a1b092091572
b4504b2d-f392-4e94-91b7-11c8fcd9de3a	t	f	2022-01-18 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	e2d41d40-0d0b-46ed-a123-cfc5e53dee94
eaaa3c9e-5eae-43cf-ace5-31a105cf8c78	t	f	2022-01-18 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	d9e9d3dc-58d6-4db5-93c9-2b89fbf6cd79
9ad1b15a-4790-4d0f-aa21-c3c3ce49461c	t	f	2022-01-18 00:00:00	\N	0f586f41-d58a-4381-936c-0e9f589a2573	41ce08da-3362-46cb-90e4-8d361359fd7b
bec60f49-6c86-45c2-b8b7-179b06d838a2	t	f	2022-01-18 00:00:00	\N	d3da3664-0d4d-42e6-9581-366691c82ea6	19d9bee9-7c4d-4c5e-8eaa-8ac5051c935e
71f24e9a-5e98-4e2c-9c89-e521891968f4	t	f	2022-01-18 00:00:00	\N	cf79ac25-e412-4561-9bcb-4f392a11ca18	19d9bee9-7c4d-4c5e-8eaa-8ac5051c935e
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
bae3a9db-b953-4384-9967-b6a695a40b35	f	f	2022-01-12 00:00:00	\N	Lanz	Anja	2000	\N	0	1fe6d9ce-05bf-4a02-81c4-53d731398880	f
1b4854d8-20ad-4930-b1c3-3240dc956831	f	f	2022-01-14 00:00:00	\N	Grau	Cédric	2013	2463794	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
f927df83-a6e2-4397-8912-3fcbbd640ebb	f	f	2022-01-11 00:00:00	\N	Barry	Lisette	2014	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
40ccb443-9e71-4f3c-937d-eb6d1d336e26	f	f	2022-01-11 00:00:00	\N	Kessler	Isabel	2013	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
b611df06-6517-4a13-a70a-6dbe3ed8eae2	f	f	2022-01-11 00:00:00	\N	Nussbaumer	Vanessa	2015	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
497a8eac-0bc3-416a-93bc-fc063eab0fcf	f	f	2022-01-11 00:00:00	\N	Huber	Joelle	2014	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
c623ec2a-e96c-469a-be6c-8cfa166cfe46	f	f	2022-01-11 00:00:00	\N	Plaz	Jaël	2013	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
9dbb066d-047c-41ed-b241-2c58091e6817	f	f	2022-01-11 00:00:00	\N	Muntwyler 	Jaël	2014	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
e4565881-aa88-4903-88fe-5cbbae005638	f	f	2022-01-11 00:00:00	\N	Müller	Emma	2012	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
481a3cb4-cb26-4227-8463-ee717c8db0ac	f	f	2022-01-11 00:00:00	\N	Kessler	Melissa	2011	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
c1811d92-27e1-4af9-aadf-c37c470d786f	f	f	2022-01-11 00:00:00	\N	Hug	Leandra	2013	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
355bba95-fd6a-4508-874f-4b12b4ac7259	f	f	2022-01-11 00:00:00	\N	Kara	Nelejoline	2013	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
92613163-8bfc-4490-aa2d-af64c7a4fc72	f	f	2022-01-11 00:00:00	\N	Fierz	Anja	2012	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
af92249a-5a95-4e07-8ad2-2eadfb148c3d	f	f	2022-01-11 00:00:00	\N	Walter	Aliena	2013	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
719b1561-8685-475a-9a8e-c4ae01c947ee	f	f	2022-01-11 00:00:00	\N	Müller	Frida	2012	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
75a9b37c-1f59-4dbc-8ef0-64397367e520	f	f	2022-01-11 00:00:00	\N	Sulzberger	Anik	2014	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
0a2ba450-116d-4b86-828e-8d848a39de40	f	f	2022-01-11 00:00:00	\N	Waldvogel	Larissa	2010	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
b3f9bd7c-c964-484f-ba2a-eed971e6302e	f	f	2022-01-14 00:00:00	\N	Grau	Marc	2015	2587071	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
dacbe400-de12-41ae-b085-1539b49f1d84	f	f	2022-01-14 00:00:00	\N	Lüthi	Laurin	2014	2463787	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
1ae54287-50bc-45bc-9b79-1b5f19f5d85b	f	f	2022-01-14 00:00:00	\N	Williner	Yago	2014	2463774	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
8f5bdaeb-1b7f-4994-a0e0-6094b5c58ead	f	f	2022-01-11 00:00:00	\N	Egli	Chiara	2010	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
3b53d27e-8915-44f0-a835-3d09a6e0cf53	f	f	2022-01-11 00:00:00	\N	Hug	Annina	2011	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
3d826b0d-3d90-4afe-85ad-b4c14ad92e98	f	f	2022-01-11 00:00:00	\N	Guarnuto	Diana	2011	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
a49caede-ef45-4644-8651-e0c20981003a	f	f	2022-01-11 00:00:00	\N	Ward	Shayanne	2011	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
73d1c77a-a7bf-4b00-9ddf-7056f107817e	f	f	2022-01-11 00:00:00	\N	Walser	Sarina	2011	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
a51724a5-36ba-4443-a13e-c708ae7a6238	f	f	2022-01-11 00:00:00	\N	Schoch	Leonie	2008	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
b8fb2865-aa6b-4391-aeee-8db904eedf28	f	f	2022-01-11 00:00:00	\N	Huber	Michelle	2008	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
92f57cee-d46b-4050-ad58-23de93dec16e	f	f	2022-01-11 00:00:00	\N	Thalmann	Anja	2011	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
15b80964-2809-4c3b-9325-f20ae4930434	f	f	2022-01-11 00:00:00	\N	Muntwyler	Lena	2010	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
d629ae8e-527f-43bb-9acb-1de7b10ca838	f	f	2022-01-11 00:00:00	\N	Schätti	Anina	2005	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
4360e314-ea32-496c-8657-c9bb8058b0ea	f	f	2022-01-11 00:00:00	\N	Müller	Alice	1995	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
4704aded-5bfb-4e70-b381-cf912524859a	f	f	2022-01-11 00:00:00	\N	Tribastone	Luana	2004	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
804ce147-8367-45a2-b4a4-6109ebdbfff3	f	f	2022-01-11 00:00:00	\N	Walser	Jana	2008	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
8c8c1d3b-60d8-4b8d-9489-2303f5e7830c	f	f	2022-01-11 00:00:00	\N	Nicoli	Sabrina	2004	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
a0cfcf47-0969-4b2c-982f-b7707c2c0a53	f	f	2022-01-11 00:00:00	\N	Nyffenegger	Elisa	1997	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
75b7f508-ab0d-4b64-ae47-bc251362c013	f	f	2022-01-11 00:00:00	\N	Zarth	Naomi	2000	\N	0	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
208cba42-90ab-4392-a889-770f7e5371a5	f	f	2022-01-11 00:00:00	\N	Breitrück	Cornelius	2009	3448483	1	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
6c96f71b-45c5-437b-88e2-cf38bfa5cead	f	f	2022-01-11 00:00:00	\N	Waldvogel	Kilian	2012	3253627	1	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
ce7cef74-724f-47d5-8b37-61dec7354c21	f	f	2022-01-11 00:00:00	\N	Breitrück	Marius	2014	3526270	1	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
43d79d88-2bfb-4899-9635-87db5b1ebb4d	f	f	2022-01-11 00:00:00	\N	Seeli	Laurin	2010	3109365	1	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
6699bdaf-f027-45bd-9f8e-cc9e1596e57e	f	f	2022-01-11 00:00:00	\N	Mezger	Sven	2012	3252622	1	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
136d2b74-98c9-41c3-85cb-b41c62d7c2cc	f	f	2022-01-11 00:00:00	\N	Huber	Dominic	2012	3149037	1	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
1ace9385-c200-4162-b8f2-ee20a21de12b	f	f	2022-01-11 00:00:00	\N	Zuppiger	Leandro	2011	3152487	1	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
ecd18d1b-5ff9-402b-acb0-a7c024d7405a	f	f	2022-01-11 00:00:00	\N	Jaussi	Silvan	2004	880226	1	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	f
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
26636a78-0791-4c4d-87fb-5e6a1027c123	f	f	2022-01-20 00:00:00	\N	Hintermann	Nils	2012	2332786	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
0985ba77-7d82-42ac-b749-b4038d98499b	f	f	2022-01-17 00:00:00	\N	Ouattara	July-Mae	2010	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
c89c90ff-9a8c-4b8c-94fe-f21a96938dd9	f	f	2022-01-17 00:00:00	\N	Senn	Ninetta	2007	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
c04c3b69-b53a-4134-b259-8d42af89df98	f	f	2022-01-17 00:00:00	\N	Heinz	Sanja	2007	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
4cfc24a3-1f5b-4aad-bc7c-3a9b25338fc0	f	f	2022-01-17 00:00:00	\N	Hunziker	Luana	2007	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
a882acde-5494-41cd-99e4-b0a2a1f1eef4	f	f	2022-01-17 00:00:00	\N	Baur	Zoë	2009	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
7339e402-4a3a-4298-ae18-c97cf15433d1	f	f	2022-01-17 00:00:00	\N	Torriani	Emilia	2006	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
b3851896-99a8-409e-933e-f8d3d9ff018f	f	f	2022-01-17 00:00:00	\N	Hering	Noa	2006	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
fa9887e0-680c-479a-8ac7-3c8f2e3f4769	f	f	2022-01-20 00:00:00	\N	Grenacher	Oskar	2011	2063959	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
6be7d65d-fba8-42a4-89b7-2c666d713306	f	f	2022-01-17 00:00:00	\N	Hunziker	Naomi	2005	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
6e648320-a8bc-4ce8-80ff-7c0fc4fc7c17	f	f	2022-01-17 00:00:00	\N	Akveld	Lena	2013	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
25718b42-a27c-4fb2-b9a3-0a012e44f6c3	f	f	2022-01-20 00:00:00	\N	Murgo	Ilyas	2012	2521932	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
ad2f61d2-31e6-4bb8-b6c6-23d4df98a103	f	f	2022-01-17 00:00:00	\N	Von Arx	Cosima	2004	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
52844f4d-5604-4615-b371-6fb99a57c626	f	f	2022-01-17 00:00:00	\N	Morbach	Elena	2002	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
fcd79d30-7590-46b9-b332-b0f30f373753	f	f	2022-01-20 00:00:00	\N	Stergiou	Jannis	2012	2254046	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
95f4fd85-29e4-44f2-a8db-c8295819a339	f	f	2022-01-17 00:00:00	\N	Gassmann	Nadine	2002	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
cb21ee21-052c-46cc-a234-80b7930f82e7	f	f	2022-01-17 00:00:00	\N	Brichet	Felice	2010	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
54b689dc-9aa3-43f8-9561-08becceb99c5	f	f	2022-01-17 00:00:00	\N	Bucheli	Babette	2010	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
6e92ebdf-7eaa-4d9f-b82d-bdc647c19670	f	f	2022-01-17 00:00:00	\N	Businger	Laura	2013	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
ba61a7bb-2162-4e6d-8951-f97e8972fb03	f	f	2022-01-17 00:00:00	\N	Blaser	Yanis	2005	682619	1	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
dbfa3cb3-f422-4d5b-a506-e745ef4f8ac5	f	f	2022-01-17 00:00:00	\N	Wieland	Mike	2013	3333502	1	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
691c3b72-32c7-4c84-bac6-025d7afc2654	f	f	2022-01-17 00:00:00	\N	Britt	Niwes	2010	3153517	1	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
6247b048-7eff-40f7-a159-0a799e31b694	f	f	2022-01-17 00:00:00	\N	Enzler	Naviin	2011	3197559	1	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
5f6d8771-f6b1-482f-9e6c-87448c63dfdc	f	f	2022-01-17 00:00:00	\N	Britt	Fionn	2014	3512177	1	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
2fac7e69-8bcc-44f6-aa39-17c3ca51a89c	f	f	2022-01-17 00:00:00	\N	Sieber	Louis	2011	3426640	1	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
e49aadfa-195f-4c25-b698-812bfdadb682	f	f	2022-01-17 00:00:00	\N	Eichenberger	Yves	2009	3046138	1	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
57454bda-dac9-44db-96a5-0912760e67bc	f	f	2022-01-17 00:00:00	\N	Bruderer	Nico	2006	893118	1	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
73edd0ac-2789-415c-9a52-25b554526e8e	f	f	2022-01-17 00:00:00	\N	Britt	Levin	2008	3046137	1	e3df7bcf-4e86-48a6-92de-474fa94729a3	f
f11b1e27-f72d-49a1-8a81-f74047503942	f	f	2022-01-17 00:00:00	\N	Horber	Helena	2000	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
d937d2c4-390f-4509-835b-0f8a2a0ec53d	f	f	2022-01-17 00:00:00	\N	Hufnagel	Kai	2007	3024636	1	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
f2de432e-1b6e-437c-9804-09b688998682	f	f	2022-01-17 00:00:00	\N	Akveld	Tim	2010	3159037	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
27316a2b-be20-426c-b73f-ff55d3b38cc7	f	f	2022-01-17 00:00:00	\N	Schlund	Kai	2013	3466585	1	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	f
7fbef750-5342-46de-a37a-56293f421ce8	f	f	2022-01-17 00:00:00	\N	Hintermann	Aisha	1999	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
8d2c0dc4-2b4e-4019-8a1d-ff480e879d3e	f	f	2022-01-17 00:00:00	\N	Molin	Virginia	1999	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
ff7b1805-07a7-40d6-9cba-f57d8141a730	f	f	2022-01-17 00:00:00	\N	Gassmann	Sibylle	1999	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
8b34d423-ada0-4bec-9cc8-d47e9e220780	f	f	2022-01-17 00:00:00	\N	Heeb	Natalie	2001	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
59342cf9-fc49-476d-8c45-3854bd896c8a	f	f	2022-01-17 00:00:00	\N	Winkler	Lia	1999	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
5d0f0123-6f6f-43dc-8946-60b03375a87d	f	f	2022-01-17 00:00:00	\N	Rüegg	Sonja	1999	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
9101091b-5a65-4a04-8b23-9deacce2a7ac	f	f	2022-01-17 00:00:00	\N	Crola	Gianna	2009	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
b7cfcd59-bb9b-4e1d-b59f-e9522d84ead8	f	f	2022-01-17 00:00:00	\N	Crola	Edda	2011	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
0485d367-39ac-444f-8256-530e2248c9e0	f	f	2022-01-17 00:00:00	\N	Caiocca	Matilde	2012	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
f15aa673-3039-494a-8187-47745bf73bdb	f	f	2022-01-17 00:00:00	\N	Studer	Paciane Bo	1995	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
e6c51a7f-2f1f-44d2-8974-f3a222018f30	f	f	2022-01-17 00:00:00	\N	Da Costa	Soraia	2014	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
4c44b26b-75b5-454a-9523-d1a13668c60b	f	f	2022-01-17 00:00:00	\N	Di Vito	Loredana	1996	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
4beded93-5981-417a-81ff-9b895474383f	f	f	2022-01-17 00:00:00	\N	D'Altri	Fynn	2013	3344883	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
384e4454-f2f9-4765-969b-b97210848672	f	f	2022-01-17 00:00:00	\N	Ruosch	Melanie	1988	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
0af9f6c2-0b45-4f0f-a0cf-41da23b67aeb	f	f	2022-01-17 00:00:00	\N	Gut	Mara	2011	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
4a26fee1-2e72-4c02-a2da-a48208956430	f	f	2022-01-17 00:00:00	\N	Gonnet	Lisa	2013	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
23c379ab-5c86-479c-94e0-e1cbd5164acc	f	f	2022-01-17 00:00:00	\N	Tondi	Timea	1993	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
451ddc55-c9c9-41de-b0b7-b3e99481c753	f	f	2022-01-17 00:00:00	\N	Gyenes	Leonie	2012	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
d95b8556-fa44-41e0-a8d1-e0cb288ea4cd	f	f	2022-01-17 00:00:00	\N	Schneider	Nina	1985	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
2f8bf907-d6f0-416b-abe2-46560b143b06	f	f	2022-01-17 00:00:00	\N	Covelli	Livio	2007	3018113	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
877359bb-d323-4184-b585-65c4c84a72b5	f	f	2022-01-17 00:00:00	\N	Krauer	Soé	2014	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
8c213cc6-47a1-4a94-9800-7e050e398ca9	f	f	2022-01-17 00:00:00	\N	Pfenninger	Juno Leah	2011	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
1feccc39-8bfc-4843-964e-76d4bb345bd2	f	f	2022-01-17 00:00:00	\N	Moser	Felix	2010	3276523	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
68cf41f0-88d3-4d35-bb68-c02b8150bc3c	f	f	2022-01-17 00:00:00	\N	Schaffhauser	Thomas	1991	561128	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
76b99e2d-c1f5-457f-bace-a59f6f019dc6	f	f	2022-01-17 00:00:00	\N	Schärer	Noel	2004	915221	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
b1857a1f-6ce6-4c3e-ab1b-603a6d854d43	f	f	2022-01-17 00:00:00	\N	Flückiger	Severin	2002	664267	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
9ae29252-dfb9-4f54-b9bf-acd7f963280f	f	f	2022-01-17 00:00:00	\N	Quarta	Lina	2015	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
20d2b026-f247-40fd-86fa-b8079c8810e6	f	f	2022-01-17 00:00:00	\N	Suter	Cloé	2009	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
cf92e3e7-201f-4998-9415-af34fe635aea	f	f	2022-01-17 00:00:00	\N	Richter	Greta	2014	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
e9588bcb-50c5-4d6c-806c-f3afbd3124ed	f	f	2022-01-17 00:00:00	\N	Sciskala	Stanislaw	2014	3466343	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
127bc2eb-3b88-4e28-b285-da2c87200b9b	f	f	2022-01-17 00:00:00	\N	Wolski	Lucian	2012	3344887	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
af32f4b2-a4e5-4fad-be72-f947b978f9f7	f	f	2022-01-17 00:00:00	\N	Vicente	Emily	2014	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
77328ed8-39ea-41b6-899e-beb5f9861380	f	f	2022-01-17 00:00:00	\N	Wyniger	Ylenia	2010	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
46ad8cc8-c402-4b31-876d-4d903dbf0bc4	f	f	2022-01-17 00:00:00	\N	Woytschak	Miyu	2009	\N	0	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
20008481-36db-4a92-83a6-458b77440a2e	f	f	2022-01-17 00:00:00	\N	Rohner	Timo	2003	664333	1	773a0356-9c76-4dfb-8c56-c1693ee2819d	f
07160725-0859-4a58-9d65-89677de3c1ee	f	f	2022-01-22 00:00:00	\N	Rechsteiner	Lukas	2012	3338171	1	1d2a9859-0137-4da2-8390-6cd570385ec4	f
d5985104-172a-4289-9e53-9ec951bbb635	f	f	2022-01-23 00:00:00	\N	Disch	Elena	1997	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
c6fb9e89-a866-4d37-8a3b-483e342056a8	f	f	2022-01-18 00:00:00	\N	Häberling	Fabian	2015	3491154	1	688a34cb-72f2-4920-aeb3-89325956de26	f
e4a7eb54-db20-4a74-a741-944bca117acb	f	f	2022-01-20 00:00:00	\N	Frach	Niklas	2010	2111997	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
d45f228f-96f1-47de-9612-775222437b36	f	f	2022-01-20 00:00:00	\N	Hintermann	Nik	2014	2463792	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
5976ff8a-30e4-4941-8240-f63393169543	f	f	2022-01-18 00:00:00	\N	Bär	Nino	2012	3327126	1	688a34cb-72f2-4920-aeb3-89325956de26	f
6d124e5a-4eb3-41e7-96c4-81e10bc865d5	f	f	2022-01-20 00:00:00	\N	Koch	Nino	2014	2587121	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
a054e6d4-5694-492b-a84c-49d8bd1f9ee9	f	f	2022-01-18 00:00:00	\N	Borst	Filip	2010	3149719	1	688a34cb-72f2-4920-aeb3-89325956de26	f
b58f7905-996a-4d8d-a05a-da9026a920eb	f	f	2022-01-20 00:00:00	\N	Ragaz	Mitchell	2009	1866348	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
6f4cf34f-bfe3-49ac-963f-dc31bb85dc66	f	f	2022-01-18 00:00:00	\N	Häberling	Timo	2011	3039059	1	688a34cb-72f2-4920-aeb3-89325956de26	f
161d55b8-8da0-4a96-8494-f18bfa41aeac	f	f	2022-01-25 00:00:00	\N	Fejk	Nelly	2015	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
ed16ea6c-1df1-4643-9ed8-5f91c3f07c38	f	f	2022-01-18 00:00:00	\N	Schlienger	Matteo	2011	3309180	1	688a34cb-72f2-4920-aeb3-89325956de26	f
8b49f6f9-d79a-4897-a200-4b386fe350e3	f	f	2022-01-20 00:00:00	\N	Stadtmann	Noah	2006	1755488	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
1d6c2970-01e1-4731-bee7-ad90613533db	f	f	2022-01-18 00:00:00	\N	Burkhard	Janis	2009	3102492	1	688a34cb-72f2-4920-aeb3-89325956de26	f
27021346-5559-4115-93c3-6d701d79d793	f	f	2022-01-18 00:00:00	\N	Gerber	Kimo	2010	3147914	1	688a34cb-72f2-4920-aeb3-89325956de26	f
f863d3da-aad8-4606-ba98-0a69ce2535f2	f	f	2022-01-18 00:00:00	\N	Schlienger	Nicola	2009	3054060	1	688a34cb-72f2-4920-aeb3-89325956de26	f
062d0f21-91aa-4219-8f38-7d89acb1413b	f	f	2022-01-18 00:00:00	\N	Klaming	Phynn	2006	3016973	1	688a34cb-72f2-4920-aeb3-89325956de26	f
7efe5df5-da80-47f3-bb9f-a1c79089d1ba	f	f	2022-01-18 00:00:00	\N	Schär	Simon	2007	3016974	1	688a34cb-72f2-4920-aeb3-89325956de26	f
a4ba36d3-c94f-4be7-abe2-be781a91a4c7	f	f	2022-01-18 00:00:00	\N	Schär	Sven	2007	3017306	1	688a34cb-72f2-4920-aeb3-89325956de26	f
bbeb3d70-1dd8-4e90-8d76-88c96cdac44e	f	f	2022-01-20 00:00:00	\N	Dobmann	Dominik	1975	079723	1	81308200-79d0-466c-a19a-ca3fbef6045a	f
01030c92-61c5-4f79-8212-3a55173d20a2	f	f	2022-01-20 00:00:00	\N	Vogel	Tobias	1989	446843	1	81308200-79d0-466c-a19a-ca3fbef6045a	f
14899b67-d0a2-4a8b-936b-6a2d4391067a	f	f	2022-01-18 00:00:00	\N	Bulliard	Su	2014	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
d16e18b7-e9c7-4d0e-8f71-73220c7f7dc9	f	f	2022-01-18 00:00:00	\N	Burgat	Marie	2014	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
8d15484c-5014-42c7-b493-f0b6579978c2	f	f	2022-01-20 00:00:00	\N	Kummer	Basil	2009	3132909	1	81308200-79d0-466c-a19a-ca3fbef6045a	f
fc45aeb9-281a-4482-bc18-c35b35b2bace	f	f	2022-01-18 00:00:00	\N	Häberling	Elaina	2015	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
1cb8f581-6c81-4ee9-b47b-c89bac12c2e2	f	f	2022-01-18 00:00:00	\N	Stadler	Vanora	2013	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
585af38c-93c7-4785-a962-fd318479e7f5	f	f	2022-01-20 00:00:00	\N	Nötzli	Benno	2011	3351766	1	81308200-79d0-466c-a19a-ca3fbef6045a	f
1e906a1f-dde2-425a-9823-5a1a875edf7b	f	f	2022-01-18 00:00:00	\N	Berliat	Jael	2013	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
45f0ea41-9d32-47c3-bb8d-f59195846d41	f	f	2022-01-18 00:00:00	\N	Meier	Sara	2013	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
7873ed2d-df5d-4541-987d-3d6d401e990c	f	f	2022-01-20 00:00:00	\N	Chlebny	Aleksander	2011	3094115	1	81308200-79d0-466c-a19a-ca3fbef6045a	f
cf20aa88-3cea-4e29-b8c9-89c3b3e99c2e	f	f	2022-01-18 00:00:00	\N	Notarnicola	Romina	2012	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
3409cfd5-f7e4-4c8c-925d-ee2ddba3cf14	f	f	2022-01-20 00:00:00	\N	Soland	Levin	2011	3085762	1	81308200-79d0-466c-a19a-ca3fbef6045a	f
8538e068-d62d-43c5-ae21-0c47a5c568c4	f	f	2022-01-18 00:00:00	\N	Widmer	Fiona	2012	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
d0d9e4f4-95cc-4611-b99e-27dcfe523783	f	f	2022-01-18 00:00:00	\N	Fanger	Shirin	2011	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
e4b88a97-f310-4b22-8af8-d33c896dabf0	f	f	2022-01-20 00:00:00	\N	Berg	Theodor	2012	3509796	1	81308200-79d0-466c-a19a-ca3fbef6045a	f
e11fac57-6be1-4244-9c9d-361177f235ac	f	f	2022-01-18 00:00:00	\N	Huber	Chantal	2011	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
b82f2f24-5c23-4249-9413-02783705d856	f	f	2022-01-20 00:00:00	\N	Weber	Tim	2013	3337099	1	81308200-79d0-466c-a19a-ca3fbef6045a	f
61696721-1964-4ed9-93c6-231b89375d77	f	f	2022-01-18 00:00:00	\N	Berli	Lena	2009	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
15cd7097-57e7-4d29-8e1c-fe1f3b1c301f	f	f	2022-01-18 00:00:00	\N	Burkart	Lea	2008	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
86ebbdce-89ed-48da-ac59-e3d2ee05d1a5	f	f	2022-01-20 00:00:00	\N	Mattli	Nicole	1986	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
711698fa-5e0a-4dec-9168-b6dfe10f077c	f	f	2022-01-18 00:00:00	\N	Häberling	Leonie	2009	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
b9998e65-2891-487d-ba52-e4e239c39e7b	f	f	2022-01-18 00:00:00	\N	Leutert	Lina	2008	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
003e4dc3-ff55-400a-92aa-3dbe4c597946	f	f	2022-01-20 00:00:00	\N	Öncü	Derya	1989	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
c13629c4-97b8-4cee-81a6-bceb003bf8f7	f	f	2022-01-18 00:00:00	\N	Viskovic	Paula	2009	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
dad4798e-62b0-48eb-9a9a-1fc20661f511	f	f	2022-01-20 00:00:00	\N	Stegmayer	Joleen	2003	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
b7f118be-23cb-4a4e-97c3-68bbdfa6d993	f	f	2022-01-20 00:00:00	\N	Beti	Natalie	2003	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
30b8423b-989b-4118-94a9-25cc5c87dc07	f	f	2022-01-18 00:00:00	\N	Rohner	Nathalie	2009	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
9dad4acd-c835-4711-9a5a-d1d1e6d86dfe	f	f	2022-01-18 00:00:00	\N	Rüegg	Lea	2008	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
2284a70c-0a8f-41dc-8074-6650ab9bba41	f	f	2022-01-18 00:00:00	\N	Zwicky	Anina	2008	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
bb41ec26-b1b4-407b-98b1-9d17bcb11f11	f	f	2022-01-18 00:00:00	\N	Bleuler	Tanja	1996	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
ea44538b-9ca4-4d50-b2d3-beddf6836c75	f	f	2022-01-18 00:00:00	\N	Schaub	Alisha	2003	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
94884068-05ac-422c-9a1c-ab52873f43ea	f	f	2022-01-18 00:00:00	\N	Meister	Jolene	2007	\N	0	688a34cb-72f2-4920-aeb3-89325956de26	f
5ea6fa08-0baa-4f4d-b3be-418c6a9a52a8	f	f	2022-01-18 00:00:00	\N	Accola	Cyril	2001	677072	1	688a34cb-72f2-4920-aeb3-89325956de26	f
0196ce81-9179-4c8f-83c4-d89d66d2532c	f	f	2022-01-19 00:00:00	\N	Bühlmann	Ean	2015	3555306	1	688a34cb-72f2-4920-aeb3-89325956de26	f
e40fe43e-d429-406b-8a46-9720bec4f297	f	f	2022-01-19 00:00:00	\N	Häberling	Nico	2013	3455916	1	688a34cb-72f2-4920-aeb3-89325956de26	f
92148697-c598-405e-bdd0-16a81d328b20	f	f	2022-01-19 00:00:00	\N	Jurik	Lukas	2013	3455916	1	688a34cb-72f2-4920-aeb3-89325956de26	f
c4805559-715e-4683-a517-a30714a7c295	f	f	2022-01-19 00:00:00	\N	Käppeli	Janis	2014	3455919	1	688a34cb-72f2-4920-aeb3-89325956de26	f
91caefba-e34c-4bba-b3b8-f80a1aed5a9a	f	f	2022-01-19 00:00:00	\N	Ochsner	Noé	2013	3555318	1	688a34cb-72f2-4920-aeb3-89325956de26	f
789248f0-b4fe-4be9-b27d-9bd16788a41e	f	f	2022-01-20 00:00:00	\N	Kocher	Jasmin	2003	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
87247b7e-c974-4fe9-b496-38049c3b8231	f	f	2022-01-19 00:00:00	\N	Sinkovec	David	2003	686884	1	854e7b58-34dc-4ed5-ac6c-f233476b1e9e	f
8828320f-f23b-40fb-9868-520849448037	f	f	2022-01-19 00:00:00	\N	Heule	Fabio	2005	857381	1	854e7b58-34dc-4ed5-ac6c-f233476b1e9e	f
41882def-df1b-4ef9-b750-f748d42a08bf	f	f	2022-01-20 00:00:00	\N	Landert	Joleen	2005	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
86533780-84ec-4dcb-9c25-646030b3ebb5	f	f	2022-01-20 00:00:00	\N	Rinderknecht	Livia	2005	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
2406b2cf-4329-4b6c-9160-336c7a46e0f4	f	f	2022-01-20 00:00:00	\N	Graullera	Annika	2004	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
6aa7f3bb-08af-43c9-b598-a5e601884639	f	f	2022-01-20 00:00:00	\N	Graullera	Sara	2005	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
7825ac07-0605-4a5d-80c9-2dc3482d812d	f	f	2022-01-20 00:00:00	\N	Kuipers	Femke	2005	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
8523bc16-1315-4f92-b0d3-486f136fb743	f	f	2022-01-20 00:00:00	\N	Weyermann	Lea	2006	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
3f383324-1dc0-4815-a8fb-4347c9678916	f	f	2022-01-20 00:00:00	\N	Badal	Nuria	2006	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
4182b334-d25c-442d-85cd-af5c553cb91b	f	f	2022-01-21 00:00:00	\N	Vetter	Jann	2004	873030	1	e2438143-6017-4683-a533-6113748d4117	f
7e84e7b5-869e-4a32-9b18-c94008af3c9c	f	f	2022-01-21 00:00:00	\N	Toggenburger	Sondang	2008	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
5308ed6a-e60f-491a-9b2c-26da8e2cfa8e	f	f	2022-01-22 00:00:00	\N	Graf	Janis	2007	3006385	1	1d2a9859-0137-4da2-8390-6cd570385ec4	f
162dceab-8d0a-4e66-8cf2-7ec51717b40e	f	f	2022-01-22 00:00:00	\N	Jakobs	Gabriel	2015	3519226	1	1d2a9859-0137-4da2-8390-6cd570385ec4	f
9b1b0d17-faa2-4e32-a7bb-ae13d77ca0fe	f	f	2022-01-27 00:00:00	\N	Christinger	Nora	2009	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
048ae246-167f-4b2d-a737-9b9c236f002b	f	f	2022-01-22 00:00:00	\N	Kleger	Miron	2013	3522443	1	1d2a9859-0137-4da2-8390-6cd570385ec4	f
932c4b6f-eb11-4965-9328-2c7ba3dad7ab	f	f	2022-01-27 00:00:00	\N	Hochuli	Nina	2008	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
7b642841-1f01-4f84-845f-261f0fb2acda	f	f	2022-01-22 00:00:00	\N	Wisotzki	Tim	1999	321156	1	1d2a9859-0137-4da2-8390-6cd570385ec4	f
5ebd82a3-cdde-4437-a80c-93c4e71c80d4	f	f	2022-01-27 00:00:00	\N	Meier	Anouk	2009	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
39cca78d-0cd2-4bcf-873a-912aa1f89f6e	f	f	2022-01-25 00:00:00	\N	Jankovic	Eva	2015	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
a5bd5afb-944a-4c17-9497-aa955d2a8548	f	f	2022-01-27 00:00:00	\N	Jäger	Julia	2008	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
be43843b-d939-4151-8595-a42bc28e9ee3	f	f	2022-01-25 00:00:00	\N	Schneider	Juli	2013	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
ea2f0d01-e31a-4838-9997-bf6b51bf1773	f	f	2022-01-23 00:00:00	\N	Cides	Cintia	2010	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
e8cba3a1-5869-49ce-9c43-4a8224c7e2a3	f	f	2022-01-23 00:00:00	\N	Furter	Jennifer	2011	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
1a427459-e70c-4f00-bd79-85af371a4509	f	f	2022-01-23 00:00:00	\N	Iwasaki	Janina	2003	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
c889dac3-63c1-46bc-a3b3-7e6cf4e5dd48	f	f	2022-01-25 00:00:00	\N	Graf	Tindra	2013	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
ab7d9af9-f436-4167-9504-bd973e5f2855	f	f	2022-01-27 00:00:00	\N	Gretler	Alina	2005	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
9b4fbc30-a935-4da7-8370-505f032abe04	f	f	2022-01-23 00:00:00	\N	Odermatt	Méline	2005	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
37d27df3-0635-4f62-8259-3badb1627eb9	f	f	2022-01-25 00:00:00	\N	Meyer	Celine	2014	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
ba0b968d-7d83-4265-b0f5-9032be1fe45e	f	f	2022-01-28 00:00:00	\N	Widmann	Carl	2010	3102478	1	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
a55af759-b519-4b84-929d-d41846d49851	f	f	2022-01-23 00:00:00	\N	Vogt	Felix	2015	\N	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
b7dcdcf8-3950-4a59-a3da-4c670c5dd8cb	f	f	2022-01-25 00:00:00	\N	Rica Rodriguez	Adriana	2012	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
6b4dd7dc-ece8-4433-9d23-16a2928e8829	f	f	2022-01-22 00:00:00	\N	Thoma	Thierry	2012	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
354b2ec6-febd-4c82-8ce0-cb8abc99262a	f	f	2022-01-22 00:00:00	\N	Cadosch	Laurin	2010	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
00eecc59-5b8b-407d-b7cb-a3a65af878be	f	f	2022-01-23 00:00:00	\N	Perdrizat	Jan	2012	3203861	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
dbf71678-6772-4c24-8d95-2966f0afad08	f	f	2022-01-22 00:00:00	\N	Mengelt	Fabio	2008	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
44ef5cf2-c181-48cc-acaf-1d4d4600f5d5	f	f	2022-01-25 00:00:00	\N	Spandel	Svenja	2014	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
96ed28a8-8a79-46bf-9e57-b10105c181bd	f	f	2022-01-28 00:00:00	\N	Koller	Vanessa	2000	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
fd260ab3-e112-4b4d-baf9-ce4b8829fd58	f	f	2022-01-25 00:00:00	\N	Trapl	Helena	2011	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
17a7016b-6228-4a34-809d-39402d6845c4	f	f	2022-01-28 00:00:00	\N	Bielmann	Kathaliya	2001	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
4d9eeece-35cb-4d9c-8163-b4285abccaab	f	f	2022-01-25 00:00:00	\N	Flace	Siria	2010	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
32860ba8-3a33-489d-8aff-9bb9b183dee0	f	f	2022-01-28 00:00:00	\N	Volkart	Lorena	2004	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
8dce089f-221a-4603-950b-29d30d67dd32	f	f	2022-01-25 00:00:00	\N	Fünfschilling 	Tara	2011	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
cf654f83-de82-4d41-a843-2dde0799e14a	f	f	2022-01-28 00:00:00	\N	Gagaine	Emija	2008	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
75c0768e-754b-4683-9721-c0a4a7964a74	f	f	2022-01-25 00:00:00	\N	Vincenti	Chiara	2012	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
d636693e-1b48-4d33-a1c1-e9646e08aef6	f	f	2022-01-28 00:00:00	\N	Osifo	Noëmi	2008	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
6ae5f224-0fa0-4b2d-9f63-31543847b18e	f	f	2022-01-28 00:00:00	\N	Matic	Milica	2009	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
0a086872-16f7-44f0-840b-117b7903f985	f	f	2022-01-25 00:00:00	\N	Guyer	Sarina	2009	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
d6efaffe-3aa9-44b0-b5a8-1750ca799e8c	f	f	2022-01-28 00:00:00	\N	Fraccalvieri	Viola	2011	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
119aa0b4-98bc-4323-ba79-ffe4b341702e	f	f	2022-01-25 00:00:00	\N	Minocchieri	Anina	2010	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
88d08af0-f65d-424f-93df-8c35b8743060	f	f	2022-01-28 00:00:00	\N	Fischer	Kiana	2012	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
52629669-ed1c-4fe7-b9cb-9c89a48230b5	f	f	2022-01-28 00:00:00	\N	Auböck	Tiia	2014	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
a9c6afa4-bc6b-416d-82d5-b9464c41a98b	f	f	2022-01-25 00:00:00	\N	Siegrist	Fiona	2010	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
434e5d65-019d-4c6c-a886-f6431c0fb1c2	f	f	2022-01-25 00:00:00	\N	Bosshard	Selina	1999	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
2a8b0a61-8a51-47cc-840d-bb8f2df430a9	f	f	2022-01-28 00:00:00	\N	Köble	Mika	2006	960299	1	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
3eba3044-7c1e-482a-8eeb-a7afa3b81910	f	f	2022-01-26 00:00:00	\N	Bruggmann	Adrian	1998	542535	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
cc1458e2-677d-483e-a491-d4f268e9e405	f	f	2022-01-26 00:00:00	\N	Pommarel	Loann	1989	3483452	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
ebf7ab72-5ca6-4aad-b3c2-544447752169	f	f	2022-01-28 00:00:00	\N	Biser	David	2008	3087086	1	86a39d76-71ed-4890-82ec-ce2a48d32627	f
25ea10eb-fe1e-4c2d-a389-478ade1ec4bf	f	f	2022-01-28 00:00:00	\N	Chenevard	Julien	2010	3196331	1	86a39d76-71ed-4890-82ec-ce2a48d32627	f
98412219-6445-40a2-b56a-f7f38a4b16ff	f	f	2022-01-28 00:00:00	\N	Rüegg	Joey	2005	933993	1	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
e94538bb-c604-4b5b-bb82-de73bed9fc43	f	f	2022-01-27 00:00:00	\N	Truninger	Nico	2009	3110786	1	a5302a2b-d270-49e5-9876-47c84cb38038	f
3772babe-b218-4435-8620-ca6aa766ee13	f	f	2022-01-27 00:00:00	\N	Meier	Nils	2006	866897	1	a5302a2b-d270-49e5-9876-47c84cb38038	f
77cf5de8-333f-47de-b9a3-14e4e00fa69a	f	f	2022-01-27 00:00:00	\N	Jäger	Sascha	2006	930033	1	a5302a2b-d270-49e5-9876-47c84cb38038	f
54cf958b-d32f-4f4a-ad2c-8631dcb02d4c	f	f	2022-01-27 00:00:00	\N	Gretler	Jannik	2007	973898	1	a5302a2b-d270-49e5-9876-47c84cb38038	f
56472a30-b319-4304-a86b-0eced54ede6c	f	f	2022-01-27 00:00:00	\N	Müller	Gian	2013	3365668	1	a5302a2b-d270-49e5-9876-47c84cb38038	f
90cb95a6-01df-4d57-82c3-6c852dc0989a	f	f	2022-01-27 00:00:00	\N	Flisch	Andrin	2006	930012	1	a5302a2b-d270-49e5-9876-47c84cb38038	f
b4c08eda-6c89-4078-bca0-5e994bb233ad	f	f	2022-01-29 00:00:00	\N	Eicher	Robin	2013	\N	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
adcce6c1-2fe3-4199-9f9d-222464c36ef5	f	f	2022-01-29 00:00:00	\N	Fankhauser	Finn	2010	981917	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
00c6b0c3-6141-4eec-b065-3a2d5bc9f3f3	f	f	2022-01-27 00:00:00	\N	Odermatt	Mia	2015	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
aa86fac4-eb31-4716-89c6-dc8fdc834ae0	f	f	2022-01-27 00:00:00	\N	Temperli	Leandra	2012	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
7c9b0b76-97b9-4d5e-b052-b84f1394a088	f	f	2022-01-27 00:00:00	\N	Perrenoud	Estelle	2014	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
226cec1e-312b-42ad-bb62-7e582e7d590d	f	f	2022-01-27 00:00:00	\N	Brey	Sofia	2012	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
748aac10-5d59-4a9d-850f-942198fdae91	f	f	2022-01-27 00:00:00	\N	Holzer	Selina	2012	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
0745244f-f816-40c0-9b1a-102fb6634fb7	f	f	2022-01-27 00:00:00	\N	Bosshard	Julia	2012	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
4486774f-d237-4013-b8a3-4505f52634b2	f	f	2022-01-27 00:00:00	\N	Truninger	Ladina	2011	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
a4cf5270-3435-49d8-a4d7-40b070f1c4ab	f	f	2022-01-29 00:00:00	\N	Keller	Claudio	2006	930826	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
699c9855-119d-4bd7-9e00-61aff964bc39	f	f	2022-01-29 00:00:00	\N	Kunz	Andreas	2013	3116499	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
8d3d32c8-9c40-4838-9743-306435725143	f	f	2022-01-20 00:00:00	\N	Füllemann	Mary Lynn	2006	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
5ba9bebb-f42b-4cf6-8f72-33440f811075	f	f	2022-01-22 00:00:00	\N	Röhl	Joel	2005	905973	1	1d2a9859-0137-4da2-8390-6cd570385ec4	f
0124ca13-e5bc-4aa9-a952-eaa5dac28170	f	f	2022-01-21 00:00:00	\N	Borioni	Noana	2008	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
7e7fd560-3ebc-4765-be45-24fc0f4f35d3	f	f	2022-01-21 00:00:00	\N	Gentilini	Chiara	2007	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
a13d3bbe-79d2-4ead-a9ed-ee5fa1198b59	f	f	2022-01-23 00:00:00	\N	Bertschinger	Livia	2005	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
f769707d-eab4-4f6c-acfb-f5ec0ccf5265	f	f	2022-01-25 00:00:00	\N	Kolk	Nele	2015	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
6f5edf06-9cbc-4d08-a7b1-88f0e8d8ae35	f	f	2022-01-27 00:00:00	\N	Perrenoud	Mina	2011	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
f917de79-0c46-4ee7-8d8d-5188b811ed2f	f	f	2022-01-25 00:00:00	\N	Peterhans	Juna	2014	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
d5e46bba-7a13-487c-9aea-180157fd8a02	f	f	2022-01-27 00:00:00	\N	Berger	Ladina	2010	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
a272147d-82d6-4b86-9d4e-5076494a6500	f	f	2022-01-25 00:00:00	\N	Fünfschilling	Tatjana	2014	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
4e8cb30e-2ec4-45f5-8b3a-c64e308fbb92	f	f	2022-01-27 00:00:00	\N	Bernhard	Mia	2006	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
3079af91-3596-46e2-91ea-aa04659babd2	f	f	2022-01-25 00:00:00	\N	Trapl	Theresa	2011	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
9f897303-76c4-48cf-83dd-ab8c8e12ea53	f	f	2022-01-23 00:00:00	\N	Feuerlein	Alena	2007	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
a20a71d7-7882-42b2-855a-641b66a39208	f	f	2022-01-23 00:00:00	\N	Fasser	Lia	2015	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
da5feae4-a7ea-4ed8-9749-94f7ada45d59	f	f	2022-01-23 00:00:00	\N	Hanimann	Sandrina	2009	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
4cd54a77-8a8a-4bba-a33a-78c4be46eaab	f	f	2022-01-23 00:00:00	\N	Martin	Isabel	2014	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
d6d6aba3-0f7b-4eac-94ca-89395eced0c2	f	f	2022-01-23 00:00:00	\N	Keller	Larina	2006	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
482b3c30-5be6-4492-a5cb-7ad1f89150f7	f	f	2022-01-27 00:00:00	\N	Camenzind	Seraina	2006	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
39c7fa6e-dcb0-41f8-a3c6-c34f7a511fcf	f	f	2022-01-23 00:00:00	\N	Perdrizat	Livia	2012	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
f4baa885-6558-49ee-961c-2460d24b90fa	f	f	2022-01-25 00:00:00	\N	Guyer	Leandra	2011	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
19a090dc-b4ad-4423-b6f6-3f02439c2ce7	f	f	2022-01-23 00:00:00	\N	Wietlisbach	Anna-May	2013	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
c6e64f28-0606-482c-9190-ef875a83f9a7	f	f	2022-01-25 00:00:00	\N	Prakash	Ramona	2011	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
78096179-2af4-4450-b4a6-8d8898d86292	f	f	2022-01-23 00:00:00	\N	Wolf	Nora	2012	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
9ac6942e-af1a-4ac4-8208-e529cc05ac3f	f	f	2022-01-23 00:00:00	\N	Wietlisbach	Emma-Rose	2015	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
4eb11125-35a5-4152-8aeb-8f6721e69f32	f	f	2022-01-25 00:00:00	\N	Ricciardi	Valeria Jamie	2011	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
b437e6cc-1184-44f5-ba23-558e718213a4	f	f	2022-01-22 00:00:00	\N	Caminada	Nico	2008	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
e39700e8-07a8-4fd5-9bc3-b128ee229568	f	f	2022-01-22 00:00:00	\N	Caviezel	Tiziano	2007	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
113ef945-991a-401f-ba5b-25e02bceaa13	f	f	2022-01-25 00:00:00	\N	Alaoui	Sara	2008	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
d5c1bd8a-e192-4e5d-9006-9d4a6ac3512d	f	f	2022-01-27 00:00:00	\N	Schiesser	Viviane	2000	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
12452659-e21d-48c7-8f95-ead28d3f8040	f	f	2022-01-23 00:00:00	\N	Cides	Dani	2003	706740	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
c49e6c4c-a355-4993-aa0c-425282edc247	f	f	2022-01-23 00:00:00	\N	Odermatt	Lian	2010	3075189	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
3481528b-0476-4851-87cc-56138eb7d80b	f	f	2022-01-23 00:00:00	\N	Ngauv	Dustin	2004	716452	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
f43391a6-c3a4-4712-933c-2738f2c3930c	f	f	2022-01-25 00:00:00	\N	Karlen	Emylia	2015	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
7d267e77-4449-469e-8118-4fbe2f6761ce	f	f	2022-01-27 00:00:00	\N	Bühler	Sandra	2003	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
5a16c40e-58cb-409b-8a10-e64555b3a757	f	f	2022-01-26 00:00:00	\N	Furger	Jari	2014	3261643	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
de0d5c86-4883-4f47-ad70-a6aa4dfea332	f	f	2022-01-25 00:00:00	\N	Hänni	Maurus	2007	\N	1	2fc3365b-34d9-4054-b2d8-aa859c7455e7	f
4444edf2-534e-42cf-8d1f-48b31c60e90d	f	f	2022-01-27 00:00:00	\N	Ochsenbein	Lara	1999	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
4e732183-e839-4bcf-9a5b-e507bb5f9a03	f	f	2022-01-28 00:00:00	\N	Violetti	Sämi	2003	705154	1	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
64e32826-941e-4a21-b418-505b0e56fda2	f	f	2022-01-26 00:00:00	\N	Bucher	Andrin	2011	3243445	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
95a92229-f0fd-434d-848e-6f8c2c724ed0	f	f	2022-01-28 00:00:00	\N	Wigger	Mara	2001	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
8bca5f87-48cf-4df8-851a-f17791ca27f3	f	f	2022-01-26 00:00:00	\N	Smoron	Damian	2010	3095433	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
9e6700d6-af25-4a9a-8368-4eb12c8cae24	f	f	2022-01-28 00:00:00	\N	Jeremic	Anja	2008	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
1c8eb3d9-4190-4f9d-bb86-9800a8557b88	f	f	2022-01-26 00:00:00	\N	Carrel	Micha	2001	571392	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
dee1d772-12cb-43fb-9ddf-f671fdc2b9b0	f	f	2022-01-26 00:00:00	\N	Pfaller	Raffael	1998	566383	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
b553f3be-1141-4e96-9e47-8c22000f2737	f	f	2022-01-28 00:00:00	\N	Correia	Leonor	2010	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
9fc87fff-2510-4327-9c0e-7a05f3085dd8	f	f	2022-01-28 00:00:00	\N	Maier	Elin	2013	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
820d720b-c897-4ab9-8c4a-b42008ecba02	f	f	2022-01-28 00:00:00	\N	Saado	Eléa	2014	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
d43d9929-5474-410d-be56-2e0858b14f23	f	f	2022-01-28 00:00:00	\N	Zuka	Inara	2014	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
19e3f121-7083-44cd-8c12-7c44f05fe500	f	f	2022-01-28 00:00:00	\N	Volkart	Yannick	2001	629281	1	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
d727f5fe-e7d2-4577-b489-4d354161de5e	f	f	2022-01-27 00:00:00	\N	Brey	Leonie	2014	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
c6a8e41b-9da6-49af-afd0-54b3ea9c28ff	f	f	2022-01-27 00:00:00	\N	Jäger	Olivia	2014	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
d01fcdbe-4deb-4c39-bfea-aee0e3b915b5	f	f	2022-01-27 00:00:00	\N	Kämpfer	Janina	2012	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
b0e58619-9fdd-4bd0-bbf2-1cec57bf0267	f	f	2022-01-27 00:00:00	\N	Angst	Romy 	2011	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
29ffbb9b-dcc7-4571-8087-4c08ef784bc3	f	f	2022-01-27 00:00:00	\N	Eglseer	Aline	2011	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
a5790b87-a247-4938-8f62-d854f2953fc1	f	f	2022-01-27 00:00:00	\N	Furrer	Livia	2012	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
ca588032-b5f0-4e01-b110-d2604ac0e738	f	f	2022-01-28 00:00:00	\N	Morgenegg	Luca	2012	3250435	1	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
74ca681f-08b0-49df-8ebd-20e38011e269	f	f	2022-01-28 00:00:00	\N	Leisi	Max	2011	3425584	1	86a39d76-71ed-4890-82ec-ce2a48d32627	f
8eff3577-8500-4dff-93a5-faa4d33fa2e3	f	f	2022-01-28 00:00:00	\N	Kurz	Juan	2010	3220317	1	86a39d76-71ed-4890-82ec-ce2a48d32627	f
255f7854-e5ef-46cf-8bb5-9df68b75b232	f	f	2022-01-29 00:00:00	\N	Baumann	Elias	2009	\N	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
4a9ef47d-7a3a-4c9f-9761-a5c7422fef1c	f	f	2022-01-29 00:00:00	\N	Hirzel	Jelle	2008	3286590	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
717ef780-9fcf-4658-9db6-693e62764908	f	f	2022-01-29 00:00:00	\N	Nock	Rico	1997	679874	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
3375fcba-0144-4efa-ac46-160742fef0aa	f	f	2022-01-29 00:00:00	\N	Meyer	Lorin	2010	3072773	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
688c540f-f846-437b-9884-875d19b83002	f	f	2022-01-29 00:00:00	\N	Meyer	Joel	2006	930860	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
28ab6e33-9ef1-46f6-b2ef-82a2d3089947	f	f	2022-01-29 00:00:00	\N	Schoch	Sven	2001	679904	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
c33749e2-6b2a-40cf-a699-fbaa97c1a492	f	f	2022-01-29 00:00:00	\N	Seeberger	Fabrizio	1995	679906	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
72afd313-31ba-4a08-b737-fa602d694892	f	f	2022-01-29 00:00:00	\N	Schuppli	Dario	2014	\N	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
29418401-87df-43e9-9901-12848ab49f09	f	f	2022-01-29 00:00:00	\N	Studer	Singto	2013	\N	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
1fcb183f-192a-477a-822b-1628def7bf3b	f	f	2022-01-29 00:00:00	\N	Waldvogel	Remo	2011	3283131	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
afe3bbf8-c9d3-46af-9e74-0542ec131d89	f	f	2022-01-29 00:00:00	\N	Tramontana	Lorenzo	2012	3514926	1	80c08ccc-c90e-4377-af3b-2de779197c7a	f
8a7f4911-b143-4c6b-9cda-40c426158f0d	f	f	2022-01-30 00:00:00	\N	Maurer	Jeremy	2011	3269631	1	1030974d-cffe-46d6-b6ea-79c8839cf2ea	f
404b262a-57ad-404d-bd38-26979ce5715d	f	f	2022-01-21 00:00:00	\N	Stadelmann	Nina	2008	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
6daae379-0879-4ccd-8690-b64aebc2d7d6	f	f	2022-01-21 00:00:00	\N	Beerli	Svenja	2007	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
02a156d2-3f1d-4371-b9ed-2e9cdc2a1905	f	f	2022-01-22 00:00:00	\N	Baur	Philipp	2008	3047041	1	1d2a9859-0137-4da2-8390-6cd570385ec4	f
056b99cb-c46d-4a05-aa6a-efbca6a73941	f	f	2022-01-22 00:00:00	\N	Sigrist	Rafael	2013	\N	1	1d2a9859-0137-4da2-8390-6cd570385ec4	f
0519f83a-fe03-474f-a300-5807cfcfe32b	f	f	2022-01-23 00:00:00	\N	Schnorf	Carmen	1991	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
0c5561bd-4984-4715-b885-ad7f957d7a78	f	f	2022-01-23 00:00:00	\N	Müller	Anna	2011	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
2147bb17-f1c7-4cc8-86a9-e7a5b55bd09a	f	f	2022-01-23 00:00:00	\N	Radecke	Jael	2013	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
4c077309-01dd-4031-a3a1-5bb961e44456	f	f	2022-01-25 00:00:00	\N	Perotto	Anna	2014	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
ec9a0640-39c3-4a97-9f1d-63acf4630589	f	f	2022-01-23 00:00:00	\N	Schmidli	Lorena	2008	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
fad485ef-5f14-4a7e-b330-eb8b3277b4d8	f	f	2022-01-25 00:00:00	\N	Schädeli	Mea	2016	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
b4dc29c0-a537-41b1-9f13-a6dd38e7725d	f	f	2022-01-23 00:00:00	\N	Odermatt	Robin	2007	850850	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
b1e4025d-1ba5-4fb4-b21c-00c8e74c1db5	f	f	2022-01-23 00:00:00	\N	Stuker	Neilo	2011	3069590	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
80afde5c-229d-4a0c-820f-8c383eb323c3	f	f	2022-01-27 00:00:00	\N	Furrer	Leonie	2010	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
81acf225-0226-4232-b5be-2691aa4fc5f8	f	f	2022-01-22 00:00:00	\N	Maissen	Gianluca	2006	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
970554d5-e2bb-4a11-9b3b-4d5f21f3c044	f	f	2022-01-25 00:00:00	\N	Schlatter	Mina	2013	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
5b95f7b0-3a83-4080-8185-77f995be163b	f	f	2022-01-27 00:00:00	\N	Mannhard	Enya	2009	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
9e151d5e-fc95-4cb0-b122-32dd2428977e	f	f	2022-01-25 00:00:00	\N	Flüglister	Lara	2013	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
e9708e57-9005-42cc-8cc1-6e0997818651	f	f	2022-01-27 00:00:00	\N	Christinger	Lea	2006	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
7e3f0c97-7735-411d-903d-dd8b4faa323c	f	f	2022-01-25 00:00:00	\N	Hutmacher	Sven	2012	\N	1	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
99047440-a28d-4a9e-98c9-8a5a5b2d7517	f	f	2022-01-25 00:00:00	\N	Lichtsteiner	Simon	2012	\N	1	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
e4bf521f-e7b9-40c3-95e3-d2e43966ca55	f	f	2022-01-25 00:00:00	\N	Kehrli	Max	2011	\N	1	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
519ef3f1-fde8-4c15-8bf0-ddf1908a8dac	f	f	2022-01-25 00:00:00	\N	Tunkli	Jàzmin	2012	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
81d5230e-58d7-4d37-bf60-291fab6f512b	f	f	2022-01-27 00:00:00	\N	Häringer	Ina	2008	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
288bf42c-3a48-490f-be92-896fa147a5dd	f	f	2022-01-27 00:00:00	\N	Truninger	Andrina	2004	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
69e1bb2b-070f-4040-b8ef-efb8c540e48b	f	f	2022-01-27 00:00:00	\N	Schmid	Jessica	2007	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
0f28a350-d776-47da-8cec-e1897a044f8c	f	f	2022-01-25 00:00:00	\N	von Treskow	Clara	2013	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
19f82a37-8d51-4782-a8e9-d863103be5e5	f	f	2022-01-27 00:00:00	\N	Pavesi	Fabienne	1994	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
cf890313-5432-4db1-a371-2ddbc6fd2b03	f	f	2022-01-28 00:00:00	\N	Forster	Emanuel	1995	855571	1	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
600aed34-2b3f-4b2f-b994-c88cc057fa1f	f	f	2022-01-25 00:00:00	\N	Ricciardi	Alessia Josie	2009	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
d2d3bfd6-d7e9-4074-a64b-dca909758826	f	f	2022-01-28 00:00:00	\N	Hutmacher	Nick	2011	3141911	1	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	f
aaf4f808-c320-4b2b-b000-2cc026e3556b	f	f	2022-01-28 00:00:00	\N	Chiarolini	Sarah	1999	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
43f462b2-d838-4f31-a4ee-2814fb879e0f	f	f	2022-01-25 00:00:00	\N	Arnold	Jasmin	2007	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
e4bf8718-c22f-4d12-a204-b1f80a6bda49	f	f	2022-01-28 00:00:00	\N	Gross	Giuliana	2004	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
b1633444-8257-4756-8073-6db26001c999	f	f	2022-01-25 00:00:00	\N	Meier	Jana	2006	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
549f5d94-0496-4769-b379-d9c544362f42	f	f	2022-01-28 00:00:00	\N	Fuchs	Elisa	2010	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
f4b75c50-054e-4da8-8350-1d84232b6441	f	f	2022-01-25 00:00:00	\N	Meier	Nick	2008	984444	1	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
fc09e934-9292-407f-9d99-ce981c8b18ea	f	f	2022-01-25 00:00:00	\N	Kapp	Gorian	0	\N	1	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
7eb4ca01-299a-444a-8123-0c8f553d0718	f	f	2022-01-25 00:00:00	\N	Dubs	Janick	2008	984439	1	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
46849279-dfbe-494c-a436-b7ab726d075d	f	f	2022-01-28 00:00:00	\N	Hunyady	Milla	2010	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
cca9c568-dd1b-4b8c-bc90-fc898f9e2c6d	f	f	2022-01-28 00:00:00	\N	von Felten	Melanie	2008	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
f38d087e-f090-480c-acd6-f83c03d978e5	f	f	2022-01-28 00:00:00	\N	Marucci	Alissa	2010	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
329b27f5-9daf-4ead-a213-4450a26db0a4	f	f	2022-01-26 00:00:00	\N	Näf	Noé	2012	3044734	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
e6ab3234-26db-4ab3-9597-3a7eca95d380	f	f	2022-01-28 00:00:00	\N	Berini	Laura	2010	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
ddc5d1c7-f3d8-4321-a137-f344eab4ad9a	f	f	2022-01-26 00:00:00	\N	Pfaller	Florian	2010	3141555	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
7c25b5c2-b0f8-4e54-8169-7b5c2c99796a	f	f	2022-01-26 00:00:00	\N	Krebs	Jonas	2011	959718	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
97df0cc6-12d7-4f17-b20b-0f4cba6d9e77	f	f	2022-01-26 00:00:00	\N	Milz	Jannis	2006	593412	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
6a361cdd-1a65-4bbe-b3ac-678e202493a6	f	f	2022-01-26 00:00:00	\N	Schmid	Riccardo	2003	517968	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
fa8c47e8-129f-4986-a347-8f08a5fbc16c	f	f	2022-01-28 00:00:00	\N	Vogelsanger	Jarina	2012	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
2a5040fd-e605-40e5-96da-7b86da83c9f6	f	f	2022-01-28 00:00:00	\N	Marsella	Valerie	2012	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
c1358ce6-29dc-41a3-a780-a5c48ae1b56f	f	f	2022-01-27 00:00:00	\N	Frei	Julia	2014	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
f76c2109-3f86-4463-b6c3-57caca3c80b0	f	f	2022-01-27 00:00:00	\N	Temperli	Selina	2010	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
fb96c26d-e059-4953-93f3-1edb8537c221	f	f	2022-01-28 00:00:00	\N	Joosten	Mia	2013	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
e0d4a99d-16e6-4e8d-b2b3-897d3c13c5e0	f	f	2022-01-28 00:00:00	\N	Horisberger	Emily	2015	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
43991b09-dc91-4ec5-85c2-812d4fda208b	f	f	2022-01-28 00:00:00	\N	Hurter	Yael	2015	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
aaa1c9c5-c724-45eb-93ea-f84da94414d4	f	f	2022-01-28 00:00:00	\N	Oertig	Lea	2014	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
ee8bd0f6-ef50-4835-b432-d9772ee52836	f	f	2022-01-28 00:00:00	\N	Pfanner	Mara	2014	\N	0	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
a6493824-cca4-4c7c-a202-3dd0a04b1f3e	f	f	2022-01-28 00:00:00	\N	Schnitzler	Felix	2001	629357	1	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
a0f3f7b1-957f-4390-92e5-64c5c8729e94	f	f	2022-01-28 00:00:00	\N	Volkart	Timo	2006	960297	1	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
b62a15ae-bb28-4457-b078-8abcb6245e7c	f	f	2022-01-28 00:00:00	\N	Studer	Fabian	2007	3074491	1	86a39d76-71ed-4890-82ec-ce2a48d32627	f
9ed30a96-af19-43db-89f3-73ca4df8b908	f	f	2022-01-28 00:00:00	\N	Denzler	Silvan	2007	966394	1	852ccab3-35f6-4d12-815c-d8b66ff664b7	f
a5d567e3-5134-4a77-a739-019c4b90404a	f	f	2022-01-29 00:00:00	\N	Bodenmann	Falk	2007	3118478	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
f24aa5e9-e827-45a8-9644-2745b5a1d6dd	f	f	2022-01-29 00:00:00	\N	Bischofberger	Levi	2012	\N	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
8d849044-eaf0-45cd-bdb2-6fb2c61d0f51	f	f	2022-01-29 00:00:00	\N	Kühne	Leandro	2007	1683736	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
b1ce1724-b0cd-412f-b359-8539992a2cdc	f	f	2022-01-29 00:00:00	\N	Schoch	Nico	2002	679902	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
12274a9f-83e7-4247-9c43-a01d7cd613fc	f	f	2022-01-29 00:00:00	\N	Keller	Julian	2005	930830	1	7647310f-d340-4dc7-b6d8-bda7a5716728	f
7f322799-cd31-402a-b52f-e49d01f09993	f	f	2022-01-29 00:00:00	\N	Long	Oliver	2012	3388692	1	80c08ccc-c90e-4377-af3b-2de779197c7a	f
d07fba0a-40a9-4b74-a6f8-e8227e6f47e1	f	f	2022-01-29 00:00:00	\N	Tanner	Luca	2012	3472956	1	80c08ccc-c90e-4377-af3b-2de779197c7a	f
ecb1f79f-955a-4f6c-b384-9a4bafff1d35	f	f	2022-01-30 00:00:00	\N	Djebrit	Aissa	2013	3459765	1	1030974d-cffe-46d6-b6ea-79c8839cf2ea	f
96f979f4-2153-47dd-9ecb-87641f8f0749	f	f	2022-01-30 00:00:00	\N	Weeks	Nikola	2014	3558121	1	1030974d-cffe-46d6-b6ea-79c8839cf2ea	f
ed4e39f4-57d9-4005-9be0-dea0858e0281	f	f	2022-01-30 00:00:00	\N	Weeks	Nemanja	2012	3558119	1	1030974d-cffe-46d6-b6ea-79c8839cf2ea	f
4854fa23-b4e4-48d6-840e-54088b5b0f72	f	f	2022-01-21 00:00:00	\N	Landolt	Maurice	2013	\N	1	e2438143-6017-4683-a533-6113748d4117	f
e4f09bb0-eef8-4a1a-8b21-cba9bb7910c3	f	f	2022-01-22 00:00:00	\N	Hoch	Cedric	2011	3227881	1	1d2a9859-0137-4da2-8390-6cd570385ec4	f
94ff7338-7eb0-4867-a8bd-c5544feaac2b	f	f	2022-01-27 00:00:00	\N	Aeppli	Laura	2009	\N	0	a5302a2b-d270-49e5-9876-47c84cb38038	f
51991c27-abb9-4e54-94a3-7ef5bf932dc8	f	f	2022-01-23 00:00:00	\N	Bertschinger	Zoe	2008	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
a49ea6a6-30e5-482e-962c-458b747f23a8	f	f	2022-01-21 00:00:00	\N	Straus	Kim	2009	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
f1e4f67e-c63b-4de7-b53d-ffb0b975c9aa	f	f	2022-01-25 00:00:00	\N	Finocchio	Tara	2012	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
9136f058-3ebb-4285-bb85-a5a8ddd4b79e	f	f	2022-01-21 00:00:00	\N	Schelldorfer	Laura	2009	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
8be21209-74dc-43f2-90ae-899edab1754e	f	f	2022-01-21 00:00:00	\N	Jorns	Alina	2009	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
89381afc-46d6-4e04-a11c-de0320fbfc78	f	f	2022-01-25 00:00:00	\N	Umbricht	Mia	2013	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
6f9ec879-5961-4840-877e-b9de6defcde7	f	f	2022-01-23 00:00:00	\N	Feuerlein	Dana	2009	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
88a07c39-d9a1-4c44-a9f9-b42bb4e603cd	f	f	2022-01-21 00:00:00	\N	Pfyl	Jessica	2009	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
0cb847e6-92fd-416b-9497-7711594bb569	f	f	2022-01-23 00:00:00	\N	Greub	Yuna	2015	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
c8da0297-b38a-4b15-8cf1-e621a9b319af	f	f	2022-01-21 00:00:00	\N	Pletscher	Ronja	2010	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
d7db5199-4be7-40d0-9428-a41df05d3f4d	f	f	2022-01-21 00:00:00	\N	Lutz	Tamara	2007	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
51ba98e7-d5a9-4647-ad29-274b2c02437e	f	f	2022-01-21 00:00:00	\N	Oesch	Nura	2008	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
a1c3ceae-a308-4b08-8298-f00bff2a654a	f	f	2022-01-21 00:00:00	\N	Zängeler	Celina	2008	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
98c0ead9-1a8a-46f9-9f0d-95cebeb3fa4d	f	f	2022-01-21 00:00:00	\N	Hintermann	Aylin	2008	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
2f2eadc6-58fb-4495-bedf-681816ad717e	f	f	2022-01-21 00:00:00	\N	Ernst	Lucy	2009	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
51141fff-f4ec-4329-86d0-3d364981b666	f	f	2022-01-21 00:00:00	\N	Beaton	Zoe	2009	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
ee28252a-ed46-4f20-ac8d-b4668af7a11a	f	f	2022-01-25 00:00:00	\N	Hofmann	Ronja	2009	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
1f2c9273-0d7b-48c3-80f1-e332bfa394a5	f	f	2022-01-21 00:00:00	\N	Brombacher	Emma	2010	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
a8b593b4-b511-4cd8-9525-61302cd859fc	f	f	2022-01-23 00:00:00	\N	Mischler	Selina	2015	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
df4a26ac-5018-45bf-9df8-52070b216dac	f	f	2022-01-21 00:00:00	\N	Jäger	Lenya	2009	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
2fdb9ffd-a9d6-42ce-a6ac-cfe5b0f947cd	f	f	2022-01-21 00:00:00	\N	Stocker	Jil	2010	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
b26369da-8a80-4bf2-85e7-6f89ee0f5df2	f	f	2022-01-23 00:00:00	\N	Müller	Lina	2013	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
08b408c6-3097-43bb-b67e-091451c7f1e0	f	f	2022-01-21 00:00:00	\N	Kuipers	Nienke	2010	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
58f975ec-5698-4901-a51b-2ed21231a06b	f	f	2022-01-25 00:00:00	\N	Rossbach	Alicia	2010	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
b0b84556-1154-49ae-b24c-d48601a68237	f	f	2022-01-21 00:00:00	\N	Kaussen	Isabel	2011	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
ec897b52-2315-4648-92c3-3111c5725355	f	f	2022-01-23 00:00:00	\N	von Euw	Alea	2008	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
2c7dbbd4-245d-427b-8736-aaf4057255c9	f	f	2022-01-21 00:00:00	\N	Widmer	Louisa	2011	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
1c879e28-9222-40db-85b6-79be066fc9e0	f	f	2022-01-21 00:00:00	\N	Unternährer	Bella	2011	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
74843001-070e-4620-9e01-b86ab5970a9f	f	f	2022-01-23 00:00:00	\N	Zaugg	Michelle	2014	\N	0	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
27a8a796-f642-43df-862a-d6918cc9ca50	f	f	2022-01-21 00:00:00	\N	Meier	Haily	2011	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
02df6e15-dc3b-4178-aa36-6143fd599b1a	f	f	2022-01-25 00:00:00	\N	Rossbach	Noelia	2006	\N	0	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
2e968f4d-61d5-4b5c-a7e3-3de96e5e6657	f	f	2022-01-21 00:00:00	\N	Wettenschwiler	Mia	2011	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
121df43d-4074-45a0-9e24-89d43c0ff9ee	f	f	2022-01-25 00:00:00	\N	Arnold	Damian	2005	851429	1	d48095c7-3de5-4a8d-b893-b8d432e7c647	f
0c2aa755-6cfc-4ed3-93af-1c84919de12d	f	f	2022-01-21 00:00:00	\N	Eichenberger	Sophie	2011	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
637639e0-eab2-49e9-aaf5-d25d31995a30	f	f	2022-01-21 00:00:00	\N	Grauf	Naima	2011	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
ea49f3ca-5003-4032-ab34-d722cfda87ab	f	f	2022-01-21 00:00:00	\N	Grossenbacher	Cheyenne	2010	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
5cdcf9db-8780-4d70-b7e6-c55041131f31	f	f	2022-01-21 00:00:00	\N	Britt	Leni	2012	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
e7bd8211-f920-4efa-a97f-bd9aca38014b	f	f	2022-01-21 00:00:00	\N	Cuppone	Giuliana	2012	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
3e48b69f-527a-4e13-bb7a-25dc5943ecc3	f	f	2022-01-26 00:00:00	\N	Pfaller	Philip	2010	3141557	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
1891d952-6085-437f-8848-0821670cafbe	f	f	2022-01-21 00:00:00	\N	Jorns	Elea	2012	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
91a3f77c-3ba9-4c07-823a-627fead3c2a5	f	f	2022-01-21 00:00:00	\N	Weber	Therese	2012	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
73fa3706-776e-4728-bffb-a0bdf5542431	f	f	2022-01-21 00:00:00	\N	Marrero	Ayleen	2012	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
f66e79e7-bc77-4efe-a823-9253e5cbc9c8	f	f	2022-01-26 00:00:00	\N	Häberli	Nico	2004	542994	1	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	f
90a30b6c-edaf-468d-a96d-b9439e5e4c16	f	f	2022-01-21 00:00:00	\N	Budai	Emma	2012	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
8caf591f-960a-40fb-9963-39b42a8484c6	f	f	2022-01-22 00:00:00	\N	Gisi	Lukas	1999	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
44ba48c7-9ef2-4f89-b040-b69ad23df045	f	f	2022-01-21 00:00:00	\N	Budai	Anna	2012	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
af4f44cd-0ac8-4782-9beb-4817b40dbf42	f	f	2022-01-22 00:00:00	\N	Tschalèr	Danik	2009	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
7ce8a50a-6d45-46ac-847e-85f3c47afce5	f	f	2022-01-21 00:00:00	\N	Jud	Sinja	2012	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
d18b15cc-8213-4292-aafb-6a7a87597f08	f	f	2022-01-22 00:00:00	\N	Maissen	Rico	2008	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
c37872ea-37e8-47f1-9af3-16a2cfbc474e	f	f	2022-01-21 00:00:00	\N	Brombacher	Anabel	2014	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
2a495017-a1ec-4997-b0ff-b5f5b1292eaa	f	f	2022-01-22 00:00:00	\N	Thoma	Fabrice	2009	\N	1	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	f
7af09c92-0722-4781-99bd-4061b9c4a23a	f	f	2022-01-21 00:00:00	\N	Weber	Alexandra	2014	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
a7efed26-f4ec-4d7b-aa45-ce138c08d8b5	f	f	2022-01-23 00:00:00	\N	Mostak	Elias	2011	3146125	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
35ef02f5-6e0d-4b15-a261-0c04aefd8dcc	f	f	2022-01-21 00:00:00	\N	Ryffel	Elina	2014	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
15d35492-6126-46c1-a8ec-6d61cc113be1	f	f	2022-01-23 00:00:00	\N	Dette	Laurenz	2013	3480247	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
19bfa43e-bd2a-418f-9561-57f708c74bba	f	f	2022-01-21 00:00:00	\N	Rupp	Emily	0	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
1cfd9655-d0a7-41c5-b3b2-10fd42f07084	f	f	2022-01-23 00:00:00	\N	Schmidli	Fabio	2005	623594	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
eaf4e0de-e70e-40ab-9d96-f534465d0a1d	f	f	2022-01-21 00:00:00	\N	Chlebny	Helena	2014	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
81141c69-6869-4cfe-8e99-48e56e882f71	f	f	2022-01-23 00:00:00	\N	Tunesi	Dario	2011	3146129	1	b490aa6f-84cd-4be3-95da-7e230d5f645e	f
57554ab0-0176-4a04-926e-a9c6c85fec2d	f	f	2022-01-21 00:00:00	\N	Schneider	Jalina	2012	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
6ccc065f-7240-440e-9984-bf06ce6abd72	f	f	2022-01-21 00:00:00	\N	Howard	Holly	0	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
da115d88-2870-45bc-9739-f9c6728097b2	f	f	2022-01-25 00:00:00	\N	Benz	Maximilian	2009	1979436	1	24510313-6d39-4217-bb3f-0bfa7fbb73d3	f
2b950d2f-e455-4479-a2c0-87a7cb06265e	f	f	2022-01-21 00:00:00	\N	Öncü	Serenay	2014	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
23f6b48b-fc39-42e8-a995-948ba22a5750	f	f	2022-01-27 00:00:00	\N	Truninger	Gian	2013	3365671	1	a5302a2b-d270-49e5-9876-47c84cb38038	f
bc0b61f7-f7b6-41cb-8e30-0875d044f2d8	f	f	2022-01-21 00:00:00	\N	\N	\N	0	\N	0	81308200-79d0-466c-a19a-ca3fbef6045a	f
b2b033c1-ae1e-46c1-a971-2ffdb7a4118a	f	f	2022-01-21 00:00:00	\N	Ammann	Max	2013	\N	1	e2438143-6017-4683-a533-6113748d4117	f
b1e9adff-9671-4584-9e01-71f73814ad78	f	f	2022-01-21 00:00:00	\N	Aeberhard	Silvan	2003	869426	1	e2438143-6017-4683-a533-6113748d4117	f
fab019bc-a424-439d-bcc5-9f3ff55bc25e	f	f	2022-01-21 00:00:00	\N	Brandenberger	Jori	2012	5215414	1	e2438143-6017-4683-a533-6113748d4117	f
daf319cf-daf5-4172-861a-d0d8af80bd76	f	f	2022-01-21 00:00:00	\N	Halbritter	Julien	2013	3385157	1	e2438143-6017-4683-a533-6113748d4117	f
3c9f3b45-0056-4218-8d92-9315134151fe	f	f	2022-01-30 00:00:00	\N	Riesen	Colin	2014	3481652	1	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
48bc951f-879f-41b0-af57-1817fd5a32ab	f	f	2022-01-30 00:00:00	\N	Utz	Elia	2014	\N	1	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
bed78fb6-a0d8-4214-b76c-9a20c023e09d	f	f	2022-01-30 00:00:00	\N	Lamprecht	Maurus	2011	3174112	1	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
645f1e3e-fc8e-4aad-a4fa-cddf26df1a51	f	f	2022-01-30 00:00:00	\N	Meister	Joël	2009	3481650	1	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
d9a42722-adf8-4213-8f61-aed363a414d0	f	f	2022-01-30 00:00:00	\N	Wirth	Nino	2013	3481654	1	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
1022eb37-6cdf-4028-beff-91395e4d2105	f	f	2022-01-30 00:00:00	\N	Flacher	Neil	2008	3013399	1	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
21e88cf6-63bd-4b12-af51-eb7c53f22ef4	f	f	2022-01-30 00:00:00	\N	Kistler	Rodin	2007	931914	1	4e9262a1-fef9-4701-9c91-1b3016ee971d	f
3e44bd05-ade2-46c7-848c-136cbd862e4b	f	f	2022-01-31 00:00:00	\N	\N	\N	0	\N	0	08bfbb88-e782-4169-83fd-17b0fd03da18	f
03d40032-ff06-439a-ac1a-6eb2edac789b	f	f	2022-01-31 00:00:00	\N	Keller	Adrian	1994	861062	1	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	f
\.


--
-- Data for Name: teilnehmer_anlass_link; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teilnehmer_anlass_link (id, aktiv, deleted, change_date, deletion_date, kategorie, teilnehmer_id, anlass_id, organisation_id, startnummer, abteilung, anlage, startgeraet, melde_status) FROM stdin;
d7762955-f0ce-48d0-9e52-a8d94b37521b	t	f	2022-01-28 00:00:00	\N	K4	b62a15ae-bb28-4457-b078-8abcb6245e7c	b7440787-50bd-4e41-b38b-48acf37af0de	86a39d76-71ed-4890-82ec-ce2a48d32627	133	\N	\N	\N	STARTET
92015701-b53b-4a7e-8545-e199afec2b4b	t	f	2022-01-29 00:00:00	\N	K4	e94538bb-c604-4b5b-bb82-de73bed9fc43	b7440787-50bd-4e41-b38b-48acf37af0de	a5302a2b-d270-49e5-9876-47c84cb38038	134	\N	\N	\N	STARTET
d132fda2-5e62-444d-9dc8-dec8734f0fa3	t	f	2022-01-27 00:00:00	\N	K1	23f6b48b-fc39-42e8-a995-948ba22a5750	b7440787-50bd-4e41-b38b-48acf37af0de	a5302a2b-d270-49e5-9876-47c84cb38038	135	\N	\N	\N	STARTET
ba942068-9577-4b82-bfa1-32b4f364bffb	t	f	2022-01-29 00:00:00	\N	K5	a4cf5270-3435-49d8-a4d7-40b070f1c4ab	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	136	\N	\N	\N	STARTET
b763cae7-b683-4b9d-89e9-83fa46ff4159	t	f	2022-01-29 00:00:00	\N	K7	717ef780-9fcf-4658-9db6-693e62764908	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	137	\N	\N	\N	STARTET
dc4f6a20-217d-403b-ba20-53e42dda2153	f	f	2022-01-12 00:00:00	\N	KEIN_START	2a9bb7bd-52fb-45dc-a9fd-1a360472fa78	b7440787-50bd-4e41-b38b-48acf37af0de	2fc3365b-34d9-4054-b2d8-aa859c7455e7	\N	\N	\N	\N	\N
5f8a8dc9-2a64-4b34-9808-4502d0d496d1	t	f	2022-01-29 00:00:00	\N	K4	3375fcba-0144-4efa-ac46-160742fef0aa	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	138	\N	\N	\N	STARTET
309ca7fd-928f-47a5-a9a1-5bf3357f39a8	t	f	2022-01-29 00:00:00	\N	K3	1fcb183f-192a-477a-822b-1628def7bf3b	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	139	\N	\N	\N	STARTET
df034126-8844-45cd-b49d-2f07d1b9fb7f	t	f	2022-01-29 00:00:00	\N	K6	28ab6e33-9ef1-46f6-b2ef-82a2d3089947	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	140	\N	\N	\N	STARTET
8283949e-7d43-4934-951f-4e164bac235d	t	f	2022-01-30 00:00:00	\N	K3	ecb1f79f-955a-4f6c-b384-9a4bafff1d35	b7440787-50bd-4e41-b38b-48acf37af0de	1030974d-cffe-46d6-b6ea-79c8839cf2ea	141	\N	\N	\N	STARTET
b96e82e7-9ad7-4347-a8df-88f445e5ccc7	t	f	2022-01-30 00:00:00	\N	K3	645f1e3e-fc8e-4aad-a4fa-cddf26df1a51	b7440787-50bd-4e41-b38b-48acf37af0de	4e9262a1-fef9-4701-9c91-1b3016ee971d	142	\N	\N	\N	STARTET
55a38ed8-4764-4401-b506-47c78a56846e	f	f	2022-01-18 00:00:00	\N	KEIN_START	a054e6d4-5694-492b-a84c-49d8bd1f9ee9	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	\N	\N	\N	\N	\N
ce7222d6-40d8-4dc6-9eb9-b79f94e51378	t	f	2022-01-11 00:00:00	\N	K7	64deb490-e1c3-4564-a332-65cec17d5d9a	b7440787-50bd-4e41-b38b-48acf37af0de	205d3aed-6ce7-4cd3-8f6d-8d222d9d59b0	1	\N	\N	\N	\N
bb47ff1e-eed5-48c6-a491-ee54ffd781dd	t	f	2022-01-20 00:00:00	\N	K3	b58f7905-996a-4d8d-a05a-da9026a920eb	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	63	\N	\N	\N	\N
92a6b192-0929-4b70-9b7d-1db6a23a410f	t	f	2022-01-28 00:00:00	\N	K5	a0f3f7b1-957f-4390-92e5-64c5c8729e94	b7440787-50bd-4e41-b38b-48acf37af0de	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	143	\N	\N	\N	STARTET
1e358d4b-9275-48b0-84c7-ad67f550fd26	t	f	2022-01-28 00:00:00	\N	K3	ebf7ab72-5ca6-4aad-b3c2-544447752169	b7440787-50bd-4e41-b38b-48acf37af0de	86a39d76-71ed-4890-82ec-ce2a48d32627	144	\N	\N	\N	STARTET
9fb875f0-2f25-4872-8734-791c0ee3e37d	t	f	2022-01-28 00:00:00	\N	K1	74ca681f-08b0-49df-8ebd-20e38011e269	b7440787-50bd-4e41-b38b-48acf37af0de	86a39d76-71ed-4890-82ec-ce2a48d32627	145	\N	\N	\N	STARTET
41c4394d-e682-469a-bef5-63ed654f6cbd	t	f	2022-01-29 00:00:00	\N	K5	3772babe-b218-4435-8620-ca6aa766ee13	b7440787-50bd-4e41-b38b-48acf37af0de	a5302a2b-d270-49e5-9876-47c84cb38038	146	\N	\N	\N	STARTET
b6e3ac55-100e-440a-88eb-a20cbb9734eb	t	f	2022-01-29 00:00:00	\N	K4	255f7854-e5ef-46cf-8bb5-9df68b75b232	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	147	\N	\N	\N	STARTET
1cbfc2d8-482a-4dfd-83c7-fb1cf9288c0b	t	f	2022-01-29 00:00:00	\N	K4	8d849044-eaf0-45cd-bdb2-6fb2c61d0f51	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	148	\N	\N	\N	STARTET
77847b59-2927-43f0-909b-8dc40eb000b7	t	f	2022-01-29 00:00:00	\N	K2	29418401-87df-43e9-9901-12848ab49f09	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	149	\N	\N	\N	STARTET
0b1bb21e-2ab3-4a99-85ec-5913f1eac710	t	f	2022-01-29 00:00:00	\N	K2	afe3bbf8-c9d3-46af-9e74-0542ec131d89	b7440787-50bd-4e41-b38b-48acf37af0de	80c08ccc-c90e-4377-af3b-2de779197c7a	150	\N	\N	\N	STARTET
2c57cb2f-3f0f-4895-a6af-1f51eb6d61d0	t	f	2022-01-30 00:00:00	\N	K2	96f979f4-2153-47dd-9ecb-87641f8f0749	b7440787-50bd-4e41-b38b-48acf37af0de	1030974d-cffe-46d6-b6ea-79c8839cf2ea	151	\N	\N	\N	STARTET
5aa36089-8655-409e-8ad5-081f3e21ecc4	t	f	2022-01-30 00:00:00	\N	K1	d9a42722-adf8-4213-8f61-aed363a414d0	b7440787-50bd-4e41-b38b-48acf37af0de	4e9262a1-fef9-4701-9c91-1b3016ee971d	152	\N	\N	\N	STARTET
33061b51-0ef3-4e70-b99f-de0e1b3f1e47	t	f	2022-01-20 00:00:00	\N	K3	fcd79d30-7590-46b9-b332-b0f30f373753	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	64	\N	\N	\N	\N
d32fe80c-91f3-4dcb-904e-b6a4728dba66	t	f	2022-01-28 00:00:00	\N	K5	2a8b0a61-8a51-47cc-840d-bb8f2df430a9	b7440787-50bd-4e41-b38b-48acf37af0de	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	153	\N	\N	\N	STARTET
b6c674b7-3f7d-4dd2-8f73-333cee2df38c	t	f	2022-01-28 00:00:00	\N	K3	25ea10eb-fe1e-4c2d-a389-478ade1ec4bf	b7440787-50bd-4e41-b38b-48acf37af0de	86a39d76-71ed-4890-82ec-ce2a48d32627	154	\N	\N	\N	STARTET
3ec0ae77-c8d8-41b7-bb4b-dcac58254a3f	t	f	2022-01-28 00:00:00	\N	K2	8eff3577-8500-4dff-93a5-faa4d33fa2e3	b7440787-50bd-4e41-b38b-48acf37af0de	86a39d76-71ed-4890-82ec-ce2a48d32627	155	\N	\N	\N	STARTET
84ae15e4-fa2c-411c-b323-bca2191ee9cf	t	f	2022-01-29 00:00:00	\N	K1	56472a30-b319-4304-a86b-0eced54ede6c	b7440787-50bd-4e41-b38b-48acf37af0de	a5302a2b-d270-49e5-9876-47c84cb38038	156	\N	\N	\N	STARTET
27aff250-3410-4481-b23d-5ef0e67559b9	t	f	2022-01-29 00:00:00	\N	K5	a5d567e3-5134-4a77-a739-019c4b90404a	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	157	\N	\N	\N	STARTET
3a8deea6-b016-4800-b70a-cef3e8061c73	t	f	2022-01-29 00:00:00	\N	K5	688c540f-f846-437b-9884-875d19b83002	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	158	\N	\N	\N	STARTET
9da78c70-d1bc-422f-ba58-83d2b2cdef99	t	f	2022-01-29 00:00:00	\N	K2	7f322799-cd31-402a-b52f-e49d01f09993	b7440787-50bd-4e41-b38b-48acf37af0de	80c08ccc-c90e-4377-af3b-2de779197c7a	159	\N	\N	\N	STARTET
9a15fb36-9588-4efa-9f94-b412b1304e80	t	f	2022-01-30 00:00:00	\N	K1	48bc951f-879f-41b0-af57-1817fd5a32ab	b7440787-50bd-4e41-b38b-48acf37af0de	4e9262a1-fef9-4701-9c91-1b3016ee971d	160	\N	\N	\N	STARTET
57da2f0d-b2af-4c59-8c59-47de488cc90f	t	f	2022-01-30 00:00:00	\N	K5	21e88cf6-63bd-4b12-af51-eb7c53f22ef4	b7440787-50bd-4e41-b38b-48acf37af0de	4e9262a1-fef9-4701-9c91-1b3016ee971d	161	\N	\N	\N	STARTET
fc1cf727-e9b7-4cd4-b0d5-0638df5991a4	t	f	2022-01-31 00:00:00	\N	K7	03d40032-ff06-439a-ac1a-6eb2edac789b	b7440787-50bd-4e41-b38b-48acf37af0de	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	\N	\N	\N	\N	STARTET
53b0b6ee-7a13-4247-9d92-e9d59be6173f	t	f	2022-01-28 00:00:00	\N	K6	19e3f121-7083-44cd-8c12-7c44f05fe500	b7440787-50bd-4e41-b38b-48acf37af0de	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	162	\N	\N	\N	STARTET
931c5df6-0792-4939-bd38-554ca3bc2651	t	f	2022-01-28 00:00:00	\N	KEIN_START	9ed30a96-af19-43db-89f3-73ca4df8b908	b7440787-50bd-4e41-b38b-48acf37af0de	852ccab3-35f6-4d12-815c-d8b66ff664b7	163	\N	\N	\N	STARTET
a0e0f526-9894-45dd-980e-6aac5d9289e3	t	f	2022-01-29 00:00:00	\N	K5	54cf958b-d32f-4f4a-ad2c-8631dcb02d4c	b7440787-50bd-4e41-b38b-48acf37af0de	a5302a2b-d270-49e5-9876-47c84cb38038	164	\N	\N	\N	STARTET
2d9ecbc5-9c65-407d-81d1-dfd9cf2dc2e4	t	f	2022-01-29 00:00:00	\N	K1	b4c08eda-6c89-4078-bca0-5e994bb233ad	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	165	\N	\N	\N	STARTET
5a1d9765-f438-480a-8b58-9eb7631e7978	t	f	2022-01-29 00:00:00	\N	K2	d07fba0a-40a9-4b74-a6f8-e8227e6f47e1	b7440787-50bd-4e41-b38b-48acf37af0de	80c08ccc-c90e-4377-af3b-2de779197c7a	166	\N	\N	\N	STARTET
c6ee25ba-a58e-4cf8-b090-1cffc1800b29	t	f	2022-01-30 00:00:00	\N	K3	bed78fb6-a0d8-4214-b76c-9a20c023e09d	b7440787-50bd-4e41-b38b-48acf37af0de	4e9262a1-fef9-4701-9c91-1b3016ee971d	167	\N	\N	\N	STARTET
501c7fef-8f57-42e2-9034-f6cdccb61bef	t	f	2022-01-20 00:00:00	\N	K5	8b49f6f9-d79a-4897-a200-4b386fe350e3	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	65	\N	\N	\N	\N
63ee5118-04aa-4c24-8452-687944252a73	t	f	2022-01-20 00:00:00	\N	K6	4e732183-e839-4bcf-9a5b-e507bb5f9a03	b7440787-50bd-4e41-b38b-48acf37af0de	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	66	\N	\N	\N	\N
87f9c6d6-4ef7-4fb2-8f27-11082d569531	t	f	2022-01-20 00:00:00	\N	KH	bbeb3d70-1dd8-4e90-8d76-88c96cdac44e	b7440787-50bd-4e41-b38b-48acf37af0de	81308200-79d0-466c-a19a-ca3fbef6045a	67	\N	\N	\N	\N
0aeb5c6a-613f-4cbe-9194-7f299a5a8162	t	f	2022-01-20 00:00:00	\N	KH	01030c92-61c5-4f79-8212-3a55173d20a2	b7440787-50bd-4e41-b38b-48acf37af0de	81308200-79d0-466c-a19a-ca3fbef6045a	68	\N	\N	\N	\N
0f97ecf5-4c2a-4401-920d-aab5ce871d4b	t	f	2022-01-20 00:00:00	\N	K3	8d15484c-5014-42c7-b493-f0b6579978c2	b7440787-50bd-4e41-b38b-48acf37af0de	81308200-79d0-466c-a19a-ca3fbef6045a	69	\N	\N	\N	\N
51741fca-c0a4-403e-9d41-43905c83fc66	t	f	2022-01-20 00:00:00	\N	K3	3409cfd5-f7e4-4c8c-925d-ee2ddba3cf14	b7440787-50bd-4e41-b38b-48acf37af0de	81308200-79d0-466c-a19a-ca3fbef6045a	70	\N	\N	\N	\N
cb04a3f3-8d10-4059-a476-36f55dd237e8	t	f	2022-01-20 00:00:00	\N	K3	e4b88a97-f310-4b22-8af8-d33c896dabf0	b7440787-50bd-4e41-b38b-48acf37af0de	81308200-79d0-466c-a19a-ca3fbef6045a	71	\N	\N	\N	\N
8326ae41-4438-4448-9e6c-be7611ac489d	t	f	2022-01-20 00:00:00	\N	K1	b82f2f24-5c23-4249-9413-02783705d856	b7440787-50bd-4e41-b38b-48acf37af0de	81308200-79d0-466c-a19a-ca3fbef6045a	72	\N	\N	\N	\N
dcae4301-ee71-4b60-a84e-73bef41e132f	t	f	2022-01-22 00:00:00	\N	K5	b437e6cc-1184-44f5-ba23-558e718213a4	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	73	\N	\N	\N	\N
f777a164-7a4e-4f63-8649-a5501c75cb36	t	f	2022-01-22 00:00:00	\N	K3	6b4dd7dc-ece8-4433-9d23-16a2928e8829	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	74	\N	\N	\N	\N
09a5fbd4-939c-4c9f-8011-26ce6e657975	t	f	2022-01-22 00:00:00	\N	K5	e39700e8-07a8-4fd5-9bc3-b128ee229568	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	75	\N	\N	\N	\N
230e2fea-30c8-4bbe-8e61-03b554e67ad9	t	f	2022-01-22 00:00:00	\N	K3	354b2ec6-febd-4c82-8ce0-cb8abc99262a	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	76	\N	\N	\N	\N
9e71cdf4-5684-4641-b804-3e0bd4c58d24	t	f	2022-01-22 00:00:00	\N	K5	2a495017-a1ec-4997-b0ff-b5f5b1292eaa	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	77	\N	\N	\N	\N
a93240df-14dd-49a8-b9dc-f0779186202e	t	f	2022-01-28 00:00:00	\N	K3	ca588032-b5f0-4e01-b110-d2604ac0e738	b7440787-50bd-4e41-b38b-48acf37af0de	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	168	\N	\N	\N	STARTET
02b8077b-84ff-470b-8f55-93b1a5cdbe01	t	f	2022-01-28 00:00:00	\N	KEIN_START	98412219-6445-40a2-b56a-f7f38a4b16ff	b7440787-50bd-4e41-b38b-48acf37af0de	852ccab3-35f6-4d12-815c-d8b66ff664b7	169	\N	\N	\N	STARTET
b57f32ab-9051-41af-92a7-7a971ab46b77	t	f	2022-01-29 00:00:00	\N	K2	f24aa5e9-e827-45a8-9644-2745b5a1d6dd	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	170	\N	\N	\N	STARTET
ac2a8dba-6480-4a52-afa2-48742d7d7434	t	f	2022-01-29 00:00:00	\N	K4	adcce6c1-2fe3-4199-9f9d-222464c36ef5	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	171	\N	\N	\N	STARTET
a1810fe3-9c11-485e-adda-6004d2d27190	t	f	2022-01-29 00:00:00	\N	K6	b1ce1724-b0cd-412f-b359-8539992a2cdc	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	172	\N	\N	\N	STARTET
64b2656e-4fb1-4047-a773-5f019403714b	t	f	2022-01-29 00:00:00	\N	K7	c33749e2-6b2a-40cf-a699-fbaa97c1a492	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	173	\N	\N	\N	STARTET
0f8a6273-5bd7-42a6-804b-41832c968e24	t	f	2022-01-30 00:00:00	\N	K3	8a7f4911-b143-4c6b-9cda-40c426158f0d	b7440787-50bd-4e41-b38b-48acf37af0de	1030974d-cffe-46d6-b6ea-79c8839cf2ea	174	\N	\N	\N	STARTET
870d7588-21a0-47af-86f2-35219802bb05	t	f	2022-01-30 00:00:00	\N	K5	1022eb37-6cdf-4028-beff-91395e4d2105	b7440787-50bd-4e41-b38b-48acf37af0de	4e9262a1-fef9-4701-9c91-1b3016ee971d	175	\N	\N	\N	STARTET
03e7e9c4-bc39-48b8-9542-705011e041e2	t	f	2022-01-11 00:00:00	\N	K5	daa197bf-60ea-41fb-af9b-2d48c57d9d6e	b7440787-50bd-4e41-b38b-48acf37af0de	205d3aed-6ce7-4cd3-8f6d-8d222d9d59b0	2	\N	\N	\N	\N
4fe407e2-b458-4e0a-9097-3d1d6cf64846	t	f	2022-01-11 00:00:00	\N	K3	43d79d88-2bfb-4899-9635-87db5b1ebb4d	b7440787-50bd-4e41-b38b-48acf37af0de	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	3	\N	\N	\N	\N
4e875274-dcb8-4cf7-a815-a859ab8769c6	t	f	2022-01-11 00:00:00	\N	K3	208cba42-90ab-4392-a889-770f7e5371a5	b7440787-50bd-4e41-b38b-48acf37af0de	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	4	\N	\N	\N	\N
af78d590-5852-4f0b-b4f0-a3bec4cf07a4	t	f	2022-01-11 00:00:00	\N	K3	6c96f71b-45c5-437b-88e2-cf38bfa5cead	b7440787-50bd-4e41-b38b-48acf37af0de	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	5	\N	\N	\N	\N
a6da34a8-72ae-454c-a373-d15077882780	t	f	2022-01-11 00:00:00	\N	K3	6699bdaf-f027-45bd-9f8e-cc9e1596e57e	b7440787-50bd-4e41-b38b-48acf37af0de	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	6	\N	\N	\N	\N
95311922-6784-4d41-8159-2e94013f6444	t	f	2022-01-11 00:00:00	\N	K3	1ace9385-c200-4162-b8f2-ee20a21de12b	b7440787-50bd-4e41-b38b-48acf37af0de	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	7	\N	\N	\N	\N
a25cd90b-73eb-4761-a287-405299206e19	t	f	2022-01-11 00:00:00	\N	K6	ecd18d1b-5ff9-402b-acb0-a7c024d7405a	b7440787-50bd-4e41-b38b-48acf37af0de	8b92d8ae-ce49-4ffb-842d-9de90fb5737f	8	\N	\N	\N	\N
2f437dd4-2682-45d9-97a3-3ae285397510	t	f	2022-01-11 00:00:00	\N	K7	964f1a26-1db4-4d92-ace7-e1e8d1040fe7	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	9	\N	\N	\N	\N
40dcf79d-d660-478d-8e48-ca3bef7f8a4c	t	f	2022-01-11 00:00:00	\N	K4	6054e9bf-9754-4ff1-b893-d434aa8c9c14	b7440787-50bd-4e41-b38b-48acf37af0de	89e47949-21f1-4855-a397-20c3bc3426d7	10	\N	\N	\N	\N
16532e6d-542d-47a2-bd37-4e81559c8f6a	t	f	2022-01-11 00:00:00	\N	K7	97e40a84-12ab-4196-9a07-251795684d05	b7440787-50bd-4e41-b38b-48acf37af0de	89e47949-21f1-4855-a397-20c3bc3426d7	11	\N	\N	\N	\N
8e3df435-f40f-4493-8a03-f3fdc0c38eec	t	f	2022-01-11 00:00:00	\N	K5	8ce8b225-cfbc-48dc-8ec0-ff766f8af8ba	b7440787-50bd-4e41-b38b-48acf37af0de	89e47949-21f1-4855-a397-20c3bc3426d7	12	\N	\N	\N	\N
68e756f8-5243-407d-8a70-a84d970120ce	t	f	2022-01-18 00:00:00	\N	K4	27021346-5559-4115-93c3-6d701d79d793	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	13	\N	\N	\N	\N
50a10158-eefd-4398-a70f-a2aa5f866e78	t	f	2022-01-18 00:00:00	\N	K1	c6fb9e89-a866-4d37-8a3b-483e342056a8	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	14	\N	\N	\N	\N
99d384db-58bc-4496-aab3-50c0811819ed	t	f	2022-01-13 00:00:00	\N	K4	3ff268d4-5f14-47c2-b97c-6dd626e6d5f7	b7440787-50bd-4e41-b38b-48acf37af0de	a60429c0-6964-454b-8ee1-ddad66957f06	15	\N	\N	\N	\N
457d8b84-e7e3-4013-8d46-9b9f1d4a89e5	t	f	2022-01-13 00:00:00	\N	K2	31c0e81b-0100-473b-8b83-b166c58d30c0	b7440787-50bd-4e41-b38b-48acf37af0de	a60429c0-6964-454b-8ee1-ddad66957f06	16	\N	\N	\N	\N
924ec5d6-245d-4c2f-bef3-e043f195ddf4	t	f	2022-01-13 00:00:00	\N	K6	846a1295-b969-4696-9aa3-490d714ed495	b7440787-50bd-4e41-b38b-48acf37af0de	a60429c0-6964-454b-8ee1-ddad66957f06	17	\N	\N	\N	\N
78c654bc-fdac-4778-9785-6525033266e9	t	f	2022-01-13 00:00:00	\N	K3	44cd2080-cd4d-4cc7-b3d0-59049ec6a039	b7440787-50bd-4e41-b38b-48acf37af0de	a60429c0-6964-454b-8ee1-ddad66957f06	18	\N	\N	\N	\N
1b7d4299-e39d-4a07-9720-a45ddbd4b2b8	t	f	2022-01-13 00:00:00	\N	K3	d47e529c-488c-4d0a-8701-4660764839a4	b7440787-50bd-4e41-b38b-48acf37af0de	a60429c0-6964-454b-8ee1-ddad66957f06	19	\N	\N	\N	\N
ac9880e0-abdc-4698-8ff8-cbb0ad29f30e	t	f	2022-01-13 00:00:00	\N	K6	f823ade5-ba29-4694-95b2-96fe94ae61f3	b7440787-50bd-4e41-b38b-48acf37af0de	a60429c0-6964-454b-8ee1-ddad66957f06	20	\N	\N	\N	\N
bf16e180-dd88-4f4d-8413-f113d5b695c2	t	f	2022-01-13 00:00:00	\N	K2	24d83ab7-2161-4bdd-8c73-ca2eb83e2f41	b7440787-50bd-4e41-b38b-48acf37af0de	a60429c0-6964-454b-8ee1-ddad66957f06	21	\N	\N	\N	\N
fa75a809-367c-4847-aec7-13e5f0d5c9dc	t	f	2022-01-13 00:00:00	\N	K2	15d210c8-1e12-46ee-8aea-cf05f9932a53	b7440787-50bd-4e41-b38b-48acf37af0de	a60429c0-6964-454b-8ee1-ddad66957f06	22	\N	\N	\N	\N
90409784-0f18-401b-846c-31f1af143b40	t	f	2022-01-14 00:00:00	\N	K2	1b4854d8-20ad-4930-b1c3-3240dc956831	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	23	\N	\N	\N	\N
4e4bcb83-954a-4870-b98b-6a4dd096dece	t	f	2022-01-14 00:00:00	\N	K1	b3f9bd7c-c964-484f-ba2a-eed971e6302e	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	24	\N	\N	\N	\N
8e46b400-5854-4c08-b194-7819d3918c77	t	f	2022-01-14 00:00:00	\N	K3	5828b5e1-f4c0-469d-99b2-1d63dc7b663c	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	25	\N	\N	\N	\N
af15fa03-3abf-40c8-9e4a-c968517b624f	t	f	2022-01-14 00:00:00	\N	K4	191b7c4a-462a-48ad-a967-12dd83e31dca	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	26	\N	\N	\N	\N
7a246b48-6a46-4df2-a7ea-7ed627856611	t	f	2022-01-18 00:00:00	\N	K2	5976ff8a-30e4-4941-8240-f63393169543	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	27	\N	\N	\N	\N
a1131bf0-f2ca-437c-9ba4-9388402ef5ee	t	f	2022-01-18 00:00:00	\N	K4	1d6c2970-01e1-4731-bee7-ad90613533db	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	28	\N	\N	\N	\N
2f67f7ba-1a15-4063-8c04-ed4e0d7ce560	t	f	2022-01-14 00:00:00	\N	K1	1ae54287-50bc-45bc-9b79-1b5f19f5d85b	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	29	\N	\N	\N	\N
c9f1c823-1235-47a3-a318-5b5a06da4fac	t	f	2022-01-14 00:00:00	\N	K2	dacbe400-de12-41ae-b085-1539b49f1d84	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	30	\N	\N	\N	\N
ab996989-a59d-44b6-90c8-babe0e099207	t	f	2022-01-14 00:00:00	\N	K4	f37982fe-3e6d-4eda-abda-8ac5755df352	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	31	\N	\N	\N	\N
98c45d7c-82c4-4f8e-bf23-44bb98c482c9	t	f	2022-01-17 00:00:00	\N	K1	5f6d8771-f6b1-482f-9e6c-87448c63dfdc	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	32	\N	\N	\N	\N
6b28aba7-470d-48bc-8dcd-3914911c6c29	t	f	2022-01-17 00:00:00	\N	K4	6247b048-7eff-40f7-a159-0a799e31b694	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	33	\N	\N	\N	\N
0b4868c8-1017-49f8-aee0-2867825637b3	t	f	2022-01-17 00:00:00	\N	K5	ba61a7bb-2162-4e6d-8951-f97e8972fb03	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	34	\N	\N	\N	\N
628f5d12-759e-44cc-b342-6afc0a61713f	t	f	2022-01-17 00:00:00	\N	K5	57454bda-dac9-44db-96a5-0912760e67bc	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	35	\N	\N	\N	\N
7565541b-c50f-44c4-a38a-c22b4ea68c84	t	f	2022-01-17 00:00:00	\N	K4	73edd0ac-2789-415c-9a52-25b554526e8e	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	36	\N	\N	\N	\N
35ee38df-4b40-4161-acb4-ca4a530e61ec	t	f	2022-01-17 00:00:00	\N	K3	2fac7e69-8bcc-44f6-aa39-17c3ca51a89c	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	37	\N	\N	\N	\N
02ef5c2c-3d23-4da3-83e9-123f05c44e3f	t	f	2022-01-17 00:00:00	\N	K4	691c3b72-32c7-4c84-bac6-025d7afc2654	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	38	\N	\N	\N	\N
00e80666-07cb-4115-8219-2dfe6d2e8870	t	f	2022-01-17 00:00:00	\N	K4	e49aadfa-195f-4c25-b698-812bfdadb682	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	39	\N	\N	\N	\N
57a671cd-e981-44d1-a751-01472ed22c3b	t	f	2022-01-17 00:00:00	\N	K3	dbfa3cb3-f422-4d5b-a506-e745ef4f8ac5	b7440787-50bd-4e41-b38b-48acf37af0de	e3df7bcf-4e86-48a6-92de-474fa94729a3	40	\N	\N	\N	\N
b3ed9214-162c-4541-bc62-8509aaeae980	t	f	2022-01-17 00:00:00	\N	K5	d937d2c4-390f-4509-835b-0f8a2a0ec53d	b7440787-50bd-4e41-b38b-48acf37af0de	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	41	\N	\N	\N	\N
1e00ea56-5261-4b1b-9c1b-14e1e3f30340	t	f	2022-01-17 00:00:00	\N	K2	27316a2b-be20-426c-b73f-ff55d3b38cc7	b7440787-50bd-4e41-b38b-48acf37af0de	9d7e4d7e-0248-4ba3-a381-3d8f11c76b76	42	\N	\N	\N	\N
8099e9b6-128e-49c4-99d0-75baf3d5bab9	t	f	2022-01-18 00:00:00	\N	K1	0196ce81-9179-4c8f-83c4-d89d66d2532c	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	43	\N	\N	\N	\N
d1a8cc5e-90dd-4c8b-952c-a974dbab4521	t	f	2022-01-18 00:00:00	\N	K3	6f4cf34f-bfe3-49ac-963f-dc31bb85dc66	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	44	\N	\N	\N	\N
c9f8bef9-6b3c-497e-8a87-09f3191921d6	t	f	2022-01-18 00:00:00	\N	K3	ed16ea6c-1df1-4643-9ed8-5f91c3f07c38	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	45	\N	\N	\N	\N
1e95ec22-128e-4d52-a554-4bfd2d993840	t	f	2022-01-18 00:00:00	\N	K4	f863d3da-aad8-4606-ba98-0a69ce2535f2	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	46	\N	\N	\N	\N
a097c55d-6d23-47cc-8f70-54259888f7d0	t	f	2022-01-18 00:00:00	\N	K2	92148697-c598-405e-bdd0-16a81d328b20	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	47	\N	\N	\N	\N
99793333-157b-48d5-b6c9-3d650562dd85	t	f	2022-01-18 00:00:00	\N	K2	e40fe43e-d429-406b-8a46-9720bec4f297	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	48	\N	\N	\N	\N
95338092-5204-4837-a9ad-631cdca8a1ec	t	f	2022-01-18 00:00:00	\N	K5	7efe5df5-da80-47f3-bb9f-a1c79089d1ba	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	49	\N	\N	\N	\N
bceb81e1-e61a-4bc8-9067-04aed90069b5	t	f	2022-01-18 00:00:00	\N	K5	062d0f21-91aa-4219-8f38-7d89acb1413b	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	50	\N	\N	\N	\N
60e2bd39-f070-4721-aefa-f2285277d62a	t	f	2022-01-18 00:00:00	\N	K5	a4ba36d3-c94f-4be7-abe2-be781a91a4c7	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	51	\N	\N	\N	\N
aaf0ccab-2fa6-4e32-bf0e-6d144f99b123	t	f	2022-01-18 00:00:00	\N	K6	5ea6fa08-0baa-4f4d-b3be-418c6a9a52a8	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	52	\N	\N	\N	\N
27ec8246-dfb1-4cec-9b01-4232515a75c3	t	f	2022-01-19 00:00:00	\N	K1	c4805559-715e-4683-a517-a30714a7c295	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	53	\N	\N	\N	\N
242bfac8-8e80-46b8-aed5-b57730395821	t	f	2022-01-19 00:00:00	\N	K2	91caefba-e34c-4bba-b3b8-f80a1aed5a9a	b7440787-50bd-4e41-b38b-48acf37af0de	688a34cb-72f2-4920-aeb3-89325956de26	54	\N	\N	\N	\N
561c2e65-54a0-4ebf-af84-188afca6aec9	t	f	2022-01-20 00:00:00	\N	K1	d45f228f-96f1-47de-9612-775222437b36	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	55	\N	\N	\N	\N
06ffe66a-b402-4201-9067-1e3d7982652e	t	f	2022-01-19 00:00:00	\N	K7	8828320f-f23b-40fb-9868-520849448037	b7440787-50bd-4e41-b38b-48acf37af0de	854e7b58-34dc-4ed5-ac6c-f233476b1e9e	56	\N	\N	\N	\N
2a449255-7606-4a77-b31f-1f7f0e01926c	t	f	2022-01-19 00:00:00	\N	K7	87247b7e-c974-4fe9-b496-38049c3b8231	b7440787-50bd-4e41-b38b-48acf37af0de	854e7b58-34dc-4ed5-ac6c-f233476b1e9e	57	\N	\N	\N	\N
d5d30b27-9671-4299-a2a7-8cc858d8656f	t	f	2022-01-20 00:00:00	\N	K1	26636a78-0791-4c4d-87fb-5e6a1027c123	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	58	\N	\N	\N	\N
ad88b19c-c48c-4023-b995-6f8a14776ddd	t	f	2022-01-20 00:00:00	\N	K4	e4a7eb54-db20-4a74-a741-944bca117acb	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	59	\N	\N	\N	\N
84411f19-79f5-4f76-8807-66896f3d6e89	t	f	2022-01-20 00:00:00	\N	K3	fa9887e0-680c-479a-8ac7-3c8f2e3f4769	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	60	\N	\N	\N	\N
40bdd840-f587-4b5f-b357-f21b80027b68	t	f	2022-01-20 00:00:00	\N	K1	6d124e5a-4eb3-41e7-96c4-81e10bc865d5	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	61	\N	\N	\N	\N
bceb48cd-e891-4ba2-b10f-497af1972f80	t	f	2022-01-20 00:00:00	\N	K2	25718b42-a27c-4fb2-b9a3-0a012e44f6c3	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	62	\N	\N	\N	\N
c4d178d0-72f9-42f3-a77f-0be997b721fa	t	f	2022-01-22 00:00:00	\N	K6	8caf591f-960a-40fb-9963-39b42a8484c6	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	78	\N	\N	\N	\N
84b46cbd-4093-4f0a-81f1-70a81a9a8aca	t	f	2022-01-22 00:00:00	\N	K5	af4f44cd-0ac8-4782-9beb-4817b40dbf42	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	79	\N	\N	\N	\N
23212a99-8184-4b5c-b67c-6a03660d44c7	t	f	2022-01-22 00:00:00	\N	K5	dbf71678-6772-4c24-8d95-2966f0afad08	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	80	\N	\N	\N	\N
afa2c5d3-5e2c-44c1-a112-ad823ab11ce8	t	f	2022-01-22 00:00:00	\N	KEIN_START	81acf225-0226-4232-b5be-2691aa4fc5f8	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	81	\N	\N	\N	\N
21745be8-4627-46cf-95cd-43f85b46194b	t	f	2022-01-22 00:00:00	\N	KEIN_START	d18b15cc-8213-4292-aafb-6a7a87597f08	b7440787-50bd-4e41-b38b-48acf37af0de	f70f01bf-53ff-48cd-8b6d-95a652b9d44e	82	\N	\N	\N	\N
457c4e89-04a2-4bd4-a8b6-1b52bbf678ca	t	f	2022-01-22 00:00:00	\N	K2	07160725-0859-4a58-9d65-89677de3c1ee	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	83	\N	\N	\N	\N
6bb1d0a3-bbe9-4492-82af-f79376bd8c85	t	f	2022-01-22 00:00:00	\N	K4	02a156d2-3f1d-4371-b9ed-2e9cdc2a1905	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	84	\N	\N	\N	\N
b8175947-953b-409b-89a0-775b78eb1cf6	t	f	2022-01-22 00:00:00	\N	K3	e4f09bb0-eef8-4a1a-8b21-cba9bb7910c3	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	85	\N	\N	\N	\N
6829253f-0186-4e32-a3bb-4ea2b2c0d53d	t	f	2022-01-22 00:00:00	\N	K1	162dceab-8d0a-4e66-8cf2-7ec51717b40e	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	86	\N	\N	\N	\N
c3bfa2f0-6f8a-4002-9634-2e1aae347140	t	f	2022-01-22 00:00:00	\N	K1	048ae246-167f-4b2d-a737-9b9c236f002b	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	87	\N	\N	\N	\N
f1a366d1-5ee7-45c7-be4d-cb2b3d89b0f2	t	f	2022-01-22 00:00:00	\N	K1	056b99cb-c46d-4a05-aa6a-efbca6a73941	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	88	\N	\N	\N	\N
89a7d996-2297-4a88-9075-815688688738	t	f	2022-01-22 00:00:00	\N	KEIN_START	5308ed6a-e60f-491a-9b2c-26da8e2cfa8e	b7440787-50bd-4e41-b38b-48acf37af0de	1d2a9859-0137-4da2-8390-6cd570385ec4	89	\N	\N	\N	\N
7d828932-1cb9-409a-8bb5-6dca1909c5e0	t	f	2022-01-23 00:00:00	\N	K4	c49e6c4c-a355-4993-aa0c-425282edc247	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	90	\N	\N	\N	\N
3e9dc560-cb33-4435-958e-ec86dca13dea	t	f	2022-01-23 00:00:00	\N	K5	12452659-e21d-48c7-8f95-ead28d3f8040	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	91	\N	\N	\N	\N
59e76e6c-72e7-4d05-9919-647a473368fc	t	f	2022-01-23 00:00:00	\N	K5	3481528b-0476-4851-87cc-56138eb7d80b	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	92	\N	\N	\N	\N
c520ae93-6ac5-40e5-a23a-f287414adedf	t	f	2022-01-23 00:00:00	\N	K4	b4dc29c0-a537-41b1-9f13-a6dd38e7725d	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	93	\N	\N	\N	\N
cbb86123-c3bf-4838-84b1-3b118704c499	t	f	2022-01-23 00:00:00	\N	K5	1cfd9655-d0a7-41c5-b3b2-10fd42f07084	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	94	\N	\N	\N	\N
6131ead1-6c79-471d-8890-942812722564	t	f	2022-01-23 00:00:00	\N	K4	b1e4025d-1ba5-4fb4-b21c-00c8e74c1db5	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	95	\N	\N	\N	\N
d12e54d1-4e16-4ab0-a9d5-7412a1895911	t	f	2022-01-23 00:00:00	\N	K3	81141c69-6869-4cfe-8e99-48e56e882f71	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	96	\N	\N	\N	\N
276a9f90-78c0-4962-8265-d3f15932fe67	t	f	2022-01-23 00:00:00	\N	K3	a7efed26-f4ec-4d7b-aa45-ce138c08d8b5	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	97	\N	\N	\N	\N
54238b56-7347-45ea-a4d4-85dda3aa85be	t	f	2022-01-23 00:00:00	\N	K2	15d35492-6126-46c1-a8ec-6d61cc113be1	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	98	\N	\N	\N	\N
8f69c94b-1920-4c54-8a0a-60c63a411194	t	f	2022-01-23 00:00:00	\N	K2	00eecc59-5b8b-407d-b7cb-a3a65af878be	b7440787-50bd-4e41-b38b-48acf37af0de	b490aa6f-84cd-4be3-95da-7e230d5f645e	99	\N	\N	\N	\N
d82dbdf2-60da-4825-bd3e-73c4cac12c6f	t	f	2022-01-24 00:00:00	\N	K2	4854fa23-b4e4-48d6-840e-54088b5b0f72	b7440787-50bd-4e41-b38b-48acf37af0de	e2438143-6017-4683-a533-6113748d4117	100	\N	\N	\N	\N
46087146-bd11-449c-a7a3-1093bbd6f8ed	t	f	2022-01-24 00:00:00	\N	K2	625b0f35-302b-4ef3-99c4-8d61475bcbdd	b7440787-50bd-4e41-b38b-48acf37af0de	e2438143-6017-4683-a533-6113748d4117	101	\N	\N	\N	\N
98a6a345-21a0-402f-a43a-25688d2ceec7	t	f	2022-01-24 00:00:00	\N	K5	4182b334-d25c-442d-85cd-af5c553cb91b	b7440787-50bd-4e41-b38b-48acf37af0de	e2438143-6017-4683-a533-6113748d4117	102	\N	\N	\N	\N
fbf272f1-dd1c-43a0-a078-7d72ccb80a25	t	f	2022-01-24 00:00:00	\N	KEIN_START	b2b033c1-ae1e-46c1-a971-2ffdb7a4118a	b7440787-50bd-4e41-b38b-48acf37af0de	e2438143-6017-4683-a533-6113748d4117	103	\N	\N	\N	\N
6bcf15d7-9537-4d2b-9d1c-71129aa16b65	t	f	2022-01-24 00:00:00	\N	K5	b1e9adff-9671-4584-9e01-71f73814ad78	b7440787-50bd-4e41-b38b-48acf37af0de	e2438143-6017-4683-a533-6113748d4117	104	\N	\N	\N	\N
c8eb1b50-8af3-4c69-8162-15aada40bfce	t	f	2022-01-24 00:00:00	\N	KEIN_START	fab019bc-a424-439d-bcc5-9f3ff55bc25e	b7440787-50bd-4e41-b38b-48acf37af0de	e2438143-6017-4683-a533-6113748d4117	105	\N	\N	\N	\N
3ca0c89b-adbb-4bca-bdc2-634da6dfffd4	t	f	2022-01-24 00:00:00	\N	K2	daf319cf-daf5-4172-861a-d0d8af80bd76	b7440787-50bd-4e41-b38b-48acf37af0de	e2438143-6017-4683-a533-6113748d4117	106	\N	\N	\N	\N
3a100d66-58a8-4fb3-9005-e071438d3c14	t	f	2022-01-25 00:00:00	\N	K3	e4bf521f-e7b9-40c3-95e3-d2e43966ca55	b7440787-50bd-4e41-b38b-48acf37af0de	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	107	\N	\N	\N	\N
115d0c58-f77b-4c73-b2a4-49fabaf05fd3	t	f	2022-01-25 00:00:00	\N	K4	ba0b968d-7d83-4265-b0f5-9032be1fe45e	b7440787-50bd-4e41-b38b-48acf37af0de	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	108	\N	\N	\N	\N
98658c5d-d627-4673-be74-69418cc8f402	t	f	2022-01-25 00:00:00	\N	K2	99047440-a28d-4a9e-98c9-8a5a5b2d7517	b7440787-50bd-4e41-b38b-48acf37af0de	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	109	\N	\N	\N	\N
b1ee9179-e975-4240-819b-6b85905798c4	t	f	2022-01-25 00:00:00	\N	K2	7e3f0c97-7735-411d-903d-dd8b4faa323c	b7440787-50bd-4e41-b38b-48acf37af0de	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	110	\N	\N	\N	\N
bae753fe-4f73-4ed4-b66e-7aef17dd30f1	t	f	2022-01-25 00:00:00	\N	K3	d2d3bfd6-d7e9-4074-a64b-dca909758826	b7440787-50bd-4e41-b38b-48acf37af0de	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	111	\N	\N	\N	\N
dabd5904-1c52-4df7-b138-a1c7cc27f35d	t	f	2022-01-25 00:00:00	\N	K3	da115d88-2870-45bc-9739-f9c6728097b2	b7440787-50bd-4e41-b38b-48acf37af0de	24510313-6d39-4217-bb3f-0bfa7fbb73d3	112	\N	\N	\N	\N
f628db01-0358-411e-b68c-7814d135b754	t	f	2022-01-10 00:00:00	\N	KEIN_START	8f6e628f-13e7-4bf8-a661-7776005d8247	b7440787-50bd-4e41-b38b-48acf37af0de	2fc3365b-34d9-4054-b2d8-aa859c7455e7	113	\N	\N	\N	STARTET
02b44384-df88-4ed5-b565-e8e143f2045e	t	f	2022-01-25 00:00:00	\N	KEIN_START	de0d5c86-4883-4f47-ad70-a6aa4dfea332	b7440787-50bd-4e41-b38b-48acf37af0de	2fc3365b-34d9-4054-b2d8-aa859c7455e7	114	\N	\N	\N	STARTET
e5521b4e-c4aa-42f9-aa23-a5b30ae71c80	t	f	2022-01-25 00:00:00	\N	K5	121df43d-4074-45a0-9e24-89d43c0ff9ee	b7440787-50bd-4e41-b38b-48acf37af0de	d48095c7-3de5-4a8d-b893-b8d432e7c647	115	\N	\N	\N	STARTET
a143c796-aa6a-4e5a-981d-9345afce4692	t	f	2022-01-25 00:00:00	\N	K4	f4b75c50-054e-4da8-8350-1d84232b6441	b7440787-50bd-4e41-b38b-48acf37af0de	d48095c7-3de5-4a8d-b893-b8d432e7c647	116	\N	\N	\N	STARTET
5c2a71a2-8517-4d3a-baf1-ea8579fd5e51	t	f	2022-01-25 00:00:00	\N	K4	7eb4ca01-299a-444a-8123-0c8f553d0718	b7440787-50bd-4e41-b38b-48acf37af0de	d48095c7-3de5-4a8d-b893-b8d432e7c647	117	\N	\N	\N	STARTET
63b52066-bdc4-469b-b6ff-4518f9879787	t	f	2022-01-25 00:00:00	\N	K5	fc09e934-9292-407f-9d99-ce981c8b18ea	b7440787-50bd-4e41-b38b-48acf37af0de	d48095c7-3de5-4a8d-b893-b8d432e7c647	118	\N	\N	\N	STARTET
d9e27449-ffa3-41e4-9f72-444faf8bf83c	t	f	2022-01-26 00:00:00	\N	K3	64e32826-941e-4a21-b418-505b0e56fda2	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	119	\N	\N	\N	STARTET
863e0c09-96bc-491e-bdfe-f866543d6e79	t	f	2022-01-26 00:00:00	\N	K3	7c25b5c2-b0f8-4e54-8169-7b5c2c99796a	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	120	\N	\N	\N	STARTET
e47d9ccb-2316-425c-98fa-db4c645c5bb2	t	f	2022-01-26 00:00:00	\N	K3	3e48b69f-527a-4e13-bb7a-25dc5943ecc3	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	121	\N	\N	\N	STARTET
1c0169ce-2a01-4544-863c-398c537d24d4	t	f	2022-01-26 00:00:00	\N	K3	ddc5d1c7-f3d8-4321-a137-f344eab4ad9a	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	122	\N	\N	\N	STARTET
f7e8a14a-ce65-401c-a4dc-ab84a95582ef	t	f	2022-01-26 00:00:00	\N	K3	8bca5f87-48cf-4df8-851a-f17791ca27f3	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	123	\N	\N	\N	STARTET
809c2e3d-3b9d-46cc-bacc-ac94388ef9d0	t	f	2022-01-26 00:00:00	\N	K6	1c8eb3d9-4190-4f9d-bb86-9800a8557b88	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	124	\N	\N	\N	STARTET
cac6b42b-8058-44cf-97e0-f7cab11ffbc6	t	f	2022-01-26 00:00:00	\N	K6	3eba3044-7c1e-482a-8eeb-a7afa3b81910	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	125	\N	\N	\N	STARTET
a4ff8852-ea73-484d-8afc-9b1c45a08fcb	t	f	2022-01-26 00:00:00	\N	K5	f66e79e7-bc77-4efe-a823-9253e5cbc9c8	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	126	\N	\N	\N	STARTET
d71dea4c-6b8b-4b23-8f94-c8bcd555c91a	t	f	2022-01-26 00:00:00	\N	K5	97df0cc6-12d7-4f17-b20b-0f4cba6d9e77	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	127	\N	\N	\N	STARTET
4284d63c-8d5c-4e29-a5f0-2729fd6414d4	t	f	2022-01-26 00:00:00	\N	K6	6a361cdd-1a65-4bbe-b3ac-678e202493a6	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	128	\N	\N	\N	STARTET
5a0ffab3-747c-4694-8f4f-8ec571fdef63	t	f	2022-01-26 00:00:00	\N	K7	dee1d772-12cb-43fb-9ddf-f671fdc2b9b0	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	129	\N	\N	\N	STARTET
05394544-4fed-4c83-927e-8227185e1c91	t	f	2022-01-26 00:00:00	\N	KH	cc1458e2-677d-483e-a491-d4f268e9e405	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	130	\N	\N	\N	STARTET
3d7624f4-8d38-4711-a097-8d2b37a86dd7	t	f	2022-01-26 00:00:00	\N	K1	329b27f5-9daf-4ead-a213-4450a26db0a4	b7440787-50bd-4e41-b38b-48acf37af0de	ebbb0b94-a86b-4d3d-bba7-cf885b82ba94	131	\N	\N	\N	STARTET
2da4fe52-e309-4406-876d-041a5d3418ab	t	f	2022-01-26 00:00:00	\N	KEIN_START	cf890313-5432-4db1-a371-2ddbc6fd2b03	b7440787-50bd-4e41-b38b-48acf37af0de	5a2c7e90-a8e1-49a6-80c8-3a753967dff1	132	\N	\N	\N	STARTET
146f4824-fa6e-4f93-8a9e-2dc81594d0e1	t	f	2022-01-28 00:00:00	\N	K6	a6493824-cca4-4c7c-a202-3dd0a04b1f3e	b7440787-50bd-4e41-b38b-48acf37af0de	7ce1dc3c-2bc2-4601-9b0c-37bf0af0c959	176	\N	\N	\N	STARTET
cacae4f8-7f63-4d53-ac81-1ec66dc9f7d4	t	f	2022-01-29 00:00:00	\N	K5	90cb95a6-01df-4d57-82c3-6c852dc0989a	b7440787-50bd-4e41-b38b-48acf37af0de	a5302a2b-d270-49e5-9876-47c84cb38038	177	\N	\N	\N	STARTET
ac2f05fa-9933-451d-a4a2-4021a3097bdc	t	f	2022-01-29 00:00:00	\N	K5	12274a9f-83e7-4247-9c43-a01d7cd613fc	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	178	\N	\N	\N	STARTET
0069a830-6ea7-4d05-b13f-04e152fea195	t	f	2022-01-29 00:00:00	\N	K2	699c9855-119d-4bd7-9e00-61aff964bc39	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	179	\N	\N	\N	STARTET
a632f002-2c1e-40a5-914b-51fe93da76ba	t	f	2022-01-29 00:00:00	\N	K4	4a9ef47d-7a3a-4c9f-9761-a5c7422fef1c	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	180	\N	\N	\N	STARTET
2f6cb656-3841-4360-a78c-6e1f4a9d1ab6	t	f	2022-01-29 00:00:00	\N	K1	72afd313-31ba-4a08-b737-fa602d694892	b7440787-50bd-4e41-b38b-48acf37af0de	7647310f-d340-4dc7-b6d8-bda7a5716728	181	\N	\N	\N	STARTET
bbcfc4c7-d1f4-4736-ab07-8b0136f0fa89	t	f	2022-01-30 00:00:00	\N	K2	ed4e39f4-57d9-4005-9be0-dea0858e0281	b7440787-50bd-4e41-b38b-48acf37af0de	1030974d-cffe-46d6-b6ea-79c8839cf2ea	182	\N	\N	\N	STARTET
3e92f29e-5d02-40c3-bf31-1668d95d32a8	t	f	2022-01-30 00:00:00	\N	K1	3c9f3b45-0056-4218-8d92-9315134151fe	b7440787-50bd-4e41-b38b-48acf37af0de	4e9262a1-fef9-4701-9c91-1b3016ee971d	183	\N	\N	\N	STARTET
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
a269e0d3-5d9c-4255-b717-587ca45d1e1e	f	f	2022-01-17 00:00:00	\N	4aafd813-b46a-4496-a5c1-6104cf8511dd	0	f	\N
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
bd223d1e-cedf-4857-b987-db2cf873adc6	f	f	2022-01-18 00:00:00	\N	f7aa7d0a-58c8-4781-b8bd-0af1bf4615bd	0	f	\N
0d87abbb-f023-46aa-b54c-0cc9a29b6bab	f	f	2022-01-18 00:00:00	\N	70870a17-d0c2-45be-ab72-3a819b3c7673	0	f	\N
bddf55dd-9387-43b5-861d-b5e1e359865a	f	f	2022-01-18 00:00:00	\N	974578c2-33f3-494d-93e6-eea345ef6d22	0	f	\N
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
7b31dfc8-e2fa-4061-8be8-e5ccb99c7845	f	f	2022-01-20 00:00:00	\N	17ed84be-4dcd-4fab-baf8-40c3c422dcc0	0	f	\N
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
8f475ece-fa83-4d25-80d8-7acf49bc1695	f	f	2022-01-28 00:00:00	\N	17f95695-7deb-49cb-b14a-f73e44619c78	0	f	\N
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
e336d04b-8678-4029-9837-d4967045277f	t	f	2022-01-17 00:00:00	\N	72b0edf2-9636-4045-9cf2-2016e6582d7b	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
cbd3d8a2-79bc-4ede-83e3-5d0a84e2963b	t	f	2022-01-25 00:00:00	\N	139bda20-16a4-44ef-b6d9-242b83b346e9	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	f
22161a97-0dfd-4214-9ac6-0aa69dd03b79	t	f	2022-01-25 00:00:00	\N	091896fb-bb72-4931-a2cf-f1c0180ea1a6	d179758b-c473-41bd-9aa9-c037675cca6f	f
c08adb50-d9d0-46dc-b618-4c1a1c413645	t	f	2022-01-17 00:00:00	\N	d75592e7-1a88-4a5a-8cd4-3b634d35d9b5	d179758b-c473-41bd-9aa9-c037675cca6f	t
361e1104-a794-4ce5-a57b-496e9e2095ff	t	f	2022-01-25 00:00:00	\N	f83ba5fb-3b88-4f53-ba0d-72651fbb6bf2	d179758b-c473-41bd-9aa9-c037675cca6f	f
77e4bed3-37e9-429d-af3f-edcee61b4b56	t	f	2022-01-18 00:00:00	\N	6ac5fdf0-3503-4cbe-981e-cd39b38bf19c	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
4762439b-974f-4077-a1b6-ffdfd9d92867	t	f	2022-01-18 00:00:00	\N	6adc9680-cd78-45b3-b197-59f403ec1d8f	d179758b-c473-41bd-9aa9-c037675cca6f	t
0a2796b4-d7c3-4484-aa54-e03045ac91a4	t	f	2022-01-18 00:00:00	\N	21065ca4-fb26-45c8-9e4a-6dd3b3c9840e	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	f
f82e1962-f229-4640-b057-2f4c22cd378d	t	f	2022-01-19 00:00:00	\N	ca7098f4-74b7-468c-a84c-b54fdd5ae7a0	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
66af23a7-bf99-4eb4-9af4-23e1f54fce63	t	f	2022-01-19 00:00:00	\N	1cf6483c-4981-41fb-be23-79e8c6a905ee	d179758b-c473-41bd-9aa9-c037675cca6f	t
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
b206f77d-c285-4f2a-a87e-90641d83f2f6	t	f	2022-01-29 00:00:00	\N	7f2ca847-a39f-4ae8-b9b2-f20f5094d4f0	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
2b167383-6059-4b55-b6eb-577208fd4ddc	t	f	2022-01-29 00:00:00	\N	756d6695-f5d1-4d02-9380-bf0493c52177	d179758b-c473-41bd-9aa9-c037675cca6f	t
bd9097b8-b289-414e-96e3-8b0144771ab5	t	f	2022-01-29 00:00:00	\N	17f7ed34-d962-4748-a531-fbc92ed61244	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
2cccd6a8-0833-48a7-8673-3738dca35719	t	f	2022-01-29 00:00:00	\N	583d881a-f4cc-4db8-9555-81b04b9fde4e	d179758b-c473-41bd-9aa9-c037675cca6f	t
81dc109a-a521-4cac-a78a-4b752ce0d785	t	f	2022-01-29 00:00:00	\N	735b3b2e-2cf3-4090-befe-e41b0b983933	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	f
606d4e31-1a10-4891-bcc1-a511aac8c34c	t	f	2022-01-29 00:00:00	\N	cdd574c4-d259-431a-aa73-e64178cfed2e	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
92ebdebc-ad9e-42a3-b685-8dad6af1156a	t	f	2022-01-30 00:00:00	\N	91837aad-3d46-4a4e-9e60-2fa73c57cc24	f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t
096ce61e-3c92-4372-8ffe-5959fe28f811	t	f	2022-01-30 00:00:00	\N	0e5afa35-fc54-49c6-b28a-4f8b7aeac138	d179758b-c473-41bd-9aa9-c037675cca6f	f
\.


--
-- Data for Name: wertungsrichter_slot; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wertungsrichter_slot (id, aktiv, deleted, change_date, deletion_date, anlass_id, reihenfolge, brevet, tag, start_zeit, end_zeit, beschreibung) FROM stdin;
f0eb1b13-42b8-4354-b67c-5dccd4dcd4c5	t	f	2022-01-09 00:00:00	\N	b7440787-50bd-4e41-b38b-48acf37af0de	0	0	\N	\N	\N	SO Morgen
d179758b-c473-41bd-9aa9-c037675cca6f	t	f	2022-01-09 00:00:00	\N	b7440787-50bd-4e41-b38b-48acf37af0de	1	1	\N	\N	\N	SO Mittag
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
-- Name: uidx_organisation_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uidx_organisation_name ON public.organisation USING btree (name);


--
-- PostgreSQL database dump complete
--

