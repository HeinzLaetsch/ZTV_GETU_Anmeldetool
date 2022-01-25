import { Injectable } from "@angular/core";
import { MatPaginator } from "@angular/material/paginator";
import { Sort } from "@angular/material/sort";
import { BehaviorSubject, forkJoin, Observable, of } from "rxjs";
import { tap } from "rxjs/operators";
import { IVerein } from "src/app/verein/verein";
import { ITeilnehmer } from "../../model/ITeilnehmer";
import { KategorieEnum } from "../../model/KategorieEnum";
import { TiTuEnum } from "../../model/TiTuEnum";
import { TeilnehmerService } from "../teilnehmer/teilnehmer.service";
import { CachingAnlassService } from "./caching.anlass.service";

@Injectable({
  providedIn: "root",
})
export class CachingTeilnehmerService {
  private teilnehmerLoaded: BehaviorSubject<number>;
  // private teilnehmerLoaded: Subject<number>;

  private _loadRunning = false;

  private loaded = false;

  public dirty = false;

  public valid = true;

  private teilnehmer: ITeilnehmer[];
  // private orgUsers: IUser[];

  private oldSort: Sort;
  private sortedTeilnehmer: ITeilnehmer[];

  private oldFilter: string;
  private filteredTeilnehmer: ITeilnehmer[];

  constructor(
    private teilnehmerService: TeilnehmerService,
    private anlassService: CachingAnlassService
  ) {
    this.teilnehmerLoaded = new BehaviorSubject<number>(undefined);
    // this.teilnehmerLoaded = new Subject<number>();
  }
  reset(verein: IVerein): Observable<boolean[]> {
    this.loaded = false;
    this.dirty = false;
    this.valid = true;
    const observables = new Array<Observable<boolean>>();
    this.teilnehmer.forEach((teilnehmer) => {
      if (teilnehmer.onlyCreated) {
        observables.push(this.teilnehmerService.delete(verein, teilnehmer));
      }
    });
    if (observables.length === 0) {
      return of([true]);
    } else {
      return forkJoin(observables);
    }
    // return this.loadTeilnehmer(verein);
  }

  isTeilnehmerLoaded(): Observable<number> {
    return this.teilnehmerLoaded.asObservable();
  }

