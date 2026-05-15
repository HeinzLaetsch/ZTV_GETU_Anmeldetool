package org.ztv.anmeldetool.exception;

import java.io.Serial;

/**
 * An unchecked exception thrown when an expected entity is not found in the
 * database.
 * Extends RuntimeException to avoid forcing callers to use try-catch blocks.
 */
public class AccessDeniedException extends RuntimeException {
	@Serial
	private static final long serialVersionUID = 1L;

	/**
	 * Constructs a new AccessDeniedException with a formatted message.	 */
	public AccessDeniedException(String msg) {
		super(msg);
	}
}
