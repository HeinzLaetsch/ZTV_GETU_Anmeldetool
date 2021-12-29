import {
  AfterViewInit,
  Component,
  EventEmitter,
  Input,
  OnChanges,
  OnInit,
  Output,
  SimpleChanges,
} from "@angular/core";
import {
  FormBuilder,
  FormControl,
  FormGroup,
  Validators,
} from "@angular/forms";
import { IUser } from "src/app/core/model/IUser";
import { ConfirmedValidator } from "../../validators/ConfirmedValidator";

@Component({
  selector: "app-user",
  templateUrl: "./user.component.html",
  styleUrls: ["./user.component.css"],
})
export class UserComponent implements OnInit, AfterViewInit, OnChanges {
  @Input()
  modify: boolean;
  @Input()
  readOnly: boolean;
  @Input()
  showPassword: boolean;
  @Input()
  showBenutzername: boolean;
  @Input()
  user: IUser;
  @Output()
  userChange = new EventEmitter<IUser>();

  @Output()
  valid = new EventEmitter<boolean>();

  //floatLabel = 'Always';
  appearance = "outline";

  enteredPassword = "";

  form: FormGroup = new FormGroup({
    benutzernameControl: new FormControl("", [
      Validators.required,
      Validators.email,
      Validators.pattern("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$"),
    ]),
    nachnameControl: new FormControl("", Validators.required),
    vornameControl: new FormControl("", Validators.required),
    passwortControl: new FormControl("", Validators.required),
    passwort2Control: new FormControl("", Validators.required),
    eMailAdresseControl: new FormControl({ value: "", disabled: false }, [
      Validators.required,
      Validators.email,
      Validators.pattern("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$"),
    ]),
    mobilNummerControl: new FormControl("", [
      Validators.required,
      Validators.pattern("[0-9]{3} [0-9]{3} [0-9]{2} [0-9]{2}"),
    ]),
  });

  constructor(private formBuilder: FormBuilder) {
    this.modify = false;
    this.form.setValidators(
      ConfirmedValidator("passwortControl", "passwort2Control")
    );
  }
  ngAfterViewInit(): void {
    if (this.readOnly) {
      this.form.disable();
    }
    if (this.showBenutzername) {
      this.form.controls.eMailAdresseControl.disable();
    }
    this.emitChange(false);
  }
  ngOnChanges(changes: SimpleChanges) {
    for (const propName in changes) {
      if (changes.user) {
        // console.log('ngOnChanges: ' , changes.user.previousValue, ', ' , changes.user.currentValue);
        this.updateUser(changes.user.currentValue);
      }
    }
  }
  private updateUser(user: IUser) {
    this.form.controls.benutzernameControl.setValue(user.benutzername);
    this.form.controls.nachnameControl.setValue(user.name);
    this.form.controls.vornameControl.setValue(user.vorname);
    // Password is not returned by the server
    if (this.enteredPassword && this.enteredPassword.length > 0) {
      this.form.controls.passwortControl.setValue(this.enteredPassword);
      this.form.controls.passwort2Control.setValue(this.enteredPassword);
    } else {
      this.form.controls.passwortControl.setValue(user.password);
      this.form.controls.passwort2Control.setValue(user.password);
    }
    this.form.controls.eMailAdresseControl.setValue(user.email);
    this.form.controls.mobilNummerControl.setValue(user.handy);
  }
  private emitChange(includeUser: boolean) {
    let valid = true;
    if (this.showBenutzername) {
      const benutzerNameValid = this.form.controls.benutzernameControl.valid;
      valid = valid && benutzerNameValid;
      /*
      if (
        benutzerNameValid &&
        (this.form.controls.eMailAdresseControl.value === undefined ||
          this.form.controls.eMailAdresseControl.value === "")
      ) {
        this.form.controls.eMailAdresseControl.setValue(
          this.form.controls.benutzernameControl.value
        );
        this.user.email = this.form.controls.benutzernameControl.value;
      }*/
      if (benutzerNameValid) {
        this.user.email = this.form.controls.benutzernameControl.value;
        this.form.controls.eMailAdresseControl.setValue(
          this.form.controls.benutzernameControl.value
        );
      }
    }
    valid = valid && this.form.controls.nachnameControl.valid;
    valid = valid && this.form.controls.vornameControl.valid;
    if (this.showPassword) {
      if (
        !(
          this.modify &&
          (!this.form.controls.passwortControl.value ||
            this.form.controls.passwortControl.value === "")
        )
      ) {
        valid = valid && this.form.controls.passwortControl.valid;
        valid = valid && this.form.controls.passwort2Control.valid;
      }
    }
    if (!this.showBenutzername) {
      valid = valid && this.form.controls.eMailAdresseControl.valid;
    }
    valid = valid && this.form.controls.mobilNummerControl.valid;

    this.valid.next(valid);
    if (includeUser) {
      this.userChange.next(this.user);
    }
  }

  ngOnInit(): void {
    this.updateUser(this.user);
    this.form.controls.benutzernameControl.valueChanges.subscribe((value) => {
      if (this.user.benutzername !== value) {
        this.user.benutzername = value;
        this.emitChange(true);
      }
    });
    this.form.controls.nachnameControl.valueChanges.subscribe((value) => {
      if (this.user.name !== value) {
        this.user.name = value;
        this.emitChange(true);
      }
    });
    this.form.controls.vornameControl.valueChanges.subscribe((value) => {
      if (this.user.vorname !== value) {
        this.user.vorname = value;
        this.emitChange(true);
      }
    });
    this.form.controls.passwortControl.valueChanges.subscribe((value) => {
      if (this.user.password !== value) {
        this.user.password = value;
        this.enteredPassword = value;
        this.emitChange(true);
      }
    });
    this.form.controls.passwort2Control.valueChanges.subscribe((value) => {
      if (this.user.password !== value) {
        this.user.password = value;
        this.emitChange(true);
      }
    });
    this.form.controls.eMailAdresseControl.valueChanges.subscribe((value) => {
      if (this.user.email !== value) {
        this.user.email = value;
        this.emitChange(true);
      }
    });
    this.form.controls.mobilNummerControl.valueChanges.subscribe((value) => {
      if (this.user.handy !== value) {
        this.user.handy = value;
        this.emitChange(true);
      }
    });
  }
}
