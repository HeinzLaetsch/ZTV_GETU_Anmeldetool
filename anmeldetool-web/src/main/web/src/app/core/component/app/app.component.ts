import { type AfterContentChecked, type AfterViewInit, Component, type OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { select, Store } from '@ngrx/store';
import { SubscriptionHelper } from 'src/app/utils/subscription-helper';
import type { IAnlass } from '../../model/IAnlass';
import { selectSperrenAnlaesse } from '../../redux/anlass';
import type { AppState } from '../../redux/core.state';
import { AuthService } from '../../service/auth/auth.service';
import { BusyIndicatorProgressBarComponent } from '../busy-indicator-progress-bar/busy-indicator-progress-bar.component';
import { LoginDialogComponent } from '../login/login-dialog.component';
import { NavComponent } from '../nav/nav.component';
import { NewAnmelderComponent } from '../new-anmelder/new-anmelder.component';
import { NewVereinComponent } from '../new-verein/new-verein.component';

/** @title Main Component */
@Component({
  selector: 'lxt-anmelde-tool',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
  standalone: true,
  imports: [BusyIndicatorProgressBarComponent, NavComponent],
})
export class AnmeldeToolComponent extends SubscriptionHelper implements OnInit, AfterViewInit, AfterContentChecked {
  localeTextDE = {
    contains: 'Beinhaltet',
  };
  private showPage = 0;
  dialogOpen = false;
  appBlocked = false;
  _authenticated = false;
  anlass: IAnlass | undefined;

  fillerNav = Array.from({ length: 10 }, (_, i) => `Nav Item ${i + 1}`);

  constructor(
    private authService: AuthService,
    private store: Store<AppState>,

    public dialog: MatDialog,
  ) {
    super();
    this.registerSubscription(
      this.store.pipe(select(selectSperrenAnlaesse())).subscribe((result) => {
        if (result === undefined) {
          return;
        }
        if (result.length > 0) {
          this.appBlocked = true;
          this.dialogOpen = false;
        }
        if (!this.appBlocked && !this.authService.isAuthenticated()) {
          this.dialogOpen = true;
          this.openLoginDialog();
        }
      }),
    );
  }

  ngOnInit(): void {}

  ngAfterContentChecked(): void {
    if (!this.appBlocked && !this.authService.isAuthenticated() && this._authenticated) {
      this._authenticated = false;
      console.log('AnmeldeToolComponent::ngAfterContentChecked');
      this.openLoginDialog();
    }
  }

  ngAfterViewInit(): void {
    /*
    if (!this.appBlocked && !this.authService.isAuthenticated()) {
      console.log("AnmeldeToolComponent::ngAfterViewInit: ");
      this.openLoginDialog();
    }
    */
  }

  get administrator(): boolean {
    return this.authService.isAdministrator();
  }

  /* todo
  toolSperrenClicked(event: any): void {
    this.anlassService
      .updateAnlass(this.anlass)
      .subscribe((anlass) => (this.anlass = anlass));
  }*/

  openLoginDialog(): void {
    // this.dialogOpen = true;

    // console.log("Dialog open");

    const dialogRef = this.dialog.open(LoginDialogComponent, {
      height: '500px',
      width: '500px',
      disableClose: true,
      autoFocus: true,
    });
    dialogRef.afterClosed().subscribe((result) => {
      // console.log("Dialog Closed", result);
      if (result === 'OK') {
        this.dialogOpen = false;
        this._authenticated = true;
      }
      if (result === 1) {
        this.openNewVereinDialog();
      }
      if (result === 2) {
        this.openNewAnmelderDialog();
      }
    });
  }
  openNewVereinDialog(): void {
    const dialogRef1 = this.dialog.open(NewVereinComponent, {
      height: '900px',
      width: '500px',
      disableClose: true,
    });
    dialogRef1.afterClosed().subscribe((result) => {
      console.log('Dialog 1 Closed', result);
      if (result !== 'OK') {
        this.openLoginDialog();
      } else {
        this.dialogOpen = false;
      }
    });
  }
  openNewAnmelderDialog(): void {
    const dialogRef2 = this.dialog.open(NewAnmelderComponent, {
      height: '770px',
      width: '500px',
      disableClose: true,
    });
    dialogRef2.afterClosed().subscribe((result) => {
      console.log('Dialog 2 Closed', result);
      this.openLoginDialog();
    });
  }
  /*
  get vereineLoaded(): Observable<boolean> {
    return this.vereinService.isVereineLoaded();
  }*/

  get authenticated(): boolean {
    // console.log('ngOnInit 2: ');
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
