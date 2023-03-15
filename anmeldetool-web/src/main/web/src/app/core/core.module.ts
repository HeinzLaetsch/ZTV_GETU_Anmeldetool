import { CommonModule, DatePipe, registerLocaleData } from "@angular/common";
import {
  HttpClient,
  HttpClientModule,
  HTTP_INTERCEPTORS,
} from "@angular/common/http";
import localeDeCH from "@angular/common/locales/de-CH";
import localeDe from "@angular/common/locales/de";
import { APP_INITIALIZER, LOCALE_ID, NgModule } from "@angular/core";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { MAT_FORM_FIELD_DEFAULT_OPTIONS } from "@angular/material/form-field";
import { RouterModule } from "@angular/router";
import { EffectsModule } from "@ngrx/effects";
import { StoreRouterConnectingModule } from "@ngrx/router-store";
import { Store, StoreModule } from "@ngrx/store";
import { StoreDevtoolsModule } from "@ngrx/store-devtools";
import { tap } from "rxjs";
import { environment } from "src/environments/environment";
import { CreateEventComponent } from "../events";
import { MaterialModule } from "../shared/material-module";
import { AnmeldeToolComponent } from "./component/app/app.component";
import { BusyIndicatorProgressBarComponent } from "./component/busy-indicator-progress-bar/busy-indicator-progress-bar.component";
import { NavComponent } from "./component/nav/nav.component";
import { HttpSecurityInterceptorService } from "./interceptor/http.security.interceptor.service";
import { AnlassActions, AnlassEffects } from "./redux/anlass";
import { reducers, metaReducers, AppState } from "./redux/core.state";
import { CustomSerializer } from "./redux/router/custom-serializer";
import { CachingVereinService } from "./service/caching-services/caching.verein.service";
import { ServiceModule } from "./service/service.module";
import { LoginDialogComponent } from "./component/login/login-dialog.component";
import { NewVereinComponent } from "./component/new-verein/new-verein.component";
import { NewAnmelderComponent } from "./component/new-anmelder/new-anmelder.component";
import { SharedComponentsModule } from "../shared/component/shared.components.module";
import { HeaderComponent } from "./component/header/header.component";

registerLocaleData(localeDeCH, "de-ch");
registerLocaleData(localeDe, "de");

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

export function checkDirtyState(component: CreateEventComponent) {
  if (component.isDirty) {
    return window.confirm(
      "Anlass nicht gespeichert, wollen Sie wirklich abbrechen"
    );
  }
  return true;
}

@NgModule({
  declarations: [
    AnmeldeToolComponent,
    BusyIndicatorProgressBarComponent,
    HeaderComponent,
    NavComponent,
    LoginDialogComponent,
    NewVereinComponent,
    NewAnmelderComponent,
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    RouterModule,
    MaterialModule,
    SharedComponentsModule,
    ServiceModule,
    StoreModule.forRoot(reducers, { metaReducers }),
    EffectsModule.forRoot([AnlassEffects]),
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
          store.dispatch(AnlassActions.loadAllAnlaesse());
        };
      },
      deps: [Store],
      multi: true,
    },
    {
      provide: APP_INITIALIZER,
      useFactory: initVereinservice,
      deps: [CachingVereinService, HttpClient],
      multi: true,
    },
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
