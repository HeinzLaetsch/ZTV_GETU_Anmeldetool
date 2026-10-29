package org.ztv.anmeldetool.models;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;

import java.util.UUID;
import org.junit.jupiter.api.Test;

class LoginDataTest {

    @Test
    void combinedUsernameCanBeParsedBackIntoUsernameAndOrganisationId() {
        UUID organisationId = UUID.randomUUID();
        String combinedUsername = LoginData.getCombinedUsername("turner@example.ch", organisationId);

        assertArrayEquals(
                new String[] { "turner@example.ch", organisationId.toString() },
                LoginData.splitCombinedUsername(combinedUsername));
    }

    @Test
    void usernameWithoutOrganisationDelimiterRemainsUnchanged() {
        assertArrayEquals(new String[] { "turner@example.ch" },
                LoginData.splitCombinedUsername("turner@example.ch"));
    }
}
