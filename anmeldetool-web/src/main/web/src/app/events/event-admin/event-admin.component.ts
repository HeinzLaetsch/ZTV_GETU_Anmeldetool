import { Component, OnInit } from "@angular/core";
import { MatDialog } from "@angular/material/dialog";
import { ActivatedRoute, Router } from "@angular/router";
import { IAnlass } from "src/app/core/model/IAnlass";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { RanglistenService } from "src/app/core/service/rangliste/ranglisten.service";
import { Upload } from "./upload-dialog/upload.component";

@Component({
  selector: "app-event-admin",
  templateUrl: "./event-admin.component.html",
  styleUrls: ["./event-admin.component.css"],
})
export class EventAdminComponent implements OnInit {
  anlass: IAnlass;
  constructor(
    private router: Router,
    public dialog: MatDialog,
    private route: ActivatedRoute,
    public authService: AuthService,
    private anlassService: CachingAnlassService,
    private ranglistenService: RanglistenService
  ) {}

  ngOnInit() {
    const anlassId: string = this.route.snapshot.params.id;
    // console.log("url param: ", anlassId);
    this.anlass = this.anlassService.getAnlassById(anlassId);
  }

  get administrator(): boolean {
    return this.authService.isAdministrator();
  }
  exportTeilnehmer(): void {
    this.anlassService.getTeilnehmerForAnlassCsv(this.anlass);
  }
  importTeilnehmer(): void {
    const dialogRef = this.dialog.open(Upload, {
      data: undefined,
    });
  }
  exportWertungsrichter(): void {
    this.anlassService.getWertungsrichterForAnlassCsv(this.anlass);
  }
  lauflistenLoeschen(): void {
    this.ranglistenService
      .deleteLauflistenForAnlassAndKategorie(this.anlass, KategorieEnum.K1)
      .subscribe(() => {
        console.error("Success");
      });
  }

  lauflistenPDF(): void {
    this.ranglistenService.getLauflistenPdf(this.anlass, KategorieEnum.K1);
  }
}
