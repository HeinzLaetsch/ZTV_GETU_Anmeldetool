import { Component, EventEmitter, Input, OnInit, Output } from "@angular/core";
import { FormControl, Validators } from "@angular/forms";
import { ILauflistenEintrag } from "src/app/core/model/ILauflistenEintrag";
import { RanglistenService } from "src/app/core/service/rangliste/ranglisten.service";

@Component({
  selector: "app-erfassen-row",
  templateUrl: "./erfassen-row.component.html",
  styleUrls: ["./erfassen-row.component.css"],
})
export class ErfassenRowComponent implements OnInit {
  @Input()
  eintrag: ILauflistenEintrag;
  @Input()
  sprung: boolean;
  @Output()
  entryChangedEvent = new EventEmitter<ILauflistenEintrag>();

  note_1_Cntr: FormControl;
  note_2_Cntr: FormControl;
  saved = false;

  constructor(private ranglistenService: RanglistenService) {
    this.note_1_Cntr = new FormControl("", {
      updateOn: "blur",
      validators: [Validators.required, Validators.max(10), Validators.min(3)],
    });
    this.note_2_Cntr = new FormControl("", {
      updateOn: "blur",
      validators: [Validators.required, Validators.max(10), Validators.min(3)],
    });
  }
  ngOnInit(): void {
    this.note_1_Cntr.setValue(this.eintrag.note_1);
    this.note_1_Cntr.valueChanges.subscribe((value) => {
      this.fireErrorEvent();
    });
    this.note_2_Cntr.setValue(this.eintrag.note_2);
    this.note_2_Cntr.valueChanges.subscribe((value) => {
      this.fireErrorEvent();
    });
  }

  fireErrorEvent(): void {
    let hasErrors = false;
    if (this.note_1_Cntr.errors) {
      hasErrors = true;
    }
    if (this.sprung) {
      if (this.note_2_Cntr.errors) {
        hasErrors = true;
      }
    }
    if (hasErrors) {
      // this.entryChangedEvent.emit(this.eintrag);
    } else {
      // this.entryChangedEvent.emit(this.eintrag);
      this.update();
    }
  }

  private update() {
    this.ranglistenService
      .updateLauflistenEintrag(this.eintrag)
      .subscribe((eintrag) => {
        if (eintrag) {
          this.eintrag = eintrag;
          this.saved = true;
          this.entryChangedEvent.emit(this.eintrag);
        } else {
          this.saved = false;
        }
      });
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

    if (!note1Status || !note2Status) {
      return "errorBg";
    }
    return "okBg";
  }
}
