import {
  ChangeDetectionStrategy,
  Component,
  computed,
  DestroyRef,
  effect,
  inject,
  signal,
  viewChild,
} from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { select, Store } from '@ngrx/store';
import { AgGridAngular } from 'ag-grid-angular';
import {
  type ColDef,
  type GetRowIdParams,
  type GridApi,
  type GridReadyEvent,
  themeQuartz,
  type ValueGetterParams,
  type ValueSetterParams,
} from 'ag-grid-community';
import moment from 'moment';
import { takeUntilDestroyed, toSignal } from '@angular/core/rxjs-interop';
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
import { selectAnlaesseSortedNew } from '../../../core/redux/anlass/anlass.selector';
import { AnlassSummariesActions } from '../../../core/redux/anlass-summary/anlass-summary.actions';
import { selectAnlassSummaries } from '../../../core/redux/anlass-summary/anlass-summary.selector';
import type { AppState } from '../../../core/redux/core.state';
import { OtsActions } from '../../../core/redux/organisation-teilnahmen/ots.actions';
import { selectOts } from '../../../core/redux/organisation-teilnahmen/ots.selectors';
import { TeilnahmenActions } from '../../../core/redux/teilnahmen/teilnahmen.actions';
import { selectTeilnahmen } from '../../../core/redux/teilnahmen/teilnahmen.selectors';
import { AuthService } from '../../../core/service/auth/auth.service';
import { ButtonCellRenderer } from './button-cell-renderer/button-cell-renderer.component';
import { TeilnahmeStatusEditor } from './teilnahme-status/teilnahme-status-editor.component';
import { TeilnahmeStatusRenderer } from './teilnahme-status/teilnahme-status-renderer.component';
import { TeilnehmerDialog } from './teilnehmer-dialog/teilnehmer-dialog.component';
import { TeilnehmerGridHelpComponent } from './teilnehmer-grid-help/teilnehmer-grid-help.component';
import { MaterialModule } from 'src/app/shared/material-module';

