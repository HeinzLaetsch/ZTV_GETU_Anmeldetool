import {
  Component,
  EventEmitter,
  Input,
  OnInit,
  Output,
  ViewEncapsulation,
} from "@angular/core";
import { AbteilungEnum } from "src/app/core/model/AbteilungEnum";
import { AnlageEnum } from "src/app/core/model/AnlageEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { ILaufliste } from "src/app/core/model/ILaufliste";
import { IUser } from "src/app/core/model/IUser";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { RanglistenService } from "src/app/core/service/rangliste/ranglisten.service";
import { ChangeEvent } from "src/app/rechnungsbuero/model/change-event";

@Component({
  selector: "app-anlage-status",
  templateUrl: "./anlage-status.component.html",
  styleUrls: ["./anlage-status.component.css"],
  encapsulation: ViewEncapsulation.None,
})
export class AnlageStatusComponent implements OnInit {
  @Input()
  anlass: IAnlass;
  @Input()
  kategorie: KategorieEnum;
  @Input()
  abteilung: AbteilungEnum;
  @Input()
  anlage: AnlageEnum;
  @Input()
  erfasstChangedEmitter: EventEmitter<ILaufliste>;
  @Input()
  checkedChangedEmitter: EventEmitter<ILaufliste>;
  @Output()
  erfasstEvent = new EventEmitter<ChangeEvent>();
  @Output()
  checkedEvent = new EventEmitter<ChangeEvent>();
  @Output()
  lauflisteSelectedEvent = new EventEmitter<ILaufliste>();

  lauflisten: ILaufliste[];

  erfasst = true;
  erfasstLauflisten: boolean[];

  checked = true;
  checkedLauflisten: boolean[];

  constructor(private ranglistenService: RanglistenService) {
    this.erfasstLauflisten = new Array<boolean>();
    this.checkedLauflisten = new Array<boolean>();
  }

  ngOnInit(): void {
    this.ranglistenService
      .getLauflisten(this.anlass, this.kategorie, this.abteilung, this.anlage)
      .subscribe((lauflisten) => {
        this.lauflisten = lauflisten.sort((a, b) => {
          if (a.geraet < b.geraet) {
            return -1;
          }
          if (a.geraet > b.geraet) {
            return 1;
          }
          return 0;
        });
        this.lauflisten.forEach((laufliste) => {
          this.erfasstLauflisten.push(laufliste.erfasst);
          this.checkedLauflisten.push(laufliste.checked);
        });
        this.erfasstChanged();
        this.checkedChanged();
      });
    this.erfasstChangedEmitter.subscribe((laufliste) => {
      // console.log("AnlageStatusComponent: Laufliste changed: ", laufliste);
    });
  }

  lauflisteErfasstChanged(lauflisten: ILaufliste) {
    this.erfasstChanged();
  }

  lauflisteCheckedChanged(lauflisten: ILaufliste) {
    this.checkedChanged();
  }

  erfasstChanged() {
    const nichtAlle = this.erfasstLauflisten.filter((erfasst) => {
      if (erfasst === false) {
        return true;
      }
      return false;
    });
    this.erfasst = nichtAlle.length === 0;
    const eventData: ChangeEvent = {
      status: this.erfasst,
      topic: this.anlage,
    };
    this.erfasstEvent.emit(eventData);
  }

  checkedChanged() {
    const nichtAlle = this.checkedLauflisten.filter((checked) => {
      if (checked === false) {
        return true;
      }
      return false;
    });
    this.checked = nichtAlle.length === 0;
    const eventData: ChangeEvent = {
      status: this.checked,
      topic: this.anlage,
    };
    this.checkedEvent.emit(eventData);
  }

  lauflisteSelected(laufliste: ILaufliste): void {
    this.lauflisteSelectedEvent.emit(laufliste);
  }
}
