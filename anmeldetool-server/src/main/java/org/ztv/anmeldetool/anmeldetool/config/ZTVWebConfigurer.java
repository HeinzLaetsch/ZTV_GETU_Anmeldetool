package org.ztv.anmeldetool.anmeldetool.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.format.FormatterRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.ztv.anmeldetool.anmeldetool.controller.util.StringToAbteilungEnumConverter;
import org.ztv.anmeldetool.anmeldetool.controller.util.StringToAnlageEnumConverter;

@Configuration
public class ZTVWebConfigurer implements WebMvcConfigurer {
	@Override
	public void addFormatters(FormatterRegistry registry) {
		registry.addConverter(new StringToAbteilungEnumConverter());
		registry.addConverter(new StringToAnlageEnumConverter());
	}
}
