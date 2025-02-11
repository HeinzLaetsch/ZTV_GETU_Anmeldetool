import { Component, EventEmitter, Input, OnInit, Output } from "@angular/core";
import { select, Store } from "@ngrx/store";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IAnlassSummary } from "src/app/core/model/IAnlassSummary";
import { AppState } from "src/app/core/redux/core.state";
import { AnlassService } from "src/app/core/service/anlass/anlass.service";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { AnzeigeStatusEnum } from "src/app/core/model/AnzeigeStatusEnum";
import { Observable } from "rxjs";
import { IOrganisationAnlassLink } from "src/app/core/model/IOrganisationAnlassLink";
import {
  OalActions,
  selectOalForKeys,
} from "src/app/core/redux/organisation-anlass";
import { SubscriptionHelper } from "src/app/utils/subscription-helper";
import * as moment from "moment";

@Component({
  selector: "app-anlass-statistik",
  templateUrl: "./anlass-statistik.component.html",
  styleUrls: ["./anlass-statistik.component.css"],
})
export class AnlassStatistikComponent
  extends SubscriptionHelper
  implements OnInit
{
  @Input()
  anlass: IAnlass;
  @Input()
  anlassSummary: IAnlassSummary;

  @Output()
  startetChanged = new EventEmitter();

  // anlassSummary$: Observable<IAnlassSummary>;

  orgAnlassLink: IOrganisationAnlassLink;
  //starts$: Observable<ReadonlyArray<IOrganisationAnlassLink>>;

  startet: boolean;

  constructor(
    public authService: AuthService //private store: Store<AppState>,
  ) //private anlassService: AnlassService
  {
    super();
  }
  ngOnInit() {
    this.startet = this.anlassSummary.startet;
    /*
    this.anlassSummary$ = this.anlassService.getAnlassOrganisationSummary(
      this.anlass,
      this.authService.currentVerein
    );
    */
    /*
    this.starts$ = this.store.pipe(
      select(
        selectOalForKeys(this.authService.currentVerein.id, this.anlass.id)
      )
    );
    */
    /*
    this.registerSubscription(
      this.anlassSummary$.subscribe((result) => {
        this.anlassSummary = result;
        this.anlassSummary.startendeK2 = result.startendeK2;
        this.startetClicked.emit(this.anlassSummary.startet);
      })
    );
    */
    /*
    this.registerSubscription(
      this.starts$.subscribe((oalLinks) => {
        if (oalLinks !== undefined && oalLinks.length > 0) {
          this.orgAnlassLink = oalLinks[0];
        }
      })
    );
    */
  }
  isStartedCheckboxDisabled(): boolean {
    if (
      !this.anlass.anzeigeStatus.hasStatus(AnzeigeStatusEnum.NOCH_NICHT_OFFEN)
    ) {
      const asMoment = moment(this.anlassSummary.verlaengerungsDate);
      if (
        !this.anlass.anzeigeStatus.hasStatus(
          AnzeigeStatusEnum.ERFASSEN_CLOSED
        ) ||
        asMoment.isSameOrAfter(moment.now())
      ) {
        return false;
      }
    }
    return true;
  }

  vereinStartedClicked(check: boolean) {
    console.log("VereinStartedClicked: ", check);
    /*
    const newOAL = JSON.parse(JSON.stringify(this.orgAnlassLink));
    newOAL.startet = check;
    this.store.dispatch(
      OalActions.updateVereinsStartInvoked({ payload: newOAL })
    );
    */
    this.startetChanged.emit(check);
  }

  isTuAnlass(): boolean {
    return this.anlass.tuAnlass;
  }
  isTiAnlass(): boolean {
    return this.anlass.tiAnlass;
  }
  isBrevet1Anlass(): boolean {
    // console.log("Brevet 1: ", this.anlass.tiefsteKategorie <= KategorieEnum.K4);
    return this.anlass.brevet1Anlass;
  }
  isBrevet2Anlass(): boolean {
    // console.log("Brevet 2: ", this.anlass.hoechsteKategorie > KategorieEnum.K4);
    return this.anlass.brevet2Anlass;
  }
}
