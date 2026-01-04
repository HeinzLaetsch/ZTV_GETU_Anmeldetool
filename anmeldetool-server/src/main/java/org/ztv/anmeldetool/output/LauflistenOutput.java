package org.ztv.anmeldetool.output;

import com.itextpdf.io.font.constants.StandardFonts;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.borders.Border;
import com.itextpdf.layout.element.AreaBreak;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.element.Text;
import com.itextpdf.layout.properties.HorizontalAlignment;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.itextpdf.layout.properties.VerticalAlignment;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.stream.Collectors;
import java.util.stream.Stream;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.AnlassLauflisten;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.Laufliste;
import org.ztv.anmeldetool.models.LauflistenContainer;
import org.ztv.anmeldetool.models.PrintableLaufliste;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;

public class LauflistenOutput {

  private LauflistenOutput() {
    // private constructor for utility class
  }

  public static void createLaufListe(OutputStream outputStream, Anlass anlass,
      Optional<Boolean> onlyTiOpt,
      AnlassLauflisten anlassLauflisten) throws IOException {

    PdfDocument pdf = new PdfDocument(new PdfWriter(outputStream));
    Document document = new Document(pdf);
    List<LauflistenContainer> lcs = anlassLauflisten.getLauflistenContainer();
    lcs.sort(new Comparator<LauflistenContainer>() {
      @Override
      public int compare(LauflistenContainer o1, LauflistenContainer o2) {
        return o1.getStartgeraetOrd() < o2.getStartgeraetOrd() ? -1
            : o1.getStartgeraetOrd() == o2.getStartgeraetOrd() ? 0 : 1;
      }
    });

    List<List<Laufliste>> geraeteListen = new ArrayList<List<Laufliste>>();

    int currentIndex = 0;
    // int korrektur = 1; // wegen Undefined bei Ti == 2
    int maxGeraete = GeraetEnum.values().length - 1;
    boolean onlyTi = TiTuEnum.Ti.equals(anlass.getTiTu()) || onlyTiOpt.orElseGet(() -> false);
    if (onlyTi) {
      maxGeraete = GeraetEnum.values().length - 2;
    }

    for (GeraetEnum geraet : GeraetEnum.values()) {
      if (geraet.equals(GeraetEnum.UNDEFINED)) {
        continue;
      }
      if (geraet.equals(GeraetEnum.BARREN) && onlyTi) {
        continue;
      }
      List<Laufliste> gl = new ArrayList<Laufliste>();
      geraeteListen.add(gl);
      for (LauflistenContainer lc : lcs) {
        int pos = lc.getStartgeraetOrd() + currentIndex;
        if (pos >= maxGeraete) {
          pos = (lc.getStartgeraetOrd() + currentIndex) - maxGeraete;
        }
        if (lc.getGeraeteLauflisten() != null && pos < lc.getGeraeteLauflisten().size()) {
          gl.add(lc.getGeraeteLauflisten().get(pos));
        }
      }
      currentIndex++;
    }
    // boolean first = true;
    List<PrintableLaufliste> pl = new ArrayList<PrintableLaufliste>();
    for (List<Laufliste> gl : geraeteListen) {
      for (Laufliste ll : gl) {
        int wechsel =
            ll.getGeraet().ordinal() - ll.getLauflistenContainer().getStartgeraetOrd() + 1;
        if (wechsel < 1) {
          wechsel += maxGeraete;
        }
        /*
         * if (!first) { AreaBreak aB = new AreaBreak(); document.add(aB); } first =
         * false;
         */
        // addLaufliste(document, ll, wechsel++);
        PrintableLaufliste printable = new PrintableLaufliste(ll, wechsel++);
        pl.add(printable);
      }
    }
    pl.sort((PrintableLaufliste pl1, PrintableLaufliste pl2) -> {
      if (pl1.getLaufliste().getGeraet().ordinal() > pl2.getLaufliste().getGeraet().ordinal()) {
        return 1;
      }
      if (pl1.getLaufliste().getGeraet().ordinal() == pl2.getLaufliste().getGeraet().ordinal()) {
        if (pl1.getWechsel() > pl2.getWechsel()) {
          return 1;
        }
        return -1;
      } else {
        return -1;
      }
    });
    AtomicBoolean first = new AtomicBoolean(true);
    pl.forEach(printable -> {
      try {
        if (!first.get()) {
          AreaBreak aB = new AreaBreak();
          document.add(aB);
        }
        addLaufliste(document, printable.getLaufliste(), printable.getWechsel());
        first.set(false);
      } catch (IOException e) {
        e.printStackTrace();
      }
    });
    document.close();

  }

