import { CollectionViewer } from "@angular/cdk/collections";
import { DataSource } from "@angular/cdk/table";
import { MatPaginator, PageEvent } from "@angular/material/paginator";
import { MatSort } from "@angular/material/sort";
import { BehaviorSubject, Observable, of, Subject } from "rxjs";
import { catchError, finalize, tap } from "rxjs/operators";
import { IVerein } from "src/app/verein/verein";
import { IAnlass } from "../model/IAnlass";
import { IAnlassLink } from "../model/IAnlassLink";
import { IAnlassLinks } from "../model/IAnlassLinks";
import { ITeilnehmer } from "../model/ITeilnehmer";
import { TiTuEnum } from "../model/TiTuEnum";
import { CachingTeilnehmerService } from "../service/caching-services/caching.teilnehmer.service";

export class TeilnehmerDataSource implements DataSource<ITeilnehmer> {
  private teilnehmerSubject = new BehaviorSubject<ITeilnehmer[]>([]);
  private loadingSubject = new BehaviorSubject<boolean>(false);

  public paginator: MatPaginator;
  public sort: MatSort;
  public filter: string;

  public loading$ = this.loadingSubject.asObservable();

  constructor(private teilnehmerService: CachingTeilnehmerService, private verein: IVerein) { }

  connect(collectionViewer: CollectionViewer): Observable<ITeilnehmer[]> {
    return this.teilnehmerSubject.asObservable();
  }

  disconnect(collectionViewer: CollectionViewer): void {
    this.teilnehmerSubject.complete();
    this.loadingSubject.complete();
  }

  getTeilnehmer(filter: string, tiTu: TiTuEnum, row: number): ITeilnehmer {
    return this.teilnehmerService.getTeilnehmer(filter, tiTu, this.paginator)[row];
  }

  loadTeilnehmer(filter: string, tiTu: TiTuEnum): ITeilnehmer[] {
    this.teilnehmerService.loadTeilnehmer(this.verein).subscribe(result => {
      const loadedTeilnehmer = this.teilnehmerService.getTeilnehmer(filter, tiTu, this.paginator);
      this.teilnehmerSubject.next(loadedTeilnehmer);
      this.paginator.length = this.teilnehmerService.getTiTuTeilnehmer(tiTu).length;
    })
    return this.teilnehmerService.getTeilnehmer(filter,tiTu, this.paginator);
  }

  // pageEvent: PageEvent,
  update(filter: string, tiTu: TiTuEnum, row: number, col: number, value: any) {
    // const effRow = pageEvent.previousPageIndex * this.paginator.pageSize + row;
    if (!this.teilnehmerService.getTeilnehmer(filter, tiTu, this.paginator)) {
      console.log('Empty');
    }
    console.log('Update row: ', row, ', old: ', this.teilnehmerService.getTeilnehmer(filter, tiTu, this.paginator)[row], ', new: ', value);
    switch (col) {
      case 0: {
        this.teilnehmerService.getTeilnehmer(filter, tiTu, this.paginator)[row].name = value;
        break;
      }
      case 1: {
        this.teilnehmerService.getTeilnehmer(filter, tiTu, this.paginator)[row].vorname = value;
        break;
      }
      case 2: {
        this.teilnehmerService.getTeilnehmer(filter, tiTu, this.paginator)[row].jahrgang = value;
        break;
      }
    }
    this.teilnehmerService.getTeilnehmer(filter, tiTu, this.paginator)[row].dirty = true;
  }
  updateTeilnahme(filter: string, tiTu: TiTuEnum, row: number, col: number, value: any, anlass: IAnlass) {
    // const effRow = pageEvent.previousPageIndex * this.paginator.pageSize + row;
    if (!this.teilnehmerService.getTeilnehmer(filter, tiTu, this.paginator)) {
      console.log('Empty');
    }
    console.log('Update Teilnahmen row: ', row, ', old: ', this.teilnehmerService.getTeilnehmer(filter, tiTu, this.paginator)[row], ', new: ', value);
    const teilnehmer = this.teilnehmerService.getTeilnehmer(filter, tiTu, this.paginator)[row];
    if (!teilnehmer.teilnahmen) {
      const teilnahmen: IAnlassLinks = {
        dirty: true,
        anlassLinks: new Array<IAnlassLink>()
      };
      teilnehmer.teilnahmen = teilnahmen;
    }
    const links = teilnehmer.teilnahmen; // [col] = value;
    const filtered = links.anlassLinks.filter(link => {
      return link.anlassId === anlass.id
    });
    links.dirty = true;
    if (filtered.length > 0) {
      filtered[0].kategorie = value;
      filtered[0].dirty = true;
    } else {
      const newLink: IAnlassLink = {
        anlassId: anlass.id,
        teilnehmerId: teilnehmer.id,
        kategorie: value,
        dirty: true
      }
      links.anlassLinks.push(newLink);
    }
  }


  /*getTotal() {
    return this.teilnehmerService.anzahlTeilnehmer
  }*/

  reset(verein: IVerein) {
    console.log('Reset');
    this.teilnehmerService.reset(verein);
  }

  add(verein: IVerein): Observable<ITeilnehmer> {
    console.log('Add');
    return this.teilnehmerService.add(verein);
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
}
