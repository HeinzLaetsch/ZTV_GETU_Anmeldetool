import { Component, EventEmitter, Input, type OnChanges, type OnInit, Output, type SimpleChanges } from '@angular/core';
import { CommonModule } from '@angular/common';
import { UntypedFormControl, UntypedFormGroup, Validators } from '@angular/forms';
import type { IRolle } from 'src/app/core/model/IRolle';
import type { IUser } from 'src/app/core/model/IUser';
import type { IWertungsrichter } from 'src/app/core/model/IWertungsrichter';
import { MaterialModule } from 'src/app/shared/material-module';
import { ReactiveFormsModule } from '@angular/forms';

@Component({
  selector: 'lxt-wertungsrichter',
  templateUrl: './wertungsrichter-form.component.html',
  styleUrls: ['./wertungsrichter-form.component.scss'],
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MaterialModule],
})
export class WertungsrichterFormComponent implements OnInit, OnChanges {
  @Input()
  currentUser: IUser;
  @Input()
  wertungsrichter: IWertungsrichter;
  @Input()
  isVereinsAnmelder: boolean;
  @Input()
  isVereinsVerantwortlicher: boolean;
  @Output()
  wertungsrichterChange = new EventEmitter<IWertungsrichter>();

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

  constructor() {}

  ngOnInit(): void {
    this.setValues();

    this.form.valueChanges.subscribe((value: any) => {
      if (this.form.dirty && this.brevetControl.dirty) {
        this.wertungsrichter.brevet = this.brevetControl.value as unknown as number;
        this.wertungsrichterChange.emit(this.wertungsrichter);
      }
    });
  }

  private setValues(): void {
    this.brevetControl.setValue(this.wertungsrichter.brevet);
    this.letzterFkControl.setValue(this.wertungsrichter.letzterFK);
    this.gueltigControl.setValue(this.wertungsrichter.gueltig);
    this.bestaetigtControl.setValue(this.wertungsrichter.aktiv);
  }

  ngOnChanges(changes: SimpleChanges) {
    for (const propName in changes) {
      if (changes.wertungsrichter) {
        this.wertungsrichter = changes.wertungsrichter.currentValue;
        if (this.wertungsrichter) {
          this.setValues();
        }
      }
    }
  }

  disableRole(role: IRolle) {
    if (role.name === 'VEREINSVERANTWORTLICHER' && !this.isVereinsVerantwortlicher) {
      return true;
    }
    return false;
  }
}
