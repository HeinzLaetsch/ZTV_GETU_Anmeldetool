package org.ztv.anmeldetool.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.ztv.anmeldetool.models.Anlass;
import org.ztv.anmeldetool.models.KategorieEnum;
import org.ztv.anmeldetool.models.MeldeStatusEnum;
import org.ztv.anmeldetool.models.Organisation;
import org.ztv.anmeldetool.models.OrganisationAnlassLink;
import org.ztv.anmeldetool.models.Person;
import org.ztv.anmeldetool.models.PersonAnlassLink;
import org.ztv.anmeldetool.models.Teilnehmer;
import org.ztv.anmeldetool.models.TeilnehmerAnlassLink;
import org.ztv.anmeldetool.models.TiTuEnum;
import org.ztv.anmeldetool.models.WertungsrichterBrevetEnum;
import org.ztv.anmeldetool.models.WertungsrichterEinsatz;
import org.ztv.anmeldetool.repositories.AnlassRepository;
import org.ztv.anmeldetool.repositories.OrganisationAnlassLinkRepository;
import org.ztv.anmeldetool.repositories.PersonAnlassLinkRepository;
import org.ztv.anmeldetool.repositories.PersonenRepository;
import org.ztv.anmeldetool.repositories.TeilnehmerAnlassLinkRepository;
import org.ztv.anmeldetool.transfer.AnmeldeKontrolleDTO;
import org.ztv.anmeldetool.transfer.OrganisationAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.PersonAnlassLinkDTO;
import org.ztv.anmeldetool.transfer.VereinsStartDTO;
import org.ztv.anmeldetool.util.AnlassMapper;
import org.ztv.anmeldetool.util.OrganisationMapper;

import lombok.extern.slf4j.Slf4j;

/**
 * 
 * @author heinz
 */
@Service("anlassService")
@Slf4j
public class AnlassService {

	@Autowired
	AnlassRepository anlassRepo;

	@Autowired
	OrganisationService organisationSrv;

	@Autowired
	PersonService personSrv;

	@Autowired
	WertungsrichterService wrSrv;

	@Autowired
	OrganisationAnlassLinkRepository orgAnlassRepo;

	@Autowired
	TeilnehmerAnlassLinkRepository teilnehmerAnlassLinkRepository;

	@Autowired
	PersonAnlassLinkRepository personAnlassLinkRepository;

	@Autowired
	PersonenRepository personRepository;

	@Autowired
	AnlassMapper anlassMapper;

	@Autowired
	OrganisationMapper orgMapper;

	public Anlass updateAnlass(Anlass anlass) {
		return this.anlassRepo.save(anlass);
	}

	public List<Person> getVerfuegbareWertungsrichter(UUID anlassId, UUID orgId, WertungsrichterBrevetEnum brevet) {
		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		List<Person> personen = personRepository.findByOrganisationId(organisation.getId());
		List<Person> wrs = personen.stream().filter(person -> {
			return (person.getWertungsrichter() != null && person.getWertungsrichter().getBrevet().equals(brevet));
		}).collect(Collectors.toList());

		List<PersonAnlassLink> eingeteilteWrs = getEingeteilteWertungsrichter(anlassId, orgId, brevet);

		List<Person> verfuegbare = wrs.stream().filter(person -> {
			if (eingeteilteWrs.size() == 0) {
				return true;
			}
			boolean already = eingeteilteWrs.stream().filter(pal -> {
				log.debug("verfügbar: {}, eingeteilt: {}, gleich: {}", person.getId(), pal.getPerson().getId(),
						pal.getPerson().getId().equals(person.getId()));
				return !pal.getPerson().getId().equals(person.getId());
			}).count() == eingeteilteWrs.size();
			log.debug("Person {} ist eingeteilt {}", person.getBenutzername(), already);
			return already;
		}).collect(Collectors.toList());
		return verfuegbare;
	}

