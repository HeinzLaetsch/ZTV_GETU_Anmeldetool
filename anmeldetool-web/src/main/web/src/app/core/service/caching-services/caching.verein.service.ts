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

  loadVereine(): Observable<boolean> {
    if (!this._loadRunning && !this.loaded) {
      this._loadRunning = true;
      this.vereinService.getVereine().subscribe((vereine) => {
        this.vereine = vereine;
        this._loadRunning = false;
        this.loaded = true;
        // console.log("Vereine Loaded");
        this.vereineLoaded.next(true);
        // console.log("Vereine Loaded 2");
      });
    } else {
      if (this.loaded) {
        // console.log("Vereine already loaded");
        this.vereineLoaded.next(true);
      }
    }
    this.vereineLoaded.asObservable().subscribe((result) => {
      // console.log("loadVereine : ", result);
      this.vereineLoaded.complete();
    });
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
