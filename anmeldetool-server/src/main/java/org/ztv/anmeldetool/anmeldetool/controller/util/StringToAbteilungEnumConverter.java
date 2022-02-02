package org.ztv.anmeldetool.anmeldetool.controller.util;

import org.springframework.core.convert.converter.Converter;
import org.ztv.anmeldetool.anmeldetool.models.AbteilungEnum;

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
