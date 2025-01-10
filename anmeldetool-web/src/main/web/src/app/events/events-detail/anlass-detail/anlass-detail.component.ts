import { Component, Input, OnInit } from "@angular/core";
import { select, Store } from "@ngrx/store";
import { IAnlass } from "src/app/core/model/IAnlass";
import { AppState } from "src/app/core/redux/core.state";
import { selectVereinById } from "src/app/core/redux/verein";
import { SubscriptionHelper } from "src/app/utils/subscription-helper";
import { IVerein } from "src/app/verein/verein";

@Component({
  selector: "app-anlass-detail",
  templateUrl: "./anlass-detail.component.html",
  styleUrls: ["./anlass-detail.component.css"],
})
export class AnlassDetailComponent
  extends SubscriptionHelper
  implements OnInit
{
  @Input()
  anlass: IAnlass;

  organisator: IVerein;

  constructor(private store: Store<AppState>) {
    super();
  }
  ngOnInit() {
    this.registerSubscription(
      this.store
        .pipe(select(selectVereinById(this.anlass.organisatorId)))
        .subscribe((result) => {
          this.organisator = result;
        })
    );
  }
}
