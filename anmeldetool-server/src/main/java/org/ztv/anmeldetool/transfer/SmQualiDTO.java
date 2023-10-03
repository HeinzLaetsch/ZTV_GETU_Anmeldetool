package org.ztv.anmeldetool.transfer;

import java.math.BigDecimal;
import java.util.UUID;

import com.opencsv.bean.CsvBindByName;

import lombok.Data;

@Data
public class SmQualiDTO {
	public static final String[] FIELDS_ORDER = { "TEILNEHMERID", "NAME", "VORNAME", "JAHRGANG", "ORGANISATION",
			"ORGANISATIONID", "DURCHSCHNITTLICHEPUNKTZAHL", "WETTKAMPF1PUNKTZAHL", "WETTKAMPF2PUNKTZAHL",
			"WETTKAMPF3PUNKTZAHL", "KMSPUNKTZAHL", "FINALPUNKTZAHL", "AUSSERKANTONAL1PUNKTZAHL",
			"AUSSERKANTONAL2PUNKTZAHL", "RECKDURCHSCHNITT", "BODENDURCHSCHNITT", "SCHAUKELRINGEDURCHSCHNITT",
			"SPRUNGDURCHSCHNITT", "BARRENDURCHSCHNITT" };
	@CsvBindByName(column = "TeilnehmerId")
	private UUID teilnehmerId;
	@CsvBindByName(column = "Name")
	private String name;
	@CsvBindByName(column = "Vorname")
	private String vorname;
	@CsvBindByName(column = "Jahrgang")
	private int jahrgang;
	@CsvBindByName(column = "Organisation")
	private String organisation;
	@CsvBindByName(column = "OrganisationId")
	private UUID organisationId;
	@CsvBindByName(column = "DurchschnittlichePunktzahl")
	private BigDecimal durchschnittlichePunktzahl;

	@CsvBindByName(column = "Wettkampf1Punktzahl") // Frueh
	private BigDecimal wettkampf1Punktzahl;

	@CsvBindByName(column = "Wettkampf2Punktzahl") // K5+
	private BigDecimal wettkampf2Punktzahl;

	@CsvBindByName(column = "Wettkampf3Punktzahl") // tinnentage
	private BigDecimal wettkampf3Punktzahl;

	@CsvBindByName(column = "KMSPunktzahl") // KMS
	private BigDecimal kmsPunktzahl;

	@CsvBindByName(column = "FinalPunktzahl") // Final
	private BigDecimal finalPunktzahl;

	@CsvBindByName(column = "AusserKantonal1Punktzahl") // A1
	private BigDecimal ausserKantonal1Punktzahl;

	@CsvBindByName(column = "AusserKantonal2Punktzahl") // A1
	private BigDecimal ausserKantonal2Punktzahl;

	@CsvBindByName(column = "ReckDurchschnitt") // A2
	private BigDecimal reckDurchschnitt;

	@CsvBindByName(column = "BodenkDurchschnitt") // A2
	private BigDecimal bodenDurchschnitt;

	@CsvBindByName(column = "SchaukelringeDurchschnitt") // A2
	private BigDecimal schaukelringeDurchschnitt;

	@CsvBindByName(column = "SprungDurchschnitt") // A2
	private BigDecimal sprungDurchschnitt;

	@CsvBindByName(column = "BarrenDurchschnitt") // A2
	private BigDecimal barrenDurchschnitt;
}
