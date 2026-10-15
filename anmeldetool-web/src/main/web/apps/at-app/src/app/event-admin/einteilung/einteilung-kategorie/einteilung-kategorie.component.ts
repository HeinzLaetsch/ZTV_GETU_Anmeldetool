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
import { AbteilungEnum } from 'src/app/core/model/AbteilungEnum';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { ITeilnahmeStatistic } from 'src/app/core/model/ITeilnahmeStatistic';
import type { KategorieEnum } from 'src/app/core/model/KategorieEnum';
import { CachingAnlassService } from 'src/app/core/service/caching-services/caching.anlass.service';
import { RanglistenService } from 'src/app/core/service/rangliste/ranglisten.service';
import { EinteilungAbteilungComponent } from '../einteilung-abteilung/einteilung-abteilung.component';
import { EinteilungStartgeraetComponent } from '../einteilung-startgeraet/einteilung-startgeraet.component';

@Component({
  selector: 'ztv-einteilung-kategorie',
  templateUrl: './einteilung-kategorie.component.html',
  styleUrls: ['./einteilung-kategorie.component.scss'],
  encapsulation: ViewEncapsulation.None,
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, MaterialModule, EinteilungAbteilungComponent, EinteilungStartgeraetComponent],
})
export class EinteilungKategorieComponent implements OnInit {
  readonly anlass = input.required<IAnlass>();
  readonly kategorie = input.required<KategorieEnum>();
  readonly search = input<string | undefined>();
  readonly refreshEmitter = input.required<EventEmitter<string>>();

  abteilungen: AbteilungEnum[];

  teilnahmeStatistic: ITeilnahmeStatistic;
  teilnahmeStatisticNotAssigned: ITeilnahmeStatistic;

  private statisticLoaded = false;
  private otherLoaded = false;

  private readonly ranglistenService = inject(RanglistenService);
  private readonly anlassService = inject(CachingAnlassService);
  readonly loaded$ = new Subject<boolean>();

  get UNDEFINED(): AbteilungEnum {
    return AbteilungEnum.UNDEFINED;
  }
  ngOnInit(): void {
    this.ranglistenService.getAbteilungenForAnlass(this.anlass(), this.kategorie()).subscribe((abteilungen) => {
      this.abteilungen = abteilungen;
      if (this.statisticLoaded) {
        this.loaded$.next(true);
      }
      this.otherLoaded = true;
    });
    this.anlassService
      .getTeilnahmeStatistic(this.anlass(), this.kategorie(), undefined, undefined, undefined, this.search())
      .subscribe((statistic) => {
        this.teilnahmeStatistic = statistic;
        if (this.otherLoaded) {
          this.loaded$.next(true);
        }
        this.statisticLoaded = true;
      });
    this.anlassService
      .getTeilnahmeStatistic(
        this.anlass(),
        this.kategorie(),
        AbteilungEnum.UNDEFINED,
        undefined,
        undefined,
        this.search(),
      )
      .subscribe((statistic) => {
        this.teilnahmeStatisticNotAssigned = statistic;
      });
    this.refreshEmitter().subscribe((search) => {
      console.log('EinteilungKategorieComponent, Refresh Kategorie: ', search);
      this.anlassService
        .getTeilnahmeStatistic(this.anlass(), this.kategorie(), undefined, undefined, undefined, search)
        .subscribe((statistic) => {
          this.teilnahmeStatistic = statistic;
        });
    });
  }
}
