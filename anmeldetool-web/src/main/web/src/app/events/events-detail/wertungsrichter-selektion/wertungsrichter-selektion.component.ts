import {
  CdkDragDrop,
  moveItemInArray,
  transferArrayItem,
} from "@angular/cdk/drag-drop";
import {
  AfterViewInit,
  Component,
  Input,
  OnInit,
  ViewChild,
} from "@angular/core";
import { MatTabGroup } from "@angular/material/tabs";
import { select, Store } from "@ngrx/store";
import { Observable } from "rxjs";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IAnlassSummary } from "src/app/core/model/IAnlassSummary";
import { IUser } from "src/app/core/model/IUser";
import { WertungsrichterStatusEnum } from "src/app/core/model/WertungsrichterStatusEnum";
import { AppState } from "src/app/core/redux/core.state";
import { selectVereinById } from "src/app/core/redux/verein";
import { AnlassService } from "src/app/core/service/anlass/anlass.service";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { WertungsrichterService } from "src/app/core/service/wertungsrichter.service";
import { SubscriptionHelper } from "src/app/utils/subscription-helper";
import { IVerein } from "src/app/verein/verein";

@Component({
  selector: "app-wertungsrichter-selektion",
  templateUrl: "./wertungsrichter-selektion.component.html",
  styleUrls: ["./wertungsrichter-selektion.component.css"],
})
export class WertungsrichterSelektionComponent
  extends SubscriptionHelper
  implements OnInit, AfterViewInit
{
  @ViewChild("tabs") tabGroup: MatTabGroup;

  @Input()
  anlass: IAnlass;

  // @Input()
  anlassSummary: IAnlassSummary;
  anlassSummary$: Observable<IAnlassSummary>; // TODO REDUX

  statusBr1: WertungsrichterStatusEnum;
  statusBr2: WertungsrichterStatusEnum;
  useBrevet2: boolean = false;

  assignedWr1s = new Array<IUser>();
  assignedWr2s = new Array<IUser>();
  wr1s = new Array<IUser>();
  wr2s = new Array<IUser>();

  wertungsrichterPflichtBrevet1: number;
  wertungsrichterPflichtBrevet2: number;

  availableWertungsrichter1: IUser[] = new Array<IUser>();
  availableWertungsrichter2: IUser[] = new Array<IUser>();

  isWertungsrichter1Ok: boolean;
  isWertungsrichter2Ok: boolean;

  constructor(
    public authService: AuthService,
    private anlassService: AnlassService,
    private wertungsrichterService: WertungsrichterService
  ) {
    super();
  }
  ngOnInit() {
    /* TODO REDUX */
    this.anlassSummary$ = this.anlassService.getAnlassOrganisationSummary(
      this.anlass,
      this.authService.currentVerein
    );
    this.registerSubscription(
      this.anlassSummary$.subscribe((result) => {
        this.anlassSummary = result;
        this.wrInit();
      })
    );
    /* TODO REDUX */
  }

  ngAfterViewInit(): void {
    if (this.tabGroup) {
      if (this.isBrevet1Anlass()) {
        this.tabGroup.selectedIndex = 0;
      } else {
        this.tabGroup.selectedIndex = 1;
      }
    }
  }

  wrInit() {
    this.wertungsrichterService
      .getEingeteilteWertungsrichter(this.anlass, 1)
      .subscribe((assignedWrs) => {
        // this.assignedWr1s = assignedWrs;
        this.assignedWr1s = this.assignedWr1s.concat(assignedWrs);
        // console.log("has assigned Wrs 1 : ", assignedWrs);
        this.updateStatus();
        this.availableWertungsrichter1 = this.getAvailableWertungsrichter1();
      });
    this.wertungsrichterService
      .getEingeteilteWertungsrichter(this.anlass, 2)
      .subscribe((assignedWrs) => {
        this.assignedWr2s = assignedWrs;
        // console.log("has assigned Wrs 2 : ", assignedWrs);
        this.updateStatus();
        if (!this.isBrevet2Anlass() && assignedWrs?.length > 0) {
          this.assignedWr1s = this.assignedWr1s.concat(assignedWrs);
          this.useBrevet2 = true;
        }
        this.availableWertungsrichter2 = this.getAvailableWertungsrichter2();
      });
    // ist asynchron
    this.getVerfuegbareWertungsrichter(this.wr1s, 1);
    this.getVerfuegbareWertungsrichter(this.wr2s, 2);

    this.wertungsrichterPflichtBrevet1 =
      this.getWertungsrichterPflichtBrevet1();
    this.wertungsrichterPflichtBrevet2 =
      this.getWertungsrichterPflichtBrevet2();
  }

  updateStatus() {
    this.statusBr1 = this.getStatusBr1();
    this.statusBr2 = this.getStatusBr2();
    this.isWertungsrichter1Ok = this.getIsWertungsrichter1Ok();
    this.isWertungsrichter2Ok = this.getIsWertungsrichter2Ok();
  }

  getIsWertungsrichter1Ok(): boolean {
    return this.statusBr1 !== WertungsrichterStatusEnum.NOTOK;
  }
  getIsWertungsrichter2Ok(): boolean {
    return this.statusBr2 !== WertungsrichterStatusEnum.NOTOK;
  }

  isBrevet1Anlass(): boolean {
    // console.log("Brevet 1: ", this.anlass.tiefsteKategorie <= KategorieEnum.K4);
    return this.anlass.brevet1Anlass;
  }
  isBrevet2Anlass(): boolean {
    // console.log("Brevet 2: ", this.anlass.hoechsteKategorie > KategorieEnum.K4);
    return this.anlass.brevet2Anlass;
  }
  useBrevet2Clicked(check: boolean) {
    //console.log("Use Brevet 2: ", this.useBrevet2);
    this.availableWertungsrichter1 = this.getAvailableWertungsrichter1();
  }

  wertungsrichterUserChange(wertungsrichterUser: IUser) {
    this.updateStatus();
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

  getWertungsrichterPflichtBrevet1(): number {
    return this.wertungsrichterService.getWertungsrichterPflichtBrevet1(
      this.anlassSummary
    );
  }

  getWertungsrichterPflichtBrevet2(): number {
    return this.wertungsrichterService.getWertungsrichterPflichtBrevet2(
      this.anlassSummary
    );
  }

  getAvailableWertungsrichter1(): IUser[] {
    if (this.useBrevet2) {
      return this.wr1s.concat(this.wr2s);
    }
    return this.wr1s;
  }

  getAvailableWertungsrichter2(): IUser[] {
    return this.wr2s;
  }

  drop(event: CdkDragDrop<String[]>, liste: string) {
    //console.log("Drop: ", event, ", liste", liste);
    if (event.previousContainer === event.container) {
      console.warn("move Drop: ", event);
      moveItemInArray(
        event.container.data,
        event.previousIndex,
        event.currentIndex
      );
      return;
    } else {
      //console.log("Transfer Drop: ", event);
      transferArrayItem(
        event.previousContainer.data,
        event.container.data,
        event.previousIndex,
        event.currentIndex
      );
      //console.log("Data: ", event.container.data[0]);
    }
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
    this.updateStatus();
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
}
