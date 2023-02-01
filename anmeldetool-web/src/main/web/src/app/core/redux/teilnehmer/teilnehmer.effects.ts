import { Injectable } from "@angular/core";
import { Actions, Effect, ofType } from "@ngrx/effects";
import { map, switchMap } from "rxjs";
import { ITeilnehmer } from "../../model/ITeilnehmer";
import { AuthService } from "../../service/auth/auth.service";
import { TeilnehmerService } from "../../service/teilnehmer/teilnehmer.service";
import {
  ActionTypes,
  AddTeilnehmerAction,
  AddTeilnehmerFinishedAction,
  LoadAllTeilnehmerFinishedAction,
} from "./teilnehmer.actions";

@Injectable()
export class TeilnehmerEffects {
  constructor(
    private actions$: Actions,
    private authService: AuthService,
    private teilnehmerService: TeilnehmerService
  ) {}

  @Effect()
  loadTeilnehmer$ = this.actions$.pipe(
    ofType(ActionTypes.LoadAllTeilnehmer),
    switchMap(() =>
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

  @Effect()
  addTeilnehmer$ = this.actions$.pipe(
    ofType(ActionTypes.AddTeilnehmer),
    switchMap((action: AddTeilnehmerAction) =>
      this.teilnehmerService
        .add(this.authService.currentVerein, action.payload)
        .pipe(
          map(
            (teilnehmer: ITeilnehmer) =>
              new AddTeilnehmerFinishedAction(teilnehmer)
          )
        )
    )
  );
}
