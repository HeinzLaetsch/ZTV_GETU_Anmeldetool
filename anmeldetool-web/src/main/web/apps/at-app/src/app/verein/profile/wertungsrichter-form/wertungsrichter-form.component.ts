import { ChangeDetectionStrategy, Component, effect, input, type OnInit, output } from '@angular/core';
import { CommonModule } from '@angular/common';
import { UntypedFormControl, UntypedFormGroup, Validators } from '@angular/forms';
import type { IRolle } from 'src/app/core/model/IRolle';
import type { IUser } from 'src/app/core/model/IUser';
import type { IWertungsrichter } from 'src/app/core/model/IWertungsrichter';
import { MaterialModule } from 'src/app/shared/material-module';
import { ReactiveFormsModule } from '@angular/forms';

@Component({
  selector: 'ztv-wertungsrichter',
  templateUrl: './wertungsrichter-form.component.html',
  styleUrls: ['./wertungsrichter-form.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, ReactiveFormsModule, MaterialModule],
})
export class WertungsrichterFormComponent implements OnInit {
  readonly currentUser = input.required<IUser>();
  readonly wertungsrichter = input.required<IWertungsrichter>();
  readonly isVereinsAnmelder = input.required<boolean>();
  readonly isVereinsVerantwortlicher = input.required<boolean>();
  readonly wertungsrichterChange = output<IWertungsrichter>();

  appearance = 'outline';

  userValid: boolean;

  brevetControl = new UntypedFormControl('', Validators.required);
  letzterFkControl = new UntypedFormControl('');
  gueltigControl = new UntypedFormControl('');
  bestaetigtControl = new UntypedFormControl('');
  form: UntypedFormGroup = new UntypedFormGroup({
    brevetControl: this.brevetControl,
    letzterFkControl: this.letzterFkControl,
    gueltigControl: this.gueltigControl,
    bestaetigtControl: this.bestaetigtControl,
  });
  private readonly valuesEffect = effect(() => {
    this.setValues(this.wertungsrichter());
  });

  ngOnInit(): void {
    this.form.valueChanges.subscribe(() => {
      if (this.form.dirty && this.brevetControl.dirty) {
        this.wertungsrichter().brevet = this.brevetControl.value as unknown as number;
        this.wertungsrichterChange.emit(this.wertungsrichter());
      }
    });
  }

  private setValues(wertungsrichter: IWertungsrichter): void {
    this.brevetControl.setValue(wertungsrichter.brevet);
    this.letzterFkControl.setValue(wertungsrichter.letzterFK);
    this.gueltigControl.setValue(wertungsrichter.gueltig);
    this.bestaetigtControl.setValue(wertungsrichter.aktiv);
  }

  disableRole(role: IRolle): boolean {
    if (role.name === 'VEREINSVERANTWORTLICHER' && !this.isVereinsVerantwortlicher()) {
      return true;
    }
    return false;
  }
}
