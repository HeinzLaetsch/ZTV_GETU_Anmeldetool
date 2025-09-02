package org.ztv.anmeldetool.models;

import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity()
@Table(name = "organisation_anlass_link")
@Getter
@Setter
public class OrganisationAnlassLink extends Base {

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ORGANISATION_ID", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private Organisation organisation;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ANLASS_ID", nullable = false, insertable = true, updatable = true)
	@ToString.Exclude
	private Anlass anlass;

	private LocalDateTime verlaengerungsDate;

	private boolean reminderMeldeschlussSent;
	private boolean anmeldeKontrolleSent;
	private boolean reminderMutationsschlussSent;
}