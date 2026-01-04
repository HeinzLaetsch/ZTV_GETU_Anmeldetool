package org.ztv.anmeldetool.output;

import com.itextpdf.io.font.constants.StandardFonts;
import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.events.Event;
import com.itextpdf.kernel.events.IEventHandler;
import com.itextpdf.kernel.events.PdfDocumentEvent;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.geom.Rectangle;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Canvas;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.borders.SolidBorder;
import com.itextpdf.layout.element.AreaBreak;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.element.Text;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.opencsv.CSVWriter;
import com.opencsv.bean.HeaderColumnNameMappingStrategy;
import com.opencsv.bean.HeaderColumnNameMappingStrategyBuilder;
import com.opencsv.bean.StatefulBeanToCsv;
import com.opencsv.bean.StatefulBeanToCsvBuilder;
import com.opencsv.bean.comparator.LiteralComparator;
import com.opencsv.exceptions.CsvDataTypeMismatchException;
import com.opencsv.exceptions.CsvRequiredFieldEmptyException;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.util.List;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.transfer.RanglistenEntryDTO;
import org.ztv.anmeldetool.transfer.TeamwertungDTO;

// https://github.com/itext/i7js-examples/tree/develop/src/main/java/com/itextpdf/samples/sandbox/events
public class RanglistenOutput {

  private RanglistenOutput() {
    // private constructor for utility class
  }

  public static List<String> getTeamwertungReportName(KategorieEnum kategorie, TiTuEnum tiTu) {
    String titel = kategorie.name();
    String subTitle = "";
    if (tiTu.equals(TiTuEnum.Tu)) {
      if (kategorie.isJugend()) {
        titel = "Jugendkategorien";
        subTitle = "K1-K4";
      } else {
        titel = "Aktivkategorien";
        subTitle = "K5-K7/H";
      }
    }
    return List.of(titel, subTitle);
  }
  public static void createTeamwertung(OutputStream responseStream, List<TeamwertungDTO> twDTOs,
      KategorieEnum kategorie, TiTuEnum tiTu) throws IOException {

    List<String> reportname = getTeamwertungReportName(kategorie, tiTu);
    PdfDocument pdf = new PdfDocument(new PdfWriter(responseStream));
    // Document doc = new Document(pdf, PageSize.A4);
    Document doc = new Document(pdf);
    PdfFont fontN = PdfFontFactory.createFont(StandardFonts.HELVETICA);
    PdfFont fontB = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);

