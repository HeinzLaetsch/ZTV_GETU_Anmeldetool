import { CommonModule } from '@angular/common';
import { FocusMonitor } from '@angular/cdk/a11y';
import { coerceBooleanProperty } from '@angular/cdk/coercion';
import {
  ChangeDetectionStrategy,
  Component,
  effect,
  ElementRef,
  forwardRef,
  inject,
  input,
  type OnDestroy,
  ViewChild,
} from '@angular/core';
import {
  type AbstractControl,
  type ControlValueAccessor,
  FormBuilder,
  type FormGroup,
  NgControl,
  ReactiveFormsModule,
  Validators,
} from '@angular/forms';
import { MAT_FORM_FIELD, type MatFormField, MatFormFieldControl } from '@angular/material/form-field';
import { Subject } from 'rxjs';
import { MyTel } from './my-tel';

/** @title Form field with custom telephone number input control. */

/** Custom `MatFormFieldControl` for telephone number input. */
@Component({
  selector: 'ztv-phone-input',
  templateUrl: './phone-input.html',
  styleUrls: ['./phone-input.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule, ReactiveFormsModule],
  providers: [
    {
      provide: MatFormFieldControl,
      useExisting: forwardRef(() => PhoneInput),
    },
  ],
})
export class PhoneInput implements ControlValueAccessor, MatFormFieldControl<MyTel>, OnDestroy {
  static nextId = 0;
  @ViewChild('part1') part1Input!: ElementRef<HTMLInputElement>;
  @ViewChild('part2') part2Input!: ElementRef<HTMLInputElement>;
  @ViewChild('part3') part3Input!: ElementRef<HTMLInputElement>;
  @ViewChild('part4') part4Input!: ElementRef<HTMLInputElement>;

  parts: FormGroup;
  stateChanges = new Subject<void>();
  focused = false;
  touched = false;
  controlType = 'phone-input';
  id = `phone-input-${PhoneInput.nextId++}`;
  onChange = (_: unknown): void => {
    // intentionally empty: registered via ControlValueAccessor
  };
  onTouched = (): void => {
    // intentionally empty: registered via ControlValueAccessor
  };

  get empty(): boolean {
    const {
      value: { part1, part2, part3, part4 },
    } = this.parts;

    return !part1 && !part2 && !part3 && !part4;
  }

  get shouldLabelFloat(): boolean {
    return this.focused || !this.empty;
  }

  protected readonly _userAriaDescribedBy = input('', { alias: 'aria-describedby' });

  get userAriaDescribedBy(): string {
    return this._userAriaDescribedBy();
  }

  get placeholder(): string {
    return this._placeholderInput();
  }
  protected readonly _placeholderInput = input('', { alias: 'placeholder' });

  get required(): boolean {
    return this._requiredInput();
  }
  protected readonly _requiredInput = input(false, {
    alias: 'required',
    transform: coerceBooleanProperty,
  });

  get disabled(): boolean {
    return this._disabledInput();
  }
  protected readonly _disabledInput = input(false, {
    alias: 'disabled',
    transform: coerceBooleanProperty,
  });

  protected readonly _valueInput = input<MyTel | null>(null, { alias: 'value' });

  get value(): MyTel | null {
    if (this.parts.valid) {
      const {
        value: { part1, part2, part3, part4 },
      } = this.parts;
      return new MyTel(part1, part2, part3, part4);
    }
    return null;
  }
  get valid(): boolean {
    return this.parts.valid;
  }
  get errorState(): boolean {
    // Shows error only after its touched
    // return this.parts.invalid && this.touched;
    this.ngControl?.control?.updateValueAndValidity();

    return this.parts.invalid;
  }

  private readonly _formBuilder = inject(FormBuilder);
  private readonly _focusMonitor = inject(FocusMonitor);
  private readonly _elementRef = inject(ElementRef<HTMLElement>);
  readonly _formField = inject<MatFormField | null>(MAT_FORM_FIELD, { optional: true });
  readonly ngControl = inject(NgControl, { optional: true, self: true });

  constructor() {
    this.parts = this._formBuilder.group({
      part1: [
        null,
        [Validators.required, Validators.minLength(3), Validators.maxLength(3), Validators.pattern('[0-9]{3}')],
      ],
      part2: [
        null,
        [Validators.required, Validators.minLength(3), Validators.maxLength(3), Validators.pattern('[0-9]{3}')],
      ],
      part3: [
        null,
        [Validators.required, Validators.minLength(2), Validators.maxLength(2), Validators.pattern('[0-9]{2}')],
      ],
      part4: [
        null,
        [Validators.required, Validators.minLength(2), Validators.maxLength(2), Validators.pattern('[0-9]{2}')],
      ],
    });

    if (this.ngControl != null) {
      this.ngControl.valueAccessor = this;
    }

    effect(() => {
      this._placeholderInput();
      this._requiredInput();
      this.stateChanges.next();
    });
    effect(() => {
      const isDisabled = this._disabledInput();
      if (isDisabled) {
        this.parts.disable();
      } else {
        this.parts.enable();
      }
      this.stateChanges.next();
    });
    effect(() => {
      const tel = this._valueInput();
      if (tel) {
        this.setValue(tel);
      }
    });
  }

  ngOnDestroy(): void {
    this.stateChanges.complete();
    this._focusMonitor.stopMonitoring(this._elementRef);
  }

  onFocusIn(_event: FocusEvent): void {
    if (!this.focused) {
      this.focused = true;
      this.stateChanges.next();
    }
  }

  onFocusOut(event: FocusEvent): void {
    if (!this._elementRef.nativeElement.contains(event.relatedTarget as Element)) {
      this.touched = true;
      this.focused = false;
      this.onTouched();
      this.stateChanges.next();
    }
  }

  autoFocusNext(control: AbstractControl, nextElement?: HTMLInputElement): void {
    if (!control.errors && nextElement) {
      this._focusMonitor.focusVia(nextElement, 'program');
    }
  }

  autoFocusPrev(control: AbstractControl, prevElement: HTMLInputElement): void {
    if (control.value.length < 1) {
      this._focusMonitor.focusVia(prevElement, 'program');
    }
  }

  setDescribedByIds(ids: string[]): void {
    const controlElement = this._elementRef.nativeElement.querySelector('.phone-input-container')!;
    controlElement.setAttribute('aria-describedby', ids.join(' '));
  }

  onContainerClick(): void {
    if (this.parts.controls.part4.valid) {
      this._focusMonitor.focusVia(this.part4Input.nativeElement, 'program');
    } else if (this.parts.controls.part3.valid) {
      this._focusMonitor.focusVia(this.part4Input.nativeElement, 'program');
    } else if (this.parts.controls.part2.valid) {
      this._focusMonitor.focusVia(this.part3Input.nativeElement, 'program');
    } else if (this.parts.controls.part1.valid) {
      this._focusMonitor.focusVia(this.part2Input.nativeElement, 'program');
    } else {
      this._focusMonitor.focusVia(this.part1Input.nativeElement, 'program');
    }
  }

  writeValue(tel: MyTel | null): void {
    this.setValue(tel);
  }

  registerOnChange(fn: (value: MyTel | null) => void): void {
    this.onChange = fn;
  }

  registerOnTouched(fn: () => void): void {
    this.onTouched = fn;
  }

  setDisabledState(isDisabled: boolean): void {
    if (isDisabled) {
      this.parts.disable();
    } else {
      this.parts.enable();
    }
    this.stateChanges.next();
  }

  _handleInput(control: AbstractControl, nextElement?: HTMLInputElement): void {
    this.autoFocusNext(control, nextElement);
    this.onChange(this.value);
  }

  private setValue(tel: MyTel | null): void {
    const { part1, part2, part3, part4 } = tel || new MyTel('', '', '', '');
    this.parts.setValue({ part1, part2, part3, part4 });
    this.stateChanges.next();
  }
}
