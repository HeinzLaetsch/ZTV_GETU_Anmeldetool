import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Input, type OnChanges, type OnInit, Output, type SimpleChanges } from '@angular/core';
import { FormsModule, ReactiveFormsModule, UntypedFormControl, UntypedFormGroup, Validators } from '@angular/forms';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import type { Update } from '@ngrx/entity';
import { Store } from '@ngrx/store';
import type { IUser } from 'src/app/core/model/IUser';
import type { AppState } from 'src/app/core/redux/core.state';
import { UserActions } from 'src/app/core/redux/user';
import { MaterialModule } from '../../material-module';
import { ConfirmedValidator } from '../../validators/ConfirmedValidator';
import { MyTel, PhoneInput } from '../phonenumber/phone-input-component';
import { UserExists } from './user-exists/user-exists.component';

@Component({
  selector: 'lxt-user',
  templateUrl: './user.component.html',
  styleUrls: ['./user.component.scss'],
  standalone: true,
  imports: [CommonModule, FormsModule, ReactiveFormsModule, MaterialModule, PhoneInput],
})
export class UserComponent implements OnInit, OnChanges {
  @Input()
  modify: boolean;
  @Input()
  readOnly: boolean;
  @Input()
  showPassword: boolean;
  @Input()
  mustShowPassword: boolean;
  @Input()
  showBenutzername: boolean;
  @Input()
  user: IUser;
  @Output()
  userChange = new EventEmitter<IUser>();

  @Output()
  valid = new EventEmitter<boolean>();

  //floatLabel = 'Always';
  appearance = 'outline';

  enteredPassword = '';

  userAlreadyExists = false;
  showPasswordAendern = false;

  form: UntypedFormGroup = new UntypedFormGroup({
    benutzernameControl: new UntypedFormControl('', [
      Validators.required,
      Validators.email,
      Validators.pattern('^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$'),
    ]),
    nachnameControl: new UntypedFormControl('', Validators.required),
    vornameControl: new UntypedFormControl('', Validators.required),
    passwortAendernControl: new UntypedFormControl(false),
    passwortControl: new UntypedFormControl('', Validators.required),
    passwort2Control: new UntypedFormControl('', Validators.required),
    eMailAdresseControl: new UntypedFormControl({ value: '', disabled: false }, [
      Validators.required,
      Validators.email,
      Validators.pattern('^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$'),
    ]),
    mobilNummerControl: new UntypedFormControl(new MyTel('', '', '', '')),
  });

  constructor(
    public dialog: MatDialog,
    private store: Store<AppState>, // private userService: UserService
  ) {
    this.modify = false;
    this.form.setValidators(ConfirmedValidator('passwortControl', 'passwort2Control'));
  }

  ngOnInit(): void {
    this.updateUser(this.user);
    this.validate();
    if (this.readOnly) {
      this.form.disable();
    }
    if (this.showBenutzername) {
      this.form.controls.eMailAdresseControl.disable();
    }

    this.form.controls.benutzernameControl.valueChanges.subscribe((value) => {
      if (this.user.benutzername !== value) {
        this.user.benutzername = value;
        const userUpdate: Update<IUser> = {
          id: this.user.id,
          changes: {
            dirty: true,
            benutzername: this.user.benutzername,
          },
        };
        this.emitChange(userUpdate);
      }
    });
    this.form.controls.nachnameControl.valueChanges.subscribe((value) => {
      if (this.user.name !== value) {
        this.user.name = value;
        const userUpdate: Update<IUser> = {
          id: this.user.id,
          changes: {
            dirty: true,
            name: this.user.name,
          },
        };
        this.emitChange(userUpdate);
      }
    });
    this.form.controls.vornameControl.valueChanges.subscribe((value) => {
      if (this.user.vorname !== value) {
        this.user.vorname = value;
        const userUpdate: Update<IUser> = {
          id: this.user.id,
          changes: {
            dirty: true,
            vorname: this.user.vorname,
          },
        };
        this.emitChange(userUpdate);
      }
    });
    this.form.controls.passwortControl.valueChanges.subscribe((value) => {
      if (this.user.password !== value) {
        this.user.password = value;
        this.enteredPassword = value;
        const userUpdate: Update<IUser> = {
          id: this.user.id,
          changes: {
            dirty: true,
            password: this.user.password,
          },
        };
        this.emitChange(userUpdate);
      }
    });
    this.form.controls.passwort2Control.valueChanges.subscribe((value) => {
      if (this.user.password !== value) {
        this.user.password = value;
        const userUpdate: Update<IUser> = {
          id: this.user.id,
          changes: {
            dirty: true,
            password: this.user.password,
          },
        };
        this.emitChange(userUpdate);
      }
    });
    this.form.controls.eMailAdresseControl.valueChanges.subscribe((value) => {
      if (this.user.email !== value) {
        this.user.email = value;
        const userUpdate: Update<IUser> = {
          id: this.user.id,
          changes: {
            dirty: true,
            email: this.user.email,
          },
        };
        this.emitChange(userUpdate);
      }
    });
    this.form.controls.mobilNummerControl.valueChanges.subscribe((value) => {
      // console.log(this.form.controls.mobilNummerControl.value);
      if (value && this.user.handy !== this.concatHandy(value)) {
        this.user.handy = this.concatHandy(value);
        const userUpdate: Update<IUser> = {
          id: this.user.id,
          changes: {
            dirty: true,
            handy: this.user.handy,
          },
        };
        this.emitChange(userUpdate);
      }
    });
  }

