package org.ztv.anmeldetool.transfer;

import java.util.UUID;

public record OrganisationPersonLinkDTO(UUID id, boolean aktiv, UUID organisationId, UUID personId) { }
