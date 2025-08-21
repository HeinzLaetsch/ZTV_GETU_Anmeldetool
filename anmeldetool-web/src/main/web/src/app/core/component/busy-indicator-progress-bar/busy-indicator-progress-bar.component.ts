import { Component } from "@angular/core";
import { ProgressBarMode } from "@angular/material/progress-bar";
import { select, Store } from "@ngrx/store";
import { Observable } from "rxjs";
import { AppState } from "../../redux/core.state";
import {
  selectErrors,
  selectLoading,
  selectTransactions,
} from "./store/busy-indicator-progress-bar.selectors";
import { MatSnackBar } from "@angular/material/snack-bar";
import { SnackBarComponent } from "./snack-bar/snack-bar.component";
import { ILoading } from "./store/busy-indicator-progress-bar.state";
import { LoadingActions } from "./store/busy-indicator-progress-bar.actions";
import { SubscriptionHelper } from "src/app/utils/subscription-helper";

@Component({
  selector: "app-busy-indicator-progress-bar",
  templateUrl: "./busy-indicator-progress-bar.component.html",
  styleUrls: ["./busy-indicator-progress-bar.component.scss"],
})
export class BusyIndicatorProgressBarComponent extends SubscriptionHelper {
  public mode: ProgressBarMode = "determinate";
  durationInSeconds = 5;

  isLoading$: Observable<any>;
  isTransactions$: Observable<any>;
  isError$: Observable<any>;

  constructor(private store: Store<AppState>, private _snackBar: MatSnackBar) {
    super();
    this.isLoading$ = this.store.pipe(select(selectLoading()));
    this.isTransactions$ = this.store.pipe(select(selectTransactions()));
    this.isError$ = this.store.pipe(select(selectErrors()));
    this.registerSubscription(
      this.isLoading$.subscribe((data) => {
        if (data && data.length > 0) {
          console.log("ProgressBarMode: buffer 1");
          this.mode = "buffer";
        }
      })
    );
    this.registerSubscription(
      this.isTransactions$.subscribe((data) => {
        if (data) {
          if (data.length > 0) {
            let isAllFinished = true;
            data.forEach((item) => {
              if (item.isFinished) {
                this.store.dispatch(
                  LoadingActions.loadingEventProcessed({
                    payload: item.id,
                  })
                );
              } else {
                isAllFinished = false;
              }
            });
            if (isAllFinished) {
              console.log("ProgressBarMode: determinate 2");
              this.mode = "determinate";
            }
          }
        }
      })
    );
    this.registerSubscription(
      this.isError$.subscribe((data) => {
        if (data && data.length > 0) {
          console.log("ProgressBarMode: determinate 3");
          this.mode = "determinate";
          const error = data.find((x) => x.hasError);
          this.openSnackBar(error);
          this.store.dispatch(
            LoadingActions.loadingEventProcessed({
              payload: error.id,
            })
          );
        }
      })
    );
  }
  openSnackBar(data: ILoading) {
    this._snackBar.openFromComponent(SnackBarComponent, {
      duration: this.durationInSeconds * 1000,
      verticalPosition: "top",
      data: data.id + " / " + data.message,
    });
  }
}
