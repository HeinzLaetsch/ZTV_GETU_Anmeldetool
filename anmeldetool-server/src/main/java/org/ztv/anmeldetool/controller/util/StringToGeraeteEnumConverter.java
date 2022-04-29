package org.ztv.anmeldetool.controller.util;

import org.springframework.core.convert.converter.Converter;
import org.ztv.anmeldetool.models.GeraetEnum;

public class StringToGeraeteEnumConverter implements Converter<String, GeraetEnum> {
	@Override
	public GeraetEnum convert(String source) {
		try {
			return GeraetEnum.valueOf(source.toUpperCase());
		} catch (IllegalArgumentException e) {
			return null;
		}
	}
}
