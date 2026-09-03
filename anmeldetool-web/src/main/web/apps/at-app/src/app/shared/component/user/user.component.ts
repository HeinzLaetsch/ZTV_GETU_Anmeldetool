import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, Component, effect, inject, input, output, signal, untracked } from '@angular/core';
import { FormsModule, ReactiveFormsModule, UntypedFormControl, UntypedFormGroup, Validators } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import type { Update } from '@ngrx/entity';
import { Store } from '@ngrx/store';
import type { IUser } from 'src/app/core/model/IUser';
import type { AppState } from 'src/app/core/redux/core.state';
import { UserActions } from 'src/app/core/redux/user';
import { MaterialModule } from '../../material-module';
import { ConfirmedValidator } from '../../validators/ConfirmedValidator';
import { MyTel } from '../phonenumber/phone-input-component';
import { UserExists } from './user-exists/user-exists.component';

@Component({
  selector: 'lxt-user',
  templateUrl: './user.component.html',
  styleUrls: ['./user.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  standalone: true,
  imports: [CommonModule, FormsModule, ReactiveFormsModule, MaterialModule],
})
export class UserComponent {
  // Inputs
  modify = input(false);
  readOnly = input(false);
  showPassword = input(false);
  mustShowPassword = input(false);
  showBenutzername = input(false);
  user = input<IUser | null>(null);

  // Outputs
  userChange = output<IUser>();
  valid = output<boolean>();

  // Services
  private dialog = inject(MatDialog);
  private store = inject(Store<AppState>);

  // Local state
  readonly enteredPassword = signal('');
  readonly userAlreadyExists = signal(false);
  readonly showPasswordAendern = signal(false);

  readonly appearance = 'outline';

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

  constructor() {
    this.form.setValidators(ConfirmedValidator('passwortControl', 'passwort2Control'));

    // React to user input changes (mirrors ngOnInit + ngOnChanges)
    effect(() => {
      const user = this.user();
      if (!user) {
        return;
      }
      untracked(() => {
        this.updateUser(user);
        this.validate();
        if (this.readOnly()) {
          this.form.disable();
        }
        if (this.showBenutzername()) {
          this.form.controls.eMailAdresseControl.disable();
        }
      });
    });

    this.form.controls.benutzernameControl.valueChanges.subscribe((value) => {
      const user = this.user();
      if (!user) {
        return;
      }
      if (user.benutzername !== value) {
        user.benutzername = value;
        this.emitChange({ id: user.id ?? '', changes: { dirty: true, benutzername: user.benutzername } });
      }
    });
    this.form.controls.nachnameControl.valueChanges.subscribe((value) => {
      const user = this.user();
      if (!user) {
        return;
      }
      if (user.name !== value) {
        user.name = value;
        this.emitChange({ id: user.id ?? '', changes: { dirty: true, name: user.name } });
      }
    });
    this.form.controls.vornameControl.valueChanges.subscribe((value) => {
      const user = this.user();
      if (!user) {
        return;
      }
      if (user.vorname !== value) {
        user.vorname = value;
        this.emitChange({ id: user.id ?? '', changes: { dirty: true, vorname: user.vorname } });
      }
    });
    this.form.controls.passwortControl.valueChanges.subscribe((value) => {
      const user = this.user();
      if (!user) {
        return;
      }
      if (user.password !== value) {
        user.password = value;
        this.enteredPassword.set(value);
        this.emitChange({ id: user.id ?? '', changes: { dirty: true, password: user.password } });
      }
    });
    this.form.controls.passwort2Control.valueChanges.subscribe((value) => {
      const user = this.user();
      if (!user) {
        return;
      }
      if (user.password !== value) {
        user.password = value;
        this.emitChange({ id: user.id ?? '', changes: { dirty: true, password: user.password } });
      }
    });
    this.form.controls.eMailAdresseControl.valueChanges.subscribe((value) => {
      const user = this.user();
      if (!user) {
        return;
      }
      if (user.email !== value) {
        user.email = value;
        this.emitChange({ id: user.id ?? '', changes: { dirty: true, email: user.email } });
      }
    });
    this.form.controls.mobilNummerControl.valueChanges.subscribe((value) => {
      const user = this.user();
      if (!user) {
        return;
      }
      if (value && user.handy !== this.concatHandy(value)) {
        user.handy = this.concatHandy(value);
        this.emitChange({ id: user.id ?? '', changes: { dirty: true, handy: user.handy } });
      }
    });
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
      this.form.controls.benutzernameControl.setValue(user.benutzername, { emitEvent: false });
    }
    if (this.form.controls.nachnameControl.value !== user.name) {
      this.form.controls.nachnameControl.setValue(user.name, { emitEvent: false });
    }
    if (this.form.controls.vornameControl.value !== user.vorname) {
      this.form.controls.vornameControl.setValue(user.vorname, { emitEvent: false });
    }
    // Password is not returned by the server
    if (this.form.controls.passwortControl.value !== user.password) {
      const ep = this.enteredPassword();
      if (ep && ep.length > 0) {
        this.form.controls.passwortControl.setValue(ep, { emitEvent: false });
        this.form.controls.passwort2Control.setValue(ep, { emitEvent: false });
      } else {
        this.form.controls.passwortControl.setValue(user.password, { emitEvent: false });
        this.form.controls.passwort2Control.setValue(user.password, { emitEvent: false });
      }
    }
    if (this.form.controls.eMailAdresseControl.value !== user.email) {
      this.form.controls.eMailAdresseControl.setValue(user.email, { emitEvent: false });
    }
    const tmpValue = this.form.controls.mobilNummerControl.value;
    if (!tmpValue || tmpValue.part1 === '') {
      this.form.controls.mobilNummerControl.setValue(this.splitHandy(user.handy), { emitEvent: false });
    }
  }

  private validate(): boolean {
    let valid = true;
    const user = this.user();
    if (this.showBenutzername()) {
      const benutzerNameValid = this.form.controls.benutzernameControl.valid;
      valid = valid && benutzerNameValid && !this.userAlreadyExists();
      if (benutzerNameValid && user) {
        user.email = this.form.controls.benutzernameControl.value;
        this.form.controls.eMailAdresseControl.setValue(this.form.controls.benutzernameControl.value, {
          emitEvent: false,
        });
      }
    }
    valid = valid && this.form.controls.nachnameControl.valid;
    valid = valid && this.form.controls.vornameControl.valid;
    if (this.showPassword()) {
      if (!(
        this.modify() &&
        (!this.form.controls.passwortControl.value || this.form.controls.passwortControl.value === '')
      )) {
        valid = valid && this.form.controls.passwortControl.valid;
        valid = valid && this.form.controls.passwort2Control.valid;
      }
    }
    if (!this.showBenutzername()) {
      valid = valid && this.form.controls.eMailAdresseControl.valid && !this.userAlreadyExists();
    }
    valid = valid && this.form.controls.mobilNummerControl.valid;

    queueMicrotask(() => this.valid.emit(valid));
    if (!valid) {
      console.log('UserComponent not valid: ', this.form.errors);
    }
    return valid;
  }

  private emitChange(userUpdate: Update<IUser>) {
    const user = this.user();
    if (!user) {
      return;
    }
    queueMicrotask(() => this.userChange.emit(user));
    this.store.dispatch(UserActions.updateUser({ payload: userUpdate }));
    this.validate();
  }

  private concatHandy(mytel: MyTel): string {
    const handy = mytel.part1 + ' ' + mytel.part2 + ' ' + mytel.part3 + ' ' + mytel.part4;
    if (handy.trim().length === 0) {
      return '';
    }
    return handy;
  }
}
