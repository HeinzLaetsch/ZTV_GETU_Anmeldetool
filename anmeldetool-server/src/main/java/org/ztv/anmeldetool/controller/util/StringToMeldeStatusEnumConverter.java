package org.ztv.anmeldetool.controller.util;

import org.springframework.core.convert.converter.Converter;
import org.ztv.anmeldetool.models.MeldeStatusEnum;

public class StringToMeldeStatusEnumConverter implements Converter<String, MeldeStatusEnum> {
	@Override
	public MeldeStatusEnum convert(String source) {
		try {
			return MeldeStatusEnum.valueOf(source.toUpperCase());
		} catch (IllegalArgumentException e) {
			return null;
		}
	}
}
