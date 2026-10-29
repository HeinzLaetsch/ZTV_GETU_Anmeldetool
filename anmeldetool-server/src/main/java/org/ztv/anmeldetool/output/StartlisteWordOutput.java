package org.ztv.anmeldetool.output;

import java.io.IOException;
import java.io.OutputStream;
import java.math.BigInteger;
import java.util.List;

import org.apache.poi.xwpf.usermodel.BreakType;
import org.apache.poi.xwpf.usermodel.ParagraphAlignment;
import org.apache.poi.xwpf.usermodel.TableWidthType;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.apache.poi.xwpf.usermodel.XWPFTableCell;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;
import org.apache.poi.wp.usermodel.HeaderFooterType;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTabStop;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTabs;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblGrid;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.CTTblGridCol;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STHighlightColor;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STTabJc;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STTblLayoutType;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.transfer.StartlisteDTO;

/** Writes the Startliste (Vereine and starter count per Abteilung) as a Word document. */
public final class StartlisteWordOutput {

  static final String ZEIT_PLATZHALTER = "[Tag], [hh.mm] Uhr";
  static final String RANGVERKUENDIGUNG_PLATZHALTER = "[hh.mm] Uhr";

  private static final int COLUMNS = 3;
  private static final int VEREIN_WIDTH = 2600;
  private static final int ANZAHL_WIDTH = 600;
  private static final String FONT = "Arial";
  private static final int FONT_SIZE = 11;
  private static final int TITLE_FONT_SIZE = 14;

  private StartlisteWordOutput() {
  }

  public static void write(StartlisteDTO startliste, OutputStream out) throws IOException {
    try (XWPFDocument document = new XWPFDocument()) {
      writeHeader(document, startliste);
      List<StartlisteDTO.Section> sections = startliste.sections();
      for (int i = 0; i < sections.size(); i++) {
        writeSection(document, sections.get(i), i < sections.size() - 1);
      }
      document.write(out);
    }
  }

  private static void writeHeader(XWPFDocument document, StartlisteDTO startliste) {
    XWPFParagraph paragraph = document.createHeader(HeaderFooterType.DEFAULT).createParagraph();
    paragraph.setAlignment(ParagraphAlignment.RIGHT);
    String ort = startliste.ort() == null || startliste.ort().isBlank() ? "" : ", " + startliste.ort();
    text(paragraph, "Startliste " + nullToEmpty(startliste.anlassBezeichnung()) + ort, false, 9);
  }

  private static void writeSection(XWPFDocument document, StartlisteDTO.Section section, boolean pageBreak) {
    XWPFParagraph title = document.createParagraph();
    addTabStop(title, (VEREIN_WIDTH + ANZAHL_WIDTH) * 2);
    title.setSpacingAfter(200);
    XWPFRun titleRun = text(title, kategorieLabel(section.kategorie()), true, TITLE_FONT_SIZE);
    titleRun.addTab();
    titleRun.setText(tiTuLabel(section.tiTu()));

    // POI derives the cell count of new rows from the first row, so start with a template row and drop it after.
    XWPFTable table = document.createTable(1, COLUMNS * 2);
    configureTable(table);
    List<StartlisteDTO.Abteilung> abteilungen = section.abteilungen();
    for (int i = 0; i < abteilungen.size(); i++) {
      writeAbteilung(table, abteilungen.get(i));
      if (i < abteilungen.size() - 1) {
        table.createRow();
      }
    }
    table.removeRow(0);

    XWPFParagraph rangverkuendigung = document.createParagraph();
    rangverkuendigung.setSpacingBefore(300);
    text(rangverkuendigung, "Rangverkündigung: ", false, FONT_SIZE);
    placeholder(rangverkuendigung, RANGVERKUENDIGUNG_PLATZHALTER);
    if (pageBreak) {
      rangverkuendigung.createRun().addBreak(BreakType.PAGE);
    }
  }

