package org.ztv.anmeldetool.util;

import java.time.format.DateTimeFormatter;
import java.time.format.FormatStyle;

import org.ztv.anmeldetool.transfer.WertungsrichterEinsatzCsvDTO;

import com.opencsv.bean.AbstractCsvConverter;

public class WertungsrichterToCsv extends AbstractCsvConverter {

	@Override
	public Object convertToRead(String value) {
		return "";
	}

	@Override
	public String convertToWrite(Object value) {
		WertungsrichterEinsatzCsvDTO t = (WertungsrichterEinsatzCsvDTO) value;
		if (t.getTag() != null) {
			return String.format("%s,%s,%s,%s", t.getBrevet(),
					t.getTag().format(DateTimeFormatter.ofLocalizedDate(FormatStyle.SHORT)),
					t.getStart_zeit().format(DateTimeFormatter.ofLocalizedDate(FormatStyle.SHORT)),
					t.getEnd_zeit().format(DateTimeFormatter.ofLocalizedDate(FormatStyle.SHORT)));
		} else {
			return String.format("%s,%s", t.getBrevet().brevet, t.getBeschreibung());
		}
	}
}
