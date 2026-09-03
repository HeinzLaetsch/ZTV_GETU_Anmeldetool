import { inject, Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, CanActivateFn, Router } from '@angular/router';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { CachingAnlassService } from 'src/app/core/service/caching-services/caching.anlass.service';

export const eventCanActivate: CanActivateFn = (route: ActivatedRouteSnapshot) => {
  const anlassService = inject(CachingAnlassService);
  const router = inject(Router);
  const authService = inject(AuthService);

  console.log(anlassService.getAnlassById(route.params.id));
  const eventExists = true;

  let isAllowed = authService.isAdministratorSig();
  const roles = route.data.roles as string[] | undefined;
  if (Array.isArray(roles) && roles.length > 0) {
    roles.forEach((element: string) => {
      if (authService.hasRole(element)) {
        isAllowed = true;
      }
    });
  } else {
    isAllowed = authService.isAdministratorSig() || authService.isVereinsAnmmelderSig();
  }

  if (!eventExists || !isAllowed) {
    router.navigate(['/page404']);
    return false;
  }

  return true;
};

@Injectable({
  providedIn: 'root',
})
export class EventRouteActivatorService {
  constructor(
    private anlassService: CachingAnlassService,
    private router: Router,
    private authService: AuthService,
  ) {}

  canActivate(route: ActivatedRouteSnapshot): boolean {
    console.log(this.anlassService.getAnlassById(route.params.id));
    const eventExists = true;

    let isAllowed = this.authService.isAdministratorSig();
    const roles = route.data.roles as string[] | undefined;
    if (Array.isArray(roles) && roles.length > 0) {
      roles.forEach((element: string) => {
        if (this.authService.hasRole(element)) {
          isAllowed = true;
        }
      });
    } else {
      isAllowed = this.authService.isAdministratorSig() || this.authService.isVereinsAnmmelderSig();
    }

    if (!eventExists || !isAllowed) {
      this.router.navigate(['/page404']);
      return false;
    }

    return true;
  }
}
