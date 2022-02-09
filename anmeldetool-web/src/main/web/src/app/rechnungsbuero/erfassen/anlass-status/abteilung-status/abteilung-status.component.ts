import {
  Component,
  Input,
  OnInit,
  Output,
  ViewEncapsulation,
  EventEmitter,
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
  selector: "app-abteilung-status",
  templateUrl: "./abteilung-status.component.html",
  styleUrls: ["./abteilung-status.component.css"],
  encapsulation: ViewEncapsulation.None,
})
export class AbteilungStatusComponent implements OnInit {
  @Input()
  anlass: IAnlass;
  @Input()
  kategorie: KategorieEnum;
  @Input()
  abteilung: AbteilungEnum;
  @Output()
  erfasstEvent = new EventEmitter<ChangeEvent>();
  @Output()
  lauflisteSelectedEvent = new EventEmitter<ILaufliste>();

  erfasst: boolean;
  erfasstAnlagen: boolean[];

  anlagen: AnlageEnum[];
  constructor(private ranglistenService: RanglistenService) {
    this.erfasstAnlagen = new Array(Object.keys(AnlageEnum).length);
  }

  ngOnInit() {
    this.ranglistenService
      .getAnlagenForAnlass(this.anlass, this.kategorie, this.abteilung)
      .subscribe((anlagen) => {
        this.anlagen = anlagen;
      });
  }
  erfasstChanged(changeEvent: ChangeEvent) {
    this.erfasstAnlagen[this.getIndex(changeEvent.topic)] = changeEvent.status;
    const nichtAlle = this.erfasstAnlagen.filter((erfasst) => {
      if (erfasst === false) {
        return true;
      }
      return false;
    });
    this.erfasst = nichtAlle.length === 0;
    const eventData: ChangeEvent = {
      status: this.erfasst,
      topic: this.abteilung,
    };
    this.erfasstEvent.emit(eventData);
  }

  lauflisteSelected(laufliste: ILaufliste): void {
    this.lauflisteSelectedEvent.emit(laufliste);
  }

  private getIndex(anlage: AnlageEnum) {
    const index = Object.keys(AnlageEnum).indexOf(anlage);
    return index;
  }
}
