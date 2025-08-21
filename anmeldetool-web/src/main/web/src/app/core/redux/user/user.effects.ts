import { Injectable } from "@angular/core";
import { Actions, createEffect, ofType } from "@ngrx/effects";
import { catchError, mergeMap, of, switchMap } from "rxjs";
import { UserActions } from "./user.actions";
import { UserService } from "../../service/user/user.service";
import { AuthService } from "../../service/auth/auth.service";

@Injectable()
export class UserEffects {
  constructor(
    private actions$: Actions,
    private userService: UserService,
    private authService: AuthService
  ) {}

  loadUser$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(UserActions.loadAllUserInvoked),
      mergeMap((action) => {
        return this.userService.getUser().pipe(
          switchMap((user) => [
            UserActions.loadAllUserSuccess({ payload: user }),
          ]),
          catchError((error) => {
            return of(UserActions.loadAllUserError({ error: error }));
          })
        );
      })
    );
  });
  saveUser$ = createEffect(() => {
    return this.actions$.pipe(
      ofType(UserActions.saveUserInvoked),
      mergeMap((action) => {
        return this.authService.createUser(action.payload).pipe(
          switchMap((user) => [
            UserActions.saveUserSuccess({
              payload: user,
            }),
          ]),
          catchError((error) => {
            return of(UserActions.saveUserError({ error: error }));
          })
        );
      })
    );
  });
}
