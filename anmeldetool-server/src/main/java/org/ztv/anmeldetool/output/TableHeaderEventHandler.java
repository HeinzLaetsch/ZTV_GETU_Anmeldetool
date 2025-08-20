package org.ztv.anmeldetool.output;

import java.io.IOException;
import java.time.format.DateTimeFormatter;

import org.ztv.anmeldetool.models.Anlass;

import com.itextpdf.io.font.constants.StandardFonts;
import com.itextpdf.kernel.events.Event;
import com.itextpdf.kernel.events.IEventHandler;
import com.itextpdf.kernel.events.PdfDocumentEvent;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.geom.Rectangle;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfPage;
import com.itextpdf.kernel.pdf.canvas.PdfCanvas;
import com.itextpdf.layout.Canvas;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.borders.Border;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.element.Text;
import com.itextpdf.layout.layout.LayoutArea;
import com.itextpdf.layout.layout.LayoutContext;
import com.itextpdf.layout.layout.LayoutResult;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.itextpdf.layout.properties.VerticalAlignment;
import com.itextpdf.layout.renderer.DocumentRenderer;
import com.itextpdf.layout.renderer.TableRenderer;

public class TableHeaderEventHandler implements IEventHandler {
	public static float[] headerWidths1 = { 3.6f, 19.6f, 4.2f, 19.6f, 4.5f, 3.6f, 4.5f, 3.6f, 4.5f, 3.6f, 4.5f, 4.5f,
			4.5f, 3.6f, 5.0f, 3.6f, 3.0f };
	// 18 Rang, Name und Vorname, Jahrgang, Verein, Reck, Boden RING Sprung Barren
	// Rang, Ausz
	public static float[] headerWidths2 = { 3.0f, 18.55f, 4.05f, 18.55f, 4.25f, 3.0f, 4.25f, 3.0f, 4.25f, 3.0f, 4.25f,
			4.25f, 4.25f, 3.0f, 4.25f, 3.0f, 5.0f, 3.0f, 3.0f };

	private Table table;
	private float tableHeight;
	private Document doc;
	private Anlass anlass;

	public TableHeaderEventHandler(Document doc, Anlass anlass, boolean turner, String kategorie) throws IOException {
		this.doc = doc;
		this.anlass = anlass;
		initTable(turner, kategorie);

		TableRenderer renderer = (TableRenderer) table.createRendererSubTree();
		renderer.setParent(new DocumentRenderer(doc));

		// Simulate the positioning of the renderer to find out how much space the
		// header table will occupy.
		LayoutResult result = renderer.layout(new LayoutContext(new LayoutArea(0, PageSize.A4)));
		tableHeight = result.getOccupiedArea().getBBox().getHeight();
	}

	@Override
	public void handleEvent(Event currentEvent) {
		PdfDocumentEvent docEvent = (PdfDocumentEvent) currentEvent;
		PdfDocument pdfDoc = docEvent.getDocument();
		PdfPage page = docEvent.getPage();
		PdfCanvas canvas = new PdfCanvas(page.newContentStreamBefore(), page.getResources(), pdfDoc);
		PageSize pageSize = pdfDoc.getDefaultPageSize();
		float coordX = pageSize.getX() + doc.getLeftMargin();
		float coordY = pageSize.getTop() - doc.getTopMargin();
		float width = pageSize.getWidth() - doc.getRightMargin() - doc.getLeftMargin();
		float height = getTableHeight();
		Rectangle rect = new Rectangle(coordX, coordY, width, height);

		new Canvas(canvas, rect).add(table).close();
	}

	public float getTableHeight() {
		return tableHeight;
	}

	private static void printCell(Table table, PdfFont fontN, String value, boolean rowspan) throws IOException {
		printCell(table, fontN, value, rowspan, false);
	}

	private static void printCell(Table table, PdfFont fontN, String value, boolean rowspan, boolean centered)
			throws IOException {
		Cell cell = new Cell();
		if (rowspan) {
			cell = new Cell(2, 1);
		}
		cell = cell.setVerticalAlignment(VerticalAlignment.BOTTOM);

		Text text = new Text(value).setFont(fontN).setFontSize(7);
		if (centered) {
			cell.add(new Paragraph(text).setTextAlignment(TextAlignment.CENTER).setMultipliedLeading(1.2f));
			// cell.add(new Paragraph(text).setTextAlignment(TextAlignment.CENTER));
		} else {
			cell.add(new Paragraph(text).setMultipliedLeading(1.2f));
			// cell.add(new Paragraph(text));
		}
		table.addCell(cell);
	}

	private static void printNotenCell(Table table, PdfFont fontN, String value) throws IOException {
		Cell cell = new Cell();
		cell = new Cell(2, 2);
		// cell = cell.setHeight(18);
		cell = cell.setVerticalAlignment(VerticalAlignment.BOTTOM);
		Text text = new Text(value).setFont(fontN).setFontSize(7);
		cell.add(new Paragraph(text).setTextAlignment(TextAlignment.CENTER).setMultipliedLeading(1.2f));
		// cell.add(new Paragraph(text).setTextAlignment(TextAlignment.CENTER));
		table.addCell(cell);
	}

