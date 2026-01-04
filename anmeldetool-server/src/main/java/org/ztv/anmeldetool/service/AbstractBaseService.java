package org.ztv.anmeldetool.service;

import java.util.UUID;
import lombok.SneakyThrows;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.transaction.annotation.Transactional;
import org.ztv.anmeldetool.exception.NotFoundException;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.Base;

public abstract class AbstractBaseService<T extends Base> {
  public abstract T findById(UUID id);
}
