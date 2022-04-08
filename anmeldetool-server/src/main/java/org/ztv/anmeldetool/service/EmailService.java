package org.ztv.anmeldetool.service;

import java.util.Map;

import javax.activation.DataSource;

import org.ztv.anmeldetool.models.Person;

public interface EmailService {

	public void sendMessage(Person to, String subject, String mailTemplate, Map<String, Object> templateModel,
			DataSource... dataSourceArray);
}
