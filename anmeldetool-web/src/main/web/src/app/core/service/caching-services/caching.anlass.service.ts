import { Injectable } from "@angular/core";
import { BehaviorSubject, Observable } from "rxjs";
import { IVerein } from "src/app/verein/verein";
import { IAnlass } from "../../model/IAnlass";
import { IAnlassLink } from "../../model/IAnlassLink";
import { IAnlassLinks } from "../../model/IAnlassLinks";
import { IOrganisationAnlassLink } from "../../model/IOrganisationAnlassLink";
import { IPersonAnlassLink } from "../../model/IPersonAnlassLink";
import { ITeilnehmer } from "../../model/ITeilnehmer";
import { IUser } from "../../model/IUser";
import { IWertungsrichterEinsatz } from "../../model/IWertungsrichterEinsatz";
import { KategorieEnum } from "../../model/KategorieEnum";
import { MeldeStatusEnum } from "../../model/MeldeStatusEnum";
import { TiTuEnum } from "../../model/TiTuEnum";
import { AnlassService } from "../anlass/anlass.service";
import { CachingVereinService } from "./caching.verein.service";

export interface IHash {
  [anlassId: string]: IAnlassLinks;
}

@Injectable({
  providedIn: "root",
})
export class CachingAnlassService {
  // private teilnahmenLoaded: BehaviorSubject<boolean>;
  private teilnahmenLoaded: BehaviorSubject<boolean>;

  private anlaesseLoaded: BehaviorSubject<boolean>;

  private _loadRunning = false;

  private loaded = false;

  private anlaesse: IAnlass[];

  private teilnamen: IHash = {};

  constructor(
    private anlassService: AnlassService,
    private vereinService: CachingVereinService
  ) {
    this.anlaesseLoaded = new BehaviorSubject<boolean>(undefined);
    this.teilnahmenLoaded = new BehaviorSubject<boolean>(false);
  }
  reset(): Observable<boolean> {
    this.loaded = false;
    return this.loadAnlaesse();
  }

  getVerfuegbareWertungsrichter(
    anlass: IAnlass,
    verein: IVerein,
    brevet: number
  ): Observable<IUser[]> {
    return this.anlassService.getVerfuegbareWertungsrichter(
      anlass,
      verein,
      brevet
    );
  }
  getEingeteilteWertungsrichter(
    anlass: IAnlass,
    verein: IVerein,
    brevet: number
  ): Observable<IPersonAnlassLink[]> {
    return this.anlassService.getEingeteilteWertungsrichter(
      anlass,
      verein,
      brevet
    );
  }

  getWrEinsatz(
    anlass: IAnlass,
    verein: IVerein,
    user: IUser
  ): Observable<IPersonAnlassLink> {
    return this.anlassService.getWrEinsatz(anlass, verein, user);
  }
  updateWrEinsatz(
    verein: IVerein,
    anlassLink: IPersonAnlassLink,
    einsatz: IWertungsrichterEinsatz
  ): Observable<IWertungsrichterEinsatz> {
    return this.anlassService.updateWrEinsatz(verein, anlassLink, einsatz);
  }
  addWertungsrichterToAnlass(
    anlass: IAnlass,
    verein: IVerein,
    user: IUser
  ): Observable<IPersonAnlassLink> {
    return this.anlassService.addWertungsrichterToAnlass(anlass, verein, user);
  }
  updateAnlassLink(
    pal: IPersonAnlassLink,
    verein: IVerein
  ): Observable<IPersonAnlassLink> {
    return this.anlassService.updateAnlassLink(pal, verein);
  }

  deleteWertungsrichterFromAnlass(
    anlass: IAnlass,
    verein: IVerein,
    user: IUser
  ): Observable<IPersonAnlassLink> {
    return this.anlassService.deleteWertungsrichterFromAnlass(
      anlass,
      verein,
      user
    );
  }

  getVereinStart(
    anlass: IAnlass,
    verein: IVerein
  ): Observable<IOrganisationAnlassLink> {
    return this.anlassService.getVereinStart(anlass, verein);
  }

  getTeilnahmenForKategorie(
    anlass: IAnlass,
    katgorie: KategorieEnum
  ): IAnlassLink[] {
    const teilnahmen = this.getTeilnehmerForAnlass(anlass);
    const filteredLinks = teilnahmen.anlassLinks.filter((link) => {
      return link.kategorie === katgorie;
    });
    return filteredLinks;
  }

