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
import type { AnlageEnum } from 'src/app/core/model/AnlageEnum';
import type { GeraeteEnum } from 'src/app/core/model/GeraeteEnum';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { ITeilnahmeStatistic } from 'src/app/core/model/ITeilnahmeStatistic';
import type { KategorieEnum } from 'src/app/core/model/KategorieEnum';
import { CachingAnlassService } from 'src/app/core/service/caching-services/caching.anlass.service';
import { EinteilungStartgeraetComponent } from '../einteilung-startgeraet/einteilung-startgeraet.component';

@Component({
  selector: 'ztv-einteilung-anlage',
  templateUrl: './einteilung-anlage.component.html',
  styleUrls: ['./einteilung-anlage.component.scss'],
  encapsulation: ViewEncapsulation.None,
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, MaterialModule, EinteilungStartgeraetComponent],
})
export class EinteilungAnlageComponent implements OnInit {
  readonly anlass = input.required<IAnlass>();
  readonly kategorie = input.required<KategorieEnum>();
  readonly abteilung = input.required<AbteilungEnum>();
  readonly anlage = input.required<AnlageEnum>();
  readonly refreshEmitter = input.required<EventEmitter<string>>();
  readonly search = input<string | undefined>();
  readonly expanded = input(false);

  teilnahmeStatistic: ITeilnahmeStatistic;

  private statisticLoaded = false;
  private otherLoaded = false;

  private readonly anlassService = inject(CachingAnlassService);
  readonly loaded$ = new Subject<boolean>();

  ngOnInit(): void {
    this.anlassService
      .getTeilnahmeStatistic(this.anlass(), this.kategorie(), this.abteilung(), this.anlage(), undefined, this.search())
      .subscribe((statistic) => {
        this.teilnahmeStatistic = statistic;
        this.loaded$.next(true);
      });
    this.refreshEmitter().subscribe((search) => {
      console.log('EinteilungAnlageComponent, Refresh Kategorie: ', search);
      this.anlassService
        .getTeilnahmeStatistic(this.anlass(), this.kategorie(), this.abteilung(), this.anlage(), undefined, search)
        .subscribe((statistic) => {
          this.teilnahmeStatistic = statistic;
        });
    });
  }

  get startgeraete(): GeraeteEnum[] {
    const startgeraete = this.anlass().getStartgeraete();
    return startgeraete;
  }
}
