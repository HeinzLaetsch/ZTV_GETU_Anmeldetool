import {
  Component,
  EventEmitter,
  Input,
  OnInit,
  ViewEncapsulation,
} from "@angular/core";
import { Subject } from "rxjs";
import { AbteilungEnum } from "src/app/core/model/AbteilungEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { ITeilnahmeStatistic } from "src/app/core/model/ITeilnahmeStatistic";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { AnlassService } from "src/app/core/service/anlass/anlass.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { RanglistenService } from "src/app/core/service/rangliste/ranglisten.service";

@Component({
  selector: "app-einteilung-kategorie",
  templateUrl: "./einteilung-kategorie.component.html",
  styleUrls: ["./einteilung-kategorie.component.css"],
  encapsulation: ViewEncapsulation.None,
})
export class EinteilungKategorieComponent implements OnInit {
  @Input()
  anlass: IAnlass;
  @Input()
  kategorie: KategorieEnum;
  @Input()
  search: string;
  @Input()
  refreshEmitter: EventEmitter<string>;

  loaded$: Subject<boolean>;

  abteilungen: AbteilungEnum[];

  teilnahmeStatistic: ITeilnahmeStatistic;
  teilnahmeStatisticNotAssigned: ITeilnahmeStatistic;

  private statisticLoaded = false;
  private otherLoaded = false;

  constructor(
    private ranglistenService: RanglistenService,
    private anlassService: CachingAnlassService
  ) {
    this.loaded$ = new Subject();
  }

  get UNDEFINED(): AbteilungEnum {
    return AbteilungEnum.UNDEFINED;
  }
  ngOnInit() {
    this.ranglistenService
      .getAbteilungenForAnlass(this.anlass, this.kategorie)
      .subscribe((abteilungen) => {
        this.abteilungen = abteilungen;
        if (this.statisticLoaded) {
          this.loaded$.next(true);
        }
        this.otherLoaded = true;
      });
    this.anlassService
      .getTeilnahmeStatistic(
        this.anlass,
        this.kategorie,
        undefined,
        undefined,
        undefined,
        this.search
      )
      .subscribe((statistic) => {
        this.teilnahmeStatistic = statistic;
        if (this.otherLoaded) {
          this.loaded$.next(true);
        }
        this.statisticLoaded = true;
      });
    this.anlassService
      .getTeilnahmeStatistic(
        this.anlass,
        this.kategorie,
        AbteilungEnum.UNDEFINED,
        undefined,
        undefined,
        this.search
      )
      .subscribe((statistic) => {
        this.teilnahmeStatisticNotAssigned = statistic;
      });
    this.refreshEmitter.subscribe((search) => {
      console.log("EinteilungKategorieComponent, Refresh Kategorie: ", search);
      this.search = search;
      this.anlassService
        .getTeilnahmeStatistic(
          this.anlass,
          this.kategorie,
          undefined,
          undefined,
          undefined,
          search
        )
        .subscribe((statistic) => {
          this.teilnahmeStatistic = statistic;
        });
    });
  }
}
