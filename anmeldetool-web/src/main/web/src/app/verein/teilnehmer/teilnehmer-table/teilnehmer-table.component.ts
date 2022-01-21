import { AfterViewInit, Component, Input, ViewChild } from "@angular/core";
import { FormControl, Validators } from "@angular/forms";
import { MatDialog } from "@angular/material/dialog";
import { MatPaginator, PageEvent } from "@angular/material/paginator";
import { MatSort, Sort } from "@angular/material/sort";
import { ToastrService } from "ngx-toastr";
import { Observable, Subject, Subscription } from "rxjs";
import { takeUntil } from "rxjs/operators";
import { TeilnehmerDataSource } from "src/app/core/datasource/TeilnehmerDataSource";
import { AnzeigeStatusEnum } from "src/app/core/model/AnzeigeStatusEnum";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IAnlassLink } from "src/app/core/model/IAnlassLink";
import { IOrganisationAnlassLink } from "src/app/core/model/IOrganisationAnlassLink";
import { ITeilnehmer } from "src/app/core/model/ITeilnehmer";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { MeldeStatusEnum } from "src/app/core/model/MeldeStatusEnum";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { CachingTeilnehmerService } from "src/app/core/service/caching-services/caching.teilnehmer.service";
import { CachingVereinService } from "src/app/core/service/caching-services/caching.verein.service";
import { IVerein } from "../../verein";
import { DeleteUser } from "./delete-dialog/delete-user.component";

interface TeilnahmeControl {
  formControl: FormControl;
  anlassLink?: IAnlassLink;
}
/**
 * @title Data table with sorting, pagination, and filtering.
 */
@Component({
  selector: "app-teilnehmer-table",
  styleUrls: ["teilnehmer-table.component.css"],
  templateUrl: "teilnehmer-table.component.html",
})
export class TeilnehmerTableComponent implements AfterViewInit {
  @Input()
  tiTu: TiTuEnum;

  filterValue: string;
  sortValue: string;

  populating = true;
  checked = new Array<IOrganisationAnlassLink>();

  teilnahmenControls = new Array<Array<FormControl>>();
  teilnehmerControls = new Array<Array<FormControl>>();
  mutationsControls = new Array<Array<FormControl>>();
  check1 = new FormControl();
  pageSize = 15;

  allDisplayedColumns: string[];
  displayedColumns = ["name", "vorname", "jahrgang", "stvnummer"];
  dataSource: TeilnehmerDataSource;
  vereine: IVerein[];
  anlaesse: IAnlass[];
  // _startsChanges: IStart[];

  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;

  loadTeilnehmerPageSub: Subscription;
  private readonly unsubscribeLoadAnlaesse$: Subject<void> = new Subject();
  private readonly unsubscribeLoadTeilnehmerPage$: Subject<void> =
    new Subject();
  private readonly unsubscribeLoadVereine$: Subject<void> = new Subject();

  constructor(
    public authService: AuthService,
    private teilnehmerService: CachingTeilnehmerService,
    private vereinService: CachingVereinService,
    private anlassService: CachingAnlassService,
    private toastr: ToastrService,
    public dialog: MatDialog
  ) {
    // Assign the data to the data source for the table to render
    this.dataSource = new TeilnehmerDataSource(
      this.teilnehmerService,
      this.authService.currentVerein
    );
    // this._startsChanges = new Array<IStart>();

    this.vereinService
      .loadVereine()
      .pipe(takeUntil(this.unsubscribeLoadVereine$))
      .subscribe((result) => {
        this.unsubscribeLoadVereine$.next();
        this.vereine = this.vereinService.getVereine();
        console.log(
          "TeilnehmerTableComponent:: constructor Vereine: ",
          this.vereine
        );
      });
  }