  ngOnChanges(changes: SimpleChanges) {
    for (const propName in changes) {
      if (changes.user) {
        // console.log('ngOnChanges: ' , changes.user.previousValue, ', ' , changes.user.currentValue);
        //this.updateUser(changes.user.currentValue);
      }
    }
  }
  private openDialog(existingUser: IUser) {
    const dialogRef = this.dialog.open(UserExists, {
      data: existingUser,
    });

    dialogRef.afterClosed().subscribe((result) => {
      console.log(`Dialog result: ${result}`);
    });
  }

  private splitHandy(handy: string): MyTel {
    const parts = handy.split(' ');
    if (parts.length < 4) {
      return new MyTel('', '', '', '');
    }
    const myTel = new MyTel(parts[0], parts[1], parts[2], parts[3]);
    return myTel;
  }

  private updateUser(user: IUser) {
    if (this.form.controls.benutzernameControl.value !== user.benutzername) {
      this.form.controls.benutzernameControl.setValue(user.benutzername);
    }
    if (this.form.controls.nachnameControl.value !== user.name) {
      this.form.controls.nachnameControl.setValue(user.name);
    }
    if (this.form.controls.vornameControl.value !== user.vorname) {
      this.form.controls.vornameControl.setValue(user.vorname);
    }
    // Password is not returned by the server
    if (this.form.controls.passwortControl.value !== user.password) {
      if (this.enteredPassword && this.enteredPassword.length > 0) {
        this.form.controls.passwortControl.setValue(this.enteredPassword);
        this.form.controls.passwort2Control.setValue(this.enteredPassword);
      } else {
        this.form.controls.passwortControl.setValue(user.password);
        this.form.controls.passwort2Control.setValue(user.password);
      }
    }
    if (this.form.controls.eMailAdresseControl.value !== user.email) {
      this.form.controls.eMailAdresseControl.setValue(user.email);
    }
    const tmpValue = this.form.controls.mobilNummerControl.value;
    if (!tmpValue || tmpValue.part1 === '') {
      this.form.controls.mobilNummerControl.setValue(this.splitHandy(user.handy));
    }
  }
  private validate(): boolean {
    let valid = true;
    if (this.showBenutzername) {
      const benutzerNameValid = this.form.controls.benutzernameControl.valid;
      valid = valid && benutzerNameValid && !this.userAlreadyExists;
      if (benutzerNameValid) {
        this.user.email = this.form.controls.benutzernameControl.value;
        this.form.controls.eMailAdresseControl.setValue(this.form.controls.benutzernameControl.value);
      }
    }
    valid = valid && this.form.controls.nachnameControl.valid;
    valid = valid && this.form.controls.vornameControl.valid;
    if (this.showPassword) {
      if (
        !(this.modify && (!this.form.controls.passwortControl.value || this.form.controls.passwortControl.value === ''))
      ) {
        valid = valid && this.form.controls.passwortControl.valid;
        valid = valid && this.form.controls.passwort2Control.valid;
      }
    }
    if (!this.showBenutzername) {
      valid = valid && this.form.controls.eMailAdresseControl.valid && !this.userAlreadyExists;
    }
    valid = valid && this.form.controls.mobilNummerControl.valid;

    this.valid.next(valid);
    if (!valid) {
      console.log('UserComponent not valid: ', this.form.errors);
    }
    return valid;
  }
  private emitChange(userUpdate: Update<IUser>) {
    //includeUser: boolean) {
    // const valid =
    //if (valid) {
    this.store.dispatch(UserActions.updateUser({ payload: userUpdate }));
    this.validate();
    //}
  }

  private concatHandy(mytel: MyTel): string {
    const handy = mytel.part1 + ' ' + mytel.part2 + ' ' + mytel.part3 + ' ' + mytel.part4;
    if (handy.trim().length === 0) {
      return '';
    }
    return handy;
  }
}
