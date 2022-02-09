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
  @Output()
  erfasstEvent = new EventEmitter<ChangeEvent>();
  @Output()
  lauflisteSelectedEvent = new EventEmitter<ILaufliste>();

  lauflisten: ILaufliste[];

  erfasst = true;
  erfasstLauflisten: boolean[];

  constructor(private ranglistenService: RanglistenService) {
    this.erfasstLauflisten = new Array<boolean>();
  }

  ngOnInit(): void {
    this.ranglistenService
      .getLauflisten(this.anlass, this.kategorie, this.abteilung, this.anlage)
      .subscribe((lauflisten) => {
        this.lauflisten = lauflisten;
        this.lauflisten.forEach((laufliste) => {
          this.erfasstLauflisten.push(laufliste.erfasst);
        });
        this.erfasstChanged();
      });
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
    eventData.status = true;
    this.erfasstEvent.emit(eventData);
  }

  lauflisteSelected(laufliste: ILaufliste): void {
    this.lauflisteSelectedEvent.emit(laufliste);
  }
}
