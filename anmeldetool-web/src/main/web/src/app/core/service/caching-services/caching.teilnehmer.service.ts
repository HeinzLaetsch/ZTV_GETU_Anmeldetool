import { FocusKeyManager } from "@angular/cdk/a11y";
import { Injectable } from "@angular/core";
import { MatPaginator } from "@angular/material/paginator";
import { EventEmitter } from "events";
import { Observable, BehaviorSubject, Subject, forkJoin, of } from "rxjs";
import { reduce, tap } from "rxjs/operators";
import { IVerein } from "src/app/verein/verein";
import { ITeilnehmer } from "../../model/ITeilnehmer";
import { TiTuEnum } from "../../model/TiTuEnum";
import { AnlassService } from "../anlass/anlass.service";
import { TeilnehmerService } from "../teilnehmer/teilnehmer.service";

@Injectable({
  providedIn: "root",
})
export class CachingTeilnehmerService {
  private teilnehmerLoaded: BehaviorSubject<number>;

  private _loadRunning = false;

  private loaded = false;

  public dirty = false;

  public valid = true;

  private teilnehmer: ITeilnehmer[];
  // private orgUsers: IUser[];

  constructor(private teilnehmerService: TeilnehmerService, private anlassService: AnlassService) {
    this.teilnehmerLoaded = new BehaviorSubject<number>(undefined);
  }
  reset(verein: IVerein): Observable<number> {
    this.loaded = false;
    this.dirty = false;
    this.valid = true
    return this.loadTeilnehmer(verein);
  }

  isTeilnehmerLoaded(): Observable<number> {
    return this.teilnehmerLoaded.asObservable();
  }

  loadTeilnehmer(verein: IVerein): Observable<number> {
    console.log('Teilnehmer Caching loadTeilnehmer');
    if (!this._loadRunning && !this.loaded) {
      this._loadRunning = true;
      // verein: IVerein, filter = '',  sortDirection = 'asc', pageIndex = 0, pageSize = 3
      this.teilnehmerService.getTeilnehmer(verein, '', 'asc', 0, 150).subscribe((teilnehmer) => {
        this.teilnehmer = teilnehmer;
        // this.orgUsers = users;
        // this.users = this.deepCopy(users);
        this._loadRunning = false;
        this.loaded = true;
        this.dirty = false;
        this.valid = true;
        this.teilnehmerLoaded.next(teilnehmer.length);
        console.log("Teilnehmer Loaded");
      });
    } else {
      if (this.loaded) {
        this.teilnehmerLoaded.next(this.teilnehmer.length);
      }
    }
    return this.teilnehmerLoaded.asObservable();
  }
  /*
    private copyTeilnehmer(teilnehmer: ITeilnehmer[]): ITeilnehmer[] {
      return teilnehmer.map((teilnehmer) => {
        console.log("Orginal 1: ", teilnehmer);
        const userCopy: ITeilnehmer = Object.assign(teilnehmer);
        userCopy.benutzername = userCopy.benutzername + "_copy";
        console.log("Clone: ", userCopy);
        console.log("Orginal 2: ", user);
        return userCopy;
      });
    }
    */
  //public static
  private deepCopy<T>(source: T): T {
    return Array.isArray(source)
      ? source.map((item) => this.deepCopy(item))
      : source instanceof Date
        ? new Date(source.getTime())
        : source && typeof source === "object"
          ? Object.getOwnPropertyNames(source).reduce((o, prop) => {
            Object.defineProperty(
              o,
              prop,
              Object.getOwnPropertyDescriptor(source, prop)
            );
            o[prop] = this.deepCopy(source[prop]);
            return o;
          }, Object.create(Object.getPrototypeOf(source)))
          : (source as T);
  }
  getTiTuTeilnehmer(tiTu: TiTuEnum): ITeilnehmer[] {
    const tituFiltered = this.teilnehmer.filter(teilnehmer => {
      const key = TiTuEnum[teilnehmer.tiTu];
      return key === tiTu;
    });
    return tituFiltered;
  }

  getTeilnehmer(tiTu: TiTuEnum, paginator: MatPaginator): ITeilnehmer[] {
    if (this.loaded) {
      // console.log('Vereins User: ' , this.users);
      const start = paginator.pageSize * paginator.pageIndex;
      let end = paginator.pageSize * (paginator.pageIndex + 1);
      if (paginator.length > 0 && end > paginator.length) {
        end = paginator.length;
      }
      const tituFiltered = this.getTiTuTeilnehmer(tiTu);
      const paged = tituFiltered.slice(start, end);
      return paged;
    }
    return undefined;
  }

  getTeilnehmerById(id: string) {
    if (this.loaded) {
      const newTeilnehmer = this.teilnehmer.find((newTeilnehmer) => newTeilnehmer.id === id);
      // console.log('Org: ' , newUser, ' , alle: ' , this.orgUsers);
      const copy = this.deepCopy(newTeilnehmer);
      // console.log('Copy: ' , copy);
      return copy;
    }
    return undefined;
  }

  add(verein: IVerein): Observable<ITeilnehmer> {
    /*
    const newTeilnehmerObs = new Subject<ITeilnehmer>();
    this.teilnehmerService.add(verein).subscribe( teilnehmer => {
      this.teilnehmer.push(teilnehmer);
      this.dirty = true;
      newTeilnehmerObs.next(teilnehmer);
    })
    */
    return this.teilnehmerService.add(verein).pipe(
      tap(teilnehmer => {
        this.teilnehmer.push(teilnehmer);
        this.dirty = true;
        console.log('From Tap:', teilnehmer)
        // newTeilnehmerObs.next(teilnehmer);
      }));
    // return newTeilnehmerObs;
  }

  saveAll(verein: IVerein): Observable<any[]> {
    const observables = new Array<Observable<any>>();
    this.teilnehmer.forEach(teilnehmer => {
      if (teilnehmer.dirty) {
        teilnehmer.dirty = false;
        this.dirty = false;
        observables.push(this.teilnehmerService.save(verein, teilnehmer));
      }
      if (teilnehmer.teilnahmen && teilnehmer.teilnahmen.anlassLinks && teilnehmer.teilnahmen.dirty) {
        teilnehmer.teilnahmen.anlassLinks.forEach(value => {
          if (value.dirty) {
            observables.push(this.anlassService.saveTeilnahme(verein, value));
            value.dirty = false;
          }
        });
        teilnehmer.teilnahmen.dirty = false;
      }
    });
    return forkJoin(observables);
  }

  // alternative to arr.flat()
  private flat<T>(arr: T[][]): T[] {
    return arr.reduce((acc, val) => acc.concat(val), []);
  }
}
