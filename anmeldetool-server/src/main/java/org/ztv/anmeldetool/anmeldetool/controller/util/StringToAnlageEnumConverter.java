package org.ztv.anmeldetool.anmeldetool.controller.util;

import org.springframework.core.convert.converter.Converter;
import org.ztv.anmeldetool.anmeldetool.models.AnlageEnum;

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
