import { inject, Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../service/auth/auth.service';

export const authCanActivate: CanActivateFn = (route: ActivatedRouteSnapshot) => {
  const authService = inject(AuthService);
  const router = inject(Router);

  if (authService.isAdministratorSig()) {
    return true;
  }

  const isAuthenticated = authService.isAuthenticatedSig();
  let accessAllowed = true;
  const roles = route.data.roles as string[] | undefined;

  if (roles) {
    roles.forEach((roleName: string) => {
      const hasRole = authService.hasRole(roleName);
      accessAllowed = accessAllowed && hasRole;
    });
  }

  if (!isAuthenticated || !accessAllowed) {
    router.navigate(['/']);
    return false;
  }

  return true;
};

@Injectable({
  providedIn: 'root',
})
export class AuthRouteActivatorService {
  constructor(
    public authService: AuthService,
    private router: Router,
  ) {}

  canActivate(route: ActivatedRouteSnapshot): boolean {
    if (this.authService.isAdministratorSig()) {
      return true;
    }

    const isAuthenticated = this.authService.isAuthenticatedSig();
    let accessAllowed = true;
    const roles = route.data.roles as string[] | undefined;

    if (roles) {
      roles.forEach((roleName: string) => {
        const hasRole = this.authService.hasRole(roleName);
        accessAllowed = accessAllowed && hasRole;
      });
    }

    if (!isAuthenticated || !accessAllowed) {
      this.router.navigate(['/']);
      return false;
    }

    return true;
  }
}
