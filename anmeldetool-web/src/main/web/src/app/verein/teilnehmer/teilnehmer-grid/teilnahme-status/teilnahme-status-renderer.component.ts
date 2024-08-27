import { Component } from "@angular/core";
import { NgIf } from "@angular/common";
import { ICellRendererParams } from "ag-grid-community";
import { ICellRendererAngularComp } from "ag-grid-angular";
import {
  KategorieEnum,
  KategorieEnumFunction,
} from "src/app/core/model/KategorieEnum";
import { MeldeStatusEnum } from "src/app/core/model/MeldeStatusEnum";

@Component({
  standalone: true,
  imports: [NgIf],
  template: `<div class="teilnahme-status">
    <div class="teilnahme-status-kategorie">
      <span *ngIf="showKategorie(params.value)">
        {{ params.value.kategorie }}
      </span>
    </div>
    <div class="teilnahme-status-status">
      <span *ngIf="showStatus(params.value)"
        >{{ params.value.meldeStatus }}
      </span>
      <span *ngIf="!showStatus(params.value)"
        >{{ params.value.meldeStatus }}
      </span>
    </div>
  </div>`,
  styles: [
    `
      .teilnahme-status {
        display: flex;
        outline: none;
      }
      .teilnahme-status-kategorie {
        min-width: 2em;
      }
      .teilnahme-status-status {
        min-width: 6em;
      }
    `,
  ],
})
export class TeilnahmeStatusRenderer implements ICellRendererAngularComp {
  public params!: ICellRendererParams;

  agInit(params: ICellRendererParams): void {
    this.params = params;
  }

  refresh(params: ICellRendererParams): boolean {
    this.params = params;
    return true;
  }

  showKategorie(value: any) {
    if (value) {
      if (
        !KategorieEnumFunction.equals(KategorieEnum.KEIN_START, value.kategorie)
      ) {
        return true;
      }
    }
    return false;
  }

  showStatus(value: any): boolean {
    if (value && value.meldeStatus) {
      if (value.meldeStatus.toUpperCase() === MeldeStatusEnum.ABGEMELDET) {
        return true;
      }
      if (value.meldeStatus.toUpperCase() === "ABGEMELDET") {
        return true;
      }
    }
    return false;
  }
}
