import { HttpEventType } from '@angular/common/http';
import { CommonModule } from '@angular/common';
import { Component, Inject } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from '@angular/material/dialog';
import { MatIconModule } from '@angular/material/icon';
import { Subject, type Subscription } from 'rxjs';
import { takeUntil } from 'rxjs/operators';
import { CachingAnlassService } from 'src/app/core/service/caching-services/caching.anlass.service';

@Component({
  selector: 'lxt-upload',
  templateUrl: './upload.component.html',
  styleUrls: ['./upload.component.css'],
  standalone: true,
  imports: [CommonModule, MatDialogModule, MatButtonModule, MatIconModule],
})
export class Upload {
  private _destroy$ = new Subject<void>();
  fileName = '';
  uploading: false;
  type: string;
  upLoadError: string;

  uploadProgress: number;
  uploadSub: Subscription;

  constructor(
    private dialogRef: MatDialogRef<Upload>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private anlassService: CachingAnlassService,
  ) {}

  onFileSelected(event) {
    const file: File = event.target.files[0];

    if (file) {
      this.fileName = file.name;

      const formData = new FormData();

      formData.append('teilnehmer', file);
      // const alle = this.anlassService.getAnlaesse(TiTuEnum.Alle);
      this.anlassService
        .importTeilnehmerForAnlassCsv(this.data, formData)
        .pipe(takeUntil(this._destroy$))
        .subscribe(
          (event) => {
            console.log('Resultat: ', event);
            if (event?.type === HttpEventType.UploadProgress) {
              this.uploadProgress = Math.round(100 * (event.loaded / event.total));
            } else {
              this.uploading = false;
              this.type = 'success';
              this.dialogRef.close();
            }
            // this.updateActiveBkpLoad();
          },
          (error: any) => {
            console.error('error during file upload: ', error);
            this.uploading = false;
            this.upLoadError = error.error;
            this.type = 'error';
          },
        );
    }
  }
  ngOnDestroy(): void {
    this._destroy$.next();
  }
}
