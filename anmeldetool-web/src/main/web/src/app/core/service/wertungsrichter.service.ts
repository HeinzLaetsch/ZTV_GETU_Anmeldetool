import { Injectable } from '@angular/core';
import { catchError, forkJoin, map, Observable, of, switchMap, take } from 'rxjs';
import { IAnlass } from '../model/IAnlass';
import { IUser } from '../model/IUser';
import { WertungsrichterStatusEnum } from '../model/WertungsrichterStatusEnum';
import { AuthService } from './auth/auth.service';
import { IAnlassSummary } from '../model/IAnlassSummary';
import { select, Store } from '@ngrx/store';
import { AppState } from '../redux/core.state';
import { selectUserById } from '../redux/user';
import { AnlassService } from './anlass/anlass.service';

@Injectable({
  providedIn: 'root',
})
export class WertungsrichterService {
  user$: Observable<IUser[]>;

  constructor(
    public authService: AuthService,
    private store: Store<AppState>,
    private anlassService: AnlassService,
  ) {
    // this.store.dispatch(UserActions.loadAllUserInvoked());
  }

  getEingeteilteWertungsrichter(anlass: IAnlass, brevet: number): Observable<IUser[]> {
    return this.anlassService.getEingeteilteWertungsrichter(anlass, this.authService.currentVerein, brevet).pipe(
      switchMap((links) => {
        // Wenn keine Links vorhanden sind, leeres Array zurückgeben
        if (!links || links.length === 0) {
          return of([]);
        }

        // Erstellt für jeden Link einen Store-Stream
        const userObservables = links.map((link) =>
          this.store.pipe(
            select(selectUserById(link.personId)),
            take(1), // Wichtig: Beendet den Stream nach dem ersten Wert
            map((user) => {
              if (!user) {
                console.error(`User not found for id: ${link.personId}`);
                return null;
              }
              // Deep Copy erstellen und Link (pal) anhängen
              const tmpUser = JSON.parse(JSON.stringify(user));
              tmpUser.pal = link;
              return tmpUser;
            }),
          ),
        );

        // Wartet, bis ALLE Store-Abfragen einmalig geantwortet haben
        return forkJoin(userObservables).pipe(
          // Filtert eventuelle 'null'-Werte heraus, falls ein User nicht gefunden wurde
          map((users) => users.filter((u): u is IUser => u !== null)),
        );
      }),
      catchError((error) => {
        if (error.status !== 404) {
          console.error(error);
        }
        return of([]); // Im Fehlerfall leeres Array zurückgeben
      }),
    );
  }

  // TODO Logik ins Backend verschieben, wenn Redux AnlassSummary
  getStatusWertungsrichterBr(assignedWrs: IUser[], wertungsrichterPflicht: number): WertungsrichterStatusEnum {
    if (assignedWrs && assignedWrs.length > 0) {
      let numberOfEinsaetze = 0;
      assignedWrs.forEach((user) => {
        if (user.pal && user.pal.einsaetze) {
          user.pal.einsaetze.forEach((einsatz) => {
            if (einsatz.eingesetzt) {
              numberOfEinsaetze++;
            }
          });
        }
      });

      if (wertungsrichterPflicht <= numberOfEinsaetze) {
        return WertungsrichterStatusEnum.OK;
      }
    } else {
      if (wertungsrichterPflicht === 0) {
        return WertungsrichterStatusEnum.KEINEPFLICHT;
      }
    }
    if (wertungsrichterPflicht === 0) {
      return WertungsrichterStatusEnum.KEINEPFLICHT;
    }
    return WertungsrichterStatusEnum.NOTOK;
  }

  getWertungsrichterPflichtBrevet1(anlassSummary: IAnlassSummary): number {
    // const anzahlTeilnehmer = this.anlassService.getTeilnahmen(anlass, 1).length;
    const anzahlTeilnehmer = anlassSummary.startendeBr1;
    if (anzahlTeilnehmer > 0) {
      return Math.ceil(anzahlTeilnehmer / 15);
    }
    return 0;
  }

  getWertungsrichterPflichtBrevet2(anlassSummary: IAnlassSummary): number {
    //const anzahlTeilnehmer = this.anlassService.getTeilnahmen(anlass, 2).length;
    const anzahlTeilnehmer = anlassSummary.startendeBr2;
    if (anzahlTeilnehmer > 0) {
      return Math.ceil(anzahlTeilnehmer / 15);
    }
    return 0;
  }

  // TODO abfüllen
  getStatusWertungsrichter(
    anlassSummary: IAnlassSummary,
    assignedWr1s: IUser[],
    assignedWr2s: IUser[],
  ): WertungsrichterStatusEnum {
    const pflichtBrevet1 = this.getWertungsrichterPflichtBrevet1(anlassSummary);
    const pflichtBrevet2 = this.getWertungsrichterPflichtBrevet2(anlassSummary);

    const statusBrevet1 = this.getStatusWertungsrichterBr(assignedWr1s, pflichtBrevet1);
    const statusBrevet2 = this.getStatusWertungsrichterBr(assignedWr2s, pflichtBrevet2);
    if (statusBrevet1 === WertungsrichterStatusEnum.NOTOK) {
      return WertungsrichterStatusEnum.NOTOK;
    }
    if (statusBrevet2 === WertungsrichterStatusEnum.NOTOK) {
      return WertungsrichterStatusEnum.NOTOK;
    }
    return WertungsrichterStatusEnum.OK;
  }
}