  private static void addLaufliste(Document document, Laufliste laufliste, int currentIndex)
      throws IOException {
    PdfFont fontN = PdfFontFactory.createFont(StandardFonts.HELVETICA);
    PdfFont fontB = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);

    float[] headerWidths = {10.0f, 30.0f, 60.0f};
    Table headerTable = new Table(
        UnitValue.createPercentArray(headerWidths)).useAllAvailableWidth();
    Text abt1 = new Text(
        "Abteilung: " + laufliste.getLauflistenContainer().getTeilnehmerAnlassLinks().getFirst()
            .getAbteilung())
        .setFont(fontN).setFontSize(12);
    Cell cell = new Cell(1, 2);
    cell.add(new Paragraph(abt1));

    cell.setBorder(Border.NO_BORDER).setVerticalAlignment(VerticalAlignment.BOTTOM);
    headerTable.addCell(cell);

    Text anlage = new Text(
        "Anlage: " + laufliste.getLauflistenContainer().getTeilnehmerAnlassLinks().getFirst()
            .getAnlage())
        .setFont(fontN).setFontSize(12);
    cell = new Cell();
    cell.add(new Paragraph(anlage));
    cell.setBorder(Border.NO_BORDER).setVerticalAlignment(VerticalAlignment.BOTTOM);
    headerTable.addCell(cell);

    Text liste1 = new Text("Laufliste  ").setFont(fontN).setFontSize(16);
    cell = new Cell();
    cell.add(new Paragraph(liste1));
    cell.setBorder(Border.NO_BORDER).setVerticalAlignment(VerticalAlignment.BOTTOM);
    headerTable.addCell(cell);

    Text liste2 = new Text(laufliste.getKey()).setFont(fontB).setFontSize(16);
    cell = new Cell();
    cell.add(new Paragraph(liste2));
    cell.setBorder(Border.NO_BORDER).setVerticalAlignment(VerticalAlignment.BOTTOM);
    headerTable.addCell(cell);

    cell = new Cell();
    cell.add(new Paragraph(""));
    cell.setBorder(Border.NO_BORDER);
    headerTable.addCell(cell);

    Text title1 = new Text("Gerät  ").setFont(fontN).setFontSize(16);
    cell = new Cell();
    cell.add(new Paragraph(title1));
    cell.setBorder(Border.NO_BORDER);
    headerTable.addCell(cell);

    Text title2 = new Text(laufliste.getGeraet().name()).setFont(fontB).setFontSize(16);
    cell = new Cell();
    cell.add(new Paragraph(title2));
    cell.setBorder(Border.NO_BORDER);
    headerTable.addCell(cell);

    Text title3 = new Text("  Wechsel " + currentIndex).setFont(fontN).setFontSize(16);
    cell = new Cell();
    cell.add(new Paragraph(title3).setTextAlignment(TextAlignment.RIGHT));
    cell.setBorder(Border.NO_BORDER).setHorizontalAlignment(HorizontalAlignment.RIGHT);
    headerTable.addCell(cell);

    document.add(headerTable);

    addEmptyLine(new Paragraph().setFont(fontN), 1);

