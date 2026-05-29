import { Component, type EventEmitter, Input, type OnInit, Output, ViewEncapsulation } from '@angular/core';
import { Subject } from 'rxjs';
import type { AbteilungEnum } from 'src/app/core/model/AbteilungEnum';
import { AnlageEnum } from 'src/app/core/model/AnlageEnum';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { ITeilnahmeStatistic } from 'src/app/core/model/ITeilnahmeStatistic';
import type { KategorieEnum } from 'src/app/core/model/KategorieEnum';
import { CachingAnlassService } from 'src/app/core/service/caching-services/caching.anlass.service';
import { RanglistenService } from 'src/app/core/service/rangliste/ranglisten.service';

@Component({
  selector: 'lxt-einteilung-abteilung',
  templateUrl: './einteilung-abteilung.component.html',
  styleUrls: ['./einteilung-abteilung.component.css'],
  encapsulation: ViewEncapsulation.None,
})
export class EinteilungAbteilungComponent implements OnInit {
  @Input()
  anlass: IAnlass;
  @Input()
  kategorie: KategorieEnum;
  @Input()
  abteilung: AbteilungEnum;
  @Input()
  search: string;
  @Input()
  refreshEmitter: EventEmitter<string>;
  @Input()
  expanded: boolean;

  anlagen: AnlageEnum[];

  teilnahmeStatistic: ITeilnahmeStatistic;

  loaded$: Subject<boolean>;

  private statisticLoaded = false;
  private otherLoaded = false;

  constructor(
    private anlassService: CachingAnlassService,
    private ranglistenService: RanglistenService,
  ) {
    this.loaded$ = new Subject();
  }

  ngOnInit() {
    this.ranglistenService.getAnlagenForAnlass(this.anlass, this.kategorie, this.abteilung).subscribe((anlagen) => {
      this.anlagen = anlagen;
      if (this.statisticLoaded) {
        this.loaded$.next(true);
      }
      this.otherLoaded = true;
    });
    this.anlassService
      .getTeilnahmeStatistic(this.anlass, this.kategorie, this.abteilung, undefined, undefined, this.search)
      .subscribe((statistic) => {
        this.teilnahmeStatistic = statistic;
        if (this.otherLoaded) {
          this.loaded$.next(true);
        }
        this.statisticLoaded = true;
      });
    this.refreshEmitter.subscribe((search) => {
      console.log('EinteilungAbteilungComponent, Refresh Kategorie: ', search);
      this.search = search;
      this.anlassService
        .getTeilnahmeStatistic(this.anlass, this.kategorie, this.abteilung, undefined, undefined, search)
        .subscribe((statistic) => {
          this.teilnahmeStatistic = statistic;
        });
    });
  }

  private getIndex(anlage: AnlageEnum) {
    const index = Object.keys(AnlageEnum).indexOf(anlage);
    return index;
  }
}
