import { CommonModule } from '@angular/common';
import { Component, DestroyRef, computed, inject, signal } from '@angular/core';
import { toSignal, takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { FormsModule } from '@angular/forms';
import { form, FormField, required, validate } from '@angular/forms/signals';
import { MatAutocompleteModule, MatAutocompleteSelectedEvent } from '@angular/material/autocomplete';
import { MatButtonModule } from '@angular/material/button';
import { MatDialog, MatDialogModule } from '@angular/material/dialog';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { Router, RouterModule } from '@angular/router';
import { Store } from '@ngrx/store';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import type { IVerein } from 'src/app/verein/verein';
import type { AppState } from '../../redux/core.state';
import { selectAlleVereine } from '../../redux/verein';
import { NewVereinComponent } from '../new-verein/new-verein.component';

@Component({
  selector: 'ztv-login-dialog',
  templateUrl: './login-dialog.component.html',
  styleUrls: ['./login-dialog.component.scss'],
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    FormField,
    MatDialogModule,
    MatAutocompleteModule,
    MatFormFieldModule,
    MatInputModule,
    MatButtonModule,
    RouterModule,
  ],
})
export class LoginComponent {
  appearance = 'outline';
  loginError = signal(false);
  errorMessage = signal<string | undefined>(undefined);

  private authService = inject(AuthService);
  private store = inject(Store<AppState>);
  private router = inject(Router);
  private dialog = inject(MatDialog);
  private destroyRef = inject(DestroyRef);

  private vereineSignal = toSignal(this.store.select(selectAlleVereine), { initialValue: [] as IVerein[] });

  formModel = signal({
    vereinText: '',
    userName: '',
    password: '',
  });

  chosenVerein = signal<IVerein | null>(null);

  loginForm = form(this.formModel, (schemaPath) => {
    required(schemaPath.password);
    required(schemaPath.vereinText);
    required(schemaPath.userName);

    validate(schemaPath.userName, () => {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      const isValid = emailRegex.test(this.formModel().userName);

      return isValid
        ? null
        : {
            kind: 'email',
            message: 'Bitte eine gültige E-Mail-Adresse eingeben.',
          };
    });

    validate(schemaPath.vereinText, () => {
      const text = this.formModel().vereinText;
      const ausgewaehlt = this.chosenVerein();

      if (!ausgewaehlt || ausgewaehlt.name !== text) {
        return {
          kind: 'vereinSelection',
          message: 'Bitte einen Verein aus der Liste auswählen.',
        };
      }
      return null;
    });
  });

  filteredOptions = computed(() => {
    const vereine = this.vereineSignal();
    const suche = this.formModel().vereinText.toLowerCase().trim();

    if (!suche) {
      return vereine;
    }
    return vereine.filter((v) => v.name.toLowerCase().includes(suche));
  });

  onVereinSelected(event: MatAutocompleteSelectedEvent): void {
    const ausgewaehlterVerein = event.option.value as IVerein;
    this.chosenVerein.set(ausgewaehlterVerein);
    this.formModel.update((current) => ({
      ...current,
      vereinText: ausgewaehlterVerein.name,
    }));
  }

  login(): void {
    if (this.loginForm().invalid()) {
      this.loginForm.password().markAsTouched();
      this.loginForm.userName().markAsTouched();
      this.loginForm.vereinText().markAsTouched();
      return;
    }

    const vereinObjekt = this.chosenVerein();
    if (!vereinObjekt) {
      return;
    }

    const { userName, password } = this.formModel();
    this.loginError.set(false);

    this.authService
      .login(vereinObjekt, userName, password)
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: () => {
          this.loginError.set(false);
        },
        error: (error) => {
          this.loginError.set(true);
          this.errorMessage.set('Fehler beim Login, Verein, Name oder Passwort falsch. ' + error);
        },
      });
  }

  cancel(): void {
    this.router.navigate(['anlass']);
  }

  newVereinClicked(): void {
    this.dialog.open(NewVereinComponent, {
      width: '600px',
      height: 'auto',
      maxHeight: '95vh',
      disableClose: true,
      panelClass: 'ztv-dialog',
    });
  }
}
