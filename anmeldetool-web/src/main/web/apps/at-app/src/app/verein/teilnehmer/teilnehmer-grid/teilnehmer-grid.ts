import { Component, type OnInit, ViewChild } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import type { MatSelectChange } from '@angular/material/select';
import { select, Store } from '@ngrx/store';
import { AgGridAngular } from 'ag-grid-angular';
import type {
  ColDef,
  GetRowIdParams,
  GridApi,
  GridReadyEvent,
  ValueGetterParams,
  ValueSetterParams,
} from 'ag-grid-community';
import moment from 'moment';
import { combineLatest, type Observable, of } from 'rxjs';
import { AnzeigeStatusEnum } from '../../../core/model/AnzeigeStatusEnum';
import type { IAnlass } from '../../../core/model/IAnlass';
import type { IAnlassExtended } from '../../../core/model/IAnlassExtended';
import type { IAnlassLink } from '../../../core/model/IAnlassLink';
import type { IAnlassSummary } from '../../../core/model/IAnlassSummary';
import type { IOrganisationTeilnahmenStatistik } from '../../../core/model/IOrganisationTeilnahmenStatistik';
import type { ITeilnahmen } from '../../../core/model/ITeilnahmen';
import type { ITeilnehmer } from '../../../core/model/ITeilnehmer';
import { KategorieEnum, KategorieEnumFunction } from '../../../core/model/KategorieEnum';
import { MeldeStatusEnum } from '../../../core/model/MeldeStatusEnum';
import { isTiTuEnumEqual, parseTiTuEnum, TiTuEnum } from '../../../core/model/TiTuEnum';
import { selectAnlaesseSortedNew, selectJahre } from '../../../core/redux/anlass/anlass.selector';
import { AnlassSummariesActions } from '../../../core/redux/anlass-summary/anlass-summary.actions';
import { selectAnlassSummaries } from '../../../core/redux/anlass-summary/anlass-summary.selector';
import type { AppState } from '../../../core/redux/core.state';
import { OtsActions } from '../../../core/redux/organisation-teilnahmen/ots.actions';
import { selectOts } from '../../../core/redux/organisation-teilnahmen/ots.selectors';
import { TeilnahmenActions } from '../../../core/redux/teilnahmen/teilnahmen.actions';
import { selectTeilnahmen } from '../../../core/redux/teilnahmen/teilnahmen.selectors';
import { AuthService } from '../../../core/service/auth/auth.service';
import { SubscriptionHelper } from '../../../utils/subscription-helper';
import { ButtonCellRenderer } from './button-cell-renderer/button-cell-renderer.component';
import { TeilnahmeStatusEditor } from './teilnahme-status/teilnahme-status-editor.component';
import { TeilnahmeStatusRenderer } from './teilnahme-status/teilnahme-status-renderer.component';
import { TeilnehmerDialog } from './teilnehmer-dialog/teilnehmer-dialog.component';
import { TeilnehmerGridHelpComponent } from './teilnehmer-grid-help/teilnehmer-grid-help.component';
import { MaterialModule } from 'src/app/shared/material-module';

@Component({
  selector: 'lxt-teilnehmer-grid',
  templateUrl: './teilnehmer-grid.html',
  styleUrls: ['./teilnehmer-grid.css'],
  standalone: true,
  imports: [CommonModule, FormsModule, MaterialModule, AgGridAngular],
})
export class TeilnehmerGridComponent extends SubscriptionHelper implements OnInit {
  static tColumns = 4;
  tooltipShowDelay = 1500;
  selectedJahr = -1;

  selectedState: TiTuEnum | undefined = undefined;

  anlaesseAlle$!: Observable<IAnlass[]>;
  anlassSummaries$!: Observable<IAnlassSummary[]>;
  jahresListeAnlaesse$!: Observable<IAnlass[]>;
  jahresListe$!: Observable<number[]>;
  // alleAnlaesse: IAnlass[];
  anlaesseExtended: IAnlassExtended[] = [];

  rowData$!: Observable<ITeilnahmen[]>;
  data: ITeilnahmen[] = [];
  // private anlassSummaries = new Array<IAnlassSummary>();
  private gridApi!: GridApi<ITeilnahmen>;

  ots$!: Observable<IOrganisationTeilnahmenStatistik[]>;
  private otsData: IOrganisationTeilnahmenStatistik[] = [];

  showOldAnlaesse = false;

