import { THIS_EXPR } from "@angular/compiler/src/output/output_ast";
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
import { AuthService } from "src/app/core/service/auth/auth.service";

@Component({
  selector: "app-anlass-status",
  templateUrl: "./anlass-status.component.html",
  styleUrls: ["./anlass-status.component.css"],
  encapsulation: ViewEncapsulation.None,
})
export class AnlassStatusComponent implements OnInit {
  @Input()
  anlass: IAnlass;
  @Input()
  erfasstChangedEmitter: EventEmitter<ILaufliste>;
  @Input()
  checkedChangedEmitter: EventEmitter<ILaufliste>;

  @Output()
  lauflisteSelectedEvent = new EventEmitter<ILaufliste>();

  currentUser: IUser;
  panelOpenState = false;

  kategorien: KategorieEnum[];
  abteilungen: AbteilungEnum[][];
  anlagen: AnlageEnum;

  constructor(private authService: AuthService) {
    this.abteilungen = new Array();
  }

  ngOnInit() {
    this.currentUser = this.authService.currentUser;
    this.kategorien = this.anlass.getKategorienRaw().slice(1);
    this.erfasstChangedEmitter.subscribe((laufliste) => {
      // console.log("AnlassStatusComponent : Laufliste changed: ", laufliste);
    });
  }

  getKategorien(): KategorieEnum[] {
    return this.kategorien;
  }

  getAbteilungen(kategorie: KategorieEnum): AbteilungEnum[] {
    const index = this.kategorien.indexOf(kategorie);
    if (this.abteilungen[index]) {
      return this.abteilungen[index];
    }
    return [];
  }

  lauflisteSelected(laufliste: ILaufliste): void {
    this.lauflisteSelectedEvent.emit(laufliste);
  }
}
