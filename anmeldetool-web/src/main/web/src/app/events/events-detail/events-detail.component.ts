import {
  CdkDragDrop,
  moveItemInArray,
  transferArrayItem,
} from "@angular/cdk/drag-drop";
import { AfterViewInit, Component, OnInit, ViewChild } from "@angular/core";
import { MatTabGroup } from "@angular/material/tabs";
import { ActivatedRoute, Router } from "@angular/router";
import * as moment from "moment";
import { AnzeigeStatusEnum } from "src/app/core/model/AnzeigeStatusEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IAnlassLink } from "src/app/core/model/IAnlassLink";
import { IOrganisationAnlassLink } from "src/app/core/model/IOrganisationAnlassLink";
import { IUser } from "src/app/core/model/IUser";
import { IWertungsrichter } from "src/app/core/model/IWertungsrichter";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";
import { WertungsrichterStatusEnum } from "src/app/core/model/WertungsrichterStatusEnum";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { CachingTeilnehmerService } from "src/app/core/service/caching-services/caching.teilnehmer.service";
import { CachingUserService } from "src/app/core/service/caching-services/caching.user.service";
import { WertungsrichterService } from "src/app/core/service/wertungsrichter.service";

@Component({
  selector: "app-events-detail",
  templateUrl: "./events-detail.component.html",
  styleUrls: ["./events-detail.component.css"],
})
export class EventsDetailComponent implements OnInit, AfterViewInit {
  @ViewChild("tabs") tabGroup: MatTabGroup;

  anlass: IAnlass;
  orgAnlassLink: IOrganisationAnlassLink;
  assignedWr1s = new Array<IUser>();
  assignedWr2s = new Array<IUser>();
  wr1s = new Array<IUser>();
  wr2s = new Array<IUser>();
  // _wrEinsaetze: IWertungsrichterEinsatz[];
  teilnahmenBrevet1: IAnlassLink[];
  teilnahmenBrevet2: IAnlassLink[];
  statusBr1: WertungsrichterStatusEnum;
  statusBr2: WertungsrichterStatusEnum;
  useBrevet2: boolean = false;

