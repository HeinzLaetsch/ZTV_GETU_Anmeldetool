package org.ztv.anmeldetool.service;

import java.util.Map;

import jakarta.activation.DataSource;

import org.ztv.anmeldetool.models.Person;

public interface EmailService {

	void sendMessage(Person to, String subject, String mailTemplate, Map<String, Object> templateModel,
			DataSource... dataSourceArray);
}
