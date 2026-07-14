import { Component } from '@angular/core';
import { AnmeldeToolComponent } from './app.component';
import { LoginComponent } from '../login/login-dialog.component';
import { AuthService } from '../../service/auth/auth.service';
import { BusyIndicatorProgressBarComponent } from "../busy-indicator-progress-bar/busy-indicator-progress-bar.component";
import { NavComponent } from "../nav/nav.component";

@Component({
  selector: 'ztv-app-root',
  standalone: true,
  imports: [LoginComponent, AnmeldeToolComponent, BusyIndicatorProgressBarComponent, NavComponent],
  template: `
    <main>
      <ztv-navigation></ztv-navigation>
      <ztv-busy-indicator-progress-bar></ztv-busy-indicator-progress-bar>
      @if (authService.isLoggedIn()) {
        <ztv-anmelde-tool>loading... App</ztv-anmelde-tool>
      } @else {
        <ztv-login-dialog />
      }
    </main>
  `,
})
export class AnmeldeToolRootComponent {
  constructor(public authService: AuthService) {}
}
