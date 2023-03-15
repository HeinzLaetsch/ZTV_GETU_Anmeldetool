import { NgModule } from "@angular/core";
import { NgbModule } from "@ng-bootstrap/ng-bootstrap";
import { ToastrModule } from "ngx-toastr";
import { AppRoutingModule } from "./app-routing.module";
import { ServiceModule } from "./core/service/service.module";
import { Page404Component } from "./error/page404/page404.component";
import { NavBarComponent } from "./nav/nav-bar/nav-bar.component";
import { SharedComponentsModule } from "./shared/component/shared.components.module";
import { AnmeldeToolComponent } from "./core/component/app/app.component";
import { CoreModule } from "./core/core.module";
import { EventsModule } from "./events/events.module";
import { CommonModule } from "@angular/common";
import { BrowserModule } from "@angular/platform-browser";
import { BrowserAnimationsModule } from "@angular/platform-browser/animations";

@NgModule({
  declarations: [NavBarComponent, Page404Component],
  imports: [
    CommonModule,
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    CoreModule,
    // EventsModule, // Brauchts den hier ?
    // NgbModule,
    // ServiceModule,
    // SharedComponentsModule,
    /*
    ToastrModule.forRoot({
      timeOut: 10000,
      positionClass: "toast-center-center",
      preventDuplicates: true,
    }), // ToastrModule added
    */
  ],
  providers: [],
  bootstrap: [AnmeldeToolComponent],
})
export class AppModule {}
