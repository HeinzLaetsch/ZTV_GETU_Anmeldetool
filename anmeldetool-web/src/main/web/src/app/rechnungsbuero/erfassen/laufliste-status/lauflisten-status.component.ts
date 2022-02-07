import { Component, Input, OnInit, Output } from "@angular/core";
import { AbteilungEnum } from "src/app/core/model/AbteilungEnum";
import { AnlageEnum } from "src/app/core/model/AnlageEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IUser } from "src/app/core/model/IUser";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { RanglistenService } from "src/app/core/service/rangliste/ranglisten.service";

@Component({
  selector: "app-lauflisten-status",
  templateUrl: "./lauflisten-status.component.html",
  styleUrls: ["./lauflisten-status.component.css"],
})
export class LauflistenStatusComponent implements OnInit {
  @Input()
  anlass: IAnlass;

  currentUser: IUser;
  panelOpenState = false;

  kategorien: KategorieEnum[];
  abteilungen: AbteilungEnum[][];
  anlagen: AnlageEnum;

  constructor(
    private authService: AuthService,
    private ranglistenService: RanglistenService
  ) {
    this.abteilungen = new Array();
  }

  ngOnInit() {
    this.currentUser = this.authService.currentUser;
    this.kategorien = this.anlass.getKategorienRaw().slice(1);
    this.kategorien.forEach((kategorie) => {
      this.abteilungen.push([]);
      this.ranglistenService
        .getAbteilungenForAnlass(this.anlass, kategorie)
        .subscribe((result) => {
          const index = this.kategorien.indexOf(kategorie);
          this.abteilungen[index] = result;
        });
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
}
