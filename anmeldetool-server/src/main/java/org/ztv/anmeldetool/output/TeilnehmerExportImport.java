package org.ztv.anmeldetool.output;

import com.opencsv.CSVWriter;
import com.opencsv.bean.CsvToBeanBuilder;
import com.opencsv.bean.StatefulBeanToCsv;
import com.opencsv.bean.StatefulBeanToCsvBuilder;
import jakarta.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.Reader;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.util.StreamUtils;
import org.springframework.web.multipart.MultipartFile;
import org.ztv.anmeldetool.transfer.TeilnehmerAnlassLinkCsvDTO;
import org.ztv.anmeldetool.transfer.TeilnehmerCsvContestDTO;

public class TeilnehmerExportImport {

  public static void csvWriteToWriter(List<TeilnehmerAnlassLinkCsvDTO> tals,
      HttpServletResponse response) {
    try {
      final byte[] bom = new byte[]{(byte) 239, (byte) 187, (byte) 191};
      OutputStream os = response.getOutputStream();
      os.write(bom);
      os.write(bom);

      final PrintWriter responseWriter = new PrintWriter(new OutputStreamWriter(os, "UTF-8"));

      StatefulBeanToCsv<TeilnehmerAnlassLinkCsvDTO> writer = new StatefulBeanToCsvBuilder<TeilnehmerAnlassLinkCsvDTO>(
          responseWriter).withQuotechar(CSVWriter.NO_QUOTE_CHARACTER).withSeparator(';')
          .withOrderedResults(false)
          .build();
      writer.write(tals);
      responseWriter.flush();
      responseWriter.close();
    } catch (Exception e) {
      //ToDO replace with proper exception handling ServiceException
      throw new RuntimeException(e);
    }
  }

  public static List<TeilnehmerAnlassLinkCsvDTO> csvToDto(InputStream inputStream)
      throws IOException {
    byte[] cachedBody = StreamUtils.copyToByteArray(inputStream);
    int start = 0;
    if (cachedBody[0] == 239 && cachedBody[1] == 187 && cachedBody[2] == 191
        || cachedBody[0] == -17 && cachedBody[1] == -69 && cachedBody[2] == -65) {
      // int char1 = inputStream.read();
      // int char2 = inputStream.read();
      // int char3 = inputStream.read();
      start = 3;
    }
    InputStream byteArrayInputStream = new ByteArrayInputStream(cachedBody, start,
        cachedBody.length);
    Reader targetReader = new InputStreamReader(byteArrayInputStream, "UTF-8");
    List<TeilnehmerAnlassLinkCsvDTO> tals = new CsvToBeanBuilder<TeilnehmerAnlassLinkCsvDTO>(
        targetReader)
        .withType(TeilnehmerAnlassLinkCsvDTO.class).withQuoteChar(CSVWriter.NO_QUOTE_CHARACTER)
        .withSeparator(';').withOrderedResults(false).build().parse();
    targetReader.close();
    byteArrayInputStream.reset();
    String asString = new String(byteArrayInputStream.readAllBytes());
    return tals;
  }

  public static List<TeilnehmerCsvContestDTO> csvContestToDto(MultipartFile inputStream) {
    try {
    byte[] cachedBody = StreamUtils.copyToByteArray(inputStream.getInputStream());
    int start = 0;
    if (cachedBody[0] == 239 && cachedBody[1] == 187 && cachedBody[2] == 191
        || cachedBody[0] == -17 && cachedBody[1] == -69 && cachedBody[2] == -65) {
      start = 3;
    }
    InputStream byteArrayInputStream = new ByteArrayInputStream(cachedBody, start,
        cachedBody.length);
    Reader targetReader = new InputStreamReader(byteArrayInputStream, "UTF-8");
    List<TeilnehmerCsvContestDTO> teilnehmer = new CsvToBeanBuilder<TeilnehmerCsvContestDTO>(
        targetReader)
        .withType(TeilnehmerCsvContestDTO.class).withQuoteChar(CSVWriter.NO_QUOTE_CHARACTER)
        .withSeparator(';')
        .withOrderedResults(false).build().parse();
    targetReader.close();
    return teilnehmer.stream().filter(t -> "Geräteturnen".equals(t.getSparte()))
        .collect(Collectors.toList());
    //ToDO replace with proper exception handling ServiceException
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }
}
