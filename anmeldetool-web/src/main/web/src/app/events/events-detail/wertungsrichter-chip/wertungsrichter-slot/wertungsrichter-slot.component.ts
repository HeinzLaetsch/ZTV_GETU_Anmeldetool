import { DatePipe } from "@angular/common";
import { Component, EventEmitter, Input, OnInit, Output } from "@angular/core";
import { AnzeigeStatusEnum } from "src/app/core/model/AnzeigeStatusEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IPersonAnlassLink } from "src/app/core/model/IPersonAnlassLink";
import { IWertungsrichter } from "src/app/core/model/IWertungsrichter";
import { IWertungsrichterEinsatz } from "src/app/core/model/IWertungsrichterEinsatz";
import { IWertungsrichterSlot } from "src/app/core/model/IWertungsrichterSlot";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";

@Component({
  selector: "app-wertungsrichter-slot",
  templateUrl: "./wertungsrichter-slot.component.html",
  styleUrls: ["./wertungsrichter-slot.component.css"],
})
export class WertungsrichterSlotComponent implements OnInit {
  @Input()
  isVereinsAnmelder: boolean;
  @Input()
  isVereinsVerantwortlicher: boolean;
  @Input()
  slot: IWertungsrichterSlot;
  @Input()
  wertungsrichter: IWertungsrichter;
  @Input()
  wrAnlassLink: IPersonAnlassLink;
  @Input()
  einsatz: IWertungsrichterEinsatz;
  @Input()
  private anlass: IAnlass;

  @Output()
  wrEinsatzChange = new EventEmitter<IWertungsrichterEinsatz>();

  constructor(
    private authservice: AuthService,
    private anlassService: CachingAnlassService,
    private datePipe: DatePipe
  ) {}
  ngOnInit(): void {
    // console.log("Einsatz: ", this.einsatz);
  }

  isCheckboxDisabled() {
    if (
      !this.anlass.anzeigeStatus.hasStatus(AnzeigeStatusEnum.NOCH_NICHT_OFFEN)
    ) {
      if (
        !this.anlass.anzeigeStatus.hasStatus(AnzeigeStatusEnum.ERFASSEN_CLOSED)
      ) {
        return false;
      }
    }
    return true;
  }

  userEingesetztgmodelchange(value): void {
    this.einsatz.eingesetzt = value;
    this.anlassService
      .updateWrEinsatz(
        this.authservice.currentVerein,
        this.wrAnlassLink,
        this.einsatz
      )
      .subscribe((wrEinsatz) => {
        this.wrEinsatzChange.emit(wrEinsatz);
      });
  }
  getSlotText(): string {
    let text = "";
    if (this.slot.tag) {
      const tag = this.datePipe.transform(this.slot.tag, "dd-yyyy-MM");
      text += tag;
    }
    if (this.slot.startzeit) {
      const start = this.datePipe.transform(this.slot.startzeit, "hh:mm");
      if (text.length > 0) text += " ";
      text += start;
    }
    if (this.slot.endzeit) {
      const end = this.datePipe.transform(this.slot.endzeit, "hh:mm");
      if (text.length > 0) text += " ";
      text += end;
    }
    if (this.slot.beschreibung) {
      if (text.length > 0) text += " ";
      text += this.slot.beschreibung;
    }

    return text;
  }

  canEdit() {
    if (this.isCheckboxDisabled()) {
      return false;
    }
    return (
      this.authservice.isVereinsAnmmelder() ||
      this.authservice.isVereinsVerantwortlicher()
    );
  }
}