	public AnmeldeKontrolleDTO getAnmeldeKontrolle(UUID anlassId, UUID orgId) {
		List<VereinsStartDTO> vereinsStarts = new ArrayList<VereinsStartDTO>();
		Anlass anlass = findAnlassById(anlassId);
		AnmeldeKontrolleDTO anlassKontrolle = new AnmeldeKontrolleDTO(anlassMapper.toDto(anlass), vereinsStarts,
				orgMapper.ToDto(anlass.getOrganisator()));

		List<Organisation> orgs = getVereinsStarts(anlassId);
		if (orgId != null) {
			orgs = orgs.stream().filter(org -> {
				return org.getId().equals(orgId);
			}).collect(Collectors.toList());
		}

		orgs.stream().forEach(org -> {
			VereinsStartDTO vereinsStart = new VereinsStartDTO();
			vereinsStart.setVereinsName(org.getName());
			List<PersonAnlassLink> eingeteilteWrs1 = getEingeteilteWertungsrichter(anlassId, org.getId(),
					WertungsrichterBrevetEnum.Brevet_1);
			vereinsStart.setBr1(eingeteilteWrs1.size());
			List<PersonAnlassLink> eingeteilteWrs2 = getEingeteilteWertungsrichter(anlassId, org.getId(),
					WertungsrichterBrevetEnum.Brevet_2);
			vereinsStart.setBr2(eingeteilteWrs2.size());
			List<TeilnehmerAnlassLink> tals = getTeilnahmen(anlassId, org.getId(), true);
			int totalBr = 0;
			List<TeilnehmerAnlassLink> fTal = tals.stream().filter(tal -> {
				return tal.isAktiv() && KategorieEnum.K1.equals(tal.getKategorie())
						&& TiTuEnum.Ti.equals(tal.getTeilnehmer().getTiTu());
			}).collect(Collectors.toList());
			vereinsStart.setTals_K1_Ti(fTal);
			vereinsStart.setK1_Ti(fTal.size());
			totalBr += vereinsStart.getK1_Ti();

			fTal = tals.stream().filter(tal -> {
				return tal.isAktiv() && KategorieEnum.K1.equals(tal.getKategorie())
						&& TiTuEnum.Tu.equals(tal.getTeilnehmer().getTiTu());
			}).collect(Collectors.toList());
			vereinsStart.setTals_K1_Tu(fTal);
			vereinsStart.setK1_Tu(fTal.size());
			totalBr += vereinsStart.getK1_Tu();

			fTal = tals.stream().filter(tal -> {
				return tal.isAktiv() && KategorieEnum.K2.equals(tal.getKategorie())
						&& TiTuEnum.Ti.equals(tal.getTeilnehmer().getTiTu());
			}).collect(Collectors.toList());
			vereinsStart.setTals_K2_Ti(fTal);
			vereinsStart.setK2_Ti(fTal.size());
			totalBr += vereinsStart.getK2_Ti();

			fTal = tals.stream().filter(tal -> {
				return tal.isAktiv() && KategorieEnum.K2.equals(tal.getKategorie())
						&& TiTuEnum.Tu.equals(tal.getTeilnehmer().getTiTu());
			}).collect(Collectors.toList());
			vereinsStart.setTals_K2_Tu(fTal);
			vereinsStart.setK2_Tu(fTal.size());
			totalBr += vereinsStart.getK2_Tu();

			fTal = tals.stream().filter(tal -> {
				return tal.isAktiv() && KategorieEnum.K3.equals(tal.getKategorie())
						&& TiTuEnum.Ti.equals(tal.getTeilnehmer().getTiTu());
			}).collect(Collectors.toList());
			vereinsStart.setTals_K3_Ti(fTal);
			vereinsStart.setK3_Ti(fTal.size());
			totalBr += vereinsStart.getK3_Ti();

			fTal = tals.stream().filter(tal -> {
				return tal.isAktiv() && KategorieEnum.K3.equals(tal.getKategorie())
						&& TiTuEnum.Tu.equals(tal.getTeilnehmer().getTiTu());
			}).collect(Collectors.toList());
			vereinsStart.setK3_Tu(fTal.size());
			vereinsStart.setTals_K3_Tu(fTal);
			totalBr += vereinsStart.getK3_Tu();

			fTal = tals.stream().filter(tal -> {
				return tal.isAktiv() && KategorieEnum.K4.equals(tal.getKategorie())
						&& TiTuEnum.Ti.equals(tal.getTeilnehmer().getTiTu());
			}).collect(Collectors.toList());
			vereinsStart.setK4_Ti(fTal.size());
			vereinsStart.setTals_K4_Ti(fTal);
			totalBr += vereinsStart.getK4_Ti();

			fTal = tals.stream().filter(tal -> {
				return tal.isAktiv() && KategorieEnum.K4.equals(tal.getKategorie())
						&& TiTuEnum.Tu.equals(tal.getTeilnehmer().getTiTu());
			}).collect(Collectors.toList());
			vereinsStart.setK4_Tu(fTal.size());
			vereinsStart.setTals_K4_Tu(fTal);
			totalBr += vereinsStart.getK4_Tu();

			vereinsStart.setTotal_br1(totalBr);

			fTal = tals.stream().filter(tal -> {
				return tal.isAktiv() && KategorieEnum.K5A.equals(tal.getKategorie())
						&& TiTuEnum.Ti.equals(tal.getTeilnehmer().getTiTu());
			}).collect(Collectors.toList());
			vereinsStart.setK5A(fTal.size());
			vereinsStart.setTals_K5A(fTal);
			totalBr = vereinsStart.getK5A();

			fTal = tals.stream().filter(tal -> {
				return tal.isAktiv() && KategorieEnum.K5B.equals(tal.getKategorie())
						&& TiTuEnum.Ti.equals(tal.getTeilnehmer().getTiTu());
			}).collect(Collectors.toList());
			vereinsStart.setK5B(fTal.size());
			vereinsStart.setTals_K5B(fTal);
			totalBr += vereinsStart.getK5B();

			fTal = tals.stream().filter(tal -> {
				return tal.isAktiv() && KategorieEnum.K5.equals(tal.getKategorie())
						&& TiTuEnum.Tu.equals(tal.getTeilnehmer().getTiTu());
			}).collect(Collectors.toList());
			vereinsStart.setK5(fTal.size());
			vereinsStart.setTals_K5(fTal);
			totalBr += vereinsStart.getK5();

			fTal = tals.stream().filter(tal -> {
				return tal.isAktiv() && KategorieEnum.K6.equals(tal.getKategorie())
						&& TiTuEnum.Ti.equals(tal.getTeilnehmer().getTiTu());
			}).collect(Collectors.toList());
			vereinsStart.setK6_Ti(fTal.size());
			vereinsStart.setTals_K6_Ti(fTal);
			totalBr += vereinsStart.getK6_Ti();

			fTal = tals.stream().filter(tal -> {
				return tal.isAktiv() && KategorieEnum.K6.equals(tal.getKategorie())
						&& TiTuEnum.Tu.equals(tal.getTeilnehmer().getTiTu());
			}).collect(Collectors.toList());
			vereinsStart.setK6_Tu(fTal.size());
			vereinsStart.setTals_K6_Tu(fTal);
			totalBr += vereinsStart.getK6_Tu();

			fTal = tals.stream().filter(tal -> {
				return tal.isAktiv() && KategorieEnum.KD.equals(tal.getKategorie())
						&& TiTuEnum.Ti.equals(tal.getTeilnehmer().getTiTu());
			}).collect(Collectors.toList());
			vereinsStart.setKD(fTal.size());
			vereinsStart.setTals_KD(fTal);
			totalBr += vereinsStart.getKD();

			fTal = tals.stream().filter(tal -> {
				return tal.isAktiv() && KategorieEnum.KH.equals(tal.getKategorie())
						&& TiTuEnum.Tu.equals(tal.getTeilnehmer().getTiTu());
			}).collect(Collectors.toList());
			vereinsStart.setKH(fTal.size());
			vereinsStart.setTals_KH(fTal);
			totalBr += vereinsStart.getKH();

			fTal = tals.stream().filter(tal -> {
				return tal.isAktiv() && KategorieEnum.K7.equals(tal.getKategorie())
						&& TiTuEnum.Ti.equals(tal.getTeilnehmer().getTiTu());
			}).collect(Collectors.toList());
			vereinsStart.setK7_Ti(fTal.size());
			vereinsStart.setTals_K7_Ti(fTal);
			totalBr += vereinsStart.getK7_Ti();
			fTal = tals.stream().filter(tal -> {
				return tal.isAktiv() && KategorieEnum.K7.equals(tal.getKategorie())
						&& TiTuEnum.Tu.equals(tal.getTeilnehmer().getTiTu());
			}).collect(Collectors.toList());
			vereinsStart.setK7_Tu(fTal.size());
			vereinsStart.setTals_K7_Tu(fTal);
			totalBr += vereinsStart.getK7_Tu();

			vereinsStart.setTotal_br2(totalBr);

			vereinsStart.setTotal(vereinsStart.getTotal_br1() + vereinsStart.getTotal_br2());

			vereinsStarts.add(vereinsStart);
		});

		return anlassKontrolle;
	}

