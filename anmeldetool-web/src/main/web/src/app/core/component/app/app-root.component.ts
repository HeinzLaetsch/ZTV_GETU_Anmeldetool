import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { LoginComponent } from '../login/login-dialog.component';
import { AuthService } from '../../service/auth/auth.service';
// eslint-disable-next-line max-len
import { BusyIndicatorProgressBarComponent } from '../busy-indicator-progress-bar/busy-indicator-progress-bar.component';
import { NavComponent } from '../nav/nav.component';

@Component({
  selector: 'lxt-app-root',
  standalone: true,
  imports: [LoginComponent, RouterOutlet, BusyIndicatorProgressBarComponent, NavComponent],
  template: `
    <main>
      <ztv-navigation></ztv-navigation>
      <ztv-busy-indicator-progress-bar></ztv-busy-indicator-progress-bar>
      @if (authService.isLoggedIn()) {
        <router-outlet />
      } @else {
        <ztv-login-dialog />
      }
    </main>
  `,
})
export class AnmeldeToolRootComponent {
  constructor(public authService: AuthService) {}
}
