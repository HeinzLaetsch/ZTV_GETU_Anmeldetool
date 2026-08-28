import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, Component, computed, inject, signal } from '@angular/core';
import { ReactiveFormsModule, NonNullableFormBuilder } from '@angular/forms';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MaterialModule } from 'src/app/shared/material-module';
import type { ITeilnehmer } from 'src/app/core/model/ITeilnehmer';

interface TeilnehmerDialogData {
  title: string;
  actionButton: string;
  disabled: boolean;
  teilnehmer: ITeilnehmer;
}

@Component({
  selector: 'lxt-teilnehmer-dialog',
  templateUrl: './teilnehmer-dialog.component.html',
  styleUrls: ['./teilnehmer-dialog.component.scss'],
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MatDialogModule, MaterialModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class TeilnehmerDialog {
  readonly dialogRef = inject(MatDialogRef<TeilnehmerDialog>);
  readonly data = inject(MAT_DIALOG_DATA) as TeilnehmerDialogData;
  private readonly formBuilder = inject(NonNullableFormBuilder);

  readonly teilnehmerForm = this.formBuilder.group({
    name: this.formBuilder.control({ value: this.data.teilnehmer.name ?? '', disabled: this.data.disabled }),
    vorname: this.formBuilder.control({ value: this.data.teilnehmer.vorname ?? '', disabled: this.data.disabled }),
    jahrgang: this.formBuilder.control({ value: this.data.teilnehmer.jahrgang ?? 0, disabled: this.data.disabled }),
    tiTu: this.formBuilder.control({ value: this.data.teilnehmer.tiTu ?? 'Ti', disabled: this.data.disabled }),
    stvNummer: this.formBuilder.control({ value: this.data.teilnehmer.stvNummer ?? '', disabled: this.data.disabled }),
  });

  readonly dialogTitle = computed(() => this.data.title);
  readonly dialogActionButton = computed(() => this.data.actionButton);
  readonly isDisabled = signal(this.data.disabled);

  onCancelClick(): void {
    this.dialogRef.close();
  }

  onSaveClick(): void {
    if (this.isDisabled()) {
      this.dialogRef.close(this.data.teilnehmer);
      return;
    }

    const formValue = this.teilnehmerForm.getRawValue();
    this.dialogRef.close({
      ...this.data.teilnehmer,
      name: formValue.name,
      vorname: formValue.vorname,
      jahrgang: formValue.jahrgang,
      tiTu: formValue.tiTu,
      stvNummer: formValue.stvNummer,
    });
  }
}
