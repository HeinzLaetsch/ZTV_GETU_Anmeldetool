import { UntypedFormGroup, ValidationErrors, ValidatorFn } from "@angular/forms";

export function ConfirmedValidator(
  controlName: string,
  matchingControlName: string
): ValidatorFn {
  return (formGroup: UntypedFormGroup): ValidationErrors => {
    const control = formGroup.controls[controlName];

    const matchingControl = formGroup.controls[matchingControlName];

    if (matchingControl.errors && !matchingControl.errors.confirmedValidator) {
      return;
    }

    if (control.value !== matchingControl.value) {
      matchingControl.setErrors({ confirmedValidator: true });
    } else {
      matchingControl.setErrors(null);
    }
  };
}
/*
export function ConfirmedValidator(
  controlName: string,
  matchingControlName: string
) {
  return (formGroup: FormGroup) => {
    const control = formGroup.controls[controlName];

    const matchingControl = formGroup.controls[matchingControlName];

    if (matchingControl.errors && !matchingControl.errors.confirmedValidator) {
      return;
    }

    if (control.value !== matchingControl.value) {
      matchingControl.setErrors({ confirmedValidator: true });
    } else {
      matchingControl.setErrors(null);
    }
  };
}
*/
