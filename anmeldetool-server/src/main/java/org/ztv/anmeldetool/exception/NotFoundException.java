package org.ztv.anmeldetool.exception;

import java.io.Serial;

/**
 * An unchecked exception thrown when an expected entity is not found in the
 * database.
 * Extends RuntimeException to avoid forcing callers to use try-catch blocks.
 */
public class NotFoundException extends RuntimeException {
	@Serial
	private static final long serialVersionUID = 1L;

	/**
	 * Constructs a new EntityNotFoundException with a formatted message.
	 * @param clazz The class of the entity that was not found.
	 * @param id The identifier (e.g., UUID or String) of the entity.
	 */
	public NotFoundException(Class<?> clazz, Object id) {
		super("Entity of class %s with id %s not found".formatted(clazz.getSimpleName(), id.toString()));
	}
}
