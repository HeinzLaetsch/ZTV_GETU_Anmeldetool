package org.ztv.anmeldetool.models;

import org.ztv.anmeldetool.transfer.PersonDTO;

public record LoginResult(PersonDTO user, String token) {}
