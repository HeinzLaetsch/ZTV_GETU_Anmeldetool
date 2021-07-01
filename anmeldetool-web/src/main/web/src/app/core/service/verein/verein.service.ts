import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Subject, Observable, of } from 'rxjs';
import { IVerein } from 'src/app/verein/verein';
import { catchError } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})

export class VereinService {

  private url: string = 'http://localhost:8080/admin/organisationen';

  vereine = {};

  constructor(private http: HttpClient) { }

  getVereine(): Observable<IVerein[]> {
    return this.http.get<IVerein[]>(this.url)
      .pipe(catchError(this.handleError<IVerein[]>('getVereine', [])));
  }

  private handleError<T>(operation = 'operation', result?: T) {
    return (error: any) :Observable<T> => {
      console.error(error);
      return of (result as T);
    }
  }
}
