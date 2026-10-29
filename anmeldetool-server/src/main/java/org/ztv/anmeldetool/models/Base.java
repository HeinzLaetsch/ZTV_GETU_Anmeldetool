package org.ztv.anmeldetool.models;

import java.time.LocalDate;
import java.util.UUID;

import jakarta.persistence.Id;
import jakarta.persistence.MappedSuperclass;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.springframework.data.domain.Persistable;

@MappedSuperclass
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public abstract class Base implements Persistable<UUID> {
	@Id
	@Builder.Default
	private UUID id = UUID.randomUUID();
	@Builder.Default
	private boolean aktiv = false;
	@Builder.Default
	private boolean deleted = false;
	@Builder.Default
	private LocalDate changeDate = LocalDate.now();
	@Builder.Default
	private LocalDate deletionDate = null;

	public Base(UUID id) {
		this.id = id;
	}

	public Base(Boolean aktiv) {
		this.id = UUID.randomUUID();
		this.aktiv = aktiv;
	}

	public Base(Boolean aktiv, LocalDate changeDate) {
		this.aktiv = aktiv;
		this.changeDate = changeDate;
	}

	@Override
	public boolean isNew() {
		if (id == null) {
			return true;
		}
		return false;
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
