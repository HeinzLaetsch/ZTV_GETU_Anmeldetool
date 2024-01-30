package org.ztv.anmeldetool.transfer;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Value;

@Value
@AllArgsConstructor
public class TeilnahmenDTO {
	private TeilnehmerDTO teilnehmer;

	private List<TeilnehmerAnlassLinkDTO> talDTOList;

}
