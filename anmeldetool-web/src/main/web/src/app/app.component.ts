import {
  AfterContentChecked,
  AfterViewInit,
  Component,
  OnInit,
} from "@angular/core";
import { MatDialog } from "@angular/material/dialog";
import { ActivatedRoute } from "@angular/router";
import { IAnlass } from "./core/model/IAnlass";
import { AuthService } from "./core/service/auth/auth.service";
import { CachingAnlassService } from "./core/service/caching-services/caching.anlass.service";
import { CachingVereinService } from "./core/service/caching-services/caching.verein.service";
import { LoginDialogComponent } from "./verein/login/login-dialog.component";
import { NewAnmelderComponent } from "./verein/new-anmelder/new-anmelder.component";
import { NewVereinComponent } from "./verein/new-verein/new-verein.component";

/** @title Main Component */
@Component({
  selector: "app-anmelde-tool",
  templateUrl: "app.component.html",
  styleUrls: ["app.component.css"],
})
export class AnmeldeToolComponent
  implements OnInit, AfterViewInit, AfterContentChecked
{
  private showPage = 0;
  dialogOpen = false;
  appBlocked = false;
  _authenticated: boolean;
  anlass: IAnlass;

  constructor(
    private authService: AuthService,
    public vereinService: CachingVereinService,
    private anlassService: CachingAnlassService,
    private router: ActivatedRoute,
    public dialog: MatDialog
  ) {
    this.anlass = this.anlassService.findetAnlassStatt();
    if (this.anlass) {
      this.appBlocked = true;
    }
  }
  ngAfterContentChecked(): void {
    if (
      !this.appBlocked &&
      !this.authService.isAuthenticated() &&
      this._authenticated
    ) {
      this._authenticated = false;
      console.log("AnmeldeToolComponent::ngAfterContentChecked");
      this.openLoginDialog();
    }
  }

  fillerNav = Array.from({ length: 10 }, (_, i) => `Nav Item ${i + 1}`);

  ngOnInit() {}

  ngAfterViewInit(): void {
    if (!this.appBlocked && !this.authService.isAuthenticated()) {
      console.log("AnmeldeToolComponent::ngAfterViewInit: ");
      this.openLoginDialog();
    }
  }

  get administrator(): boolean {
    return this.authService.isAdministrator();
  }

  toolSperrenClicked(event: any): void {
    this.anlassService
      .updateAnlass(this.anlass)
      .subscribe((anlass) => (this.anlass = anlass));
  }

  openLoginDialog() {
    this.dialogOpen = true;

    // console.log("Dialog open");

    let dialogRef = this.dialog.open(LoginDialogComponent, {
      height: "500px",
      width: "500px",
      disableClose: true,
      autoFocus: true,
    });
    dialogRef.afterClosed().subscribe((result) => {
      // console.log("Dialog Closed", result);
      if (result === "OK") {
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
  openNewVereinDialog() {
    let dialogRef1 = this.dialog.open(NewVereinComponent, {
      height: "900px",
      width: "500px",
      disableClose: true,
    });
    dialogRef1.afterClosed().subscribe((result) => {
      console.log("Dialog 1 Closed", result);
      if (result !== "OK") {
        this.openLoginDialog();
      } else {
        this.dialogOpen = false;
      }
    });
  }
  openNewAnmelderDialog() {
    let dialogRef2 = this.dialog.open(NewAnmelderComponent, {
      height: "770px",
      width: "500px",
      disableClose: true,
    });
    dialogRef2.afterClosed().subscribe((result) => {
      console.log("Dialog 2 Closed", result);
      this.openLoginDialog();
    });
  }
  /*
  get vereineLoaded(): Observable<boolean> {
    return this.vereinService.isVereineLoaded();
  }*/

  get authenticated() {
    // console.log('ngOnInit 2: ');
    return this.authService.isAuthenticated();
  }
  onShowPage(showPage: number): void {
    console.log("On ShowPage", showPage);
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
      return "";
    } else {
      return "overlay-content-login";
    }
  }
}
