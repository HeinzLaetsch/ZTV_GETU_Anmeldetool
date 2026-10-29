package org.ztv.anmeldetool.output;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.util.List;

import org.apache.poi.xwpf.usermodel.ParagraphAlignment;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;
import org.apache.poi.xwpf.usermodel.XWPFTable;
import org.apache.poi.xwpf.usermodel.XWPFTableCell;
import org.apache.poi.xwpf.usermodel.XWPFTableRow;
import org.junit.jupiter.api.Test;
import org.openxmlformats.schemas.wordprocessingml.x2006.main.STBrType;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.transfer.StartlisteDTO;
import org.ztv.anmeldetool.transfer.StartlisteDTO.VereinStarter;

class StartlisteWordOutputTest {

  @Test
  void distributesVereineTopToBottomWithExtraEntriesInTheFirstColumns() {
    assertThat(StartlisteWordOutput.columnStarts(13)).containsExactly(0, 5, 9, 13);
    assertThat(StartlisteWordOutput.columnStarts(10)).containsExactly(0, 4, 7, 10);
    assertThat(StartlisteWordOutput.columnStarts(14)).containsExactly(0, 5, 10, 14);
    assertThat(StartlisteWordOutput.columnStarts(2)).containsExactly(0, 1, 2, 2);
  }

  @Test
  void writesSectionTitleAbteilungenWithTimePlaceholdersAndVereinColumns() throws Exception {
    List<VereinStarter> vereine = List.of(new VereinStarter("Bassersdorf", 14), new VereinStarter("Bonstetten", 9),
        new VereinStarter("Eglisau", 4), new VereinStarter("Mettmenstetten", 5),
        new VereinStarter("Mönchaltorf", 5), new VereinStarter("Niederglatt", 15),
        new VereinStarter("Niederhasli", 7));
    StartlisteDTO startliste = new StartlisteDTO("Frühlingsmeeting", "Bülach", List.of(
        new StartlisteDTO.Section(KategorieEnum.K1, TiTuEnum.Ti, List.of(
            new StartlisteDTO.Abteilung(AbteilungEnum.ABTEILUNG_1, vereine),
            new StartlisteDTO.Abteilung(AbteilungEnum.ABTEILUNG_2, List.of(new VereinStarter("Watt", 8))))),
        new StartlisteDTO.Section(KategorieEnum.K5A, TiTuEnum.Tu, List.of(
            new StartlisteDTO.Abteilung(null, List.of(new VereinStarter("Rafz", 3)))))));

    try (XWPFDocument document = roundTrip(startliste)) {
      List<String> paragraphs = document.getParagraphs().stream().map(XWPFParagraph::getText)
          .map(String::strip).filter(text -> !text.isEmpty()).toList();
      assertThat(paragraphs).containsExactly(
          "Kategorie 1\tTurnerinnen", "Rangverkündigung: [hh.mm] Uhr",
          "Kategorie 5A\tTurner", "Rangverkündigung: [hh.mm] Uhr");
      assertThat(document.getParagraphs().stream().filter(StartlisteWordOutputTest::hasPageBreak)).hasSize(1);
      assertThat(document.getHeaderList().getFirst().getText()).contains("Startliste Frühlingsmeeting, Bülach");

      XWPFTable table = document.getTables().getFirst();
      assertThat(table.getRows()).hasSize(7);
      assertThat(cells(table.getRow(0))).containsExactly("1. Abteilung", "", "[Tag], [hh.mm] Uhr", "", "", "");
      assertThat(table.getRow(1).getCell(1).getParagraphs().getFirst().getAlignment())
          .isEqualTo(ParagraphAlignment.RIGHT);
      assertThat(cells(table.getRow(1)))
          .containsExactly("Bassersdorf", "14", "Mettmenstetten", "5", "Niederglatt", "15");
      assertThat(cells(table.getRow(2))).containsExactly("Bonstetten", "9", "Mönchaltorf", "5", "Niederhasli", "7");
      assertThat(cells(table.getRow(3))).containsExactly("Eglisau", "4", "", "", "", "");
      assertThat(cells(table.getRow(4))).containsOnly("");
      assertThat(cells(table.getRow(5))).startsWith("2. Abteilung");
      assertThat(cells(table.getRow(6))).startsWith("Watt", "8");

      assertThat(cells(document.getTables().get(1).getRow(0))).startsWith("Ohne Abteilung");
    }
  }

  private static XWPFDocument roundTrip(StartlisteDTO startliste) throws Exception {
    ByteArrayOutputStream out = new ByteArrayOutputStream();
    StartlisteWordOutput.write(startliste, out);
    return new XWPFDocument(new ByteArrayInputStream(out.toByteArray()));
  }

  private static boolean hasPageBreak(XWPFParagraph paragraph) {
    return paragraph.getRuns().stream().flatMap(run -> run.getCTR().getBrList().stream())
        .anyMatch(br -> br.getType() == STBrType.PAGE);
  }

  private static List<String> cells(XWPFTableRow row) {
    return row.getTableCells().stream().map(XWPFTableCell::getText).toList();
  }
}
