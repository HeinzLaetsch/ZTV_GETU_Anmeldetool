package org.ztv.anmeldetool.anmeldetool.models;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;

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

	@OneToOne(cascade = { CascadeType.PERSIST, CascadeType.MERGE })
	@JoinColumn(name = "teilnehmerAnlassLink_id", referencedColumnName = "id")
	@ToString.Exclude
	private TeilnehmerAnlassLink tal;

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "notenblatt", cascade = { CascadeType.ALL })
	@ToString.Exclude
	private List<Einzelnote> einzelnoten;

	public Einzelnote getEinzelnoteForGeraet(GeraetEnum geraet) {
		Einzelnote einzelnote = einzelnoten.stream().filter(en -> {
			return en.getGeraet().equals(geraet);
		}).findFirst().get();
		return einzelnote;
	}
}
