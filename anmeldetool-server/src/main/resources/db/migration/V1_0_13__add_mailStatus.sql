ALTER TABLE anlass ADD REMINDER_MELDESCHLUSS_SENT BOOLEAN default false;
update anlass set REMINDER_MELDESCHLUSS_SENT='true';

ALTER TABLE organisation_anlass_link ADD REMINDER_MELDESCHLUSS_SENT BOOLEAN default false;
update organisation_anlass_link set REMINDER_MELDESCHLUSS_SENT='true';

ALTER TABLE organisation_anlass_link ADD ANMELDE_KONTROLLE_SENT BOOLEAN default false;
update organisation_anlass_link set ANMELDE_KONTROLLE_SENT='true';

ALTER TABLE organisation_anlass_link ADD REMINDER_MUTATIONSSCHLUSS_SENT BOOLEAN default false;
update organisation_anlass_link set REMINDER_MUTATIONSSCHLUSS_SENT='true';