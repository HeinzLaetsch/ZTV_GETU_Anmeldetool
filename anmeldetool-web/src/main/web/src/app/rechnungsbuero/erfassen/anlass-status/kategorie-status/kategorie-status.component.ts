import {
  Component,
  EventEmitter,
  Input,
  OnInit,
  Output,
  ViewEncapsulation,
} from "@angular/core";
import { AbteilungEnum } from "src/app/core/model/AbteilungEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { ILaufliste } from "src/app/core/model/ILaufliste";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { RanglistenService } from "src/app/core/service/rangliste/ranglisten.service";
import { ChangeEvent } from "src/app/rechnungsbuero/model/change-event";

@Component({
  selector: "app-kategorie-status",
  templateUrl: "./kategorie-status.component.html",
  styleUrls: ["./kategorie-status.component.css"],
  encapsulation: ViewEncapsulation.None,
})
export class KategorieStatusComponent implements OnInit {
  @Input()
  anlass: IAnlass;
  @Input()
  kategorie: KategorieEnum;
  @Input()
  erfasstChangedEmitter: EventEmitter<ILaufliste>;
  @Input()
  checkedChangedEmitter: EventEmitter<ILaufliste>;
  @Output()
  lauflisteSelectedEvent = new EventEmitter<ILaufliste>();

  abteilungen: AbteilungEnum[];

  erfasst = false;
  erfasstAbteilungen: boolean[];
  checked = false;
  checkedAbteilungen: boolean[];

  constructor(private ranglistenService: RanglistenService) {
    this.erfasstAbteilungen = new Array(Object.keys(AbteilungEnum).length);
    this.checkedAbteilungen = new Array(Object.keys(AbteilungEnum).length);
  }

  ngOnInit() {
    this.ranglistenService
      .getAbteilungenForAnlass(this.anlass, this.kategorie)
      .subscribe((abteilungen) => {
        this.abteilungen = abteilungen;
      });
    this.erfasstChangedEmitter.subscribe((laufliste) => {
      // console.log("KategorieStatusComponent: Laufliste changed: ", laufliste);
    });
  }

  erfasstChanged(changeEvent: ChangeEvent) {
    this.erfasstAbteilungen[this.getIndex(changeEvent.topic)] =
      changeEvent.status;
    const nichtAlle = this.erfasstAbteilungen.filter((erfasst) => {
      if (erfasst === false) {
        return true;
      }
      return false;
    });
    this.erfasst = nichtAlle.length === 0;
  }
  checkedChanged(changeEvent: ChangeEvent) {
    this.checkedAbteilungen[this.getIndex(changeEvent.topic)] =
      changeEvent.status;
    const nichtAlle = this.checkedAbteilungen.filter((checked) => {
      if (checked === false) {
        return true;
      }
      return false;
    });
    this.checked = nichtAlle.length === 0;
  }

  lauflisteSelected(laufliste: ILaufliste): void {
    this.lauflisteSelectedEvent.emit(laufliste);
  }

  private getIndex(abteilung: AbteilungEnum) {
    const index = Object.keys(AbteilungEnum).indexOf(abteilung);
    return index;
  }
}
