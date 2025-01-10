import { Component, OnInit } from "@angular/core";
import { ActivatedRoute, Router } from "@angular/router";
import { select, Store } from "@ngrx/store";
import { Observable } from "rxjs";
import { AnzeigeStatusEnum } from "src/app/core/model/AnzeigeStatusEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IAnlassSummary } from "src/app/core/model/IAnlassSummary";
import { IOrganisationAnlassLink } from "src/app/core/model/IOrganisationAnlassLink";
import { IUser } from "src/app/core/model/IUser";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";
import { WertungsrichterStatusEnum } from "src/app/core/model/WertungsrichterStatusEnum";
import { selectAnlassById } from "src/app/core/redux/anlass";
import { AppState } from "src/app/core/redux/core.state";
import { selectVereinById } from "src/app/core/redux/verein";
import { AnlassService } from "src/app/core/service/anlass/anlass.service";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { WertungsrichterService } from "src/app/core/service/wertungsrichter.service";
import { SubscriptionHelper } from "src/app/utils/subscription-helper";
import { IVerein } from "src/app/verein/verein";

@Component({
  selector: "app-event-register-summary",
  templateUrl: "./event-register-summary.component.html",
  styleUrls: ["./event-register-summary.component.css"],
})
export class EventRegisterSummaryComponent
  extends SubscriptionHelper
  implements OnInit
{
  anlass: IAnlass;
  anlass$: Observable<IAnlass>;
  // organisationAnlassLink: IOrganisationAnlassLink;

  anlassSummary: IAnlassSummary;
  organisator: IVerein;

  assignedWr1s = new Array<IUser>();
  assignedWr2s = new Array<IUser>();

  //anzahlTeilnehmer;

  constructor(
    public authService: AuthService,
    private store: Store<AppState>,
    private anlassService: AnlassService,
    // private anlassService: CachingAnlassService,
    private wertungsrichterService: WertungsrichterService,
    private route: ActivatedRoute,
    private router: Router,
    private angWindow: Window
  ) {
    super();
  }

  ngOnInit() {
    const anlassId: string = this.route.snapshot.params.id;
    this.anlass$ = this.store.pipe(select(selectAnlassById(anlassId)));
    this.registerSubscription(
      this.anlass$.subscribe((data) => {
        this.anlass = data;
        this.loadAnlassRelated();
      })
    );
    // console.log("url param: ", anlassId);
    // this.anlass = this.anlassService.getAnlassById(anlassId);
  }

  private loadAnlassRelated() {
    this.registerSubscription(
      this.anlassService
        .getAnlassOrganisationSummary(
          this.anlass,
          this.authService.currentVerein
        )
        .subscribe((result) => {
          this.anlassSummary = result;
        })
    );
    this.registerSubscription(
      this.store
        .pipe(select(selectVereinById(this.anlass.organisatorId)))
        .subscribe((result) => {
          this.organisator = result;
        })
    );

    /*


    this.registerSubscription(
      this.anlassService
        .getVereinStart(this.anlass, this.authService.currentVerein)
        .subscribe((result) => {
          this.organisationAnlassLink = result;
          this.anlass.erfassenVerlaengert = result.verlaengerungsDate;
        })
    );
    this.anzahlTeilnehmer = 0;
    // Ersetzen mit Summary ?
    this.registerSubscription(
      this.anlassService
        .loadTeilnahmen(this.anlass, this.authService.currentVerein, true)
        .subscribe((result) => {
          if (result) {
            const links = this.anlassService.getTeilnehmerForAnlass(
              this.anlass
            );
            if (links) {
              this.anzahlTeilnehmer = links.filter((link) => {
                return link.kategorie !== KategorieEnum.KEINE_TEILNAHME;
              }).length;
            }
          }
        })
    );
    */
    this.fillassignedWrs();
  }

  print() {
    this.angWindow.print();
  }
  printWRs() {
    this.registerSubscription(
      this.anlassService
        .getVereinWertungsrichterKontrollePdf(
          this.anlass,
          this.authService.currentVerein
        )
        .subscribe((result) => {})
    );
  }

  get titel(): string {
    return (
      this.anlass.getCleaned() + " - " + this.authService.currentVerein.name
    );
  }
  get vereinStarted(): boolean {
    // return this.organisationAnlassLink?.startet;
    return this.anlassSummary?.startet;
  }

  getTeilnahmenForKategorieK1(): number {
    /*
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K1
    ).length;
    */
    return this.anlassSummary.startendeK1;
  }
  getTeilnahmenForKategorieK2(): number {
    /*
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K2
    ).length;
    */
    return this.anlassSummary.startendeK2;
  }
  getTeilnahmenForKategorieK3(): number {
    /*
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K3
    ).length;
    */
    return this.anlassSummary.startendeK3;
  }
  getTeilnahmenForKategorieK4(): number {
    /*
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K4
    ).length;
    */
    return this.anlassSummary.startendeK4;
  }
  getTeilnahmenForKategorieK5(): number {
    /*
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K5
    ).length;
    */
    return this.anlassSummary.startendeK5;
  }
  getTeilnahmenForKategorieK5A(): number {
    /*
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K5A
    ).length;
    */
    return this.anlassSummary.startendeK5A;
  }
  getTeilnahmenForKategorieK5B(): number {
    /*
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K5B
    ).length;
    */
    return this.anlassSummary.startendeK5B;
  }
  getTeilnahmenForKategorieK6(): number {
    /*
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K6
    ).length;
    */
    return this.anlassSummary.startendeK6;
  }
  getTeilnahmenForKategorieKD(): number {
    /*
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.KD
    ).length;
    */
    return this.anlassSummary.startendeKD;
  }
  getTeilnahmenForKategorieKH(): number {
    /*
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.KH
    ).length;
    */
    return this.anlassSummary.startendeKH;
  }
  getTeilnahmenForKategorieK7(): number {
    /*
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K7
    ).length;
    */
    return this.anlassSummary.startendeK7;
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
    if (!this.anlassSummary?.startet) {
      return { redNoMargin: true };
    } else {
      return { greenNoMargin: true };
    }
  }

  get totalTeilnehmer(): number {
    return this.anlassSummary.startendeBr1 + this.anlassSummary.startendeBr2;
  }

  get hasTeilnehmer(): boolean {
    return this.totalTeilnehmer > 0;
  }

  getTeilnehmerClass() {
    if (this.hasTeilnehmer) {
      return { greenNoMargin: true };
    } else {
      return { redNoMargin: true };
    }
  }

  getWertungsrichterClass() {
    if (this.hasTeilnehmer) {
      return { greenNoMargin: true };
    } else {
      return { redNoMargin: true };
    }
  }
  handleClickMe(event: PointerEvent) {
    // this.anlassClick.emit(this.anlass.anlassBezeichnung);
    this.router.navigate(["/anlass/", this.anlass?.id]);
  }

  vereinStartedClicked(event: PointerEvent) {
    console.log(event);
    /*
    event.cancelBubble = true;
    this.registerSubscription(
      this.anlassService
        .updateVereinsStart(this.organisationAnlassLink)
        .subscribe((result) => {
          console.log("Clicked: ", result);
        })
    );
    */
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
      this.anlassSummary,
      this.assignedWr1s,
      this.assignedWr2s
    );
  }
  fillassignedWrs() {
    this.registerSubscription(
      this.wertungsrichterService
        .getEingeteilteWertungsrichter(this.anlass, 1)
        .subscribe((assignedWrs) => (this.assignedWr1s = assignedWrs))
    );
    this.registerSubscription(
      this.wertungsrichterService
        .getEingeteilteWertungsrichter(this.anlass, 2)
        .subscribe((assignedWrs) => (this.assignedWr2s = assignedWrs))
    );
  }
}
