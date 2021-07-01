package org.ztv.anmeldetool.anmeldetool.models;

import javax.persistence.Entity;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;

@Entity()
@Table(name = "VERBAND")
@Getter
@Setter
public class Verband extends Base {
	
	private String verband;
	
	private String verbandLong;
}
