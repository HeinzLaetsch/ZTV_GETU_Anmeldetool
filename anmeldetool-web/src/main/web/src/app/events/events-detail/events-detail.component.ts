import { Component, OnInit } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { IEvent } from "../shared";
import { EventService } from "src/app/core/service/event/event.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { IAnlass } from "src/app/core/model/IAnlass";
import { AuthService } from "src/app/core/service/auth/auth.service";
import {
  CdkDragDrop,
  moveItemInArray,
  transferArrayItem,
} from "@angular/cdk/drag-drop";
import { IWertungsrichterAnlassLink } from "src/app/core/model/IWertungsrichterAnlassLink";
import { CachingTeilnehmerService } from "src/app/core/service/caching-services/caching.teilnehmer.service";
import { CachingUserService } from "src/app/core/service/caching-services/caching.user.service";
import { IUser } from "src/app/core/model/IUser";

@Component({
  selector: "app-events-detail",
  templateUrl: "./events-detail.component.html",
  styleUrls: ["./events-detail.component.css"],
})
export class EventsDetailComponent implements OnInit {
  anlass: IAnlass;
  vereinStarted: boolean;
  wrs = new Array<IUser>();
  assignedWrs = new Array<IUser>();
  _wrAnlassLink: IWertungsrichterAnlassLink[];

  constructor(
    public authService: AuthService,
    private anlassService: CachingAnlassService,
    private userService: CachingUserService,
    private route: ActivatedRoute
  ) {}

  ngOnInit() {
    const anlassId: string = this.route.snapshot.params.id;
    console.log("url param: ", anlassId);
    this.anlass = this.anlassService.getAnlassById(anlassId);
    this.anlassService
      .getVereinStart(this.anlass, this.authService.currentVerein)
      .subscribe((result) => {
        this.vereinStarted = result;
      });
    this.anlassService
      .getEingeteilteWertungsrichter(
        this.anlass,
        this.authService.currentVerein
      )
      .subscribe(
        (result) => {
          this._wrAnlassLink = result;
          this.assignedWrs = this.assignedWrs.slice(0, 0);
          if (result) {
            this._wrAnlassLink.map((link) => {
              const user = this.userService.getUserById(link.personId);
              this.assignedWrs.push(user);
            });
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
    this.wrs = this.userService.getAllWertungsrichter(1);
  }
  getCleaned(): string {
    return this.anlass.anlassBezeichnung.replace("%", "");
  }

  get anzahlTeilnehmer(): number {
    if (
      this.anlassService.getTeilnehmer(this.anlass) &&
      this.anlassService.getTeilnehmer(this.anlass).anlassLinks
    ) {
      return this.anlassService.getTeilnehmer(this.anlass).anlassLinks.length;
    }
    return 0;
  }
  get statusWertungsrichter(): string {
    return "nicht komplett";
  }
  get availableWertungsrichter(): IUser[] {
    return this.wrs;
  }
  drop(event: CdkDragDrop<String[]>) {
    console.log("Drop: ", event);
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
