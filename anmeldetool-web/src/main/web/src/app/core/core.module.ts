import { DatePipe, registerLocaleData } from "@angular/common";
import {
  HTTP_INTERCEPTORS,
  HttpClient,
  HttpClientModule,
} from "@angular/common/http";
import { BrowserAnimationsModule } from "@angular/platform-browser/animations";
import { APP_INITIALIZER, LOCALE_ID, NgModule } from "@angular/core";
import localeDeCH from "@angular/common/locales/de-CH";
import localeDe from "@angular/common/locales/de";

import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { RouterModule } from "@angular/router";
import { EffectsModule } from "@ngrx/effects";
import { StoreRouterConnectingModule } from "@ngrx/router-store";
import { Store, StoreModule } from "@ngrx/store";
import { StoreDevtoolsModule } from "@ngrx/store-devtools";
import { tap } from "rxjs";
import { environment } from "src/environments/environment";
import { MaterialModule } from "../shared/material-module";
import { BusyIndicatorProgressBarComponent } from "./component/busy-indicator-progress-bar/busy-indicator-progress-bar.component";
import { NavComponent } from "./component/nav/nav.component";
import { HttpSecurityInterceptorService } from "./interceptor/http.security.interceptor.service";
import { AnlassActions, AnlassEffects } from "./redux/anlass";
import { reducers, metaReducers, AppState } from "./redux/core.state";
import { CustomSerializer } from "./redux/router/custom-serializer";
import { CachingVereinService } from "./service/caching-services/caching.verein.service";
import { ServiceModule } from "./service/service.module";
import { AnmeldeToolComponent } from "./component/app/app.component";
import { LoginDialogComponent } from "./component/login/login-dialog.component";
import { NewVereinComponent } from "./component/new-verein/new-verein.component";
import { NewAnmelderComponent } from "./component/new-anmelder/new-anmelder.component";
import { SharedComponentsModule } from "../shared/component/shared.components.module";
import { HeaderComponent } from "./component/header/header.component";
import { BusyIndicatorProgressBarEffects } from "./component/busy-indicator-progress-bar/store/busy-indicator-progress-bar.effects";
import { BrowserModule } from "@angular/platform-browser";
import { MAT_FORM_FIELD_DEFAULT_OPTIONS } from "@angular/material/form-field";
import { Page404Component } from "../error/page404/page404.component";
import { VereinActions, VereinEffects } from "./redux/verein";
import { OalEffects } from "./redux/organisation-anlass";
import { UserEffects } from "./redux/user";
import { AnlassSummaryEffects } from "./redux/anlass-summary";

export function initVereinservice(
  vereinService: CachingVereinService
): Function {
  return () =>
    vereinService.loadVereine().pipe(
      tap((value) => {
        console.log("Vereinservice loaded, ", value);
      })
    );
}

/*
const localeText = useMemo(() => {
    return AG_GRID_LOCALE_DE;
}, []);
*/

registerLocaleData(localeDeCH, "de-ch");
registerLocaleData(localeDe, "de");

@NgModule({
  declarations: [
    AnmeldeToolComponent,
    Page404Component,
    BusyIndicatorProgressBarComponent,
    HeaderComponent,
    NavComponent,
    LoginDialogComponent,
    NewVereinComponent,
    NewAnmelderComponent,
  ],
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

    StoreModule.forRoot(reducers, { metaReducers }),

    EffectsModule.forRoot([
      BusyIndicatorProgressBarEffects,
      AnlassEffects,
      VereinEffects,
      OalEffects,
      UserEffects,
      AnlassSummaryEffects,
    ]),

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
      useFactory: (store: Store<AppState>) => {
        return () => {
          store.dispatch(AnlassActions.loadAllAnlaesseInvoked());
        };
      },
      deps: [Store],
      multi: true,
    },
    {
      provide: APP_INITIALIZER,
      useFactory: (store: Store<AppState>) => {
        return () => {
          store.dispatch(VereinActions.loadAllVereineInvoked());
        };
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
      useValue: { floatLabel: "always" },
    },
    {
      provide: HTTP_INTERCEPTORS,
      useClass: HttpSecurityInterceptorService,
      multi: true,
    },
    {
      provide: LOCALE_ID,
      useValue: "de",
    },
    {
      provide: Window,
      useValue: window,
    },
  ],
})
export class CoreModule {}
