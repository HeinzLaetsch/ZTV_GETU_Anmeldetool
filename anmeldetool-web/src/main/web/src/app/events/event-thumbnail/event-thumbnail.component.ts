import { Component, EventEmitter, Input, OnInit, Output } from "@angular/core";
import { Router } from "@angular/router";
import { AnzeigeStatusEnum } from "src/app/core/model/AnzeigeStatusEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IOrganisationAnlassLink } from "src/app/core/model/IOrganisationAnlassLink";
import { IUser } from "src/app/core/model/IUser";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { WertungsrichterStatusEnum } from "src/app/core/model/WertungsrichterStatusEnum";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { WertungsrichterService } from "src/app/core/service/wertungsrichter.service";

@Component({
  selector: "app-event-thumbnail",
  templateUrl: "./event-thumbnail.component.html",
  styleUrls: ["./event-thumbnail.component.css"],
})
export class EventThumbnailComponent implements OnInit {
  @Input() anlass: IAnlass;
  @Output() anlassClick = new EventEmitter();

  someProperty: any = "some Text";
  organisationAnlassLink: IOrganisationAnlassLink;
  anzahlTeilnehmer: number;
  assignedWr1s = new Array<IUser>();
  assignedWr2s = new Array<IUser>();

  constructor(
    public authService: AuthService,
    private anlassService: CachingAnlassService,
    private wertungsrichterService: WertungsrichterService,
    private router: Router
  ) {}

  ngOnInit() {
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

  get vereinStarted(): boolean {
    return this.organisationAnlassLink?.startet;
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
  handleClickMe(event: MouseEvent) {
    // this.anlassClick.emit(this.anlass.anlassBezeichnung);
    this.router.navigate(["/anlass/", this.anlass?.id]);
  }

  vereinStartedClicked(event: MouseEvent) {
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
