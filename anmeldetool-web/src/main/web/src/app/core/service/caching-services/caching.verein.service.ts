import { Injectable } from "@angular/core";
import { Observable, Subject } from "rxjs";
import { IVerein } from "src/app/verein/verein";
import { VereinService } from "../verein/verein.service";

@Injectable({
  providedIn: "root",
})
export class CachingVereinService {
  private vereineLoaded: Subject<boolean>;

  private _loadRunning = false;

  private loaded = false;

  private vereine: IVerein[];

  constructor(private vereinService: VereinService) {
    this.vereineLoaded = new Subject<boolean>();
  }

  reset(): Observable<boolean> {
    this.loaded = false;
    return this.loadVereine();
  }

  private strip(org: string, pattern: string) {
    const hasGetuA = org.indexOf(pattern);
    if (hasGetuA >= 0) {
      return org.substring(hasGetuA + pattern.length);
    }
    return org;
  }
  loadVereine(): Observable<boolean> {
    if (!this._loadRunning && !this.loaded) {
      this._loadRunning = true;
      this.vereinService.getVereine().subscribe((vereine) => {
        this.vereine = vereine;
        this.vereine.sort((a, b) => {
          let strippedA = a.name.toUpperCase();
          let strippedB = b.name.toUpperCase();
          if (strippedA === "ZTV") {
            return 1;
          }
          if (strippedB === "ZTV") {
            return -1;
          }
          strippedA = this.strip(strippedA, "GR ");
          strippedB = this.strip(strippedB, "GR ");
          strippedA = this.strip(strippedA, "GETU ");
          strippedB = this.strip(strippedB, "GETU ");
          strippedA = this.strip(strippedA, "DTV ");
          strippedB = this.strip(strippedB, "DTV ");
          strippedA = this.strip(strippedA, "STU ");
          strippedB = this.strip(strippedB, "STU ");
          strippedA = this.strip(strippedA, "TG ");
          strippedB = this.strip(strippedB, "TG ");
          strippedA = this.strip(strippedA, "TV ");
          strippedB = this.strip(strippedB, "TV ");
          strippedA = this.strip(strippedA, "TSV ");
          strippedB = this.strip(strippedB, "TSV ");
          strippedA = this.strip(strippedA, "GERÄTERIEGE JUGI ");
          strippedB = this.strip(strippedB, "GERÄTERIEGE JUGI ");
          strippedA = this.strip(strippedA, "GERÄTERIEGE ");
          strippedB = this.strip(strippedB, "GERÄTERIEGE ");
          strippedA = this.strip(strippedA, "TURNVEREIN ");
          strippedB = this.strip(strippedB, "TURNVEREIN ");
          strippedA = this.strip(strippedA, "TURNSPORT ");
          strippedB = this.strip(strippedB, "TURNSPORT ");
          strippedA = this.strip(strippedA, "GERÄTETURNEN ");
          strippedB = this.strip(strippedB, "GERÄTETURNEN ");
          strippedA = this.strip(strippedA, "SATUS ");
          strippedB = this.strip(strippedB, "SATUS ");
          strippedA = this.strip(strippedA, "NEUE SEKTION ");
          strippedB = this.strip(strippedB, "NEUE SEKTION ");

          if (strippedA < strippedB) {
            return -1;
          }
          if (strippedA > strippedB) {
            return 1;
          }
          return 0;
        });
        this._loadRunning = false;
        this.loaded = true;
        // console.log("Vereine Loaded");
        // this.vereineLoaded.next(true);
        // console.log("Vereine Loaded 2");
        this.vereineLoaded.complete();
      });
    } else {
      if (this.loaded) {
        // console.log("Vereine already loaded");
        this.vereineLoaded.next(true);
      }
    }
    /*
    this.vereineLoaded.asObservable().subscribe((result) => {
      // console.log("loadVereine : ", result);
      this.vereineLoaded.complete();
    });
    */
    return this.vereineLoaded.asObservable();
  }

  getVereine(): IVerein[] {
    if (this.loaded) {
      return this.vereine;
    }
    return undefined;
  }
  getVereinById(id: string) {
    if (this.loaded) {
      return this.vereine.find((verein) => verein.id === id);
    }
    return undefined;
  }
}