  private initAll() {
    this.anlassService
      .loadAnlaesse()
      .pipe(takeUntil(this.unsubscribeLoadAnlaesse$))
      .subscribe((result) => {
        this.unsubscribeLoadAnlaesse$.next();
        if (!result) {
          return;
        }
        this.anlaesse = this.anlassService.getAnlaesse(this.tiTu);
        // console.log("TeilnehmerTableComponent:: ngOnInit: ", this.anlaesse);
        this.allDisplayedColumns = this.displayedColumns.map((col) => col);
        this.anlaesse.forEach((anlass) => {
          this.allDisplayedColumns.push(
            anlass.anlassBezeichnung +
              "///" +
              anlass.tiTu +
              anlass.tiefsteKategorie
          );
          this.allDisplayedColumns.push(
            anlass.anlassBezeichnung +
              "///" +
              anlass.tiTu +
              anlass.tiefsteKategorie +
              "Btn"
          );
        });
        this.allDisplayedColumns.pop();
        this.allDisplayedColumns.push("aktion");

        let anzahlControls = this.pageSize;
        for (let i = 0; i <= anzahlControls; i++) {
          const teilnehmerLineControls = new Array<FormControl>();
          teilnehmerLineControls.push(this.getControl(i, 0));
          teilnehmerLineControls.push(this.getControl(i, 1));
          teilnehmerLineControls.push(this.getControl(i, 2));
          teilnehmerLineControls.push(this.getControl(i, 3));
          this.teilnehmerControls.push(teilnehmerLineControls);

          const lineControls = new Array<FormControl>();
          this.teilnahmenControls.push(lineControls);

          const mutationsControls = new Array<FormControl>();
          this.mutationsControls.push(mutationsControls);
        }
        this.loadTeilnehmerPage();
        this.loadTeilnahmen(true);
      });
  }

  getStatusClass(anlass: IAnlass): string {
    if (this.isChangesDisabled(anlass)) {
      return "opacity_03";
    } else {
      return "opacity_10";
    }
  }
  private loadTeilnahmen(createControl: boolean) {
    let i = 0;
    let currentAnlass = 0;
    this.anlaesse.forEach((anlass) => {
      // console.log("Prepare Anlass: ", anlass);
      if (createControl) {
        this.teilnahmenControls.forEach((line) => {
          const cntr = new FormControl({
            value: KategorieEnum.KEINE_TEILNAHME,
            disabled: true,
          });
          line.push(cntr);
        });
        this.mutationsControls.forEach((line) => {
          const cntr = new FormControl({
            value: undefined,
            disabled: true,
          });
          line.push(cntr);
        });
      }
      const empty = {
        anlassId: anlass?.id,
        organisationsId: this.authService.currentVerein?.id,
        startet: false,
        verlaengerungsDate: undefined,
      };
      this.anlassService
        .getVereinStart(anlass, this.authService.currentVerein)
        .subscribe((result) => {
          if (this.checked.length === 0) {
            this.anlaesse.forEach((anlass) => {
              this.checked.push(empty);
              anlass.position = i++;
            });
          }

          /*
          console.log(
            "getVereinStart ",
            anlass.anlassBezeichnung,
            " , Ti/Tu ",
            this.tiTu,
            ", started Result is: ",
            result,
            " , checked: ",
            this.checked.length,
            " , Anlässe: ",
            this.anlaesse.length
          );*/
          this.checked[anlass.position] = result;
          const isLast = currentAnlass++ === this.anlaesse.length - 1;
          this.teilnahmenloader(anlass, isLast);
        });
    });
  }
  public resetDataSource() {
    // console.log("resetDataSource");
    this.dataSource
      .reset(this.authService.currentVerein)
      .subscribe((results) => {
        this.initAll();
      });
    this.paginator.firstPage();
  }

  get isTeilnahmenLoaded(): Observable<boolean> {
    // console.log('TeilnehmerComponent::isTeilnehmerLoaded')
    return this.anlassService.isTeilnahmenLoaded();
  }

  getMeldeStatus(): String[] {
    return Object.values(MeldeStatusEnum);
  }