@Component({
  selector: 'ztv-teilnehmer-grid',
  templateUrl: './teilnehmer-grid.html',
  styleUrls: ['./teilnehmer-grid.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [MaterialModule, AgGridAngular],
})
export class TeilnehmerGridComponent {
  private readonly dialog = inject(MatDialog);
  private readonly destroyRef = inject(DestroyRef);
  private readonly store = inject(Store<AppState>);
  private readonly authService = inject(AuthService);

  gridTheme = themeQuartz;
  static tColumns = 4;
  tooltipShowDelay = 1500;
  readonly selectedJahr = signal(moment().year());
  readonly selectedState = signal<TiTuEnum | undefined>(undefined);

  readonly anlaesse = toSignal(
    this.store.pipe(select(selectAnlaesseSortedNew(this.authService.isAdministratorSig()))),
    {
      initialValue: [] as IAnlass[],
    },
  );
  readonly anlassSummaries = toSignal(this.store.pipe(select(selectAnlassSummaries())), {
    initialValue: [] as IAnlassSummary[],
  });
  readonly anlaesseExtended = computed(() =>
    this.anlaesse()
      .map((anlass) => {
        const summary = this.anlassSummaries().find((anlassSummary) => anlassSummary.anlassId === anlass.id);
        return summary ? { anlass, summary } : undefined;
      })
      .filter((anlassExt): anlassExt is IAnlassExtended => anlassExt !== undefined),
  );
  readonly rowData = toSignal(this.store.pipe(select(selectTeilnahmen())), {
    initialValue: [] as ITeilnahmen[],
  });
  private gridApi!: GridApi<ITeilnahmen>;

  readonly otsData = toSignal(this.store.pipe(select(selectOts())), {
    initialValue: [] as IOrganisationTeilnahmenStatistik[],
  });

  readonly showOldAnlaesse = signal(false);

  context: { this: TeilnehmerGridComponent } = {
    this: this,
  };
  columnDefs: ColDef<ITeilnahmen>[] = [
    {
      headerName: 'Aktion',
      colId: 'teilnehmer.delete',
      cellRenderer: ButtonCellRenderer,
      width: 90,
      editable: false,
      pinned: 'left',
    },
    {
      colId: 'teilnehmer.name',
      headerName: 'Name',
      minWidth: 150,
      maxWidth: 200,
      valueSetter: this.teilnehmerAttributeValueSetter,
      valueGetter: this.teilnehmerAttributeValueGetter,
      pinned: 'left',
      tooltip: () => 'Doppelklicken um zu ändern',
    },
    {
      headerName: 'Vorname',
      colId: 'teilnehmer.vorname',
      minWidth: 150,
      maxWidth: 200,
      valueSetter: this.teilnehmerAttributeValueSetter,
      valueGetter: this.teilnehmerAttributeValueGetter,
      pinned: 'left',
      tooltip: () => 'Doppelklicken um zu ändern',
    },
    {
      headerName: 'Jahrg.',
      colId: 'teilnehmer.jahrgang',
      maxWidth: 90,
      valueSetter: this.teilnehmerAttributeValueSetter,
      valueGetter: this.teilnehmerAttributeValueGetter,
      pinned: 'left',
      tooltip: () => 'Doppelklicken um zu ändern',
    },
    {
      headerName: 'Ti/Tu',
      colId: 'teilnehmer.tiTu',
      maxWidth: 90,
      cellEditor: 'agSelectCellEditor',
      cellEditorParams: { values: ['Ti', 'Tu'] },
      valueSetter: this.teilnehmerAttributeValueSetter,
      valueGetter: this.teilnehmerAttributeValueGetter,
      pinned: 'left',
      tooltip: () => 'Doppelklicken um zu ändern',
    },
    {
      headerName: 'STV Nr.',
      colId: 'teilnehmer.stvNummer',
      maxWidth: 90,
      valueSetter: this.teilnehmerAttributeValueSetter,
      valueGetter: this.teilnehmerAttributeValueGetter,
      pinned: 'left',
      tooltip: () => 'Doppelklicken um zu ändern',
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
      maxWidth: 100,
      valueSetter: this.teilnehmerAttributeValueSetter,
      pinned: 'left',
    },
  ];
  private readonly staticColumnDefs = this.columnDefs;

  defaultColDef: ColDef<ITeilnahmen> = {
    sortable: true,
    filter: true,
    editable: true,
    wrapHeaderText: true,
    autoHeaderHeight: true,
    suppressKeyboardEvent: (params) => this.onSuppressKeyboardEvent(params),
  };

  // For accessing the Grid's API
  readonly agGrid = viewChild.required(AgGridAngular);
  private readonly columnEffect = effect(() => {
    this.anlaesseExtended();
    if (this.gridApi && !this.gridApi.isDestroyed()) {
      this.refreshAnlaesse();
    }
  });

  constructor() {
    this.store.dispatch(AnlassSummariesActions.loadAllAnlasssummariesInvoked());
    this.loadTeilnahmen();
  }

  onSuppressKeyboardEvent(params: { event: KeyboardEvent }): boolean {
    const isTabKey = params.event.key === 'Tab';

    if (isTabKey) {
      this.gridApi.stopEditing();
      return true;
    }
    return false;
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
    rowValue.jahr = component.selectedJahr();
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

  private loadTeilnahmen(): void {
    this.store.dispatch(
      TeilnahmenActions.loadAllTeilnahmenInvoked({
        payload: this.selectedJahr(),
      }),
    );
    this.store.dispatch(
      OtsActions.loadAllOtsInvoked({
        payload: this.selectedJahr(),
      }),
    );
  }

  onShowOldAnlaesseChange(checked: boolean): void {
    this.showOldAnlaesse.set(checked);
    this.redraw();
  }

  onGridReady(params: GridReadyEvent): void {
    const gridApi = params.api;
    this.gridApi = gridApi;
    this.refreshAnlaesse();
    this.sortByNameAsc();
  }

  private sortByNameAsc(): void {
    this.gridApi!.applyColumnState({
      state: [{ colId: 'teilnehmer.name', sort: 'asc' }],
      defaultState: { sort: null },
    });
  }

  getRowId(params: GetRowIdParams<ITeilnahmen>): string {
    return params.data.teilnehmer.id || '';
  }

  refreshAnlaesse(): void {
    const dynamicColumnDefs = this.anlaesseExtended().map((anlassExt, index) => ({
      colId: String(index),
      headerName: anlassExt.anlass.getCleaned(),
      valueGetter: this.talValueGetter,
      valueSetter: this.talValueSetter,
      minWidth: 100,
      maxWidth: 150,
      editable: (params): boolean => params.context.this.isEditable(params, anlassExt),
      cellRenderer: TeilnahmeStatusRenderer,
      cellEditor: TeilnahmeStatusEditor,
      tooltip: (): string => this.getKategorieTooltip(),
      comparator: this.talComparator,
      cellEditorPopup: false,
      cellEditorParams: (params: ValueSetterParams): { kats: KategorieEnum[]; mode: number } => ({
        kats: params.context.this.getAvailableKValues(params, anlassExt),
        mode: params.context.this.getMode(anlassExt),
      }),
      hide: !this.showAnlass(anlassExt.anlass),
    }));

    this.columnDefs = [...this.staticColumnDefs, ...dynamicColumnDefs];

    if (this.gridApi && !this.gridApi.isDestroyed()) {
      this.gridApi.setGridOption('columnDefs', this.columnDefs);
    }
  }

  getKategorieTooltip(): string {
    //if (component.isEditable(params, anlass)) {
    return 'Doppelklicken um zu ändern';
    //}
    //return "Dein Verein startet nicht! Kein Ändern möglich";
  }
  private showAnlass(anlass: IAnlass): boolean {
    const asMoment = moment(anlass.endDatum).endOf('day').add(1, 'day');
    if (!this.showOldAnlaesse()) {
      return asMoment.isSameOrAfter(moment().startOf('day'));
    }
    return asMoment.year() === this.selectedJahr();
  }
  redraw(): void {
    let visbility = true;
    const anlaesseExtended = this.anlaesseExtended();
    this.agGrid()
      .api.getColumnState()
      .forEach((state) => {
        if (!state.colId.startsWith('teil')) {
          const index = +state.colId;
          if (anlaesseExtended.length > index) {
            if (
              !anlaesseExtended[index].anlass.alleAnlass &&
              this.selectedState() === 'Turner' &&
              anlaesseExtended[index].anlass.tiAnlass
            ) {
              visbility = false;
            }
            if (
              !anlaesseExtended[index].anlass.alleAnlass &&
              this.selectedState() === 'Turnerin' &&
              anlaesseExtended[index].anlass.tuAnlass
            ) {
              visbility = false;
            }
          }
          const showAnlass = this.showAnlass(anlaesseExtended[index].anlass);
          if (visbility && !showAnlass) {
            visbility = showAnlass;
          }
          if (state.colId) {
            this.agGrid().api.setColumnsVisible([state.colId], visbility);
          }
        }
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
      const ots = component.filterOts(anlaesseExt.anlass, component.otsData());
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
    const ots = component.filterOts(anlassExt.anlass, component.otsData());
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
    const anlass = component.anlaesseExtended()[index];
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
    newValue.jahr = component.selectedJahr();

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
        payload: component.selectedJahr(),
      }),
    );

    return true;
  }

  talValueGetter(params: ValueGetterParams): IAnlassLink {
    const component: TeilnehmerGridComponent = params.context.this;
    const index = Number(params.column.getColId());
    if (params.data) {
      const tal = params.data.talDTOList?.find((element: IAnlassLink) => {
        if (component.anlaesseExtended()[index] === undefined) {
          return false;
        }
        return element.anlassId === component.anlaesseExtended()[index].anlass.id;
      });
      if (tal !== undefined) {
        return tal;
      }
      return component.emptyTal(
        params.data.teilnehmer.id,
        component.anlaesseExtended()[index].anlass.id,
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
      if (component.anlaesseExtended()[index] === undefined) {
        return false;
      }
      return element.anlassId === component.anlaesseExtended()[index].anlass.id;
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
    if (this.selectedState() === newValue) {
      this.selectedState.set(undefined);
    } else {
      this.selectedState.set(newValue);
    }
    if (this.selectedState() && isTiTuEnumEqual(TiTuEnum.Ti, this.selectedState())) {
      this.gridApi.setColumnFilterModel('teilnehmer.tiTu', {
        filterType: 'text',
        type: 'equals',
        filter: 'Ti',
      });
    } else if (this.selectedState() && isTiTuEnumEqual(TiTuEnum.Tu, this.selectedState())) {
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
      this.selectedState() === TiTuEnum.Ti ? 'Ti' : this.selectedState() === TiTuEnum.Tu ? 'Tu' : undefined;
    const newTeilnehmer: ITeilnehmer = {
      tiTu: selectedStateKey,
      dirty: true,
    };
    this.openDialog(newTeilnehmer);
  }

  private openDialog(newTeilnehmer: ITeilnehmer): void {
    this.dialog
      .open(TeilnehmerDialog, {
        data: {
          title: 'Teilnehmer hinzufügen',
          actionButton: 'Speichern',
          disabled: false,
          teilnehmer: newTeilnehmer,
        },
      })
      .afterClosed()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe((result) => {
        if (result) {
          this.store.dispatch(TeilnahmenActions.addTeilnehmerInvoked({ payload: result }));
        }
      });
  }
  openTeilnehmerGridHelp(): void {
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
