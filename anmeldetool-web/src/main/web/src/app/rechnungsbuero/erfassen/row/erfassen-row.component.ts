import { ValueConverter } from "@angular/compiler/src/render3/view/template";
import { Component, EventEmitter, Input, OnInit, Output } from "@angular/core";
import { UntypedFormControl, Validators } from "@angular/forms";
import { MatDialog } from "@angular/material/dialog";
import { ToastrService } from "ngx-toastr";
import { IAnlass } from "src/app/core/model/IAnlass";
import { ILauflistenEintrag } from "src/app/core/model/ILauflistenEintrag";
import { RanglistenService } from "src/app/core/service/rangliste/ranglisten.service";
import { NotenBlattZurueckZiehen } from "./delete-dialog/delete-notenblatt.component";

@Component({
  selector: "app-erfassen-row",
  templateUrl: "./erfassen-row.component.html",
  styleUrls: ["./erfassen-row.component.css"],
})
export class ErfassenRowComponent implements OnInit {
  @Input()
  anlass: IAnlass;
  @Input()
  eintrag: ILauflistenEintrag;
  @Input()
  sprung: boolean;
  @Input()
  modeErfassen: boolean;
  @Output()
  entryChangedEvent = new EventEmitter<ILauflistenEintrag>();

  note_1_Cntr: UntypedFormControl;
  note_2_Cntr: UntypedFormControl;
  note_1_correct = false;
  note_2_correct = false;

  constructor(
    private ranglistenService: RanglistenService,
    public dialog: MatDialog,
    private toastr: ToastrService
  ) {
    this.note_1_Cntr = new UntypedFormControl("", {
      updateOn: "blur",
      validators: [
        Validators.required,
        Validators.max(10),
        Validators.min(0),
        Validators.pattern("^[0,1]?[0-9](\\.[0-9]?[0,5]?|$)"),
      ],
    });
    this.note_2_Cntr = new UntypedFormControl("", {
      updateOn: "blur",
      validators: [
        Validators.required,
        Validators.max(10),
        Validators.min(0),
        Validators.pattern("^[0,1]?[0-9](\\.[0-9]?[0,5]?|$)"),
      ],
    });
  }
  ngOnInit(): void {
    if (this.modeErfassen) {
      this.note_1_Cntr.setValue(this.eintrag.note_1, { emitEvent: false });
      if (this.eintrag.erfasst) {
        this.note_1_Cntr.disable();
        this.note_2_Cntr.disable();
      } else {
        this.note_1_Cntr.enable();
        this.note_2_Cntr.enable();
      }
      this.note_1_Cntr.valueChanges.subscribe((value) => {
        console.log("On Control Blur , Value: ", this.note_1_Cntr.value);
        if (this.eintrag.note_1 !== value) {
          const corrected = this.addPoint(value);
          this.note_1_Cntr.setValue(corrected, { emitEvent: false });
          this.eintrag.note_1 = +corrected;
          this.note_1_correct = true;
          this.note_2_correct = true;
          this.fireUpdateEvent();
        }
      });
      this.note_2_Cntr.setValue(this.eintrag.note_2, { emitEvent: false });
      this.note_2_Cntr.valueChanges.subscribe((value) => {
        if (this.eintrag.note_2 !== value) {
          const corrected = this.addPoint(value);
          this.note_2_Cntr.setValue(corrected, { emitEvent: false });
          this.eintrag.note_2 = +corrected;
          this.note_1_correct = true;
          this.note_2_correct = true;
          this.fireUpdateEvent();
        }
      });
    } else {
      if (this.eintrag.checked) {
        this.note_1_Cntr.disable();
        this.note_2_Cntr.disable();
        this.note_1_Cntr.setValue(this.eintrag.note_1, { emitEvent: false });
        this.note_2_Cntr.setValue(this.eintrag.note_2, { emitEvent: false });
      } else {
        this.note_1_Cntr.enable();
        this.note_2_Cntr.enable();
      }
      this.note_1_Cntr.valueChanges.subscribe((value: string) => {
        this.note_1_Cntr.setValue(this.addPoint(value), { emitEvent: false });
        this.note_1_correct = +this.note_1_Cntr.value === this.eintrag.note_1;
        if (!this.sprung) {
          this.note_2_correct = this.note_1_correct;
        }
        this.fireCheckedEvent();
      });
      this.note_2_Cntr.valueChanges.subscribe((value) => {
        this.note_2_Cntr.setValue(this.addPoint(value), { emitEvent: false });
        this.note_2_correct = +this.note_2_Cntr.value === this.eintrag.note_2;
        this.fireCheckedEvent();
      });
    }
    if (this.eintrag.deleted) {
      if (this.eintrag.note_1 <= 0) {
        this.note_1_Cntr.disable();
      }
      if (this.eintrag.note_2 <= 0) {
        this.note_2_Cntr.disable();
      }
    }
  }
  private addPoint(value: string): string {
    console.log("addPoint: ", value);
    if (value && value.indexOf(".") === -1) {
      if (value.indexOf("1") === 0 && value.length > 1) {
        if (value.length > 2) {
          value = value.substring(0, 2) + "." + value.substring(2);
        }
      } else {
        if (value.length > 1) {
          value = value.substring(0, 1) + "." + value.substring(1);
        }
      }
    }
    return value;
  }

