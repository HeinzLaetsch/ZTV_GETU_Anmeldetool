import { Component, Input, OnInit } from "@angular/core";
import { IUser } from "src/app/core/model/IUser";
import { IWertungsrichter } from "src/app/core/model/IWertungsrichter";
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

  private wertungsrichter: IWertungsrichter;

  constructor(private userService: CachingUserService) {}
  ngOnInit(): void {
    this.userService
      .getWertungsrichter(this.wertungsrichterUser.id)
      .subscribe((value) => {
        if (value) {
          this.wertungsrichter = value;
        }
      });
  }
}
