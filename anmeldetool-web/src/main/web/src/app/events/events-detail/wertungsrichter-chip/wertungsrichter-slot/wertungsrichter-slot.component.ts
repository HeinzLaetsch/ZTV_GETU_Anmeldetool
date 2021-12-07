import { DatePipe } from "@angular/common";
import { Component, Input, OnInit } from "@angular/core";
import { IPersonAnlassLink } from "src/app/core/model/IPersonAnlassLink";
import { IWertungsrichter } from "src/app/core/model/IWertungsrichter";
import { IWertungsrichterEinsatz } from "src/app/core/model/IWertungsrichterEinsatz";
import { IWertungsrichterSlot } from "src/app/core/model/IWertungsrichterSlot";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { CachingUserService } from "src/app/core/service/caching-services/caching.user.service";

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
  private einsatz: IWertungsrichterEinsatz;

  constructor(
    private authservice: AuthService,
    private userService: CachingUserService,
    private anlassService: CachingAnlassService,
    private datePipe: DatePipe
  ) {}
  ngOnInit(): void {
    // console.log("Einsatz: ", this.einsatz);
  }
  userEingesetztgmodelchange(value): void {
    this.einsatz.eingesetzt = value;
    this.anlassService
      .updateWrEinsatz(
        this.authservice.currentVerein,
        this.wrAnlassLink,
        this.einsatz
      )
      .subscribe((wrEinsatz) => {});
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
    return (
      this.authservice.isVereinsAnmmelder() ||
      this.authservice.isVereinsVerantwortlicher()
    );
  }
}
