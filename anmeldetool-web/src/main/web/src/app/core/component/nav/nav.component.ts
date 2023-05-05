import { Component, OnInit } from "@angular/core";
import { AuthService } from "../../service/auth/auth.service";
import { AppState } from "../../redux/core.state";
import { Store, select } from "@ngrx/store";
import { SubscriptionHelper } from "src/app/utils/subscription-helper";
import { IAnlass } from "../../model/IAnlass";
import { Observable } from "rxjs";
import { selectAllAnlaesse } from "../../redux/anlass";

@Component({
  selector: "app-nav",
  templateUrl: "./nav.component.html",
  styleUrls: ["./nav.component.scss"],
})
export class NavComponent extends SubscriptionHelper implements OnInit {
  anlaesse: IAnlass[];
  public anlaesse$!: Observable<IAnlass[]>;

  constructor(public authService: AuthService, private store: Store<AppState>) {
    super();
    this.anlaesse$ = this.store.pipe(select(selectAllAnlaesse));
  }

  ngOnInit() {
    this.registerSubscription(
      this.anlaesse$.subscribe((data) => {
        this.anlaesse = data;
      })
    );
  }
}
