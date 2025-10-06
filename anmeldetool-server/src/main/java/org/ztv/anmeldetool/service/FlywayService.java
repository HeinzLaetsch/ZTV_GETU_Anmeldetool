package org.ztv.anmeldetool.service;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.List;
import java.util.Optional;

import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.FlywayHistory;
import org.ztv.anmeldetool.repositories.FlywayRepository;

import lombok.extern.slf4j.Slf4j;

@Service("flywayService")
@Slf4j
@Profile("!test")
public class FlywayService {

	private FlywayRepository flywayRepository;

	public FlywayService(FlywayRepository flywayRepository) {
		this.flywayRepository = flywayRepository;
	}

	public List<FlywayHistory> getAll() {
		return this.flywayRepository.findByOrderByInstalledRank();
	}

	public boolean isJavaMigrationNeeded(String version) {
		Optional<FlywayHistory> migrationOpt = this.flywayRepository.findByVersionAndSuccess(version, true);
		if (migrationOpt.isPresent()) {
			LocalDateTime now = LocalDateTime.now(ZoneOffset.UTC).minusMinutes(2);
			return now
					.isBefore(LocalDateTime.ofInstant(migrationOpt.get().getInstalledOn().toInstant(), ZoneOffset.UTC));
		}
		return false;
	}
}