	private static void printSprungCell(Table table, PdfFont fontN, String value) throws IOException {
		Cell cell = new Cell();
		cell = new Cell(1, 4);
		// cell = cell.setHeight(18);
		cell = cell.setVerticalAlignment(VerticalAlignment.BOTTOM);
		Text text = new Text(value).setFont(fontN).setFontSize(7);
		cell.add(new Paragraph(text).setTextAlignment(TextAlignment.CENTER).setMultipliedLeading(1.2f));
		// cell.add(new Paragraph(text).setTextAlignment(TextAlignment.CENTER));
		table.addCell(cell);
	}

	private static void printSprungNotenCell(Table table, PdfFont fontN, String value) throws IOException {
		Cell cell = new Cell();
		cell = new Cell(1, 2);
		// cell = cell.setHeight(18);
		cell = cell.setVerticalAlignment(VerticalAlignment.BOTTOM);
		Text text = new Text(value).setFont(fontN).setFontSize(7);
		cell.add(new Paragraph(text).setTextAlignment(TextAlignment.CENTER).setMultipliedLeading(1.2f));
		// cell.add(new Paragraph(text).setTextAlignment(TextAlignment.CENTER));
		table.addCell(cell);
	}

	private static void printTitelCell(Table table, PdfFont fontN, Anlass anlass, String kategorie, boolean turner)
			throws IOException {
		Cell cell = null;
		int FONTSIZE = 13;
		if (turner) {
			cell = new Cell(2, 15);
		} else {
			cell = new Cell(2, 13);
		}
		// cell = cell.setHeight(18);
		cell = cell.setVerticalAlignment(VerticalAlignment.MIDDLE);
		cell.setBorder(Border.NO_BORDER);
		Text text = new Text(anlass.getAnlassBezeichnung().replace("%", "")).setFont(fontN).setFontSize(FONTSIZE);
		Text textOrt = new Text(" in " + anlass.getOrt()).setFont(fontN).setFontSize(FONTSIZE);
		DateTimeFormatter formatters = DateTimeFormatter.ofPattern("dd.MM");
		DateTimeFormatter formattersYear = DateTimeFormatter.ofPattern("dd.MM.yyyy");

		String start = anlass.getStartDate().format(formatters);
		String end = anlass.getEndDate().format(formattersYear);
		Text textDate = null;
		if (anlass.getStartDate().equals(anlass.getEndDate())) {
			textDate = new Text(", " + start).setFont(fontN).setFontSize(FONTSIZE);
		} else {
			textDate = new Text(", " + start + " bis " + end).setFont(fontN).setFontSize(FONTSIZE);
		}
		cell.add(new Paragraph(text).add(textOrt).add(textDate).setTextAlignment(TextAlignment.CENTER)
				.setMultipliedLeading(1.2f));
		table.addCell(cell);

		cell = new Cell(1, 4);
		// cell = cell.setHeight(18);
		cell = cell.setVerticalAlignment(VerticalAlignment.TOP);
		cell.setBorder(Border.NO_BORDER);
		text = new Text(kategorie).setFont(fontN).setFontSize(FONTSIZE + 1);
		cell.add(new Paragraph(text).setTextAlignment(TextAlignment.RIGHT).setMultipliedLeading(0.0f));
		table.addCell(cell);

		cell = new Cell(1, 4);
		cell = cell.setVerticalAlignment(VerticalAlignment.BOTTOM);
		cell.setBorder(Border.NO_BORDER);
		if (turner) {
			text = new Text("Turner").setFont(fontN).setFontSize(10);
		} else {
			text = new Text("Turnerinnen").setFont(fontN).setFontSize(10);
		}
		cell.add(new Paragraph(text).setTextAlignment(TextAlignment.RIGHT).setMultipliedLeading(0.5f));
		table.addCell(cell);
	}

	private void initTable(boolean turner, String kategorie) throws IOException {
		PdfFont fontN = PdfFontFactory.createFont(StandardFonts.HELVETICA);
		UnitValue[] values = UnitValue.createPercentArray(headerWidths1);
		table = new Table(values).useAllAvailableWidth();
		if (turner) {
			table = new Table(UnitValue.createPercentArray(headerWidths2)).useAllAvailableWidth();
		}

		printTitelCell(table, fontN, anlass, kategorie, turner);

		printCell(table, fontN, "", true);

		printCell(table, fontN, "Name und Vorname", true);

		printCell(table, fontN, "Jg", true, true);

		printCell(table, fontN, "Verein", true);

		printNotenCell(table, fontN, "Reck");

		printNotenCell(table, fontN, "Boden");

		printNotenCell(table, fontN, "Ring");

		printSprungCell(table, fontN, "Sprung");

		// printNotenCell(table, fontN, "Zählb.");

		if (turner) {
			printNotenCell(table, fontN, "Barren");
		}
		printCell(table, fontN, "Total", true);

		printCell(table, fontN, "", true);

		printCell(table, fontN, "", true);

		// 2. Zeile
		printCell(table, fontN, "1", false, true);
		printCell(table, fontN, "2", false, true);
		printSprungNotenCell(table, fontN, "Endnote");
	}
}