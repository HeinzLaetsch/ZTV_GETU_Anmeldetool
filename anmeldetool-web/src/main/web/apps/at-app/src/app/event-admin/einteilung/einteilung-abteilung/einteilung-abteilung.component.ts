import {
  ChangeDetectionStrategy,
  Component,
  type EventEmitter,
  inject,
  input,
  type OnInit,
  ViewEncapsulation,
} from '@angular/core';
import { CommonModule } from '@angular/common';
import { MaterialModule } from 'src/app/shared/material-module';
import { Subject } from 'rxjs';
import type { AbteilungEnum } from 'src/app/core/model/AbteilungEnum';
import { AnlageEnum } from 'src/app/core/model/AnlageEnum';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { ITeilnahmeStatistic } from 'src/app/core/model/ITeilnahmeStatistic';
import type { KategorieEnum } from 'src/app/core/model/KategorieEnum';
import { CachingAnlassService } from 'src/app/core/service/caching-services/caching.anlass.service';
import { RanglistenService } from 'src/app/core/service/rangliste/ranglisten.service';
import { EinteilungAnlageComponent } from '../einteilung-anlage/einteilung-anlage.component';

@Component({
  selector: 'ztv-einteilung-abteilung',
  templateUrl: './einteilung-abteilung.component.html',
  styleUrls: ['./einteilung-abteilung.component.scss'],
  encapsulation: ViewEncapsulation.None,
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, MaterialModule, EinteilungAnlageComponent],
})
export class EinteilungAbteilungComponent implements OnInit {
  readonly anlass = input.required<IAnlass>();
  readonly kategorie = input.required<KategorieEnum>();
  readonly abteilung = input.required<AbteilungEnum>();
  readonly search = input<string | undefined>();
  readonly refreshEmitter = input.required<EventEmitter<string>>();
  readonly expanded = input(false);

  anlagen: AnlageEnum[];

  teilnahmeStatistic: ITeilnahmeStatistic;

  private statisticLoaded = false;
  private otherLoaded = false;

  private readonly anlassService = inject(CachingAnlassService);
  private readonly ranglistenService = inject(RanglistenService);
  readonly loaded$ = new Subject<boolean>();

  ngOnInit(): void {
    this.ranglistenService
      .getAnlagenForAnlass(this.anlass(), this.kategorie(), this.abteilung())
      .subscribe((anlagen) => {
        this.anlagen = anlagen;
        if (this.statisticLoaded) {
          this.loaded$.next(true);
        }
        this.otherLoaded = true;
      });
    this.anlassService
      .getTeilnahmeStatistic(this.anlass(), this.kategorie(), this.abteilung(), undefined, undefined, this.search())
      .subscribe((statistic) => {
        this.teilnahmeStatistic = statistic;
        if (this.otherLoaded) {
          this.loaded$.next(true);
        }
        this.statisticLoaded = true;
      });
    this.refreshEmitter().subscribe((search) => {
      console.log('EinteilungAbteilungComponent, Refresh Kategorie: ', search);
      this.anlassService
        .getTeilnahmeStatistic(this.anlass(), this.kategorie(), this.abteilung(), undefined, undefined, search)
        .subscribe((statistic) => {
          this.teilnahmeStatistic = statistic;
        });
    });
  }

  private getIndex(anlage: AnlageEnum): number {
    const index = Object.keys(AnlageEnum).indexOf(anlage);
    return index;
  }
}
