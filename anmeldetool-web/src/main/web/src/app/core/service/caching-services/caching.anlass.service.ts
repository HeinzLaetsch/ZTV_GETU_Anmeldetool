import { Injectable } from "@angular/core";
import { BehaviorSubject, Observable } from "rxjs";
import { IVerein } from "src/app/verein/verein";
import { IAnlass } from "../../model/IAnlass";
import { IAnlassLink } from "../../model/IAnlassLink";
import { IAnlassLinks } from "../../model/IAnlassLinks";
import { ITeilnehmer } from "../../model/ITeilnehmer";
import { IUser } from "../../model/IUser";
import { IWertungsrichterAnlassLink } from "../../model/IWertungsrichterAnlassLink";
import { KategorieEnum } from "../../model/KategorieEnum";
import { TiTuEnum } from "../../model/TiTuEnum";
import { AnlassService } from "../anlass/anlass.service";

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

  constructor(private anlassService: AnlassService) {
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
  ): Observable<IWertungsrichterAnlassLink[]> {
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
  ): Observable<IWertungsrichterAnlassLink> {
    return this.anlassService.getWrEinsatz(anlass, verein, user);
  }

  addWertungsrichterToAnlass(
    anlass: IAnlass,
    verein: IVerein,
    user: IUser
  ): Observable<IWertungsrichterAnlassLink> {
    return this.anlassService.addWertungsrichterToAnlass(anlass, verein, user);
  }

  deleteWertungsrichterFromAnlass(
    anlass: IAnlass,
    verein: IVerein,
    user: IUser
  ): Observable<IWertungsrichterAnlassLink> {
    return this.anlassService.deleteWertungsrichterFromAnlass(
      anlass,
      verein,
      user
    );
  }

  getVereinStart(anlass: IAnlass, verein: IVerein): Observable<boolean> {
    return this.anlassService.getVereinStart(anlass, verein);
  }

  getTeilnehmerForAnlass(anlass: IAnlass): IAnlassLinks {
    if (this.teilnamen) {
      return this.teilnamen[anlass.id];
    }
    return undefined;
  }

  getTeilnehmer(anlass: IAnlass, teilnehmer: ITeilnehmer): IAnlassLink {
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
    anlass: IAnlass,
    verein: IVerein,
    started: boolean
  ): Observable<boolean> {
    return this.anlassService.updateVereinsStart(anlass, verein, started);
  }
  isAnlaesseLoaded(): Observable<boolean> {
    return this.anlaesseLoaded.asObservable();
  }
  loadAnlaesse(): Observable<boolean> {
    if (!this._loadRunning && !this.loaded) {
      this._loadRunning = true;
      this.anlassService.getAnlaesse().subscribe((anlaesse) => {
        this.anlaesse = anlaesse;
        this._loadRunning = false;
        this.loaded = true;
        this.anlaesseLoaded.next(true);
        console.log("Anlaesse Loaded");
      });
    } else {
      if (this.loaded) {
        console.log("Anlaesse already loaded");
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
            einzel.kategorie !== KategorieEnum.K4
          );
        });
      }
    } else {
      return new Array();
    }
  }
}
