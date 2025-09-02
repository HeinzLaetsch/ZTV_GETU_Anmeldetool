package org.ztv.anmeldetool.models;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity()
@Table(name = "EINZELNOTE")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class Einzelnote extends Base {

	@ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
	@JoinColumn(name = "NOTENBLATT_ID", nullable = false, insertable = true, updatable = true)
	private Notenblatt notenblatt;

	// @ManyToOne(fetch = FetchType.LAZY, cascade = { CascadeType.MERGE,
	// CascadeType.PERSIST })
	// @ManyToOne(fetch = FetchType.LAZY)
	// @JoinColumn(name = "LAUFLISTEN_ID", nullable = true, insertable = true,
	// updatable = true)
	@Transient
	private Laufliste laufliste;

	@Enumerated(EnumType.STRING)
	private GeraetEnum geraet;

	private float note_1;
	private float note_2;
	private float zaehlbar;

	private boolean erfasst;

	private boolean checked;

	private int startOrder;
}
