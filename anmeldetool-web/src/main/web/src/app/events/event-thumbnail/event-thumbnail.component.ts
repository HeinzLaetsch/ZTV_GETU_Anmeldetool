import { Component, EventEmitter, Input, OnInit, Output } from "@angular/core";
import { Router } from "@angular/router";
import { select, Store } from "@ngrx/store";
import { Observable } from "rxjs";
import { AnzeigeStatusEnum } from "src/app/core/model/AnzeigeStatusEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IAnlassExtended } from "src/app/core/model/IAnlassExtended";
import { IAnlassSummary } from "src/app/core/model/IAnlassSummary";
import { IOrganisationAnlassLink } from "src/app/core/model/IOrganisationAnlassLink";
import { selectAktiveAnlaesse } from "src/app/core/redux/anlass";
import { AppState } from "src/app/core/redux/core.state";
import { selectVereinById } from "src/app/core/redux/verein";
import { AnlassService } from "src/app/core/service/anlass/anlass.service";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { SubscriptionHelper } from "src/app/utils/subscription-helper";
import { IVerein } from "src/app/verein/verein";

@Component({
  selector: "app-event-thumbnail",
  templateUrl: "./event-thumbnail.component.html",
  styleUrls: ["./event-thumbnail.component.css"],
})
export class EventThumbnailComponent
  extends SubscriptionHelper
  implements OnInit
{
  @Input() anlassExtended: IAnlassExtended;

  @Output() anlassClick = new EventEmitter();

  organisator: IVerein;

  constructor(
    public authService: AuthService,
    private store: Store<AppState>,
    private router: Router,

    private anlassService: AnlassService
  ) {
    super();
  }

  ngOnInit() {
    this.registerSubscription(
      this.store
        .pipe(
          select(selectVereinById(this.anlassExtended.anlass.organisatorId))
        )
        .subscribe((result) => {
          this.organisator = result;
        })
    );
  }

  isEnabled(): boolean {
    return this.authService.currentVerein.name != "ZTV";
  }

  getClassForAnzeigeStatus(anzeigeStatus: AnzeigeStatusEnum): string {
    if (this.anlassExtended.anlass.anzeigeStatus.hasStatus(anzeigeStatus)) {
      return "div-red";
    }
    return "div-green";
  }

  getStartedClass() {
    if (!this.anlassExtended.summary?.startet) {
      return { redNoMargin: true };
    } else {
      return { greenNoMargin: true };
    }
  }

  get hasTeilnehmer(): boolean {
    return (
      this.anlassExtended.summary.startendeBr1 +
        this.anlassExtended.summary.startendeBr2 >
      0
    );
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
      return { redNoMargin: true };
    } else {
      return { greenNoMargin: true };
    }
  }
  handleClickMe(event: MouseEvent) {
    // this.anlassClick.emit(this.anlass.anlassBezeichnung);
    this.router.navigate(["/anlaesse/", this.anlassExtended.anlass?.id]);
  }

  vereinStartedClicked(event: MouseEvent) {
    console.log(event);
    event.cancelBubble = true;
    const organisationAnlassLink: IOrganisationAnlassLink = {
      anlassId: this.anlassExtended.anlass.id,
      organisationsId: this.authService.currentVerein.id,
      startet: this.anlassExtended.summary.startet,
      verlaengerungsDate: this.anlassExtended.summary.verlaengerungsDate,
    };
    // Sollte ersetzt werden
    this.registerSubscription(
      this.anlassService
        .updateVereinsStart(organisationAnlassLink)
        .subscribe((result) => {
          console.log("Clicked: ", result);
        })
    );
  }

  get isWertungsrichterOk(): boolean {
    if (this.hasTeilnehmer) {
      return (
        this.anlassExtended.summary.br1Ok && this.anlassExtended.summary.br2Ok
      );
    }
    return true;
  }
}
