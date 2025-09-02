package org.ztv.anmeldetool.models;

import java.util.Calendar;
import java.util.UUID;

import jakarta.persistence.Id;
import jakarta.persistence.MappedSuperclass;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;

@MappedSuperclass
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public abstract class Base {
	@Id
	@Builder.Default
	private UUID id = UUID.randomUUID();
	@Builder.Default
	private boolean aktiv = false;
	@Builder.Default
	private boolean deleted = false;
	@Builder.Default
	@Temporal(TemporalType.DATE)
	private Calendar changeDate = Calendar.getInstance();
	@Builder.Default
	@Temporal(TemporalType.DATE)
	private Calendar deletionDate = null;

	public Base(UUID id) {
		this.id = id;
	}

	public Base(Boolean aktiv) {
		this.id = UUID.randomUUID();
		this.aktiv = aktiv;
	}

	public Base(Boolean aktiv, Calendar changeDate) {
		this.aktiv = aktiv;
		this.changeDate = changeDate;
	}

	@Override
	public int hashCode() {
		if (id != null) {
			return id.hashCode();
		}
		return super.hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		if (obj == null) {
			return false;
		}
		Base other = (Base) obj;
		if (id != null) {
			if (other.id != null)
				return id == other.id;
		}
		return true;
	}
}
