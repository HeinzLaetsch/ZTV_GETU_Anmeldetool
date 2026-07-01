import { APP_INITIALIZER } from '@angular/core';
import { isDevMode } from '@angular/core';
import { provideStoreDevtools } from '@ngrx/store-devtools';
import { bootstrapApplication } from '@angular/platform-browser';
import { provideEffects } from '@ngrx/effects';
import { Store } from '@ngrx/store';
import { provideStore } from '@ngrx/store';
import { routingProviders } from './app/app.routing';
import { AnmeldeToolComponent } from './app/core/component/app/app.component';
import { AnlassActions } from './app/core/redux/anlass';
import { VereinActions } from './app/core/redux/verein';
import { appEffects } from './app/core/redux/app.effects';
import { appReducers } from './app/core/redux/app.reducer';

bootstrapApplication(AnmeldeToolComponent, {
  providers: [
    routingProviders,
    provideStore(appReducers),
    provideEffects(...appEffects),
    provideStoreDevtools({
    maxAge: 25,
    logOnly: !isDevMode()
  }),
    {
      provide: APP_INITIALIZER,
      multi: true,
      deps: [Store],
      useFactory: (store: Store) => () => {
        store.dispatch(AnlassActions.loadAllAnlaesseInvoked());
        store.dispatch(VereinActions.loadAllVereineInvoked());
      },
    },
  ],
}).catch((e) => console.error(e));
