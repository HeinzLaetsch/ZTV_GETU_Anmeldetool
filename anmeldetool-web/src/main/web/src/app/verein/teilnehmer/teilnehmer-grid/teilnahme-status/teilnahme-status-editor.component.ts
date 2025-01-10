import {
  AfterViewInit,
  Component,
  ViewChild,
  ViewContainerRef,
} from "@angular/core";
import { NgClass, NgFor } from "@angular/common";
import { NgIf } from "@angular/common";
import { ICellEditorAngularComp } from "ag-grid-angular";
import { FormsModule } from "@angular/forms";
import { MaterialModule } from "src/app/shared/material-module";
import { IAnlassLink } from "src/app/core/model/IAnlassLink";
import { MeldeStatusEnum } from "src/app/core/model/MeldeStatusEnum";

@Component({
  standalone: true,
  imports: [NgClass, NgFor, NgIf, FormsModule, MaterialModule],
  template: `
    <div #container class="teilnahme-status">
      <!-- Kategorie -->
      <div
        *ngIf="
          params.mode === 0 ||
          params.mode === 3 ||
          (params.mode === 2 && params.kats.length === 0)
        "
        class="teilnahme-status-kategorie"
      >
        {{ tal.kategorie }}
      </div>
      <div
        *ngIf="
          params.mode === 1 || (params.mode === 2 && params.kats.length > 0)
        "
        class="teilnahme-status-kategorie"
      >
        <mat-select
          [(ngModel)]="tal.kategorie"
          (selectionChange)="onChanged()"
          (click)="selected()"
        >
          <mat-option *ngFor="let kat of params.kats" [value]="kat">
            {{ kat }}
          </mat-option>
        </mat-select>
      </div>

      <!-- MeldeStatus -->
      <div
        *ngIf="params.mode === 0 || params.mode === 3"
        class="teilnahme-status-status"
      >
        {{ tal.meldeStatus }}
      </div>
      <div
        *ngIf="
          (params.mode === 1 || params.mode === 2) &&
          tal.meldeStatus?.toUpperCase() !== 'ABGEMELDET'
        "
        class="teilnahme-status-status-icon"
      >
        <mat-icon (click)="resetKategorie()">delete</mat-icon>
      </div>
      <!--
      <div *ngIf="params.mode === 2" class="teilnahme-status-status">
        <mat-select
          [(ngModel)]="tal.meldeStatus"
          (selectionChange)="onChanged()"
        >
          <mat-option *ngFor="let stat of params.stats" [value]="stat">
            {{ stat }}
          </mat-option>
        </mat-select>
      </div>
      -->
    </div>
  `,
  styles: [
    `
      .teilnahme-status {
        display: flex;
        outline: none;
      }
      .teilnahme-status-kategorie {
        min-width: 6em;
      }
      .teilnahme-status-status {
        min-width: 8em;
      }
      .teilnahme-status-status-icon {
        padding: 5px;
        min-width: 8em;
      }
    `,
  ],
})
export class TeilnahmeStatusEditor
  implements ICellEditorAngularComp, AfterViewInit
{
  public params: any;
  public tal: IAnlassLink;

  @ViewChild("container", { read: ViewContainerRef })
  public container!: ViewContainerRef;

  // dont use afterGuiAttached for post gui events - hook into ngAfterViewInit instead for this
  ngAfterViewInit() {
    window.setTimeout(() => {
      this.container.element.nativeElement.focus();
    });
  }

  agInit(params: any): void {
    this.params = params;
    console.log("Mode: ", params?.mode);
    this.tal = {
      anlassId: this.params.value.anlassId,
      teilnehmerId: this.params.value.teilnehmerId,
      organisationId: this.params.value.organisationId,
      kategorie: this.params.value.kategorie,
      meldeStatus: this.params.value.meldeStatus,
    };
  }
  selected() {
    if (
      this.params.kats.length > 0 &&
      this.params.value.meldeStatus?.toUpperCase() == "ABGEMELDET"
    ) {
      console.log("Selected");
      this.tal.meldeStatus = MeldeStatusEnum.STARTET;
      this.params.stopEditing();
    }
  }

  resetKategorie() {
    // this.tal.kategorie = "KEIN_START";
    if (this.tal.meldeStatus?.toUpperCase() === "ABGEMELDET") {
      this.tal.meldeStatus = MeldeStatusEnum.STARTET;
    } else {
      this.tal.meldeStatus = MeldeStatusEnum.ABGEMELDET;
    }
    this.params.stopEditing();
  }

  getValue(): IAnlassLink {
    return this.tal;
  }

  isPopup(): boolean {
    return false;
  }

  onChanged() {
    if (this.tal.kategorie === "KEIN_START") {
      this.tal.meldeStatus = MeldeStatusEnum.ABGEMELDET;
    } else {
      this.tal.meldeStatus = MeldeStatusEnum.STARTET;
    }
    this.params.stopEditing();
  }

  onKeyDown(event: any): void {
    const key = event.key;
    if (
      key == "ArrowLeft" || // left
      key == "ArrowRight"
    ) {
      event.stopPropagation();
    }
  }
  onClick(newValue: string) {}
}
