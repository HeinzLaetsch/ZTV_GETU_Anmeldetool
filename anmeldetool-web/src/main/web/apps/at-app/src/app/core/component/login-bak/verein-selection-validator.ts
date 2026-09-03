import { AbstractControl, ValidationErrors } from '@angular/forms';

// The function checks if the input is forbidden
export function vereinSelectionValidator(control: AbstractControl): ValidationErrors | null {
  const value = control.value;

  console.log('### VALIDATOR:', value);
  console.log('### VALIDATOR typeof:', typeof value);

  if (value === null || value === '') {
    return null;
  }

  return typeof value === 'string' ? { vereinSelection: true } : null;
}