  getTeilnehmerForAnlassCsv(anlass: IAnlass): void {
    this.anlassService.getTeilnehmerForAnlassCsv(anlass);
  }

  importTeilnehmerForAnlassCsv(
    anlass: IAnlass,
    formData: FormData
  ): Observable<any> {
    return this.anlassService.importTeilnehmerForAnlassCsv(anlass, formData);
  }

  getBenutzerForAnlassCsv(anlass: IAnlass): void {
    this.anlassService.getBenutzerForAnlassCsv(anlass);
  }

  getWertungsrichterForAnlassCsv(anlass: IAnlass): void {
    this.anlassService.getWertungsrichterForAnlassCsv(anlass);
  }

  getTeilnehmerForAnlass(anlass: IAnlass): IAnlassLinks {
    if (this.teilnamen) {
      return this.teilnamen[anlass.id];
    }
    return undefined;
  }

  getTeilnahmenForAnlassSorted(anlass: IAnlass): IAnlassLink[] {
    if (this.teilnamen) {
      const kategories = Object.keys(KategorieEnum);
      return this.teilnamen[anlass.id].anlassLinks.sort((a, b) => {
        return this.compare(
          kategories.indexOf(a.kategorie),
          kategories.indexOf(b.kategorie),
          true
        );
      });
    }
    return undefined;
  }

  compare(a: number | string, b: number | string, isAsc: boolean) {
    return (a < b ? -1 : 1) * (isAsc ? 1 : -1);
  }

  getTeilnahme(anlass: IAnlass, teilnehmer: ITeilnehmer): IAnlassLink {
    // TODO Lade hier
    if (this.teilnamen) {
      const anlassTeilnahmen = this.getTeilnehmerForAnlass(anlass);
      if (anlassTeilnahmen && anlassTeilnahmen.anlassLinks) {
        const links = anlassTeilnahmen.anlassLinks.filter((link) => {
          // console.log("Link: ", link.teilnehmerId, ", Teiln: ", teilnehmer.id);
          return link.teilnehmerId === teilnehmer.id;
        });
        if (links && links.length > 0) {
          return links[0];
        }
      }
    }
    return undefined;
  }

  updateVereinsStart(
    orgAnlassLink: IOrganisationAnlassLink
  ): Observable<IOrganisationAnlassLink> {
    return this.anlassService.updateVereinsStart(orgAnlassLink);
  }
  isAnlaesseLoaded(): Observable<boolean> {
    return this.anlaesseLoaded.asObservable();
  }
  loadAnlaesse(): Observable<boolean> {
    if (!this._loadRunning && !this.loaded) {
      this._loadRunning = true;
      this.anlassService.getAnlaesse().subscribe((anlaesse) => {
        // this.anlaesse = anlaesse;
        this.anlaesse = anlaesse.map((anlass) => {
          anlass.organisator = this.vereinService.getVereinById(
            anlass.organisatorId
          )?.name;
          return anlass;
        });
        this._loadRunning = false;
        this.loaded = true;
        this.anlaesseLoaded.next(true);
        // console.log("Anlaesse Loaded");
      });
    } else {
      if (this.loaded) {
        // console.log("Anlaesse already loaded");
        this.anlaesseLoaded.next(true);
      }
    }
    // return this.vereineLoaded.asObservable().pipe(skip(1));
    return this.anlaesseLoaded.asObservable();
  }

  getAnlaesse(titu: TiTuEnum): IAnlass[] {
    if (this.loaded) {
      if (titu === TiTuEnum.Alle) {
        return this.anlaesse;
      }
      return this.anlaesse.filter((anlass) => {
        const key = TiTuEnum[anlass.tiTu];
        if (key === titu) {
          return true;
        }
        if (key === TiTuEnum.Alle) {
          return true;
        }
        return false;
      });
    }
    return undefined;
  }
  getAnlassById(id: string) {
    if (this.loaded) {
      return this.anlaesse.find((anlass) => anlass.id === id);
    }
    return undefined;
  }
  getAnlassByOrganisatorId(id: string) {
    if (this.loaded) {
      return this.anlaesse.find((anlass) => anlass.organisatorId === id);
    }
    return undefined;
  }
  getAnlassByAnlassBezeichnung(anlassBezeichnung: string, titu: string) {
    if (this.loaded) {
      return this.anlaesse.find(
        (anlass) =>
          anlass.anlassBezeichnung === anlassBezeichnung && anlass.tiTu === titu
      );
    }
    return undefined;
  }

