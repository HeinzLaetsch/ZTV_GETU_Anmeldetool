package org.ztv.anmeldetool.output;

import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.ztv.anmeldetool.transfer.SmQualiDTO;

import com.opencsv.CSVWriter;
import com.opencsv.bean.HeaderColumnNameMappingStrategy;
import com.opencsv.bean.HeaderColumnNameMappingStrategyBuilder;
import com.opencsv.bean.StatefulBeanToCsv;
import com.opencsv.bean.StatefulBeanToCsvBuilder;
import com.opencsv.bean.comparator.LiteralComparator;
import com.opencsv.exceptions.CsvDataTypeMismatchException;
import com.opencsv.exceptions.CsvRequiredFieldEmptyException;

// https://github.com/itext/i7js-examples/tree/develop/src/main/java/com/itextpdf/samples/sandbox/events
public class SmQualiOutput {
	public static void csvWriteToWriter(HttpServletResponse response, List<SmQualiDTO> smqDtoList)
			throws CsvDataTypeMismatchException, CsvRequiredFieldEmptyException, IOException {

		final byte[] bom = new byte[] { (byte) 239, (byte) 187, (byte) 191 };
		OutputStream os = response.getOutputStream();
		os.write(bom);
		os.write(bom);

		final PrintWriter responseWriter = new PrintWriter(new OutputStreamWriter(os, "UTF-8"));

		HeaderColumnNameMappingStrategy<SmQualiDTO> strategy = new HeaderColumnNameMappingStrategyBuilder<SmQualiDTO>()
				.build();
		strategy.setType(SmQualiDTO.class);
		strategy.setColumnOrderOnWrite(new LiteralComparator(SmQualiDTO.FIELDS_ORDER));

		StatefulBeanToCsv<SmQualiDTO> writer = new StatefulBeanToCsvBuilder<SmQualiDTO>(responseWriter)
				.withQuotechar(CSVWriter.NO_QUOTE_CHARACTER).withSeparator(';').withMappingStrategy(strategy)
				.withOrderedResults(true).build();
		writer.write(smqDtoList);
		responseWriter.flush();
		responseWriter.close();
	}
}
