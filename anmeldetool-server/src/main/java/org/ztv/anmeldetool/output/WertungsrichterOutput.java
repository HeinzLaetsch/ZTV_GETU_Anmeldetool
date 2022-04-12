package org.ztv.anmeldetool.output;

import java.io.IOException;
import java.io.OutputStream;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.dom4j.DocumentException;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.models.WertungsrichterEinsatz;
import org.ztv.anmeldetool.transfer.AnmeldeKontrolleDTO;

import com.itextpdf.io.font.constants.StandardFonts;
import com.itextpdf.kernel.events.PdfDocumentEvent;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.borders.Border;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.element.Text;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;

// https://github.com/itext/i7js-examples/tree/develop/src/main/java/com/itextpdf/samples/sandbox/events
public class WertungsrichterOutput {

	public static float[] headerWidths = { 20.0f, 20.0f, 10.0f, 10.0f, 40.0f };

	public static void createWertungsrichter(OutputStream out, AnmeldeKontrolleDTO anmeldeKontrolle,
			List<PersonAnlassLink> palBr1, List<PersonAnlassLink> palBr2) throws DocumentException, IOException {
		PdfFont fontN = PdfFontFactory.createFont(StandardFonts.HELVETICA);
		PdfFont fontB = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);

		PdfDocument pdf = new PdfDocument(new PdfWriter(out));
		Document doc = new Document(pdf);
		AnmeldeKontrolleTableHeaderEventHandler headerEventHandler = new AnmeldeKontrolleTableHeaderEventHandler(doc,
				anmeldeKontrolle);
		// Momentan kein Handler für den
		pdf.addEventHandler(PdfDocumentEvent.END_PAGE, headerEventHandler);
		// pdf.addEventHandler(PdfDocumentEvent.END_PAGE, new
		// TextFooterEventHandler(doc));

		// Calculate top margin to be sure that the table will fit the margin.
		float topMargin = 36 + headerEventHandler.getTableHeight();
		doc.setMargins(topMargin, 30, 36, 30);

		// Text text = new Text("Text: ").setFont(fontN).setFontSize(12);
		// doc.add(new Paragraph(text));

		Table table = initTable(fontB, "Gemeldete Wertungsrichter Einsätze Brevet 1");
		fillTable(table, fontN, fontB, palBr1);

		doc.add(table);

		table = initTable(fontB, "Gemeldete Wertungsrichter Einsätze Brevet 2");
		fillTable(table, fontN, fontB, palBr2);

		doc.add(table);

		doc.close();
	}

	private static void fillTable(Table table, PdfFont fontN, PdfFont fontB, List<PersonAnlassLink> palBr)
			throws IOException {
		if (palBr == null || palBr.isEmpty()) {
			return;
		}
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy hh:mm");

		printCell(table, fontB, "Name", true);
		printCell(table, fontB, "Vorname", true);
		printCell(table, fontB, "Start", true);
		printCell(table, fontB, "Ende", true);
		printCell(table, fontB, "Beschreibung", true);
		for (PersonAnlassLink pal : palBr) {
			printCell(table, fontN, pal.getPerson().getName(), true);
			printCell(table, fontN, pal.getPerson().getVorname(), true);
			boolean first = true;
			for (WertungsrichterEinsatz einsatz : pal.getEinsaetze()) {
				if (!einsatz.isEingesetzt()) {
					continue;
				}
				if (!first) {
					printCell(table, fontN, "", true); // Name
					printCell(table, fontN, "", true); // Vorname
				}
				first = false;
				if (null != einsatz.getWertungsrichterSlot().getStart_zeit()) {
					printCell(table, fontN, einsatz.getWertungsrichterSlot().getStart_zeit().format(formatter), true);
				} else {
					printCell(table, fontN, "", true);
				}
				if (null != einsatz.getWertungsrichterSlot().getEnd_zeit()) {
					printCell(table, fontN, einsatz.getWertungsrichterSlot().getEnd_zeit().format(formatter), true);
				} else {
					printCell(table, fontN, "", true);
				}
				printCell(table, fontN, einsatz.getWertungsrichterSlot().getBeschreibung(), true);
			}
			if (null != pal.getKommentar()) {
				printRow(table, fontN, pal.getKommentar());
			} else {
				printRow(table, fontN, "");
			}
		}
	}

	private static Table initTable(PdfFont font, String titel) throws IOException {
		Table table = new Table(UnitValue.createPercentArray(headerWidths)).useAllAvailableWidth();
		Cell cell = new Cell(1, headerWidths.length);
		cell.setBorder(Border.NO_BORDER);
		Text text = new Text(titel).setFont(font).setFontSize(12);
		cell.add(new Paragraph(text).setMultipliedLeading(2.5f));
		cell = cell.setTextAlignment(TextAlignment.LEFT);
		table.addCell(cell);
		return table;
	}

	private static void printRow(Table table, PdfFont font, String value) throws IOException {
		Cell cell = new Cell(1, headerWidths.length);
		cell.setBorder(Border.NO_BORDER);
		Text text = new Text(value).setFont(font).setFontSize(7);
		cell.add(new Paragraph(text).setMultipliedLeading(2.5f));
		cell = cell.setTextAlignment(TextAlignment.LEFT);
		table.addCell(cell);
	}

	private static void printCell(Table table, PdfFont font, String value, boolean leftAlign) throws IOException {
		Cell cell = new Cell();
		// cell.setBorderTop(new SolidBorder(ColorConstants.LIGHT_GRAY, 1.0f));
		// cell.setBorderBottom(new SolidBorder(ColorConstants.LIGHT_GRAY, 1.0f));
		cell.setBorder(Border.NO_BORDER);
		Text text = new Text(value).setFont(font).setFontSize(7);
		cell.add(new Paragraph(text).setMultipliedLeading(1.25f));
		if (leftAlign) {
			cell = cell.setTextAlignment(TextAlignment.LEFT);
		} else {
			cell = cell.setTextAlignment(TextAlignment.RIGHT);
		}
		table.addCell(cell);
	}
}