    // Calculate top margin to be sure that the table will fit the margin.
    doc.setMargins(36, 36, 36, 36);
    Text text = new Text("Teamwertung Kategorie " + reportname.get(0) + " " + reportname.get(1)).setFont(fontB)
        .setFontSize(16);
    doc.add(new Paragraph(text));
    float[] cols = {15.0f, 30.0f, 55.0f};
    boolean even = false;
    int anzahl = kategorie.isJugend() ? 4 : 0;
    Table table = new Table(UnitValue.createPercentArray(cols)).useAllAvailableWidth();
    for (TeamwertungDTO tw : twDTOs) {
      if (tw.getAnzahlResultate() >= anzahl) {
        printCell(table, "%d".formatted(tw.getRang()), false, even);
        printCell(table, tw.getVerein(), true, even);
        printCell(table, "%.3f".formatted(tw.getGesamtPunktzahl()), false, even);
        even = !even;
      }
    }
    doc.add(table);
    doc.close();
  }

  public static void createRanglistePerVerein(OutputStream responseStream,
      List<RanglistenEntryDTO> ranglistenDTOs,
      KategorieEnum kategorie) throws IOException {
    PdfDocument pdf = new PdfDocument(new PdfWriter(responseStream));
    Document doc = new Document(pdf);
    PdfFont fontN = PdfFontFactory.createFont(StandardFonts.HELVETICA);
    PdfFont fontB = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);

    // Calculate top margin to be sure that the table will fit the margin.
    doc.setMargins(36, 36, 36, 36);
    int pos = 0;
    while (pos != -1) {
      pos = printVereinRangliste(doc, fontB, fontN, ranglistenDTOs, pos, kategorie);
      if (pos != -1) {
        AreaBreak aB = new AreaBreak();
        doc.add(aB);
      }
    }
    doc.close();
  }

  private static int printVereinRangliste(Document doc, PdfFont fontB, PdfFont fontN,
      List<RanglistenEntryDTO> ranglistenDTOs, int pos, KategorieEnum kategorie) {
    if (pos >= ranglistenDTOs.size()) {
      return -1;
    }
    int auszeichnungen = 0;
    String verein = ranglistenDTOs.get(pos).getVerein();
    Text vereinText = new Text("Verein: " + verein + " " + kategorie.name()).setFont(fontB)
        .setFontSize(16);
    doc.add(new Paragraph(vereinText));
    while (pos < ranglistenDTOs.size() && verein.equals(ranglistenDTOs.get(pos).getVerein())) {
      if (printRow(doc, fontB, fontN, ranglistenDTOs.get(pos++))) {
        auszeichnungen++;
      }
    }
    Text auszText = new Text("Anzahl Auszeichnungen: " + "%d".formatted(auszeichnungen)).setFont(
            fontB)
        .setFontSize(12);
    doc.add(new Paragraph(auszText));
    return pos;
  }

  private static boolean printRow(Document doc, PdfFont fontB, PdfFont fontN,
      RanglistenEntryDTO ranglistenDTO) {
    String ausz = " ";
    boolean auszeichnung = ranglistenDTO.isAuszeichnung() && ranglistenDTO.getRang() > 3;
    if (auszeichnung) {
      ausz = "*";
    }
    String name_vorname =
        "%03d".formatted(ranglistenDTO.getRang()) + "  " + ausz + " " + ranglistenDTO.getName()
            + " " + ranglistenDTO.getVorname() + "  " + "%2.3f".formatted(
            ranglistenDTO.getGesamtPunktzahl());
    Text text = new Text(name_vorname).setFontSize(12);
    if (ranglistenDTO.getRang() < 4) {
      text = text.setFont(fontB);
    } else {
      text = text.setFont(fontN);
    }
    doc.add(new Paragraph(text));

    return auszeichnung;
  }

  public static void createRangliste(OutputStream responseStream, Anlass anlass,
      List<RanglistenEntryDTO> ranglistenDTOs, TiTuEnum tiTu, KategorieEnum kategorie)
      throws IOException {
    var turner = tiTu != TiTuEnum.Ti;
    var averageSprung = kategorie.equals(KategorieEnum.K6) || kategorie.equals(KategorieEnum.K7);
    PdfDocument pdf = new PdfDocument(new PdfWriter(responseStream));
    Document doc = new Document(pdf, PageSize.A4);
    TableHeaderEventHandler thEventHandler = new TableHeaderEventHandler(doc, anlass, turner,
        kategorie.name());
    pdf.addEventHandler(PdfDocumentEvent.END_PAGE, thEventHandler);
    pdf.addEventHandler(PdfDocumentEvent.END_PAGE,
        new TextFooterEventHandler(doc, anlass, kategorie.name()));

    // Calculate top margin to be sure that the table will fit the margin.
    float topMargin = 20 + thEventHandler.getTableHeight();
    doc.setMargins(topMargin, 30, 20, 30);

    Table table = initTable(turner);
    int rang = 0;
    for (RanglistenEntryDTO dto : ranglistenDTOs) {
      /*
       * if (rang != dto.getRang()) { rang = dto.getRang(); }
       */
      createRow(table, ++rang, dto, turner, averageSprung);
    }
    doc.add(table);

    doc.close();
  }

  public static void csvWriteToWriter(OutputStream responseStream,
      List<RanglistenEntryDTO> ranglistenDTOs)
      throws CsvDataTypeMismatchException, CsvRequiredFieldEmptyException, IOException {

    final byte[] bom = new byte[]{(byte) 239, (byte) 187, (byte) 191};
    OutputStream os = responseStream;
    os.write(bom);
    os.write(bom);

    final PrintWriter responseWriter = new PrintWriter(new OutputStreamWriter(os, "UTF-8"));

    HeaderColumnNameMappingStrategy<RanglistenEntryDTO> strategy = new HeaderColumnNameMappingStrategyBuilder<RanglistenEntryDTO>()
        .build();
    strategy.setType(RanglistenEntryDTO.class);
    strategy.setColumnOrderOnWrite(new LiteralComparator(RanglistenEntryDTO.FIELDS_ORDER));

    StatefulBeanToCsv<RanglistenEntryDTO> writer = new StatefulBeanToCsvBuilder<RanglistenEntryDTO>(
        responseWriter)
        .withQuotechar(CSVWriter.NO_QUOTE_CHARACTER).withSeparator(';')
        .withMappingStrategy(strategy)
        .withOrderedResults(true).build();
    writer.write(ranglistenDTOs);
    responseWriter.flush();
    responseWriter.close();
  }

  private static Table initTable(boolean turner) {
    Table table = new Table(UnitValue.createPercentArray(TableHeaderEventHandler.headerWidths1))
        .useAllAvailableWidth();
    if (turner) {
      table = new Table(UnitValue.createPercentArray(TableHeaderEventHandler.headerWidths2))
          .useAllAvailableWidth();
    }
    return table;
  }

  private static void createRow(Table table, int rang, RanglistenEntryDTO dto, boolean turner,
      boolean sprungAverage)
      throws IOException {
    boolean even = rang % 2 == 0;
    if (rang == dto.getRang()) {
      printCell(table, "%d".formatted(dto.getRang()), false, even);
    } else {
      printCell(table, "", even);
    }
    printCell(table, dto.getName() + " " + dto.getVorname(), even);
    // printCell(table, );
    printCell(table, "%d".formatted(dto.getJahrgang()), false, even);
    printCell(table, dto.getVerein(), even);
    printCell(table, "%.2f".formatted(dto.getNoteReck()), false, even);
    printCell(table, "%d".formatted(dto.getRangReck()), false, even);
    printCell(table, "%.2f".formatted(dto.getNoteBoden()), false, even);
    printCell(table, "%d".formatted(dto.getRangBoden()), false, even);
    printCell(table, "%.2f".formatted(dto.getNoteSchaukelringe()), false, even);
    printCell(table, "%d".formatted(dto.getRangSchaukelringe()), false, even);
    printCell(table, "%.2f".formatted(dto.getNoteSprung1()), false, even);
    printCell(table, "%.2f".formatted(dto.getNoteSprung2()), false, even);
    DecimalFormat df = new DecimalFormat("#0.00");
    df.setRoundingMode(RoundingMode.HALF_UP);
    printCell(table, df.format(dto.getNoteZaehlbar() + 0.0005f), false, even);
    /*
     * if (sprungAverage) { printCell(table, String.format("%.2f",
     * dto.getNoteZaehlbar()), false, even); } else { printCell(table,
     * String.format("%.2f", dto.getNoteZaehlbar()), false, even); }
     */
    printCell(table, "%d".formatted(dto.getRangSprung()), false, even);
    if (turner) {
      printCell(table, "%.2f".formatted(dto.getNoteBarren()), false, even);
      printCell(table, "%d".formatted(dto.getRangBarren()), false, even);
    }
    df.setRoundingMode(RoundingMode.HALF_UP);
    String asText = df.format(dto.getGesamtPunktzahl() + 0.0005f);
    printCell(table, asText, false, even);
    /*
     * if (sprungAverage) { printCell(table, String.format("%.2f",
     * dto.getGesamtPunktzahl()), false, even); } else { printCell(table,
     * String.format("%.2f", dto.getGesamtPunktzahl()), false, even); }
     */
    if (rang == dto.getRang()) {
      printCell(table, "%d".formatted(dto.getRang()), false, even);
    } else {
      printCell(table, "", even);
    }
    switch (dto.getRang()) {
      case 1:
        printCell(table, "G", even);
        break;
      case 2:
        printCell(table, "S", even);
        break;
      case 3:
        printCell(table, "B", even);
        break;
      default:
        if (dto.isAuszeichnung()) {
          printCell(table, "*", even);
        } else {
          printCell(table, "", even);
        }
    }
  }

  private static void printCell(Table table, String value, boolean even) throws IOException {
    printCell(table, value, true, even);
  }

  private static void printCell(Table table, String value, boolean leftAlign, boolean even)
      throws IOException {
    PdfFont fontN = PdfFontFactory.createFont(StandardFonts.HELVETICA);

    Cell cell = new Cell();
    cell.setBorderTop(new SolidBorder(ColorConstants.LIGHT_GRAY, 1.0f));
    cell.setBorderBottom(new SolidBorder(ColorConstants.LIGHT_GRAY, 1.0f));
    Text text = new Text(value).setFont(fontN).setFontSize(7);
    cell.add(new Paragraph(text).setMultipliedLeading(1.0f));
    // cell.add(new Paragraph(text));
    if (leftAlign) {
      cell = cell.setTextAlignment(TextAlignment.LEFT);
    } else {
      cell = cell.setTextAlignment(TextAlignment.RIGHT);
    }
    if (even) {
      cell.setBackgroundColor(ColorConstants.LIGHT_GRAY, 0.2f);
    }
    table.addCell(cell);
  }

  private static class TextFooterEventHandler implements IEventHandler {

    private Table table;
    private float tableHeight;
    private Document doc;
    private Anlass anlass;
    private String kategorie;

    public TextFooterEventHandler(Document doc, Anlass anlass, String kategorie) {
      this.doc = doc;
      this.anlass = anlass;
      this.kategorie = kategorie;
    }

    @Override
    public void handleEvent(Event currentEvent) {
      PdfDocumentEvent docEvent = (PdfDocumentEvent) currentEvent;
      Rectangle pageSize = docEvent.getPage().getPageSize();

      PdfFont font = null;
      try {
        font = PdfFontFactory.createFont(StandardFonts.HELVETICA_OBLIQUE);
      } catch (IOException e) {
        System.err.println(e.getMessage());
      }

      float coordX = ((pageSize.getLeft() + doc.getLeftMargin()) + (pageSize.getRight()
          - doc.getRightMargin()))
          / 2;
      float headerY = pageSize.getTop() - doc.getTopMargin() + 10;
      float footerY = doc.getBottomMargin() - 5;

      String sponsor = "";
      if (anlass.getKategorieSponsoren() != null
          && anlass.getKategorieSponsoren().getSponsoren() != null
          && anlass.getKategorieSponsoren().getSponsoren().containsKey(kategorie)) {
        sponsor =
            "Kategoriensponsor: " + anlass.getKategorieSponsoren().getSponsoren().get(kategorie);
      }
      Canvas canvas = new Canvas(docEvent.getPage(), pageSize);
      canvas
          // If the exception has been thrown, the font variable is not initialized.
          // Therefore null will be set and iText will use the default font - Helvetica
          .setFont(font).setFontSize(5)
          // .showTextAligned("this is a header", coordX, headerY, TextAlignment.CENTER)
          .showTextAligned(sponsor + "   " + anlass.getRanglistenFooter(), coordX, footerY,
              TextAlignment.CENTER)
          .close();
    }

    public float getTableHeight() {
      return tableHeight;
    }

    private void ceateTableHeader() {
      float[] headerWidths = {10.0f, 30.0f, 60.0f};
      Table headerTable = new Table(
          UnitValue.createPercentArray(headerWidths)).useAllAvailableWidth();

    }
  }
}
