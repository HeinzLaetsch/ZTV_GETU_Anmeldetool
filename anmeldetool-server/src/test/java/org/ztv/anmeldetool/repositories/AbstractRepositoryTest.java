package org.ztv.anmeldetool.repositories;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.VerbandEnum;

public class AbstractRepositoryTest {

  protected static final ObjectMapper objectMapper = new ObjectMapper().registerModule(new JavaTimeModule());;

  protected final VerbandsRepository verbandsRepository;

  public AbstractRepositoryTest(VerbandsRepository verbandsRepository) {
    this.verbandsRepository = verbandsRepository;
  }

  public Organisation buildDefaultOrganisation(String name, VerbandEnum verbandAbkz) {
    Organisation org = Organisation.builder().name(name)
        .verband(verbandsRepository.findByVerband(verbandAbkz.name()).orElseThrow()).build();
    return org;
  }
}
