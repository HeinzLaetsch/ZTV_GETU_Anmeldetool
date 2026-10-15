import { inject, Injectable } from '@angular/core';
import { Actions, createEffect } from '@ngrx/effects';
import type { Action } from '@ngrx/store';
import type { Update } from '@ngrx/entity';
import { filter, map } from 'rxjs/operators';
import { LoadingActions } from './busy-indicator-progress-bar.actions';
import type { ILoading } from './busy-indicator-progress-bar.state';

@Injectable({ providedIn: 'root' })
export class BusyIndicatorProgressBarEffects {
  private actions$ = inject(Actions);
  private getErrorMessage(action: Action & { error?: { message?: string } }): string | undefined {
    return action.error?.message;
  }

  loadingProcessRunning$ = createEffect(() => {
    return this.actions$.pipe(
      filter((action) => {
        return action.type.includes('invoked');
      }),
      map((action) => {
        console.log('Action set isLoading : true: ', action.type.substring(0, action.type.indexOf('invoked')));
        return LoadingActions.loadingEventStartet({
          payload: {
            id: action.type.substring(0, action.type.indexOf('invoked')).toLowerCase(),
            creationDate: new Date(),
            finishedDate: new Date(),
            isLoading: true,
            isFinished: false,
            hasError: false,
            message: 'invoked',
          },
        });
      }),
    );
  });

  loadingProcessStopped$ = createEffect(() => {
    return this.actions$.pipe(
      filter((action) => {
        return action.type.includes('success');
      }),
      map((action) => {
        const updatedLoadingState: Update<ILoading> = {
          id: action.type.substring(0, action.type.indexOf('success')).toLowerCase(),
          changes: {
            finishedDate: new Date(),
            isLoading: false,
            isFinished: true,
            hasError: false,
            message: 'success',
          },
        };
        return LoadingActions.loadingEventFinished({
          payload: updatedLoadingState,
        });
      }),
    );
  });

  loadingProcessError$ = createEffect(() => {
    return this.actions$.pipe(
      filter((action) => {
        return action.type.includes('error');
      }),
      map((action: Action & { error?: { message?: string } }) => {
        console.log('Action ', action);
        const updatedLoadingState: Update<ILoading> = {
          id: action.type.substring(0, action.type.indexOf('error')).toLowerCase(),
          changes: {
            finishedDate: new Date(),
            isLoading: false,
            isFinished: false,
            hasError: true,
            message: this.getErrorMessage(action),
          },
        };
        return LoadingActions.loadingEventFinished({
          payload: updatedLoadingState,
        });
      }),
    );
  });
  /*
  loadingProcessProcessed$ = createEffect(() => {
    return this.actions$.pipe(
      filter((action) => {
        return action.type.includes('processed');
      }),
      map((action) => {
        const id = action.type.substring(0, action.type.indexOf('processed')).toLowerCase();
        return LoadingActions.loadingEventProcessed({ payload: id });
      }),
    );
  });
  */
}
