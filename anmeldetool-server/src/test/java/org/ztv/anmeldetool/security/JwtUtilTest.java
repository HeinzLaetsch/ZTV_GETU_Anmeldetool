package org.ztv.anmeldetool.security;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import io.jsonwebtoken.JwtException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.test.util.ReflectionTestUtils;

class JwtUtilTest {

    private final JwtUtil jwtUtil = new JwtUtil();

    @BeforeEach
    void configureSigningKey() {
        ReflectionTestUtils.setField(jwtUtil, "secret", "MDEyMzQ1Njc4OWFiY2RlZjAxMjM0NTY3ODlhYmNkZWY=");
        ReflectionTestUtils.setField(jwtUtil, "expiration", 60_000L);
    }

    @Test
    void generatedTokenPreservesIdentityAndRejectsTampering() {
        UserDetails userDetails = userDetails("testuser#organisation-id");
        String token = jwtUtil.generateToken(userDetails);

        assertEquals(userDetails.getUsername(), jwtUtil.extractUsername(token));
        assertTrue(jwtUtil.validateToken(token, userDetails));
        assertFalse(jwtUtil.validateToken(token, userDetails("another-user#organisation-id")));
        assertThrows(JwtException.class, () -> jwtUtil.extractUsername(token + "tampered"));
    }

    @Test
    void expiredTokenIsNotValid() {
        ReflectionTestUtils.setField(jwtUtil, "expiration", -1_000L);
        UserDetails userDetails = userDetails("testuser#organisation-id");

        assertFalse(jwtUtil.validateToken(jwtUtil.generateToken(userDetails), userDetails));
    }

    private UserDetails userDetails(String username) {
        return User.withUsername(username)
                .password("password")
                .authorities("BENUTZER")
                .build();
    }
}
