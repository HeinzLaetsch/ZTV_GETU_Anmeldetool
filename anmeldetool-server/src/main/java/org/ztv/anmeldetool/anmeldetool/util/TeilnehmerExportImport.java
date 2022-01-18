package org.ztv.anmeldetool.anmeldetool.util;

import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.ztv.anmeldetool.anmeldetool.transfer.TeilnehmerAnlassLinkCsvDTO;

import com.opencsv.CSVWriter;
import com.opencsv.bean.StatefulBeanToCsv;
import com.opencsv.bean.StatefulBeanToCsvBuilder;
import com.opencsv.exceptions.CsvDataTypeMismatchException;
import com.opencsv.exceptions.CsvRequiredFieldEmptyException;

public class TeilnehmerExportImport {

	public static void csvWriteToWriter(List<TeilnehmerAnlassLinkCsvDTO> tals, HttpServletResponse response)
			throws CsvDataTypeMismatchException, CsvRequiredFieldEmptyException, IOException {

		final byte[] bom = new byte[] { (byte) 239, (byte) 187, (byte) 191 };
		OutputStream os = response.getOutputStream();
		os.write(bom);
		os.write(bom);

		final PrintWriter responseWriter = new PrintWriter(new OutputStreamWriter(os, "UTF-8"));

		StatefulBeanToCsv<TeilnehmerAnlassLinkCsvDTO> writer = new StatefulBeanToCsvBuilder<TeilnehmerAnlassLinkCsvDTO>(
				responseWriter).withQuotechar(CSVWriter.NO_QUOTE_CHARACTER).withSeparator(';').withOrderedResults(false)
						.build();
		writer.write(tals);
		responseWriter.flush();
		responseWriter.close();
	}
}