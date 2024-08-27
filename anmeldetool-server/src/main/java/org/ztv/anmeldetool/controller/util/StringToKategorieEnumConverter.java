package org.ztv.anmeldetool.controller.util;

import org.springframework.core.convert.converter.Converter;
import org.ztv.anmeldetool.models.KategorieEnum;

public class StringToKategorieEnumConverter implements Converter<String, KategorieEnum> {
	@Override
	public KategorieEnum convert(String source) {
		try {
			return KategorieEnum.valueOf(source.toUpperCase());
		} catch (IllegalArgumentException e) {
			return KategorieEnum.KEIN_START;
		}
	}
}
