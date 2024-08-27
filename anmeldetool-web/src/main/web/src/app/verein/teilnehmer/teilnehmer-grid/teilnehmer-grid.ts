import { Component, OnInit, ViewChild } from "@angular/core";
import { select, Store } from "@ngrx/store";
import { AgGridAngular } from "ag-grid-angular";
import {
  CellClickedEvent,
  ColDef,
  GridApi,
  GridReadyEvent,
  IRowNode,
  ValueGetterParams,
  ValueSetterParams,
} from "ag-grid-community";
import { Observable, Subscription } from "rxjs";
import { IAnlass } from "src/app/core/model/IAnlass";
import {
  KategorieEnum,
  KategorieEnumFunction,
} from "src/app/core/model/KategorieEnum";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";
import {
  selectAllAnlaesseTiTu,
  selectAnlaesse,
} from "src/app/core/redux/anlass";
import { AppState } from "src/app/core/redux/core.state";
import { AuthService } from "src/app/core/service/auth/auth.service";
import {
  TeilnahmenActions,
  selectTeilnahmen,
  selectTiTeilnahmen,
  selectTuTeilnahmen,
} from "src/app/core/redux/teilnahmen";
import { ITeilnahmen } from "src/app/core/model/ITeilnahmen";
import { IAnlassLink } from "src/app/core/model/IAnlassLink";
import { ITeilnehmer } from "src/app/core/model/ITeilnehmer";
import { AddTeilnehmer } from "./add-teilnehmer/add-teilnehmer.component";
import { MatDialog } from "@angular/material/dialog";
import { AnzeigeStatusEnum } from "src/app/core/model/AnzeigeStatusEnum";
import { TeilnahmeStatusEditor } from "./teilnahme-status/teilnahme-status-editor.component";
import { TeilnahmeStatusRenderer } from "./teilnahme-status/teilnahme-status-renderer.component";
import { MeldeStatusEnum } from "src/app/core/model/MeldeStatusEnum";
import { IOrganisationTeilnahmenStatistik } from "src/app/core/model/IOrganisationTeilnahmenStatistik";
import {
  OtsActions,
  selectAllOts,
  selectOts,
  selectOtsByAnlassId,
} from "src/app/core/redux/organisation-teilnahmen";

@Component({
  selector: "app-teilnehmer-grid",
  templateUrl: "./teilnehmer-grid.html",
  styleUrls: ["./teilnehmer-grid.css"],
})
export class TeilnehmerGridComponent implements OnInit {
  static tColumns = 4;
  static jahr = 2024;

  selectedState = undefined;

  anlaesseAlle$: Observable<IAnlass[]>;
  alleAnlaesse: IAnlass[];

  public rowDataAll$!: Observable<ITeilnahmen[]>;
  public rowDataTi$!: Observable<ITeilnahmen[]>;
  public rowDataTu$!: Observable<ITeilnahmen[]>;

  public rowData: ITeilnahmen[];

  public rowAllData: ITeilnahmen[];
  public rowTiData: ITeilnahmen[];
  public rowTuData: ITeilnahmen[];
  private gridApi!: GridApi<ITeilnahmen>;

  public ots$!: Observable<IOrganisationTeilnahmenStatistik[]>;
  private otsData: IOrganisationTeilnahmenStatistik[];

  private subscriptions: Map<string, Subscription>;

