import { Injectable } from "@angular/core";
import { ActivatedRouteSnapshot, Router } from "@angular/router";
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
    // console.log(this.anlassService.getAnlassById(route.params.id));
    const eventExists = !!this.anlassService.getAnlassById(route.params.id);
    // console.log('canActivate ', eventExists);
    const isAllowed =
      this.authService.isAdministrator() ||
      this.authService.isVereinsAnmmelder();
    if (!eventExists || !isAllowed) {
      this.router.navigate(["/page404"]);
    }
    return true;
  }
}
