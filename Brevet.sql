-- select * from Anlass; -- 0fa002f3-d432-46d4-a753-991d021db3fa
-- select * from wertungsrichter_slot ws where ws.anlass_id='0fa002f3-d432-46d4-a753-991d021db3fa'; -- f6d18808-a19f-495a-8f33-adb4a75870da sollte 88c3c579-cfa1-4057-96c4-855fac75c9bf
/*
-- select * from wertungsrichter_einsatz we where we.wertungsrichter_slot_id='f6d18808-a19f-495a-8f33-adb4a75870da';
/*
se*/lect * from person_anlass_link pal where pal.id IN (
select we.person_anlass_link_id from wertungsrichter_einsatz we where we.wertungsrichter_slot_id='f6d18808-a19f-495a-8f33-adb4a75870da');
*/
/*
select we.*, ws.* from wertungsrichter_einsatz we inner join wertungsrichter_slot ws on ws.id = we.wertungsrichter_slot_id
where we.wertungsrichter_slot_id='f6d18808-a19f-495a-8f33-adb4a75870da';
*/
/*
select * from wertungsrichter_einsatz we where we.person_anlass_link_id IN (
select DISTINCT we.person_anlass_link_id from wertungsrichter_einsatz we inner join wertungsrichter_slot ws on ws.id = we.wertungsrichter_slot_id where we.person_anlass_link_id IN (
select we.person_anlass_link_id from wertungsrichter_einsatz we 
	where we.wertungsrichter_slot_id='f6d18808-a19f-495a-8f33-adb4a75870da') and ws.brevet='0' and ws.reihenfolge>'2') AND we.wertungsrichter_slot_id='f6d18808-a19f-495a-8f33-adb4a75870da';
*/
/*
update wertungsrichter_einsatz set wertungsrichter_slot_id='88c3c579-cfa1-4057-96c4-855fac75c9bf' where person_anlass_link_id IN (
select DISTINCT we.person_anlass_link_id from wertungsrichter_einsatz we inner join wertungsrichter_slot ws on ws.id = we.wertungsrichter_slot_id where we.person_anlass_link_id IN (
select we.person_anlass_link_id from wertungsrichter_einsatz we 
	where we.wertungsrichter_slot_id='f6d18808-a19f-495a-8f33-adb4a75870da') and ws.brevet='0' and ws.reihenfolge>'2') AND wertungsrichter_slot_id='f6d18808-a19f-495a-8f33-adb4a75870da';
*/
update wertungsrichter_slot set brevet='1' where id='f6d18808-a19f-495a-8f33-adb4a75870da';
