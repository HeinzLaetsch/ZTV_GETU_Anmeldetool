INSERT INTO public.anlass(
	id, aktiv, deleted, change_date, deletion_date, anlass_bezeichnung, ort, halle, 
            start_date, end_date, ti_tu, tiefste_kategorie, hoechste_kategorie, 
            anmeldung_beginn, erfassen_geschlossen, cross_kategorie_aenderungen_geschlossen, aenderungen_in_kategorie_geschlossen, aenderungen_nicht_mehr_erlaubt, 
            published, iban, zu_gunsten, bank, 
            abteilung_fix, anlage_fix, startgeraet_fix, organisator_id, tool_sperren, reminder_meldeschluss_sent, ranglisten_footer)
	VALUES ('332deae3-99cb-4668-960c-140a4a0b5de4', 'true', 'false', To_TimeStamp('24-5-2022', 'dd-MM-yyyy'), NULL, 'Gerätemeisterschaften K5+', 'Regensdorf', 'Wisacher',  
            To_TimeStamp('11-9-2022', 'dd-MM-yyyy'),  To_TimeStamp('11-9-2022', 'dd-MM-yyyy'), 'Alle', 'K5', 'K7', 
            To_TimeStamp('23-5-2022', 'dd-MM-yyyy'), To_TimeStamp('3-6-2022', 'dd-MM-yyyy'), To_TimeStamp('3-6-2022', 'dd-MM-yyyy'), To_TimeStamp('8-9-2022', 'dd-MM-yyyy'), To_TimeStamp('8-9-2022', 'dd-MM-yyyy'), 
            'true', 'CH08 0070 0114 8027 6689 9', 'Turnverein Regensdorf', 'Zürcher Kantonalbank', 
            'false', 'false', 'false', '2fc3365b-34d9-4054-b2d8-aa859c7455e7', 'false', 'false', 'Turnverein Regensdorf');

INSERT INTO public.wertungsrichter_slot(
	id, aktiv, deleted, change_date, deletion_date, anlass_id, 
            reihenfolge, brevet, tag, start_zeit, end_zeit, beschreibung, egal_slot)
	VALUES ('ad6c8488-f71d-429b-9756-a4fe8af1be6d', 'true', 'false', To_TimeStamp('24-5-2022', 'dd-MM-yyyy'), NULL, '332deae3-99cb-4668-960c-140a4a0b5de4', 
            1, '1', NULL, NULL, NULL, 'SO Morgen', 'false');
            
INSERT INTO public.wertungsrichter_slot(
	id, aktiv, deleted, change_date, deletion_date, anlass_id, 
            reihenfolge, brevet, tag, start_zeit, end_zeit, beschreibung, egal_slot)
	VALUES ('3809394a-2011-4e01-b179-7f053250d90b', 'true', 'false', To_TimeStamp('24-5-2022', 'dd-MM-yyyy'), NULL, '332deae3-99cb-4668-960c-140a4a0b5de4', 
            2, '1', NULL, NULL, NULL, 'SO Mittag', 'false');    