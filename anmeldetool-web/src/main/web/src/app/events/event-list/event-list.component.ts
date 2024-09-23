import { Component, OnInit } from "@angular/core";
import { select, Store } from "@ngrx/store";
import { Observable, Subscription } from "rxjs";
import { IAnlass } from "src/app/core/model/IAnlass";
import {
  selectAktiveAnlaesse,
  selectAllAnlaesse,
  selectAnlaesse,
} from "src/app/core/redux/anlass";
import { AppState } from "src/app/core/redux/core.state";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { SubscriptionHelper } from "src/app/utils/subscription-helper";

@Component({
  selector: "app-event-list",
  templateUrl: "./event-list.component.html",
  styleUrls: ["./event-list.component.css"],
})
export class EventListComponent extends SubscriptionHelper implements OnInit {
  anlaesse: IAnlass[];
  anlaesse$: Observable<IAnlass[]>;
  loaded = false;
  subscription: Subscription[] = [];

  constructor(
    public authService: AuthService,
    private store: Store<AppState> // private anlassService: CachingAnlassService
  ) {
    super();
    this.anlaesse$ = this.store.pipe(select(selectAktiveAnlaesse()));
  }

  ngOnInit() {
    this.registerSubscription(
      this.anlaesse$.subscribe((data) => {
        this.anlaesse = data;
      })
    );
  }

  get showEvents(): boolean {
    return (
      (this.authService.isAuthenticated() &&
        this.authService.isVereinsAnmmelder() &&
        !this.authService.isAdministrator()) ||
      (this.authService.isAdministrator() &&
        this.authService.currentVerein.name != "ZTV")
    );
  }
  handleEventClicked(data) {
    console.log("received :", data);
  }

  ngOnDestroy(): void {
    this.subscription.forEach((s) => s.unsubscribe());
  }
}