  // Each Column Definition results in one Column.
  // headerValueGetter;
  // valueGetter;

  context: { this: TeilnehmerGridComponent } = {
    this: this,
  };
  columnDefs: ColDef<ITeilnahmen>[] = [
    {
      headerName: 'Aktion',
      colId: 'teilnehmer.delete',
      cellRenderer: ButtonCellRenderer,
      width: 70,
      editable: false,
      pinned: 'left',
    },
    {
      colId: 'teilnehmer.name',
      headerName: 'Name',
      // field: "teilnehmer.name",
      minWidth: 150,
      maxWidth: 200,
      valueSetter: this.teilnehmerAttributeValueSetter,
      valueGetter: this.teilnehmerAttributeValueGetter,
      pinned: 'left',
      tooltipValueGetter: () => 'Doppelklicken um zu ändern',
    },
    {
      headerName: 'Vorname',
      colId: 'teilnehmer.vorname',
      minWidth: 150,
      maxWidth: 200,
      valueSetter: this.teilnehmerAttributeValueSetter,
      valueGetter: this.teilnehmerAttributeValueGetter,
      pinned: 'left',
      tooltipValueGetter: () => 'Doppelklicken um zu ändern',
    },
    {
      headerName: 'Jahrg.',
      colId: 'teilnehmer.jahrgang',
      maxWidth: 70,
      valueSetter: this.teilnehmerAttributeValueSetter,
      valueGetter: this.teilnehmerAttributeValueGetter,
      tooltipValueGetter: () => 'Doppelklicken um zu ändern',
    },
    {
      headerName: 'Ti/Tu',
      colId: 'teilnehmer.tiTu',
      maxWidth: 80,
      cellEditor: 'agSelectCellEditor',
      cellEditorParams: { values: ['Ti', 'Tu'] },
      valueSetter: this.teilnehmerAttributeValueSetter,
      valueGetter: this.teilnehmerAttributeValueGetter,
      tooltipValueGetter: () => 'Doppelklicken um zu ändern',
    },
    {
      headerName: 'STV Nr.',
      colId: 'teilnehmer.stvNummer',
      maxWidth: 80,
      valueSetter: this.teilnehmerAttributeValueSetter,
      valueGetter: this.teilnehmerAttributeValueGetter,
      tooltipValueGetter: () => 'Doppelklicken um zu ändern',
    },
    {
      headerName: 'aktuelle Kategorie',
      colId: 'teilnehmer.aktuelle_kategorie',
      editable: this.isAdmin,
      wrapHeaderText: true,
      valueGetter: this.kategorieValueGetter,
      cellEditor: 'agSelectCellEditor',
      cellEditorParams: (params: { data?: ITeilnahmen }): { values: string[] } => ({
        values: this.getAvailableKategories(params.data?.teilnehmer),
      }),
      comparator: this.kValueComparator,
      maxWidth: 90,
      valueSetter: this.teilnehmerAttributeValueSetter,
      pinned: 'left',
    },
  ];

  // DefaultColDef sets props common to all Columns
  defaultColDef: ColDef<ITeilnahmen> = {
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
    private authService: AuthService, // private anlassService: AnlassService
  ) {
    super();
    this.selectedJahr = moment().year();
    this.store.dispatch(AnlassSummariesActions.loadAllAnlasssummariesInvoked());
  }

  onSuppressKeyboardEvent(params: { event: KeyboardEvent }): boolean {
    const isTabKey = params.event.key === 'Tab';

    if (isTabKey) {
      this.gridApi.stopEditing();
      return true;
    }
    return false;
  }

  jahrSelektiert(event: MatSelectChange): void {
    console.log('Jahr: ', event);
    this.selectedJahr = event.value;
    this.loadTeilnahmen();
    this.rowData$ = this.store.pipe(select(selectTeilnahmen())) as Observable<ITeilnahmen[]>;
  }

  getYear(anlass: IAnlass): number {
    return moment(anlass.endDatum).year();
  }

  private getAvailableKategories(teilnehmer?: ITeilnehmer): string[] {
    const tiTu = teilnehmer?.tiTu;

    const tiTuEnum = parseTiTuEnum(typeof tiTu === 'string' ? tiTu : undefined) || TiTuEnum.Tu;

    return KategorieEnumFunction.valuesAndGreater('K1', tiTuEnum, undefined);
  }

