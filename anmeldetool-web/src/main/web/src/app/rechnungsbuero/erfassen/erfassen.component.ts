import { Component, EventEmitter, OnDestroy, OnInit } from "@angular/core";
import { ActivatedRoute, Router } from "@angular/router";
import { Subject, Subscription } from "rxjs";
import { GeraeteEnum } from "src/app/core/model/GeraeteEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { ILaufliste } from "src/app/core/model/ILaufliste";
import { ILauflistenEintrag } from "src/app/core/model/ILauflistenEintrag";
import { IUser } from "src/app/core/model/IUser";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { CachingVereinService } from "src/app/core/service/caching-services/caching.verein.service";
import { RanglistenService } from "src/app/core/service/rangliste/ranglisten.service";

@Component({
  selector: "app-erfassen",
  templateUrl: "./erfassen.component.html",
  styleUrls: ["./erfassen.component.css"],
})
export class ErfassenComponent implements OnInit, OnDestroy {
  private routeSubject: Subscription;

  checkedChangedEmitter = new EventEmitter<ILaufliste>();

  erfasstChangedEmitter = new EventEmitter<ILaufliste>();

  currentUser: IUser;
  anlass: IAnlass;
  laufliste: ILaufliste;

  search: string;

  modeErfassen = true;

  constructor(
    private authService: AuthService,
    private anlassService: CachingAnlassService,
    private ranglistenService: RanglistenService,
    private route: ActivatedRoute
  ) {}

  ngOnInit() {
    this.currentUser = this.authService.currentUser;
    const organisatorId: string = this.route.snapshot.params.id;
    this.anlass = this.anlassService.getAnlassByOrganisatorId(organisatorId);
    this.routeSubject = this.route.params.subscribe((param) => {
      if (param.function === "erfassen") {
        this.modeErfassen = true;
      } else {
        this.modeErfassen = false;
      }
    });
  }

  get sprung(): boolean {
    if (
      this.laufliste?.geraet === GeraeteEnum.SPRUNG.toString().toUpperCase()
    ) {
      return true;
    }
    return false;
  }
  get title(): string {
    if (this.modeErfassen) {
      return "Noten erfassen";
    }
    return "Note überprüfen";
  }

  searchLaufliste() {
    // console.log("Suche: ", this.search);
    this.ranglistenService
      .searchLauflisteByKey(this.anlass, this.search)
      .subscribe((laufliste) => {
        this.laufliste = laufliste;
      });
  }
  get sortedEintraege() {
    return this.laufliste.eintraege.sort((a, b) => {
      if (a.startOrder < b.startOrder) {
        return -1;
      }
      if (a.startOrder > b.startOrder) {
        return 1;
      }
      return 0;
    });
  }

  lauflisteSelected(laufliste: ILaufliste): void {
    this.search = laufliste.laufliste;
    this.searchLaufliste();
  }

  private updateLaufliste(): void {
    this.ranglistenService
      .updateLaufliste(this.anlass, this.laufliste)
      .subscribe((laufliste) => {
        this.laufliste = laufliste;
        if (this.modeErfassen) {
          this.erfasstChangedEmitter.emit(laufliste);
        } else {
          this.checkedChangedEmitter.emit(laufliste);
        }
      });
  }
  entryChanged(entry: ILauflistenEintrag) {
    const toBeUpdated = this.laufliste.eintraege.filter((eintrag) => {
      return eintrag.tal_id === entry.tal_id;
    })[0];
    if (this.modeErfassen) {
      toBeUpdated.erfasst = entry.erfasst;
      const notErfasst = this.laufliste.eintraege.filter((eintrag) => {
        return !eintrag.erfasst && !eintrag.deleted;
      });
      if (notErfasst.length === 0) {
        this.laufliste.erfasst = true;
        this.updateLaufliste();
      } else {
        // TODO handle rollback
        const old = this.laufliste.erfasst;
        this.laufliste.erfasst = false;
        if (old) {
          this.updateLaufliste();
        }
      }
    } else {
      toBeUpdated.checked = entry.checked;
      const notChecked = this.laufliste.eintraege.filter((eintrag) => {
        return !eintrag.checked && !eintrag.deleted;
      });
      if (notChecked.length === 0) {
        this.laufliste.checked = true;
        this.updateLaufliste();
      } else {
        const old = this.laufliste.checked;
        this.laufliste.checked = false;
        if (old) {
          this.updateLaufliste();
        }
      }
    }
  }

  ngOnDestroy() {
    this.routeSubject.unsubscribe();
  }
}
