import { Injectable } from '@angular/core';
import { Subject, Observable, of, BehaviorSubject, Subscription } from 'rxjs';
import { IVerein } from 'src/app/verein/verein';
import { IAnlass } from '../../model/IAnlass';
import { AnlassService } from '../anlass/anlass.service';

@Injectable({
  providedIn: 'root'
})

export class CachingAnlassService {

  private anlaesseLoaded: BehaviorSubject<boolean>;

  private _loadRunning = false;

  private loaded = false;

  private anlaesse: IAnlass[];

  constructor(private anlassService: AnlassService) {
    this.anlaesseLoaded = new BehaviorSubject<boolean>(undefined);
  }
  reset(): Observable<boolean> {
    this.loaded = false;
    return this.loadAnlaesse();
  }
  getVereinStart(anlass: IAnlass, verein: IVerein): Observable<boolean> {
    return this.anlassService.getVereinStart(anlass, verein);
  }
  updateVereinsStart(anlass: IAnlass, verein: IVerein, started: boolean): Observable<boolean> {
    return this.anlassService.updateVereinsStart(anlass, verein, started);
  }
  isAnlaesseLoaded(): Observable<boolean> {
    return this.anlaesseLoaded.asObservable();
  }
  loadAnlaesse(): Observable<boolean> {
    if(!this._loadRunning && !this.loaded) {
      this._loadRunning = true;
       this.anlassService.getAnlaesse().subscribe( anlaesse => {
        this.anlaesse = anlaesse;
        this._loadRunning = false;
        this.loaded = true
        this.anlaesseLoaded.next(true);
        console.log('Anlaesse Loaded');
      });
    } else {
      if (this.loaded) {
        console.log('Anlaesse already loaded');
        this.anlaesseLoaded.next(true);
      }
    }
    // return this.vereineLoaded.asObservable().pipe(skip(1));
    return this.anlaesseLoaded.asObservable();
  }

  getAnlaesse(): IAnlass[] {
    if (this.loaded) {
      return this.anlaesse;
    }
    return undefined;
  }
  getAnlassById(id: string) {
    if (this.loaded) {
      return this.anlaesse.find( verein => verein.id = id);
    }
    return undefined;
  }
}