  teilnehmerAttributeValueGetter(params: ValueGetterParams): string {
    switch (params.column.getColId().toUpperCase()) {
      case 'TEILNEHMER.NAME': {
        return params.data.teilnehmer.name;
      }
      case 'TEILNEHMER.VORNAME': {
        return params.data.teilnehmer.vorname;
      }
      case 'TEILNEHMER.JAHRGANG': {
        return params.data.teilnehmer.jahrgang;
      }
      case 'TEILNEHMER.TITU': {
        return params.data.teilnehmer.tiTu;
      }
      case 'TEILNEHMER.STVNUMMER': {
        return params.data.teilnehmer.stvNummer;
      }
    }
    return 'NoValue';
  }
  teilnehmerAttributeValueSetter(params: ValueSetterParams): boolean {
    const component: TeilnehmerGridComponent = params.context.this;
    const rowValue: ITeilnahmen = JSON.parse(JSON.stringify(params.data));
    rowValue.jahr = component.selectedJahr;
    switch (params.column.getColId().toUpperCase()) {
      case 'TEILNEHMER.NAME': {
        rowValue.teilnehmer.name = params.newValue;
        break;
      }
      case 'TEILNEHMER.VORNAME': {
        rowValue.teilnehmer.vorname = params.newValue;
        break;
      }
      case 'TEILNEHMER.JAHRGANG': {
        rowValue.teilnehmer.jahrgang = params.newValue;
        break;
      }
      case 'TEILNEHMER.TITU': {
        rowValue.teilnehmer.tiTu = params.newValue;
        break;
      }
      case 'TEILNEHMER.STVNUMMER': {
        rowValue.teilnehmer.stvNummer = params.newValue;
        break;
      }
      case 'TEILNEHMER.AKTUELLE_KATEGORIE': {
        rowValue.teilnehmer.letzteKategorie = params.newValue;
        break;
      }
    }
    component.store.dispatch(TeilnahmenActions.updateTeilnahmenInvoked({ payload: rowValue }));
    return false;
  }

  ngOnInit(): void {
    this.loadTeilnahmen();
    this.registerSelects();
    this.subscribeColumnData();
  }

  private loadTeilnahmen(): void {
    this.store.dispatch(
      TeilnahmenActions.loadAllTeilnahmenInvoked({
        payload: this.selectedJahr,
      }),
    );
    this.store.dispatch(
      OtsActions.loadAllOtsInvoked({
        payload: this.selectedJahr,
      }),
    );
  }

  showOldChanged(checked: boolean): void {
    this.showOldAnlaesse = checked;
    this.redraw();
  }

  onGridReady(params: GridReadyEvent): void {
    this.gridApi = params.api;
    this.registerSubscription(
      this.rowData$.subscribe((data) => {
        if (!this.gridApi.isDestroyed()) {
          this.gridApi.setGridOption('rowData', data);
        }
      }),
    );
    this.sortByNameAsc();
    this.getSummaries();
  }

  private sortByNameAsc(): void {
    this.gridApi!.applyColumnState({
      state: [{ colId: 'teilnehmer.name', sort: 'asc' }],
      defaultState: { sort: null },
    });
  }

  getJahresListe(): Observable<number[]> {
    return this.jahresListe$;
  }

  getRowId(params: GetRowIdParams<ITeilnahmen>): string {
    return params.data.teilnehmer.id || '';
  }

  subscribeColumnData(): void {
    /*
    this.registerSubscription(
      this.anlaesseAlle$.subscribe((anlaesse) => {
        this.alleAnlaesse = anlaesse;
        this.refreshAnlaesse();
      })
    );
    */
    const anlassExt$ = combineLatest([this.anlaesseAlle$, this.anlassSummaries$]);

    this.registerSubscription(
      anlassExt$.subscribe(([anlaesse, anlassSummaries]) => {
        this.anlaesseExtended = anlaesse
          .map((anlass) => {
            const summary = anlassSummaries.find((anlassSummary) => {
              return anlassSummary.anlassId === anlass.id;
            });

            if (!summary) {
              return undefined;
            }

            const anlaesseExtended: IAnlassExtended = {
              anlass,
              summary,
            };
            return anlaesseExtended;
          })
          .filter((anlassExt): anlassExt is IAnlassExtended => anlassExt !== undefined);
        this.refreshAnlaesse();
        console.log('AnlaesseExtended: ', this.anlaesseExtended);
      }),
    );
  }

