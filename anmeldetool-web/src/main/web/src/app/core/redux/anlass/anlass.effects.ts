import { Injectable } from "@angular/core";
import { Actions, createEffect, ofType } from "@ngrx/effects";
import { Store } from "@ngrx/store";
import { catchError, exhaustMap, filter, map, of, withLatestFrom } from "rxjs";
import { IAnlass } from "../../model/IAnlass";
import { AnlassService } from "../../service/anlass/anlass.service";
import { AnlassActions } from "./anlass.actions";
import { selectLoadStatus } from "./anlass.selector";

@Injectable()
export class AnlassEffects {
  constructor(
    private actions$: Actions,
    private anlassService: AnlassService,
    private store: Store
  ) {}

  // @Effect()
  loadAnlaesse$ = createEffect(() =>
    this.actions$.pipe(
      ofType(AnlassActions.loadAllAnlaesse),
      withLatestFrom(this.store.select(selectLoadStatus)),
      filter(([_, loadStatus]) => loadStatus === "NOT_LOADED"),
      exhaustMap(() =>
        this.anlassService.getAnlaesse().pipe(
          map((anlaesse: ReadonlyArray<IAnlass>) =>
            AnlassActions.loadAllAnlaesseSuccess({ payload: anlaesse })
          ),
          catchError((error) =>
            of(AnlassActions.loadAllAnlaesseError({ error: error }))
          )
        )
      )
    )
  );
}
/*
        ,
  catchError((error) =>
      of(AnlassActions.loadAllAnlaesseFailed({ error: error }))
  )
    */
/*
  fetchMenus$ = createEffect(() =>
    this.actions$.pipe(
      // you can pass in multiple actions here that will trigger the same effect
      ofType(MenusActions.appLoaded.type, MenusActions.addMenuItemSuccess),
      switchMap(() =>
        this.apiService.getItems().pipe(
          map((menuItems) =>
            MenusActions.fetchMenuSuccess({ menuItems: menuItems })
          ),
          catchError((error) =>
            of(MenusActions.fetchMenuFailed({ error: error }))
          )
        )
      )
    )
  );
}
*/
