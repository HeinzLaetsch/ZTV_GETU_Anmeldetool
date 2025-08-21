import { Component, OnInit } from "@angular/core";
import { SubscriptionHelper } from "../utils/subscription-helper";
import { IUser } from "../core/model/IUser";
import { IAnlass } from "../core/model/IAnlass";
import { Observable } from "rxjs";
import { AuthService } from "../core/service/auth/auth.service";
import { select, Store } from "@ngrx/store";
import { AppState } from "../core/redux/core.state";
import { ActivatedRoute } from "@angular/router";
import { selectAnlassById } from "../core/redux/anlass";

@Component({
  selector: "app-rechnungsbuero",
  templateUrl: "./rechnungsbuero.component.html",
  styleUrls: ["./rechnungsbuero.component.css"],
})
export class RechnungsbueroComponent
  extends SubscriptionHelper
  implements OnInit
{
  currentUser: IUser;
  anlass: IAnlass;
  anlass$: Observable<IAnlass>;

  constructor(
    private authService: AuthService,
    private store: Store<AppState>,
    private route: ActivatedRoute
  ) {
    super();
  }

  ngOnInit() {
    this.currentUser = this.authService.currentUser;
    const anlassId: string = this.route.snapshot.params.id;
    this.anlass$ = this.store.pipe(select(selectAnlassById(anlassId)));
    this.registerSubscription(
      this.anlass$.subscribe((anlass) => {
        this.anlass = anlass;
      })
    );
  }
}