    float[] widths1 = {6.0f, 6.0f, 20.0f, 20.0f, 20.0f, 28.0f};
    float[] widths2 = {6.0f, 6.0f, 20.0f, 20.0f, 20.0f, 14.0f, 14.0f};
    float[] widths = widths1;
    boolean isSprung = false;
    if (laufliste.getGeraet().equals(GeraetEnum.SPRUNG)) {
      widths = widths2;
      isSprung = true;
    }
    laufliste.setAbloesung(currentIndex);
    Table table = new Table(UnitValue.createPercentArray(widths)).useAllAvailableWidth();
    table.setFixedLayout();
    addTableHeader(table, isSprung);
    int index = 1;
    int korrIndex = currentIndex;
    List<TeilnehmerAnlassLink> tals = laufliste.getLauflistenContainer()
        .getTeilnehmerAnlassLinksOrdered();
    if (tals.size() < korrIndex) {
      korrIndex -= tals.size();
    }
    int startOrder = 0;
    for (TeilnehmerAnlassLink tal : tals) {
      if (index >= korrIndex) {
        addRow(table, tal, isSprung);
        updateStartOrder(tal, laufliste, startOrder++);
      }
      index++;
    }
    index = 1;
    for (TeilnehmerAnlassLink tal : tals) {
      if (index < korrIndex) {
        addRow(table, tal, isSprung);
        updateStartOrder(tal, laufliste, startOrder++);
      }
      index++;
    }
    document.add(table);
  }

  private static void updateStartOrder(TeilnehmerAnlassLink tal, Laufliste laufliste,
      int startOrder) {
    laufliste.getEinzelnoten().stream().forEach(einzelnote -> {
      if (tal.getId().equals(einzelnote.getNotenblatt().getTal().getId())) {
        einzelnote.setStartOrder(startOrder);
      }
    });
  }

  private static void addContainer(Document document, LauflistenContainer container,
      GeraetEnum geraet,
      int currentIndex) throws IOException {
    Laufliste laufliste = container.getGeraeteLauflisten().stream().filter(liste -> {
      return liste.getGeraet().equals(geraet);
    }).collect(Collectors.toList()).getFirst();
    addLaufliste(document, laufliste, currentIndex);
  }

  private static void addTableHeader(Table table, boolean isSprung) {
    if (isSprung) {
      Stream.of("Kat.", "Nr.", "Verein", "Name", "Vorname", "Note 1", "Note 2")
          .forEach(columnTitle -> {
            table.addCell(columnTitle);
          });
    } else {
      Stream.of("Kat.", "Nr.", "Verein", "Name", "Vorname", "Note").forEach(columnTitle -> {
        table.addCell(columnTitle);
      });
    }
  }

  private static void addRow(Table table, TeilnehmerAnlassLink tal, boolean isSprung) {
    Cell cell = new Cell();
    cell.setMinHeight(30);
    cell.setVerticalAlignment(VerticalAlignment.MIDDLE);
    cell.add(new Paragraph(tal.getKategorie().name()));
    table.addCell(cell);

    cell = new Cell();
    cell.setMinHeight(30);
    cell.setVerticalAlignment(VerticalAlignment.MIDDLE);
    cell.add(new Paragraph(tal.getStartnummer().toString()).setTextAlignment(TextAlignment.RIGHT));
    table.addCell(cell);

    cell = new Cell();
    cell.setMinHeight(30);
    cell.setVerticalAlignment(VerticalAlignment.MIDDLE);
    cell.add(new Paragraph(tal.getOrganisation().getName()));
    table.addCell(cell);

    cell = new Cell();
    cell.setMinHeight(30);
    cell.setVerticalAlignment(VerticalAlignment.MIDDLE);
    cell.add(new Paragraph(tal.getTeilnehmer().getName()));
    table.addCell(cell);

    cell = new Cell();
    cell.setMinHeight(30);
    cell.setVerticalAlignment(VerticalAlignment.MIDDLE);
    cell.add(new Paragraph(tal.getTeilnehmer().getVorname()));
    table.addCell(cell);

    cell = new Cell();
    cell.setMinHeight(30);
    cell.setVerticalAlignment(VerticalAlignment.MIDDLE);
    cell.add(new Paragraph(""));
    table.addCell(cell);

    if (isSprung) {
      cell = new Cell();
      cell.setMinHeight(30);
      cell.setVerticalAlignment(VerticalAlignment.MIDDLE);
      cell.add(new Paragraph(""));
      table.addCell(cell);
    }
  }

  private static void addEmptyLine(Paragraph paragraph, int number) {
    for (int i = 0; i < number; i++) {
      paragraph.add(new Paragraph(" "));
    }
  }
}
