import { Component, EventEmitter, Input, OnInit, Output } from "@angular/core";
import { AbteilungEnum } from "src/app/core/model/AbteilungEnum";
import { AnlageEnum } from "src/app/core/model/AnlageEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { ILaufliste } from "src/app/core/model/ILaufliste";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { RanglistenService } from "src/app/core/service/rangliste/ranglisten.service";

@Component({
  selector: "app-laufliste-status",
  templateUrl: "./laufliste-status.component.html",
  styleUrls: ["./laufliste-status.component.css"],
})
export class LauflisteStatusComponent implements OnInit {
  @Input()
  anlass: IAnlass;
  @Input()
  kategorie: KategorieEnum;
  @Input()
  abteilung: AbteilungEnum;
  @Input()
  anlage: AnlageEnum;
  @Input()
  laufliste: ILaufliste;
  @Output()
  lauflisteSelectedEvent = new EventEmitter<ILaufliste>();

  constructor(private ranglistenService: RanglistenService) {}

  ngOnInit() {}

  clicked(event: any) {
    this.lauflisteSelectedEvent.emit(this.laufliste);
  }
}
