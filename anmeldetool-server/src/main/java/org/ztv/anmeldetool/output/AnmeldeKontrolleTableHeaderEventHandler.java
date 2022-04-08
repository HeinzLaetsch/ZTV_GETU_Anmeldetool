package org.ztv.anmeldetool.output;

import java.io.IOException;
import java.time.format.DateTimeFormatter;

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
	public static float[] headerWidths = { 14.0f, 14.0f, 14.0f, 14.0f, 14.0f, 30.0f };

	private Table table;
	private float tableHeight;
	private Document doc;

	public AnmeldeKontrolleTableHeaderEventHandler(Document doc, AnmeldeKontrolleDTO anmeldeKontrolle)
			throws IOException {
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

	private static void printTitelCell(Table table, PdfFont fontN, String value) throws IOException {
		Cell cell = new Cell();
		cell = new Cell(1, headerWidths.length);
		// cell = cell.setHeight(18);
		cell = cell.setVerticalAlignment(VerticalAlignment.TOP);
		cell.setBorder(Border.NO_BORDER);
		Text text = new Text(value).setFont(fontN).setFontSize(14);
		cell.add(new Paragraph(text).setTextAlignment(TextAlignment.CENTER).setMultipliedLeading(1.2f));
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

	private void initTable(AnmeldeKontrolleDTO anmeldeKontrolle) throws IOException {
		PdfFont fontN = PdfFontFactory.createFont(StandardFonts.HELVETICA);
		PdfFont fontB = PdfFontFactory.createFont(StandardFonts.HELVETICA_BOLD);

		table = new Table(UnitValue.createPercentArray(headerWidths)).useAllAvailableWidth();

		printTitelCell(table, fontN, "Anmeldung");

		printTitelCell(table, fontN, anmeldeKontrolle.getDetailAnlassName());

		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");

		printCell(table, fontN, "von:", false);
		printCell(table, fontB, anmeldeKontrolle.getAnlass().getStartDatum().format(formatter), true);

		printCell(table, fontN, "bis:", false);
		printCell(table, fontB, anmeldeKontrolle.getAnlass().getEndDatum().format(formatter), true);

		printCell(table, fontN, "", false);
		printCell(table, fontN, "", false);

		printCell(table, fontN, "Geschlecht:", false);
		printCell(table, fontB, anmeldeKontrolle.getAnlass().getTiTu().name(), true);

		printCell(table, fontN, "", false);
		printCell(table, fontN, "", false);
		printCell(table, fontN, "", false);
		printCell(table, fontN, "", false);

		printCell(table, fontN, "Startberechtigt:", false);
		printCell(table, fontB, anmeldeKontrolle.getAnlass().getTiefsteKategorie().name(), true);

		printCell(table, fontN, "bis:", false);
		printCell(table, fontB, anmeldeKontrolle.getAnlass().getHoechsteKategorie().name(), true);

		printCell(table, fontN, "", false);
		printCell(table, fontN, "", false);

		printCell(table, fontN, "Ort:", false);
		printCell(table, fontB, anmeldeKontrolle.getAnlass().getOrt(), true);

		printCell(table, fontN, "Halle:", false);
		printCell(table, fontB, anmeldeKontrolle.getAnlass().getHalle(), true);

		printCell(table, fontN, "Organisator:", false);
		printCell(table, fontB, anmeldeKontrolle.getOrganisator().getName(), true);
	}
}