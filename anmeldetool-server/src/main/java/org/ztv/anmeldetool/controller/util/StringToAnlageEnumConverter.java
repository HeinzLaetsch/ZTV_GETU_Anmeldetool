package org.ztv.anmeldetool.controller.util;

import org.springframework.core.convert.converter.Converter;
import org.ztv.anmeldetool.models.AnlageEnum;

public class StringToAnlageEnumConverter implements Converter<String, AnlageEnum> {
	@Override
	public AnlageEnum convert(String source) {
		try {
			return AnlageEnum.valueOf(source.toUpperCase());
		} catch (IllegalArgumentException e) {
			return null;
		}
	}
}
