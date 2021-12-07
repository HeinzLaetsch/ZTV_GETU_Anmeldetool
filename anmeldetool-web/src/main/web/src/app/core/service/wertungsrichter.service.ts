import { Injectable } from "@angular/core";
import { Observable, Subject } from "rxjs";
import { IAnlass } from "../model/IAnlass";
import { IUser } from "../model/IUser";
import { AuthService } from "./auth/auth.service";
import { CachingAnlassService } from "./caching-services/caching.anlass.service";
import { CachingUserService } from "./caching-services/caching.user.service";

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
  ): string {
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
        return "OK";
      }
    } else {
      if (wertungsrichterPflicht === 0) return "OK";
    }
    if (wertungsrichterPflicht === 0) {
      return "OK";
    }
    return "unvollständig";
  }
}
