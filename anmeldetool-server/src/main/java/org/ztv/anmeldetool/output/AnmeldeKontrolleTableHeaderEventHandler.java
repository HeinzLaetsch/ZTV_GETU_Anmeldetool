package org.ztv.anmeldetool.output;

import java.io.IOException;

import org.ztv.anmeldetool.transfer.AnmeldeKontrolleDTO;

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

public class AnmeldeKontrolleTableHeaderEventHandler implements IEventHandler {
	public static float[] headerWidths1 = { 5.0f, 15.0f, 15.0f, 5.0f, 20.0f, 5.0f, 5.0f, 5.0f, 5.0f, 5.0f, 5.0f, 5.0f,
			5.0f };
	public static float[] headerWidths2 = { 3.0f, 21.0f, 4.0f, 19.5f, 4.0f, 3.0f, 4.0f, 3.0f, 4.0f, 3.0f, 4.0f, 4.0f,
			4.0f, 3.0f, 4.0f, 3.0f, 4.5f, 3.0f, 2.0f };

	private Table table;
	private float tableHeight;
	private Document doc;

	public AnmeldeKontrolleTableHeaderEventHandler(Document doc, AnmeldeKontrolleDTO anmeldeKontrolle) throws IOException {
		this.doc = doc;
		initTable(anmeldeKontrolle);

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
		} else {
			cell.add(new Paragraph(text).setMultipliedLeading(1.2f));
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
		table.addCell(cell);
	}

	private static void printSprungCell(Table table, PdfFont fontN, String value) throws IOException {
		Cell cell = new Cell();
		cell = new Cell(1, 4);
		// cell = cell.setHeight(18);
		cell = cell.setVerticalAlignment(VerticalAlignment.BOTTOM);
		Text text = new Text(value).setFont(fontN).setFontSize(7);
		cell.add(new Paragraph(text).setTextAlignment(TextAlignment.CENTER).setMultipliedLeading(1.2f));
		table.addCell(cell);
	}

	private static void printSprungNotenCell(Table table, PdfFont fontN, String value) throws IOException {
		Cell cell = new Cell();
		cell = new Cell(1, 2);
		// cell = cell.setHeight(18);
		cell = cell.setVerticalAlignment(VerticalAlignment.BOTTOM);
		Text text = new Text(value).setFont(fontN).setFontSize(7);
		cell.add(new Paragraph(text).setTextAlignment(TextAlignment.CENTER).setMultipliedLeading(1.2f));
		table.addCell(cell);
	}

	private static void printTitelCell(Table table, PdfFont fontN, String value) throws IOException {
		Cell cell = new Cell();
		cell = new Cell(1, 19);
		// cell = cell.setHeight(18);
		cell = cell.setVerticalAlignment(VerticalAlignment.TOP);
		cell.setBorder(Border.NO_BORDER);
		Text text = new Text(value).setFont(fontN).setFontSize(14);
		cell.add(new Paragraph(text).setTextAlignment(TextAlignment.CENTER).setMultipliedLeading(1.2f));
		table.addCell(cell);
	}

	private void initTable(AnmeldeKontrolleDTO anmeldeKontrolle) throws IOException {
		PdfFont fontN = PdfFontFactory.createFont(StandardFonts.HELVETICA);

		table = new Table(UnitValue.createPercentArray(headerWidths1)).useAllAvailableWidth();
		if (anmeldeKontrolle.getAnlass().getTiTu().isTurner()) {
			table = new Table(UnitValue.createPercentArray(headerWidths2)).useAllAvailableWidth();
		}

		printTitelCell(table, fontN, "Zürcher Kantonaler Frühlingswettkampf Turner in Kloten");

		printCell(table, fontN, "", true);

		printCell(table, fontN, "Name und Vorname", true);

		printCell(table, fontN, "Jg", true);

		printCell(table, fontN, "Verein", true);

		printNotenCell(table, fontN, "Reck");

		printNotenCell(table, fontN, "Boden");

		printNotenCell(table, fontN, "Ring");

		printSprungCell(table, fontN, "Sprung");

		// printNotenCell(table, fontN, "Zählb.");

		if (anmeldeKontrolle.getAnlass().getTiTu().isTurner()) {
			printNotenCell(table, fontN, "Barren");
		}
		printCell(table, fontN, "Total", true);

		printCell(table, fontN, "", true);

		printCell(table, fontN, "", true);

		// 2. Zeile
		printCell(table, fontN, "1", false, true);
		printCell(table, fontN, "2", false, true);
		printSprungNotenCell(table, fontN, "Zählbar");
	}
}