import { CollectionViewer } from "@angular/cdk/collections";
import { DataSource } from "@angular/cdk/table";
import { MatPaginator, PageEvent } from "@angular/material/paginator";
import { MatSort } from "@angular/material/sort";
import { BehaviorSubject, Observable, of, Subject } from "rxjs";
import { catchError, finalize, tap } from "rxjs/operators";
import { IVerein } from "src/app/verein/verein";
import { ITeilnehmer } from "../model/ITeilnehmer";
import { CachingTeilnehmerService } from "../service/caching-services/caching.teilnehmer.service";

export class TeilnehmerDataSource implements DataSource<ITeilnehmer> {
  private teilnehmerSubject = new BehaviorSubject<ITeilnehmer[]>([]);
  private loadingSubject = new BehaviorSubject<boolean>(false);

  public paginator: MatPaginator;
  public sort: MatSort;
  public filter: string;

  public loading$ = this.loadingSubject.asObservable();

  constructor(private teilnehmerService: CachingTeilnehmerService, private verein: IVerein) {}

  connect(collectionViewer: CollectionViewer): Observable<ITeilnehmer[]> {
    return this.teilnehmerSubject.asObservable();
  }

  disconnect(collectionViewer: CollectionViewer): void {
    this.teilnehmerSubject.complete();
    this.loadingSubject.complete();
  }

  loadTeilnehmer(filter = ''): ITeilnehmer[] {
    this.teilnehmerService.loadTeilnehmer(this.verein).subscribe( result =>  {
      ;
      this.teilnehmerSubject.next(this.teilnehmerService.getTeilnehmer());
    })
    return this.teilnehmerService.getTeilnehmer();
  }

  /*
  loadTeilnehmer(filter = ''): Observable<ITeilnehmer[]> {
    this.loadingSubject.next(true);
    let direction = 'asc';
    if (this.sort) {
      direction = this.sort.direction;
    }
    let pageIndex = 0;
    let pageSize = 15;
    if (this.paginator) {
      pageIndex = this.paginator.pageIndex;
      pageSize = this.paginator.pageSize;
      // this.paginator.length = 100;
    }
    console.log('DataSource: ', this.sort,' , this.paginator: ', this.paginator, ', ' ,pageIndex, ', ', pageSize)
    this.teilnehmerService.getTeilnehmer()
      .pipe(
        catchError(() => of([])),
        finalize(() => this.loadingSubject.next(false))
      )
      .subscribe((teilnehmer) => {
        if (this.paginator) {
          this.paginator.length = this.teilnehmerService.anzahlTeilnehmer;
          console.log('DataSource: ', this.sort,' , this.paginator: ', this.paginator, ', ' ,pageIndex, ', ', pageSize)
        }
        this.teilnehmerSubject.next(teilnehmer)
      });
      return this.teilnehmerSubject.asObservable();
  }
  */
  // pageEvent: PageEvent,
  update(row: number, col: number, value: any) {
    // const effRow = pageEvent.previousPageIndex * this.paginator.pageSize + row;
    if (!this.teilnehmerService.getTeilnehmer()) {
      console.log('Empty');
    }
    console.log('Update row: ' , row, ', old: ', this.teilnehmerService.getTeilnehmer()[row],', new: ', value);
    switch (col) {
      case 0: {
        this.teilnehmerService.getTeilnehmer()[row].name = value;
        break;
      }
      case 1: {
        this.teilnehmerService.getTeilnehmer()[row].vorname = value;
        break;
      }
      case 2: {
        this.teilnehmerService.getTeilnehmer()[row].jahrgang = value;
        break;
      }
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
  set dirty (dirty: boolean) {
    this.teilnehmerService.dirty = dirty;
  }
  get dirty(): boolean {
    return this.teilnehmerService.dirty;
  }
  set valid (valid: boolean) {
    console.log('set Valid: ', valid);
    this.teilnehmerService.valid = valid;
  }
  get valid(): boolean {
    console.log('get Valid: ', this.teilnehmerService.valid);
    return this.teilnehmerService.valid;
  }
  saveAll(verein: IVerein): Observable<ITeilnehmer[]> {
    return this.teilnehmerService.saveAll(verein);
  }
}
