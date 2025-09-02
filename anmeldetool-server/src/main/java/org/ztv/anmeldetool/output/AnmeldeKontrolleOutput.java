package org.ztv.anmeldetool.output;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.transfer.AnmeldeKontrolleDTO;
import org.ztv.anmeldetool.transfer.VereinsStartDTO;

import com.itextpdf.io.font.constants.StandardFonts;
import com.itextpdf.kernel.events.Event;
import com.itextpdf.kernel.events.IEventHandler;
import com.itextpdf.kernel.events.PdfDocumentEvent;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.geom.Rectangle;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Canvas;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.borders.Border;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.element.Text;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.itextpdf.layout.properties.VerticalAlignment;

// https://github.com/itext/i7js-examples/tree/develop/src/main/java/com/itextpdf/samples/sandbox/events
public class AnmeldeKontrolleOutput {

	public static float[] headerWidths = { 5.0f, 20.0f, 20.0f, 5.0f, 10.0f, 10.0f, 20.0f, 10.0f };

	public static void createAnmeldeKontrolle(OutputStream out, AnmeldeKontrolleDTO anmeldeKontrolle)
			throws IOException {
		PdfFont fontN = PdfFontFactory.createFont(StandardFonts.HELVETICA);
		PdfFont fontB = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);

		PdfDocument pdf = new PdfDocument(new PdfWriter(out));
		Document doc = new Document(pdf);
		AnmeldeKontrolleTableHeaderEventHandler headerEventHandler = new AnmeldeKontrolleTableHeaderEventHandler(doc,
				anmeldeKontrolle);
		// Momentan kein Handler für den
		pdf.addEventHandler(PdfDocumentEvent.END_PAGE, headerEventHandler);
		pdf.addEventHandler(PdfDocumentEvent.END_PAGE, new TextFooterEventHandler(doc));

		// Calculate top margin to be sure that the table will fit the margin.
		float topMargin = 36 + headerEventHandler.getTableHeight();
		doc.setMargins(topMargin, 30, 36, 30);

		// Text text = new Text("Text: ").setFont(fontN).setFontSize(12);
		// doc.add(new Paragraph(text));

		if (anmeldeKontrolle.getVereinsStart() != null && anmeldeKontrolle.getVereinsStart().size() > 0) {
			VereinsStartDTO dto = anmeldeKontrolle.getVereinsStart().getFirst();

			Table table = initTable(fontB);
			fillTable(table, fontN, fontB, KategorieEnum.K1, TiTuEnum.Ti, dto.getTals_K1_Ti());
			fillTable(table, fontN, fontB, KategorieEnum.K1, TiTuEnum.Tu, dto.getTals_K1_Tu());
			fillTable(table, fontN, fontB, KategorieEnum.K2, TiTuEnum.Ti, dto.getTals_K2_Ti());
			fillTable(table, fontN, fontB, KategorieEnum.K2, TiTuEnum.Tu, dto.getTals_K2_Tu());
			fillTable(table, fontN, fontB, KategorieEnum.K3, TiTuEnum.Ti, dto.getTals_K3_Ti());
			fillTable(table, fontN, fontB, KategorieEnum.K3, TiTuEnum.Tu, dto.getTals_K3_Tu());
			fillTable(table, fontN, fontB, KategorieEnum.K4, TiTuEnum.Ti, dto.getTals_K4_Ti());
			fillTable(table, fontN, fontB, KategorieEnum.K4, TiTuEnum.Tu, dto.getTals_K4_Tu());
			fillTable(table, fontN, fontB, KategorieEnum.K5B, TiTuEnum.Ti, dto.getTals_K5B());
			fillTable(table, fontN, fontB, KategorieEnum.K5A, TiTuEnum.Ti, dto.getTals_K5A());
			fillTable(table, fontN, fontB, KategorieEnum.K5, TiTuEnum.Tu, dto.getTals_K5());
			fillTable(table, fontN, fontB, KategorieEnum.K6, TiTuEnum.Ti, dto.getTals_K6_Ti());
			fillTable(table, fontN, fontB, KategorieEnum.K6, TiTuEnum.Tu, dto.getTals_K6_Tu());
			fillTable(table, fontN, fontB, KategorieEnum.KD, TiTuEnum.Ti, dto.getTals_KD());
			fillTable(table, fontN, fontB, KategorieEnum.KH, TiTuEnum.Tu, dto.getTals_KH());
			fillTable(table, fontN, fontB, KategorieEnum.K7, TiTuEnum.Ti, dto.getTals_K7_Ti());
			fillTable(table, fontN, fontB, KategorieEnum.K7, TiTuEnum.Tu, dto.getTals_K7_Tu());

			doc.add(table);
		}

