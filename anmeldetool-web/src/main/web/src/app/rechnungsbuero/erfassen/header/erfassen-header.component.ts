import { Component, Input, OnInit } from "@angular/core";
import { GeraeteEnum } from "src/app/core/model/GeraeteEnum";
import { ILaufliste } from "src/app/core/model/ILaufliste";
import { IUser } from "src/app/core/model/IUser";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingUserService } from "src/app/core/service/caching-services/caching.user.service";

@Component({
  selector: "app-erfassen-header",
  templateUrl: "./erfassen-header.component.html",
  styleUrls: ["./erfassen-header.component.css"],
})
export class ErfassenHeaderComponent implements OnInit {
  @Input()
  laufliste: ILaufliste;

  currentUser: IUser;

  constructor(private authService: AuthService) {}

  ngOnInit() {
    this.currentUser = this.authService.currentUser;
  }

}
