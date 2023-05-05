import { APP_INITIALIZER, LOCALE_ID, NgModule } from "@angular/core";
import localeDeCH from "@angular/common/locales/de-CH";
import localeDe from "@angular/common/locales/de";

import { AnmeldeToolComponent } from "./core/component/app/app.component";
import { AppRoutingModule } from "./app-routing.module";
import { Page404Component } from "./error/page404/page404.component";

import {
  CreateEventComponent,
  EventListComponent,
  EventRegisterSummaryComponent,
  EventsDatesComponent,
  EventsDetailComponent,
  EventStartListComponent,
  EventStartListHeaderComponent,
  EventStartListRowComponent,
  EventThumbnailComponent,
  WertungsrichterChipComponent,
  WertungsrichterSlotComponent,
} from "./events/index";
// import { NavBarComponent } from "./nav/nav-bar/nav-bar.component";
import { CoreModule } from "./core/core.module";
// import { BrowserModule } from "@angular/platform-browser";
import { DatePipe, registerLocaleData } from "@angular/common";
import { Store, StoreModule } from "@ngrx/store";
import { AppState, metaReducers, reducers } from "./core/redux/core.state";
import { AnlassActions, AnlassEffects } from "./core/redux/anlass";
import { CachingVereinService } from "./core/service/caching-services/caching.verein.service";
import { tap } from "rxjs";
import { HTTP_INTERCEPTORS, HttpClient } from "@angular/common/http";
import { MAT_FORM_FIELD_DEFAULT_OPTIONS } from "@angular/material/form-field";
import { HttpSecurityInterceptorService } from "./core/interceptor/http.security.interceptor.service";
import { EffectsModule } from "@ngrx/effects";
import { BusyIndicatorProgressBarEffects } from "./core/component/busy-indicator-progress-bar/store/busy-indicator-progress-bar.effects";
import { StoreRouterConnectingModule } from "@ngrx/router-store";
import { StoreDevtoolsModule } from "@ngrx/store-devtools";
import { environment } from "src/environments/environment";
import { CustomSerializer } from "./core/redux/router/custom-serializer";

@NgModule({
  declarations: [
    // Page404Component,
    // EventListComponent,
    // WertungsrichterChipComponent,
    // WertungsrichterSlotComponent,
    // EventThumbnailComponent,
    // EventsDatesComponent,
    // EventsDetailComponent,
    // CreateEventComponent,
    // EventRegisterSummaryComponent,
    // EventStartListComponent,
    // EventStartListRowComponent,
    // EventStartListHeaderComponent,
  ],
  imports: [AppRoutingModule, CoreModule],
  bootstrap: [AnmeldeToolComponent],
})
export class AppModule {}
