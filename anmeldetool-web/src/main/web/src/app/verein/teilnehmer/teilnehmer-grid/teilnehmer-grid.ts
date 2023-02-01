import { Component, OnInit, ViewChild } from "@angular/core";
import { select, Store } from "@ngrx/store";
import { AgGridAngular } from "ag-grid-angular";
import { CellClickedEvent, ColDef, GridReadyEvent } from "ag-grid-community";
import { Observable } from "rxjs";
import { ITeilnehmer } from "src/app/core/model/ITeilnehmer";
import {
  KategorieEnum,
  KategorieEnumFunction,
} from "src/app/core/model/KategorieEnum";
import {
  getAllEntries,
  getAllTiEntries,
  getAllTuEntries,
  TeilnehmerState,
} from "src/app/core/redux/teilnehmer";
import { LoadAllTeilnehmerAction } from "src/app/core/redux/teilnehmer/teilnehmer.actions";

@Component({
  selector: "app-teilnehmer-grid",
  templateUrl: "./teilnehmer-grid.html",
  styleUrls: ["./teilnehmer-grid.css"],
})
export class TeilnehmerGridComponent implements OnInit {
  // entries$: Observable<ITeilnehmer[]>;
  // doneItems$: Observable<Todo[]>;
  // Data that gets displayed in the grid
  public rowData$!: Observable<ITeilnehmer[]>;

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
        values: KategorieEnumFunction.values,
      },
    },
  ];

  // DefaultColDef sets props common to all Columns
  public defaultColDef: ColDef = {
    sortable: true,
    filter: true,
  };

  // For accessing the Grid's API
  @ViewChild(AgGridAngular) agGrid!: AgGridAngular;

  constructor(
    private store: Store<TeilnehmerState> /*,
    private authService: AuthService,
    private teilnehmerService: TeilnehmerService
    */
  ) {}

  ngOnInit() {
    this.store.dispatch(new LoadAllTeilnehmerAction());
    // this.store.dispatch(new LoadAllTeilnahmenAction());
  }

  disAllowTab() {}

  // Example load data from sever
  onGridReady(params: GridReadyEvent) {
    this.rowData$ = this.store.pipe(select(getAllTuEntries));
    /*
    this.rowData$ = this.teilnehmerService.getTeilnehmer(
      this.authService.currentVerein
    );
    */
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
