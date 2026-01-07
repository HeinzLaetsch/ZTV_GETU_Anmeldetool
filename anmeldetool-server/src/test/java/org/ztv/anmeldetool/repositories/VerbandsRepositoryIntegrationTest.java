package org.ztv.anmeldetool.repositories;

import static org.assertj.core.api.Assertions.assertThat;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.models.Verband;

@SpringBootTest
@Transactional
@Disabled
class VerbandsRepositoryIntegrationTest extends AbstractRepositoryTest {

    @Autowired
    public VerbandsRepositoryIntegrationTest(VerbandsRepository verbandsRepository) {
        super(verbandsRepository);
    }

    @Test
    @DisplayName("Should find all active Verbaende ordered by name")
    void testFindAllByAktivOrderByVerband() {
        List<Verband> activeVerbaende = verbandsRepository.findAllByAktivOrderByVerband(true);

        assertThat(activeVerbaende).hasSize(7);
        assertThat(activeVerbaende).extracting(Verband::getVerband).containsExactly("AZO", "GLZ", "GRTV", "STV", "UTV", "WTU", "ZTV");
    }

    @Test
    @DisplayName("Should find all inactive Verbaende")
    void testFindAllByAktiv() {
        List<Verband> inactiveVerbaende = verbandsRepository.findAllByAktiv(true);

        assertThat(inactiveVerbaende).hasSize(7);
        assertThat(inactiveVerbaende.get(0).getVerband()).isEqualTo("STV");
    }

    @Test
    @DisplayName("Should find a Verband by its abbreviation")
    void testFindByVerband() {
        Optional<Verband> foundVerbandOpt = verbandsRepository.findByVerband("ZTV");

        assertThat(foundVerbandOpt).isPresent();
        assertThat(foundVerbandOpt.get().getVerbandLong()).isEqualTo("Zürcher Turnverband");
    }

    @Test
    @DisplayName("Should return empty Optional for a non-existent Verband abbreviation")
    void testFindByVerband_NotFound() {
        Optional<Verband> foundVerbandOpt = verbandsRepository.findByVerband("NONEXISTENT");

        assertThat(foundVerbandOpt).isNotPresent();
    }
}
