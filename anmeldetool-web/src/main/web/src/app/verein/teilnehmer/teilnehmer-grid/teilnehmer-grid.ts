import { Component, OnInit, ViewChild } from "@angular/core";
import { select, Store } from "@ngrx/store";
import { AgGridAngular } from "ag-grid-angular";
import {
  ColDef,
  GetRowIdParams,
  GridApi,
  GridReadyEvent,
  ITooltipParams,
  ValueGetterParams,
  ValueSetterParams,
} from "ag-grid-community";
import { Observable, of } from "rxjs";
import { IAnlass } from "src/app/core/model/IAnlass";
import {
  KategorieEnum,
  KategorieEnumFunction,
} from "src/app/core/model/KategorieEnum";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";
import { selectAnlaesse, selectJahre } from "src/app/core/redux/anlass";
import { AppState } from "src/app/core/redux/core.state";
import { AuthService } from "src/app/core/service/auth/auth.service";
import {
  TeilnahmenActions,
  selectTeilnahmen,
} from "src/app/core/redux/teilnahmen";
import { ITeilnahmen } from "src/app/core/model/ITeilnahmen";
import { IAnlassLink } from "src/app/core/model/IAnlassLink";
import { ITeilnehmer } from "src/app/core/model/ITeilnehmer";
import { MatDialog } from "@angular/material/dialog";
import { AnzeigeStatusEnum } from "src/app/core/model/AnzeigeStatusEnum";
import { TeilnahmeStatusEditor } from "./teilnahme-status/teilnahme-status-editor.component";
import { TeilnahmeStatusRenderer } from "./teilnahme-status/teilnahme-status-renderer.component";
import { MeldeStatusEnum } from "src/app/core/model/MeldeStatusEnum";
import { IOrganisationTeilnahmenStatistik } from "src/app/core/model/IOrganisationTeilnahmenStatistik";
import {
  OtsActions,
  selectOts,
} from "src/app/core/redux/organisation-teilnahmen";
import { ButtonCellRenderer } from "./button-cell-renderer/button-cell-renderer.component";
import { TeilnehmerDialog } from "./teilnehmer-dialog/teilnehmer-dialog.component";
import * as moment from "moment";
import { MatSelectChange } from "@angular/material/select";
import { SubscriptionHelper } from "src/app/utils/subscription-helper";
import { AnlassService } from "src/app/core/service/anlass/anlass.service";
import { IAnlassSummary } from "src/app/core/model/IAnlassSummary";
import { TeilnehmerGridHelpComponent } from "./teilnehmer-grid-help/teilnehmer-grid-help.component";

