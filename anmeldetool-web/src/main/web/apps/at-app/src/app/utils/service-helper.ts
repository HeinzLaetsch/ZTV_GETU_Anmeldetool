import { HttpErrorResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { type Observable, of, throwError } from 'rxjs';

@Injectable()
export abstract class ServiceHelper {
  handleError<T>(operation = 'operation', error: unknown, result?: T | Observable<T>, emptyObject?: T): Observable<T> {
    if (error instanceof HttpErrorResponse && error.status === 404) {
      return of(emptyObject as T);
    }
    if (error instanceof Error && 'status' in error && (error as { status: number }).status === 404) {
      return of(emptyObject as T);
    }

    console.error('Error in: ', operation, ', message: ', error, ', result: ', result);

    // return of(emptyObject as T);

    return throwError(() => error);
  }
}
