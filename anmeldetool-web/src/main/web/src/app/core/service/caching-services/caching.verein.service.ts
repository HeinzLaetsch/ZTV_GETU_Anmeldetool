import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Subject, Observable, of, BehaviorSubject, Subscription } from 'rxjs';
import { IVerein } from 'src/app/verein/verein';
import { catchError, skip } from 'rxjs/operators';
import { VereinService } from '../verein/verein.service';

@Injectable({
  providedIn: 'root'
})

export class CachingVereinService {

  private vereineLoaded: BehaviorSubject<boolean>;

  private _loadRunning = false;

  private loaded = false;

  private vereine: IVerein[];

  constructor(private vereinService: VereinService) {
    // this.vereineLoaded = new BehaviorSubject<boolean>(undefined);
    this.vereineLoaded = new BehaviorSubject<boolean>(undefined);
  }
  reset(): Observable<boolean> {
    this.loaded = false;
    return this.loadVereine();
  }
  isVereineLoaded(): Observable<boolean> {
    return this.vereineLoaded.asObservable();
  }
  loadVereine(): Observable<boolean> {
    if(!this._loadRunning && !this.loaded) {
      this._loadRunning = true;
       this.vereinService.getVereine().subscribe( vereine => {
        this.vereine = vereine;
        this._loadRunning = false;
        this.loaded = true
        this.vereineLoaded.next(true);
        console.log('Vereine Loaded');
      });
    } else {
      if (this.loaded) {
        console.log('Vereine already loaded');
        this.vereineLoaded.next(true);
      }
    }
    // return this.vereineLoaded.asObservable().pipe(skip(1));
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
      return this.vereine.find( verein => verein.id = id);
    }
    return undefined;
  }
}
