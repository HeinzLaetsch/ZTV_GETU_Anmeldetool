package org.ztv.anmeldetool.util;

import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.ztv.anmeldetool.transfer.BenutzerDTO;

import com.opencsv.CSVWriter;
import com.opencsv.bean.HeaderColumnNameMappingStrategy;
import com.opencsv.bean.HeaderColumnNameMappingStrategyBuilder;
import com.opencsv.bean.StatefulBeanToCsv;
import com.opencsv.bean.StatefulBeanToCsvBuilder;
import com.opencsv.bean.comparator.LiteralComparator;
import com.opencsv.exceptions.CsvDataTypeMismatchException;
import com.opencsv.exceptions.CsvRequiredFieldEmptyException;

public class BenutzerExport {

	public static void csvWriteToWriter(List<BenutzerDTO> benutzerList, HttpServletResponse response)
			throws CsvDataTypeMismatchException, CsvRequiredFieldEmptyException, IOException {

		final byte[] bom = new byte[] { (byte) 239, (byte) 187, (byte) 191 };
		OutputStream os = response.getOutputStream();
		os.write(bom);
		os.write(bom);

		final PrintWriter responseWriter = new PrintWriter(new OutputStreamWriter(os, "UTF-8"));

		HeaderColumnNameMappingStrategy<BenutzerDTO> strategy = new HeaderColumnNameMappingStrategyBuilder<BenutzerDTO>()
				.build();
		strategy.setType(BenutzerDTO.class);
		strategy.setColumnOrderOnWrite(new LiteralComparator(BenutzerDTO.FIELDS_ORDER));

		StatefulBeanToCsv<BenutzerDTO> writer = new StatefulBeanToCsvBuilder<BenutzerDTO>(responseWriter)
				.withQuotechar(CSVWriter.NO_QUOTE_CHARACTER).withSeparator(';').withOrderedResults(false)
				.withMappingStrategy(strategy).build();
		writer.write(benutzerList);
		responseWriter.flush();
		responseWriter.close();
	}
}
