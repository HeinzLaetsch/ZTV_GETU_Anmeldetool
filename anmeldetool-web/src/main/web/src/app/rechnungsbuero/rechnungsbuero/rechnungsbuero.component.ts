import { Component, EventEmitter, OnDestroy, OnInit } from "@angular/core";
import { MatSelect } from "@angular/material/select";
import { ActivatedRoute, Router } from "@angular/router";
import { Subject, Subscription } from "rxjs";
import { GeraeteEnum } from "src/app/core/model/GeraeteEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { ILaufliste } from "src/app/core/model/ILaufliste";
import { ILauflistenEintrag } from "src/app/core/model/ILauflistenEintrag";
import { ILauflistenStatus } from "src/app/core/model/ILauflistenStatus";
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
  lauflistenStatus: ILauflistenStatus;

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
    // this.getRangliste();
    this.getConfig();
    this.getRanglistenState();
  }

  getRanglistenState() {
    this.ranglistenService
      .getRanglistenState(this.anlass, this.getFilter(), this.kategorie)
      .subscribe((result) => {
        this.lauflistenStatus = result;
      });
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
  get label(): string {
    if (!this.ranglistenEntries) {
      return "? / ?%";
    }
    const labelAsString =
      "Rang " +
      this.maxAuszeichnungen +
      " / " +
      (this.maxAuszeichnungen / this.ranglistenEntries.length) * 100 +
      " %";
    this.ranglistenEntries;
    return labelAsString;
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
  private getFilter(): string {
    let filter = "Tu";
    if (this.isAlle()) {
      filter = "Ti";
      if (TiTuEnum.Tu === this.tiTu) {
        filter = "Tu";
      }
    } else {
      if (this.anlass.tiAnlass) {
        filter = "Ti";
      } else {
        filter = "Tu";
      }
    }
    return filter;
  }
  getTeamwertung() {
    this.ranglistenService.getTeamwertung(
      this.anlass,
      this.getFilter(),
      this.kategorie
    );
  }

  getRanglistePdfPerVerein() {
    this.ranglistenService.getRanglistePdfPerVerein(
      this.anlass,
      this.getFilter(),
      this.kategorie
    );
  }

  getRanglistePdf() {
    this.ranglistenService.getRanglistePdf(
      this.anlass,
      this.getFilter(),
      this.kategorie,
      this.maxAuszeichnungen
    );
  }

  getRanglisteCsv() {
    this.ranglistenService.getRanglisteCsv(
      this.anlass,
      this.getFilter(),
      this.kategorie,
      this.maxAuszeichnungen
    );
  }

  getRangliste() {
    this.ranglistenService
      .getRangliste(
        this.anlass,
        this.getFilter(),
        this.kategorie,
        this.maxAuszeichnungen
      )
      .subscribe((result) => {
        this.ranglistenEntries = result;
        if (result) {
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
        }
      });
  }

  getConfig() {
    this.ranglistenService
      .getRanglisteConfiguration(this.anlass, this.getFilter(), this.kategorie)
      .subscribe((result) => {
        this.config = result;
        this.getRangliste();
      });
  }
  getKategorienRaw(anlass: IAnlass): KategorieEnum[] {
    return anlass.getKategorienRaw().slice(1);
  }

  kategorieSelected(kategorie: MatSelect): void {
    this.kategorie = kategorie.value;
    //     this.getRangliste();
    this.getConfig();
    this.getRanglistenState();
  }

  tiTuSelected(kategorie: MatSelect): void {
    this.tiTu = TiTuEnum[kategorie.value];
    // this.getRangliste();
    const b1 = TiTuEnum.Tu === this.tiTu;
    const b2 = TiTuEnum.Ti === this.tiTu;
    this.getConfig();
    this.getRanglistenState();
  }

  isAlle(): boolean {
    return this.anlass.alleAnlass;
  }

  ngOnDestroy() {}
}
