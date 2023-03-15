import {createFeature, createReducer, on} from '@ngrx/store';
import {LoadingActions} from './busy-indicator-progress-bar.actions';
import {initialState} from './busy-indicator-progress-bar.state';

export const loadingFeature = createFeature({
  name: 'loading',
  reducer: createReducer(
    initialState,
    on(LoadingActions.isLoading, (state, action) => ({
      ...state,
      isLoading: action.isLoading,
    })),
  )
});
