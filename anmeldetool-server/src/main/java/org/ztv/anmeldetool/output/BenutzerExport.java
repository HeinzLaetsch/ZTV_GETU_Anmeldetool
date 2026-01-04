package org.ztv.anmeldetool.output;

import com.opencsv.CSVWriter;
import com.opencsv.bean.HeaderColumnNameMappingStrategy;
import com.opencsv.bean.HeaderColumnNameMappingStrategyBuilder;
import com.opencsv.bean.StatefulBeanToCsv;
import com.opencsv.bean.StatefulBeanToCsvBuilder;
import com.opencsv.bean.comparator.LiteralComparator;
import jakarta.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.List;
import org.ztv.anmeldetool.transfer.BenutzerDTO;

public class BenutzerExport {

  //ToDo replace with generic implementation
  public static void csvWriteToWriter(List<BenutzerDTO> benutzerList,
      HttpServletResponse response) {

    final byte[] bom = new byte[]{(byte) 239, (byte) 187, (byte) 191};
    try {
      OutputStream os = response.getOutputStream();
      os.write(bom);
      os.write(bom);

      final PrintWriter responseWriter = new PrintWriter(new OutputStreamWriter(os, "UTF-8"));

      HeaderColumnNameMappingStrategy<BenutzerDTO> strategy = new HeaderColumnNameMappingStrategyBuilder<BenutzerDTO>()
          .build();
      strategy.setType(BenutzerDTO.class);
      strategy.setColumnOrderOnWrite(new LiteralComparator(BenutzerDTO.FIELDS_ORDER));

      StatefulBeanToCsv<BenutzerDTO> writer = new StatefulBeanToCsvBuilder<BenutzerDTO>(
          responseWriter)
          .withQuotechar(CSVWriter.NO_QUOTE_CHARACTER).withSeparator(';').withOrderedResults(true)
          .withEscapechar(CSVWriter.NO_ESCAPE_CHARACTER).withMappingStrategy(strategy).build();
      writer.write(benutzerList);
      responseWriter.flush();
      responseWriter.close();
    } catch (Exception e) {
      //ToDO replace with proper exception handling ServiceException
      throw new RuntimeException(e);
    }
  }
}
