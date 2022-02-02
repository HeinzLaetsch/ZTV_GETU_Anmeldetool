package org.ztv.anmeldetool.anmeldetool.output;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.servlet.http.HttpServletResponse;

import org.dom4j.DocumentException;
import org.ztv.anmeldetool.anmeldetool.models.AnlassLauflisten;
import org.ztv.anmeldetool.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.anmeldetool.models.Laufliste;
import org.ztv.anmeldetool.anmeldetool.models.LauflistenContainer;
import org.ztv.anmeldetool.anmeldetool.models.TeilnehmerAnlassLink;

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

public class LauflistenOutput {

	public static void createLaufListe(AnlassLauflisten anlassLauflisten, HttpServletResponse response)
			throws DocumentException, IOException {

		PdfDocument pdf = new PdfDocument(new PdfWriter(response.getOutputStream()));
		Document document = new Document(pdf);

		boolean first = true;
		int currentIndex = 0;
		for (GeraetEnum geraet : GeraetEnum.values()) {
			if (geraet.equals(GeraetEnum.UNDEFINED)) {
				continue;
			}
			List<LauflistenContainer> lc = anlassLauflisten.getLauflistenContainer();
			int wechsel = 1;
			for (int index = currentIndex; index >= 0; index--) {

				int startgeraeteIndex = lc.get(index).getStartgeraet().ordinal();
				if (startgeraeteIndex <= geraet.ordinal()) {
					if (!first) {
						AreaBreak aB = new AreaBreak();
						document.add(aB);
					}
					first = false;
					addContainer(document, lc.get(index), geraet, wechsel++);
				}
			}
			for (int index = lc.size() - 1; index >= 0; index--) {
				int startgeraeteIndex = lc.get(index).getStartgeraet().ordinal();
				if (startgeraeteIndex > geraet.ordinal()) {
					if (!first) {
						AreaBreak aB = new AreaBreak();
						document.add(aB);
					}
					first = false;
					addContainer(document, lc.get(index), geraet, wechsel++);
				}
			}
			currentIndex++;
		}
		document.close();
	}

	private static void addLaufliste(Document document, Laufliste laufliste, GeraetEnum geraet, int currentIndex)
			throws IOException {
		PdfFont fontN = PdfFontFactory.createFont(StandardFonts.HELVETICA);
		PdfFont fontB = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);

		float[] headerWidths = { 10.0f, 30.0f, 60.0f };
		Table headerTable = new Table(UnitValue.createPercentArray(headerWidths)).useAllAvailableWidth();
		Text liste1 = new Text("Laufliste  ").setFont(fontN).setFontSize(16);
		Cell cell = new Cell();
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

		float[] widths1 = { 6.0f, 20.0f, 20.0f, 20.0f, 34.0f };
		float[] widths2 = { 6.0f, 20.0f, 20.0f, 20.0f, 17.0f, 17.0f };
		float[] widths = widths1;
		boolean isSprung = false;
		if (geraet.equals(GeraetEnum.SPRUNG)) {
			widths = widths2;
			isSprung = true;
		}
		Table table = new Table(UnitValue.createPercentArray(widths)).useAllAvailableWidth();
		table.setFixedLayout();
		addTableHeader(table, isSprung);
		int index = 0;
		for (TeilnehmerAnlassLink tal : laufliste.getLauflistenContainer().getTeilnehmerAnlassLinksOrdered()) {
			if (index >= geraet.ordinal()) {
				addRows(table, tal, isSprung);
			}
			index++;
		}
		index = 0;
		for (TeilnehmerAnlassLink tal : laufliste.getLauflistenContainer().getTeilnehmerAnlassLinksOrdered()) {
			if (index < geraet.ordinal()) {
				addRows(table, tal, isSprung);
			}
			index++;
		}
		document.add(table);
	}

	private static void addContainer(Document document, LauflistenContainer container, GeraetEnum geraet,
			int currentIndex) throws DocumentException, IOException {
		Laufliste laufliste = container.getGeraeteLauflisten().stream().filter(liste -> {
			return liste.getGeraet().equals(geraet);
		}).collect(Collectors.toList()).get(0);
		addLaufliste(document, laufliste, geraet, currentIndex);
	}

	private static void addTableHeader(Table table, boolean isSprung) {
		if (isSprung) {
			Stream.of("Kat.", "Verein", "Name", "Vorname", "Note 1", "Note 2").forEach(columnTitle -> {
				Cell header = new Cell();
				// header.setBackgroundColor(BaseColor.LIGHT_GRAY);
				// header.setBorder(1);
				// header.setP
				table.addCell(columnTitle);
			});
		} else {
			Stream.of("Kat.", "Verein", "Name", "Vorname", "Note").forEach(columnTitle -> {
				Cell header = new Cell();
				// header.setBackgroundColor(BaseColor.LIGHT_GRAY);
				// header.setBorder(1);
				// header.setP
				table.addCell(columnTitle);
			});
		}
	}

	private static void addRows(Table table, TeilnehmerAnlassLink tal, boolean isSprung) {
		Cell cell = new Cell();
		cell.setMinHeight(30);
		cell.setVerticalAlignment(VerticalAlignment.MIDDLE);
		cell.add(new Paragraph(tal.getKategorie().name()));
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

	/*
	 * private void addCustomRows(PdfPTable table) throws URISyntaxException,
	 * BadElementException, IOException { Path path =
	 * Paths.get(ClassLoader.getSystemResource("Java_logo.png").toURI()); Image img
	 * = Image.getInstance(path.toAbsolutePath().toString()); img.scalePercent(10);
	 * 
	 * PdfPCell imageCell = new PdfPCell(img); table.addCell(imageCell);
	 * 
	 * PdfPCell horizontalAlignCell = new PdfPCell(new Phrase("row 2, col 2"));
	 * horizontalAlignCell.setHorizontalAlignment(Element.ALIGN_CENTER);
	 * table.addCell(horizontalAlignCell);
	 * 
	 * PdfPCell verticalAlignCell = new PdfPCell(new Phrase("row 2, col 3"));
	 * verticalAlignCell.setVerticalAlignment(Element.ALIGN_BOTTOM);
	 * table.addCell(verticalAlignCell); }
	 */
}
