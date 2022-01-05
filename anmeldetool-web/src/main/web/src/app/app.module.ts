import { DatePipe, registerLocaleData } from "@angular/common";
import { HttpClientModule, HTTP_INTERCEPTORS } from "@angular/common/http";
import localeDeCH from "@angular/common/locales/de-CH";
import { APP_INITIALIZER, LOCALE_ID, NgModule } from "@angular/core";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { MAT_FORM_FIELD_DEFAULT_OPTIONS } from "@angular/material/form-field";
import { BrowserModule } from "@angular/platform-browser";
import { BrowserAnimationsModule } from "@angular/platform-browser/animations";
import { NgbModule } from "@ng-bootstrap/ng-bootstrap";
import { ToastrModule } from "ngx-toastr";
import { tap } from "rxjs/operators";
import { AppRoutingModule } from "./app-routing.module";
import { AnmeldeToolComponent } from "./app.component";
import { HoverOverDirective } from "./core/directive/hover.directive";
import { HttpSecurityInterceptorService } from "./core/interceptor/http.security.interceptor.service";
import { CachingVereinService } from "./core/service/caching-services/caching.verein.service";
import { ServiceModule } from "./core/service/service.module";
import { Page404Component } from "./error/page404/page404.component";
import {
  CreateEventComponent,
  EventListComponent,
  EventsDatesComponent,
  EventsDetailComponent,
  EventThumbnailComponent,
  WertungsrichterChipComponent,
  WertungsrichterSlotComponent,
} from "./events/index";
import { MaterialModule } from "./material-module";
import { NavBarComponent } from "./nav/nav-bar/nav-bar.component";
import { SharedComponentsModule } from "./shared/component/shared.components.module";
import { LoginDialogComponent } from "./verein/login/login-dialog.component";
import { NewAnmelderComponent } from "./verein/new-anmelder/new-anmelder.component";
import { NewVereinComponent } from "./verein/new-verein/new-verein.component";
registerLocaleData(localeDeCH, "de-ch");

export function initVereinservice(
  vereinService: CachingVereinService
): Function {
  return () =>
    vereinService
      .loadVereine()
      .pipe(tap((value) => console.log("Vereinservice loaded, ", value)));
}

@NgModule({
  declarations: [
    AnmeldeToolComponent,
    EventListComponent,
    WertungsrichterChipComponent,
    WertungsrichterSlotComponent,
    EventThumbnailComponent,
    EventsDatesComponent,
    NavBarComponent,
    EventsDetailComponent,
    CreateEventComponent,
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
    NgbModule,
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
  ],
  bootstrap: [AnmeldeToolComponent],
})
export class AppModule {}

export function checkDirtyState(component: CreateEventComponent) {
  if (component.isDirty) {
    return window.confirm(
      "Anlass nicht gespeichert, wollen Sie wirklich abbrechen"
    );
  }
  return true;
}
