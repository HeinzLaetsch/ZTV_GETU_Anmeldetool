package org.ztv.anmeldetool.anmeldetool.repositories;

import java.util.Collection;
import java.util.UUID;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.ztv.anmeldetool.anmeldetool.models.Person;

@Repository
public interface PersonenRepository extends CrudRepository<Person, UUID> {

	Person findByBenutzername(String benutzername);
	
	@Query(value = "SELECT p.* from PERSON p, organisation_person_link opl, ORGANISATION org where opl.PERSON_ID=p.id AND opl.ORGANISATION_ID=org.id AND org.id=?1", nativeQuery = true )
	Collection<Person> findByBenutzernameOrganisationId(String orgId);
}
