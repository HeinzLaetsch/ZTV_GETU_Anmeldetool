import { HttpEventType } from '@angular/common/http';
import { CommonModule } from '@angular/common';
import { Component, DestroyRef, inject, signal } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatIconModule } from '@angular/material/icon';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import { CachingAnlassService } from 'src/app/core/service/caching-services/caching.anlass.service';

@Component({
  selector: 'lxt-contest-upload',
  templateUrl: './contest-upload.component.html',
  styleUrls: ['./contest-upload.component.css'],
  standalone: true,
  imports: [CommonModule, MatDialogModule, MatButtonModule, MatIconModule],
})
export class ContestUpload {
  private readonly dialogRef = inject(MatDialogRef<ContestUpload>);
  private readonly destroyRef = inject(DestroyRef);
  private readonly anlassService = inject(CachingAnlassService);

  readonly data = inject<IAnlass>(MAT_DIALOG_DATA);
  readonly fileName = signal('');
  readonly uploading = signal(false);
  readonly type = signal<'success' | 'error' | null>(null);
  readonly upLoadError = signal('');
  readonly uploadProgress = signal(0);

  onFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement | null;
    const file = input?.files?.[0];

    if (file) {
      this.fileName.set(file.name);
      this.uploading.set(true);
      this.uploadProgress.set(0);
      this.type.set(null);

      const formData = new FormData();

      formData.append('teilnehmer', file);
      this.anlassService
        .importContestTeilnehmerForAnlassCsv(this.data, formData)
        .pipe(takeUntilDestroyed(this.destroyRef))
        .subscribe({
          next: (uploadEvent) => {
            console.log('Resultat: ', uploadEvent);
            if (uploadEvent?.type === HttpEventType.UploadProgress) {
              const total = uploadEvent.total ?? uploadEvent.loaded;
              this.uploadProgress.set(Math.round((100 * uploadEvent.loaded) / total));
              return;
            }

            this.uploading.set(false);
            this.type.set('success');
            this.dialogRef.close();
          },
          error: (error: unknown) => {
            const uploadError = error as { error?: string };
            console.error('error during file upload: ', error);
            this.uploading.set(false);
            this.upLoadError.set(uploadError.error ?? 'Unbekannter Fehler');
            this.type.set('error');
          },
        });
    }
  }
}