  private static void writeAbteilung(XWPFTable table, StartlisteDTO.Abteilung abteilung) {
    XWPFTableRow header = table.createRow();
    text(cellParagraph(header.getCell(0)), abteilungLabel(abteilung.abteilung()), true, FONT_SIZE);
    placeholder(cellParagraph(header.getCell(2)), ZEIT_PLATZHALTER);

    List<StartlisteDTO.VereinStarter> vereine = abteilung.vereine();
    int[] columnStarts = columnStarts(vereine.size());
    int rows = vereine.isEmpty() ? 0 : columnStarts[1];
    for (int row = 0; row < rows; row++) {
      XWPFTableRow tableRow = table.createRow();
      for (int column = 0; column < COLUMNS; column++) {
        int index = columnStarts[column] + row;
        if (index < columnStarts[column + 1]) {
          StartlisteDTO.VereinStarter verein = vereine.get(index);
          text(cellParagraph(tableRow.getCell(column * 2)), verein.verein(), false, FONT_SIZE);
          XWPFParagraph anzahl = cellParagraph(tableRow.getCell(column * 2 + 1));
          anzahl.setAlignment(ParagraphAlignment.RIGHT);
          text(anzahl, Long.toString(verein.anzahl()), false, FONT_SIZE);
        }
      }
    }
  }

  /**
   * Distributes {@code count} entries top-to-bottom over the columns; the first columns get the extra entries
   * (e.g. 13 → 5/4/4). Returns the start index of each column plus the total as last element.
   */
  static int[] columnStarts(int count) {
    int[] starts = new int[COLUMNS + 1];
    int base = count / COLUMNS;
    int remainder = count % COLUMNS;
    for (int column = 0; column < COLUMNS; column++) {
      starts[column + 1] = starts[column] + base + (column < remainder ? 1 : 0);
    }
    return starts;
  }

  private static void configureTable(XWPFTable table) {
    table.removeBorders();
    table.setWidthType(TableWidthType.DXA);
    table.setWidth(Integer.toString((VEREIN_WIDTH + ANZAHL_WIDTH) * COLUMNS));
    table.getCTTbl().getTblPr().addNewTblLayout().setType(STTblLayoutType.FIXED);
    CTTblGrid grid = table.getCTTbl().getTblGrid() != null ? table.getCTTbl().getTblGrid()
        : table.getCTTbl().addNewTblGrid();
    grid.setGridColArray(new CTTblGridCol[0]);
    for (int column = 0; column < COLUMNS; column++) {
      grid.addNewGridCol().setW(BigInteger.valueOf(VEREIN_WIDTH));
      grid.addNewGridCol().setW(BigInteger.valueOf(ANZAHL_WIDTH));
    }
  }

  private static XWPFParagraph cellParagraph(XWPFTableCell cell) {
    return cell.getParagraphs().getFirst();
  }

  private static void addTabStop(XWPFParagraph paragraph, int position) {
    CTTabs tabs = paragraph.getCTP().isSetPPr() && paragraph.getCTP().getPPr().isSetTabs()
        ? paragraph.getCTP().getPPr().getTabs()
        : paragraph.getCTPPr().addNewTabs();
    CTTabStop tab = tabs.addNewTab();
    tab.setVal(STTabJc.LEFT);
    tab.setPos(BigInteger.valueOf(position));
  }

  private static XWPFRun text(XWPFParagraph paragraph, String value, boolean bold, int size) {
    XWPFRun run = paragraph.createRun();
    run.setFontFamily(FONT);
    run.setFontSize(size);
    run.setBold(bold);
    run.setText(value);
    return run;
  }

  private static void placeholder(XWPFParagraph paragraph, String value) {
    text(paragraph, value, false, FONT_SIZE).getCTR().addNewRPr().addNewHighlight().setVal(STHighlightColor.YELLOW);
  }

  static String kategorieLabel(KategorieEnum kategorie) {
    return "Kategorie " + kategorie.name().substring(1);
  }

  static String tiTuLabel(TiTuEnum tiTu) {
    return switch (tiTu) {
      case Ti -> "Turnerinnen";
      case Tu -> "Turner";
      case Alle -> "Turnerinnen und Turner";
    };
  }

  static String abteilungLabel(AbteilungEnum abteilung) {
    if (abteilung == null || abteilung == AbteilungEnum.UNDEFINED) {
      return "Ohne Abteilung";
    }
    return abteilung.name().substring("ABTEILUNG_".length()) + ". Abteilung";
  }

  private static String nullToEmpty(String value) {
    return value == null ? "" : value;
  }
}
