package org.ztv.anmeldetool.anmeldetool.transfer;

import java.util.List;
import java.util.Set;
import java.util.UUID;

import lombok.Builder;
import lombok.Value;

/*
 *  id: '-1',
    verein_id: '-1',
    lastName: '',
    firstName: '',
    password: '',
    userName: '',
    eMail: '',
    mobileNummer: '',
    enabled: true

 */
/**
 * 
 * @author heinz
 *
 */
@Value
@Builder
public class PersonDTO {

	private UUID id;

	private List<UUID> organisationids;

	private String benutzername;

	private String name;

	private String vorname;

	private String handy;

	private String email;

	private String password;

	private boolean aktiv;

	private Set<RolleDTO> rollen;
}
