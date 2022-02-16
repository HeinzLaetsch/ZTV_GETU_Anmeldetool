import { Component, EventEmitter, OnDestroy, OnInit } from "@angular/core";
import { ActivatedRoute, Router } from "@angular/router";
import { Subject, Subscription } from "rxjs";
import { GeraeteEnum } from "src/app/core/model/GeraeteEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { ILaufliste } from "src/app/core/model/ILaufliste";
import { ILauflistenEintrag } from "src/app/core/model/ILauflistenEintrag";
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
    this.getRangliste();
  }

  getRangliste() {
    let filter = 'Tu';
    if (this.tiTu === TiTuEnum.Ti) {
      filter = 'Ti';
    }
      this.ranglistenService
        .getRangliste(this.anlass, filter, this.kategorie)
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
  ngOnDestroy() {}
}
