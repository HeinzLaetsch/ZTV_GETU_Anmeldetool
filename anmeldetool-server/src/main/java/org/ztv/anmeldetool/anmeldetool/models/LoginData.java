package org.ztv.anmeldetool.anmeldetool.models;

import java.util.UUID;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LoginData {
	private static final String DELIMITER = "#";
	
	private String username;
	private String password;
	private UUID organisationId;	
	
	public static String getCombinedUsername(String username, UUID organisationId) {
		return username + LoginData.DELIMITER + organisationId;
	}

	public static String[] splitCombinedUsername(String combinedUsername) {
		return combinedUsername.split(LoginData.DELIMITER);
	}
}