	public List<PersonAnlassLink> getEingeteilteWertungsrichter(UUID anlassId) {
		Anlass anlass = this.findAnlassById(anlassId);
		List<PersonAnlassLink> pals = personAnlassLinkRepository.findByAnlass(anlass);
		pals.forEach(pal -> {
			List<WertungsrichterEinsatz> allEinsaetze = pal.getEinsaetze().stream().filter(einsatz -> {
				return einsatz.isEingesetzt();
			}).collect(Collectors.toList());
			pal.setEinsaetze(allEinsaetze);
		});
		return pals;
	}

	public List<PersonAnlassLink> getEingeteilteWertungsrichter(UUID anlassId, UUID orgId,
			WertungsrichterBrevetEnum brevet) {
		Anlass anlass = this.findAnlassById(anlassId);
		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		List<PersonAnlassLink> pals = personAnlassLinkRepository.findByAnlassAndOrganisation(anlass, organisation);
		pals = pals.stream().filter(pal -> {
			return pal.getPerson().getWertungsrichter().getBrevet().equals(brevet);
		}).collect(Collectors.toList());
		return pals;
	}

	public ResponseEntity<PersonAnlassLinkDTO> updateEingeteilteWertungsrichter(UUID anlassId, UUID orgId,
			UUID personId, String kommentar, boolean add) throws Exception {

		PersonAnlassLink pal = getAnlassLink(anlassId, orgId, personId);
		if (add) {
			if (pal != null) {
				return ResponseEntity.badRequest().build();
			}
			Anlass anlass = this.findAnlassById(anlassId);
			Organisation organisation = organisationSrv.findOrganisationById(orgId);
			Person person = this.personSrv.findPersonById(personId);
			pal = new PersonAnlassLink();
			pal.setAktiv(true);
			pal.setAnlass(anlass);
			pal.setOrganisation(organisation);
			pal.setPerson(person);
			pal.setKommentar(kommentar);
			pal = personAnlassLinkRepository.save(pal);
			PersonAnlassLinkDTO palDTO = PersonAnlassLinkDTO.builder().anlassId(pal.getAnlass().getId())
					.organisationId(pal.getOrganisation().getId()).personId(pal.getPerson().getId()).build();
			return ResponseEntity.ok(palDTO);
		} else {
			if (pal == null) {
				return ResponseEntity.badRequest().build();
			}
			personAnlassLinkRepository.delete(pal);
			PersonAnlassLinkDTO palDTO = PersonAnlassLinkDTO.builder().anlassId(pal.getAnlass().getId())
					.organisationId(pal.getOrganisation().getId()).personId(pal.getPerson().getId()).build();
			return ResponseEntity.ok(palDTO);
		}
	}

