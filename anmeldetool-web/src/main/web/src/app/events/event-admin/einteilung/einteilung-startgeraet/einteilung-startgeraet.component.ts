import {
  Component,
  EventEmitter,
  Input,
  OnInit,
  ViewEncapsulation,
} from "@angular/core";
import { FormControl } from "@angular/forms";
import { Subject } from "rxjs";
import { AbteilungEnum } from "src/app/core/model/AbteilungEnum";
import { AnlageEnum } from "src/app/core/model/AnlageEnum";
import { GeraeteEnum } from "src/app/core/model/GeraeteEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { ITeilnahmeStatistic } from "src/app/core/model/ITeilnahmeStatistic";
import { ITeilnehmerStart } from "src/app/core/model/ITeilnehmerStart";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { MeldeStatusEnum } from "src/app/core/model/MeldeStatusEnum";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";

@Component({
  selector: "app-einteilung-startgeraet",
  templateUrl: "./einteilung-startgeraet.component.html",
  styleUrls: ["./einteilung-startgeraet.component.css"],
  encapsulation: ViewEncapsulation.None,
})
export class EinteilungStartgeraetComponent implements OnInit {
  @Input()
  anlass: IAnlass;
  @Input()
  kategorie: KategorieEnum;
  @Input()
  abteilung: AbteilungEnum;
  @Input()
  anlage: AnlageEnum;
  @Input()
  startgeraet: GeraeteEnum;
  @Input()
  refreshEmitter: EventEmitter<string>;
  @Input()
  search: string;
  @Input()
  expanded: boolean;

  loaded$: Subject<boolean>;

  private statisticLoaded = false;
  private startsLoaded = false;

  startende: ITeilnehmerStart[];

  teilnahmeStatistic: ITeilnahmeStatistic;

  displayedColumns: string[] = [
    "name",
    "vorname",
    "verein",
    "tiTu",
    "abteilung",
    "anlage",
    "startgeraet",
    "abmelden",
  ];

  startgeraeteControls_ = new Array<FormControl>();
  anlageControls_ = new Array<FormControl>();
  abteilungenControls_ = new Array<FormControl>();

  constructor(private anlassService: CachingAnlassService) {
    this.loaded$ = new Subject();
    this.startgeraeteControls_ = new Array();
  }

  ngOnInit(): void {
    this.loadData(this.search);
    this.refreshEmitter.subscribe((search) => {
      console.log(
        "EinteilungStartgeraetComponent, Refresh Kategorie: ",
        search
      );
      this.search = search;
      this.loadData(search);
    });
  }

  private loadData(search: string): void {
    this.anlassService
      .getTeilnahmeStatistic(
        this.anlass,
        this.kategorie,
        this.abteilung,
        this.anlage,
        this.startgeraet,
        search
      )
      .subscribe((statistic) => {
        this.teilnahmeStatistic = statistic;
        this.statisticLoaded = true;
        if (this.startsLoaded) {
          this.loaded$.next(true);
        }
      });

    this.anlassService
      .getByStartgeraet(
        this.anlass,
        this.kategorie,
        this.abteilung,
        this.anlage,
        this.startgeraet,
        search
      )
      .subscribe((startende) => {
        this.startende = startende;
        this.startgeraeteControls_.slice(0, 0);
        if (this.startende) {
          this.startende.forEach((start) => {
            let control = new FormControl();
            control.setValue(start.startgeraet);
            this.startgeraeteControls_.push(control);
            control = new FormControl();
            control.setValue(start.anlage);
            this.anlageControls_.push(control);
            control = new FormControl();
            control.setValue(start.abteilung);
            this.abteilungenControls_.push(control);
          });
        }
        this.startsLoaded = true;
        if (this.statisticLoaded) {
          this.loaded$.next(true);
        }
      });
  }

  get startgeraeteControls(): FormControl[] {
    return this.startgeraeteControls_;
  }
  change(rowIndex: any, colIndex: any) {
    console.log("Change ", rowIndex, " ", colIndex);
    switch (colIndex) {
      case 0:
        console.log(" Abteilung: ", this.abteilungenControls_[rowIndex].value);
        this.startende[rowIndex].abteilung =
          this.abteilungenControls_[rowIndex].value.toUpperCase();
        break;
      case 1:
        console.log(" Anlage: ", this.anlageControls_[rowIndex].value);
        this.startende[rowIndex].anlage =
          this.anlageControls_[rowIndex].value.toUpperCase();
        break;
      case 2:
        console.log(
          " Startgeraet: ",
          this.startgeraeteControls_[rowIndex].value
        );
        this.startende[rowIndex].startgeraet =
          this.startgeraeteControls_[rowIndex].value.toUpperCase();
        break;
    }
    this.anlassService
      .updateStartgeraet(this.anlass, this.startende[rowIndex])
      .subscribe(() => {});
  }

  get alleStartgeraete(): GeraeteEnum[] {
    const startgeraete = this.anlass.getStartgeraete();
    return startgeraete;
  }
  get anlageControls(): FormControl[] {
    return this.anlageControls_;
  }
  get abteilungenControls(): FormControl[] {
    return this.abteilungenControls_;
  }
  get alleAnlagen(): AnlageEnum[] {
    const anlagen = new Array<AnlageEnum>();
    anlagen.push(AnlageEnum.ANLAGE_1);
    anlagen.push(AnlageEnum.ANLAGE_2);
    anlagen.push(AnlageEnum.ANLAGE_3);
    anlagen.push(AnlageEnum.ANLAGE_4);
    return anlagen;
  }
  get alleAbteilungen(): AbteilungEnum[] {
    const abteilungen = new Array<AbteilungEnum>();
    abteilungen.push(AbteilungEnum.ABTEILUNG_1);
    abteilungen.push(AbteilungEnum.ABTEILUNG_2);
    abteilungen.push(AbteilungEnum.ABTEILUNG_3);
    abteilungen.push(AbteilungEnum.ABTEILUNG_4);
    return abteilungen;
  }
  compareWith(value1, value2) {
    if (value1 && value2 && value1.toUpperCase() === value2.toUpperCase()) {
      return value1;
    } else {
      return "";
    }
  }
  abmelden(rowIndex: number): void {
    console.log("Abmelden von ", this.startende[rowIndex].name);
    this.startende[rowIndex].meldeStatus =
      MeldeStatusEnum.ABGEMELDET_3.toString().toUpperCase();
    if (!this.anlass.aenderungenNichtMehrErlaubt) {
      this.startende[rowIndex].meldeStatus =
        MeldeStatusEnum.ABGEMELDET_1.toString().toUpperCase();
    }
    this.anlassService
      .updateStartgeraet(this.anlass, this.startende[rowIndex])
      .subscribe(() => {});
  }
}
