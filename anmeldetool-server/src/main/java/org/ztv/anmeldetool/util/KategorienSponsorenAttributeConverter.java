package org.ztv.anmeldetool.util;

import java.util.HashMap;
import java.util.Map;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

import org.ztv.anmeldetool.models.KategorienSponsoren;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.java.Log;

@Log
@Converter
public class KategorienSponsorenAttributeConverter implements AttributeConverter<KategorienSponsoren, String> {
	private static final ObjectMapper objectMapper = new ObjectMapper();

	@Override
	public String convertToDatabaseColumn(KategorienSponsoren ks) {
		try {
			return objectMapper.writeValueAsString(ks);
		} catch (JsonProcessingException jpe) {
			log.warning("Cannot convert KategorienSponsoren into JSON");
			return null;
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public KategorienSponsoren convertToEntityAttribute(String value) {
		try {
			if (value == null) {
				return null;
			}
			var tmp = objectMapper.readValue(value, HashMap.class);
			if (tmp == null) {
				return null;
			}
			KategorienSponsoren ks = new KategorienSponsoren();
			ks.setSponsoren((Map<String, String>) tmp.get("sponsoren"));
			return ks;
			// return objectMapper.readValue(value, KategorienSponsoren.class);
		} catch (JsonProcessingException | IllegalArgumentException e) {
			log.warning("Cannot convert JSON into KategorienSponsoren");
			return null;
		}
	}
}
