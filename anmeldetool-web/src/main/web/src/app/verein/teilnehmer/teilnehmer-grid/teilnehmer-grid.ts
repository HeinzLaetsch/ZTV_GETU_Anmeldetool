import { Component, ViewChild } from "@angular/core";
import { AgGridAngular } from "ag-grid-angular";
import { CellClickedEvent, ColDef, GridReadyEvent } from "ag-grid-community";
import { Observable } from "rxjs";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { TeilnehmerService } from "src/app/core/service/teilnehmer/teilnehmer.service";

@Component({
  selector: "app-teilnehmer-grid",
  templateUrl: "./teilnehmer-grid.html",
  styleUrls: ["./teilnehmer-grid.css"],
})
export class TeilnehmerGridComponent {
  // Each Column Definition results in one Column.
  public columnDefs: ColDef[] = [
    { field: "name" },
    { field: "vorname" },
    { field: "jahrgang" },
    { field: "stvNummer" },
    {
      field: "letzteKategorie",
      editable: true,
      cellEditor: "agSelectCellEditor",
      cellEditorParams: {
        values: ["K1", "K2", "K3", "K4", "K5"],
      },
    },
  ];

  // DefaultColDef sets props common to all Columns
  public defaultColDef: ColDef = {
    sortable: true,
    filter: true,
  };

  // Data that gets displayed in the grid
  public rowData$!: Observable<any[]>;

  // For accessing the Grid's API
  @ViewChild(AgGridAngular) agGrid!: AgGridAngular;

  constructor(
    private authService: AuthService,
    private teilnehmerService: TeilnehmerService
  ) {}

  // Example load data from sever
  onGridReady(params: GridReadyEvent) {
    this.rowData$ = this.teilnehmerService.getTeilnehmer(
      this.authService.currentVerein
    );
  }

  // Example of consuming Grid Event
  onCellClicked(e: CellClickedEvent): void {
    console.log("cellClicked", e);
  }

  // Example using Grid's API
  clearSelection(): void {
    this.agGrid.api.deselectAll();
  }
}
