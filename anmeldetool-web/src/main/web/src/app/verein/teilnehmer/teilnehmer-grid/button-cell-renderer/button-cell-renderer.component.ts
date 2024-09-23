import { ICellRendererAngularComp } from "ag-grid-angular";
import { ICellRendererParams } from "ag-grid-community";
import { Component } from "@angular/core";
import { MaterialModule } from "src/app/shared/material-module";
import { MatDialog } from "@angular/material/dialog";
import { ITeilnehmer } from "src/app/core/model/ITeilnehmer";
import { AppState } from "src/app/core/redux/core.state";
import { Store } from "@ngrx/store";
import { TeilnahmenActions } from "src/app/core/redux/teilnahmen";
import { TeilnehmerActions } from "src/app/core/redux/teilnehmer";
import { TeilnehmerDialog } from "../teilnehmer-dialog/teilnehmer-dialog.component";

@Component({
  standalone: true,
  imports: [MaterialModule],
  template: `
    <div [style.overflow]="'hidden'" [style.textOverflow]="'ellipsis'">
      <button
        mat-icon-button
        style="background-color:light-gray"
        aria-label="Teilnehmer löschen"
        (click)="delete()"
      >
        <mat-icon>delete</mat-icon>
      </button>
    </div>
  `,
  styles: [
    `
      :host {
        overflow: hidden;
      }
    `,
  ],
})
export class ButtonCellRenderer implements ICellRendererAngularComp {
  public params!: ICellRendererParams;

  constructor(public dialog: MatDialog, private store: Store<AppState>) {}

  agInit(params: ICellRendererParams): void {
    this.params = params;
  }

  refresh() {
    return false;
  }

  delete() {
    const teilnehmer = this.params.data.teilnehmer;
    this.openDialog(teilnehmer);
  }

  private openDialog(teilnehmer: ITeilnehmer) {
    const dialogRef = this.dialog.open(TeilnehmerDialog, {
      data: {
        title: "Teilnehmer löschen",
        actionButton: "Löschen",
        disabled: true,
        teilnehmer: teilnehmer,
      },
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result) {
        console.log(`Dialog result: ${result}`);
        this.store.dispatch(
          TeilnahmenActions.deleteTeilnehmerInvoked({
            payload: result,
          })
        );
      } else {
        console.log(`Dialog Abbruch: ${result}`);
      }
    });
  }
}