	public PersonAnlassLink getAnlassLink(UUID anlassId, UUID orgId, UUID personId) throws Exception {
		Anlass anlass = this.findAnlassById(anlassId);
		if (anlass == null) {
		}
		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		Person person = this.personSrv.findPersonById(personId);
		if (anlass == null || organisation == null || person == null) {
			return null;
		}
		List<PersonAnlassLink> pals = personAnlassLinkRepository.findByPersonAndOrganisationAndAnlass(person,
				organisation, anlass);
		if (pals.size() > 1) {
			log.error("Elements: {}", pals.size());
			throw new Exception("too many elements");
		}
		if (pals.size() == 0) {
			return null;
		}
		return pals.get(0);
	}

	public PersonAnlassLink updateAnlassLink(PersonAnlassLink pal) {
		return personAnlassLinkRepository.save(pal);
	}

	public List<Anlass> getAnlaesse(boolean onlyAktiv) {
		List<Anlass> anlaesse = null;
		if (onlyAktiv) {
			anlaesse = anlassRepo.findByAktivOrderByStartDate(true);
		} else {
			anlaesse = anlassRepo.findAllByOrderByStartDate();
		}

		return anlaesse;
	}

	public Map<Teilnehmer, List<TeilnehmerAnlassLink>> getTeilnahmen(int jahr, UUID orgId) {
		LocalDateTime startDate = LocalDateTime.of(jahr, 1, 1, 0, 0);
		LocalDateTime endDate = LocalDateTime.of(jahr, 12, 31, 23, 59);
		List<Anlass> anlaesse = anlassRepo.findByStartDateBetweenAndAktivOrderByStartDate(startDate, endDate, true);
		Map<Teilnehmer, List<TeilnehmerAnlassLink>> teilnahmenDTOMap = new HashMap();
		anlaesse.forEach(anlass -> {
			getTeilnahmen(anlass.getId(), orgId, false).forEach(tal -> {
				if (!teilnahmenDTOMap.containsKey(tal.getTeilnehmer())) {
					List<TeilnehmerAnlassLink> tals = new ArrayList();
					tals.add(tal);
					teilnahmenDTOMap.put(tal.getTeilnehmer(), tals);
				} else {
					teilnahmenDTOMap.get(tal.getTeilnehmer()).add(tal);
				}
			});
		});
		return teilnahmenDTOMap;
	}

