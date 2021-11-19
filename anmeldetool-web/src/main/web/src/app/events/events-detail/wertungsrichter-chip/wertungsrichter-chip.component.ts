import { Component, Input, OnInit } from "@angular/core";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IUser } from "src/app/core/model/IUser";
import { IWertungsrichter } from "src/app/core/model/IWertungsrichter";
import { IWertungsrichterAnlassLink } from "src/app/core/model/IWertungsrichterAnlassLink";
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
export class WertungsrichterChipComponent implements OnInit {
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

  private wertungsrichter: IWertungsrichter;
  private wrAnlassLink: IWertungsrichterAnlassLink;

  constructor(
    private authservice: AuthService,
    private userService: CachingUserService,
    private anlassService: CachingAnlassService
  ) {}
  ngOnInit(): void {
    this.userService
      .getWertungsrichter(this.wertungsrichterUser.id)
      .subscribe((value) => {
        if (value) {
          this.wertungsrichter = value;
        }
      });
    this.anlassService
      .getWrEinsatz(
        this.anlass,
        this.authservice.currentVerein,
        this.wertungsrichterUser
      )
      .subscribe((link) => {
        if (!link) {
          console.error("No Link");
        }
        this.wrAnlassLink = link;
        if (!this.wrAnlassLink.einsaetze) {
          this.wrAnlassLink.einsaetze = new Array<IWertungsrichterEinsatz>();
        }
        //TODO Momentan löschen
        this.wrAnlassLink.einsaetze = this.wrAnlassLink.einsaetze.slice(0, 0);
        this.anlass.wertungsrichterSlots?.forEach((slot) => {
          const einsatz: IWertungsrichterEinsatz = {
            id: "",
            slotId: slot.id,
            wertungsrichterId: this.wertungsrichterUser.wr?.id,
            wertungsrichterAnlassLinkId: this.wrAnlassLink.id,
            eingesetzt: false,
          };
          this.wrAnlassLink.einsaetze.push(einsatz);
        });
      });
    // console.log("Anlass: ", this.anlass);
  }

  getEinsatzForSlot(slot: IWertungsrichterSlot): IWertungsrichterEinsatz {
    return this.wrAnlassLink?.einsaetze?.filter((einsatz) => {
      return einsatz.slotId === slot.id;
    })?.[0];
  }
}
