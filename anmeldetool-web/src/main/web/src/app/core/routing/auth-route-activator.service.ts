import { Injectable } from "@angular/core";
import { ActivatedRouteSnapshot, Router } from "@angular/router";
import { AuthService } from "../service/auth/auth.service";

@Injectable({
  providedIn: "root",
})
export class AuthRouteActivatorService {
  constructor(public authService: AuthService, private router: Router) {}

  canActivate(route: ActivatedRouteSnapshot) {
    if (this.authService.isAdministrator()) {
      return true;
    }
    const isAuthenticated = this.authService.isAuthenticated();
    let accessAllowed = true;
    if (route.data.roles) {
      route.data.roles.forEach((roleName) => {
        const hasRole = this.authService.hasRole(roleName);
        accessAllowed = accessAllowed && hasRole;
      });
    }
    // console.log("canActivate ", isAuthenticated);
    if (!isAuthenticated || !accessAllowed) {
      this.router.navigate(["/"]);
    }
    return isAuthenticated;
  }
}
