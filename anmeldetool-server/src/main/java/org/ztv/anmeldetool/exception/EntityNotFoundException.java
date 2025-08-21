package org.ztv.anmeldetool.exception;

import java.util.UUID;

public class EntityNotFoundException extends Exception {
	private static final long serialVersionUID = 1L;

	public EntityNotFoundException(Class<?> clazz, UUID id) {
		super(String.format("Entity of class %s with id %s not found", clazz.getSimpleName(), id.toString()));
	}
}