  registerSelects(): void {
    this.anlaesseAlle$ = this.store.pipe(select(selectAnlaesseSortedNew(this.authService.isAdministratorSig())));
    this.anlassSummaries$ = this.store.pipe(select(selectAnlassSummaries())) as Observable<IAnlassSummary[]>;
    this.jahresListeAnlaesse$ = this.store.pipe(select(selectJahre()));
    this.rowData$ = this.store.pipe(select(selectTeilnahmen())) as Observable<ITeilnahmen[]>;
    this.ots$ = this.store.pipe(select(selectOts())) as Observable<IOrganisationTeilnahmenStatistik[]>;
    this.registerSubscription(
      this.ots$.subscribe((data) => {
        this.otsData = data;
      }),
    );
    this.registerSubscription(
      this.jahresListeAnlaesse$.subscribe((anlaesse) => {
        this.jahresListe$ = of(anlaesse.map((anlass) => this.getYear(anlass)));
      }),
    );
  }

  getSummaries(): void {
    /*
    this.agGrid.api.getColumns().forEach((column) => {
      // this.agGrid.api.getColumnState().forEach((state) => {
      if (!column.getColId().startsWith("teil")) {
        const index = +column.getColId();
        if (this.anlaesseExtended[index].anlass.aktiv) {
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
    */
  }
  refreshAnlaesse(): void {
    this.anlaesseExtended.forEach((anlassExt) => {
      this.columnDefs.push({
        headerName: anlassExt.anlass.getCleaned(),
        valueGetter: this.talValueGetter,
        valueSetter: this.talValueSetter,
        minWidth: 100,
        maxWidth: 150,
        editable: (params) => params.context.this.isEditable(params, anlassExt),
        cellRenderer: TeilnahmeStatusRenderer,
        cellEditor: TeilnahmeStatusEditor,
        tooltipValueGetter: (params) => params.context.this.getKategorieTooltip(),
        comparator: this.talComparator,
        cellEditorPopup: false,
        cellEditorParams: (params: ValueSetterParams) => ({
          kats: params.context.this.getAvailableKValues(params, anlassExt),
          mode: params.context.this.getMode(anlassExt),
        }),
        hide: !this.showAnlass(anlassExt.anlass),
      });
    });
  }

  getKategorieTooltip(): string {
    //if (component.isEditable(params, anlass)) {
    return 'Doppelklicken um zu ändern';
    //}
    //return "Dein Verein startet nicht! Kein Ändern möglich";
  }
  private showAnlass(anlass: IAnlass): boolean {
    const asMoment = moment(anlass.endDatum).endOf('day');
    if (!this.showOldAnlaesse) {
      return asMoment.isSameOrAfter(moment().startOf('day'));
    }
    return asMoment.year() === this.selectedJahr;
  }
  redraw(): void {
    let visbility = true;
    this.agGrid.api.getColumnState().forEach((state) => {
      if (!state.colId.startsWith('teil')) {
        const index = +state.colId;
        if (this.anlaesseExtended.length > index) {
          if (
            !this.anlaesseExtended[index].anlass.alleAnlass &&
            this.selectedState === 'Turner' &&
            this.anlaesseExtended[index].anlass.tiAnlass
          ) {
            visbility = false;
          }
          if (
            !this.anlaesseExtended[index].anlass.alleAnlass &&
            this.selectedState === 'Turnerin' &&
            this.anlaesseExtended[index].anlass.tuAnlass
          ) {
            visbility = false;
          }
        }
        const showAnlass = this.showAnlass(this.anlaesseExtended[index].anlass);
        if (visbility && !showAnlass) {
          visbility = showAnlass;
        }
        if (state.colId) {
          this.agGrid.api.setColumnsVisible([state.colId], visbility);
        }
      }
      // console.log("State ", state);
    });
  }
  kValueComparator(valueA: string, valueB: string): number {
    return kategorieComparator(valueA, valueB);
  }

  talComparator(valueA: IAnlassLink, valueB: IAnlassLink): number {
    if (valueA && valueB) {
      return kategorieComparator(valueA.kategorie, valueB.kategorie);
    }
    return 0;
  }

