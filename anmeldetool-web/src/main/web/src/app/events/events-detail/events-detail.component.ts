import {
  CdkDragDrop,
  moveItemInArray,
  transferArrayItem,
} from "@angular/cdk/drag-drop";
import { Component, OnInit } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IAnlassLink } from "src/app/core/model/IAnlassLink";
import { IUser } from "src/app/core/model/IUser";
import { IWertungsrichterAnlassLink } from "src/app/core/model/IWertungsrichterAnlassLink";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { CachingUserService } from "src/app/core/service/caching-services/caching.user.service";

@Component({
  selector: "app-events-detail",
  templateUrl: "./events-detail.component.html",
  styleUrls: ["./events-detail.component.css"],
})
export class EventsDetailComponent implements OnInit {
  anlass: IAnlass;
  vereinStarted: boolean;
  assignedWr1s = new Array<IUser>();
  assignedWr2s = new Array<IUser>();
  wr1s = new Array<IUser>();
  wr2s = new Array<IUser>();
  _wrAnlassLink: IWertungsrichterAnlassLink[];
  teilnahmenBrevet1: IAnlassLink[];
  teilnahmenBrevet2: IAnlassLink[];
  statusBr1: string;
  statusBr2: string;

  constructor(
    public authService: AuthService,
    private anlassService: CachingAnlassService,
    private userService: CachingUserService,
    private route: ActivatedRoute
  ) {}

  ngOnInit() {
    const anlassId: string = this.route.snapshot.params.id;
    // console.log("url param: ", anlassId);
    this.anlass = this.anlassService.getAnlassById(anlassId);
    this.anlassService
      .getVereinStart(this.anlass, this.authService.currentVerein)
      .subscribe((result) => {
        this.vereinStarted = result;
      });
    this.teilnahmenBrevet1 = this.anlassService.getTeilnahmen(this.anlass, 1);
    this.teilnahmenBrevet2 = this.anlassService.getTeilnahmen(this.anlass, 2);

    this.getEingeteilteWertungsrichter(this.assignedWr1s, 1);
    this.getEingeteilteWertungsrichter(this.assignedWr2s, 2);
    this.getVerfuegbareWertungsrichter(this.wr1s, 1);
    this.getVerfuegbareWertungsrichter(this.wr2s, 2);
  }

  private getVerfuegbareWertungsrichter(wrs: IUser[], brevet: number) {
    this.anlassService
      .getVerfuegbareWertungsrichter(
        this.anlass,
        this.authService.currentVerein,
        brevet
      )
      .subscribe((allUser) => {
        allUser.forEach((user) => wrs.push(user));
      });
  }

  private getEingeteilteWertungsrichter(
    assignedWrs: IUser[],
    brevet: number
  ): void {
    this.anlassService
      .getEingeteilteWertungsrichter(
        this.anlass,
        this.authService.currentVerein,
        brevet
      )
      .subscribe(
        (result) => {
          if (result) {
            result.map((link) => {
              const user = this.userService.getUserById(link.personId);
              assignedWrs.push(user);
            });
            this.statusBr1 = this.getStatusWertungsrichterBr1();
            this.statusBr2 = this.getStatusWertungsrichterBr2();
          }
        },
        (error) => {
          switch (error.status) {
            case 404: {
              break;
            }
            default: {
              console.error(error);
            }
          }
        }
      );
  }
  getCleaned(): string {
    return this.anlass.anlassBezeichnung.replace("%", "");
  }

  get anzahlTeilnehmerBrevet1(): number {
    return this.teilnahmenBrevet1.length;
  }

  get anzahlTeilnehmerBrevet2(): number {
    return this.teilnahmenBrevet2.length;
  }

  get wertungsrichterPflichtBrevet1(): string {
    if (this.anzahlTeilnehmerBrevet1 > 0)
      return ((this.anzahlTeilnehmerBrevet1 - 1) / 15 + 0.5).toFixed();
    return "0";
  }

  get wertungsrichterPflichtBrevet2(): string {
    if (this.anzahlTeilnehmerBrevet2 > 0)
      return ((this.anzahlTeilnehmerBrevet2 - 1) / 10 + 0.5).toFixed();
    return "0";
  }

  get anzahlTeilnehmer(): number {
    if (
      this.anlassService.getTeilnehmerForAnlass(this.anlass) &&
      this.anlassService.getTeilnehmerForAnlass(this.anlass).anlassLinks
    ) {
      return this.anlassService.getTeilnehmerForAnlass(this.anlass).anlassLinks
        .length;
    }
    return 0;
  }
  getStatusWertungsrichterBr1(): string {
    if (this.assignedWr1s) {
      if (
        this.wertungsrichterPflichtBrevet1 ===
        this.assignedWr1s.length.toFixed()
      ) {
        return "OK";
      }
    } else {
      if (this.wertungsrichterPflichtBrevet1 === "0") return "OK";
    }
    if (this.wertungsrichterPflichtBrevet1 == "0") {
      return "OK";
    }
    return "unvollständig";
  }

  getStatusWertungsrichterBr2(): string {
    if (this.assignedWr2s) {
      if (
        this.wertungsrichterPflichtBrevet2 ===
        this.assignedWr2s.length.toFixed()
      ) {
        return "OK";
      }
    } else {
      if (this.wertungsrichterPflichtBrevet2 === "0") return "OK";
    }
    if (this.wertungsrichterPflichtBrevet2 == "0") {
      return "OK";
    }
    return "unvollständig";
  }
  get availableWertungsrichter1(): IUser[] {
    return this.wr1s;
  }
  get availableWertungsrichter2(): IUser[] {
    return this.wr2s;
  }

  drop(event: CdkDragDrop<String[]>, liste: string) {
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
      // this.assignedRolesDirty = true;
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
            this.statusBr1 = this.getStatusWertungsrichterBr1();
            this.statusBr2 = this.getStatusWertungsrichterBr2();
          });
      } else {
        this.anlassService
          .deleteWertungsrichterFromAnlass(
            this.anlass,
            this.authService.currentVerein,
            event.container.data[event.currentIndex] as unknown as IUser
          )
          .subscribe((result) => {
            this.statusBr1 = this.getStatusWertungsrichterBr1();
            this.statusBr2 = this.getStatusWertungsrichterBr2();
          });
      }
    }
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
}
