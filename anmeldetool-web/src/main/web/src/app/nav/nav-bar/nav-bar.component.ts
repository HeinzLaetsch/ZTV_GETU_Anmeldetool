import { Component, OnInit } from "@angular/core";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { Observable } from "rxjs";
import { IEvent } from "src/app/events";
import { CachingVereinService } from "src/app/core/service/caching-services/caching.verein.service";
import { IVerein } from "src/app/verein/verein";
import { CachingUserService } from "src/app/core/service/caching-services/caching.user.service";

@Component({
  selector: "app-nav-bar",
  templateUrl: "./nav-bar.component.html",
  styleUrls: ["./nav-bar.component.css"],
})
export class NavBarComponent implements OnInit {
  public _events: Observable<IEvent[]>;

  constructor(
    public authService: AuthService,
    public vereinService: CachingVereinService,
    private userService: CachingUserService
  ) {}

  ngOnInit() {}

  getVereine(): IVerein[] {
    return this.vereinService.getVereine();
  }

  setVerein(verein: IVerein) {
    this.authService.selectVerein(verein);
    this.userService.reset();
  }
}
