package org.ztv.anmeldetool.controller;

import java.net.URI;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

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
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import org.ztv.anmeldetool.models.AbteilungEnum;
import org.ztv.anmeldetool.models.AnlageEnum;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.AnlassLauflisten;
import org.ztv.anmeldetool.models.Einzelnote;
import org.ztv.anmeldetool.models.GeraetEnum;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.Laufliste;
import org.ztv.anmeldetool.models.LauflistenContainer;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.Notenblatt;
import org.ztv.anmeldetool.models.RanglisteConfiguration;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.output.LauflistenOutput;
import org.ztv.anmeldetool.output.RanglistenOutput;
import org.ztv.anmeldetool.service.AnlassService;
import org.ztv.anmeldetool.service.LauflistenService;
import org.ztv.anmeldetool.service.OrganisationService;
import org.ztv.anmeldetool.service.RanglistenService;
import org.ztv.anmeldetool.service.ServiceException;
import org.ztv.anmeldetool.service.TeilnehmerAnlassLinkService;
import org.ztv.anmeldetool.transfer.LauflisteDTO;
import org.ztv.anmeldetool.transfer.LauflistenEintragDTO;
import org.ztv.anmeldetool.transfer.RanglisteConfigurationDTO;
import org.ztv.anmeldetool.transfer.RanglistenEntryDTO;
import org.ztv.anmeldetool.transfer.TeamwertungDTO;
import org.ztv.anmeldetool.util.RanglistenConfigurationMapper;
import org.ztv.anmeldetool.util.TeilnehmerAnlassLinkRanglistenMapper;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/anlaesse")
@Slf4j
@CrossOrigin(origins = "*", allowedHeaders = "*", allowCredentials = "true")
public class AnlassController {

	@Autowired
	AnlassService anlassService;

	@Autowired
	OrganisationService organisationService;

	@Autowired
	LauflistenService lauflistenService;

	@Autowired
	RanglistenService ranglistenService;

	@Autowired
	TeilnehmerAnlassLinkService teilnehmerAnlassLinkService;

	@Autowired
	TeilnehmerAnlassLinkRanglistenMapper talrMapper;

	@Autowired
	RanglistenConfigurationMapper rcMapper;

	@PutMapping("/{anlassId}/ranglisten/{tiTu}/{kategorie}/config")
	public @ResponseBody ResponseEntity<RanglisteConfigurationDTO> putRanglistenConfig(HttpServletRequest request,
			HttpServletResponse response, @PathVariable UUID anlassId, @PathVariable TiTuEnum tiTu,
			@PathVariable KategorieEnum kategorie, @RequestBody RanglisteConfigurationDTO dto) {
		RanglisteConfiguration entity = rcMapper.toEntity(dto);
		entity = ranglistenService.saveRanglisteConfiguration(entity);
		dto = rcMapper.fromEntity(entity);
		if (dto != null) {
			return ResponseEntity.ok(dto);
		} else {
			return this.getNotFound();
		}
	}

