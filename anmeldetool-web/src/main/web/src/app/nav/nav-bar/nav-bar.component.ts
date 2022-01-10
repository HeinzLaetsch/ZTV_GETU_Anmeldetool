import { Component, OnInit } from "@angular/core";
import { Router } from "@angular/router";
import { Observable } from "rxjs";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { CachingTeilnehmerService } from "src/app/core/service/caching-services/caching.teilnehmer.service";
import { CachingUserService } from "src/app/core/service/caching-services/caching.user.service";
import { CachingVereinService } from "src/app/core/service/caching-services/caching.verein.service";
import { IEvent } from "src/app/events";
import { IVerein } from "src/app/verein/verein";

@Component({
  selector: "app-nav-bar",
  templateUrl: "./nav-bar.component.html",
  styleUrls: ["./nav-bar.component.css"],
})
export class NavBarComponent implements OnInit {
  public _events: Observable<IEvent[]>;

  constructor(
    private router: Router,
    public authService: AuthService,
    public vereinService: CachingVereinService,
    private userService: CachingUserService,
    private anlassService: CachingAnlassService,
    private teilnehmerService: CachingTeilnehmerService
  ) {}

  ngOnInit() {}

  getVereine(): IVerein[] {
    return this.vereinService.getVereine();
  }

  setVerein(verein: IVerein) {
    const oldSelectedVerein = this.authService.currentVerein;
    this.authService.selectVerein(verein);
    this.userService.reset();
    this.anlassService.reset();
    this.teilnehmerService.reset(oldSelectedVerein);
    this.teilnehmerService.loadTeilnehmer(verein);
    this.router.navigate(["/"]);
  }
}
