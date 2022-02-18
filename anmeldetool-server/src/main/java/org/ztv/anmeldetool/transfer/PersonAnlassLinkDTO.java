package org.ztv.anmeldetool.transfer;

import java.util.List;
import java.util.UUID;

import lombok.Builder;
import lombok.Value;

@Value
// @AllArgsConstructor
@Builder
public class PersonAnlassLinkDTO {

	UUID anlassId;

	UUID personId;

	UUID organisationId;

	boolean dirty;

	private String kommentar;

	private List<WertungsrichterEinsatzDTO> einsaetze;
}