  getKategorien(anlass: IAnlass): String[] {
    let k5 = Object.keys(KategorieEnum).findIndex(
      (key) => key === KategorieEnum.K5
    );
    const start = Object.keys(KategorieEnum).findIndex(
      (key) => key === anlass.tiefsteKategorie
    );
    let end = Object.keys(KategorieEnum).findIndex(
      (key) => key === anlass.hoechsteKategorie
    );
    // Keine Teilnahme
    let filtered = Object.values(KategorieEnum).slice(0, 1);
    if (end > k5) {
      filtered = filtered.concat(Object.values(KategorieEnum).slice(start, k5));
      if (this.tiTu === TiTuEnum.Ti) {
        filtered.push(KategorieEnum.K5A);
        filtered.push(KategorieEnum.K5B);
        filtered.push(KategorieEnum.K6);
        filtered.push(KategorieEnum.KD);
      } else {
        filtered.push(KategorieEnum.K5);
        filtered.push(KategorieEnum.K6);
        filtered.push(KategorieEnum.KH);
      }
      filtered.push(KategorieEnum.K7);
    } else {
      filtered = filtered.concat(
        Object.values(KategorieEnum).slice(start, end + 1)
      );
    }
    return filtered;
  }
  get anzahlTeilnehmer(): number {
    return 0;
  }

  private toasterWarningSpeichern() {
    if (this.teilnehmerService.dirty) {
      const options = this.toastr.toastrConfig;
      options.closeButton = true;
      this.toastr.warning(
        "Änderungen zuerst speichern oder verwerfen",
        "Speichern/Verwerfen",
        options
      );
      return true;
    }
    return false;
  }

  public addNewTeilnehmer(titu: TiTuEnum) {
    if (
      this.paginator.length % this.paginator.pageSize === 0 &&
      this.toasterWarningSpeichern()
    ) {
      return;
    } else {
      console.log("addNewTeilnehmer");
      this.dataSource.sort(undefined);
      this.dataSource
        .add(this.authService.currentVerein, titu)
        .subscribe((teilnehmer) => {
          console.log("Teilnehmer added: ", teilnehmer);
          this.paginator.length =
            this.teilnehmerService.getTiTuTeilnehmer(titu).length;
          this.paginator.lastPage();
          this.loadTeilnehmerPage();
        });
    }
  }
  public saveTeilnehmer() {
    console.log("saveTeilnehmer");
    /*
    this._startsChanges.forEach((start) => {
      this.anlassService
        .updateVereinsStart(
          start.anlass,
          this.authService.currentVerein,
          start.start
        )
        .subscribe((response) => {
          console.log("updateVereinsStart");
        });
    });
    */
    this.dataSource
      .saveAll(this.authService.currentVerein)
      .subscribe((results) => {
        console.log("result of SaveAll: ", results);
      });
  }

  getControl(row: number, col: number): FormControl {
    let control: FormControl = undefined;
    // TODO pattern für STV Nummer
    if (col === 0 || col === 1) {
      control = new FormControl(row + ":", [
        Validators.minLength(2),
        Validators.required,
        Validators.pattern(
          "[a-zA-Z -_.\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u00FF]*"
        ),
      ]);
    }
    if (col === 2) {
      control = new FormControl(row + ":", [
        Validators.minLength(4),
        Validators.maxLength(4),
        Validators.required,
        Validators.pattern("[1,2][0-9]*"),
      ]);
    }
    if (col === 3) {
      control = new FormControl(row + ":", [
        Validators.minLength(5),
        Validators.maxLength(7),
        Validators.required,
        Validators.pattern("[0-9]*"),
      ]);
    }
    return control;
  }
  private teilnahmenloader(anlass: IAnlass, isLast: boolean): void {
    this.anlassService
      .loadTeilnahmen(anlass, this.authService.currentVerein, isLast)
      .subscribe((result) => {
        // console.log(
        //  "Teilnahme loaded: ",
        //  anlass.anlassBezeichnung,
        //  "Result: ",
        //  result
        // );
        if (result) {
          this.fillTeilnahmenControls(anlass);
          this.fillMuationsControls(anlass);
        }
      });
  }

