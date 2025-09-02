package org.ztv.anmeldetool.repositories;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.NativeQuery;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.models.Person;

@Repository
public interface PersonenRepository extends CrudRepository<Person, UUID> {

	Person findByBenutzernameIgnoreCase(String benutzername);

	@NativeQuery("SELECT p.* from PERSON p, organisation_person_link opl, ORGANISATION org where opl.PERSON_ID=p.id AND opl.ORGANISATION_ID=org.id AND org.id=?1")
	List<Person> findByOrganisationId(UUID orgId);
}
