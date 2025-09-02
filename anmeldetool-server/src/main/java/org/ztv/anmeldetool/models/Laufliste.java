package org.ztv.anmeldetool.models;

import java.util.List;

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
import lombok.ToString;

@Entity()
@Table(name = "LAUFLISTE")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class Laufliste extends Base {

	private String key;

	@Enumerated(EnumType.STRING)
	private GeraetEnum geraet;

	private int abloesung;

	private boolean erfasst;

	private boolean checked;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "LAUFLISTEN_CONTAINER_ID", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private LauflistenContainer lauflistenContainer;

	// @OneToMany(fetch = FetchType.LAZY, mappedBy = "laufliste", cascade = {
	// CascadeType.MERGE, CascadeType.PERSIST })
	// @OneToMany(fetch = FetchType.LAZY, mappedBy = "laufliste")
	@ToString.Exclude
	@Transient
	private List<Einzelnote> einzelnoten;
}
