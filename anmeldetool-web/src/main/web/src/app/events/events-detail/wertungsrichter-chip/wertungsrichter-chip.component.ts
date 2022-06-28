import {
  Component,
  EventEmitter,
  Input,
  OnChanges,
  OnInit,
  Output,
  SimpleChanges,
} from "@angular/core";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IUser } from "src/app/core/model/IUser";
import { IWertungsrichter } from "src/app/core/model/IWertungsrichter";
import { IWertungsrichterEinsatz } from "src/app/core/model/IWertungsrichterEinsatz";
import { IWertungsrichterSlot } from "src/app/core/model/IWertungsrichterSlot";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { CachingUserService } from "src/app/core/service/caching-services/caching.user.service";

@Component({
  selector: "app-wertungsrichter-chip",
  templateUrl: "./wertungsrichter-chip.component.html",
  styleUrls: ["./wertungsrichter-chip.component.css"],
})
export class WertungsrichterChipComponent implements OnInit, OnChanges {
  @Input()
  isVereinsAnmelder: boolean;
  @Input()
  isVereinsVerantwortlicher: boolean;
  @Input()
  isAllWertungsrichterList: boolean;
  @Input()
  wertungsrichterUser: IUser;
  @Input()
  anlass: IAnlass;
  @Input()
  useBrevet2: boolean;
  @Output()
  wertungsrichterUserChange = new EventEmitter<IUser>();

  wertungsrichter: IWertungsrichter;

  constructor(
    private authservice: AuthService,
    private userService: CachingUserService,
    private anlassService: CachingAnlassService
  ) {}
  ngOnChanges(changes: SimpleChanges): void {
    if (
      changes.isAllWertungsrichterList &&
      !changes.isAllWertungsrichterList.currentValue
    ) {
      console.error("Load Einsaetze");
    }
  }

  ngOnInit(): void {
    this.userService
      .getWertungsrichter(this.wertungsrichterUser.id)
      .subscribe((value) => {
        if (value) {
          this.wertungsrichter = value;
        }
      });
  }

  wrEinsatzChange(wrEinsatz: IWertungsrichterEinsatz) {
    this.wertungsrichterUserChange.emit(this.wertungsrichterUser);
  }

  kommentarChange(value): void {
    console.log("Value changed: ", value);
    this.wertungsrichterUser.pal.kommentar = value.target.value;
    this.anlassService
      .updateAnlassLink(
        this.wertungsrichterUser.pal,
        this.authservice.currentVerein
      )
      .subscribe((pal) => {
        console.log("Pal saved: ", pal.kommentar);
      });
  }
  getSlotsForBrevet(): IWertungsrichterSlot[] {
    const slots = this.anlass.wertungsrichterSlots.filter((slot) => {
      if (this.useBrevet2) {
        return slot.brevet === 1;
      } else {
        return slot.brevet === this.wertungsrichter.brevet;
      }
    });
    return slots;
  }

  getEinsatzForSlot(slot: IWertungsrichterSlot): IWertungsrichterEinsatz {
    // console.log("getEinsatzForSlot: ", slot, this.wertungsrichterUser);
    const einsatz = this.wertungsrichterUser?.pal?.einsaetze?.filter(
      (einsatz) => {
        return einsatz.wertungsrichterSlotId === slot.id;
      }
    )?.[0];
    return einsatz;
  }

  egalIsAktiv(slot: IWertungsrichterSlot): boolean {
    const egalSlot = this.getEgalSlot();
    if (egalSlot === undefined || egalSlot.id === slot.id) {
      return false;
    }
    return egalSlot.egalSlot;
  }
  get wrAnlassLink() {
    return this.wertungsrichterUser.pal;
  }

  private getEgalSlot(): IWertungsrichterSlot {
    const egalSlots = this.getSlotsForBrevet().filter((slot) => {
      return slot.egalSlot;
    });
    return egalSlots.length > 0 ? egalSlots[0] : undefined;
  }
}