  getAvailableKValues(params: ValueSetterParams, anlaesseExt: IAnlassExtended): KategorieEnum[] {
    const component = params.context.this as TeilnehmerGridComponent;

    if (component.getMode(anlaesseExt) === 1) {
      const tiTu = parseTiTuEnum(params.data.teilnehmer.tiTu) || TiTuEnum.Tu;
      const kats = KategorieEnumFunction.valuesAndGreater(
        //params.data.teilnehmer.letzteKategorie,
        KategorieEnum.K1,
        tiTu,
        anlaesseExt.anlass,
      );
      return kats;
    }
    if (component.getMode(anlaesseExt) === 4) {
      const tiTu = parseTiTuEnum(params.data.teilnehmer.tiTu);
      const kats = KategorieEnumFunction.valuesAndGreater('K1', tiTu, anlaesseExt.anlass);
      return kats;
    }
    if (component.getMode(anlaesseExt) === 2) {
      const tiTu = parseTiTuEnum(params.data.teilnehmer.tiTu) || TiTuEnum.Tu;
      const kats = KategorieEnumFunction.valuesAndGreater(
        //params.data.teilnehmer.letzteKategorie,
        'K1',
        tiTu,
        anlaesseExt.anlass,
      );
      const ots = component.filterOts(anlaesseExt.anlass, component.otsData);
      if (ots) {
        const katsFiltered = kats.filter((kat: KategorieEnum) => {
          const meldeStati = ots.kategorieStati.find((status) => kat === status.kategorie);
          const neumeldungen = meldeStati?.meldeStati.filter((status: { meldeStatus: MeldeStatusEnum }) => {
            return status.meldeStatus === MeldeStatusEnum.NEUMELDUNG;
          });
          const abmeldungen = meldeStati?.meldeStati.filter((status: { meldeStatus: MeldeStatusEnum }) => {
            return status.meldeStatus.toUpperCase().startsWith('ABGEMELDET');
          });
          const abmeldungenCount = abmeldungen?.[0]?.count || 0;
          const neumeldungenCount = neumeldungen?.[0]?.count || 0;
          console.log('Kategorie: %s , Abmeldungen: %d, Neumeldungen: %d', kat, abmeldungenCount, neumeldungenCount);
          return neumeldungenCount < abmeldungenCount;
        });
        return katsFiltered;
      }
    }
    return [];
  }

  private filterOts(
    anlass: IAnlass,
    otsData: IOrganisationTeilnahmenStatistik[],
  ): IOrganisationTeilnahmenStatistik | undefined {
    return otsData.find((ots) => ots.anlassId === anlass.id);
  }

  /*
    mode = 0 --> Wettkampf Anmeldung noch nicht offen oder Wettkampf vorbei // Kein Edit
    mode = 1 --> Wettkampf Anmeldung offen, Erfassen erlaubt oder verlängert
    mode = 2 --> Wettkampf Anmeldung offen, Erfassen geschlossen, Mutationen erlaubt(Abmelden/Neumelden)
    mode = 3 --> Wettkampf Anmeldung offen, Mutationen geschlossen // Kein Edit
    mode = 4 --> Admin Mode (Alles erlaubt)
  */
  getMode(anlassExt: IAnlassExtended): number {
    if (this.authService.isAdministratorSig()) {
      return 4;
    }
    const anzeigeStatus = anlassExt.anlass.anzeigeStatus;
    if (!anzeigeStatus) {
      return 0;
    }
    if (anzeigeStatus.hasStatus(AnzeigeStatusEnum.NOCH_NICHT_OFFEN)) {
      return 0;
    }
    if (anzeigeStatus.hasStatus(AnzeigeStatusEnum.CLOSED)) {
      return 0;
    }
    // Falls verlängert, nimm das Verlängerungsdatum
    let asMoment = moment(anlassExt.anlass.erfassenGeschlossen).add(1, 'days');
    if (anlassExt.summary?.verlaengerungsDate) {
      asMoment = moment(anlassExt.summary.verlaengerungsDate);
    }
    if (!anzeigeStatus.hasStatus(AnzeigeStatusEnum.ERFASSEN_CLOSED) || asMoment.isSameOrAfter(moment())) {
      return 1;
    }
    if (!anzeigeStatus.hasStatus(AnzeigeStatusEnum.IN_KATEGORIE_CLOSED)) {
      return 2;
    }
    //TODO Beides mal gleich
    if (anzeigeStatus.hasStatus(AnzeigeStatusEnum.IN_KATEGORIE_CLOSED)) {
      return 3;
    }

    return 0;
  }

  isAdmin(): boolean {
    return true;
    //return this.authService.isAdministrat or();
  }

