import { Injectable } from "@angular/core";
import { Actions, createEffect, Effect, ofType } from "@ngrx/effects";
import { Store } from "@ngrx/store";
import {
  catchError,
  exhaustMap,
  filter,
  map,
  of,
  switchMap,
  withLatestFrom,
} from "rxjs";
import { IOrganisationAnlassLink } from "../../model/IOrganisationAnlassLink";
import { AnlassService } from "../../service/anlass/anlass.service";
import { VereinService } from "../../service/verein/verein.service";
import {
  ActionTypes,
  loadAllOalSuccess,
  updateVereinsStart,
  updateVereinsStartFailed,
  updateVereinsStartSuccess,
} from "./oal.actions";
import { selectLoadStatus } from "./oal.selectors";

@Injectable()
export class OalEffects {
  constructor(
    private actions$: Actions<any>,
    private vereinsrv: VereinService,
    private anlasssrv: AnlassService,
    private store: Store
  ) {}

  // @Effect()
  loadAllOal$ = createEffect(() =>
    this.actions$.pipe(
      ofType(ActionTypes.LoadAllOal, ActionTypes.UpdateVereinsStartSuccess),
      withLatestFrom(this.store.select(selectLoadStatus)),
      filter(([_, loadStatus]) => loadStatus !== "LOADED"),
      exhaustMap(() =>
        this.vereinsrv
          .getStarts()
          .pipe(
            map((oal: ReadonlyArray<IOrganisationAnlassLink>) =>
              loadAllOalSuccess({ payload: oal })
            )
          )
      )
    )
  );

  updateOal$ = createEffect(() =>
    this.actions$.pipe(
      ofType(ActionTypes.UpdateVereinsStart),
      switchMap((action) =>
        this.anlasssrv.updateVereinsStart(action.payload).pipe(
          map(() => updateVereinsStartSuccess()),
          catchError((error) => of(updateVereinsStartFailed({ error: error })))
        )
      )
    )
  );
}
