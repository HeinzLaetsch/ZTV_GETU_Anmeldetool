package org.ztv.anmeldetool.util;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.Reader;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.springframework.util.StreamUtils;
import org.ztv.anmeldetool.transfer.AnmeldeKontrolleDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkCsvDTO;
import org.ztv.anmeldetool.transfer.VereinsStartDTO;

import com.opencsv.CSVWriter;
import com.opencsv.bean.CsvToBeanBuilder;
import com.opencsv.bean.HeaderColumnNameMappingStrategy;
import com.opencsv.bean.HeaderColumnNameMappingStrategyBuilder;
import com.opencsv.bean.StatefulBeanToCsv;
import com.opencsv.bean.StatefulBeanToCsvBuilder;
import com.opencsv.bean.comparator.LiteralComparator;
import com.opencsv.exceptions.CsvDataTypeMismatchException;
import com.opencsv.exceptions.CsvRequiredFieldEmptyException;

public class AnmeldeKontrolleExport {

	public static void csvWriteToWriter(AnmeldeKontrolleDTO anmeldekontrolle, HttpServletResponse response)
			throws CsvDataTypeMismatchException, CsvRequiredFieldEmptyException, IOException {

		final byte[] bom = new byte[] { (byte) 239, (byte) 187, (byte) 191 };
		OutputStream os = response.getOutputStream();
		os.write(bom);
		os.write(bom);

		final PrintWriter responseWriter = new PrintWriter(new OutputStreamWriter(os, "UTF-8"));

		HeaderColumnNameMappingStrategy<VereinsStartDTO> strategy = new HeaderColumnNameMappingStrategyBuilder<VereinsStartDTO>()
				.build();
		strategy.setType(VereinsStartDTO.class);
		strategy.setColumnOrderOnWrite(new LiteralComparator(VereinsStartDTO.FIELDS_ORDER));

		StatefulBeanToCsv<VereinsStartDTO> writer = new StatefulBeanToCsvBuilder<VereinsStartDTO>(responseWriter)
				.withQuotechar(CSVWriter.NO_QUOTE_CHARACTER).withSeparator(';')
				.withEscapechar(CSVWriter.NO_ESCAPE_CHARACTER).withOrderedResults(true).withMappingStrategy(strategy)
				.build();
		writer.write(anmeldekontrolle.getVereinsStart());
		responseWriter.flush();
		responseWriter.close();
	}

	public static List<TeilnehmerAnlassLinkCsvDTO> csvWriteToWriter(InputStream inputStream) throws IOException {
		byte[] cachedBody = StreamUtils.copyToByteArray(inputStream);
		int start = 0;
		if (cachedBody[0] == 239 && cachedBody[1] == 187 && cachedBody[2] == 191) {
			start = 3;
		}
		InputStream byteArrayInputStream = new ByteArrayInputStream(cachedBody, start, cachedBody.length);
		Reader targetReader = new InputStreamReader(byteArrayInputStream, "UTF-8");
		List<TeilnehmerAnlassLinkCsvDTO> tals = new CsvToBeanBuilder<TeilnehmerAnlassLinkCsvDTO>(targetReader)
				.withType(TeilnehmerAnlassLinkCsvDTO.class).withQuoteChar(CSVWriter.NO_QUOTE_CHARACTER)
				.withSeparator(';').withOrderedResults(false).build().parse();
		targetReader.close();
		return tals;
	}
}
