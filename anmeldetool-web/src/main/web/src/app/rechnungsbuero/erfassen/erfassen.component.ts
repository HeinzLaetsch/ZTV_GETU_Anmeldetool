import { Component, OnInit } from "@angular/core";
import { GeraeteEnum } from "src/app/core/model/GeraeteEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { ILaufliste } from "src/app/core/model/ILaufliste";
import { IUser } from "src/app/core/model/IUser";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { CachingUserService } from "src/app/core/service/caching-services/caching.user.service";
import { RanglistenService } from "src/app/core/service/rangliste/ranglisten.service";

@Component({
  selector: "app-erfassen",
  templateUrl: "./erfassen.component.html",
  styleUrls: ["./erfassen.component.css"],
})
export class ErfassenComponent implements OnInit {
  currentUser: IUser;
  anlass: IAnlass;
  laufliste: ILaufliste;

  search: string;

  constructor(
    private authService: AuthService,
    private anlassService: CachingAnlassService,
    private ranglistenService: RanglistenService
  ) {}

  ngOnInit() {
    this.currentUser = this.authService.currentUser;
    this.anlass = this.anlassService.getAnlaesse(TiTuEnum.Tu)[0];
  }

  get sprung(): boolean {
    if (this.laufliste?.geraet === GeraeteEnum.SPRUNG) {
      return true;
    }
    return false;
  }
  get title(): string {
    if (this.sprung) {
      return "Noten erfassen";
    }
    return "Note erfassen";
  }

  searchLaufliste() {
    console.log("Suche: ", this.search);
    this.ranglistenService
      .searchLauflisteByKey(this.anlass, this.search)
      .subscribe((laufliste) => {
        this.laufliste = laufliste;
      });
  }
}