  fillTeilnahmenControls(anlassOrg: IAnlass) {
    let teilnehmerPos = 0;
    this.teilnahmenControls.forEach((line) => {
      let pos = 0;
      // console.log("Line: ", line);
      this.anlaesse.forEach((anlass) => {
        // Lokale Variable (für was ??) die für jeden Anlass/Teilnehmer die Kategorie speichert
        // Mit Resolver sperren ???
        // console.log("Before: " , anlass.anlassBezeichnung , ", Line :", teilnehmerPos, "/", pos, " Pos: ", line[pos].value);
        if (anlassOrg === anlass) {
          // const teilnehmerKategorie = new Array<string>();
          const link = this.getTeilnahme(teilnehmerPos, anlass);
          // console.log("Old Line :", teilnehmerPos, "/", pos, " Pos: ", line[pos].value);
          const mustEnable = this.mustEnableAnlass(pos);
          if (link) {
            if (link.kategorie === "KEIN_START") {
              line[pos].setValue(KategorieEnum.KEINE_TEILNAHME);
            } else {
              line[pos].setValue(link?.kategorie);
            }
          } else {
            line[pos].setValue(KategorieEnum.KEINE_TEILNAHME);
          }
          if (mustEnable) {
            line[pos].enable();
          } else {
            line[pos].disable();
          }
          // console.log("New Line :", teilnehmerPos, "/", pos, " Pos: ", line[pos].value);
        }
        pos++;
      });
      teilnehmerPos++;
    });
  }

  // TODO Mutation geschlossen Wettkampf zu oder nicht offen
  fillMuationsControls(anlassOrg: IAnlass) {
    let teilnehmerPos = 0;
    this.mutationsControls.forEach((line) => {
      let pos = 0;
      this.anlaesse.forEach((anlass) => {
        if (anlassOrg === anlass) {
          const link = this.getTeilnahme(teilnehmerPos, anlass);
          const mustEnable = this.mustEnableAnlass(pos);
          if (link) {
            if (!link.meldeStatus) {
              if (link.kategorie === KategorieEnum.KEINE_TEILNAHME) {
                line[pos].setValue(undefined);
              } else {
                line[pos].setValue(MeldeStatusEnum.STARTET);
              }
            } else {
              line[pos].setValue(link.meldeStatus);
            }
          } else {
            line[pos].setValue(undefined);
          }
          if (!mustEnable) {
            if (!link || link.kategorie === KategorieEnum.KEINE_TEILNAHME) {
              line[pos].disable();
            } else {
              line[pos].enable();
            }
          } else {
            line[pos].disable();
          }
        }
        pos++;
      });
      teilnehmerPos++;
    });
  }
  getTeilnahme(teilnehmerRecord: number, anlass: IAnlass): IAnlassLink {
    const tr = this.dataSource.getTeilnehmer(
      this.filterValue,
      this.tiTu,
      teilnehmerRecord
    );
    if (tr) {
      return this.anlassService.getTeilnehmer(anlass, tr);
    }
    // console.log("Teilnehmer yet not Loaded: ", anlass.anlassBezeichnung);
    return undefined;
  }

  sortData(sort: Sort) {
    if (this.toasterWarningSpeichern()) {
      return;
    }
    if (sort.active.indexOf("///") > -1) {
      // Anlass
      const end = sort.active.indexOf("///");
      const anlassBezeichnung = sort.active.slice(0, end);
      const anlass =
        this.anlassService.getAnlassByAnlassBezeichnung(anlassBezeichnung);
      sort.active = anlass.id;
    }
    this.dataSource.sort(sort);
    this.loadTeilnahmen(false);
    this.loadTeilnehmerPage();
  }
  mustEnableAnlass(colIndex: number): boolean {
    if (colIndex < 0 || this.checked[colIndex] === undefined) {
      return false;
    }
    const mustEnable =
      this.checked[colIndex].startet &&
      !this.isChangesDisabled(this.anlaesse[colIndex]);
    return mustEnable;
  }
  private checkForIndex(colIndex: number, check: boolean) {
    // console.log("Clicked: ", colIndex, ", ", check);
    let anzahlControls = this.pageSize;
    const mustEnable = this.mustEnableAnlass(colIndex);

    for (let i = 0; i <= anzahlControls; i++) {
      if (mustEnable) {
        this.teilnahmenControls[i][colIndex].enable();
      } else {
        this.teilnahmenControls[i][colIndex].disable();
      }
    }
  }

  getStartet(colIndex: number): boolean {
    return this.checked[colIndex]?.startet;
  }

  clicked(event: any, colIndex: any) {
    console.log(event);
    event.stopPropagation();
  }

