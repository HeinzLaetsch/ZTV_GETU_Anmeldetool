import { Component, OnInit, ViewChild } from "@angular/core";
import {
  FormBuilder,
  FormControl,
  FormGroup,
  Validators,
} from "@angular/forms";
import { last } from "rxjs/operators";
import { Router } from "@angular/router";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { ConfirmedValidator } from "src/app/shared/validators/ConfirmedValidator";
import { IUser } from "src/app/core/model/IUser";
import { IVerein } from "../verein";
import { VereinService } from "src/app/core/service/verein/verein.service";
import { CachingVereinService } from "src/app/core/service/caching-services/caching.verein.service";
import { CachingUserService } from "src/app/core/service/caching-services/caching.user.service";
import { THIS_EXPR } from "@angular/compiler/src/output/output_ast";
import { MatTabGroup } from "@angular/material/tabs";
import { TeilnehmerTableComponent } from "./teilnehmer-table/teilnehmer-table.component";
import { IChangeEvent } from "./change-event";
import { CachingTeilnehmerService } from "src/app/core/service/caching-services/caching.teilnehmer.service";
import { Observable } from "rxjs";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";

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

  @ViewChild(TeilnehmerTableComponent, { static: false })
  teilnehmerTable: TeilnehmerTableComponent;

  constructor(
    private formBuilder: FormBuilder,
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
    this.teilnehmerService.loadTeilnehmer(this.authService.currentVerein).subscribe(result => {
      console.log('TeilnehmerComponent::ngOnInit 1: ', result);
    });;
  }

  get vereinsUsers(): IUser[] {
    return this._vereinsUser;
  }

  get isTeilnehmerLoaded(): Observable<number> {
    // console.log('TeilnehmerComponent::isTeilnehmerLoaded')
    return this.teilnehmerService.isTeilnehmerLoaded();
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

  cancel() {
    this.teilnehmerTable.resetDataSource();
    this.needsCancel = false;
    this.needsSave = false;
    // this.router.navigate(["events"]);
  }

  saveProfile(formValues) {
    this.router.navigate(["events"]);
  }

  addTurnerin(event: any) {
    this.needsCancel = true;
    this.teilnehmerTable.addNewTeilnehmer();
  }

  saveTeilnehmer(event: any) {
    this.needsCancel = false;
    this.needsSave = false;
    this.teilnehmerTable.saveTeilnehmer();
    this.teilnehmerService.dirty = false;
  }

  addTurner(event: any) {
    this.needsCancel = true;
    this.teilnehmerTable.addNewTeilnehmer();
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
