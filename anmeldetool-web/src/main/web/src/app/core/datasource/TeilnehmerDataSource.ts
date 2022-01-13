import { CollectionViewer } from "@angular/cdk/collections";
import { DataSource } from "@angular/cdk/table";
import { MatPaginator } from "@angular/material/paginator";
import { Sort } from "@angular/material/sort";
import { BehaviorSubject, Observable, Subscription } from "rxjs";
import { IVerein } from "src/app/verein/verein";
import { IAnlass } from "../model/IAnlass";
import { IAnlassLink } from "../model/IAnlassLink";
import { IAnlassLinks } from "../model/IAnlassLinks";
import { ITeilnehmer } from "../model/ITeilnehmer";
import { KategorieEnum } from "../model/KategorieEnum";
import { TiTuEnum } from "../model/TiTuEnum";
import { CachingTeilnehmerService } from "../service/caching-services/caching.teilnehmer.service";

export class TeilnehmerDataSource implements DataSource<ITeilnehmer> {
  private teilnehmerSubject = new BehaviorSubject<ITeilnehmer[]>([]);
  // private teilnehmerSubject = new Subject<ITeilnehmer[]>();
  // private loadingSubject = new BehaviorSubject<boolean>(false);

  public paginator: MatPaginator;
  // public sort: MatSort;
  sortValue: Sort;
  public filter: string;
  private loadTeilnehmerSub: Subscription;

  // public loading$ = this.loadingSubject.asObservable();

  constructor(
    private teilnehmerService: CachingTeilnehmerService,
    private verein: IVerein
  ) {}

  connect(collectionViewer: CollectionViewer): Observable<ITeilnehmer[]> {
    return this.teilnehmerSubject.asObservable();
  }

  disconnect(collectionViewer: CollectionViewer): void {
    this.teilnehmerSubject.complete();
    // this.loadingSubject.complete();
  }

  getTeilnehmer(filter: string, tiTu: TiTuEnum, row: number): ITeilnehmer {
    return this.teilnehmerService.getTeilnehmer(
      filter,
      this.sortValue,
      tiTu,
      this.paginator,
      undefined
    )[row];
  }

  loadTeilnehmer(filter: string, tiTu: TiTuEnum): Observable<ITeilnehmer[]> {
    if (this.loadTeilnehmerSub) {
      this.loadTeilnehmerSub.unsubscribe();
    }
    this.loadTeilnehmerSub = this.teilnehmerService
      .loadTeilnehmer(this.verein)
      .subscribe((result) => {
        // console.log("Load Teilnehmer: ", result);
        const loadedTeilnehmer = this.teilnehmerService.getTeilnehmer(
          filter,
          this.sortValue,
          tiTu,
          this.paginator,
          undefined
        );
        this.teilnehmerSubject.next(loadedTeilnehmer);
        this.paginator.length =
          this.teilnehmerService.getTiTuTeilnehmer(tiTu).length;
      });
    return this.teilnehmerSubject.asObservable();
    /*
    return this.teilnehmerService.getTeilnehmer(
      filter,
      this.sortValue,
      tiTu,
      this.paginator,
      undefined
    );
    */
  }

  delete(filter: string, tiTu: TiTuEnum, row: number): Observable<boolean> {
    return this.teilnehmerService.delete(
      this.verein,
      filter,
      this.sortValue,
      tiTu,
      this.paginator,
      row
    );
  }

  // pageEvent: PageEvent,
  update(
    filter: string,
    tiTu: TiTuEnum,
    previousIndex: number,
    row: number,
    col: number,
    value: any
  ) {
    // const effRow = pageEvent.previousPageIndex * this.paginator.pageSize + row;
    if (
      !this.teilnehmerService.getTeilnehmer(
        filter,
        this.sortValue,
        tiTu,
        this.paginator,
        previousIndex
      )
    ) {
      console.log("Empty");
    }
    switch (col) {
      case 0: {
        this.teilnehmerService.getTeilnehmer(
          filter,
          this.sortValue,
          tiTu,
          this.paginator,
          previousIndex
        )[row].name = value;
        break;
      }
      case 1: {
        this.teilnehmerService.getTeilnehmer(
          filter,
          this.sortValue,
          tiTu,
          this.paginator,
          previousIndex
        )[row].vorname = value;
        break;
      }
      case 2: {
        this.teilnehmerService.getTeilnehmer(
          filter,
          this.sortValue,
          tiTu,
          this.paginator,
          previousIndex
        )[row].jahrgang = value;
        break;
      }
      case 3: {
        this.teilnehmerService.getTeilnehmer(
          filter,
          this.sortValue,
          tiTu,
          this.paginator,
          previousIndex
        )[row].stvNummer = value;
        break;
      }
    }
    this.teilnehmerService.getTeilnehmer(
      filter,
      this.sortValue,
      tiTu,
      this.paginator,
      previousIndex
    )[row].dirty = true;
  }
  updateTeilnahme(
    filter: string,
    tiTu: TiTuEnum,
    row: number,
    col: number,
    value: any,
    anlass: IAnlass
  ) {
    // const effRow = pageEvent.previousPageIndex * this.paginator.pageSize + row;
    if (
      !this.teilnehmerService.getTeilnehmer(
        filter,
        this.sortValue,
        tiTu,
        this.paginator,
        undefined
      )
    ) {
      console.log("Empty");
    }
    const teilnehmer = this.teilnehmerService.getTeilnehmer(
      filter,
      this.sortValue,
      tiTu,
      this.paginator,
      undefined
    )[row];
    if (!teilnehmer.teilnahmen) {
      const teilnahmen: IAnlassLinks = {
        dirty: true,
        anlassLinks: new Array<IAnlassLink>(),
      };
      teilnehmer.teilnahmen = teilnahmen;
    }
    const links = teilnehmer.teilnahmen; // [col] = value;
    const filtered = links.anlassLinks.filter((link) => {
      return link.anlassId === anlass.id;
    });
    links.dirty = true;
    let corrected = value;
    if (value === KategorieEnum.KEINE_TEILNAHME) {
      corrected = "KEIN_START";
    }
    if (filtered.length > 0) {
      filtered[0].kategorie = corrected;
      filtered[0].dirty = true;
    } else {
      const newLink: IAnlassLink = {
        anlassId: anlass.id,
        teilnehmerId: teilnehmer.id,
        kategorie: corrected,
        dirty: true,
      };
      links.anlassLinks.push(newLink);
    }
  }

  reset(verein: IVerein): Observable<any> {
    // console.log("Reset");
    return this.teilnehmerService.reset(verein);
  }

  add(verein: IVerein, titu: TiTuEnum): Observable<ITeilnehmer> {
    console.log("Add");
    return this.teilnehmerService.add(verein, titu);
  }
  set dirty(dirty: boolean) {
    this.teilnehmerService.dirty = dirty;
  }
  get dirty(): boolean {
    return this.teilnehmerService.dirty;
  }
  set valid(valid: boolean) {
    // console.log('set Valid: ', valid);
    this.teilnehmerService.valid = valid;
  }
  get valid(): boolean {
    // console.log('get Valid: ', this.teilnehmerService.valid);
    return this.teilnehmerService.valid;
  }
  saveAll(verein: IVerein): Observable<ITeilnehmer[]> {
    return this.teilnehmerService.saveAll(verein);
  }
  sort(sort: Sort) {
    this.sortValue = sort;
  }
}
