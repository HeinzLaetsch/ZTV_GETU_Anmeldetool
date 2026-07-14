import { inject, isDevMode, provideAppInitializer } from '@angular/core';
import { provideStoreDevtools } from '@ngrx/store-devtools';
import { bootstrapApplication } from '@angular/platform-browser';
import { provideEffects } from '@ngrx/effects';
import { Store } from '@ngrx/store';
import { provideStore } from '@ngrx/store';
import { routingProviders } from './app/app.routing';
import { AnlassActions } from './app/core/redux/anlass';
import { VereinActions } from './app/core/redux/verein';
import { appEffects } from './app/core/redux/app.effects';
import { appReducers } from './app/core/redux/app.reducer';
import { AnmeldeToolRootComponent } from './app/core/component/app/app-root.component';

bootstrapApplication(AnmeldeToolRootComponent, {
  providers: [
    routingProviders,
    provideStore(appReducers),
    provideEffects(...appEffects),
    provideStoreDevtools({
      maxAge: 25,
      logOnly: !isDevMode(),
    }),
    provideAppInitializer(() => {
      const store = inject(Store);

      store.dispatch(AnlassActions.loadAllAnlaesseInvoked());
      store.dispatch(VereinActions.loadAllVereineInvoked());
    }),
  ],
}).catch((e) => console.error(e));
