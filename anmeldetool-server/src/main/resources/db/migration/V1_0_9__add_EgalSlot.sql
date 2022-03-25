ALTER TABLE WERTUNGSRICHTER_SLOT ADD EGAL_SLOT BOOLEAN default false;
update wertungsrichter_slot ws set egal_slot='false';
