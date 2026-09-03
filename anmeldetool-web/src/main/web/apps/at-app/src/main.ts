import { HTTP_INTERCEPTORS, provideHttpClient, withInterceptorsFromDi } from '@angular/common/http';
import { registerLocaleData } from '@angular/common';
import localeDeCH from '@angular/common/locales/de-CH';
import { inject, isDevMode, LOCALE_ID, provideAppInitializer } from '@angular/core';
import { provideStoreDevtools } from '@ngrx/store-devtools';
import { bootstrapApplication } from '@angular/platform-browser';
import { provideEffects } from '@ngrx/effects';
import { Store } from '@ngrx/store';
import { provideStore } from '@ngrx/store';
import { routingProviders } from './app/app.routing';
import { AnlassActions } from './app/core/redux/anlass';
import { HttpSecurityInterceptorService } from './app/core/interceptor/http.security.interceptor.service';
import { VereinActions } from './app/core/redux/verein';
import { appEffects } from './app/core/redux/app.effects';
import { appReducers } from './app/core/redux/app.reducer';
import { AnmeldeToolRootComponent } from './app/core/component/app/app-root.component';

registerLocaleData(localeDeCH, 'de-CH');
registerLocaleData(localeDeCH, 'DE-CH');

bootstrapApplication(AnmeldeToolRootComponent, {
  providers: [
    routingProviders,
    provideHttpClient(withInterceptorsFromDi()),
    {
      provide: HTTP_INTERCEPTORS,
      useClass: HttpSecurityInterceptorService,
      multi: true,
    },
    {
      provide: LOCALE_ID,
      useValue: 'de-CH',
    },
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
