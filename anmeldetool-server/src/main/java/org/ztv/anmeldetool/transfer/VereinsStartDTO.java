package org.ztv.anmeldetool.transfer;

import java.util.List;

import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;

import com.opencsv.bean.CsvBindByName;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class VereinsStartDTO {

	public static final String[] FIELDS_ORDER = { "VEREINSNAME", "K1TI", "K1TU", "K2TI", "K2TU", "K3TI", "K3TU", "K4TI",
			"K4TU", "K5A", "K5B", "K5", "K6TI", "K6TU", "KD", "KH", "K7TI", "K7TU", "TOTAL", "TOTALBR1", "TOTALBR2",
			"BR1", "BR2" };

	@CsvBindByName(column = "VEREINSNAME")
	private String vereinsName;

	@CsvBindByName(column = "BR1")
	private int br1;

	@CsvBindByName(column = "BR2")
	private int br2;

	@CsvBindByName(column = "TOTALBR1")
	private int total_br1;

	@CsvBindByName(column = "TOTALBR2")
	private int total_br2;

	@CsvBindByName(column = "TOTAL")
	private int total;

	@CsvBindByName(column = "K1TI")
	private int k1_Ti;
	private List<TeilnehmerAnlassLink> tals_K1_Ti;

	@CsvBindByName(column = "K1TU")
	private int k1_Tu;
	private List<TeilnehmerAnlassLink> tals_K1_Tu;

	@CsvBindByName(column = "K2TI")
	private int k2_Ti;
	private List<TeilnehmerAnlassLink> tals_K2_Ti;

	@CsvBindByName(column = "K2TU")
	private int k2_Tu;
	private List<TeilnehmerAnlassLink> tals_K2_Tu;

	@CsvBindByName(column = "K3TI")
	private int k3_Ti;
	private List<TeilnehmerAnlassLink> tals_K3_Ti;

	@CsvBindByName(column = "K3TU")
	private int k3_Tu;
	private List<TeilnehmerAnlassLink> tals_K3_Tu;

	@CsvBindByName(column = "K4TI")
	private int k4_Ti;
	private List<TeilnehmerAnlassLink> tals_K4_Ti;

	@CsvBindByName(column = "K4TU")
	private int k4_Tu;
	private List<TeilnehmerAnlassLink> tals_K4_Tu;

	@CsvBindByName(column = "K5")
	private int k5;
	private List<TeilnehmerAnlassLink> tals_K5;

	@CsvBindByName(column = "K5A")
	private int k5A;
	private List<TeilnehmerAnlassLink> tals_K5A;

	@CsvBindByName(column = "K5B")
	private int k5B;
	private List<TeilnehmerAnlassLink> tals_K5B;

	@CsvBindByName(column = "K6TI")
	private int k6_Ti;
	private List<TeilnehmerAnlassLink> tals_K6_Ti;

	@CsvBindByName(column = "K6TU")
	private int k6_Tu;
	private List<TeilnehmerAnlassLink> tals_K6_Tu;

	@CsvBindByName(column = "KH")
	private int kH;
	private List<TeilnehmerAnlassLink> tals_KH;

	@CsvBindByName(column = "KD")
	private int kD;
	private List<TeilnehmerAnlassLink> tals_KD;

	@CsvBindByName(column = "K7TI")
	private int k7_Ti;
	private List<TeilnehmerAnlassLink> tals_K7_Ti;

	@CsvBindByName(column = "K7TU")
	private int k7_Tu;
	private List<TeilnehmerAnlassLink> tals_K7_Tu;
}
