import { Injectable } from "@angular/core";
import { ActivatedRouteSnapshot, Router } from "@angular/router";
import { Store } from "@ngrx/store";
import { AppState } from "src/app/core/redux/core.state";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";

@Injectable({
  providedIn: "root",
})
export class EventRouteActivatorService {
  constructor(
    private anlassService: CachingAnlassService,
    private router: Router,
    private authService: AuthService
  ) {}

  canActivate(route: ActivatedRouteSnapshot) {
    console.log(this.anlassService.getAnlassById(route.params.id));
    let eventExists = true;
    /* Store mit Async nicht sinnvoll
    if (route.params.id) {
      eventExists = !!this.anlassService.getAnlassById(route.params.id);
    }*/
    // Admin darf alles
    let isAllowed = this.authService.isAdministrator();
    if (route.data.roles?.length > 0) {
      route.data.roles.forEach((element) => {
        if (this.authService.hasRole(element)) {
          isAllowed = true;
        }
      });
    } else {
      isAllowed =
        this.authService.isAdministrator() ||
        this.authService.isVereinsAnmmelder();
    }
    if (!eventExists || !isAllowed) {
      this.router.navigate(["/page404"]);
    }
    return true;
  }
}
