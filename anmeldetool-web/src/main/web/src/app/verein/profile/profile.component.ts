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
import { THIS_EXPR } from '@angular/compiler/src/output/output_ast';
import { MatTabGroup } from '@angular/material/tabs';
import { IRolle } from 'src/app/core/model/IRolle';

@Component({
  selector: "app-profile",
  templateUrl: "./profile.component.html",
  styleUrls: ["./profile.component.css"],
})
export class ProfileComponent implements OnInit {
  appearance = "outline";
  profileForm: FormGroup;
  currentUser: IUser;
  _vereinsUser: IUser[];

  @ViewChild('tabs') tabGroup: MatTabGroup;

  constructor(
    private formBuilder: FormBuilder,
    private authService: AuthService,
    private userService: CachingUserService,
    private router: Router
  ) {
    this.profileForm = this.formBuilder.group(
      {
        benutzernameControl: [
          "",
          [
            Validators.required,
            Validators.email,
            Validators.pattern("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$"),
          ],
        ],
        nachnameControl: ["", Validators.required],
        vornameControl: ["", Validators.required],
        passwortControl: [""],
        passwort2Control: [""],
        eMailAdresseControl: [
          "",
          [
            Validators.required,
            Validators.email,
            Validators.pattern("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$"),
          ],
        ],
        mobilNummerControl: [
          "",
          [
            Validators.required,
            Validators.pattern("[0-9]{3} [0-9]{3} [0-9]{2} [0-9]{2}"),
          ],
        ],
      },
      { validator: ConfirmedValidator("passwortControl", "passwort2Control") }
    );
  }

  ngOnInit() {
    // console.log("ProfileComponent::ngOnInit: ", this.authService.currentUser);
    this.currentUser = this.authService.currentUser;
    this._vereinsUser = this.userService.getUser();
  }


  get vereinsUsers(): IUser[] {
    return this._vereinsUser;
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
  /*
  validateFirstName() {
    return this.firstName.valid || this.firstName.untouched;
  }

  validateLastName() {
    return this.lastName.valid || this.lastName.untouched;
  }
  */
  cancel() {
    this.router.navigate(["events"]);
  }

  saveProfile(formValues) {
    if (this.profileForm.valid) {
      // this.authService.updateCurrentUser(formValues.firstName, formValues.lastName);
      this.router.navigate(["events"]);
    }
  }
  getTabIndex() {
    console.log('Index: ' , this._vereinsUser[this._vereinsUser.length-1].benutzername);
    if(this._vereinsUser[this._vereinsUser.length-1].benutzername) {
      return 0;
    }
    return this._vereinsUser.length -1;
  }

  addUser(event: any) {
    this._vereinsUser.push( {
      id: undefined,
      organisationid: this.authService.currentVerein.id,
      benutzername: '',
      name: '',
      vorname: '',
      email: '',
      handy: '',
      aktiv: true,
      password: 'getu',
      rollen: new Array<IRolle>(),
    })
    this.tabGroup.selectedIndex = this._vereinsUser.length -1;
  }
  /*
  save(): void {
    const self = this;

    const user: IUser = {
      id: this.authService.currentUser.id,
      organisationid: this.authService.currentUser.organisationid,
      name: this.profileForm.controls.nachnameControl.value,
      vorname: this.profileForm.controls.vornameControl.value,
      password: this.profileForm.controls.passwortControl.value,
      benutzername: this.profileForm.controls.benutzernameControl.value,
      email: this.profileForm.controls.eMailAdresseControl.value,
      handy: this.profileForm.controls.mobilNummerControl.value,
      aktiv: true,
    };
    console.error('Not correct');
    // this.authService.updateUser(user).subscribe((user) => {});
  }
  */
}
