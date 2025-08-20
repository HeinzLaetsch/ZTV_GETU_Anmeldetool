package org.ztv.anmeldetool.models;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Getter;

@Entity()
@Table(name = "FLYWAY_SCHEMA_HISTORY")
@Getter
public class FlywayHistory {

	@Id
	private Integer installedRank;
	private String version;
	private String description;
	private String type;
	private String script;
	private int checksum;
	private String installedBy;
	private Date installedOn;
	private int executionTime;
	private boolean success;
}
