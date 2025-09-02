package org.ztv.anmeldetool.exception;

import java.io.Serial;
import java.util.UUID;

public class EntityNotFoundException extends Exception {
	@Serial
	private static final long serialVersionUID = 1L;

	public EntityNotFoundException(Class<?> clazz, UUID id) {
		super("Entity of class %s with id %s not found".formatted(clazz.getSimpleName(), id.toString()));
	}
}
