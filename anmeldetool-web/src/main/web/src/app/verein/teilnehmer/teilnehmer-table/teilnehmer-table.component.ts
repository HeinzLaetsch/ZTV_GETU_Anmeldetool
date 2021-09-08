import { ThrowStmt } from "@angular/compiler";
import {
  AfterViewInit,
  Component,
  OnInit,
  ViewChild,
  Output,
  EventEmitter,
  Input,
} from "@angular/core";
import {
  FormBuilder,
  FormControl,
  FormGroup,
  Validators,
} from "@angular/forms";
import { MatPaginator, PageEvent } from "@angular/material/paginator";
import { MatSort } from "@angular/material/sort";
import { Observable, Subscription } from "rxjs";
import { TeilnehmerDataSource } from "src/app/core/datasource/TeilnehmerDataSource";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IAnlassLink } from "src/app/core/model/IAnlassLink";
import { ITeilnehmer } from "src/app/core/model/ITeilnehmer";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";
import { AnlassService } from "src/app/core/service/anlass/anlass.service";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { CachingTeilnehmerService } from "src/app/core/service/caching-services/caching.teilnehmer.service";
import { CachingVereinService } from "src/app/core/service/caching-services/caching.verein.service";
import { IVerein } from "../../verein";
import { IStart } from "../starts";

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
export class TeilnehmerTableComponent implements OnInit, AfterViewInit {
  @Input()
  tiTu: TiTuEnum;

  populating = true;
  checked: Array<boolean>;

  // teilnahmenControls = new Array<Array<TeilnahmeControl>>();
  teilnahmenControls = new Array<Array<FormControl>>();
  teilnehmerControls = new Array<Array<FormControl>>();
  check1 = new FormControl();
  pageSize = 15;

  options: string[] = [
    "keine Teilnahme",
    "K1",
    "K2",
    "K3",
    "K4",
    "K5",
    "K6",
    "K7",
    "KD",
  ];

  allDisplayedColumns: string[];
  displayedColumns = ["name", "vorname", "jahrgang"];
  dataSource: TeilnehmerDataSource;
  vereine: IVerein[];
  anlaesse: IAnlass[];
  _startsChanges: IStart[];

  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;

  constructor(
    public authService: AuthService,
    private teilnehmerService: CachingTeilnehmerService,
    private vereinService: CachingVereinService,
    private anlassService: CachingAnlassService
  ) {
    // Assign the data to the data source for the table to render
    this.dataSource = new TeilnehmerDataSource(
      this.teilnehmerService,
      this.authService.currentVerein
    );
    this._startsChanges = new Array<IStart>();

    let localSubscription1: Subscription = undefined;
    localSubscription1 = this.vereinService
      .loadVereine()
      .subscribe((result) => {
        this.vereine = this.vereinService.getVereine();
        console.log(
          "TeilnehmerTableComponent:: constructor Vereine: ",
          this.vereine
        );
        if (localSubscription1) {
          localSubscription1.unsubscribe();
        }
      });
  }

  public resetDataSource() {
    console.log("resetDataSource");
    this.dataSource.reset(this.authService.currentVerein);
    // this.dataSource.getTotal(this.authService.currentVerein).subscribe( anzahl => this.paginator.length = anzahl);
    this.paginator.firstPage();
  }

  get isTeilnahmenLoaded(): Observable<boolean> {
    // console.log('TeilnehmerComponent::isTeilnehmerLoaded')
    return this.anlassService.isTeilnahmenLoaded();
  }

