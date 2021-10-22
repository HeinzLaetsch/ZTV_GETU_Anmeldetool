package org.ztv.anmeldetool.anmeldetool.transfer;

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
}
