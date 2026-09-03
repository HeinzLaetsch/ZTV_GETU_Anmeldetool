import type { Update } from '@ngrx/entity';
import { createActionGroup, props } from '@ngrx/store';
import type { ILoading } from './busy-indicator-progress-bar.state';

export const LoadingActions = createActionGroup({
  source: 'loading',
  events: {
    'Loading Event Startet': props<{ payload: ILoading }>(),
    'Loading Event finished': props<{ payload: Update<ILoading> }>(),
    'Loading Event fehler': props<{ payload: Update<ILoading> }>(),
    'Loading Event processed': props<{ payload: string }>(),
    'Loading Event stopped': props<{ payload: string }>(),
  },
});