  checkedClicked(check: boolean, colIndex: any) {
    console.log("Clicked: ", colIndex, ", ", check);
    this.checked[colIndex].startet = check;

    this.checkForIndex(colIndex, check);

    this.anlassService
      .updateVereinsStart(this.checked[colIndex])
      .subscribe((response) => {
        this.checked[colIndex] = response;
        console.log("VereinsStart updated");
      });
  }
  /**
   * Set the paginator and sort after the view init since this component will
   * be able to query its view for the initialized paginator and sort.
   */
  ngAfterViewInit() {
    // console.log('Init Table: ', this.tiTu);
    if (this.paginator) {
      this.dataSource.paginator = this.paginator;
      // this.dataSource.sort = this.sort;
      this.paginator.page.subscribe((pageEvent) => {
        this.checkIfDirty(pageEvent);
        // console.log("PageEvent: ", pageEvent);
        this.loadTeilnahmen(false);
        this.loadTeilnehmerPage();
      });
      this.initAll();
    }
  }

  public isDirty(): boolean {
    return this.teilnehmerService.dirty;
  }
  checkIfDirty(pageEvent: PageEvent) {
    let row = 0;
    this.teilnehmerControls.forEach((teilnehmerLine) => {
      let col = 0;
      teilnehmerLine.forEach((control) => {
        if (control.dirty) {
          this.dataSource.update(
            this.filterValue,
            this.tiTu,
            pageEvent.previousPageIndex,
            row,
            col,
            control.value
          );
          control.reset();
        }
        if (control.touched) {
          console.log("Control touched: ", row, ", ", col);
        }
        col++;
      });
      row++;
    });
  }
  loadTeilnehmerPage() {
    this.dataSource
      .loadTeilnehmer(this.filterValue, this.tiTu)
      .pipe(takeUntil(this.unsubscribeLoadTeilnehmerPage$))
      .subscribe((result) => {
        this.unsubscribeLoadTeilnehmerPage$.next();
        // console.error("Load Teilnehmer Page");
        this.populateTeilnehmer(result);
      });
  }
  populateTeilnehmer(allTeilnehmer: ITeilnehmer[]) {
    let i = 0;
    this.populating = true;
    if (allTeilnehmer) {
      allTeilnehmer.forEach((teilnehmer) => {
        // console.log("populateTeilnehmer");
        this.teilnehmerControls[i][0].setValue(teilnehmer.name);
        this.teilnehmerControls[i][1].setValue(teilnehmer.vorname);
        this.teilnehmerControls[i][2].setValue(teilnehmer.jahrgang);
        this.teilnehmerControls[i][3].setValue(teilnehmer.stvNummer);
        i++;
      });
    }
    this.populating = false;
  }
  applyFilter(filterValue: string) {
    if (filterValue) {
      filterValue = filterValue.trim(); // Remove whitespace
      this.filterValue = filterValue.toLowerCase(); // Datasource defaults to lowercase matches
    } else {
      this.filterValue = filterValue;
    }
    this.dataSource.filter = this.filterValue;
    // this.checkIfDirty(pageEvent);
    // console.log("PageEvent: ", pageEvent);
    this.loadTeilnahmen(false);
    this.loadTeilnehmerPage();
  }
  copy(event: any, row: any, rowIndex: number, colIndex: any, anlass: IAnlass) {
    console.log(
      "Copy clicked: ",
      event,
      " row: ",
      row,
      " ,rowIndex: ",
      rowIndex,
      " ,colIndex: ",
      colIndex
    );
    const rest = this.checked.slice(colIndex + 1);
    const newIndex = rest.findIndex((element) => element) + colIndex + 1;
    this.teilnahmenControls[rowIndex][newIndex].setValue(
      this.teilnahmenControls[rowIndex][colIndex].value
    );
    this.updateTeilnahmen(rowIndex, newIndex);
  }
  copyAll(event: any, colIndex: any) {
    let rowIndex = 0;
    const rest = this.checked.slice(colIndex + 1);
    const newIndex = rest.findIndex((element) => element) + colIndex + 1;
    this.teilnahmenControls.forEach((anlassCntrLine) => {
      anlassCntrLine[newIndex].setValue(anlassCntrLine[colIndex].value);
      this.updateTeilnahmen(rowIndex, newIndex);
      rowIndex++;
    });
    console.log("Copy All clicked: ", event, " ,colIndex: ", colIndex);
  }
  vchange(rowIndex: number, colIndex: number, value: any) {
    console.log("Value Change fired: ", value);
  }

