package org.ztv.anmeldetool;

import java.io.IOException;
import java.util.Properties;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.env.EnvironmentPostProcessor;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.PropertiesPropertySource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;

public class DockerSecretsPasswordProcessor implements EnvironmentPostProcessor {
	@Override
	public void postProcessEnvironment(ConfigurableEnvironment environment, SpringApplication application) {
		System.out.println("Loading Secrets");
		Resource resource = new FileSystemResource("/run/secrets/docker_secrets");
		try {
			if (resource.exists()) {
				System.out.println("Using secrets from injected Docker secret file");
				// String dbPassword = StreamUtils.copyToString(resource.getInputStream(),
				// Charset.defaultCharset());
				Properties properties = new Properties();
				properties.load(resource.getInputStream());
				// props.put("spring.datasource.password", dbPassword);

				environment.getPropertySources().addLast(new PropertiesPropertySource("secrets", properties));
			} else {
				System.err.println("Secrets File %s not found, using default configuration".formatted(
						resource.getURI().toString()));
			}
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}
}
