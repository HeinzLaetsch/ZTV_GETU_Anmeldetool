package org.ztv.anmeldetool.controller;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.SmQualiAnlassTeilnahmen;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.output.SmQualiOutput;
import org.ztv.anmeldetool.service.ServiceException;
import org.ztv.anmeldetool.service.SmQualiService;
import org.ztv.anmeldetool.transfer.SmQualiDTO;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/smquali")
@Slf4j
//@CrossOrigin(origins = "*", allowedHeaders = "*", allowCredentials = "true")
public class SmQualiController {
	@Autowired
	SmQualiService smQualiService;

	// , produces = "application/pdf"
	@GetMapping(value = "/{jahr}/{tiTu}/{kategorie}", produces = "application/json")
	public ResponseEntity<List<SmQualiDTO>> getSmAuswertungJSON(HttpServletRequest request,
			HttpServletResponse response, @PathVariable Integer jahr, @PathVariable TiTuEnum tiTu,
			@PathVariable KategorieEnum kategorie, @RequestParam Optional<Boolean> onlyQualiOpt) {
		try {
			List<SmQualiDTO> smqDtoList = mapDTO(jahr, tiTu, kategorie, onlyQualiOpt.orElse(Boolean.TRUE));

			return ResponseEntity.ok(smqDtoList);
		} catch (ServiceException ex) {
			log.error("Unable to query SMQuali: ", ex);
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to query RanglistenConfig: ",
					ex);
		}
	}

	@GetMapping(value = "/{jahr}/{tiTu}/{kategorie}", produces = "text/csv;charset=UTF-8")
	public void getSmAuswertungCSV(HttpServletRequest request, HttpServletResponse response, @PathVariable Integer jahr,
			@PathVariable TiTuEnum tiTu, @PathVariable KategorieEnum kategorie,
			@RequestParam Optional<Boolean> onlyQualiOpt) {
		try {
			List<SmQualiDTO> smqDtoList = mapDTO(jahr, tiTu, kategorie, onlyQualiOpt.orElse(Boolean.TRUE));

			String reportName = "SM_QUALI_" + jahr + "_" + kategorie.name() + "_" + tiTu.name();

			response.addHeader("Content-Disposition", "attachment; filename=" + reportName + ".csv");
			response.addHeader("Content-Type", "text/csv;charset=UTF-8");
			response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);

			SmQualiOutput.csvWriteToWriter(response, smqDtoList);
		} catch (Exception ex) {
			log.error("Unable to query SMQuali: ", ex);
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to query RanglistenConfig: ",
					ex);
		}
	}

	private List<SmQualiDTO> mapDTO(Integer jahr, TiTuEnum tiTu, KategorieEnum kategorie, Boolean onlyQuali)
			throws ServiceException {
		List<SmQualiAnlassTeilnahmen> anlassTeilnahmen = smQualiService.getAnlassTeilnahmen(jahr, onlyQuali, tiTu,
				kategorie);
		List<SmQualiDTO> smqDtoList = anlassTeilnahmen.stream().map(smq -> {
			SmQualiDTO smqDto = new SmQualiDTO();
			// smqDto.setDurchschnittlicheEinzelnoten(smq.getDurchschnittlicheEinzelnoten());
			smqDto.setDurchschnittlichePunktzahl(smq.getDurchschnittlichePunktzahl());
			smqDto.setTeilnehmerId(smq.getTeilnehmer().getId());
			smqDto.setName(smq.getTeilnehmer().getName());
			smqDto.setVorname(smq.getTeilnehmer().getVorname());
			smqDto.setJahrgang(smq.getTeilnehmer().getJahrgang());
			smqDto.setOrganisation(smq.getTeilnehmer().getOrganisation().getName());
			smqDto.setOrganisationId(smq.getTeilnehmer().getOrganisation().getId());
			/*
			 * smqDto.setWettkampf1Punktzahl(smq.getWettkampf1Punktzahl());
			 * smqDto.setWettkampf2Punktzahl(smq.getWettkampf2Punktzahl());
			 * smqDto.setWettkampf3Punktzahl(smq.getWettkampf3Punktzahl());
			 * smqDto.setKmsPunktzahl(smq.getKmsPunktzahl());
			 * smqDto.setFinalPunktzahl(smq.getFinalPunktzahl());
			 * smqDto.setAusserKantonal1Punktzahl(smq.getAusserKantonal1Punktzahl());
			 * smqDto.setAusserKantonal2Punktzahl(smq.getAusserKantonal2Punktzahl());
			 * smqDto.setReckDurchschnitt(smq.getDurchschnittlicheEinzelnoten().get(
			 * GeraetEnum.RECK));
			 * smqDto.setBodenDurchschnitt(smq.getDurchschnittlicheEinzelnoten().get(
			 * GeraetEnum.BODEN));
			 * smqDto.setSchaukelringeDurchschnitt(smq.getDurchschnittlicheEinzelnoten().get
			 * (GeraetEnum.SCHAUKELRINGE));
			 * smqDto.setSprungDurchschnitt(smq.getDurchschnittlicheEinzelnoten().get(
			 * GeraetEnum.SPRUNG));
			 * smqDto.setBarrenDurchschnitt(smq.getDurchschnittlicheEinzelnoten().get(
			 * GeraetEnum.BARREN));
			 */
			return smqDto;
		}).collect(Collectors.toList());
		return smqDtoList;
	}
}
