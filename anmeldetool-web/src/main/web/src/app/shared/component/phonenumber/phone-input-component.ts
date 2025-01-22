import { FocusMonitor } from "@angular/cdk/a11y";
import { BooleanInput, coerceBooleanProperty } from "@angular/cdk/coercion";
import {
  Component,
  ElementRef,
  Inject,
  Input,
  OnDestroy,
  Optional,
  Self,
  ViewChild,
} from "@angular/core";
import {
  AbstractControl,
  ControlValueAccessor,
  UntypedFormBuilder,
  UntypedFormGroup,
  NgControl,
  ValidationErrors,
  Validators,
} from "@angular/forms";
import {
  MatFormField,
  MatFormFieldControl,
  MAT_FORM_FIELD,
} from "@angular/material/form-field";
import { Subject } from "rxjs";

/** @title Form field with custom telephone number input control. */

/** Data structure for holding telephone number. */
export class MyTel {
  constructor(
    public part1: string,
    public part2: string,
    public part3: string,
    public part4: string
  ) {}
}

/** Custom `MatFormFieldControl` for telephone number input. */
@Component({
  selector: "app-phone-input",
  templateUrl: "phone-input.html",
  styleUrls: ["phone-input.css"],
  providers: [{ provide: MatFormFieldControl, useExisting: PhoneInput }],
  host: {
    "[class.phone-floating]": "shouldLabelFloat",
    "[id]": "id",
  },
})
export class PhoneInput
  implements ControlValueAccessor, MatFormFieldControl<MyTel>, OnDestroy
{
  static nextId = 0;
  @ViewChild("part1") part1Input: HTMLInputElement;
  @ViewChild("part2") part2Input: HTMLInputElement;
  @ViewChild("part3") part3Input: HTMLInputElement;
  @ViewChild("part4") part4Input: HTMLInputElement;

  parts: UntypedFormGroup;
  stateChanges = new Subject<void>();
  focused = false;
  touched = false;
  controlType = "phone-input";
  id = `phone-input-${PhoneInput.nextId++}`;
  onChange = (_: any) => {};
  onTouched = () => {};

  get empty() {
    const {
      value: { part1, part2, part3, part4 },
    } = this.parts;

    return !part1 && !part2 && !part3 && !part4;
  }

  get shouldLabelFloat() {
    return this.focused || !this.empty;
  }

  @Input("aria-describedby") userAriaDescribedBy: string;

  get placeholder(): string {
    return this._placeholder;
  }
  @Input()
  set placeholder(value: string) {
    this._placeholder = value;
    this.stateChanges.next();
  }
  private _placeholder: string;

  get required(): boolean {
    return this._required;
  }
  @Input()
  set required(value: BooleanInput) {
    this._required = coerceBooleanProperty(value);
    this.stateChanges.next();
  }
  private _required = false;

  get disabled(): boolean {
    return this._disabled;
  }
  @Input()
  set disabled(value: BooleanInput) {
    this._disabled = coerceBooleanProperty(value);
    this._disabled ? this.parts.disable() : this.parts.enable();
    this.stateChanges.next();
  }
  private _disabled = false;

  get value(): MyTel | null {
    if (this.parts.valid) {
      const {
        value: { part1, part2, part3, part4 },
      } = this.parts;
      return new MyTel(part1, part2, part3, part4);
    }
    return null;
  }
  @Input()
  set value(tel: MyTel | null) {
    const { part1, part2, part3, part4 } = tel || new MyTel("", "", "", "");
    this.parts.setValue({ part1, part2, part3, part4 });
    this.stateChanges.next();
  }

  get valid(): boolean {
    return this.parts.valid;
  }
  get errorState(): boolean {
    // Shows error only after its touched
    // return this.parts.invalid && this.touched;
    const errors: ValidationErrors = {
      required: this.parts.hasError("required"),
      minLength: this.parts.hasError("minLength"),
      maxLength: this.parts.hasError("maxLength"),
      pattern: this.parts.hasError("pattern"),
    };

    this.ngControl.control.updateValueAndValidity();

    return this.parts.invalid;
  }

  constructor(
    formBuilder: UntypedFormBuilder,
    private _focusMonitor: FocusMonitor,
    private _elementRef: ElementRef<HTMLElement>,
    @Optional() @Inject(MAT_FORM_FIELD) public _formField: MatFormField,
    @Optional() @Self() public ngControl: NgControl
  ) {
    this.parts = formBuilder.group({
      part1: [
        null,
        [
          Validators.required,
          Validators.minLength(3),
          Validators.maxLength(3),
          Validators.pattern("[0-9]{3}"),
        ],
      ],
      part2: [
        null,
        [
          Validators.required,
          Validators.minLength(3),
          Validators.maxLength(3),
          Validators.pattern("[0-9]{3}"),
        ],
      ],
      part3: [
        null,
        [
          Validators.required,
          Validators.minLength(2),
          Validators.maxLength(2),
          Validators.pattern("[0-9]{2}"),
        ],
      ],
      part4: [
        null,
        [
          Validators.required,
          Validators.minLength(2),
          Validators.maxLength(2),
          Validators.pattern("[0-9]{2}"),
        ],
      ],
    });

    if (this.ngControl != null) {
      this.ngControl.valueAccessor = this;
    }
  }

  ngOnDestroy() {
    this.stateChanges.complete();
    this._focusMonitor.stopMonitoring(this._elementRef);
  }

  onFocusIn(event: FocusEvent) {
    if (!this.focused) {
      this.focused = true;
      this.stateChanges.next();
    }
  }

  onFocusOut(event: FocusEvent) {
    if (
      !this._elementRef.nativeElement.contains(event.relatedTarget as Element)
    ) {
      this.touched = true;
      this.focused = false;
      this.onTouched();
      this.stateChanges.next();
    }
  }

  autoFocusNext(
    control: AbstractControl,
    nextElement?: HTMLInputElement
  ): void {
    if (!control.errors && nextElement) {
      this._focusMonitor.focusVia(nextElement, "program");
    }
  }

  autoFocusPrev(control: AbstractControl, prevElement: HTMLInputElement): void {
    if (control.value.length < 1) {
      this._focusMonitor.focusVia(prevElement, "program");
    }
  }

  setDescribedByIds(ids: string[]) {
    const controlElement = this._elementRef.nativeElement.querySelector(
      ".phone-input-container"
    )!;
    controlElement.setAttribute("aria-describedby", ids.join(" "));
  }

  onContainerClick() {
    if (this.parts.controls.part4.valid) {
      this._focusMonitor.focusVia(this.part4Input, "program");
    } else if (this.parts.controls.part3.valid) {
      this._focusMonitor.focusVia(this.part4Input, "program");
    } else if (this.parts.controls.part2.valid) {
      this._focusMonitor.focusVia(this.part3Input, "program");
    } else if (this.parts.controls.part1.valid) {
      this._focusMonitor.focusVia(this.part2Input, "program");
    } else {
      this._focusMonitor.focusVia(this.part1Input, "program");
    }
  }

  writeValue(tel: MyTel | null): void {
    this.value = tel;
  }

  registerOnChange(fn: any): void {
    this.onChange = fn;
  }

  registerOnTouched(fn: any): void {
    this.onTouched = fn;
  }

  setDisabledState(isDisabled: boolean): void {
    this.disabled = isDisabled;
  }

  _handleInput(control: AbstractControl, nextElement?: HTMLInputElement): void {
    this.autoFocusNext(control, nextElement);
    this.onChange(this.value);
  }
}
