import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { catchError } from 'rxjs/operators';
import { IUser } from '../../model/IUser';
import { Observable, of } from 'rxjs';
import { IAnlass } from '../../model/IAnlass';
import { IVerein } from 'src/app/verein/verein';
import { IAnlassLink } from '../../model/IAnlassLink';
import { IAnlassLinks } from '../../model/IAnlassLinks';

@Injectable({
  providedIn: 'root'
})

export class AnlassService {

  private url: string = 'http://localhost:8080/admin/anlaesse';

  constructor(private http: HttpClient) { }

  getAnlaesse(): Observable<IAnlass[]> {
    console.log('getAnlaesse called');
    return this.http.get<IAnlass[]>(this.url)
      .pipe(catchError(this.handleError<IAnlass[]>('getAnlaesse', [])));
  }

  getVereinStart(anlass: IAnlass, verein: IVerein): Observable<boolean> {
    const combinedUrl = this.url+'/'+anlass.id+'/'+'organisationen'+'/'+verein.id;
    console.log('getVereinStart called: ', combinedUrl);
    return this.http.get<boolean>(combinedUrl)
      .pipe(catchError( error => {
        if (error.status === 404) {
          return of (false);
        }
          this.handleError<boolean>('getVereinStart');
      }));
  }

  getVereinsStarts(anlass: IAnlass): Observable<IVerein[]> {
    const combinedUrl = this.url+'/'+anlass.id+'/'+'organisationen';
    console.log('getVereinsStarts called');
    return this.http.get<IVerein[]>(combinedUrl)
      .pipe(catchError(this.handleError<IVerein[]>('getVereinsStarts', [])));
  }

  updateVereinsStart(anlass: IAnlass, verein: IVerein, started: boolean): Observable<boolean> {
    const combinedUrl = this.url+'/'+anlass.id+'/'+'organisationen'+'/'+verein.id;
    console.log('updateVereinsStart called: ' , combinedUrl , ' , data: ' , started);
    return this.http.patch<boolean>(combinedUrl, {anlassId: anlass.id, organisationsId: verein.id, started: started})
      .pipe(catchError(this.handleError<boolean>('updateVereinsStart', )));
  }

  saveTeilnahme(verein: IVerein, anlassLink: IAnlassLink): Observable<boolean>{
    console.log('Service save Teilnahme: ', anlassLink);
    const combinedUrl = this.url + '/' + anlassLink.anlassId + '/'+'organisationen'+'/'+ verein.id + '/teilnehmer/' + anlassLink.teilnehmerId;
    return this.http.patch<boolean>(combinedUrl, anlassLink)
      .pipe(catchError(this.handleError<boolean>('saveTeilnahme')));
  }

  // /anlaesse/{anlassId}/organisationen/{orgId}/teilnehmer/
  getTeilnehmer(anlass: IAnlass, verein: IVerein): Observable<IAnlassLink[]> {
    const combinedUrl = this.url+'/'+anlass.id+'/'+'organisationen' + '/' + verein.id + '/teilnehmer/';
    console.log('getTeilnehmer called: ', combinedUrl);
    return this.http.get<IAnlassLink[]>(combinedUrl)
      .pipe(catchError(this.handleError<IAnlassLink[]>('getTeilnehmer', [])));
  }

  private handleError<T>(operation = 'operation', result?: T) {
    return (error: any) :Observable<T> => {
      console.error('HandleError: ', error);
      return of (result as T);
    }
  }
}
