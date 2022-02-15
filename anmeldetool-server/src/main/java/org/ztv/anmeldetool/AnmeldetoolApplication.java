package org.ztv.anmeldetool;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class AnmeldetoolApplication {

	public static void main(String[] args) {
		SpringApplication.run(AnmeldetoolApplication.class, args);
	}

	/*
	 * @Bean public Jackson2ObjectMapperBuilderCustomizer init() { return new
	 * Jackson2ObjectMapperBuilderCustomizer() {
	 * 
	 * @Override public void customize(Jackson2ObjectMapperBuilder builder) {
	 * builder.timeZone(TimeZone.getTimeZone("Europe/London")); } }; }
	 */

}
