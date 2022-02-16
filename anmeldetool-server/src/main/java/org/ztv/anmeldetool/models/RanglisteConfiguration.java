package org.ztv.anmeldetool.models;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity()
@Table(name = "RANGLISTEN_CONFIGURATION")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class RanglisteConfiguration extends Base {

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ANLASS_ID", nullable = false, insertable = true, updatable = true)
	private Anlass anlass;

	private KategorieEnum kategorie;

	private TiTuEnum tiTu;

	private int maxAuszeichnungen;
}
