import { Component, type EventEmitter, Input, type OnInit, ViewEncapsulation } from '@angular/core';
import { Subject } from 'rxjs';
import type { AbteilungEnum } from 'src/app/core/model/AbteilungEnum';
import type { AnlageEnum } from 'src/app/core/model/AnlageEnum';
import type { GeraeteEnum } from 'src/app/core/model/GeraeteEnum';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { ITeilnahmeStatistic } from 'src/app/core/model/ITeilnahmeStatistic';
import type { KategorieEnum } from 'src/app/core/model/KategorieEnum';
import { CachingAnlassService } from 'src/app/core/service/caching-services/caching.anlass.service';

@Component({
  selector: 'lxt-einteilung-anlage',
  templateUrl: './einteilung-anlage.component.html',
  styleUrls: ['./einteilung-anlage.component.css'],
  encapsulation: ViewEncapsulation.None,
})
export class EinteilungAnlageComponent implements OnInit {
  @Input()
  anlass: IAnlass;
  @Input()
  kategorie: KategorieEnum;
  @Input()
  abteilung: AbteilungEnum;
  @Input()
  anlage: AnlageEnum;
  @Input()
  refreshEmitter: EventEmitter<string>;
  @Input()
  search: string;
  @Input()
  expanded: boolean;

  teilnahmeStatistic: ITeilnahmeStatistic;

  loaded$: Subject<boolean>;

  private statisticLoaded = false;
  private otherLoaded = false;

  constructor(private anlassService: CachingAnlassService) {
    this.loaded$ = new Subject();
  }

  ngOnInit(): void {
    this.anlassService
      .getTeilnahmeStatistic(this.anlass, this.kategorie, this.abteilung, this.anlage, undefined, this.search)
      .subscribe((statistic) => {
        this.teilnahmeStatistic = statistic;
        this.loaded$.next(true);
      });
    this.refreshEmitter.subscribe((search) => {
      console.log('EinteilungAnlageComponent, Refresh Kategorie: ', search);
      this.search = search;
      this.anlassService
        .getTeilnahmeStatistic(this.anlass, this.kategorie, this.abteilung, this.anlage, undefined, search)
        .subscribe((statistic) => {
          this.teilnahmeStatistic = statistic;
        });
    });
  }

  get startgeraete(): GeraeteEnum[] {
    const startgeraete = this.anlass.getStartgeraete();
    return startgeraete;
  }
}
