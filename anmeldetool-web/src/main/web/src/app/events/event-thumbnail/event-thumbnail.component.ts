import { Component, EventEmitter, Input, OnInit, Output } from "@angular/core";
import { Router } from "@angular/router";
import { AnzeigeStatusEnum } from "src/app/core/model/AnzeigeStatusEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IAnlassSummary } from "src/app/core/model/IAnlassSummary";
import { IOrganisationAnlassLink } from "src/app/core/model/IOrganisationAnlassLink";
import { AnlassService } from "src/app/core/service/anlass/anlass.service";
import { AuthService } from "src/app/core/service/auth/auth.service";

@Component({
  selector: "app-event-thumbnail",
  templateUrl: "./event-thumbnail.component.html",
  styleUrls: ["./event-thumbnail.component.css"],
})
export class EventThumbnailComponent implements OnInit {
  @Input() anlass: IAnlass;
  @Output() anlassClick = new EventEmitter();

  // organisationAnlassLink: IOrganisationAnlassLink;
  anlassSummary: IAnlassSummary;

  constructor(
    public authService: AuthService,
    private anlassService: AnlassService,
    private router: Router
  ) {}

  ngOnInit() {
    this.anlassService
      .getAnlassOrganisationSummary(this.anlass, this.authService.currentVerein)
      .subscribe((result) => {
        this.anlassSummary = result;
      });
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

  get hasTeilnehmer(): boolean {
    return (
      this.anlassSummary.startendeBr1 + this.anlassSummary.startendeBr2 > 0
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
  handleClickMe(event: PointerEvent) {
    // this.anlassClick.emit(this.anlass.anlassBezeichnung);
    this.router.navigate(["/anlaesse/", this.anlass?.id]);
  }

  vereinStartedClicked(event: PointerEvent) {
    console.log(event);
    event.cancelBubble = true;
    const organisationAnlassLink: IOrganisationAnlassLink = {
      anlassId: this.anlass.id,
      organisationsId: this.authService.currentVerein.id,
      startet: this.anlassSummary.startet,
      verlaengerungsDate: this.anlassSummary.verlaengerungsDate,
    };
    this.anlassService
      .updateVereinsStart(organisationAnlassLink)
      .subscribe((result) => {
        console.log("Clicked: ", result);
      });
  }

  get isWertungsrichterOk(): boolean {
    if (this.hasTeilnehmer) {
      return this.anlassSummary.br1Ok && this.anlassSummary.br2Ok;
    }
    return true;
  }
}
