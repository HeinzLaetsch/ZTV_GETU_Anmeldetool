package org.ztv.anmeldetool.transfer;

import java.util.List;
import java.util.UUID;

import lombok.Builder;
import lombok.Value;

//@Value
// @AllArgsConstructor
//@Builder
public record PersonAnlassLinkDTO(UUID anlassId, UUID personId, UUID organisationId, boolean dirty, String kommentar, List<WertungsrichterEinsatzDTO> einsaetze) {}
