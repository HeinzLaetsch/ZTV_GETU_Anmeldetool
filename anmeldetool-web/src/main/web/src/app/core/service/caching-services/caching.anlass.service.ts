import { Injectable } from '@angular/core';
import { Subject, Observable, of, BehaviorSubject, Subscription } from 'rxjs';
import { IVerein } from 'src/app/verein/verein';
import { IAnlass } from '../../model/IAnlass';
import { IAnlassLinks } from '../../model/IAnlassLinks';
import { AnlassService } from '../anlass/anlass.service';

export interface IHash {
  [anlassId: string]: IAnlassLinks;
}

@Injectable({
  providedIn: 'root'
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
  getVereinStart(anlass: IAnlass, verein: IVerein): Observable<boolean> {
    return this.anlassService.getVereinStart(anlass, verein);
  }
  getTeilnehmer(anlass: IAnlass) {
    if (this.teilnamen) {
      return this.teilnamen[anlass.id];
    }
    return undefined;
  }
  updateVereinsStart(anlass: IAnlass, verein: IVerein, started: boolean): Observable<boolean> {
    return this.anlassService.updateVereinsStart(anlass, verein, started);
  }
  isAnlaesseLoaded(): Observable<boolean> {
    return this.anlaesseLoaded.asObservable();
  }
  loadAnlaesse(): Observable<boolean> {
    if (!this._loadRunning && !this.loaded) {
      this._loadRunning = true;
      this.anlassService.getAnlaesse().subscribe(anlaesse => {
        this.anlaesse = anlaesse;
        this._loadRunning = false;
        this.loaded = true
        this.anlaesseLoaded.next(true);
        console.log('Anlaesse Loaded');
      });
    } else {
      if (this.loaded) {
        console.log('Anlaesse already loaded');
        this.anlaesseLoaded.next(true);
      }
    }
    // return this.vereineLoaded.asObservable().pipe(skip(1));
    return this.anlaesseLoaded.asObservable();
  }

  getAnlaesse(): IAnlass[] {
    if (this.loaded) {
      return this.anlaesse;
    }
    return undefined;
  }
  getAnlassById(id: string) {
    if (this.loaded) {
      return this.anlaesse.find(verein => verein.id = id);
    }
    return undefined;
  }
  loadTeilnahmen(anlass: IAnlass, verein: IVerein, isLast: boolean): Observable<boolean> {
    this.anlassService.getTeilnehmer(anlass, verein).subscribe(anlassLinkArray => {
      const anlassLinks: IAnlassLinks = {
        dirty: false,
        anlassLinks: anlassLinkArray
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
}
