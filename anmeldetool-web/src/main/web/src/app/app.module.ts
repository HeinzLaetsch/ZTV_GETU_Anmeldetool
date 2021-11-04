import { HttpClientModule, HTTP_INTERCEPTORS } from "@angular/common/http";
import { APP_INITIALIZER, NgModule } from "@angular/core";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { MAT_FORM_FIELD_DEFAULT_OPTIONS } from "@angular/material/form-field";
import { BrowserModule } from "@angular/platform-browser";
import { BrowserAnimationsModule } from "@angular/platform-browser/animations";
import { NgbModule } from "@ng-bootstrap/ng-bootstrap";
import { tap } from "rxjs/operators";
import { AppRoutingModule } from "./app-routing.module";
import { AnmeldeToolComponent } from "./app.component";
import { HttpSecurityInterceptorService } from "./core/interceptor/http.security.interceptor.service";
import { CachingVereinService } from "./core/service/caching-services/caching.verein.service";
import { ServiceModule } from "./core/service/service.module";
import { Page404Component } from "./error/page404/page404.component";
import {
  CreateEventComponent,
  EventListComponent,
  EventsDetailComponent,
  EventThumbnailComponent,
  WertungsrichterChipComponent,
} from "./events/index";
import { MaterialModule } from "./material-module";
import { NavBarComponent } from "./nav/nav-bar/nav-bar.component";
import { SharedComponentsModule } from "./shared/component/shared.components.module";
import { LoginDialogComponent } from "./verein/login/login-dialog.component";
import { NewAnmelderComponent } from "./verein/new-anmelder/new-anmelder.component";
import { NewVereinComponent } from "./verein/new-verein/new-verein.component";

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
    EventThumbnailComponent,
    NavBarComponent,
    EventsDetailComponent,
    CreateEventComponent,
    Page404Component,
    NewAnmelderComponent,
    NewVereinComponent,
    LoginDialogComponent,
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
  ],
  providers: [
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
