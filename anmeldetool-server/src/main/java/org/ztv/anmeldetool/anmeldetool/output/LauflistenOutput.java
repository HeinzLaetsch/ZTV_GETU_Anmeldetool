package org.ztv.anmeldetool.anmeldetool.output;

import java.io.IOException;
import java.util.stream.Stream;

import javax.servlet.http.HttpServletResponse;

import org.dom4j.DocumentException;
import org.ztv.anmeldetool.anmeldetool.models.AnlassLauflisten;
import org.ztv.anmeldetool.anmeldetool.models.LauflistenContainer;
import org.ztv.anmeldetool.anmeldetool.models.TeilnehmerAnlassLink;

import com.itextpdf.io.font.constants.StandardFonts;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.AreaBreak;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.UnitValue;
import com.itextpdf.layout.properties.VerticalAlignment;

public class LauflistenOutput {

	public static void createLaufListe(AnlassLauflisten anlassLauflisten, HttpServletResponse response)
			throws DocumentException, IOException {

		PdfDocument pdf = new PdfDocument(new PdfWriter(response.getOutputStream()));
		Document document = new Document(pdf);

		// Font fontL = FontFactory.getFont(FontFactory.COURIER, 16, BaseColor.BLACK);
		PdfFont fontL = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);
		// Chunk chunk = new Chunk("Lauflisten ", fontL);
		Paragraph paragraph1 = new Paragraph("Laufliste ").setFont(fontL);

		boolean first = true;
		document.add(paragraph1);
		for (LauflistenContainer container : anlassLauflisten.getLauflistenContainer()) {
			if (!first) {
				AreaBreak aB = new AreaBreak();
				document.add(aB);
			}
			first = false;
			addContainer(document, container);
		}
		// addCustomRows(table);

		document.close();
	}

	private static void addContainer(Document document, LauflistenContainer container)
			throws DocumentException, IOException {
		PdfFont fontM = PdfFontFactory.createFont(StandardFonts.HELVETICA);

		Paragraph paragraph2 = new Paragraph(
				"StartGerät " + container.getTeilnehmerAnlassLinks().get(0).getStartgeraet()).setFont(fontM);
		document.add(paragraph2);
		addEmptyLine(paragraph2, 1);

		// PdfPTable table = new PdfPTable(5);
		Table table = new Table(UnitValue.createPercentArray(5)).useAllAvailableWidth();
		addTableHeader(table);
		for (TeilnehmerAnlassLink tal : container.getTeilnehmerAnlassLinks()) {
			addRows(table, container, tal);
		}
		document.add(table);
	}

	private static void addTableHeader(Table table) {
		Stream.of("Kat.", "Verein", "Name", "Vorname", "Note").forEach(columnTitle -> {
			Cell header = new Cell();
			// header.setBackgroundColor(BaseColor.LIGHT_GRAY);
			// header.setBorder(1);
			// header.setP
			table.addCell(columnTitle);
		});
	}

	private static void addRows(Table table, LauflistenContainer container, TeilnehmerAnlassLink tal) {
		table.addCell(tal.getKategorie().name());
		table.addCell(tal.getOrganisation().getName());
		table.addCell(tal.getTeilnehmer().getName());
		table.addCell(tal.getTeilnehmer().getVorname());

		Cell cell = new Cell();
		cell.setMinHeight(50);
		cell.setVerticalAlignment(VerticalAlignment.MIDDLE);
		cell.add(new Paragraph(""));
		table.addCell(cell);
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
