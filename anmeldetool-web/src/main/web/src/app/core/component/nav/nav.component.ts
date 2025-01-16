import { Component, OnInit } from "@angular/core";
import { AuthService } from "../../service/auth/auth.service";
import { AppState } from "../../redux/core.state";
import { Store, select } from "@ngrx/store";
import { SubscriptionHelper } from "src/app/utils/subscription-helper";
import { IAnlass } from "../../model/IAnlass";
import { Observable } from "rxjs";
import {
  selectAktiveAnlaesse,
  selectAllAnlaesse,
  selectAnlaesse,
  selectAnlaesseSortedNew,
} from "../../redux/anlass";
import {
  selectAlleVereine,
  selectVereinById,
  selectVereineSorted,
} from "../../redux/verein";
import { IVerein } from "src/app/verein/verein";
import { Router } from "@angular/router";

@Component({
  selector: "app-nav",
  templateUrl: "./nav.component.html",
  styleUrls: ["./nav.component.scss"],
})
export class NavComponent extends SubscriptionHelper implements OnInit {
  anlaesse: IAnlass[];
  public anlaesse$!: Observable<IAnlass[]>;

  vereine: IVerein[];
  public vereine$!: Observable<IVerein[]>;

  organisator: IVerein;

  constructor(
    public authService: AuthService,
    private store: Store<AppState>,
    private router: Router
  ) {
    super();
    this.anlaesse$ = this.store.pipe(select(selectAnlaesseSortedNew()));
    this.vereine$ = this.store.pipe(select(selectVereineSorted()));
    this.router.routeReuseStrategy.shouldReuseRoute = function () {
      return false;
    };
  }

  ngOnInit() {
    this.registerSubscription(
      this.anlaesse$.subscribe((data) => {
        this.anlaesse = data;
      })
    );
    this.registerSubscription(
      this.vereine$.subscribe((data) => {
        this.vereine = data;
      })
    );
  }

  getOrganisator(anlass: IAnlass): Observable<IVerein> {
    return this.store.pipe(select(selectVereinById(anlass.organisatorId)));
  }

  setVerein(verein: IVerein) {
    const oldSelectedVerein = this.authService.currentVerein;
    this.authService.selectVerein(verein);
    // this.userService.reset();
    // this.anlassService.reset();
    // this.teilnehmerService.reset(oldSelectedVerein, false);
    // this.teilnehmerService.loadTeilnehmer(verein);
    this.router.navigate(["/"]);
  }
}
