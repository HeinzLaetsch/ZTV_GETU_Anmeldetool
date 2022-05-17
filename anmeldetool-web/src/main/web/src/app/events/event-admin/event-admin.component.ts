import { Component, EventEmitter, OnInit } from "@angular/core";
import { MatDialog } from "@angular/material/dialog";
import { ActivatedRoute, Router } from "@angular/router";
import { Subject } from "rxjs";
import { takeUntil } from "rxjs/operators";
import { AbteilungEnum } from "src/app/core/model/AbteilungEnum";
import { AnlageEnum } from "src/app/core/model/AnlageEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { ITeilnahmeStatistic } from "src/app/core/model/ITeilnahmeStatistic";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { RanglistenService } from "src/app/core/service/rangliste/ranglisten.service";
import { Upload } from "./upload-dialog/upload.component";

@Component({
  selector: "app-event-admin",
  templateUrl: "./event-admin.component.html",
  styleUrls: ["./event-admin.component.css"],
})
export class EventAdminComponent implements OnInit {
  anlass: IAnlass;

  private readonly lauflistenPDF$: Subject<void> = new Subject();

  message: string;
  hasError: boolean = false;
  onlyTi = false;
  hideOnlyTi = false;

  abteilungen: AbteilungEnum[];
  selectedAbteilung: AbteilungEnum;

  kategorien: KategorieEnum[];
  selectedKategorie: KategorieEnum;

  anlagen: AnlageEnum[];
  selectedAnlage: AnlageEnum;

  teilnahmeStatistic: ITeilnahmeStatistic;

  refreshEmitter = new EventEmitter<string>();

  loaded$: Subject<boolean>;

  constructor(
    private router: Router,
    public dialog: MatDialog,
    private route: ActivatedRoute,
    public authService: AuthService,
    private anlassService: CachingAnlassService,
    private ranglistenService: RanglistenService
  ) {
    this.loaded$ = new Subject();
  }

  ngOnInit() {
    const anlassId: string = this.route.snapshot.params.id;
    // console.log("url param: ", anlassId);
    this.anlass = this.anlassService.getAnlassById(anlassId);
    if (this.anlass.alleAnlass) {
      this.hideOnlyTi = true;
    }
    this.kategorien = this.anlass.getKategorienRaw();
    this.anlassService
      .getTeilnahmeStatistic(
        this.anlass,
        undefined,
        undefined,
        undefined,
        undefined,
        undefined
      )
      .subscribe((statistic) => {
        this.teilnahmeStatistic = statistic;
        this.loaded$.next(true);
      });
  }

  get administrator(): boolean {
    return this.authService.isAdministrator();
  }

  exportMutationen(): void {
    this.anlassService.getMutationenForAnlassCsv(this.anlass);
  }

  exportTeilnehmer(): void {
    this.anlassService.getTeilnehmerForAnlassCsv(this.anlass);
  }
  importTeilnehmer(): void {
    const dialogRef = this.dialog.open(Upload, {
      data: this.anlass,
    });
  }

  exportBenutzer(): void {
    this.anlassService.getBenutzerForAnlassCsv(this.anlass);
  }

  exportWertungsrichter(): void {
    this.anlassService.getWertungsrichterForAnlassCsv(this.anlass);
  }

  exportAnmeldeKontrolle(): void {
    this.anlassService.getAnmeldeKontrolleCsv(this.anlass);
  }

  getAbteilungenForAnlass(): void {
    this.ranglistenService
      .getAbteilungenForAnlass(this.anlass, this.selectedKategorie)
      .subscribe((result) => {
        this.abteilungen = result;
      });
  }
  getAnlagenForAnlass(): void {
    this.ranglistenService
      .getAnlagenForAnlass(
        this.anlass,
        this.selectedKategorie,
        this.selectedAbteilung
      )
      .subscribe((result) => {
        this.anlagen = result;
      });
  }

  changeKategorie(event: any) {
    console.log("Event: ", event);
    this.selectedKategorie = event;
    this.selectedAbteilung = undefined;
    this.selectedAnlage = undefined;
    this.getAbteilungenForAnlass();
  }
  changeAbteilung(event: any) {
    console.log("Event: ", event);
    this.selectedAbteilung = event;
    this.selectedAnlage = undefined;
    this.getAnlagenForAnlass();
  }
  changeAnlage(event: any) {
    console.log("Event: ", event);
    this.selectedAnlage = event;
    // this.getAnlagenForAnlass();
  }

  get isButtonsDisabled(): boolean {
    if (
      this.selectedKategorie &&
      this.selectedAbteilung &&
      this.selectedAnlage
    ) {
      return false;
    }
    return true;
  }
  lauflistenLoeschen(): void {
    this.hasError = false;
    this.ranglistenService
      .deleteLauflistenForAnlassAndKategorie(
        this.anlass,
        this.selectedKategorie,
        this.selectedAbteilung,
        this.selectedAnlage
      )
      .pipe(takeUntil(this.lauflistenPDF$))
      .subscribe((result) => {
        console.error("result: ", result);
        if (!result || result === "Success") {
          this.message = "Löschen erfolgreich durchgeführt";
          this.hasError = false;
        } else {
          this.message = "Löschen fehlgeschlagen";
          this.hasError = true;
        }
        this.lauflistenPDF$.next();
      });
  }

  lauflistenPDF(): void {
    this.hasError = false;
    this.ranglistenService
      .getLauflistenPdf(
        this.anlass,
        this.selectedKategorie,
        this.selectedAbteilung,
        this.selectedAnlage,
        this.onlyTi
      )
      .pipe(takeUntil(this.lauflistenPDF$))
      .subscribe((result) => {
        console.error("result: ", result);
        if (result === "Success") {
          this.message = "Listen erfolgreich generiert";
          this.hasError = false;
        } else {
          this.message = "Listen generieren fehlgeschlagen";
          this.hasError = true;
        }
        this.lauflistenPDF$.next();
      });
  }

  refreshEinteilung(): void {
    this.refreshEmitter.emit(undefined);
  }

  toolSperrenClicked(event: any): void {
    this.anlassService
      .updateAnlass(this.anlass)
      .subscribe((anlass) => (this.anlass = anlass));
  }
}