  fireCheckedEvent() {
    if (this.note_1_correct && this.note_2_correct) {
      this.eintrag.checked = true;
      this.update();
    }
  }

  fireUpdateEvent(): void {
    let hasErrors = false;
    if (this.note_1_Cntr.errors) {
      hasErrors = true;
    }
    if (this.sprung) {
      if (this.note_2_Cntr.errors) {
        hasErrors = true;
      }
    }
    if (!hasErrors) {
      this.update();
    }
  }

  private update() {
    this.ranglistenService
      .updateLauflistenEintrag(this.anlass, this.eintrag)
      .subscribe((eintrag) => {
        if (eintrag) {
          this.eintrag = eintrag;
          this.entryChangedEvent.emit(this.eintrag);
          if (this.eintrag.note_1 !== -1) {
            this.note_1_Cntr.disable({ emitEvent: false });
            if (this.sprung) {
              this.note_2_Cntr.disable({ emitEvent: false });
            }
          }
        }
      });
  }
  getNotenStyle(): string {
    if (this.sprung) {
      if (this.note_1_Cntr.touched && this.note_2_Cntr.touched) {
        if (!this.note_1_Cntr.errors && !this.note_2_Cntr.errors) {
          if (this.note_1_correct && this.note_2_correct) {
            return "show_note";
          } else {
            return "show_note_error";
          }
        }
      }
    } else {
      if (this.note_1_Cntr.touched) {
        if (!this.note_1_Cntr.errors) {
          if (this.note_1_correct) {
            return "show_note";
          } else {
            return "show_note_error";
          }
        }
      }
    }
    return "hide_note";
  }
  getBackground(): string {
    let note1Status = true;
    let note2Status = true;
    let untouched = true;

    if (this.note_1_Cntr.touched) {
      untouched = false;
      if (this.note_1_Cntr?.errors) {
        note1Status = false;
      }
    }
    if (this.sprung) {
      if (this.note_2_Cntr.touched) {
        untouched = false;
        if (this.note_2_Cntr?.errors) {
          note2Status = false;
        }
      } else {
        return "notTouchedBg";
      }
    }

    if (untouched) {
      return "notTouchedBg";
    }

    if (
      !note1Status ||
      !note2Status ||
      !this.note_1_correct ||
      (this.sprung && !this.note_2_correct)
    ) {
      return "errorBg";
    }
    return "okBg";
  }
  leeren() {
    this.eintrag.erfasst = false;
    this.eintrag.checked = false;
    this.eintrag.deleted = false;
    this.eintrag.note_1 = -1;
    this.eintrag.note_2 = -1;
    this.note_1_Cntr.setValue(-1, { emitEvent: false });
    this.note_2_Cntr.setValue(-1, { emitEvent: false });
    this.note_1_Cntr.enable();
    this.note_2_Cntr.enable();
    this.update();
  }
  delete() {
    // console.log("Delete");
    const dialogRef = this.dialog.open(NotenBlattZurueckZiehen, {
      data: this.eintrag,
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result === "abbrechen") {
        return;
      }
      this.ranglistenService
        .deleteNotenblatt(this.anlass, this.eintrag, result)
        .subscribe((result) => {
          if (result) {
            this.eintrag.deleted = true;
            this.eintrag.note_1 = -1;
            this.eintrag.note_2 = -1;
            this.note_1_Cntr.disable();
            this.note_2_Cntr.disable();
            this.update();
            this.toasterInfo();
          } else {
            this.toasterError();
          }
        });
    });
  }
  private toasterInfo() {
    const options = this.toastr.toastrConfig;
    options.timeOut = 1000;
    this.toastr.info("Notenblatt zurückgezogen");
  }
  private toasterError() {
    const options = this.toastr.toastrConfig;
    options.closeButton = true;
    options.disableTimeOut = true;
    this.toastr.error("Es ist ein Fehler aufgetreten");
  }
}