@Component({
  selector: "app-teilnehmer-grid",
  templateUrl: "./teilnehmer-grid.html",
  styleUrls: ["./teilnehmer-grid.css"],
})
export class TeilnehmerGridComponent
  extends SubscriptionHelper
  implements OnInit
{
  static tColumns = 4;
  tooltipShowDelay = 1500;
  public selectedJahr = -1;

  selectedState = undefined;

  anlaesseAlle$: Observable<IAnlass[]>;
  jahresListeAnlaesse$: Observable<IAnlass[]>;
  jahresListe$: Observable<number[]>;
  alleAnlaesse: IAnlass[];

  public rowData$!: Observable<ITeilnahmen[]>;
  public data: ITeilnahmen[];
  private anlassSummaries = new Array<IAnlassSummary>();
  private gridApi!: GridApi<ITeilnahmen>;

  public ots$!: Observable<IOrganisationTeilnahmenStatistik[]>;
  private otsData: IOrganisationTeilnahmenStatistik[];

  public showOldAnlaesse: boolean = false;

  // Each Column Definition results in one Column.
  // headerValueGetter;
  // valueGetter;

  public context: any = {
    this: this,
  };
  public columnDefs: ColDef[] = [
    {
      headerName: "Aktion",
      colId: "teilnehmer.delete",
      cellRenderer: ButtonCellRenderer,
      width: 70,
      editable: false,
      pinned: "left",
    },
    {
      colId: "teilnehmer.name",
      headerName: "Name",
      // field: "teilnehmer.name",
      minWidth: 150,
      maxWidth: 200,
      valueSetter: this.teilnehmerAttributeValueSetter,
      valueGetter: this.teilnehmerAttributeValueGetter,
      pinned: "left",
      tooltipValueGetter: (p: ITooltipParams) => "Doppelklicken um zu ändern",
    },
    {
      headerName: "Vorname",
      colId: "teilnehmer.vorname",
      minWidth: 150,
      maxWidth: 200,
      valueSetter: this.teilnehmerAttributeValueSetter,
      valueGetter: this.teilnehmerAttributeValueGetter,
      pinned: "left",
      tooltipValueGetter: (p: ITooltipParams) => "Doppelklicken um zu ändern",
    },
    {
      headerName: "Jahrg.",
      colId: "teilnehmer.jahrgang",
      maxWidth: 70,
      valueSetter: this.teilnehmerAttributeValueSetter,
      valueGetter: this.teilnehmerAttributeValueGetter,
      tooltipValueGetter: (p: ITooltipParams) => "Doppelklicken um zu ändern",
    },
    {
      headerName: "Ti/Tu",
      colId: "teilnehmer.tiTu",
      maxWidth: 80,
      cellEditor: "agSelectCellEditor",
      cellEditorParams: { values: ["Ti", "Tu"] },
      valueSetter: this.teilnehmerAttributeValueSetter,
      valueGetter: this.teilnehmerAttributeValueGetter,
      tooltipValueGetter: (p: ITooltipParams) => "Doppelklicken um zu ändern",
    },
    {
      headerName: "STV Nr.",
      colId: "teilnehmer.stvNummer",
      maxWidth: 80,
      valueSetter: this.teilnehmerAttributeValueSetter,
      valueGetter: this.teilnehmerAttributeValueGetter,
      tooltipValueGetter: (p: ITooltipParams) => "Doppelklicken um zu ändern",
    },
    {
      headerName: "aktuelle Kategorie",
      colId: "teilnehmer.aktuelle_kategorie",
      editable: this.isAdmin,
      wrapHeaderText: true,
      valueGetter: this.kategorieValueGetter,
      cellEditor: "agSelectCellEditor",
      cellEditorParams: function (params) {
        return {
          values: params.context.this.getAvailableKategories(params),
        };
      },
      comparator: this.kValueComparator,
      maxWidth: 90,
      valueSetter: this.teilnehmerAttributeValueSetter,
      pinned: "left",
    },
  ];

  // DefaultColDef sets props common to all Columns
  public defaultColDef: ColDef = {
    sortable: true,
    filter: true,
    editable: true,
    wrapHeaderText: true,
    autoHeaderHeight: true,
    suppressKeyboardEvent: (params) => this.onSuppressKeyboardEvent(params),
  };

  // For accessing the Grid's API
  @ViewChild(AgGridAngular) agGrid!: AgGridAngular;

  constructor(
    public dialog: MatDialog,
    private store: Store<AppState>,
    private authService: AuthService,
    private anlassService: AnlassService
  ) {
    super();
    this.selectedJahr = moment(Date.now()).year();
  }

  onSuppressKeyboardEvent(params): boolean {
    let isTabKey = params.event.key === "Tab";

    if (isTabKey) {
      this.gridApi.stopEditing();
      return true;
    }
    return false;
  }

  public jahrSelektiert(event: MatSelectChange) {
    console.log("Jahr: ", event);
    this.selectedJahr = event.value;
    this.loadTeilnahmen();
    this.rowData$ = this.store.pipe(select(selectTeilnahmen()));
  }

  public getYear(anlass: IAnlass): number {
    return moment(anlass.endDatum).year();
  }

  private getAvailableKategories(params: any): string[] {
    const kats = KategorieEnumFunction.valuesAndGreater(
      KategorieEnum.K1,
      params.data.teilnehmer.tiTu,
      undefined
    );
    return kats;
  }
  teilnehmerAttributeValueGetter(params: ValueGetterParams): string {
    const component: TeilnehmerGridComponent = params.context.this;
    const rowValue: ITeilnahmen = JSON.parse(JSON.stringify(params.data));
    switch (params.column.getColId().toUpperCase()) {
      case "TEILNEHMER.NAME": {
        return params.data.teilnehmer.name;
        break;
      }
      case "TEILNEHMER.VORNAME": {
        return params.data.teilnehmer.vorname;
        break;
      }
      case "TEILNEHMER.JAHRGANG": {
        return params.data.teilnehmer.jahrgang;
        break;
      }
      case "TEILNEHMER.TITU": {
        return params.data.teilnehmer.tiTu;
        break;
      }
      case "TEILNEHMER.STVNUMMER": {
        return params.data.teilnehmer.stvNummer;
        break;
      }
    }
    return "NoValue";
  }
  teilnehmerAttributeValueSetter(params: ValueSetterParams): boolean {
    const component: TeilnehmerGridComponent = params.context.this;
    const rowValue: ITeilnahmen = JSON.parse(JSON.stringify(params.data));
    rowValue.jahr = component.selectedJahr;
    switch (params.column.getColId().toUpperCase()) {
      case "TEILNEHMER.NAME": {
        rowValue.teilnehmer.name = params.newValue;
        break;
      }
      case "TEILNEHMER.VORNAME": {
        rowValue.teilnehmer.vorname = params.newValue;
        break;
      }
      case "TEILNEHMER.JAHRGANG": {
        rowValue.teilnehmer.jahrgang = params.newValue;
        break;
      }
      case "TEILNEHMER.TITU": {
        rowValue.teilnehmer.tiTu = params.newValue;
        break;
      }
      case "TEILNEHMER.STVNUMMER": {
        rowValue.teilnehmer.stvNummer = params.newValue;
        break;
      }
      case "TEILNEHMER.AKTUELLE_KATEGORIE": {
        rowValue.teilnehmer.letzteKategorie = params.newValue;
        break;
      }
    }
    component.store.dispatch(
      TeilnahmenActions.updateTeilnahmenInvoked({ payload: rowValue })
    );
    return false;
  }

  ngOnInit() {
    this.loadTeilnahmen();
    this.registerSelects();
    this.subscribeColumnData();
  }

  private loadTeilnahmen() {
    this.store.dispatch(
      TeilnahmenActions.loadAllTeilnahmenInvoked({
        payload: this.selectedJahr,
      })
    );
    this.store.dispatch(
      OtsActions.loadAllOtsInvoked({
        payload: this.selectedJahr,
      })
    );
  }

  public showOldChanged(checked: boolean) {
    this.showOldAnlaesse = checked;
    this.redraw();
  }

  onGridReady(params: GridReadyEvent) {
    this.gridApi = params.api;
    this.registerSubscription(
      this.rowData$.subscribe((data) => {
        if (!this.gridApi.isDestroyed()) {
          this.gridApi.setGridOption("rowData", data);
        }
      })
    );
    this.sortByNameAsc();
    this.getSummaries();
  }

  private sortByNameAsc() {
    this.gridApi!.applyColumnState({
      state: [{ colId: "teilnehmer.name", sort: "asc" }],
      defaultState: { sort: null },
    });
  }

  public getJahresListe(): Observable<number[]> {
    return this.jahresListe$;
  }

  public getRowId(params: GetRowIdParams<ITeilnahmen>): any {
    return params.data.teilnehmer.id;
  }

  public subscribeColumnData() {
    this.registerSubscription(
      this.anlaesseAlle$.subscribe((anlaesse) => {
        this.alleAnlaesse = anlaesse;
        this.refreshAnlaesse();
      })
    );
  }

  registerSelects() {
    this.anlaesseAlle$ = this.store.pipe(select(selectAnlaesse()));
    this.jahresListeAnlaesse$ = this.store.pipe(select(selectJahre()));
    this.rowData$ = this.store.pipe(select(selectTeilnahmen()));
    this.ots$ = this.store.pipe(select(selectOts()));
    this.registerSubscription(
      this.ots$.subscribe((data) => {
        this.otsData = data;
      })
    );
    this.registerSubscription(
      this.jahresListeAnlaesse$.subscribe((anlaesse) => {
        this.jahresListe$ = of(anlaesse.map((anlass) => this.getYear(anlass)));
      })
    );
  }

  getSummaries() {
    this.agGrid.api.getColumns().forEach((column) => {
      // this.agGrid.api.getColumnState().forEach((state) => {
      if (!column.getColId().startsWith("teil")) {
        const index = +column.getColId();
        if (this.alleAnlaesse[index].aktiv) {
          const anlassSummary$ =
            this.anlassService.getAnlassOrganisationSummary(
              this.alleAnlaesse[index],
              this.authService.currentVerein
            );
          this.registerSubscription(
            anlassSummary$.subscribe((anlassSummary) => {
              this.anlassSummaries.push(anlassSummary);
            })
          );
        }
      }
    });
  }
  refreshAnlaesse() {
    var columnId = 0;
    this.alleAnlaesse.forEach((anlass) => {
      this.columnDefs.push({
        headerName: anlass.getCleaned(),
        valueGetter: this.talValueGetter,
        valueSetter: this.talValueSetter,
        minWidth: 100,
        maxWidth: 150,
        editable: function (params) {
          return params.context.this.isEditable(params, anlass);
        },
        cellRenderer: TeilnahmeStatusRenderer,
        cellEditor: TeilnahmeStatusEditor,
        tooltipValueGetter: function (params) {
          return params.context.this.getKategorieTooltip(params, anlass);
        },
        comparator: this.talComparator,
        cellEditorPopup: false,
        cellEditorParams: function (params) {
          return {
            kats: params.context.this.getAvailableKValues(params, anlass),
            mode: params.context.this.getMode(anlass),
          };
        },
        hide: !this.showAnlass(anlass),
      });
      columnId++;
    });
  }

  getKategorieTooltip(params: any, anlass: IAnlass): string {
    const component: TeilnehmerGridComponent = params.context.this;
    //if (component.isEditable(params, anlass)) {
    return "Doppelklicken um zu ändern";
    //}
    //return "Dein Verein startet nicht! Kein Ändern möglich";
  }
  private showAnlass(anlass: IAnlass): boolean {
    const asMoment = moment(anlass.endDatum);
    if (!this.showOldAnlaesse) {
      if (asMoment.isBefore()) {
        return false;
      } else {
        return true;
      }
    }
    if (asMoment.year() === this.selectedJahr) {
      return true;
    }
    return false;
  }
  redraw() {
    const allState = this.agGrid.api.getColumnState();
    const dateNow = Date.now();
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
        const showAnlass = this.showAnlass(this.alleAnlaesse[index]);
        if (visbility && !showAnlass) {
          visbility = showAnlass;
        }
        this.agGrid.api.setColumnVisible(state.colId, visbility);
      }
      // console.log("State ", state);
    });
  }
  kValueComparator(valueA: String, valueB: String) {
    return kategorieComparator(valueA, valueB);
  }

  talComparator(valueA: IAnlassLink, valueB: IAnlassLink) {
    if (valueA && valueB) {
      return kategorieComparator(valueA.kategorie, valueB.kategorie);
    }
    return 0;
  }

  getAvailableKValues(params: any, anlass: IAnlass): any[] {
    const component: TeilnehmerGridComponent = params.context.this;

    if (component.getMode(anlass) === 1) {
      const kats = KategorieEnumFunction.valuesAndGreater(
        //params.data.teilnehmer.letzteKategorie,
        KategorieEnum.K1,
        params.data.teilnehmer.tiTu,
        anlass
      );
      return kats;
    }
    if (component.getMode(anlass) === 4) {
      const kats = KategorieEnumFunction.valuesAndGreater(
        KategorieEnum.K1,
        params.data.teilnehmer.tiTu,
        anlass
      );
      return kats;
    }
    if (component.getMode(anlass) === 2) {
      const kats = KategorieEnumFunction.valuesAndGreater(
        //params.data.teilnehmer.letzteKategorie,
        KategorieEnum.K1,
        params.data.teilnehmer.tiTu,
        anlass
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
            "Kategorie: %s , Abmeldungen: %d, Neumeldungen: %d",
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

  isAdmin(params: any): boolean {
    return true;
    //return this.authService.isAdministrat or();
  }

  isEditable(params: any, anlass: IAnlass): boolean {
    // check auf startet
    if (this.anlassSummaries && this.anlassSummaries.length > 0) {
      const summary = this.anlassSummaries.find((summary) => {
        if (summary.anlassId === anlass.id) {
          return true;
        }
      });
      if (!summary || !summary.startet) {
        return false;
      }
    } else {
      return false;
    }

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
    if (this.getMode(anlass) === 0 || this.getMode(anlass) === 3) {
      return false;
    }
    if (this.getMode(anlass) === 1 || this.getMode(anlass) === 4) {
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
      params.data.teilnehmer.tiTu,
      anlass
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
    if (!ots || !ots.kategorieStati) {
      return false;
    }
    var retValue = false;
    for (const kategorie of kategories) {
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

  talValueSetter(params: ValueSetterParams): boolean {
    const component: TeilnehmerGridComponent = params.context.this;
    const anlass = component.getAnlassIdForColId(params);

    const newValue: ITeilnahmen = JSON.parse(JSON.stringify(params.data));
    if (!newValue.talDTOList) {
      newValue.talDTOList = [];
    }
    newValue.jahr = component.selectedJahr;

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
    if (params.data) {
      const tal = params.data.talDTOList?.find((element) => {
        if (
          component.alleAnlaesse === undefined ||
          component.alleAnlaesse[index] === undefined
        ) {
          return component.emptyTal(
            params.data.teilnehmer.id,
            undefined,
            undefined
          );
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

  onClick(newValue: string) {
    if (this.selectedState === newValue) {
      this.selectedState = undefined;
    } else {
      this.selectedState = newValue;
    }
    if (TiTuEnum.equals(TiTuEnum.Ti, this.selectedState)) {
      this.gridApi.setColumnFilterModel("teilnehmer.tiTu", {
        filterType: "text",
        type: "equals",
        filter: "Ti",
      });
    } else if (TiTuEnum.equals(TiTuEnum.Tu, this.selectedState)) {
      this.gridApi.setColumnFilterModel("teilnehmer.tiTu", {
        filterType: "text",
        type: "equals",
        filter: "Tu",
      });
    } else {
      this.gridApi.setColumnFilterModel("teilnehmer.tiTu", {});
    }
    this.gridApi.onFilterChanged();
    this.redraw();
  }

  addRow($event) {
    const newTeilnehmer: ITeilnehmer = {
      tiTu: this.selectedState,
      dirty: true,
    };
    this.openDialog(newTeilnehmer);
  }

  private openDialog(newTeilnehmer: ITeilnehmer) {
    const dialogRef = this.dialog.open(TeilnehmerDialog, {
      data: {
        title: "Teilnehmer hinzufügen",
        actionButton: "Speichern",
        disabled: false,
        teilnehmer: newTeilnehmer,
      },
    });

    this.registerSubscription(
      dialogRef.afterClosed().subscribe((result) => {
        if (result) {
          console.log(`Dialog result: ${result}`);
          this.store.dispatch(
            TeilnahmenActions.addTeilnehmerInvoked({ payload: result })
          );
        } else {
          console.log(`Dialog Abbruch: ${result}`);
        }
      })
    );
  }
  openTeilnehmerGridHelp() {
    console.log("openTeilnehmerGridHelp");
    const dialogRef = this.dialog.open(TeilnehmerGridHelpComponent);
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
