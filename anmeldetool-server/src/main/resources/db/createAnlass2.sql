INSERT INTO public.anlass(
	id, aktiv, deleted, change_date, deletion_date, anlass_bezeichnung, ort, halle, 
            start_date, end_date, ti_tu, tiefste_kategorie, hoechste_kategorie, 
            anmeldung_beginn, erfassen_geschlossen, cross_kategorie_aenderungen_geschlossen, aenderungen_in_kategorie_geschlossen, aenderungen_nicht_mehr_erlaubt, 
            published, iban, zu_gunsten, bank, 
            abteilung_fix, anlage_fix, startgeraet_fix, organisator_id, tool_sperren, reminder_meldeschluss_sent)
	VALUES ('c0a70b2a-1aa6-418f-8603-f95286101064', 'true', 'false', To_TimeStamp('24-5-2022', 'dd-MM-yyyy'), NULL, 'Gerätemeister%schaften K1-K4', 'Gossau', 'Oberstufe',  
            To_TimeStamp('27-8-2022', 'dd-MM-yyyy'),  To_TimeStamp('28-8-2022', 'dd-MM-yyyy'), 'Alle', 'K1', 'K4', 
            To_TimeStamp('23-5-2022', 'dd-MM-yyyy'), To_TimeStamp('3-6-2022', 'dd-MM-yyyy'), To_TimeStamp('3-6-2022', 'dd-MM-yyyy'), To_TimeStamp('25-8-2022', 'dd-MM-yyyy'), To_TimeStamp('8-9-2022', 'dd-MM-yyyy'), 
            'false', '', '', '', 
            'false', 'false', 'false', '2fc3365b-34d9-4054-b2d8-aa859c7455e7', 'false', 'false');

INSERT INTO public.wertungsrichter_slot(
	id, aktiv, deleted, change_date, deletion_date, anlass_id, 
            reihenfolge, brevet, tag, start_zeit, end_zeit, beschreibung, egal_slot)
	VALUES ('5a1b5cfa-4d2d-4d63-9eb1-1b5468c28d12', 'true', 'false', To_TimeStamp('24-5-2022', 'dd-MM-yyyy'), NULL, 'c0a70b2a-1aa6-418f-8603-f95286101064', 
            1, '1', NULL, NULL, NULL, 'SA Morgen', 'false');
            
INSERT INTO public.wertungsrichter_slot(
	id, aktiv, deleted, change_date, deletion_date, anlass_id, 
            reihenfolge, brevet, tag, start_zeit, end_zeit, beschreibung, egal_slot)
	VALUES ('577ba407-bb96-472f-8b82-6639d986dcc5', 'true', 'false', To_TimeStamp('24-5-2022', 'dd-MM-yyyy'), NULL, 'c0a70b2a-1aa6-418f-8603-f95286101064', 
            2, '1', NULL, NULL, NULL, 'SA Mittag', 'false');    
            
INSERT INTO public.wertungsrichter_slot(
	id, aktiv, deleted, change_date, deletion_date, anlass_id, 
            reihenfolge, brevet, tag, start_zeit, end_zeit, beschreibung, egal_slot)
	VALUES ('5ddd84fe-b6e1-4c1a-86eb-06ac1ba30cef', 'true', 'false', To_TimeStamp('24-5-2022', 'dd-MM-yyyy'), NULL, 'c0a70b2a-1aa6-418f-8603-f95286101064', 
            3, '1', NULL, NULL, NULL, 'SO Morgen', 'false');
            
INSERT INTO public.wertungsrichter_slot(
	id, aktiv, deleted, change_date, deletion_date, anlass_id, 
            reihenfolge, brevet, tag, start_zeit, end_zeit, beschreibung, egal_slot)
	VALUES ('81d2613c-8752-46b7-bf86-83fdc938dfdf', 'true', 'false', To_TimeStamp('24-5-2022', 'dd-MM-yyyy'), NULL, 'c0a70b2a-1aa6-418f-8603-f95286101064', 
            4, '1', NULL, NULL, NULL, 'SO Mittag', 'false');    