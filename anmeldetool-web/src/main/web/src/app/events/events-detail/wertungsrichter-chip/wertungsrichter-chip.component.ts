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
  @Output()
  wertungsrichterUserChange = new EventEmitter<IUser>();

  private wertungsrichter: IWertungsrichter;

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
    return this.anlass.wertungsrichterSlots.filter(
      (slot) => slot.brevet === this.wertungsrichter.brevet
    );
  }

  getEinsatzForSlot(slot: IWertungsrichterSlot): IWertungsrichterEinsatz {
    // console.log("getEinsatzForSlot: ", slot, this.wertungsrichterUser);
    return this.wertungsrichterUser?.pal?.einsaetze?.filter((einsatz) => {
      return einsatz.wertungsrichterSlotId === slot.id;
    })?.[0];
  }

  get wrAnlassLink() {
    return this.wertungsrichterUser.pal;
  }
}
