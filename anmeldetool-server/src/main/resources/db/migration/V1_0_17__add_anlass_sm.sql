ALTER TABLE ANLASS ADD SM_QUALI BOOLEAN default true;
update ANLASS set SM_QUALI='true';

ALTER TABLE ANLASS ADD AUSSERKANTONAL BOOLEAN default false;
<<<<<<< HEAD
update ANLASS set AUSSERKANTONAL='false';


=======
update ANLASS set AUSSERKANTONAL='false';
>>>>>>> grid
