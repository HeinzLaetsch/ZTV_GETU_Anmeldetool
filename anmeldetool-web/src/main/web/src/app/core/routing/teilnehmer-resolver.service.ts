import { Injectable } from "@angular/core";
import { Resolve } from "@angular/router";
import { Observable, of } from "rxjs";

@Injectable({
  providedIn: "root",
})
export class TeilnehmerResolverService implements Resolve<number> {
  constructor() // private authService: AuthService,
  // private teilnehmerService: CachingTeilnehmerService
  {}

  resolve(): Observable<number> {
    console.log("resolve Teilnehmer");
    return of(0);
    /*
    return this.teilnehmerService
      .loadTeilnehmer(this.authService.currentVerein)
      .pipe(
        take(1),
        mergeMap((anzahl) => {
          if (anzahl) {
            return of(anzahl);
          } else {
            return EMPTY;
          }
        })
      );
      */
  }
}
