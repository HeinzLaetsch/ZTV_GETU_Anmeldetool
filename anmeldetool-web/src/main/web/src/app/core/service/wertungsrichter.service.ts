import { Injectable } from "@angular/core";
import { Observable, Subject } from "rxjs";
import { IAnlass } from "../model/IAnlass";
import { IUser } from "../model/IUser";
import { WertungsrichterStatusEnum } from "../model/WertungsrichterStatusEnum";
import { AuthService } from "./auth/auth.service";
import { CachingAnlassService } from "./caching-services/caching.anlass.service";
import { CachingUserService } from "./caching-services/caching.user.service";
import { IAnlassSummary } from "../model/IAnlassSummary";

@Injectable({
  providedIn: "root",
})
export class WertungsrichterService {
  constructor(
    public authService: AuthService,
    private anlassService: CachingAnlassService,
    private userService: CachingUserService
  ) {}

  public getEingeteilteWertungsrichter(
    anlass: IAnlass,
    brevet: number
  ): Observable<IUser[]> {
    const assignedWrs = new Array<IUser>();
    const eingteilteWrSubject = new Subject<IUser[]>();

    // get PAL
    this.anlassService
      .getEingeteilteWertungsrichter(
        anlass,
        this.authService.currentVerein,
        brevet
      )
      .subscribe(
        (result) => {
          if (result) {
            result.map((link) => {
              const user = this.userService.getUserById(link.personId);
              user.pal = link;
              assignedWrs.push(user);
            });
          }
          assignedWrs.sort((a, b) => {
            if (a.benutzername < b.benutzername) {
              return -1;
            }
            if (a.benutzername > b.benutzername) {
              return 1;
            }
            return 0;
          });
          eingteilteWrSubject.next(assignedWrs);
        },
        (error) => {
          switch (error.status) {
            case 404: {
              break;
            }
            default: {
              console.error(error);
            }
          }
          eingteilteWrSubject.next([]);
        }
      );
    return eingteilteWrSubject.asObservable();
  }

  getStatusWertungsrichterBr(
    assignedWrs: IUser[],
    wertungsrichterPflicht: number
  ): WertungsrichterStatusEnum {
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
    if (anzahlTeilnehmer > 0) return Math.ceil(anzahlTeilnehmer / 15);
    return 0;
  }

  getWertungsrichterPflichtBrevet2(anlassSummary: IAnlassSummary): number {
    //const anzahlTeilnehmer = this.anlassService.getTeilnahmen(anlass, 2).length;
    const anzahlTeilnehmer = anlassSummary.startendeBr2;
    if (anzahlTeilnehmer > 0) return Math.ceil(anzahlTeilnehmer / 15);
    return 0;
  }

  // TODO abfüllen
  getStatusWertungsrichter(
    anlassSummary: IAnlassSummary,
    assignedWr1s: Array<IUser>,
    assignedWr2s: Array<IUser>
  ): WertungsrichterStatusEnum {
    const pflichtBrevet1 = this.getWertungsrichterPflichtBrevet1(anlassSummary);
    const pflichtBrevet2 = this.getWertungsrichterPflichtBrevet2(anlassSummary);

    const statusBrevet1 = this.getStatusWertungsrichterBr(
      assignedWr1s,
      pflichtBrevet1
    );
    const statusBrevet2 = this.getStatusWertungsrichterBr(
      assignedWr2s,
      pflichtBrevet2
    );
    if (statusBrevet1 === WertungsrichterStatusEnum.NOTOK) {
      return WertungsrichterStatusEnum.NOTOK;
    }
    if (statusBrevet2 === WertungsrichterStatusEnum.NOTOK) {
      return WertungsrichterStatusEnum.NOTOK;
    }
    return WertungsrichterStatusEnum.OK;
  }
}