  neuAnmeldungErlaubt(anlass: IAnlass): boolean {
    const anlassLinks: IAnlassLinks = this.teilnamen[anlass.id];
    const anzahlUmmeldungen = anlassLinks.anlassLinks.filter((link) => {
      const isUmmeldung = link.meldeStatus === MeldeStatusEnum.UMMELDUNG;
      return isUmmeldung;
    }).length;
    const neuMeldungen = anlassLinks.anlassLinks.filter((link) => {
      return link.meldeStatus === MeldeStatusEnum.NEUMELDUNG;
    }).length;
    return anzahlUmmeldungen > neuMeldungen;
  }
  neuAnmeldungErlaubtKategorie(
    anlass: IAnlass,
    kategorie: KategorieEnum
  ): boolean {
    const anlassLinks: IAnlassLinks = this.teilnamen[anlass.id];
    const anzahlUmmeldungen = anlassLinks.anlassLinks.filter((link) => {
      const sameKat = link.kategorie === kategorie;
      const isUmmeldung = link.meldeStatus === MeldeStatusEnum.UMMELDUNG;
      return sameKat && isUmmeldung;
    }).length;
    const neuMeldungen = anlassLinks.anlassLinks.filter((link) => {
      return link.meldeStatus === MeldeStatusEnum.NEUMELDUNG;
    }).length;
    return anzahlUmmeldungen > neuMeldungen;
  }
  loadTeilnahmen(
    anlass: IAnlass,
    verein: IVerein,
    isLast: boolean
  ): Observable<boolean> {
    this.anlassService
      .getTeilnehmer(anlass, verein)
      .subscribe((anlassLinkArray) => {
        const anlassLinks: IAnlassLinks = {
          dirty: false,
          anlassLinks: anlassLinkArray,
        };
        if (anlassLinks) {
          anlassLinks.anlassLinks.forEach((al) => {
            if (
              al.kategorie === "KEIN_START" ||
              al.kategorie === undefined ||
              al.kategorie === null
            ) {
              al.kategorie = KategorieEnum.KEINE_TEILNAHME;
            }
          });
        }
        this.teilnamen[anlass.id] = anlassLinks;
        // Fuer jeden Anlass ein Observable
        // console.log("Teilnahme loaded: ", anlass.anlassBezeichnung, ' Verein: ', verein.name, ' isLast: ', isLast);
        if (isLast) {
          this.teilnahmenLoaded.next(true);
        }
      });
    return this.teilnahmenLoaded.asObservable();
  }
  isTeilnahmenLoaded(): Observable<boolean> {
    return this.teilnahmenLoaded.asObservable();
  }

  public getTeilnahmen(anlass: IAnlass, brevet: number) {
    const teilnahmen = this.getTeilnehmerForAnlass(anlass);
    if (teilnahmen && teilnahmen.anlassLinks) {
      if (brevet === 1) {
        return teilnahmen.anlassLinks.filter((einzel) => {
          return (
            einzel.kategorie === KategorieEnum.K1 ||
            einzel.kategorie === KategorieEnum.K2 ||
            einzel.kategorie === KategorieEnum.K3 ||
            einzel.kategorie === KategorieEnum.K4
          );
        });
      } else {
        return teilnahmen.anlassLinks.filter((einzel) => {
          return (
            einzel.kategorie !== KategorieEnum.K1 &&
            einzel.kategorie !== KategorieEnum.K2 &&
            einzel.kategorie !== KategorieEnum.K3 &&
            einzel.kategorie !== KategorieEnum.K4 &&
            einzel.kategorie !== KategorieEnum.KEINE_TEILNAHME
          );
        });
      }
    } else {
      return new Array();
    }
  }
  saveTeilnahme(verein: IVerein, anlassLink: IAnlassLink): Observable<boolean> {
    return this.anlassService.saveTeilnahme(verein, anlassLink);
  }
}
