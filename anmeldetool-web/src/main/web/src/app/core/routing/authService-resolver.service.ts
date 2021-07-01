import { Injectable } from '@angular/core';
import { Resolve } from '@angular/router';
import { map } from 'rxjs/operators';
import { AuthService } from '../service/auth/auth.service';

@Injectable({
  providedIn: 'root'
})
export class AuthServiceResolverService implements Resolve<any>{

  constructor(public authService: AuthService) { }

  resolve() {
    console.log('resolve Auth');
    return this.authService.isAuthenticated();
  }
}
