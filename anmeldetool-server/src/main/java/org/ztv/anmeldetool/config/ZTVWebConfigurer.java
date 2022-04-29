package org.ztv.anmeldetool.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.format.FormatterRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.ztv.anmeldetool.controller.util.StringToAbteilungEnumConverter;
import org.ztv.anmeldetool.controller.util.StringToAnlageEnumConverter;
import org.ztv.anmeldetool.controller.util.StringToGeraeteEnumConverter;
import org.ztv.anmeldetool.controller.util.StringToMeldeStatusEnumConverter;

@Configuration
public class ZTVWebConfigurer implements WebMvcConfigurer {
	@Override
	public void addFormatters(FormatterRegistry registry) {
		registry.addConverter(new StringToAbteilungEnumConverter());
		registry.addConverter(new StringToAnlageEnumConverter());
		registry.addConverter(new StringToGeraeteEnumConverter());
		registry.addConverter(new StringToMeldeStatusEnumConverter());
	}
}
