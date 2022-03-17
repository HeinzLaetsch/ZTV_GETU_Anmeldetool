import { HttpEventType } from "@angular/common/http";
import { Component, Inject } from "@angular/core";
import { MatDialogRef, MAT_DIALOG_DATA } from "@angular/material/dialog";
import { Subject, Subscription } from "rxjs";
import { takeUntil } from "rxjs/operators";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";

@Component({
  selector: "app-upload",
  templateUrl: "./upload.component.html",
  styleUrls: ["./upload.component.css"],
})
export class Upload {
  private _destroy$ = new Subject<void>();
  fileName = "";
  uploading: false;
  type: string;
  upLoadError: string;

  uploadProgress: number;
  uploadSub: Subscription;

  constructor(
    private dialogRef: MatDialogRef<Upload>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private anlassService: CachingAnlassService
  ) {}

  onFileSelected(event) {
    const file: File = event.target.files[0];

    if (file) {
      this.fileName = file.name;

      const formData = new FormData();

      formData.append("teilnehmer", file);
      // const alle = this.anlassService.getAnlaesse(TiTuEnum.Alle);
      this.anlassService
        .importTeilnehmerForAnlassCsv(this.data, formData)
        .pipe(takeUntil(this._destroy$))
        .subscribe(
          (event) => {
            console.log("Resultat: ", event);
            if (event?.type === HttpEventType.UploadProgress) {
              this.uploadProgress = Math.round(
                100 * (event.loaded / event.total)
              );
            } else {
              this.uploading = false;
              this.type = "success";
              this.dialogRef.close();
            }
            // this.updateActiveBkpLoad();
          },
          // tslint:disable-next-line:no-any
          (error: any) => {
            console.error("error during file upload: ", error);
            this.uploading = false;
            this.upLoadError = error.error;
            this.type = "error";
          }
        );
    }
  }
  public ngOnDestroy(): void {
    this._destroy$.next();
  }
}
