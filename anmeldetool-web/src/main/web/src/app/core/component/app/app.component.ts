import { Component, type OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { select, Store } from '@ngrx/store';
import { SubscriptionHelper } from 'src/app/utils/subscription-helper';
import type { IAnlass } from '../../model/IAnlass';
import { selectSperrenAnlaesse } from '../../redux/anlass';
import type { AppState } from '../../redux/core.state';
import { AuthService } from '../../service/auth/auth.service';
import { BusyIndicatorProgressBarComponent } from '../busy-indicator-progress-bar/busy-indicator-progress-bar.component';
import { NavComponent } from '../nav/nav.component';
import { NewAnmelderComponent } from '../new-anmelder/new-anmelder.component';
import { NewVereinComponent } from '../new-verein/new-verein.component';

/** @title Main Component */
@Component({
  selector: 'ztv-anmelde-tool',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
  standalone: true,
  imports: [BusyIndicatorProgressBarComponent, NavComponent],
})
export class AnmeldeToolComponent extends SubscriptionHelper implements OnInit {
  localeTextDE = {
    contains: 'Beinhaltet',
  };
  private showPage = 0;
  dialogOpen = false;
  appBlocked = false;
  _authenticated = true;
  private loginDialogScheduled = false;
  anlass: IAnlass | undefined;

  fillerNav = Array.from({ length: 10 }, (_, i) => `Nav Item ${i + 1}`);

  constructor(
    private authService: AuthService,
    private store: Store<AppState>,

    public dialog: MatDialog,
  ) {
    super();
  }

  ngOnInit(): void {
    setTimeout(() => {
      this.registerSubscription(
        this.store.pipe(select(selectSperrenAnlaesse())).subscribe((result) => {
          if (result === undefined) {
            return;
          }

          this.appBlocked = result.length > 0;

          if (this.appBlocked) {
            this.dialogOpen = false;
            return;
          }

          this.openLoginDialogIfNeeded();
        }),
      );

      this.openLoginDialogIfNeeded();
    });
  }

  get administrator(): boolean {
    return this.authService.isAdministrator();
  }

  /*
        width: '500px',
      height: 'auto',

  */

  private openLoginDialogIfNeeded(): void {
    if (this.appBlocked || this.authService.isAuthenticated() || !this._authenticated || this.loginDialogScheduled) {
      return;
    }

    this.loginDialogScheduled = true;
    queueMicrotask(() => {
      this.loginDialogScheduled = false;

      if (!this.appBlocked && !this.authService.isAuthenticated() && this._authenticated) {
        this._authenticated = false;
        this.dialogOpen = true;
        //this.openLoginDialog();
      }
    });
  }

  /** LHH
    openLoginDialog(): void {
    const dialogConfig = new MatDialogConfig();

    dialogConfig.disableClose = true;
    dialogConfig.autoFocus = true;
    dialogConfig.panelClass = 'login-dialog-panel';
    const dialogRef = this.dialog.open(LoginDialogComponent, dialogConfig);
    dialogRef.afterClosed().subscribe((result) => {
      queueMicrotask(() => {
        if (result === 'OK') {
          this.dialogOpen = false;
          this._authenticated = true;
          return;
        }

        if (result === 1) {
          this.openNewVereinDialog();
          return;
        }

        if (result === 2) {
          this.openNewAnmelderDialog();
        }
      });
    });
  }
  */

  openNewVereinDialog(): void {
    const dialogRef1 = this.dialog.open(NewVereinComponent, {
      height: '900px',
      width: '500px',
      disableClose: true,
    });
    dialogRef1.afterClosed().subscribe((result) => {
      queueMicrotask(() => {
        console.log('Dialog 1 Closed', result);
        if (result !== 'OK') {
          //this.openLoginDialog();
          return;
        }

        this.dialogOpen = false;
      });
    });
  }
  openNewAnmelderDialog(): void {
    const dialogRef2 = this.dialog.open(NewAnmelderComponent, {
      height: '770px',
      width: '500px',
      disableClose: true,
    });
    dialogRef2.afterClosed().subscribe((result) => {
      queueMicrotask(() => {
        console.log('Dialog 2 Closed', result);
        //this.openLoginDialog();
      });
    });
  }

  get authenticated(): boolean {
    return this.authService.isAuthenticated();
  }
  onShowPage(showPage: number): void {
    console.log('On ShowPage', showPage);
    this.showPage = showPage;
  }

  isShowLogin(): boolean {
    return this.showPage === 0;
  }
  isShowNewVerein(): boolean {
    return this.showPage === 1;
  }
  isShowNewAnmelder(): boolean {
    return this.showPage === 2;
  }
  getOverlayContentClass(): string {
    if (this.authenticated) {
      return '';
    } else {
      return 'overlay-content-login';
    }
  }
}
