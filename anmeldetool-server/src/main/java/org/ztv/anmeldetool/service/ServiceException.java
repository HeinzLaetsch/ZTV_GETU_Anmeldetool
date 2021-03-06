package org.ztv.anmeldetool.service;

public class ServiceException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@SuppressWarnings("rawtypes")
	private final Class service;

	@SuppressWarnings("rawtypes")
	public ServiceException(Class service, String message) {
		super(message);
		this.service = service;
	}

	public String getMessage() {
		StringBuilder sb = new StringBuilder("Exception in Service: ");
		sb.append(this.service.getSimpleName()).append(" , Message: ");
		sb.append(super.getMessage());
		return sb.toString();
	}
}