  constructor(
    public authService: AuthService,
    private anlassService: CachingAnlassService,
    private userService: CachingUserService,
    private wertungsrichterService: WertungsrichterService,
    private teilnehmerService: CachingTeilnehmerService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit() {
    const anlassId: string = this.route.snapshot.params.id;
    // console.log("url param: ", anlassId);
    this.anlass = this.anlassService.getAnlassById(anlassId);
    this.anlassService
      .getVereinStart(this.anlass, this.authService.currentVerein)
      .subscribe((result) => {
        this.orgAnlassLink = result;
        this.anlass.erfassenVerlaengert = result.verlaengerungsDate;
      });
    this.teilnahmenBrevet1 = this.anlassService.getTeilnahmen(this.anlass, 1);
    this.teilnahmenBrevet2 = this.anlassService.getTeilnahmen(this.anlass, 2);

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
    this.teilnehmerService.loadTeilnehmer(this.authService.currentVerein);
  }
  ngAfterViewInit(): void {
    if (this.isBrevet1Anlass()) {
      this.tabGroup.selectedIndex = 0;
    } else {
      this.tabGroup.selectedIndex = 1;
    }
  }

  isViewOnly(): boolean {
    return !this.authService.isAdministrator();
  }

  verlaengertChange(event: Date): void {
    const asMoment = moment(event);
    this.orgAnlassLink.verlaengerungsDate = asMoment.add(1, "h").toDate();
    this.anlassService
      .updateVereinsStart(this.orgAnlassLink)
      .subscribe((result) => {
        this.anlass.erfassenVerlaengert = result.verlaengerungsDate;
        console.log("verlaengertChange: ", event);
      });
  }

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
  private getVerfuegbareWertungsrichter(wrs: IUser[], brevet: number) {
    this.anlassService
      .getVerfuegbareWertungsrichter(
        this.anlass,
        this.authService.currentVerein,
        brevet
      )
      .subscribe((allUser) => {
        if (allUser) {
          allUser.forEach((user) => wrs.push(user));
          wrs.sort((a, b) => {
            if (a.benutzername < b.benutzername) {
              return -1;
            }
            if (a.benutzername > b.benutzername) {
              return 1;
            }
            return 0;
          });
        }
      });
  }

  get isWertungsrichter1Ok(): boolean {
    return this.statusBr1 !== WertungsrichterStatusEnum.NOTOK;
  }
  get isWertungsrichter2Ok(): boolean {
    return this.statusBr2 !== WertungsrichterStatusEnum.NOTOK;
  }
  wertungsrichterUserChange(wertungsrichterUser: IUser) {
    this.statusBr1 = this.getStatusBr1();
    this.statusBr2 = this.getStatusBr2();
  }

  getTeilnahmenForKategorieK1(): IAnlassLink[] {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K1
    );
  }
  getTeilnahmenForKategorieK2(): IAnlassLink[] {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K2
    );
  }
  getTeilnahmenForKategorieK3(): IAnlassLink[] {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K3
    );
  }
  getTeilnahmenForKategorieK4(): IAnlassLink[] {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K4
    );
  }
  getTeilnahmenForKategorieK5(): IAnlassLink[] {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K5
    );
  }
  getTeilnahmenForKategorieK5A(): IAnlassLink[] {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K5A
    );
  }
  getTeilnahmenForKategorieK5B(): IAnlassLink[] {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K5B
    );
  }
  getTeilnahmenForKategorieK6(): IAnlassLink[] {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K6
    );
  }
  getTeilnahmenForKategorieKD(): IAnlassLink[] {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.KD
    );
  }
  getTeilnahmenForKategorieKH(): IAnlassLink[] {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.KH
    );
  }
  getTeilnahmenForKategorieK7(): IAnlassLink[] {
    return this.anlassService.getTeilnahmenForKategorie(
      this.anlass,
      KategorieEnum.K7
    );
  }

  get anzahlTeilnehmerBrevet1(): number {
    return this.teilnahmenBrevet1.length;
  }

  get anzahlTeilnehmerBrevet2(): number {
    return this.teilnahmenBrevet2.length;
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

  // TODO check with this.teilnahmenBrevet1 = this.anlassService.getTeilnahmen(this.anlass, 1);
  get anzahlTeilnehmer(): number {
    if (this.anlassService.getTeilnehmerForAnlass(this.anlass)) {
      return this.anlassService.getTeilnehmerForAnlass(this.anlass).length;
    }
    return 0;
  }
  get availableWertungsrichter1(): IUser[] {
    if (this.useBrevet2) {
      return this.wr1s.concat(this.wr2s);
    }
    return this.wr1s;
  }
  get availableWertungsrichter2(): IUser[] {
    return this.wr2s;
  }

  drop(event: CdkDragDrop<IUser[]>, liste: string) {
    console.log("Drop: ", event, ", liste", liste);
    if (event.previousContainer === event.container) {
      console.log("move Drop: ", event);
      moveItemInArray(
        event.container.data,
        event.previousIndex,
        event.currentIndex
      );
    } else {
      console.log("Transfer Drop: ", event);
      transferArrayItem(
        event.previousContainer.data,
        event.container.data,
        event.previousIndex,
        event.currentIndex
      );
      console.log("Data: ", event.container.data[0]);
      if (liste === "2") {
        this.anlassService
          .addWertungsrichterToAnlass(
            this.anlass,
            this.authService.currentVerein,
            event.container.data[event.currentIndex] as unknown as IUser
          )
          .subscribe((result) => {
            this.statusBr1 = this.getStatusBr1();
            this.statusBr2 = this.getStatusBr2();

            this.loadWrLink(
              event.container.data[event.currentIndex] as unknown as IUser
            );
          });
      } else {
        this.anlassService
          .deleteWertungsrichterFromAnlass(
            this.anlass,
            this.authService.currentVerein,
            event.container.data[event.currentIndex] as unknown as IUser
          )
          .subscribe((result) => {
            this.statusBr1 = this.getStatusBr1();
            this.statusBr2 = this.getStatusBr2();
          });
      }
    }
  }

  getStatusBr1(): WertungsrichterStatusEnum {
    this.statusBr1 = this.wertungsrichterService.getStatusWertungsrichterBr(
      this.assignedWr1s,
      this.wertungsrichterPflichtBrevet1
    );
    return this.statusBr1;
  }
  getStatusBr2(): WertungsrichterStatusEnum {
    this.statusBr2 = this.wertungsrichterService.getStatusWertungsrichterBr(
      this.assignedWr2s,
      this.wertungsrichterPflichtBrevet2
    );
    return this.statusBr2;
  }

  loadWrLink(wertungsrichterUser: IUser): void {
    this.anlassService
      .getWrEinsatz(
        this.anlass,
        this.authService.currentVerein,
        wertungsrichterUser
      )
      .subscribe((pal) => {
        wertungsrichterUser.pal = pal;
      });
  }
  useBrevet2Clicked(check: boolean) {
    console.log("Use Brevet 2: ", this.useBrevet2);
  }
  vereinStartedClicked(check: boolean) {
    this.anlassService
      .updateVereinsStart(this.orgAnlassLink)
      .subscribe((result) => {
        console.log("Clicked: ", result);
      });
  }

  handleClickMe(event: PointerEvent) {
    this.router.navigate(["anlass/anmeldungen/", this.anlass?.id]);
  }
}