	public List<Anlass> getAnlaesseFiltered(int jahr, boolean nurSmQuali, TiTuEnum tiTu) {
		LocalDateTime start = LocalDateTime.parse(jahr + "-01-01T00:00:00");
		LocalDateTime end = LocalDateTime.parse(jahr + 1 + "-01-01T00:00:00");
		end = LocalDateTime.now();
//		return anlassRepo
//				.findByAktivAndSmQualiAndTiTuOrTiTuAndHoechsteKategorieEqualsAndStartDateBetweenOrderByStartDate(true,
//						nurSmQuali, tiTu, TiTuEnum.Alle, kategorie, start, end);
		TiTuEnum[] tiTus = { tiTu, TiTuEnum.Alle };
		boolean[] nurSmQualis = { true, false };
		if (nurSmQuali) {
			nurSmQualis[1] = true;
		}
		return anlassRepo
				.findByAktivTrueAndSmQualiInAndTiTuInAndHoechsteKategorieEqualsAndStartDateBetweenOrderByStartDate(
						nurSmQualis, tiTus, KategorieEnum.K7, start, end);
	}

	public List<TeilnehmerAnlassLink> getTeilnahmen(UUID anlassId, UUID orgId, boolean exclude) {
		Anlass anlass = this.findAnlassById(anlassId);
		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		List<TeilnehmerAnlassLink> teilnahmen = null;
		if (exclude) {
			List<MeldeStatusEnum> exclusion = Arrays
					.asList(new MeldeStatusEnum[] { MeldeStatusEnum.ABGEMELDET, MeldeStatusEnum.ABGEMELDET_1,
							MeldeStatusEnum.ABGEMELDET_2, MeldeStatusEnum.ABGEMELDET_3, MeldeStatusEnum.UMMELDUNG });
			teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndOrganisationExclude(anlass, organisation,
					exclusion);
		} else {
			teilnahmen = teilnehmerAnlassLinkRepository.findByAnlassAndOrganisation(anlass, organisation);
		}
		teilnahmen = teilnahmen.stream().filter(link -> {
			try {
				String name = link.getTeilnehmer().getName();
				return true;
			} catch (Exception ex) {
				return false;
			}
		}).collect(Collectors.toList());

		if (teilnahmen.size() > 0) {
			log.debug("Teilnehmer {}", teilnahmen.get(0).getKategorie());
			try {
				log.debug("Teilnehmer {}", teilnahmen.get(0).getTeilnehmer().getName());
			} catch (Exception ex) {
				log.warn("Kein Teilnehmer message: {} ", ex.getMessage());
			}
			log.debug("Teilnehmer {}", teilnahmen.get(0).getOrganisation().getName());
		}
		return teilnahmen;
	}