  loadTeilnehmer(verein: IVerein): Observable<number> {
    // console.log("Teilnehmer Caching loadTeilnehmer: ", verein.name);
    if (!this._loadRunning && !this.loaded) {
      this._loadRunning = true;
      // verein: IVerein, filter = '',  sortDirection = 'asc', pageIndex = 0, pageSize = 3
      this.teilnehmerService
        .getTeilnehmer(verein, "", "asc", 0, 150)
        .subscribe((teilnehmer) => {
          this.teilnehmer = teilnehmer;
          // this.orgUsers = users;
          // this.users = this.deepCopy(users);
          this._loadRunning = false;
          this.loaded = true;
          this.dirty = false;
          this.valid = true;
          this.teilnehmerLoaded.next(teilnehmer.length);
          // console.log("Teilnehmer Loaded: ", teilnehmer.length);
        });
    } else {
      if (this.loaded) {
        this.teilnehmerLoaded.next(this.teilnehmer.length);
      }
    }
    return this.teilnehmerLoaded.asObservable();
  }
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
    const tituFiltered = this.teilnehmer.filter((teilnehmer) => {
      const key = TiTuEnum[teilnehmer.tiTu];
      return key === tiTu;
    });
    return tituFiltered;
  }

  deleteTeilnehmer(
    verein: IVerein,
    teilnehmer: ITeilnehmer
  ): Observable<boolean> {
    this.removeTeilnehmer(teilnehmer);
    return this.teilnehmerService.delete(verein, teilnehmer);
  }
  delete(
    verein: IVerein,
    filter: string,
    sort: Sort,
    tiTu: TiTuEnum,
    paginator: MatPaginator,
    row: number
  ): Observable<boolean> {
    const teilnehmer = this.getTeilnehmer(
      filter,
      sort,
      tiTu,
      paginator,
      undefined
    )[row];
    this.removeTeilnehmer(teilnehmer);
    return this.teilnehmerService.delete(verein, teilnehmer);
  }

  removeTeilnehmer(searchTeilnehmer: ITeilnehmer) {
    const index = this.teilnehmer.indexOf(searchTeilnehmer);
    const removed = this.teilnehmer.splice(index, 1);
    // console.log("Finished: ", index, " , ", removed);
  }
  getTeilnehmer(
    filter: string,
    sort: Sort,
    tiTu: TiTuEnum,
    paginator: MatPaginator,
    previousIndex: number
  ): ITeilnehmer[] {
    if (this.loaded) {
      // console.log('Vereins User: ' , this.users);
      let index = paginator.pageIndex;
      if (previousIndex !== undefined) {
        index = previousIndex;
      }
      const start = paginator.pageSize * index;
      let end = paginator.pageSize * (index + 1);
      if (paginator.length > 0 && end > paginator.length) {
        end = paginator.length;
      }
      let tituFiltered = this.getTiTuTeilnehmer(tiTu);
      tituFiltered = this.filterByName(filter, tituFiltered);
      tituFiltered = this.sortBySort(tituFiltered, sort);
      const paged = tituFiltered.slice(start, end);
      return paged;
    }
    return undefined;
  }

  private sortBySort(tituFiltered: ITeilnehmer[], sort: Sort): ITeilnehmer[] {
    if (!sort) {
      this.oldSort = sort;
      return tituFiltered;
    }
    if (this.oldSort === sort) {
      return this.sortedTeilnehmer;
    }
    this.oldSort = sort;
    console.log("Sort: ", sort.active);
    const isAsc = sort.direction === "asc";
    const anlass = this.anlassService.getAnlassById(sort.active);

    this.sortedTeilnehmer = tituFiltered.sort((a, b) => {
      switch (sort.active) {
        case "name":
          return this.compare(a.name, b.name, isAsc);
        case "vorname":
          return this.compare(a.vorname, b.vorname, isAsc);
        case "jahrgang":
          return this.compare(a.jahrgang, b.jahrgang, isAsc);
        case "stvnummer":
          return this.compare(a.stvNummer, b.stvNummer, isAsc);
        default:
          const aLink = this.anlassService.getTeilnehmer(anlass, a);
          const bLink = this.anlassService.getTeilnehmer(anlass, b);
          if (!aLink) {
            if (bLink) {
              return 1;
            }
            return 0;
          }
          if (!bLink) {
            if (aLink) {
              return -1;
            }
            return 0;
          }
          const kategories = Object.keys(KategorieEnum);
          return this.compare(
            kategories.indexOf(aLink.kategorie),
            kategories.indexOf(bLink.kategorie),
            isAsc
          );
      }
    });
    return this.sortedTeilnehmer;
  }

  compare(a: number | string, b: number | string, isAsc: boolean) {
    return (a < b ? -1 : 1) * (isAsc ? 1 : -1);
  }

  private filterByName(
    filter: string,
    teilnehmer: ITeilnehmer[]
  ): ITeilnehmer[] {
    if (!filter || filter.length === 0) {
      this.oldFilter = filter;
      return teilnehmer;
    }
    if (this.oldFilter === filter) {
      return this.filteredTeilnehmer;
    }
    this.oldFilter = filter;
    this.filteredTeilnehmer = teilnehmer.filter((teilnehmer) => {
      if (teilnehmer.name.toLowerCase().indexOf(filter) > -1) {
        return true;
      }
      if (teilnehmer.vorname.toLowerCase().indexOf(filter) > -1) {
        return true;
      }
      return false;
    });
    return this.filteredTeilnehmer;
  }

  getTeilnehmerById(id: string) {
    if (this.loaded) {
      const newTeilnehmer = this.teilnehmer.find(
        (newTeilnehmer) => newTeilnehmer.id === id
      );
      // console.log('Org: ' , newUser, ' , alle: ' , this.orgUsers);
      const copy = this.deepCopy(newTeilnehmer);
      // console.log('Copy: ' , copy);
      return copy;
    }
    return undefined;
  }

  add(verein: IVerein, titu: TiTuEnum): Observable<ITeilnehmer> {
    return this.teilnehmerService.add(verein, titu).pipe(
      tap((teilnehmer) => {
        teilnehmer.onlyCreated = true;
        this.teilnehmer.push(teilnehmer);
        this.dirty = true;
        console.log("From Tap:", teilnehmer);
      })
    );
  }

  saveAll(verein: IVerein): Observable<any[]> {
    const observables = new Array<Observable<any>>();
    this.teilnehmer.forEach((teilnehmer) => {
      if (teilnehmer.dirty) {
        teilnehmer.dirty = false;
        teilnehmer.onlyCreated = false;
        this.dirty = false;
        observables.push(this.teilnehmerService.save(verein, teilnehmer));
      }
      if (
        teilnehmer.teilnahmen &&
        teilnehmer.teilnahmen.anlassLinks &&
        teilnehmer.teilnahmen.dirty
      ) {
        teilnehmer.teilnahmen.anlassLinks.forEach((value) => {
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
