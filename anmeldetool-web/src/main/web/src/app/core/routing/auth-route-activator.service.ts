import { Injectable } from "@angular/core";
import { ActivatedRouteSnapshot, Router } from "@angular/router";
import { AuthService } from "../service/auth/auth.service";

@Injectable({
  providedIn: "root",
})
export class AuthRouteActivatorService {
  constructor(public authService: AuthService, private router: Router) {}

  canActivate(route: ActivatedRouteSnapshot) {
    console.log("check Auth");
    const isAuthenticated = this.authService.isAuthenticated();
    console.log("canActivate ", isAuthenticated);
    if (!isAuthenticated) {
      this.router.navigate(["/"]);
    }
    return isAuthenticated;
  }
}
