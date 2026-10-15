import { Component, type OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import type { MatSelectChange } from '@angular/material/select';
import type { ISmQuali } from 'src/app/core/model/ISmQuali';
import { KategorieEnum } from 'src/app/core/model/KategorieEnum';
import { parseTiTuEnum, TiTuEnum } from 'src/app/core/model/TiTuEnum';
import { SmQualiService } from 'src/app/core/service/smquali/smquali.service';
import { MaterialModule } from 'src/app/shared/material-module';

@Component({
  selector: 'ztv-smquali-viewer',
  templateUrl: './smquali-viewer.component.html',
  styleUrls: ['./smquali-viewer.component.scss'],
  standalone: true,
  imports: [CommonModule, MaterialModule],
})
export class SmQualiViewerComponent implements OnInit {
  jahr = 2023;
  tiTu: TiTuEnum = TiTuEnum.Ti;
  kategorie: KategorieEnum = KategorieEnum.K7;
  nurQuali = true;

  smQualiList: ISmQuali[];
  constructor(private smQualiService: SmQualiService) {}

  ngOnInit(): void {
    this.loadAuswertung();
  }

  private loadAuswertung(): void {
    this.smQualiService
      .getSmAuswertungJson(this.jahr, this.getFilter(this.tiTu), this.kategorie, this.nurQuali)
      .subscribe((result) => (this.smQualiList = result));
  }
  downloadAuswertungCSV(): void {
    this.smQualiService.getSmAuswertungCsv(this.jahr, this.getFilter(this.tiTu), this.kategorie, this.nurQuali);
  }

  private getFilter(titu: TiTuEnum): string {
    let filter: string;
    if (TiTuEnum.Tu === titu) {
      filter = 'Tu';
    } else {
      filter = 'Ti';
    }
    return filter;
  }
  getJahre(): number[] {
    return [2023];
  }
  jahrSelected(jahr: MatSelectChange): void {
    this.jahr = jahr.value;
    this.loadAuswertung();
  }
  getKategorien(): KategorieEnum[] {
    if (this.tiTu === TiTuEnum.Ti) {
      return [KategorieEnum.K5A, KategorieEnum.K6, KategorieEnum.KD, KategorieEnum.K7];
    } else {
      return [KategorieEnum.K5, KategorieEnum.K6, KategorieEnum.KH, KategorieEnum.K7];
    }
  }
  getTiTu(): TiTuEnum[] {
    return [TiTuEnum.Ti, TiTuEnum.Tu];
  }
  kategorieSelected(kategorie: MatSelectChange): void {
    this.kategorie = kategorie.value;
    this.loadAuswertung();
  }

  tiTuSelected(tiTu: MatSelectChange): void {
    this.tiTu = parseTiTuEnum(tiTu.value) || TiTuEnum.Tu;
    // this.tiTu = TiTuEnum[tiTu.value];
    this.loadAuswertung();
  }
  setNurQuali(nurQuali): void {
    this.nurQuali = nurQuali;
    this.loadAuswertung();
  }
}
