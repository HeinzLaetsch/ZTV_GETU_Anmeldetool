import { APP_INITIALIZER, LOCALE_ID, NgModule } from "@angular/core";

import { AnmeldeToolComponent } from "./core/component/app/app.component";
import { AppRoutingModule } from "./app-routing.module";
<<<<<<< HEAD
=======
import { AnmeldeToolComponent } from "./app.component";
import { HoverOverDirective } from "./core/directive/hover.directive";
import { HttpSecurityInterceptorService } from "./core/interceptor/http.security.interceptor.service";
import { CachingVereinService } from "./core/service/caching-services/caching.verein.service";
import { ServiceModule } from "./core/service/service.module";
import { Page404Component } from "./error/page404/page404.component";
import {
  CreateEventComponent,
  EventAdminComponent,
  EinteilungComponent,
  EinteilungKategorieComponent,
  EventListComponent,
  EventRegisterSummaryComponent,
  EventsDatesComponent,
  EventsDetailComponent,
  EventStartListComponent,
  EventStartListHeaderComponent,
  EventStartListRowComponent,
  EventThumbnailComponent,
  Upload,
  ContestUpload,
  WertungsrichterChipComponent,
  WertungsrichterSlotComponent,
} from "./events/index";
import { MaterialModule } from "./material-module";
import { NavBarComponent } from "./nav/nav-bar/nav-bar.component";
import { SharedComponentsModule } from "./shared/component/shared.components.module";
import { LoginDialogComponent } from "./verein/login/login-dialog.component";
import { NewAnmelderComponent } from "./verein/new-anmelder/new-anmelder.component";
import { NewVereinComponent } from "./verein/new-verein/new-verein.component";
import { CachingAnlassService } from "./core/service/caching-services/caching.anlass.service";
import { EinteilungAbteilungComponent } from "./events/event-admin/einteilung/einteilung-abteilung/einteilung-abteilung.component";
import { EinteilungAnlageComponent } from "./events/event-admin/einteilung/einteilung-anlage/einteilung-anlage.component";
import { EinteilungStartgeraetComponent } from "./events/event-admin/einteilung/einteilung-startgeraet/einteilung-startgeraet.component";
import { SmQualiViewerComponent } from "./smquali/smquali-viewer/smquali-viewer.component";
registerLocaleData(localeDeCH, "de-ch");
registerLocaleData(localeDe, "de");
>>>>>>> d72c740 (changes for SM Quali)

// import { NavBarComponent } from "./nav/nav-bar/nav-bar.component";
import { CoreModule } from "./core/core.module";
// import { BrowserModule } from "@angular/platform-browser";

@NgModule({
<<<<<<< HEAD
  declarations: [],
  imports: [AppRoutingModule, CoreModule],
=======
  declarations: [
    AnmeldeToolComponent,
    Upload,
    ContestUpload,
    EventListComponent,
    WertungsrichterChipComponent,
    WertungsrichterSlotComponent,
    EventThumbnailComponent,
    EventsDatesComponent,
    NavBarComponent,
    EventsDetailComponent,
    CreateEventComponent,
    EventRegisterSummaryComponent,
    EventStartListComponent,
    EventStartListRowComponent,
    EventStartListHeaderComponent,
    EventAdminComponent,
    EinteilungComponent,
    EinteilungKategorieComponent,
    EinteilungAbteilungComponent,
    EinteilungAnlageComponent,
    EinteilungStartgeraetComponent,
    SmQualiViewerComponent,
    Page404Component,
    NewAnmelderComponent,
    NewVereinComponent,
    LoginDialogComponent,
    HoverOverDirective,
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    FormsModule,
    ReactiveFormsModule,
    // NgbModule,
    HttpClientModule,
    AppRoutingModule,
    MaterialModule,
    ServiceModule,
    SharedComponentsModule,
    ToastrModule.forRoot({
      timeOut: 10000,
      positionClass: "toast-center-center",
      preventDuplicates: true,
    }), // ToastrModule added
  ],
  providers: [
    DatePipe,
    {
      provide: APP_INITIALIZER,
      useFactory: initAnlassservice,
      deps: [CachingAnlassService],
      multi: true,
    },
    {
      provide: APP_INITIALIZER,
      useFactory: initVereinservice,
      deps: [CachingVereinService],
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
>>>>>>> d72c740 (changes for SM Quali)
  bootstrap: [AnmeldeToolComponent],
})
export class AppModule {}
