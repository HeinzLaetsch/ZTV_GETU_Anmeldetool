package org.ztv.anmeldetool.anmeldetool.models;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import lombok.experimental.SuperBuilder;

@Entity
@Table(name = "WERTUNGSRICHTER_EINSATZ")
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class WertungsrichterEinsatz extends Base {

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PERSON_ANLASS_LINK_ID" + "", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private PersonAnlassLink personAnlassLink;

	@OneToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "WERTUNGSRICHTER_SLOT_ID", referencedColumnName = "ID")
	private WertungsrichterSlot wertungsrichterSlot;

	private boolean eingesetzt;
}