  getKategorien(anlass: IAnlass): String[] {
    const tiefste = anlass.tiefsteKategorie;
    const hoechste = anlass.hoechsteKategorie;
    let kd = Object.keys(KategorieEnum).findIndex(
      (key) => key === KategorieEnum.KD
    );
    const start = Object.keys(KategorieEnum).findIndex(
      (key) => key === anlass.tiefsteKategorie
    );
    let end = Object.keys(KategorieEnum).findIndex(
      (key) => key === anlass.hoechsteKategorie
    );
    let filtered = Object.values(KategorieEnum).slice(0, 1);
    if (end > kd) {
      filtered = filtered.concat(Object.values(KategorieEnum).slice(start, kd));
      if (this.tiTu === TiTuEnum.Ti) {
        filtered.push(KategorieEnum.KD);
      } else {
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

  public addNewTeilnehmer() {
    console.log("addNewTeilnehmer");
    this.dataSource
      .add(this.authService.currentVerein)
      .subscribe((teilnehmer) => {
        console.log("Teilnehmer added: ", teilnehmer);
        this.paginator.lastPage();
        this.loadTeilnehmerPage();
      });
  }
  public saveTeilnehmer() {
    console.log("saveTeilnehmer");
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
    this.dataSource
      .saveAll(this.authService.currentVerein)
      .subscribe((results) => {
        console.log("result of SaveAll: ", results);
      });
  }

  getControl(row: number, col: number): FormControl {
    let control: FormControl = undefined;
    if (col !== 2) {
      control = new FormControl(row + ":", [
        Validators.minLength(2),
        Validators.required,
        Validators.pattern(
          "[a-zA-Z -_.\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u00FF]*"
        ),
      ]);
    } else {
      control = new FormControl(row + ":", [
        Validators.minLength(4),
        Validators.required,
        Validators.pattern("[1,2][0-9]*"),
      ]);
    }
    return control;
  }
  private teilnahmenloader(anlass: IAnlass, isLast: boolean): void {
    this.anlassService
      .loadTeilnahmen(anlass, this.authService.currentVerein, isLast)
      .subscribe((result) => {
        console.log(
          "Teilnahme loaded: ",
          anlass.anlassBezeichnung,
          "Result: ",
          result
        );
        if (result) {
          this.fillTeilnahmenControls(anlass);
        }
      });
  }
  ngOnInit(): void {
    let localSubscription2: Subscription = undefined;
    localSubscription2 = this.anlassService
      .loadAnlaesse()
      .subscribe((result) => {
        if (!result) {
          return;
        }
        this.anlaesse = this.anlassService.getAnlaesse();
        // console.log("TeilnehmerTableComponent:: ngOnInit: ", this.anlaesse);
        if (localSubscription2) {
          localSubscription2.unsubscribe();
        }
        let colIndex = 0;
        let currentAnlass = 0;
        this.checked = new Array();

        this.anlaesse.forEach((anlass) => {
          // console.log("Prepare Anlass: ", anlass);
          this.anlassService
            .getVereinStart(anlass, this.authService.currentVerein)
            .subscribe((result) => {
              console.log("getVereinStart Result is: ", result);
              this.checked.push(result);
              // this.checkForIndex(colIndex++, result);
              this.teilnahmenControls.forEach((line) => {
                const cntr = new FormControl({
                  value: this.options[3],
                  disabled: true,
                });
                line.push(cntr);
              });
              const isLast = currentAnlass++ === this.anlaesse.length - 1;
              this.teilnahmenloader(anlass, isLast);
            });

        });
        this.allDisplayedColumns = this.displayedColumns.map((col) => col);
        this.anlaesse.forEach((anlass) => {
          this.allDisplayedColumns.push(anlass.anlassBezeichnung);
          this.allDisplayedColumns.push(anlass.anlassBezeichnung + "Btn");
        });
        this.allDisplayedColumns.pop();
        this.allDisplayedColumns.push("aktion");

        let anzahlControls = this.pageSize;
        for (let i = 0; i <= anzahlControls; i++) {
          const teilnehmerLineControls = new Array<FormControl>();
          teilnehmerLineControls.push(this.getControl(i, 0));
          teilnehmerLineControls.push(this.getControl(i, 1));
          teilnehmerLineControls.push(this.getControl(i, 2));
          this.teilnehmerControls.push(teilnehmerLineControls);

          const lineControls = new Array<FormControl>();
          this.teilnahmenControls.push(lineControls);
        }
        this.loadTeilnehmerPage();
      });
  }

  fillTeilnahmenControls(anlassOrg: IAnlass) {
    let teilnehmerPos = 0;
    this.teilnahmenControls.forEach((line) => {
      let pos = 0;
      console.log("Line: ", line);
      this.anlaesse.forEach((anlass) => {
        // Lokale Variable (für was ??) die für jeden Anlass/Teilnehmer die Kategorie speichert
        // Mit Resolver sperren ???
        // console.log("Before: " , anlass.anlassBezeichnung , ", Line :", teilnehmerPos, "/", pos, " Pos: ", line[pos].value);
        if (anlassOrg === anlass) {
          const teilnehmerKategorie = new Array<string>();
            const link = this.getTeilnahme(teilnehmerPos, anlass);
            console.log("Old Line :", teilnehmerPos, "/", pos, " Pos: ", line[pos].value);
            line[pos].setValue(link?.kategorie);
            if (this.checked[pos]) {
              line[pos].enable();
            }
            console.log("New Line :", teilnehmerPos, "/", pos, " Pos: ", line[pos].value);
        }
        pos++;
      });
      teilnehmerPos++;
    });
  }

  getTeilnahme(teilnehmerRecord: number, anlass: IAnlass): IAnlassLink {
    const teilnehmer = this.anlassService.getTeilnehmer(anlass);
    if (teilnehmer) {
      const tr = this.dataSource.getTeilnehmer(teilnehmerRecord);
      if (tr) {
        const link = teilnehmer.anlassLinks.find((value) => {
          console.log("Teilnahme: ", value.teilnehmerId, "Current: ", tr.id);
          return value.teilnehmerId === tr.id;
        });
        return link;
        // return element.teilnehmerId === tr.id
      }
      return undefined;
    }
    console.log("Teilnehmer yet not Loaded: ", anlass.anlassBezeichnung);
    return undefined;
  }

  private checkForIndex(colIndex: number, check: boolean) {
    // console.log("Clicked: ", colIndex, ", ", check);
    this.checked[colIndex] = check;

    let anzahlControls = this.pageSize;
    for (let i = 0; i <= anzahlControls; i++) {
      if (this.checked[colIndex]) {
        this.teilnahmenControls[i][colIndex].enable();
      } else {
        this.teilnahmenControls[i][colIndex].disable();
      }
    }
  }

  checkedClicked(event: any, colIndex: any) {
    this.checkForIndex(colIndex, event.checked);
    console.log("Clicked: ", colIndex, ", ", event);
    const newStart: IStart = {
      anlass: this.anlaesse[colIndex],
      start: event.checked,
    };
    let start = this._startsChanges.find(
      (start) => start.anlass.id === newStart.anlass.id
    );
    if (start) {
      start.start = newStart.start;
    } else {
      this._startsChanges.push(newStart);
      start = newStart;
    }
    this.anlassService
      .updateVereinsStart(
        start.anlass,
        this.authService.currentVerein,
        start.start
      )
      .subscribe((response) => {
        console.log("VereinsStart updated");
      });
  }
  /**
   * Set the paginator and sort after the view init since this component will
   * be able to query its view for the initialized paginator and sort.
   */
  ngAfterViewInit() {
    this.dataSource.paginator = this.paginator;
    this.dataSource.sort = this.sort;
    this.paginator.page
      /*
      .pipe(
        tap(() => {
          this.checkIfDirty();
          this.loadTeilnehmerPage();
        })
      )*/
      .subscribe((pageEvent) => {
        this.checkIfDirty(pageEvent);
        console.log("PageEvent: ", pageEvent);
      });
    // this.paginator.length = this.dataSource.getTotal();
  }
  checkIfDirty(pageEvent: PageEvent) {
    let row = 0;
    this.teilnehmerControls.forEach((teilnehmerLine) => {
      let col = 0;
      teilnehmerLine.forEach((control) => {
        if (control.dirty) {
          console.log("Control dirty: ", row, ", ", col);
          this.dataSource.update(row, col, control.value);
          //control.reset();
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
    console.log("Load Teilnehmer Page");
    this.dataSource.loading$.subscribe((result) => {
      this.populateTeilnehmer(this.dataSource.loadTeilnehmer());
    });
  }
  populateTeilnehmer(allTeilnehmer: ITeilnehmer[]) {
    let i = 0;
    this.populating = true;
    allTeilnehmer.forEach((teilnehmer) => {
      console.log("populateTeilnehmer");
      this.teilnehmerControls[i][0].setValue(teilnehmer.name);
      this.teilnehmerControls[i][1].setValue(teilnehmer.vorname);
      this.teilnehmerControls[i][2].setValue(teilnehmer.jahrgang);
      i++;
    });
    this.populating = false;
  }
  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // Datasource defaults to lowercase matches
    this.dataSource.filter = filterValue;
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
    this.teilnahmenControls[rowIndex][colIndex + 1].setValue(this.teilnahmenControls[rowIndex][colIndex].value)
    this.updateTeilnahmen(rowIndex, colIndex+1);
  }
  copyAll(event: any, colIndex: any) {
    let rowIndex = 0;
    this.teilnahmenControls.forEach( anlassCntrLine => {
      anlassCntrLine[colIndex + 1].setValue(anlassCntrLine[colIndex].value);
      this.updateTeilnahmen(rowIndex, colIndex+1);
      rowIndex++;
    })
    console.log("Copy All clicked: ", event, " ,colIndex: ", colIndex);
  }
  vchange(rowIndex: number, colIndex: number, value: any) {
    console.log("Value Change fired: ", value);
  }


  private updateTeilnahmen(rowIndex: any, colIndex: any) {
    const anlass = this.anlaesse[colIndex];
    this.dataSource.valid = this.teilnahmenControls[rowIndex][colIndex].valid;
    this.dataSource.updateTeilnahme(
      rowIndex,
      colIndex,
      this.teilnahmenControls[rowIndex][colIndex].value,
      anlass
    );
    this.dataSource.dirty = true;
  }

  private updateTeilnehmer(rowIndex: any, colIndex: any) {
    this.dataSource.valid = this.teilnehmerControls[rowIndex][colIndex].valid;
    this.dataSource.update(
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
    /*
    this.dataSource.valid = this.teilnehmerControls[rowIndex][colIndex].valid;
    this.dataSource.update(
      rowIndex,
      colIndex,
      this.teilnehmerControls[rowIndex][colIndex].value
    );
    this.dataSource.dirty = true;
    */
  }

  change(
    event: any,
    teilnehmer: boolean,
    row: any,
    rowIndex: any,
    colIndex: any,
    anlass: IAnlass
  ) {
    this.updateTeilnahmen(rowIndex, colIndex);
    /*
    this.dataSource.valid = this.teilnahmenControls[rowIndex][colIndex].valid;
    this.dataSource.updateTeilnahme(rowIndex, colIndex, event.value, anlass);
    this.dataSource.dirty = true;
    */
  }
  delete(event: any, row: any, rowIndex: any) {
    console.log("click fired: ", event, " row: ", row, " rowIndex: ", rowIndex);
  }
}
