import { DatePipe, registerLocaleData } from '@angular/common';
import { HTTP_INTERCEPTORS, HttpClientModule } from '@angular/common/http';
import localeDe from '@angular/common/locales/de';
import localeDeCH from '@angular/common/locales/de-CH';
import { APP_INITIALIZER, LOCALE_ID, NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MAT_FORM_FIELD_DEFAULT_OPTIONS } from '@angular/material/form-field';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { RouterModule } from '@angular/router';
import { StoreRouterConnectingModule } from '@ngrx/router-store';
import { Store, StoreModule } from '@ngrx/store';
import { StoreDevtoolsModule } from '@ngrx/store-devtools';
import { tap } from 'rxjs';
import { environment } from 'src/environments/environment';
import { SharedComponentsModule } from '../shared/component/shared.components.module';
import { MaterialModule } from '../shared/material-module';
import { HttpSecurityInterceptorService } from './interceptor/http.security.interceptor.service';
import { AnlassActions, AnlassEffects } from './redux/anlass';
import { type AppState, metaReducers, reducers } from './redux/core.state';
import { CustomSerializer } from './redux/router/custom-serializer';
import { VereinActions, VereinEffects } from './redux/verein';
import type { CachingVereinService } from './service/caching-services/caching.verein.service';
import { ServiceModule } from './service/service.module';

export function initVereinservice(vereinService: CachingVereinService): Function {
  return () =>
    vereinService.loadVereine().pipe(
      tap((value) => {
        console.log('Vereinservice loaded, ', value);
      }),
    );
}

/*
const localeText = useMemo(() => {
    return AG_GRID_LOCALE_DE;
}, []);
*/

registerLocaleData(localeDeCH, 'de-ch');
registerLocaleData(localeDe, 'de');

@NgModule({
  declarations: [],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    HttpClientModule,
    FormsModule,
    ReactiveFormsModule,
    RouterModule,
    MaterialModule,

    SharedComponentsModule,
    ServiceModule,

    //LHH brauchts nicht mehr StoreModule.forRoot(reducers, { metaReducers }),

    //LHH brauchts nicht mehr EffectsModule.forRoot([BusyIndicatorProgressBarEffects, AnlassEffects, VereinEffects, OalEffects, UserEffects]),

    StoreRouterConnectingModule.forRoot({
      serializer: CustomSerializer,
    }),
    StoreDevtoolsModule.instrument({
      maxAge: 25,
      logOnly: environment.production,
    }),
  ],
  providers: [
    DatePipe,
    {
      provide: APP_INITIALIZER,
      useFactory: (store: Store<AppState>) => (): void => {
        store.dispatch(AnlassActions.loadAllAnlaesseInvoked());
      },
      deps: [Store],
      multi: true,
    },
    {
      provide: APP_INITIALIZER,
      useFactory: (store: Store<AppState>) => (): void => {
        store.dispatch(VereinActions.loadAllVereineInvoked());
      },
      deps: [Store],
      multi: true,
    },
    /*
    {
      provide: APP_INITIALIZER,
      useFactory: initVereinservice,
      deps: [CachingVereinService, HttpClient],
      multi: true,
    },
    */
    {
      provide: MAT_FORM_FIELD_DEFAULT_OPTIONS,
      useValue: { floatLabel: 'always' },
    },
    {
      provide: HTTP_INTERCEPTORS,
      useClass: HttpSecurityInterceptorService,
      multi: true,
    },
    {
      provide: LOCALE_ID,
      useValue: 'de',
    },
    {
      provide: Window,
      useValue: window,
    },
  ],
})
export class CoreModule {}
