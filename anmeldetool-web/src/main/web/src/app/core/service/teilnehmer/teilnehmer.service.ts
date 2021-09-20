import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { catchError } from 'rxjs/operators';
import { Observable, of } from 'rxjs';
import { IAnlassLink } from '../../model/IAnlassLink';
import { ITeilnehmer } from '../../model/ITeilnehmer';
import { IVerein } from 'src/app/verein/verein';
import { IAnlass } from '../../model/IAnlass';
import { TiTuEnum } from '../../model/TiTuEnum';

@Injectable({
  providedIn: 'root'
})

export class TeilnehmerService {

  private url: string = 'http://localhost:8080/admin/organisationen/';
  private _anzahlTeilnehmer = 0;
  teilnehmer: ITeilnehmer[] = [];
  // teilnahmen: IAnlassLink[] = [  {id: '1', anlassId: '1', kategorie: 'k1'}, {id: '2', anlassId: '2', kategorie: ''}, {id: '3', anlassId: '3', kategorie: ''}, {id: '4', anlassId: '4', kategorie: ''}];

  constructor(private http: HttpClient) {
    // this.loadTeilnehmer();
  }

  getTeilnehmer(verein: IVerein, filter = '', sortDirection = 'asc', pageIndex = 0, pageSize = 3): Observable<ITeilnehmer[]> {
    console.log('getTeilnehmer called');
    this.updateCount(verein, filter);
    const combinedUrl = this.url + verein.id + '/teilnehmer?page=' + pageIndex + '&size=' + pageSize;
    return this.http.get<ITeilnehmer[]>(combinedUrl)
      .pipe(catchError(this.handleError<ITeilnehmer[]>('getAnlaesse', [])));
  }

  reset() {
    // this.loadTeilnehmer();
  }
  get anzahlTeilnehmer() {
    return this._anzahlTeilnehmer;
  }
  updateCount(verein: IVerein, filter = '') {
    const combinedUrl = this.url + verein.id + '/teilnehmer/count';
    this.http.get<number>(combinedUrl)
      .pipe(catchError(this.handleError<number>('count')))
      .subscribe(anzahl => this._anzahlTeilnehmer = anzahl);
  }

  add(verein: IVerein): Observable<ITeilnehmer> {
    console.log('getTeilnehmer called');
    this._anzahlTeilnehmer++;
    const combinedUrl = this.url + verein.id + '/teilnehmer';
    return this.http.post<ITeilnehmer>(combinedUrl, {})
      .pipe(catchError(this.handleError<ITeilnehmer>('add')));
  }

  save(verein: IVerein, teilnehmer: ITeilnehmer): Observable<ITeilnehmer> {
    console.log('Service save: ', teilnehmer);
    const combinedUrl = this.url + verein.id + '/teilnehmer';
    return this.http.patch<ITeilnehmer>(combinedUrl, teilnehmer)
      .pipe(catchError(this.handleError<ITeilnehmer>('add')));
    // this.teilnehmer.push(teilnehmer);
    // return of(true);
  }

  private handleError<T>(operation = 'operation', result?: T) {
    return (error: any): Observable<T> => {
      console.error(error);
      return of(result as T);
    }
  }
}
/** Constants used to fill up our data base. */
const SURNAMES = ['Maia', 'Asher', 'Olivia', 'Atticus', 'Amelia', 'Jack',
  'Charlotte', 'Theodore', 'Isla', 'Oliver', 'Isabella', 'Jasper',
  'Cora', 'Levi', 'Violet', 'Arthur', 'Mia', 'Thomas', 'Elizabeth'];

const NAMES = ['Balmer', 'Bärtschi', 'Meier', 'Müller', 'Keller', 'Brandenberger',
  'Schmidhauser', 'Kneubühler', 'Hochmuth', 'Berset', 'Trump', 'Einstein',
  'Hase', 'Schneemann', 'Cologna', 'Federer', 'Bretscher', 'Züllig', 'Marti'];

/** Builds and returns a new User. */
function createTeilnehmer(id: number, teilnahmen): ITeilnehmer {
  const name =
    NAMES[Math.round(Math.random() * (NAMES.length - 1))] + ' ' + id;
  const vorname =
    SURNAMES[Math.round(Math.random() * (SURNAMES.length - 1))] + ' ' + id;

  return {
    id: id.toString(),
    name: name,
    vorname: vorname,
    jahrgang: 2000 + Math.round(Math.random() * 15),
    tiTu: TiTuEnum.Ti,
    teilnahmen: teilnahmen,
    dirty: false
  };
}