  isEditable(params: ValueSetterParams | ValueGetterParams, anlassExt: IAnlassExtended): boolean {
    // check auf startet
    /*
    if (anlassExt.summary && this.anlassSummaries.length > 0) {
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
    */
    if (!anlassExt.summary || !anlassExt.summary.startet) {
      return false;
    }

    if (!(
      (anlassExt.anlass.tiAnlass && isTiTuEnumEqual(params.data.teilnehmer.tiTu, TiTuEnum.Ti)) ||
      (anlassExt.anlass.tuAnlass && isTiTuEnumEqual(params.data.teilnehmer.tiTu, TiTuEnum.Tu))
    )) {
      return false;
    }

    const component: TeilnehmerGridComponent = params.context.this;
    const letzteKategorie = component.kategorieValueGetter(params as ValueGetterParams);
    if (letzteKategorie !== null && letzteKategorie !== '') {
      if (anlassExt.anlass.brevet1Anlass && !anlassExt.anlass.brevet2Anlass) {
        if (!KategorieEnumFunction.isBrevet1(letzteKategorie as KategorieEnum)) {
          return false;
        }
      }
      /* Funktion geht nicht, sonst kann kein Kategorie höher gestartet werden
      if (!anlassExt.anlass.brevet1Anlass && anlassExt.anlass.brevet2Anlass) {
        if (
          !KategorieEnumFunction.isBrevet2(letzteKategorie) &&
          !(
            KategorieEnumFunction.isBrevet1(letzteKategorie) &&
            KategorieEnumFunction.equals(KategorieEnum.K4, letzteKategorie)
          )
        ) {
          return false;
        }
      }
      */
    }
    if (this.getMode(anlassExt) === 0 || this.getMode(anlassExt) === 3) {
      return false;
    }
    if (this.getMode(anlassExt) === 1 || this.getMode(anlassExt) === 2 || this.getMode(anlassExt) === 4) {
      return true;
    }

    const tal = component.getTal(params, anlassExt.anlass, params.data.talDTOList);
    if (tal && !KategorieEnumFunction.equals(KategorieEnum.KEIN_START, KategorieEnumFunction.parse(tal.kategorie))) {
      return true;
    }
    // Check if Abmeldung
    const ots = component.filterOts(anlassExt.anlass, component.otsData);
    const possibleKategories = KategorieEnumFunction.valuesAndGreater(
      letzteKategorie,
      params.data.teilnehmer.tiTu,
      anlassExt.anlass,
    );
    if (component.hasAbmeldungenForKategories(possibleKategories, ots)) {
      return true;
    }
    return false;
  }

  hasAbmeldungenForKategories(kategories: KategorieEnum[], ots: IOrganisationTeilnahmenStatistik | undefined): boolean {
    if (!ots || !ots.kategorieStati) {
      return false;
    }
    let retValue = false;
    for (const kategorie of kategories) {
      const katStatus = ots.kategorieStati.find((status) => status.kategorie === kategorie);
      if (katStatus) {
        const meldeStatus = katStatus.meldeStati.find((status: { meldeStatus: MeldeStatusEnum }) =>
          status.meldeStatus.toUpperCase().startsWith('ABGEMELDET'),
        );
        if (meldeStatus) {
          retValue = true;
          break;
        }
      }
    }
    return retValue;
  }
  getAnlassIdForColId(params: ValueSetterParams): IAnlassExtended {
    const component: TeilnehmerGridComponent = params.context.this;
    const index = Number(params.column.getColId());
    const anlass = component.anlaesseExtended[index];
    return anlass;
  }

  getTal(_params: unknown, anlass: IAnlass, tals: IAnlassLink[]): IAnlassLink | undefined {
    const tal = tals.find((talInt) => talInt.anlassId === anlass.id);
    return tal;
  }

  talValueSetter(params: ValueSetterParams): boolean {
    const component: TeilnehmerGridComponent = params.context.this;
    const anlassExt = component.getAnlassIdForColId(params);

    const newValue: ITeilnahmen = JSON.parse(JSON.stringify(params.data));
    if (!newValue.talDTOList) {
      newValue.talDTOList = [];
    }
    newValue.jahr = component.selectedJahr;

    const tal = newValue.talDTOList.find((talInt: IAnlassLink) => talInt.anlassId === anlassExt.anlass.id);
    if (tal) {
      tal.kategorie = params.newValue.kategorie;
      tal.meldeStatus = params.newValue.meldeStatus;
    } else {
      if (params.newValue.kategorie === 'kein Start') {
        return true;
      }
      newValue.talDTOList.push(params.newValue);
    }
    component.store.dispatch(TeilnahmenActions.updateTeilnahmenInvoked({ payload: newValue }));
    component.store.dispatch(
      OtsActions.loadAllOtsInvoked({
        payload: component.selectedJahr,
      }),
    );

    return true;
  }

