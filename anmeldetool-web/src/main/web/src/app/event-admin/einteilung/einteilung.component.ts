import { Component, type EventEmitter, Input, type OnInit, ViewEncapsulation } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Subject } from 'rxjs';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { ITeilnahmeStatistic } from 'src/app/core/model/ITeilnahmeStatistic';
import type { IUser } from 'src/app/core/model/IUser';
import type { KategorieEnum } from 'src/app/core/model/KategorieEnum';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { CachingAnlassService } from 'src/app/core/service/caching-services/caching.anlass.service';
import { MaterialModule } from 'src/app/shared/material-module';
import { EinteilungKategorieComponent } from './einteilung-kategorie/einteilung-kategorie.component';

@Component({
  selector: 'lxt-einteilung',
  templateUrl: './einteilung.component.html',
  styleUrls: ['./einteilung.component.css'],
  encapsulation: ViewEncapsulation.None,
  standalone: true,
  imports: [CommonModule, FormsModule, MaterialModule, EinteilungKategorieComponent],
})
export class EinteilungComponent implements OnInit {
  @Input()
  anlass: IAnlass;

  @Input()
  refreshEmitter: EventEmitter<string>;

  currentUser: IUser;
  panelOpenState = false;

  kategorien: KategorieEnum[];

  teilnahmeStatistic: ITeilnahmeStatistic;

  loaded$: Subject<boolean>;

  search_: string;

  constructor(
    private authService: AuthService,
    private anlassService: CachingAnlassService,
  ) {
    this.loaded$ = new Subject();
  }

  ngOnInit() {
    this.currentUser = this.authService.currentUser;
    this.kategorien = this.anlass.getKategorienRaw().slice(1);
    this.loadData();
  }

  get search(): string {
    return this.search_;
  }
  set search(search: string) {
    this.search_ = search;
  }

  private loadData() {
    this.anlassService
      .getTeilnahmeStatistic(this.anlass, undefined, undefined, undefined, undefined, this.search_)
      .subscribe((statistic) => {
        this.teilnahmeStatistic = statistic;
        this.loaded$.next(true);
      });
    this.refreshEmitter.subscribe((search) => {
      console.log('EinteilungComponent, Refresh Kategorie: ', search);
      this.anlassService
        .getTeilnahmeStatistic(this.anlass, undefined, undefined, undefined, undefined, this.search_)
        .subscribe((statistic) => {
          this.teilnahmeStatistic = statistic;
        });
    });
  }
  getKategorien(): KategorieEnum[] {
    return this.kategorien;
  }
  executeSearch(value: string): void {
    console.log('Suche ', value, this.search);
    this.refreshEmitter.emit(value);
  }
  clear() {
    this.search = undefined;
    this.refreshEmitter.emit(undefined);
  }
}
