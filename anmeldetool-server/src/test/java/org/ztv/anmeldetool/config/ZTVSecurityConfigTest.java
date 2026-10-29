package org.ztv.anmeldetool.config;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockFilterChain;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.web.filter.CorsFilter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

class ZTVSecurityConfigTest {

    private final PasswordEncoder passwordEncoder = new ZTVSecurityConfig().passwordEncoder();

    @Test
    void allowsPatchPreflightForClubParticipationFromTheFrontend() throws Exception {
        MockHttpServletRequest request = new MockHttpServletRequest("OPTIONS",
                "/admin/anlaesse/event-id/organisationen/verein-id");
        request.addHeader("Origin", "http://localhost:4200");
        request.addHeader("Access-Control-Request-Method", "PATCH");
        request.addHeader("Access-Control-Request-Headers", "authorization,content-type,vereinsid,x-requested-with");
        MockHttpServletResponse response = new MockHttpServletResponse();

        new CorsFilter(new ZTVSecurityConfig().corsConfigurationSource())
                .doFilter(request, response, new MockFilterChain());

        assertEquals(200, response.getStatus());
        assertEquals("http://localhost:4200", response.getHeader("Access-Control-Allow-Origin"));
        assertEquals("true", response.getHeader("Access-Control-Allow-Credentials"));
        assertTrue(response.getHeader("Access-Control-Allow-Methods").contains("PATCH"));
        assertTrue(response.getHeader("Access-Control-Allow-Headers").contains("authorization"));
    }

    @Test
    void matchesBcryptHashesUsedByThePreviousDelegatingEncoder() {
        String encodedPassword = new BCryptPasswordEncoder().encode("test-password");

        assertTrue(passwordEncoder.matches("test-password", "{bcrypt}" + encodedPassword));
    }

    @Test
    void encodesNewPasswordsWithBcryptPrefix() {
        assertTrue(passwordEncoder.encode("test-password").startsWith("{bcrypt}"));
    }

    @Test
    void rejectsPlaintextLegacyHashes() {
        assertThrows(IllegalArgumentException.class,
                () -> passwordEncoder.matches("test-password", "{noop}test-password"));
    }
}
