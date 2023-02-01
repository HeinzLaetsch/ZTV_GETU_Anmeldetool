import { Injectable } from "@angular/core";
import { Actions } from "@ngrx/effects";
import { AnlassService } from "../../service/anlass/anlass.service";
import { AuthService } from "../../service/auth/auth.service";

@Injectable()
export class TeilnehmerEffects {
  constructor(
    private actions$: Actions,
    private authService: AuthService,
    private anlassService: AnlassService
  ) {}

  /*
  @Effect()
  loadTodos$ = this.actions$.pipe(
    ofType(ActionTypes.LoadAllTeilnahmen),
    switchMap((action: AddTeilnahmeAction) =>
      this.anlassService getTeilnehmer(action.payload, this.authService.currentVerein);

      this.teilnehmerService
        .getTeilnehmer(this.authService.currentVerein)
        .pipe(
          map(
            (teilnehmer: ITeilnehmer[]) =>
              new LoadAllTeilnehmerFinishedAction(teilnehmer)
          )
        )
    )
  );
  */
}
