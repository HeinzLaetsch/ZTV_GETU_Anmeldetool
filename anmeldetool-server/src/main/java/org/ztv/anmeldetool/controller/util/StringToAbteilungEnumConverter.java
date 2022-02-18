package org.ztv.anmeldetool.controller.util;

import org.springframework.core.convert.converter.Converter;
import org.ztv.anmeldetool.models.AbteilungEnum;

public class StringToAbteilungEnumConverter implements Converter<String, AbteilungEnum> {
	@Override
	public AbteilungEnum convert(String source) {
		try {
			return AbteilungEnum.valueOf(source.toUpperCase());
		} catch (IllegalArgumentException e) {
			return null;
		}
	}
}