  talValueGetter(params: ValueGetterParams): IAnlassLink {
    const component: TeilnehmerGridComponent = params.context.this;
    const index = Number(params.column.getColId());
    if (params.data) {
      const tal = params.data.talDTOList?.find((element: IAnlassLink) => {
        if (component.anlaesseExtended === undefined || component.anlaesseExtended[index] === undefined) {
          return false;
        }
        return element.anlassId === component.anlaesseExtended[index].anlass.id;
      });
      if (tal !== undefined) {
        return tal;
      }
      return component.emptyTal(
        params.data.teilnehmer.id,
        component.anlaesseExtended[index].anlass.id,
        component.authService.currentVerein.id,
      );
    }

    return component.emptyTal('', '', '');
  }

  private emptyTal(teilnehmerId = '', anlassId = '', organisationId = ''): IAnlassLink {
    const tal: IAnlassLink = {
      teilnehmerId,
      anlassId,
      organisationId,
      kategorie: KategorieEnum.KEIN_START,
    };
    return tal;
  }

  kValueGetter(params: ValueGetterParams): string {
    const component: TeilnehmerGridComponent = params.context.this;
    const index = Number(params.column.getColId());
    const tal = params.data.talDTOList.find((element: IAnlassLink) => {
      if (component.anlaesseExtended === undefined || component.anlaesseExtended[index] === undefined) {
        return false;
      }
      return element.anlassId === component.anlaesseExtended[index].anlass.id;
    });
    if (tal !== undefined) {
      return tal.kategorie;
    }
    return '';
  }

  kategorieValueGetter(params: ValueGetterParams): string {
    if (params.data.teilnehmer.letzteKategorie === 'KEIN_START') {
      return '';
    }
    return params.data.teilnehmer.letzteKategorie;
  }

  onClick(newValue: TiTuEnum): void {
    if (this.selectedState === newValue) {
      this.selectedState = undefined;
    } else {
      this.selectedState = newValue;
    }
    if (this.selectedState && isTiTuEnumEqual(TiTuEnum.Ti, this.selectedState)) {
      this.gridApi.setColumnFilterModel('teilnehmer.tiTu', {
        filterType: 'text',
        type: 'equals',
        filter: 'Ti',
      });
    } else if (this.selectedState && isTiTuEnumEqual(TiTuEnum.Tu, this.selectedState)) {
      this.gridApi.setColumnFilterModel('teilnehmer.tiTu', {
        filterType: 'text',
        type: 'equals',
        filter: 'Tu',
      });
    } else {
      this.gridApi.setColumnFilterModel('teilnehmer.tiTu', {});
    }
    this.gridApi.onFilterChanged();
    this.redraw();
  }

  addRow(): void {
    const selectedStateKey =
      this.selectedState === TiTuEnum.Ti ? 'Ti' : this.selectedState === TiTuEnum.Tu ? 'Tu' : undefined;
    const newTeilnehmer: ITeilnehmer = {
      tiTu: selectedStateKey,
      dirty: true,
    };
    this.openDialog(newTeilnehmer);
  }

  private openDialog(newTeilnehmer: ITeilnehmer): void {
    const dialogRef = this.dialog.open(TeilnehmerDialog, {
      data: {
        title: 'Teilnehmer hinzufügen',
        actionButton: 'Speichern',
        disabled: false,
        teilnehmer: newTeilnehmer,
      },
    });

    this.registerSubscription(
      dialogRef.afterClosed().subscribe((result) => {
        if (result) {
          console.log(`Dialog result: ${result}`);
          this.store.dispatch(TeilnahmenActions.addTeilnehmerInvoked({ payload: result }));
        } else {
          console.log(`Dialog Abbruch: ${result}`);
        }
      }),
    );
  }
  openTeilnehmerGridHelp(): void {
    console.log('openTeilnehmerGridHelp');
    this.dialog.open(TeilnehmerGridHelpComponent);
  }
}

const kategorieComparator = (valueA: string, valueB: string): number => {
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
