import { Component, HostListener, OnInit, ViewChild } from "@angular/core";
import { FormBuilder } from "@angular/forms";
import { MatTabGroup } from "@angular/material/tabs";
import { Router } from "@angular/router";
import { Observable } from "rxjs";
import { tap } from "rxjs/operators";
import { IUser } from "src/app/core/model/IUser";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingTeilnehmerService } from "src/app/core/service/caching-services/caching.teilnehmer.service";
import { CachingUserService } from "src/app/core/service/caching-services/caching.user.service";
import { IVerein } from "../verein";
import { IChangeEvent } from "./change-event";
import { TeilnehmerTableComponent } from "./teilnehmer-table/teilnehmer-table.component";

@Component({
  selector: "app-teilnehmer",
  templateUrl: "./teilnehmer.component.html",
  styleUrls: ["./teilnehmer.component.css"],
})
export class TeilnehmerComponent implements OnInit {
  appearance = "outline";
  currentUser: IUser;
  _vereinsUser: IUser[];
  needsSave = false;
  needsCancel = false;
  hasErrors = false;
  events: IChangeEvent[];

  @ViewChild("tabs") tabGroup: MatTabGroup;

  @ViewChild("tableTi", { static: false })
  teilnehmerTableTi: TeilnehmerTableComponent;

  @ViewChild("tableTu", { static: false })
  teilnehmerTableTu: TeilnehmerTableComponent;

  constructor(
    private authService: AuthService,
    private userService: CachingUserService,
    private teilnehmerService: CachingTeilnehmerService,
    private router: Router
  ) {
    this.events = new Array<IChangeEvent>();
  }

  ngOnInit() {
    // console.log("ProfileComponent::ngOnInit: ", this.authService.currentUser);
    this.currentUser = this.authService.currentUser;
    this._vereinsUser = this.userService.getUser();
    this.teilnehmerService
      .loadTeilnehmer(this.authService.currentVerein)
      .subscribe((result) => {
        // console.log("TeilnehmerComponent::ngOnInit 1: ", result);
      });
  }
  @HostListener("window:beforeunload", ["$event"])
  unloadNotification($event: any) {
    if (this.disAllowTab()) {
      $event.returnValue = true;
    }
  }

  disAllowTab() {
    if (!this.teilnehmerTableTi && !this.teilnehmerTableTu) {
      return false;
    }
    if (this.teilnehmerTableTi.isDirty() || this.teilnehmerTableTu.isDirty()) {
      return true;
    } else {
      return false;
    }
  }

  get vereinsUsers(): IUser[] {
    return this._vereinsUser;
  }

  get isTeilnehmerLoaded(): Observable<number> {
    // console.log('TeilnehmerComponent::isTeilnehmerLoaded')
    return this.teilnehmerService.isTeilnehmerLoaded().pipe(
      tap((evt) => {
        // console.info("Evt: ", evt);
      })
    );
  }
  isVereinsVerantwortlicher(): boolean {
    return true;
  }
  get usertext(): string {
    return JSON.stringify(this.currentUser);
  }
  get verein(): IVerein {
    return this.authService.currentVerein;
  }
  get user(): IUser {
    return this.currentUser;
  }

  set user(value: IUser) {
    this.currentUser = value;
  }
  cancelTi() {
    this.cancel(this.teilnehmerTableTi);
  }
  cancelTu() {
    this.cancel(this.teilnehmerTableTu);
  }
  cancel(ttc: TeilnehmerTableComponent) {
    ttc.resetDataSource();
    this.needsCancel = false;
    this.needsSave = false;
    // this.router.navigate(["events"]);
  }

  saveProfile(formValues) {
    this.router.navigate(["events"]);
  }

  addTurnerin(event: any) {
    this.needsCancel = true;
    this.teilnehmerTableTi.addNewTeilnehmer(TiTuEnum.Ti);
  }
  saveTeilnehmerTi(event: any) {
    this.saveTeilnehmer(this.teilnehmerTableTi);
  }
  saveTeilnehmerTu(event: any) {
    this.saveTeilnehmer(this.teilnehmerTableTu);
  }
  saveTeilnehmer(ttc: TeilnehmerTableComponent) {
    this.needsCancel = false;
    this.needsSave = false;
    ttc.saveTeilnehmer();
    this.teilnehmerService.dirty = false;
  }

  addTurner(event: any) {
    this.needsCancel = true;
    this.teilnehmerTableTu.addNewTeilnehmer(TiTuEnum.Tu);
  }

  get disAllowSave(): boolean {
    if (!this.teilnehmerService.dirty) {
      // console.log('disAllowSave: ', this.teilnehmerService.dirty, ', valid: ', this.teilnehmerService.valid);
      return true;
    }
    if (this.teilnehmerService.dirty && !this.teilnehmerService.valid) {
      // console.log('disAllowSave: ', this.teilnehmerService.dirty && !this.teilnehmerService.valid, ', valid: ', this.teilnehmerService.valid);
      return true;
    }
    // console.log('Save: dirty: ', this.teilnehmerService.dirty, ', valid: ', this.teilnehmerService.valid);
    return false;
  }
  get disAllowCancel(): boolean {
    return !this.teilnehmerService.dirty;
  }
  get disAllowAdd(): boolean {
    return false;
  }
  get ti(): TiTuEnum {
    return TiTuEnum.Ti;
  }
  get tu(): TiTuEnum {
    return TiTuEnum.Tu;
  }
}
