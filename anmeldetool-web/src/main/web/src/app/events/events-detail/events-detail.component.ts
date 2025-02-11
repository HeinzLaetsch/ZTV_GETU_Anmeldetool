import { Component, OnInit } from "@angular/core";
import { ActivatedRoute, Router } from "@angular/router";
import { Update } from "@ngrx/entity";
import { select, Store } from "@ngrx/store";
import * as moment from "moment";
import { Observable } from "rxjs";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IAnlassLink } from "src/app/core/model/IAnlassLink";
import { IAnlassSummary } from "src/app/core/model/IAnlassSummary";
import { IOrganisationAnlassLink } from "src/app/core/model/IOrganisationAnlassLink";
import { ITeilnehmer } from "src/app/core/model/ITeilnehmer";
import { selectAnlassById } from "src/app/core/redux/anlass";
import {
  AnlassSummariesActions,
  selectAnlassSummaryByAnlassId,
} from "src/app/core/redux/anlass-summary";
import { AppState } from "src/app/core/redux/core.state";
import {
  OalActions,
  selectOalForKeys,
} from "src/app/core/redux/organisation-anlass";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { SubscriptionHelper } from "src/app/utils/subscription-helper";

@Component({
  selector: "app-events-detail",
  templateUrl: "./events-detail.component.html",
  styleUrls: ["./events-detail.component.css"],
})
export class EventsDetailComponent
  extends SubscriptionHelper
  implements OnInit
{
  // @ViewChild("tabs") tabGroup: MatTabGroup;

  anlass: IAnlass;
  anlass$: Observable<IAnlass>;
  anlassSummary$: Observable<IAnlassSummary>;
  anlassSummary: IAnlassSummary;

  // starts$: Observable<ReadonlyArray<IOrganisationAnlassLink>>;
  teilnehmer$: Observable<ITeilnehmer[]>;
  teilnahmenBrevet1$: Observable<ReadonlyArray<IAnlassLink>>;
  teilnahmenBrevet2$: Observable<ReadonlyArray<IAnlassLink>>;

  // starts: Array<IOrganisationAnlassLink>;
  // orgAnlassLink: IOrganisationAnlassLink;

  // _wrEinsaetze: IWertungsrichterEinsatz[];
  teilnehmer: ITeilnehmer[];
  teilnahmenBrevet1: IAnlassLink[];
  teilnahmenBrevet2: IAnlassLink[];

  //vereinStartet = false;

  constructor(
    public authService: AuthService,
    private store: Store<AppState>,
    private route: ActivatedRoute,
    private router: Router
  ) {
    super();
    // TODO REDUX store.dispatch(AnlassSummaryActions.loadAllAnlasssummaryInvoked());
  }

  ngOnInit() {
    const anlassId: string = this.route.snapshot.params.id;

    this.anlass$ = this.store.pipe(select(selectAnlassById(anlassId)));
    this.anlassSummary$ = this.store.pipe(
      select(selectAnlassSummaryByAnlassId(anlassId))
    );

    this.registerSubscription(
      this.anlass$.subscribe((anlass) => {
        this.anlass = anlass;
      })
    );
    this.registerSubscription(
      this.anlassSummary$.subscribe((anlassSummary) => {
        this.anlassSummary = anlassSummary;
        // this.vereinStartet = this.anlassSummary.startet;
      })
    );

    /* TODO REDUX
    this.anlassSummary$ = this.store.pipe(
      select(selectAnlassSummaryByAnlassId(anlassId))
    );
    this.registerSubscription(
      this.anlassSummary$.subscribe((anlassSummary) => {
        this.anlassSummary = anlassSummary;
      })
    );
*/
    // wrInit();
  }

  handleClickMe(event: PointerEvent) {
    this.router.navigate(["anlass/anmeldungen/", this.anlass?.id]);
  }

  startetChanged(start: boolean) {
    // Hier update des via AnlassSummary
    let anlassSummaryUpdate: Update<IAnlassSummary> = {
      id: this.anlassSummary.anlassId,
      changes: {
        startet: start,
        verlaengerungsDate: this.anlassSummary.verlaengerungsDate,
      },
    };

    this.store.dispatch(
      AnlassSummariesActions.updateAnlasssummaryInvoked({
        payload: anlassSummaryUpdate,
      })
    );
    // this.vereinStartet = start;
    /*
    const tempLink = JSON.parse(JSON.stringify(this.orgAnlassLink));
    tempLink.startet = start;
    this.store.dispatch(
      OalActions.updateVereinsStartInvoked({ payload: tempLink })
    );
    */
  }
  verlaengertChanged(event: Date): void {
    // Hier als update patch schicken sowie in die Subcomponente verschieben
    const asMoment = moment(event);
    /*
    const tempLink = JSON.parse(JSON.stringify(this.orgAnlassLink));

    tempLink.verlaengerungsDate = asMoment.add(1, "h").toDate();

    this.store.dispatch(
      OalActions.updateVereinsStartInvoked({ payload: tempLink })
    );
    */
    let anlassSummaryUpdate: Update<IAnlassSummary> = {
      id: this.anlassSummary.anlassId,
      changes: {
        startet: this.anlassSummary.startet,
        verlaengerungsDate: asMoment.add(1, "h").toDate(),
      },
    };
    this.store.dispatch(
      AnlassSummariesActions.updateAnlasssummaryInvoked({
        payload: anlassSummaryUpdate,
      })
    );
    /*
    let oalUpdate: Update<IOrganisationAnlassLink> = {
      id:
        this.orgAnlassLink.anlassId + "/" + this.orgAnlassLink.organisationsId,
      changes: {
        verlaengerungsDate: asMoment.add(1, "h").toDate(),
      },
    };

    this.store.dispatch(OalActions.updateOalInvoked({ payload: oalUpdate }));
*/
    /*
    this.anlassService
      .updateVereinsStart(this.orgAnlassLink)
      .subscribe((result) => {
        this.anlass.erfassenVerlaengert = result.verlaengerungsDate;
        console.log("verlaengertChange: ", event);
      });
      */
  }
  isViewOnly(): boolean {
    return !this.authService.isAdministrator();
  }
  isTuAnlass(): boolean {
    return this.anlass.tuAnlass;
  }
  isTiAnlass(): boolean {
    return this.anlass.tiAnlass;
  }
  // TODO check with this.teilnahmenBrevet1 = this.anlassService.getTeilnahmen(this.anlass, 1);
  get anzahlTeilnehmer(): number {
    return this.teilnehmer?.length;
  }

  /*
  storeInit() {
    this.store.dispatch(OalActions.loadAllOalInvoked());
    //TODO Old style ???
    // Still needed?
    // this.store.dispatch(loadAllTeilnahmenAction());
  }
  */
  /*
  wrInit() {
    this.wertungsrichterService
      .getEingeteilteWertungsrichter(this.anlass, 1)
      .subscribe((assignedWrs) => {
        // this.assignedWr1s = assignedWrs;
        this.assignedWr1s = this.assignedWr1s.concat(assignedWrs);
        // console.log("has assigned Wrs 1 : ", assignedWrs);
        this.statusBr1 = this.getStatusBr1();
      });
    this.wertungsrichterService
      .getEingeteilteWertungsrichter(this.anlass, 2)
      .subscribe((assignedWrs) => {
        this.assignedWr2s = assignedWrs;
        // console.log("has assigned Wrs 2 : ", assignedWrs);
        this.statusBr2 = this.getStatusBr2();
        if (!this.isBrevet2Anlass() && assignedWrs?.length > 0) {
          this.assignedWr1s = this.assignedWr1s.concat(assignedWrs);
          this.useBrevet2 = true;
        }
      });
    this.getVerfuegbareWertungsrichter(this.wr1s, 1);
    this.getVerfuegbareWertungsrichter(this.wr2s, 2);
  }
  */
  /*
  anlassInit() {
    this.starts$ = this.store.pipe(
      select(
        selectOalForKeys(this.authService.currentVerein.id, this.anlass.id)
      )
    );

    this.starts$.subscribe((oalLinks) => {
      if (oalLinks !== undefined && oalLinks.length > 0) {
        this.orgAnlassLink = oalLinks[1];
        // TODO is readonly this.anlass.erfassenVerlaengert = this.orgAnlassLink.verlaengerungsDate;
      }
    });
   */
  /*
    this.teilnahmenBrevet1$ = this.store.select(
      getBrevet1Entries(this.anlass.id)
    );
    this.teilnahmenBrevet2$ = this.store.select(
      getBrevet2Entries(this.anlass.id)
    );
    this.teilnehmer$ = this.store.select(
      selectTeilnehmerForAnlassEntries(this.anlass.id)
    );
    this.teilnehmer$.subscribe((teilnehmer) => (this.teilnehmer = teilnehmer));
    */
  /*
  }
    */

  /*
  ngAfterViewInit(): void {
    if (this.isBrevet1Anlass()) {
      this.tabGroup.selectedIndex = 0;
    } else {
      this.tabGroup.selectedIndex = 1;
    }
  }
    */

  /*
  isStartedCheckboxDisabled(): boolean {
    if (
      !this.anlass.anzeigeStatus.hasStatus(AnzeigeStatusEnum.NOCH_NICHT_OFFEN)
    ) {
      if (
        !this.anlass.anzeigeStatus.hasStatus(AnzeigeStatusEnum.ERFASSEN_CLOSED)
      ) {
        return false;
      }
    }
    return true;
  }
  */
  /*
  getTeilnahmenForKategorieK1(): Observable<IAnlassLink[]> {
    return this.store.select(
      getTeilnahmenForKategorie(this.anlass.id, KategorieEnum.K1)
    );
  }
  getTeilnahmenForKategorieK2(): Observable<IAnlassLink[]> {
    return this.store.select(
      getTeilnahmenForKategorie(this.anlass.id, KategorieEnum.K2)
    );
  }
  getTeilnahmenForKategorieK3(): Observable<IAnlassLink[]> {
    return this.store.select(
      getTeilnahmenForKategorie(this.anlass.id, KategorieEnum.K3)
    );
  }
  getTeilnahmenForKategorieK4(): Observable<IAnlassLink[]> {
    return this.store.select(
      getTeilnahmenForKategorie(this.anlass.id, KategorieEnum.K4)
    );
  }
  getTeilnahmenForKategorieK5(): Observable<IAnlassLink[]> {
    return this.store.select(
      getTeilnahmenForKategorie(this.anlass.id, KategorieEnum.K5)
    );
  }
  getTeilnahmenForKategorieK5A(): Observable<IAnlassLink[]> {
    return this.store.select(
      getTeilnahmenForKategorie(this.anlass.id, KategorieEnum.K5A)
    );
  }
  getTeilnahmenForKategorieK5B(): Observable<IAnlassLink[]> {
    return this.store.select(
      getTeilnahmenForKategorie(this.anlass.id, KategorieEnum.K5B)
    );
  }
  getTeilnahmenForKategorieK6(): Observable<IAnlassLink[]> {
    return this.store.select(
      getTeilnahmenForKategorie(this.anlass.id, KategorieEnum.K6)
    );
  }
  getTeilnahmenForKategorieKD(): Observable<IAnlassLink[]> {
    return this.store.select(
      getTeilnahmenForKategorie(this.anlass.id, KategorieEnum.KD)
    );
  }
  getTeilnahmenForKategorieKH(): Observable<IAnlassLink[]> {
    return this.store.select(
      getTeilnahmenForKategorie(this.anlass.id, KategorieEnum.KH)
    );
  }
  getTeilnahmenForKategorieK7(): Observable<IAnlassLink[]> {
    return this.store.select(
      getTeilnahmenForKategorie(this.anlass.id, KategorieEnum.K7)
    );
  }

  get anzahlTeilnehmerBrevet1(): number {
    return this.teilnahmenBrevet1?.length;
  }

  get anzahlTeilnehmerBrevet2(): number {
    return this.teilnahmenBrevet2?.length;
  }

  get wertungsrichterPflichtBrevet1(): number {
    return this.wertungsrichterService.getWertungsrichterPflichtBrevet1(
      this.anlass
    );
  }

  get wertungsrichterPflichtBrevet2(): number {
    return this.wertungsrichterService.getWertungsrichterPflichtBrevet2(
      this.anlass
    );
  }
  */
  /*
  vereinStartedClicked(check: boolean) {
    this.store.dispatch(
      OalActions.updateVereinsStartInvoked({ payload: this.orgAnlassLink })
    );
  }
*/
}