	@GetMapping(value = "/{anlassId}/ranglisten/{tiTu}/{kategorie}/config")
	public ResponseEntity<RanglisteConfigurationDTO> getRanglistenConfig(HttpServletRequest request,
			HttpServletResponse response, @PathVariable UUID anlassId, @PathVariable TiTuEnum tiTu,
			@PathVariable KategorieEnum kategorie) {
		try {
			Anlass anlass = anlassService.findAnlassById(anlassId);
			RanglisteConfiguration ranglistenConfig = ranglistenService.getRanglisteConfiguration(anlass, kategorie,
					tiTu);
			if (ranglistenConfig.getMaxAuszeichnungen() == 0) {
				List<TeilnehmerAnlassLink> tals = ranglistenService.getTeilnehmerSorted(anlass, kategorie, tiTu);
				int maxAuszeichnungen = ranglistenService.calcMaxAuszeichnungen(tals,
						ranglistenConfig.getMaxAuszeichnungen());
				ranglistenConfig.setMaxAuszeichnungen(maxAuszeichnungen);
			}

			RanglisteConfigurationDTO dto = rcMapper.fromEntity(ranglistenConfig);
			return ResponseEntity.ok(dto);
		} catch (Exception ex) {
			log.error("Unable to query RanglistenConfig: ", ex);
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to query RanglistenConfig: ",
					ex);
		}
	}

	@GetMapping(value = "/{anlassId}/ranglisten/{tiTu}/{kategorie}")
	public ResponseEntity<List<RanglistenEntryDTO>> getRangliste(HttpServletRequest request,
			HttpServletResponse response, @PathVariable UUID anlassId, @PathVariable TiTuEnum tiTu,
			@PathVariable KategorieEnum kategorie,
			@RequestParam(name = "maxAuszeichnungen") Optional<Integer> maxAuszeichungenOpt) {
		try {
			List<RanglistenEntryDTO> ranglistenDTOs = generateRangliste(anlassId, tiTu, kategorie, maxAuszeichungenOpt);
			return ResponseEntity.ok(ranglistenDTOs);
		} catch (Exception ex) {
			log.error("Unable to query LauflisteDTO: ", ex);
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to query LauflisteDTO: ", ex);
		}
	}

	private List<RanglistenEntryDTO> getRanglistenPerVereinDtos(UUID anlassId, TiTuEnum tiTu, KategorieEnum kategorie)
			throws ServiceException {
		Anlass anlass = anlassService.findAnlassById(anlassId);
		List<TeilnehmerAnlassLink> tals = ranglistenService.getRanglistePerVerein(anlass, tiTu, kategorie);

		List<RanglistenEntryDTO> ranglistenDTOs = tals.stream().map(tal -> {
			return talrMapper.fromEntity(tal);
		}).collect(Collectors.toList());
		return ranglistenDTOs;
	}

	@GetMapping(value = "/{anlassId}/ranglisten/{tiTu}/{kategorie}/vereine")
	public ResponseEntity<List<RanglistenEntryDTO>> getRanglistePerVerein(HttpServletRequest request,
			HttpServletResponse response, @PathVariable UUID anlassId, @PathVariable TiTuEnum tiTu,
			@PathVariable KategorieEnum kategorie) {
		try {
			List<RanglistenEntryDTO> ranglistenDTOs = getRanglistenPerVereinDtos(anlassId, tiTu, kategorie);
			return ResponseEntity.ok(ranglistenDTOs);
		} catch (Exception ex) {
			log.error("Unable to query Ranglisten per Verein: ", ex);
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
					"Unable to query Ranglisten per Verein: ", ex);
		}
	}

	@GetMapping(value = "/{anlassId}/ranglisten/{tiTu}/{kategorie}/vereine", produces = "application/pdf")
	public void getRanglistePerVereinPdf(HttpServletRequest request, HttpServletResponse response,
			@PathVariable UUID anlassId, @PathVariable TiTuEnum tiTu, @PathVariable KategorieEnum kategorie) {
		try {
			List<RanglistenEntryDTO> ranglistenDTOs = getRanglistenPerVereinDtos(anlassId, tiTu, kategorie);

			response.addHeader("Content-Disposition",
					"attachment; filename=Ranglisten-Per-Verein-" + kategorie + ".pdf");
			response.addHeader("Content-Type", "application/pdf");
			response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);

			RanglistenOutput.createRanglistePerVerein(response, ranglistenDTOs);

		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
					"Unable to query Ranglisten per Verein: ", ex);
		}
	}

	@GetMapping(value = "/{anlassId}/ranglisten/{tiTu}/{kategorie}/vereine", produces = "text/csv;charset=UTF-8")
	public ResponseEntity<List<RanglistenEntryDTO>> getRanglistePerVereinCsv(HttpServletRequest request,
			HttpServletResponse response, @PathVariable UUID anlassId, @PathVariable TiTuEnum tiTu,
			@PathVariable KategorieEnum kategorie) {
		try {
			List<RanglistenEntryDTO> ranglistenDTOs = getRanglistenPerVereinDtos(anlassId, tiTu, kategorie);

			return ResponseEntity.ok(ranglistenDTOs);
		} catch (Exception ex) {
			log.error("Unable to query Ranglisten per Verein: ", ex);
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
					"Unable to query Ranglisten per Verein: ", ex);
		}
	}

	@GetMapping(value = "/{anlassId}/ranglisten/{tiTu}/{kategorie}/teamwertung", produces = "application/pdf")
	public void getTeamwertungPdf(HttpServletRequest request, HttpServletResponse response, @PathVariable UUID anlassId,
			@PathVariable TiTuEnum tiTu, @PathVariable KategorieEnum kategorie) {
		try {
			List<RanglistenEntryDTO> ranglistenDTOs = getRanglistenPerVereinDtos(anlassId, tiTu, kategorie);
			List<TeamwertungDTO> twList = this.ranglistenService.getTeamwertung(kategorie, ranglistenDTOs);
			response.addHeader("Content-Disposition", "attachment; filename=Teamwertung-" + kategorie + ".pdf");
			response.addHeader("Content-Type", "application/pdf");
			response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);

			RanglistenOutput.createTeamwertung(response, twList, kategorie);

		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
					"Unable to query Ranglisten per Verein: ", ex);
		}
	}

	private List<RanglistenEntryDTO> generateRangliste(UUID anlassId, TiTuEnum tiTu, KategorieEnum kategorie,
			Optional<Integer> maxAuszeichungenOpt) throws ServiceException {
		Anlass anlass = anlassService.findAnlassById(anlassId);
		RanglisteConfiguration ranglistenConfig = ranglistenService.getRanglisteConfiguration(anlass, kategorie, tiTu);
		List<TeilnehmerAnlassLink> tals = ranglistenService.getTeilnehmerSorted(anlass, kategorie, tiTu);

		int maxAuszeichnungen = ranglistenService.calcMaxAuszeichnungen(tals, ranglistenConfig.getMaxAuszeichnungen());
		if (maxAuszeichungenOpt.isPresent() && maxAuszeichungenOpt.get() > 0) {
			maxAuszeichnungen = maxAuszeichungenOpt.get();
			ranglistenConfig.setMaxAuszeichnungen(maxAuszeichnungen);
			ranglistenConfig = ranglistenService.saveRanglisteConfiguration(ranglistenConfig);
		}
		tals = ranglistenService.createRangliste(tals, maxAuszeichnungen);

		List<RanglistenEntryDTO> ranglistenDTOs = tals.stream().map(tal -> {
			ranglistenService.saveNotenblatt(tal.getNotenblatt());
			return talrMapper.fromEntity(tal);
		}).collect(Collectors.toList());

		ranglistenDTOs = sortByGeraet(ranglistenDTOs);
		return ranglistenDTOs;

	}

	private List<RanglistenEntryDTO> sortByGeraet(List<RanglistenEntryDTO> ranglistenDTOs) {
		// Reck
		ranglistenDTOs = ranglistenDTOs.stream()
				.sorted(Comparator.comparing(dto -> dto.getNoteReck(), Comparator.reverseOrder()))
				.collect(Collectors.toList());

		int rang = 0;
		int pos = 0;
		float currentNote = 0.0f;
		for (RanglistenEntryDTO dto : ranglistenDTOs) {
			pos++;
			if (dto.getNoteReck() != currentNote) {
				rang = pos;
				currentNote = dto.getNoteReck();
			}
			dto.setRangReck(rang);
		}
		// Boden
		ranglistenDTOs = ranglistenDTOs.stream()
				.sorted(Comparator.comparing(dto -> dto.getNoteBoden(), Comparator.reverseOrder()))
				.collect(Collectors.toList());

		rang = 0;
		pos = 0;
		currentNote = 0.0f;
		for (RanglistenEntryDTO dto : ranglistenDTOs) {
			pos++;
			if (dto.getNoteBoden() != currentNote) {
				rang = pos;
				currentNote = dto.getNoteBoden();
			}
			dto.setRangBoden(rang);
		}
		// Ring
		ranglistenDTOs = ranglistenDTOs.stream()
				.sorted(Comparator.comparing(dto -> dto.getNoteSchaukelringe(), Comparator.reverseOrder()))
				.collect(Collectors.toList());

		rang = 0;
		pos = 0;
		currentNote = 0.0f;
		for (RanglistenEntryDTO dto : ranglistenDTOs) {
			pos++;
			if (dto.getNoteSchaukelringe() != currentNote) {
				rang = pos;
				currentNote = dto.getNoteSchaukelringe();
			}
			dto.setRangSchaukelringe(rang);
		}
		// Sprung
		ranglistenDTOs = ranglistenDTOs.stream()
				.sorted(Comparator.comparing(dto -> dto.getNoteZaehlbar(), Comparator.reverseOrder()))
				.collect(Collectors.toList());

		rang = 0;
		pos = 0;
		currentNote = 0.0f;
		for (RanglistenEntryDTO dto : ranglistenDTOs) {
			pos++;
			if (dto.getNoteZaehlbar() != currentNote) {
				rang = pos;
				currentNote = dto.getNoteZaehlbar();
			}
			dto.setRangSprung(rang);
		}
		// Barren
		ranglistenDTOs = ranglistenDTOs.stream()
				.sorted(Comparator.comparing(dto -> dto.getNoteBarren(), Comparator.reverseOrder()))
				.collect(Collectors.toList());

		rang = 0;
		pos = 0;
		currentNote = 0.0f;
		for (RanglistenEntryDTO dto : ranglistenDTOs) {
			pos++;
			if (dto.getNoteBarren() != currentNote) {
				rang = pos;
				currentNote = dto.getNoteBarren();
			}
			dto.setRangBarren(rang);
		}

		ranglistenDTOs = ranglistenDTOs.stream()
				.sorted(Comparator.comparing(dto -> dto.getRang(), Comparator.naturalOrder()))
				.collect(Collectors.toList());
		return ranglistenDTOs;
	}

	@GetMapping(value = "/{anlassId}/ranglisten/{tiTu}/{kategorie}", produces = "application/pdf")
	public void getRanglistenPdf(HttpServletRequest request, HttpServletResponse response, @PathVariable UUID anlassId,
			@PathVariable TiTuEnum tiTu, @PathVariable KategorieEnum kategorie,
			@RequestParam(name = "maxAuszeichnungen") Optional<Integer> maxAuszeichungenOpt) {
		try {
			List<RanglistenEntryDTO> ranglistenDTOs = generateRangliste(anlassId, tiTu, kategorie, maxAuszeichungenOpt);

			response.addHeader("Content-Disposition", "attachment; filename=Lauflisten-" + kategorie + ".pdf");
			response.addHeader("Content-Type", "application/pdf");
			response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);
			// Regel für Sprung Durchschnitt
			boolean averageSprung = kategorie.equals(KategorieEnum.K6) || kategorie.equals(KategorieEnum.K7);
			RanglistenOutput.createRangliste(response, ranglistenDTOs, tiTu == TiTuEnum.Ti ? false : true,
					averageSprung);

		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to generate Lauflisten: ", ex);
		}
	}

	@DeleteMapping("/{anlassId}/lauflisten/{kategorie}/{abteilung}/{anlage}")
	public ResponseEntity<?> deleteLauflisten(HttpServletRequest request, @PathVariable UUID anlassId,
			@PathVariable KategorieEnum kategorie, @PathVariable AbteilungEnum abteilung,
			@PathVariable AnlageEnum anlage) {
		try {
			Anlass anlass = anlassService.findAnlassById(anlassId);
			lauflistenService.deleteLauflistenForAnlassAndKategorie(anlass, kategorie, abteilung, anlage);
			return ResponseEntity.ok().build();
		} catch (Exception e) {
			log.warn("deleteLauflisten", e);
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Could not delete", e);
		}
	}

	@GetMapping(value = "/{anlassId}/lauflisten")
	public ResponseEntity<LauflisteDTO> getAnlagen(HttpServletRequest request, HttpServletResponse response,
			@PathVariable UUID anlassId, @RequestParam(name = "search") String search) {
		try {
			Anlass anlass = anlassService.findAnlassById(anlassId);
			Optional<Laufliste> listenOpt = lauflistenService.findLauflistenForAnlassAndSearch(anlass, search);
			if (listenOpt.isEmpty()) {
				return getNotFound();
			}
			final Laufliste laufliste = listenOpt.get();
			List<TeilnehmerAnlassLink> tals = laufliste.getLauflistenContainer().getTeilnehmerAnlassLinks();
			if (tals == null || tals.size() == 0) {
				return getNotFound();
			}
			TeilnehmerAnlassLink firstTal = tals.get(0);

			List<LauflistenEintragDTO> eintraege = tals.stream().map(tal -> {
				Einzelnote einzelnote = tal.getNotenblatt().getEinzelnoteForGeraet(laufliste.getGeraet());

				return LauflistenEintragDTO.builder().id(tal.getId()).laufliste_id(laufliste.getId())
						.startnummer(tal.getStartnummer()).startOrder(einzelnote.getStartOrder())
						.verein(tal.getOrganisation().getName()).name(tal.getTeilnehmer().getName())
						.vorname(tal.getTeilnehmer().getVorname()).note_1(einzelnote.getNote_1())
						.note_2(einzelnote.getNote_2()).checked(einzelnote.isChecked()).erfasst(einzelnote.isErfasst())
						.tal_id(tal.getId()).deleted(tal.isDeleted()).build();
			}).collect(Collectors.toList());

			LauflisteDTO lauflisteDTO = LauflisteDTO.builder().laufliste(laufliste.getKey())
					.abteilung(firstTal.getAbteilung()).anlage(firstTal.getAnlage()).geraet(laufliste.getGeraet())
					.id(laufliste.getId()).eintraege(eintraege).erfasst(laufliste.isErfasst())
					.checked(laufliste.isChecked()).abloesung(laufliste.getAbloesung()).build();
			return ResponseEntity.ok(lauflisteDTO);
		} catch (Exception ex) {
			log.error("Unable to query LauflisteDTO: ", ex);
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to query LauflisteDTO: ", ex);
		}
	}

	@GetMapping(value = "/{anlassId}/lauflisten/{kategorie}/{abteilung}")
	public ResponseEntity<List<AnlageEnum>> getAnlagen(HttpServletRequest request, HttpServletResponse response,
			@PathVariable UUID anlassId, @PathVariable KategorieEnum kategorie, @PathVariable AbteilungEnum abteilung) {
		try {
			Anlass anlass = anlassService.findAnlassById(anlassId);
			List<AnlageEnum> anlagen = teilnehmerAnlassLinkService.findAbteilungenByKategorieAndAbteilung(anlass,
					kategorie, abteilung);
			return ResponseEntity.ok(anlagen);
		} catch (Exception ex) {
			log.error("Unable to query Anlagen: ", ex);
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to query Anlagen: ", ex);
		}
	}

	@GetMapping(value = "/{anlassId}/lauflisten/{kategorie}")
	public ResponseEntity<List<AbteilungEnum>> getAbteilungen(HttpServletRequest request, HttpServletResponse response,
			@PathVariable UUID anlassId, @PathVariable KategorieEnum kategorie) {
		try {
			Anlass anlass = anlassService.findAnlassById(anlassId);
			List<AbteilungEnum> abteilungen = teilnehmerAnlassLinkService.findAbteilungenByKategorie(anlass, kategorie);
			return ResponseEntity.ok(abteilungen);
		} catch (Exception ex) {
			log.error("Unable to query Abteilungen: ", ex);
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to query Abteilungen: ", ex);
		}
	}

	@GetMapping(value = "/{anlassId}/lauflisten/{kategorie}/{abteilung}/{anlage}")
	public ResponseEntity<List<LauflisteDTO>> getLauflisten(HttpServletRequest request, HttpServletResponse response,
			@PathVariable UUID anlassId, @PathVariable KategorieEnum kategorie, @PathVariable AbteilungEnum abteilung,
			@PathVariable AnlageEnum anlage) {
		try {
			Anlass anlass = anlassService.findAnlassById(anlassId);

			List<LauflistenContainer> listen = lauflistenService.getLauflistenForAnlassAndKategorie(anlass, kategorie,
					abteilung, anlage);
			List<Laufliste> alle = new ArrayList<Laufliste>();
			for (LauflistenContainer container : listen) {
				alle.addAll(container.getGeraeteLauflisten());
			}

			List<LauflisteDTO> listenDTO = alle.stream().map(laufliste -> {
				return LauflisteDTO.builder().laufliste(laufliste.getKey()).geraet(laufliste.getGeraet())
						.id(laufliste.getId()).checked(laufliste.isChecked()).erfasst(laufliste.isErfasst()).build();
			}).collect(Collectors.toList());
			return ResponseEntity.ok(listenDTO);
		} catch (Exception ex) {
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to generate Lauflisten: ", ex);
		}
	}

	@PutMapping("/{anlassId}/lauflisten/{lauflistenId}")
	public @ResponseBody ResponseEntity<LauflisteDTO> putLaufliste(HttpServletRequest request,
			HttpServletResponse response, @PathVariable UUID anlassId, @PathVariable UUID lauflistenId,
			@RequestBody LauflisteDTO lauflisteDto) {
		Optional<Laufliste> lauflisteOpt = lauflistenService.findLauflisteById(lauflisteDto.getId());
		if (lauflisteOpt.isPresent()) {
			Laufliste laufliste = lauflisteOpt.get();
			laufliste.setErfasst(lauflisteDto.isErfasst());
			laufliste.setChecked(lauflisteDto.isChecked());
			laufliste = lauflistenService.saveLaufliste(laufliste);
			return ResponseEntity.ok(lauflisteDto);
		} else {
			return this.getNotFound();
		}
	}

	@PutMapping("/{anlassId}/lauflisten/{lauflistenId}/lauflisteneintraege/{lauflisteneintragId}")
	public @ResponseBody ResponseEntity<LauflistenEintragDTO> putAnlassVereine(HttpServletRequest request,
			HttpServletResponse response, @PathVariable UUID anlassId, @PathVariable UUID lauflistenId,
			@PathVariable UUID lauflisteneintragId, @RequestBody LauflistenEintragDTO lauflistenEintragDto) {
		// return lauflistenService.;
		Optional<TeilnehmerAnlassLink> talOpt = teilnehmerAnlassLinkService
				.findTeilnehmerAnlassLinkById(lauflistenEintragDto.getTal_id());
		Optional<Laufliste> lauflisteOpt = this.lauflistenService
				.findLauflisteById(lauflistenEintragDto.getLaufliste_id());
		if (talOpt.isPresent() && lauflisteOpt.isPresent()) {
			TeilnehmerAnlassLink tal = talOpt.get();
			Laufliste laufliste = lauflisteOpt.get();
			Einzelnote einzelnote = tal.getNotenblatt().getEinzelnoteForGeraet(laufliste.getGeraet());
			einzelnote.setNote_1(lauflistenEintragDto.getNote_1());
			einzelnote.setNote_2(lauflistenEintragDto.getNote_2());
			if (einzelnote.getNote_1() > 0
					&& (einzelnote.getNote_2() > 0 || !GeraetEnum.SPRUNG.equals(laufliste.getGeraet()))) {
				einzelnote.setErfasst(true);
			} else {
				einzelnote.setErfasst(false);
			}
			einzelnote.setChecked(lauflistenEintragDto.isChecked());
			einzelnote = lauflistenService.saveEinzelnote(einzelnote);
			Notenblatt notenblatt = updateNotenblatt(tal.getNotenblatt(), tal.getKategorie());
			lauflistenService.saveNotenblatt(notenblatt);
			LauflistenEintragDTO le = LauflistenEintragDTO.builder().id(tal.getId()).laufliste_id(laufliste.getId())
					.startnummer(tal.getStartnummer()).verein(tal.getOrganisation().getName())
					.name(tal.getTeilnehmer().getName()).vorname(tal.getTeilnehmer().getVorname())
					.note_1(einzelnote.getNote_1()).note_2(einzelnote.getNote_2()).checked(einzelnote.isChecked())
					.erfasst(einzelnote.isErfasst()).tal_id(tal.getId()).deleted(tal.isDeleted()).build();
			return ResponseEntity.ok(le);
		} else {
			return this.getNotFound();
		}
	}

	private Notenblatt updateNotenblatt(Notenblatt notenblatt, KategorieEnum kategorie) {
		List<Einzelnote> einzelnoten = notenblatt.getEinzelnoten();
		float gesamtPunktzahl = 0.0f;
		for (Einzelnote einzelnote : einzelnoten) {
			float note = einzelnote.getNote_1();
			if (GeraetEnum.SPRUNG.equals(einzelnote.getGeraet())) {
				if (kategorie.ordinal() == KategorieEnum.K6.ordinal()
						|| kategorie.ordinal() == KategorieEnum.K7.ordinal()) {
					note += einzelnote.getNote_2();
					note = note / 2;
				} else {
					if (note < einzelnote.getNote_2()) {
						note = einzelnote.getNote_2();
					}
				}
				einzelnote.setZaehlbar(note);
			}
			gesamtPunktzahl += note;
		}
		notenblatt.setGesamtPunktzahl(gesamtPunktzahl);
		return notenblatt;

	}

	@DeleteMapping("/{anlassId}/lauflisten/{lauflistenId}/lauflisteneintraege/{lauflisteneintragId}")
	public ResponseEntity<Boolean> deleteLauflistenEintrag(HttpServletRequest request, @PathVariable UUID anlassId,
			@PathVariable UUID lauflistenId, @PathVariable UUID lauflisteneintragId,
			@RequestParam(name = "grund") String grund) {
		try {
			Optional<TeilnehmerAnlassLink> talOpt = teilnehmerAnlassLinkService
					.findTeilnehmerAnlassLinkById(lauflisteneintragId);
			if (talOpt.isEmpty()) {
				return this.getNotFound();
			}
			TeilnehmerAnlassLink tal = talOpt.get();
			tal.setDeleted(true);
			tal.setAktiv(false);
			if ("nichtAngetreten".equals(grund)) {
				tal.setMeldeStatus(MeldeStatusEnum.NICHTGESTARTET);
			}
			if ("verletzt".equals(grund)) {
				tal.setMeldeStatus(MeldeStatusEnum.VERLETZT);
			}
			teilnehmerAnlassLinkService.save(tal);

			return ResponseEntity.ok(Boolean.TRUE);
		} catch (Exception e) {
			return ResponseEntity.badRequest().build();
		}
	}

	@GetMapping(value = "/{anlassId}/lauflisten/{kategorie}/{abteilung}/{anlage}", produces = "application/pdf")
	public void getLauflistenPdf(HttpServletRequest request, HttpServletResponse response, @PathVariable UUID anlassId,
			@PathVariable KategorieEnum kategorie, @PathVariable AbteilungEnum abteilung,
			@PathVariable AnlageEnum anlage) {
		try {
			Anlass anlass = anlassService.findAnlassById(anlassId);

			response.addHeader("Content-Disposition", "attachment; filename=Lauflisten-" + kategorie + ".pdf");
			response.addHeader("Content-Type", "application/pdf");
			response.addHeader(HttpHeaders.ACCESS_CONTROL_EXPOSE_HEADERS, HttpHeaders.CONTENT_DISPOSITION);

			AnlassLauflisten anlassLauflisten = lauflistenService.generateLauflistenForAnlassAndKategorie(anlass,
					kategorie, abteilung, anlage);
			LauflistenOutput.createLaufListe(anlassLauflisten, response);
			anlassLauflisten.getLauflistenContainer().stream().forEach(container -> {
				lauflistenService.saveAllLauflisten(container.getGeraeteLauflisten());
				container.getGeraeteLauflisten().stream().forEach(laufliste -> {
					laufliste.getEinzelnoten().stream().forEach(einzelnote -> {
						Einzelnote note = lauflistenService.findEinzelnoteById(einzelnote.getId()).get();
						note.setStartOrder(einzelnote.getStartOrder());
						lauflistenService.saveEinzelnote(note);
						// lauflistenService.saveAllEinzelnoten();
					});
				});
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Unable to generate Lauflisten: ", ex);
		}
	}

	private <T> ResponseEntity<T> getNotFound() {
		URI requestURI = ServletUriComponentsBuilder.fromCurrentRequest().build().toUri();
		return ResponseEntity.notFound().location(requestURI).build();
	}
}
