import { AfterViewInit, Component, EventEmitter, OnInit } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { LoginDialogComponent } from "./verein/login/login-dialog.component";
import { MatDialog } from "@angular/material/dialog";
import { AuthService } from "./core/service/auth/auth.service";
import { NewVereinComponent } from "./verein/new-verein/new-verein.component";
import { NewAnmelderComponent } from "./verein/new-anmelder/new-anmelder.component";
import { CachingVereinService } from "./core/service/caching-services/caching.verein.service";
import { Observable } from "rxjs";

/** @title Main Component */
@Component({
  selector: "app-anmelde-tool",
  templateUrl: "app.component.html",
  styleUrls: ["app.component.css"],
})
export class AnmeldeToolComponent implements OnInit, AfterViewInit {
  private showPage = 0;
  dialogOpen = false;
  _authenticated: boolean;

  constructor(
    private authService: AuthService,
    public vereinService: CachingVereinService,
    private router: ActivatedRoute,
    public dialog: MatDialog
  ) {
    console.log("Konst");
  }

  fillerNav = Array.from({ length: 10 }, (_, i) => `Nav Item ${i + 1}`);

  ngOnInit() {
    this.vereinService.loadVereine().subscribe((result) => {
      console.log("AnmeldeToolComponent::ngOnInit 1: ", result);
    });

    if (!this.authService.isAuthenticated()) {
      // console.log('AnmeldeToolComponent::ngOnInit 2: ');
      this.openLoginDialog();
    }
  }

  ngAfterViewInit(): void {}

  openLoginDialog() {
    this.dialogOpen = true;

    console.log("Dialog open");

    let dialogRef = this.dialog.open(LoginDialogComponent, {
      height: "500px",
      width: "500px",
      disableClose: true,
    });
    dialogRef.afterClosed().subscribe((result) => {
      console.log("Dialog Closed", result);
      if (result === "OK") {
        this.dialogOpen = false;
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
