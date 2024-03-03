import { Component, OnInit, ViewChild } from "@angular/core";
import { select, Store } from "@ngrx/store";
import { AgGridAngular } from "ag-grid-angular";
import {
  CellClickedEvent,
  ColDef,
  GridApi,
  GridReadyEvent,
  ValueGetterParams,
} from "ag-grid-community";
import { Observable } from "rxjs";
import { IAnlass } from "src/app/core/model/IAnlass";
import { KategorieEnumFunction } from "src/app/core/model/KategorieEnum";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";
import {
  selectAllAnlaesseTiTu,
  selectAnlaesse,
} from "src/app/core/redux/anlass";
import { AppState } from "src/app/core/redux/core.state";
import { AuthService } from "src/app/core/service/auth/auth.service";
import {
  TeilnahmenActions,
  selectAllTeilnahmen,
  selectTeilnahmen,
  selectTiTeilnahmen,
  selectTuTeilnahmen,
} from "src/app/core/redux/teilnahmen";
import { ITeilnahmen } from "src/app/core/model/ITeilnahmen";

@Component({
  selector: "app-teilnehmer-grid",
  templateUrl: "./teilnehmer-grid.html",
  styleUrls: ["./teilnehmer-grid.css"],
})
export class TeilnehmerGridComponent implements OnInit {
  // entries$: Observable<ITeilnehmer[]>;
  // doneItems$: Observable<Todo[]>;
  // Data that gets displayed in the grid
  static tColumns = 4;
  anlaesse$: Observable<IAnlass[]>;
  anlaesse: IAnlass[];
  selectedState = [TiTuEnum.Ti];
  // public rowData$!: Observable<ITeilnehmer[]>;
  public rowData$!: Observable<ITeilnahmen[]>;
  private gridApi!: GridApi<ITeilnahmen>;

  // Each Column Definition results in one Column.
  headerValueGetter;
  valueGetter;

  public context: any = {
    this: this,
  };
  public columnDefs: ColDef[] = [
    {
      headerName: "Name",
      field: "teilnehmer.name",
      minWidth: 150,
      maxWidth: 200,
    },
    {
      headerName: "Vorname",
      field: "teilnehmer.vorname",
      minWidth: 150,
      maxWidth: 200,
    },
    {
      headerName: "Jahrg.",
      field: "teilnehmer.jahrgang",
      maxWidth: 70,
    },
    {
      headerName: "STV Nr.",
      field: "teilnehmer.stvNummer",
      maxWidth: 80,
    },
    {
      headerName: "aktuelle Kategorie",
      wrapHeaderText: true,
      field: "teilnehmer.letzteKategorie",
      maxWidth: 90,
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
    private store: Store<AppState>,
    private authService: AuthService /*,
    private store: Store<TeilnehmerState>
    private teilnehmerService: TeilnehmerService
    */
  ) {}

  ngOnInit() {
    // this.store.dispatch(TeilnehmerActions.loadAllTeilnehmerInvoked());
    this.store.dispatch(
      TeilnahmenActions.loadAllTeilnahmenInvoked({ payload: 2023 })
    );
    this.anlaesse$ = this.store.pipe(select(selectAnlaesse()));
    this.anlaesse$.subscribe((anlaesse) => {
      this.anlaesse = anlaesse;
      this.anlaesse.forEach((anlass) => {
        this.columnDefs.push({
          headerName: anlass.getCleaned(),
          valueGetter: this.kValueGetter,
          valueSetter: (params) => {
            let newVal = params.newValue;
            let colId =
              params.column.getInstanceId() - TeilnehmerGridComponent.tColumns;
            params.data.talDTOList[1].kategorie = newVal;
            this.store.dispatch(
              TeilnahmenActions.updateTeilnahmenInvoked(params.data)
            );
            return false;
          },
          wrapHeaderText: true,
          // headerComponent: AnlassHeaderComponent,
          minWidth: 70,
          maxWidth: 130,
          editable: true,
          cellEditor: "agSelectCellEditor",
          cellEditorParams: function (params) {
            return {
              values: KategorieEnumFunction.valuesAndGreater(
                params.data.teilnehmer.letzteKategorie
              ),
            };
          },
        });
      });
      // anlassInit();
    });
  }

  //          values: KategorieEnumFunction.values(),

  /*
  loadAnlaesseTeilnahmen(anlaesse: IAnlass[]) {
    this.authService.currentVerein;

    this.store.dispatch(
      TeilnahmenActions.loadAllTeilnahmenInvoked({ payload: 2023 })
    );
  } */

  disAllowTab() {}

  /*
      this.starts$ = this.store.pipe(
      select(
        selectOalForKeys(this.authService.currentVerein.id, this.anlass.id)
      )
    );

    this.starts$.subscribe((oalLinks) => {
      if (oalLinks !== undefined && oalLinks.length > 0) {
        this.orgAnlassLink = oalLinks[1];
        this.anlass.erfassenVerlaengert = this.orgAnlassLink.verlaengerungsDate;
      }
    });
  */

  // Example load data from sever
  onGridReady(params: GridReadyEvent) {
    this.refreshData();
    this.gridApi = params.api;
  }
  /*
    this.store
      .pipe(select(selectTiTeilnehmer()))
      .subscribe((teilnehmerList) => {
        teilnehmerList.forEach((teilnehmer) => {
          this.store
            .pipe(select(selectTeilnahmenByTeilnehmerId(teilnehmer.id)))
            .subscribe((teilnahme) => {
              teilnehmer.teilnahmen;
            });
        });
      });
    */

  refreshData() {
    if (this.selectedState.length > 1) {
      this.rowData$ = this.store.pipe(select(selectTeilnahmen()));
    } else {
      if (TiTuEnum.equals(TiTuEnum.Ti, this.selectedState[0])) {
        this.rowData$ = this.store.pipe(select(selectTiTeilnahmen()));
      } else {
        if (TiTuEnum.equals(TiTuEnum.Tu, this.selectedState[0])) {
          this.rowData$ = this.store.pipe(select(selectTuTeilnahmen()));
        }
      }
    }
  }

  kValueGetter(params: ValueGetterParams) {
    const component: TeilnehmerGridComponent = params.context.this;
    const index = params.column
      ? params.column.getInstanceId() - TeilnehmerGridComponent.tColumns
      : null;
    const tals = params.data.talDTOList.filter((element) => {
      if (
        component.anlaesse === undefined ||
        component.anlaesse[index] === undefined
      ) {
        return false;
      }
      return element.anlassId === component.anlaesse[index].id;
    });
    if (tals !== undefined && tals.length > 0 && tals[0] !== undefined) {
      return tals[0].kategorie;
    }
    return "";
  }

  // Example of consuming Grid Event
  onCellClicked(e: CellClickedEvent): void {
    console.log("cellClicked", e);
  }

  // Example using Grid's API
  clearSelection(): void {
    this.agGrid.api.deselectAll();
  }

  onChange($event) {
    console.log($event.value);
    this.selectedState = $event.value;
    this.agGrid.api.getColumnState().forEach((state) => {
      state.hide = true;
    });
    this.refreshData();
  }
}
