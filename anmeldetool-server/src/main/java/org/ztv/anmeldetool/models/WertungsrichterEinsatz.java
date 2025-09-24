package org.ztv.anmeldetool.models;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;

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
	@JoinColumn(name = "PERSON_ANLASS_LINK_ID", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private PersonAnlassLink personAnlassLink;

	@OneToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "WERTUNGSRICHTER_SLOT_ID")
  // , referencedColumnName = "ID"
	private WertungsrichterSlot wertungsrichterSlot;

	private boolean eingesetzt;
}