	public List<OrganisationAnlassLink> getOrganisationAnlassLinks() {
		List<OrganisationAnlassLink> teilnahmen = orgAnlassRepo.findAll();
		return teilnahmen;
	}

	public OrganisationAnlassLink getVereinStart(UUID anlassId, UUID orgId) {
		Anlass anlass = findAnlassById(anlassId);
		if (anlass == null) {
			return null;
		}
		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		if (organisation == null) {
			return null;
		}

		List<OrganisationAnlassLink> teilnahmen = orgAnlassRepo.findByOrganisationAndAnlass(organisation, anlass);
		if (teilnahmen != null && teilnahmen.size() >= 1) {
			// TODO Check if Date stays
			return teilnahmen.get(0);
		}
		return null;
	}

	public List<Organisation> getVereinsStarts(UUID anlassId) {
		Anlass anlass = findAnlassById(anlassId);
		if (anlass == null) {
			return new ArrayList<Organisation>();
		}
		List<OrganisationAnlassLink> orgLinks = anlass.getOrganisationenLinks();
		Set<UUID> ids = new HashSet<UUID>();
		List<Organisation> orgs = orgLinks.stream().map(orgLink -> {
			if (orgLink.isAktiv() && !ids.contains(orgLink.getOrganisation().getId())) {
				// log.debug("Verein: {}, {}", orgLink.getOrganisation().getName(),
				// orgLink.getOrganisation().getId());
				ids.add(orgLink.getOrganisation().getId());
				return orgLink.getOrganisation();
			}
			return null;
		}).filter(Objects::nonNull).collect(Collectors.toList());
		return orgs;
	}

	public Anlass findAnlassById(UUID anlassId) {
		Optional<Anlass> optAnlass = anlassRepo.findById(anlassId);
		return optAnlass.get();
	}

	public OrganisationAnlassLink updateTeilnehmendeVereine(UUID anlassId, UUID orgId, OrganisationAnlassLinkDTO oal) {

		Anlass anlass = findAnlassById(anlassId);

		Organisation organisation = organisationSrv.findOrganisationById(orgId);
		if (organisation == null) {
			return null;
		}

		List<OrganisationAnlassLink> teilnahmen = orgAnlassRepo.findByOrganisationAndAnlass(organisation, anlass);
		OrganisationAnlassLink organisationAnlassLink;
		if (teilnahmen.size() != 0) {
			organisationAnlassLink = teilnahmen.get(0);
			organisationAnlassLink.setAktiv(oal.isStartet());
			organisationAnlassLink.setAnlass(anlass);
			organisationAnlassLink.setOrganisation(organisation);
			organisationAnlassLink.setVerlaengerungsDate(oal.getVerlaengerungsDate());
		} else {
			organisationAnlassLink = new OrganisationAnlassLink();
			organisationAnlassLink.setAktiv(oal.isStartet());
			organisationAnlassLink.setAnlass(anlass);
			organisationAnlassLink.setOrganisation(organisation);
			organisationAnlassLink.setVerlaengerungsDate(oal.getVerlaengerungsDate());
		}
		organisationAnlassLink = orgAnlassRepo.save(organisationAnlassLink);

		return organisationAnlassLink;
	}

	public Anlass save(Anlass anlass) {
		return anlassRepo.save(anlass);
	}

}
