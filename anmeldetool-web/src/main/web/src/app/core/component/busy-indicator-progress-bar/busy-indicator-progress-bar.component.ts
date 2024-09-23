import { Component } from "@angular/core";
import { ProgressBarMode } from "@angular/material/progress-bar";
import { select, Store } from "@ngrx/store";
import { Observable } from "rxjs";
import { AppState } from "../../redux/core.state";
import { loadingFeature } from "./store/busy-indicator-progress-bar.reducers";

@Component({
  selector: "app-busy-indicator-progress-bar",
  templateUrl: "./busy-indicator-progress-bar.component.html",
  styleUrls: ["./busy-indicator-progress-bar.component.scss"],
})
export class BusyIndicatorProgressBarComponent {
  public mode: ProgressBarMode = "determinate";

  isLoading$: Observable<any>;

  constructor(private store: Store<AppState>) {
    this.isLoading$ = this.store.pipe(select(loadingFeature.selectIsLoading));
    this.isLoading$.subscribe((data) => {
      if (data) {
        console.log("ProgressBarMode: buffer");
        this.mode = "buffer";
      } else {
        console.log("ProgressBarMode: determinate");
        this.mode = "determinate";
      }
    });
  }
}
