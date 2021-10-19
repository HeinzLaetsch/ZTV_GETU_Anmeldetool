import { BrowserModule } from "@angular/platform-browser";
import { NgModule } from "@angular/core";
import { BrowserAnimationsModule } from "@angular/platform-browser/animations";

import { NgbModule } from "@ng-bootstrap/ng-bootstrap";

import { AppRoutingModule } from "./app-routing.module";

import { AnmeldeToolComponent } from "./app.component";

import {
  EventListComponent,
  EventThumbnailComponent,
  EventsDetailComponent,
  CreateEventComponent,
} from "./events/index";

import { NavBarComponent } from "./nav/nav-bar/nav-bar.component";
import { Page404Component } from "./error/page404/page404.component";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { ServiceModule } from "./core/service/service.module";
import { HttpClientModule, HTTP_INTERCEPTORS } from "@angular/common/http";
import { NewAnmelderComponent } from "./verein/new-anmelder/new-anmelder.component";
import { NewVereinComponent } from "./verein/new-verein/new-verein.component";
import { MaterialModule } from "./material-module";
import { LoginDialogComponent } from "./verein/login/login-dialog.component";
import { MAT_FORM_FIELD_DEFAULT_OPTIONS } from "@angular/material/form-field";
import { HttpSecurityInterceptorService } from "./core/interceptor/http.security.interceptor.service";
import { SharedComponentsModule } from "./shared/component/shared.components.module";

@NgModule({
  declarations: [
    AnmeldeToolComponent,
    EventListComponent,
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
    //EventRouteActivatorService,
    /*{
      provide: 'canDeactivateCreateEvent', useValue: checkDirtyState Ist zum verhindern, dass ein Dialog mit geänderten Daten ohne speichern verlassen wird
    },
    */
    //EventListResolverService, Wartet bis Eventliste bereitsteht
    /*
  {
    provide: APP_INITIALIZER,
    useFactory: initializeKeycloak,
    multi: true,
    deps: [KeycloakService],
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
