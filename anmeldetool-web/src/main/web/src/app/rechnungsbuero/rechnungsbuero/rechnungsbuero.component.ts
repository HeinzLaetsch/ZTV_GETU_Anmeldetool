import { Component, EventEmitter, OnDestroy, OnInit } from "@angular/core";
import { MatSelect } from "@angular/material/select";
import { ActivatedRoute, Router } from "@angular/router";
import { Subject, Subscription } from "rxjs";
import { GeraeteEnum } from "src/app/core/model/GeraeteEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { ILaufliste } from "src/app/core/model/ILaufliste";
import { ILauflistenEintrag } from "src/app/core/model/ILauflistenEintrag";
import { IRanglistenConfiguration } from "src/app/core/model/IRanglistenConfiguration";
import { IRanglistenEntry } from "src/app/core/model/IRanglistenEntry";
import { IUser } from "src/app/core/model/IUser";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { CachingVereinService } from "src/app/core/service/caching-services/caching.verein.service";
import { RanglistenService } from "src/app/core/service/rangliste/ranglisten.service";

@Component({
  selector: "app-rechnungsbuero",
  templateUrl: "./rechnungsbuero.component.html",
  styleUrls: ["./rechnungsbuero.component.css"],
})
export class RechnungsbueroComponent implements OnInit, OnDestroy {
  currentUser: IUser;
  anlass: IAnlass;
  tiTu: TiTuEnum;
  kategorie: KategorieEnum;
  ranglistenEntries: IRanglistenEntry[];
  highlighted = false;
  config: IRanglistenConfiguration;

  constructor(
    private authService: AuthService,
    private anlassService: CachingAnlassService,
    private ranglistenService: RanglistenService,
    private route: ActivatedRoute
  ) {
    this.tiTu = TiTuEnum.Tu;
    this.kategorie = KategorieEnum.K1;
  }

  ngOnInit() {
    this.currentUser = this.authService.currentUser;
    const organisatorId: string = this.route.snapshot.params.id;
    this.anlass = this.anlassService.getAnlassByOrganisatorId(organisatorId);
    this.tiTu = this.anlass.tiTu;
    this.getRangliste();
    this.getConfig();
  }

  get filterOk(): boolean {
    return !!this.kategorie;
  }
  get anzahl(): number {
    if (this.ranglistenEntries) {
      return this.ranglistenEntries.length;
    }
    return 0;
  }
  get maxAuszeichnungen(): number {
    if (this.config) return this.config.maxAuszeichnungen;
    return 0;
  }
  set maxAuszeichnungen(maxAuszeichnungen: number) {
    if (this.config) this.config.maxAuszeichnungen = maxAuszeichnungen;
  }
  sliderChanged(value: number) {
    console.log("Slider: ", value);
    this.getRangliste();
  }
  getTeamwertung() {
    let filter = "Tu";
    if (this.tiTu === TiTuEnum.Ti) {
      filter = "Ti";
    }
    this.ranglistenService.getTeamwertung(this.anlass, filter, this.kategorie);
  }

  getRanglistePdfPerVerein() {
    let filter = "Tu";
    if (this.tiTu === TiTuEnum.Ti) {
      filter = "Ti";
    }
    this.ranglistenService.getRanglistePdfPerVerein(
      this.anlass,
      filter,
      this.kategorie
    );
  }
  getRanglistePdf() {
    let filter = "Tu";
    if (this.tiTu === TiTuEnum.Ti) {
      filter = "Ti";
    }
    this.ranglistenService.getRanglistePdf(
      this.anlass,
      filter,
      this.kategorie,
      this.maxAuszeichnungen
    );
  }

  getRangliste() {
    let filter = "Tu";
    if (this.tiTu === TiTuEnum.Ti) {
      filter = "Ti";
    }
    this.ranglistenService
      .getRangliste(this.anlass, filter, this.kategorie, this.maxAuszeichnungen)
      .subscribe((result) => {
        this.ranglistenEntries = result;
        this.ranglistenEntries.sort((a, b) => {
          if (a.rang < b.rang) {
            return -1;
          }
          if (a.rang > b.rang) {
            return 1;
          }
          // Da noch Namen vergleichen ?
          return 0;
        });
      });
  }

  getConfig() {
    let filter = "Tu";
    if (this.tiTu === TiTuEnum.Ti) {
      filter = "Ti";
    }
    this.ranglistenService
      .getRanglisteConfiguration(this.anlass, filter, this.kategorie)
      .subscribe((result) => {
        this.config = result;
      });
  }
  getKategorienRaw(anlass: IAnlass): KategorieEnum[] {
    return anlass.getKategorienRaw().slice(1);
  }

  kategorieSelected(kategorie: MatSelect): void {
    this.kategorie = kategorie.value;
    this.getRangliste();
    this.getConfig();
  }

  tiTuSelected(kategorie: MatSelect): void {
    this.tiTu = kategorie.value;
    this.getRangliste();
    this.getConfig();
  }

  isAlle(): boolean {
    return this.anlass.tuAnlass && this.anlass.tiAnlass;
  }

  ngOnDestroy() {}
}