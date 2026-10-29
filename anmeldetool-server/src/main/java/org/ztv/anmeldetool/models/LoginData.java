package org.ztv.anmeldetool.models;

import java.util.UUID;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LoginData {
	private static final String DELIMITER = "#";
	
	@NotBlank
	private String username;
	@NotBlank
	private String password;
	@NotNull
	private UUID organisationId;
	
	public static String getCombinedUsername(String username, UUID organisationId) {
		return username + LoginData.DELIMITER + organisationId;
	}

	public static String[] splitCombinedUsername(String combinedUsername) {
		int delimiterIndex = combinedUsername.lastIndexOf(DELIMITER);
		if (delimiterIndex < 0) {
			return new String[] { combinedUsername };
		}
		return new String[] {
				combinedUsername.substring(0, delimiterIndex),
				combinedUsername.substring(delimiterIndex + DELIMITER.length())
		};
	}
}