  private updateMutationen(rowIndex: any, colIndex: any) {
    const anlass = this.anlaesse[colIndex];
    this.dataSource.valid = this.mutationsControls[rowIndex][colIndex].valid;
    this.dataSource.updateMutationen(
      this.filterValue,
      this.tiTu,
      rowIndex,
      this.mutationsControls[rowIndex][colIndex].value,
      anlass
    );
    this.dataSource.dirty = true;
  }

  private updateTeilnahmen(rowIndex: any, colIndex: any) {
    const anlass = this.anlaesse[colIndex];
    this.dataSource.valid = this.teilnahmenControls[rowIndex][colIndex].valid;
    this.dataSource.updateTeilnahme(
      this.filterValue,
      this.tiTu,
      rowIndex,
      this.teilnahmenControls[rowIndex][colIndex].value,
      anlass
    );
    this.dataSource.dirty = true;
  }

  private updateTeilnehmer(rowIndex: any, colIndex: any) {
    this.dataSource.valid = this.teilnehmerControls[rowIndex][colIndex].valid;
    this.dataSource.update(
      this.filterValue,
      this.tiTu,
      undefined,
      rowIndex,
      colIndex,
      this.teilnehmerControls[rowIndex][colIndex].value
    );
    this.dataSource.dirty = true;
  }
  changeTeilnehmer(event: any, row: any, rowIndex: any, colIndex: any) {
    console.log(
      "change fired: ",
      // event,
      " row: ",
      row,
      " rowIndex: ",
      rowIndex,
      " ,colIndex: ",
      colIndex,
      " New: ",
      this.teilnehmerControls[rowIndex][colIndex].value,
      " Valid: ",
      this.teilnehmerControls[rowIndex][colIndex].valid
    );
    this.updateTeilnehmer(rowIndex, colIndex);
  }

  change(rowIndex: any, colIndex: any) {
    this.updateTeilnahmen(rowIndex, colIndex);
  }

  changeMutation(rowIndex: any, colIndex: any) {
    this.updateMutationen(rowIndex, colIndex);
  }

  delete(event: any, row: any, rowIndex: any) {
    // console.log("click fired: ", event, " row: ", row, " rowIndex: ", rowIndex);
    const toBeDeleted = this.dataSource.getTeilnehmer(
      this.filterValue,
      this.tiTu,
      rowIndex
    );
    this.openDialog(toBeDeleted);
  }

  // Wenn Name oder Jahrgang geändert wird Wettkämpfe anzeigen, bei welchem das keine Rolle mehr spielt.
  // überprüfen, dass nur einzelne Buchstaben geändert werden, keine komplett neuen Namen.
  isChangesDisabled(anlass: IAnlass) {
    if (this.authService.isAdministrator()) {
      return false;
    }
    const nicht_offen = anlass.anzeigeStatus.hasStatus(
      AnzeigeStatusEnum.NOCH_NICHT_OFFEN
    );
    const closed = anlass.anzeigeStatus.hasStatus(
      AnzeigeStatusEnum.ERFASSEN_CLOSED
    );
    const verlaengert = anlass.anzeigeStatus.hasStatus(
      AnzeigeStatusEnum.VERLAENGERT
    );
    if (!nicht_offen) {
      if (!closed || verlaengert) {
        return false;
      }
    }
    return true;
  }

  private openDialog(toBeDeleted: ITeilnehmer) {
    const dialogRef = this.dialog.open(DeleteUser, {
      data: toBeDeleted,
    });

    dialogRef.afterClosed().subscribe((result) => {
      if (result) {
        this.dataSource
          .deleteTeilnehmer(this.authService.currentVerein, toBeDeleted)
          .subscribe((results) => {
            this.applyFilter(this.filterValue);
          });
      } else {
        console.log(`Abbrechen result: ${result}`);
      }
    });
  }
}
