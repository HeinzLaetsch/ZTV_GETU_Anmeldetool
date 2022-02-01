package org.ztv.anmeldetool.anmeldetool.controller.admin;

import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import org.ztv.anmeldetool.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.anmeldetool.models.AnlassLauflisten;
import org.ztv.anmeldetool.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.anmeldetool.output.LauflistenOutput;
import org.ztv.anmeldetool.anmeldetool.service.AnlassService;
import org.ztv.anmeldetool.anmeldetool.service.LauflistenService;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/anlaesse")
@Slf4j
@CrossOrigin(origins = "*", allowedHeaders = "*", allowCredentials = "true")
public class AnlassController {

	@Autowired
	AnlassService anlassService;

	@Autowired
	LauflistenService lauflistenService;

	@DeleteMapping("/{anlassId}/lauflisten/{kategorie}")
	public ResponseEntity<?> deleteEingeteilteWertungsrichter(HttpServletRequest request, @PathVariable UUID anlassId,
			@PathVariable String kategorie) {
		try {
			Anlass anlass = anlassService.findAnlassById(anlassId);
			KategorieEnum kategorieEnum = KategorieEnum.valueOf(kategorie);
			lauflistenService.deleteLauflistenForAnlassAndKategorie(anlass, kategorieEnum);
			return ResponseEntity.ok().build();
		} catch (Exception e) {
			log.warn("deleteEingeteilteWertungsrichter", e);
			return ResponseEntity.badRequest().build();
		}
	}

	@GetMapping(value = "/{anlassId}/lauflisten/{kategorie}", produces = "application/pdf")
	public void getLauflistenPdf(HttpServletRequest request, HttpServletResponse response, @PathVariable UUID anlassId,
			@PathVariable String kategorie) {
		try {
			Anlass anlass = anlassService.findAnlassById(anlassId);
			KategorieEnum kategorieEnum = KategorieEnum.valueOf(kategorie);

			response.addHeader("Content-Disposition", "attachment; filename=Lauflisten-" + kategorie + ".pdf");
			response.addHeader("Content-Type", "application/pdf");
			response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);

			AnlassLauflisten anlassLauflisten = lauflistenService.generateLauflistenForAnlassAndKategorie(anlass,
					kategorieEnum);
			LauflistenOutput.createLaufListe(anlassLauflisten, response);

			// response.addHeader("Content-Length", "");
		} catch (Exception ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to generate Lauflisten: ", ex);
		}
	}

	@GetMapping(value = "/{anlassId}/lauflisten/{kategorie}", produces = "application/json")
	public void getLauflisten(HttpServletRequest request, HttpServletResponse response, @PathVariable UUID anlassId,
			@PathVariable String kategorie) {
		try {
			Anlass anlass = anlassService.findAnlassById(anlassId);
			KategorieEnum kategorieEnum = KategorieEnum.valueOf(kategorie);

			response.addHeader("Content-Disposition", "attachment; filename=Lauflisten-" + kategorie + ".pdf");
			response.addHeader("Content-Type", "application/json");
			response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);

			// response.setCharacterEncoding("UTF-8");
			// LauflistenOutput.createLaufListe(response);

			// response.addHeader("Content-Length", "");
		} catch (Exception ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
					"Unable to generate Wertungsrichter Export: ", ex);
		}
	}
}
