import { Component, OnInit } from "@angular/core";
import { MatSelectChange } from "@angular/material/select";
import { ISmQuali } from "src/app/core/model/ISmQuali";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { getTiTuEnum, TiTuEnum } from "src/app/core/model/TiTuEnum";
import { SmQualiService } from "src/app/core/service/smquali/smquali.service";

@Component({
  selector: "app-smquali-viewer",
  templateUrl: "./smquali-viewer.component.html",
  styleUrls: ["./smquali-viewer.component.css"],
})
export class SmQualiViewerComponent implements OnInit {
  jahr: number = 2023;
  tiTu: TiTuEnum = TiTuEnum.Ti;
  kategorie: KategorieEnum = KategorieEnum.K7;
  nurQuali: boolean = true;

  smQualiList: ISmQuali[];
  constructor(private smQualiService: SmQualiService) {}

  ngOnInit() {
    this.loadAuswertung();
  }

  private loadAuswertung() {
    this.smQualiService
      .getSmAuswertungJson(
        this.jahr,
        this.getFilter(this.tiTu),
        this.kategorie,
        this.nurQuali
      )
      .subscribe((result) => (this.smQualiList = result));
  }
  downloadAuswertungCSV() {
    this.smQualiService.getSmAuswertungCsv(
      this.jahr,
      this.getFilter(this.tiTu),
      this.kategorie,
      this.nurQuali
    );
  }

  private getFilter(titu: TiTuEnum): string {
    let filter = "Tu";
    if (TiTuEnum.Tu === titu) {
      filter = "Tu";
    } else {
      filter = "Ti";
    }
    return filter;
  }
  getJahre() {
    return [2023];
  }
  jahrSelected(jahr: MatSelectChange): void {
    this.jahr = jahr.value;
    this.loadAuswertung();
  }
  getKategorien() {
    if (this.tiTu === TiTuEnum.Ti) {
      return [
        KategorieEnum.K5A,
        KategorieEnum.K6,
        KategorieEnum.KD,
        KategorieEnum.K7,
      ];
    } else {
      return [
        KategorieEnum.K5,
        KategorieEnum.K6,
        KategorieEnum.KH,
        KategorieEnum.K7,
      ];
    }
  }
  getTiTu() {
    return [TiTuEnum.Ti, TiTuEnum.Tu];
  }
  kategorieSelected(kategorie: MatSelectChange): void {
    this.kategorie = kategorie.value;
    this.loadAuswertung();
  }

  tiTuSelected(tiTu: MatSelectChange): void {
    const aNY = getTiTuEnum(tiTu.value);
    this.tiTu = getTiTuEnum(tiTu.value);
    // this.tiTu = TiTuEnum[tiTu.value];
    this.loadAuswertung();
  }
  setNurQuali(nurQuali) {
    this.nurQuali = nurQuali;
    this.loadAuswertung();
  }
}
