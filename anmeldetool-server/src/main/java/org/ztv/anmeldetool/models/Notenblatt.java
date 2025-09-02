package org.ztv.anmeldetool.models;

import java.util.List;
import java.util.Optional;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity()
@Table(name = "NOTENBLATT")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class Notenblatt extends Base {

	private float gesamtPunktzahl;

	private int rang;

	private boolean auszeichnung;

	@OneToOne(cascade = { CascadeType.PERSIST, CascadeType.MERGE })
	@JoinColumn(name = "teilnehmerAnlassLink_id", referencedColumnName = "id")
	@ToString.Exclude
	private TeilnehmerAnlassLink tal;

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "notenblatt", cascade = { CascadeType.ALL })
	@ToString.Exclude
	private List<Einzelnote> einzelnoten;

	public Einzelnote getEinzelnoteForGeraet(GeraetEnum geraet) {
		if (einzelnoten == null) {
			return new Einzelnote();
		}
		Optional<Einzelnote> einzelnoteOpt = einzelnoten.stream().filter(en -> {
			return en.getGeraet().equals(geraet);
		}).findFirst();
		if (einzelnoteOpt.isPresent()) {
			return einzelnoteOpt.orElse(null);
		}
		return null;
	}
}
