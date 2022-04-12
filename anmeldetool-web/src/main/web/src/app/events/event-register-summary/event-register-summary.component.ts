import { Component, OnInit } from "@angular/core";
import { ActivatedRoute, Router } from "@angular/router";
import { AnzeigeStatusEnum } from "src/app/core/model/AnzeigeStatusEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IOrganisationAnlassLink } from "src/app/core/model/IOrganisationAnlassLink";
import { IUser } from "src/app/core/model/IUser";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";
import { WertungsrichterStatusEnum } from "src/app/core/model/WertungsrichterStatusEnum";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { WertungsrichterService } from "src/app/core/service/wertungsrichter.service";

@Component({
  selector: "app-event-register-summary",
  templateUrl: "./event-register-summary.component.html",
  styleUrls: ["./event-register-summary.component.css"],
})
export class EventRegisterSummaryComponent implements OnInit {
  anlass: IAnlass;
  organisationAnlassLink: IOrganisationAnlassLink;
  assignedWr1s = new Array<IUser>();
  assignedWr2s = new Array<IUser>();

  anzahlTeilnehmer;

  constructor(
    public authService: AuthService,
    private anlassService: CachingAnlassService,
    private wertungsrichterService: WertungsrichterService,
    private route: ActivatedRoute,
    private router: Router,
    private angWindow: Window
  ) {}

  ngOnInit() {
    const anlassId: string = this.route.snapshot.params.id;
    // console.log("url param: ", anlassId);
    this.anlass = this.anlassService.getAnlassById(anlassId);
    this.anlassService
      .getVereinStart(this.anlass, this.authService.currentVerein)
      .subscribe((result) => {
        this.organisationAnlassLink = result;
        this.anlass.erfassenVerlaengert = result.verlaengerungsDate;
      });
    this.anzahlTeilnehmer = 0;
    this.anlassService
      .loadTeilnahmen(this.anlass, this.authService.currentVerein, true)
      .subscribe((result) => {
        if (result) {
          const links = this.anlassService.getTeilnehmerForAnlass(this.anlass);
          if (links) {
            this.anzahlTeilnehmer = links.filter((link) => {
              return link.kategorie !== KategorieEnum.KEINE_TEILNAHME;
            }).length;
          }
        }
      });
    this.fillassignedWrs();
  }

  print() {
    this.angWindow.print();
  }
  printWRs() {
    this.anlassService
      .getVereinWertungsrichterKontrollePdf(
        this.anlass,
        this.authService.currentVerein
      )
      .subscribe((result) => {});
  }

  get titel(): string {
    return (
      this.anlass.getCleaned() + " - " + this.authService.currentVerein.name
    );
  }
  get vereinStarted(): boolean {
    return this.organisationAnlassLink?.startet;
  }

  getTeilnahmenForKategorieK1(): number {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K1
    ).length;
  }
  getTeilnahmenForKategorieK2(): number {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K2
    ).length;
  }
  getTeilnahmenForKategorieK3(): number {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K3
    ).length;
  }
  getTeilnahmenForKategorieK4(): number {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K4
    ).length;
  }
  getTeilnahmenForKategorieK5(): number {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K5
    ).length;
  }
  getTeilnahmenForKategorieK5A(): number {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K5A
    ).length;
  }
  getTeilnahmenForKategorieK5B(): number {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K5B
    ).length;
  }
  getTeilnahmenForKategorieK6(): number {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K6
    ).length;
  }
  getTeilnahmenForKategorieKD(): number {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.KD
    ).length;
  }
  getTeilnahmenForKategorieKH(): number {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.KH
    ).length;
  }
  getTeilnahmenForKategorieK7(): number {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K7
    ).length;
  }

  get brevet1Anlass(): boolean {
    return this.anlass.tiefsteKategorie < KategorieEnum.K5;
  }

  get brevet2Anlass(): boolean {
    const b2 = this.anlass.hoechsteKategorie > KategorieEnum.K4;
    return b2;
  }

  get tuAnlass(): boolean {
    const tiTus = Object.keys(TiTuEnum);
    const tuAnlass =
      tiTus.indexOf(this.anlass.tiTu) === 1 ||
      tiTus.indexOf(this.anlass.tiTu) === 2;
    return tuAnlass;
  }

  get tiAnlass(): boolean {
    const tiTus = Object.keys(TiTuEnum);
    const tiuAnlass =
      tiTus.indexOf(this.anlass.tiTu) === 0 ||
      tiTus.indexOf(this.anlass.tiTu) === 2;
    return tiuAnlass;
  }

  isEnabled(): boolean {
    return true;
  }

  getClassForAnzeigeStatus(anzeigeStatus: AnzeigeStatusEnum): string {
    if (this.anlass.anzeigeStatus.hasStatus(anzeigeStatus)) {
      return "div-red";
    }
    return "div-green";
  }

  getStartedClass() {
    if (!this.organisationAnlassLink?.startet) {
      return { redNoMargin: true };
    } else {
      return { greenNoMargin: true };
    }
  }

  get hasTeilnehmer(): boolean {
    return this.anzahlTeilnehmer > 0;
  }

  getTeilnehmerClass() {
    if (this.anzahlTeilnehmer === 0) {
      return { redNoMargin: true };
    } else {
      return { greenNoMargin: true };
    }
  }

  getWertungsrichterClass() {
    if (this.anzahlTeilnehmer !== 0) {
      return { redNoMargin: true };
    } else {
      return { greenNoMargin: true };
    }
  }
  handleClickMe(event: PointerEvent) {
    // this.anlassClick.emit(this.anlass.anlassBezeichnung);
    this.router.navigate(["/anlass/", this.anlass?.id]);
  }

  vereinStartedClicked(event: PointerEvent) {
    console.log(event);
    event.cancelBubble = true;
    this.anlassService
      .updateVereinsStart(this.organisationAnlassLink)
      .subscribe((result) => {
        console.log("Clicked: ", result);
      });
  }

  get isWertungsrichterOk(): boolean {
    if (this.hasTeilnehmer) {
      return (
        this.statusWertungsrichter === WertungsrichterStatusEnum.OK ||
        this.statusWertungsrichter === WertungsrichterStatusEnum.KEINEPFLICHT
      );
    }
    return true;
  }

  get statusWertungsrichter(): WertungsrichterStatusEnum {
    return this.wertungsrichterService.getStatusWertungsrichter(
      this.anlass,
      this.assignedWr1s,
      this.assignedWr2s
    );
  }
  fillassignedWrs() {
    this.wertungsrichterService
      .getEingeteilteWertungsrichter(this.anlass, 1)
      .subscribe((assignedWrs) => (this.assignedWr1s = assignedWrs));
    this.wertungsrichterService
      .getEingeteilteWertungsrichter(this.anlass, 2)
      .subscribe((assignedWrs) => (this.assignedWr2s = assignedWrs));
  }
}
