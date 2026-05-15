package org.ztv.anmeldetool.transfer;

import java.util.List;
import java.util.Set;
import java.util.UUID;

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
//@Value
//@Builder
public record PersonDTO(UUID id, List<UUID> organisationids, List<OrganisationPersonLinkDTO> organisationenLinks, String benutzername, String name, String vorname, String handy, String email, String password, boolean aktiv, Set<RolleDTO> rollen) {}