		doc.close();
	}

	private static void fillTable(Table table, PdfFont fontN, PdfFont fontB, KategorieEnum kategorie, TiTuEnum titu,
			List<TeilnehmerAnlassLink> tals) throws IOException {
		if (tals == null || tals.isEmpty()) {
			return;
		}
		printTitelCell(table, fontB, "Kategorie ", kategorie, titu);
		printCell(table, fontB, "Startnr.", true);
		printCell(table, fontB, "Name", true);
		printCell(table, fontB, "Vorname", true);
		printCell(table, fontB, "Jahrgang", true);
		printCell(table, fontB, "Abteilung", true);
		printCell(table, fontB, "Anlage", true);
		printCell(table, fontB, "Startgerät (provisorisch)", true);
		printCell(table, fontB, "Status", true);
		for (TeilnehmerAnlassLink tal : tals) {
			try {
				if (tal.getStartnummer() != null) {
					printCell(table, fontN, tal.getStartnummer().toString(), true);
				} else {
					printCell(table, fontN, "", true);
				}
				printCell(table, fontN, tal.getTeilnehmer().getName(), true);
				printCell(table, fontN, tal.getTeilnehmer().getVorname(), true);
				printCell(table, fontN, "%d".formatted(tal.getTeilnehmer().getJahrgang()), true);
				if (tal.getAbteilung() != null && tal.getAnlass().isAbteilungFix()) {
					printCell(table, fontN, "%d".formatted(tal.getAbteilung().ordinal() + 1), true);
				} else {
					printCell(table, fontN, "", true);
				}
				if (tal.getAnlage() != null && tal.getAnlass().isAnlageFix()) {
					printCell(table, fontN, "%d".formatted(tal.getAnlage().ordinal() + 1), true);
				} else {
					printCell(table, fontN, "", true);
				}
				if (tal.getStartgeraet() != null && tal.getAnlass().isStartgeraetFix()) {
					printCell(table, fontN, tal.getStartgeraet().name(), true);
				} else {
					printCell(table, fontN, "", true);
				}
				if (tal.getMeldeStatus() != null) {
					printCell(table, fontN, tal.getMeldeStatus().text, true);
				} else {
					printCell(table, fontN, MeldeStatusEnum.STARTET.name(), true);
				}
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
	}

	private static Table initTable(PdfFont font) throws IOException {
		Table table = new Table(UnitValue.createPercentArray(headerWidths)).useAllAvailableWidth();
		return table;
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

	private static void printTitelCell(Table table, PdfFont font, String value, KategorieEnum kategorie, TiTuEnum titu)
			throws IOException {
		Cell cell = new Cell();
		cell = new Cell(1, 3);
		cell = cell.setVerticalAlignment(VerticalAlignment.BOTTOM);
		cell.setBorder(Border.NO_BORDER);
		Text text = new Text(value).setFont(font).setFontSize(12);
		// cell.add(new
		// Paragraph(text).setTextAlignment(TextAlignment.CENTER).setMultipliedLeading(1.2f));
		cell.add(new Paragraph(text).setMultipliedLeading(2.2f));
		table.addCell(cell);

		cell = new Cell(1, 2);
		cell = cell.setVerticalAlignment(VerticalAlignment.BOTTOM);
		cell.setBorder(Border.NO_BORDER);
		text = new Text(kategorie.name()).setFont(font).setFontSize(12);
		// cell.add(new
		// Paragraph(text).setTextAlignment(TextAlignment.CENTER).setMultipliedLeading(1.2f));
		cell.add(new Paragraph(text).setMultipliedLeading(2.2f));
		table.addCell(cell);

		cell = new Cell(1, 3);
		cell = cell.setVerticalAlignment(VerticalAlignment.BOTTOM);
		cell.setBorder(Border.NO_BORDER);
		text = new Text(titu.name()).setFont(font).setFontSize(12);
		// cell.add(new
		// Paragraph(text).setTextAlignment(TextAlignment.CENTER).setMultipliedLeading(1.2f));
		cell.add(new Paragraph(text).setMultipliedLeading(2.2f));
		table.addCell(cell);
	}

	private static class TextFooterEventHandler implements IEventHandler {
		private Table table;
		private float tableHeight;
		private Document doc;

		public TextFooterEventHandler(Document doc) {
			this.doc = doc;
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

			float coordX = ((pageSize.getLeft() + doc.getLeftMargin()) + (pageSize.getRight() - doc.getRightMargin()))
					/ 2;
			float headerY = pageSize.getTop() - doc.getTopMargin() + 10;
			float footerY = doc.getBottomMargin();

			Canvas canvas = new Canvas(docEvent.getPage(), pageSize);
			canvas
					// If the exception has been thrown, the font variable is not initialized.
					// Therefore null will be set and iText will use the default font - Helvetica
					.setFont(font).setFontSize(5)
					// .showTextAligned("this is a header", coordX, headerY, TextAlignment.CENTER)
					.showTextAligned("Anlage und Startgerät sind provisorisch und können bis zum Wettkampf ändern",
							coordX, footerY, TextAlignment.CENTER)
					.close();
		}

		public float getTableHeight() {
			return tableHeight;
		}

		private void ceateTableHeader() {
			float[] headerWidths = { 10.0f, 30.0f, 60.0f };
			Table headerTable = new Table(UnitValue.createPercentArray(headerWidths)).useAllAvailableWidth();

		}
	}
}
