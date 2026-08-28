import { Component, inject, signal, type OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import {
  FormsModule,
  ReactiveFormsModule,
  UntypedFormBuilder,
  type UntypedFormGroup,
  Validators,
} from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatSelectModule } from '@angular/material/select';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { Router, RouterModule } from '@angular/router';
import { toSignal } from '@angular/core/rxjs-interop';
import type { IRolle } from 'src/app/core/model/IRolle';
import type { IUser } from 'src/app/core/model/IUser';
import { CachingUserService } from 'src/app/core/service/caching-services/caching.user.service';
import { VereinService } from 'src/app/core/service/verein/verein.service';
import { UserService } from 'src/app/core/service/user/user.service';
import { UserComponent } from 'src/app/shared/component/user/user.component';
import type { IVerein } from 'src/app/verein/verein';

@Component({
  selector: 'lxt-new-anmelder',
  templateUrl: './new-anmelder.component.html',
  styleUrls: ['./new-anmelder.component.css'],
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MatDialogModule,
    MatFormFieldModule,
    MatInputModule,
    MatSelectModule,
    MatButtonModule,
    MatCheckboxModule,
    MatProgressSpinnerModule,
    MatSnackBarModule,
    RouterModule,
    UserComponent,
  ],
})
export class NewAnmelderComponent implements OnInit {
  //floatLabel = 'Always';
  appearance = 'outline';
  private readonly formBuilder = inject(UntypedFormBuilder);
  readonly dialogRef = inject(MatDialogRef<NewAnmelderComponent>);
  private readonly vereinService = inject(VereinService);
  private readonly cachingUserService = inject(CachingUserService);
  private readonly userService = inject(UserService);
  private readonly router = inject(Router);

  readonly form: UntypedFormGroup = this.formBuilder.group({
    vereinFormControl: ['', Validators.required],
  });

  readonly vereine = toSignal(this.vereinService.getVereine(), { initialValue: [] as IVerein[] });

  readonly userValid = signal(false);
  readonly error = signal(false);
  readonly errorMessage = signal<string | undefined>(undefined);

  readonly anmelder = signal<IUser>({
    id: '-1',
    name: '',
    verbandId: '',
    organisationids: ['-1'],
    vorname: '',
    password: '',
    benutzername: '',
    email: '',
    handy: '',
    aktiv: true,
  });

  constructor() {}

  ngOnInit() {
    this.anmelder.update((current) => ({
      ...current,
      organisationids: ['-1'],
    }));
  }

  updateUserValid(valid: boolean): void {
    this.userValid.set(valid);
    console.log('Valid changed', valid);
  }

  updateAnmelder(anmelder: IUser): void {
    console.log('Anmelder changed', anmelder);
    this.anmelder.set(anmelder);
  }

  save(): void {
    const rollen: IRolle[] = [{ id: '', name: 'ANMELDER', aktiv: false }];
    console.log('Verein: ', this.form.controls.vereinFormControl.value);
    const currentAnmelder = this.anmelder();
    if (!currentAnmelder.organisationids) {
      currentAnmelder.organisationids = [];
    }
    currentAnmelder.organisationids = currentAnmelder.organisationids.slice(0, 0);
    currentAnmelder.organisationids.push(this.form.controls.vereinFormControl.value);

    currentAnmelder.aktiv = true;
    currentAnmelder.rollen = rollen;

    currentAnmelder.benutzername = currentAnmelder.email;
    this.cachingUserService.getUserByBenutzername(currentAnmelder.benutzername).subscribe((user) => {
      if (user) {
        this.error.set(true);
        this.errorMessage.set(
          'Es existiert bereits ein Benutzer mit dem Benutzernamen: ' + currentAnmelder.benutzername,
        );
      } else {
        this.userService.createUser(currentAnmelder).subscribe((createdUser) => {
          console.log('User kreiert ', createdUser.benutzername);
          this.dialogRef.close('OK');
          this.router.navigate(['profile']);
        });
      }
    });
  }

  cancel(): void {
    this.dialogRef.close('CANCEL');
    console.log('Cancel');
  }
}
