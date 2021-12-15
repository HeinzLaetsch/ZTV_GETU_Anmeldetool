import { Component, EventEmitter, Input, OnInit, Output } from "@angular/core";
import { Router } from "@angular/router";
import { AnzeigeStatusEnum } from "src/app/core/model/AnzeigeStatusEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IUser } from "src/app/core/model/IUser";
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
  vereinStarted: boolean;
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
        this.vereinStarted = result;
      });
    this.anzahlTeilnehmer = 0;
    this.anlassService
      .loadTeilnahmen(this.anlass, this.authService.currentVerein, true)
      .subscribe((result) => {
        if (result) {
          const links = this.anlassService.getTeilnehmerForAnlass(this.anlass);
          if (links) {
            if (links.anlassLinks)
              this.anzahlTeilnehmer = links.anlassLinks.length;
          }
        }
      });
    this.fillassignedWrs();
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
    if (!this.vereinStarted) {
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
      .updateVereinsStart(
        this.anlass,
        this.authService.currentVerein,
        !this.vereinStarted
      )
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

  // TODO abfüllen
  get statusWertungsrichter(): WertungsrichterStatusEnum {
    const pflichtBrevet1 =
      this.wertungsrichterService.getWertungsrichterPflichtBrevet1(this.anlass);
    const pflichtBrevet2 =
      this.wertungsrichterService.getWertungsrichterPflichtBrevet2(this.anlass);

    const statusBrevet1 =
      this.wertungsrichterService.getStatusWertungsrichterBr(
        this.assignedWr1s,
        pflichtBrevet1
      );
    const statusBrevet2 =
      this.wertungsrichterService.getStatusWertungsrichterBr(
        this.assignedWr2s,
        pflichtBrevet2
      );
    if (statusBrevet1 === WertungsrichterStatusEnum.NOTOK) {
      return WertungsrichterStatusEnum.NOTOK;
    }
    if (statusBrevet2 === WertungsrichterStatusEnum.NOTOK) {
      return WertungsrichterStatusEnum.NOTOK;
    }
    return WertungsrichterStatusEnum.KEINEPFLICHT;
  }

  getCleaned(): string {
    return this.anlass.anlassBezeichnung.replace("%", "");
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