  // Each Column Definition results in one Column.
  // headerValueGetter;
  // valueGetter;

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
      colId: "teilnehmer.aktuelle_kategorie",
      headerName: "aktuelle Kategorie",
      editable: false,
      wrapHeaderText: true,
      valueGetter: this.kategorieValueGetter,
      comparator: this.kValueComparator,
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
    public dialog: MatDialog,
    private store: Store<AppState>,
    private authService: AuthService
  ) {
    this.subscriptions = new Map<string, Subscription>();
  }

  ngOnInit() {
    this.store.dispatch(
      TeilnahmenActions.loadAllTeilnahmenInvoked({
        payload: TeilnehmerGridComponent.jahr,
      })
    );
    this.store.dispatch(
      OtsActions.loadAllOtsInvoked({
        payload: TeilnehmerGridComponent.jahr,
      })
    );

    //this.refreshAnlaesse();
    this.registerSelects();
    this.subscribeColumnData();
    this.subscribeRowData();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.gridApi.setGridOption("rowData", this.rowData);
    // this.subscribeRowData();
  }

  public subscribeColumnData() {
    this.anlaesseAlle$.subscribe((anlaesse) => {
      this.alleAnlaesse = anlaesse;
      this.refreshAnlaesse();
      /*
      if (this.selectedState === undefined) {
        this.refreshAnlaesse();
      }
      */
    });
  }

  private subscribeRowData() {
    this.rowDataAll$.subscribe((data) => {
      this.rowAllData = data;
      if (this.rowData === undefined) {
        setTimeout(() => {
          //  api.redrawRows();
          if (data && data.length > 0) {
            this.rowData = data;
          }
        }, 0);
      }
      // this.rowData = this.rowAllData;
    });

    /*
    if (!this.subscriptions.has("rowData") && this.gridApi) {
      this.subscriptions.set(
        "rowData",
        this.rowDataAll$.subscribe((data) => {
          this.rowAllData = data;

          if (this.selectedState === undefined) {
            // this.gridApi.setGridOption("rowData", data);

            this.store.dispatch(
              OtsActions.loadAllOtsInvoked({
                payload: TeilnehmerGridComponent.jahr,
              })
            );
          }
        })
      );
      */

    // Nur Ti
    this.rowDataTi$.subscribe((data) => {
      this.rowTiData = data;
      /*
        if (TiTuEnum.equals(TiTuEnum.Ti, this.selectedState)) {
          this.gridApi.setGridOption("rowData", data);
        }
        */
    });
    // Nur Tu
    this.rowDataTu$.subscribe((data) => {
      this.rowTuData = data;
      /*
        if (TiTuEnum.equals(TiTuEnum.Tu, this.selectedState)) {
          this.gridApi.setGridOption("rowData", data);
        }
        */
    });
  }

  registerSelects() {
    this.anlaesseAlle$ = this.store.pipe(
      //select(selectAllAnlaesseTiTu(this.selectedState))
      select(selectAnlaesse())
    );

    this.rowDataAll$ = this.store.pipe(select(selectTeilnahmen()));
    this.rowDataTi$ = this.store.pipe(select(selectTiTeilnahmen()));
    this.rowDataTu$ = this.store.pipe(select(selectTuTeilnahmen()));

    this.ots$ = this.store.pipe(select(selectOts()));
    this.ots$.subscribe((data) => {
      this.otsData = data;
    });
  }

  disAllowTab() {}

  disAllowAdd() {
    return false;
  }

  disAllowSave() {}

  disAllowCancel() {}

  // Example load data from sever

  refreshAnlaesse() {
    /*
    if (this.anlaesse$ === undefined) {
      this.anlaesse$ = this.store.pipe(select(selectAnlaesse()));
    }*/
    // this.anlaesse$.subscribe((anlaesse) => {
    var columnId = 0;
    this.alleAnlaesse.forEach((anlass) => {
      this.columnDefs.push({
        headerName: anlass.getCleaned(), // .substring(0, 15)
        valueGetter: this.talValueGetter,
        valueSetter: this.talValueSetter,
        wrapHeaderText: true,
        // headerComponent: AnlassHeaderComponent,
        minWidth: 100,
        maxWidth: 200,
        editable: function (params) {
          return params.context.this.isEditable(params, anlass);
        },
        cellRenderer: TeilnahmeStatusRenderer,
        cellEditor: TeilnahmeStatusEditor,
        comparator: this.talComparator,
        cellEditorPopup: false,
        // cellEditor: "agSelectCellEditor",
        cellEditorParams: function (params) {
          return {
            kats: params.context.this.getAvailableKValues(params, anlass),
            mode: params.context.this.getMode(anlass),
            // stats: params.context.this.getMeldeStati(anlass),
          };
        },
      });
      columnId++;
    });
    // anlassInit();
    // });
  }

  /*
  refreshData() {
    this.anlaesse$ = this.store.pipe(
      select(selectAllAnlaesseTiTu(this.selectedState))
    );
    if (this.selectedState === undefined) {
      this.rowDataAll$ = this.store.pipe(select(selectTeilnahmen()));
    } else {
      if (TiTuEnum.equals(TiTuEnum.Ti, this.selectedState)) {
        this.rowDataTi$ = this.store.pipe(select(selectTiTeilnahmen()));
      } else {
        if (TiTuEnum.equals(TiTuEnum.Tu, this.selectedState)) {
          this.rowDataTu$ = this.store.pipe(select(selectTuTeilnahmen()));
        }
      }
    }

    this.subscribeRowData();

    this.ots$ = this.store.pipe(select(selectOts()));
    this.ots$.subscribe((data) => {
      this.otsData = data;
    });
  }*/

  redraw() {
    const allState = this.agGrid.api.getColumnState();
    this.agGrid.api.getColumnState().forEach((state) => {
      if (!state.colId.startsWith("teil")) {
        var visbility = true;
        const index = +state.colId;
        if (this.alleAnlaesse.length > index) {
          if (
            !this.alleAnlaesse[index].alleAnlass &&
            this.selectedState === "Turner" &&
            this.alleAnlaesse[index].tiAnlass
          ) {
            visbility = false;
          }
          if (
            !this.alleAnlaesse[index].alleAnlass &&
            this.selectedState === "Turnerin" &&
            this.alleAnlaesse[index].tuAnlass
          ) {
            visbility = false;
          }
        }
        this.agGrid.api.setColumnVisible(state.colId, visbility);
      }
      // console.log("State ", state);
    });
  }
  kValueComparator(
    valueA: String,
    valueB: String,
    nodeA: IRowNode,
    nodeB: IRowNode,
    isDescending: boolean
  ) {
    return kategorieComparator(valueA, valueB);
  }

  talComparator(
    valueA: IAnlassLink,
    valueB: IAnlassLink,
    nodeA: IRowNode,
    nodeB: IRowNode,
    isDescending: boolean
  ) {
    if (valueA && valueB) {
      return kategorieComparator(valueA.kategorie, valueB.kategorie);
    }
    return 0;
  }

  getAvailableKValues(params: any, anlass: IAnlass): any[] {
    const component: TeilnehmerGridComponent = params.context.this;

    if (component.getMode(anlass) === 1) {
      const kats = KategorieEnumFunction.valuesAndGreater(
        params.data.teilnehmer.letzteKategorie,
        params.data.teilnehmer.tiTu
      );
      return kats;
    }
    if (component.getMode(anlass) === 2) {
      const kats = KategorieEnumFunction.valuesAndGreater(
        params.data.teilnehmer.letzteKategorie,
        params.data.teilnehmer.tiTu
      );
      const ots = component.filterOts(anlass, component.otsData);
      if (ots) {
        const katsFiltered = kats.filter((kat) => {
          const meldeStati = ots.kategorieStati.find(
            (kategorieStatus) => kat === kategorieStatus.kategorie
          );
          const neumeldungen = meldeStati?.meldeStati.filter((m) => {
            return m.meldeStatus === MeldeStatusEnum.NEUMELDUNG;
          }).length;
          const abmeldungen = meldeStati?.meldeStati.filter((m) => {
            return m.meldeStatus.toUpperCase().startsWith("ABGEMELDET");
          }).length;
          console.log(
            "Kaetgorie: %s , Abmeldungen: %d, Neumeldungen: %d",
            kat,
            abmeldungen,
            neumeldungen
          );
          return neumeldungen < abmeldungen;
        });
        return katsFiltered;
      }
    }
    return [];
  }

  private filterOts(
    anlass: IAnlass,
    otsData: IOrganisationTeilnahmenStatistik[]
  ): IOrganisationTeilnahmenStatistik {
    return otsData.find((ots) => ots.anlassId === anlass.id);
  }

  /*
    mode = 0 --> Wettkampf Anmeldung noch nicht offen oder Wettkampf vorbei // Kein Edit
    mode = 1 --> Wettkampf Anmeldung offen, Erfassen erlaubt oder verlängert
    mode = 2 --> Wettkampf Anmeldung offen, Erfassen geschlossen, Mutationen erlaubt(Abmelden/Neumelden)
    mode = 3 --> Wettkampf Anmeldung offen, Mutationen geschlossen // Kein Edit
    mode = 4 --> Admin Mode (Alles erlaubt)
  */
  getMode(anlass: IAnlass): number {
    if (this.authService.isAdministrator()) {
      return 4;
    }
    if (anlass.anzeigeStatus.hasStatus(AnzeigeStatusEnum.NOCH_NICHT_OFFEN)) {
      return 0;
    }
    if (anlass.anzeigeStatus.hasStatus(AnzeigeStatusEnum.CLOSED)) {
      return 0;
    }
    if (
      !anlass.anzeigeStatus.hasStatus(AnzeigeStatusEnum.ERFASSEN_CLOSED) ||
      anlass.anzeigeStatus.hasStatus(AnzeigeStatusEnum.VERLAENGERT)
    ) {
      return 1;
    }
    if (
      !anlass.anzeigeStatus.hasStatus(AnzeigeStatusEnum.IN_KATEGORIE_CLOSED)
    ) {
      return 2;
    }
    if (anlass.anzeigeStatus.hasStatus(AnzeigeStatusEnum.IN_KATEGORIE_CLOSED)) {
      return 3;
    }
  }

  isEditable(params: any, anlass: IAnlass): boolean {
    if (
      !(
        (anlass.tiAnlass &&
          TiTuEnum.equals(params.data.teilnehmer.tiTu, TiTuEnum.Ti)) ||
        (anlass.tuAnlass &&
          TiTuEnum.equals(params.data.teilnehmer.tiTu, TiTuEnum.Tu))
      )
    ) {
      return false;
    }

    const component: TeilnehmerGridComponent = params.context.this;
    const letzteKategorie = component.kategorieValueGetter(params);

    if (anlass.brevet1Anlass && !anlass.brevet2Anlass) {
      if (!KategorieEnumFunction.isBrevet1(letzteKategorie)) {
        return false;
      }
    }
    if (!anlass.brevet1Anlass && anlass.brevet2Anlass) {
      if (!KategorieEnumFunction.isBrevet2(letzteKategorie)) {
        return false;
      }
    }
    if (this.getMode(anlass) === 0 && this.getMode(anlass) === 3) {
      return false;
    }
    if (this.getMode(anlass) === 1) {
      return true;
    }

    const tal = component.getTal(params, anlass, params.data.talDTOList);
    if (
      tal &&
      !KategorieEnumFunction.equals(
        KategorieEnum.KEIN_START,
        KategorieEnumFunction.parse(tal.kategorie)
      )
    ) {
      return true;
    }
    // Check if Abmeldung
    const ots = component.filterOts(anlass, component.otsData);
    const possibleKategories = KategorieEnumFunction.valuesAndGreater(
      letzteKategorie,
      params.data.teilnehmer.tiTu
    );
    if (component.hasAbmeldungenForKategories(possibleKategories, ots)) {
      return true;
    }
    return false;
  }

  hasAbmeldungenForKategories(
    kategories: KategorieEnum[],
    ots: IOrganisationTeilnahmenStatistik
  ): any {
    var retValue = false;
    for (const kategorie of kategories) {
      // kategories.forEach((kategorie) => {
      const kats = ots.kategorieStati.find(
        (kats) => kats.kategorie === kategorie
      );
      if (kats) {
        const ms = kats.meldeStati.find((ms) =>
          ms.meldeStatus.toUpperCase().startsWith("ABGEMELDET")
        );
        if (ms) {
          retValue = true;
          break;
        }
      }
    }
    return retValue;
  }
  getAnlassIdForColId(params: any): IAnlass {
    const component: TeilnehmerGridComponent = params.context.this;
    const index = params.column.getColId();
    const anlass = component.alleAnlaesse[index];
    return anlass;
  }

  getTal(params: any, anlass: IAnlass, tals: IAnlassLink[]): IAnlassLink {
    const component: TeilnehmerGridComponent = params.context.this;

    const tal: IAnlassLink = tals.find(
      (talInt) => talInt.anlassId === anlass.id
    );
    return tal;
  }

  /*
  kValueSetter(params: ValueSetterParams): boolean {
    const component: TeilnehmerGridComponent = params.context.this;
    const anlass = component.getAnlassIdForColId(params);
    const newValue: ITeilnahmen = JSON.parse(JSON.stringify(params.data));
    const tal = component.getTal(params, anlass, newValue.talDTOList);
    tal.kategorie = params.newValue;
    newValue.jahr = TeilnehmerGridComponent.jahr;

    component.store.dispatch(
      TeilnahmenActions.updateTeilnahmenInvoked({ payload: newValue })
    );

    return true;
  }
  */
  talValueSetter(params: ValueSetterParams): boolean {
    const component: TeilnehmerGridComponent = params.context.this;
    const anlass = component.getAnlassIdForColId(params);

    const newValue: ITeilnahmen = JSON.parse(JSON.stringify(params.data));
    newValue.jahr = TeilnehmerGridComponent.jahr;

    const tal: IAnlassLink = newValue.talDTOList.find(
      (talInt) => talInt.anlassId === anlass.id
    );
    if (tal) {
      tal.kategorie = params.newValue.kategorie;
      tal.meldeStatus = params.newValue.meldeStatus;
    } else {
      if (params.newValue.kategorie === "kein Start") {
        return true;
      }
      newValue.talDTOList.push(params.newValue);
    }
    component.store.dispatch(
      TeilnahmenActions.updateTeilnahmenInvoked({ payload: newValue })
    );

    return true;
  }

  talValueGetter(params: ValueGetterParams): IAnlassLink {
    const component: TeilnehmerGridComponent = params.context.this;
    const index = Number(params.column.getColId());
    // && component.alleAnlaesse
    if (params.data) {
      const tal = params.data.talDTOList.find((element) => {
        if (
          component.alleAnlaesse === undefined ||
          component.alleAnlaesse[index] === undefined
        ) {
          return this.emptyTal(params.data.teilnehmer.id, undefined, undefined);
        }
        return element.anlassId === component.alleAnlaesse[index].id;
      });
      if (tal !== undefined) {
        return tal;
      }
      return component.emptyTal(
        params.data.teilnehmer.id,
        component.alleAnlaesse[index].id,
        component.authService.currentVerein.id
      );
    }
  }

  private emptyTal(
    teilnehmerId: string,
    anlassId: string,
    organisationId: string
  ) {
    const tal = {
      teilnehmerId,
      anlassId,
      organisationId,
      kategorie: KategorieEnum.KEIN_START,
      // meldeStatus: MeldeStatusEnum.KEINE_TEILNAHME,
    };
    return tal;
  }

  kValueGetter(params: ValueGetterParams) {
    const component: TeilnehmerGridComponent = params.context.this;
    const index = Number(params.column.getColId());
    const tal = params.data.talDTOList.find((element) => {
      if (
        component.alleAnlaesse === undefined ||
        component.alleAnlaesse[index] === undefined
      ) {
        return false;
      }
      return element.anlassId === component.alleAnlaesse[index].id;
    });
    if (tal !== undefined) {
      return tal.kategorie;
    }
    return "";
  }

  kategorieValueGetter(params: ValueGetterParams) {
    if (params.data.teilnehmer.letzteKategorie === "KEIN_START") {
      return "";
    }
    return params.data.teilnehmer.letzteKategorie;
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
    console.log("Change: ", $event.value);
    this.selectedState = $event.value;
    // this.refreshData();
    this.redraw();
  }

  onClick(newValue: string) {
    if (this.selectedState === newValue) {
      this.selectedState = undefined;
    } else {
      this.selectedState = newValue;
    }
    if (TiTuEnum.equals(TiTuEnum.Ti, this.selectedState)) {
      this.rowData = this.rowTiData;
    } else if (TiTuEnum.equals(TiTuEnum.Tu, this.selectedState)) {
      this.rowData = this.rowTuData;
    } else {
      this.rowData = this.rowAllData;
    }
    this.redraw();
  }

  addRow($event) {
    const newTeilnehmer: ITeilnehmer = {
      tiTu: this.selectedState,
      dirty: true,
    };
    this.openDialog(newTeilnehmer);
  }
  cancel($event) {}
  saveTeilnehmer($event) {}

  private openDialog(newTeilnehmer: ITeilnehmer) {
    const dialogRef = this.dialog.open(AddTeilnehmer, {
      data: newTeilnehmer,
    });

    dialogRef.afterClosed().subscribe((result) => {
      console.log(`Dialog result: ${result}`);
    });
  }
}

const kategorieComparator = function (valueA: String, valueB: String): number {
  const allValues = KategorieEnumFunction.values();
  const indexA = allValues.indexOf(valueA);
  const indexB = allValues.indexOf(valueB);
  if (indexA > indexB) {
    return 1;
  }
  if (indexA < indexB) {
    return -1;
  }
  return 0;
};
