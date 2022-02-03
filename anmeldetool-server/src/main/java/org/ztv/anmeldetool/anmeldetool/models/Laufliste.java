package org.ztv.anmeldetool.anmeldetool.models;

import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

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

	private boolean erfasst;

	private boolean checked;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "LAUFLISTEN_CONTAINER_ID", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private LauflistenContainer lauflistenContainer;
}
