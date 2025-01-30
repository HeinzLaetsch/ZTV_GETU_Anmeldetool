import { APP_INITIALIZER, LOCALE_ID, NgModule } from "@angular/core";

import { AnmeldeToolComponent } from "./core/component/app/app.component";
import { AppRoutingModule } from "./app-routing.module";

// import { NavBarComponent } from "./nav/nav-bar/nav-bar.component";
import { CoreModule } from "./core/core.module";
// import { BrowserModule } from "@angular/platform-browser";

@NgModule({
  declarations: [],
  imports: [AppRoutingModule, CoreModule],
  bootstrap: [AnmeldeToolComponent],
})
export class AppModule {}
