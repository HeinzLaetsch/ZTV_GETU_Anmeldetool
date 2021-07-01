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
import { FormBuilder, FormControl, FormGroup, Validators } from "@angular/forms";
import { MatPaginator, PageEvent } from "@angular/material/paginator";
import { MatSort } from "@angular/material/sort";
import { Subscription } from "rxjs";
import { TeilnehmerDataSource } from "src/app/core/datasource/TeilnehmerDataSource";
import { IAnlass } from "src/app/core/model/IAnlass";
import { ITeilnehmer } from "src/app/core/model/ITeilnehmer";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { CachingTeilnehmerService } from "src/app/core/service/caching-services/caching.teilnehmer.service";
import { CachingVereinService } from "src/app/core/service/caching-services/caching.verein.service";
import { IVerein } from "../../verein";
import { IChangeEvent } from "../change-event";
import { IStart } from "../starts";

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
  /*
  anlaesse: IAnlass[] = [
    { id: "1", name: "Frühlings wettkampf Ti 14.7.21" },
    { id: "2", name: "Geräteturnerinnen tag 14.7.21" },
    { id: "3", name: "Gerätewettkampf Ti 14.7.21" },
    { id: "4", name: "Kant. Geräteturn meisterschaften 14.7.21" },
  ];
*/

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
    this.dataSource = new TeilnehmerDataSource(this.teilnehmerService, this.authService.currentVerein);
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

  getKategorien(anlass: IAnlass): String[] {
    const tiefste = anlass.tiefsteKategorie;
    const hoechste = anlass.hoechsteKategorie;
    let kd = Object.keys(KategorieEnum).findIndex( key => key === KategorieEnum.KD);
    const start = Object.keys(KategorieEnum).findIndex( key => key === anlass.tiefsteKategorie);
    let end = Object.keys(KategorieEnum).findIndex( key => key === anlass.hoechsteKategorie);
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
      filtered = filtered.concat(Object.values(KategorieEnum).slice(start, end+1));
    }
    return filtered;
  }
  get anzahlTeilnehmer(): number {
    return 0;
  }

  public addNewTeilnehmer() {
    console.log("addNewTeilnehmer");
    this.dataSource.add(this.authService.currentVerein).subscribe( teilnehmer => {
      console.log('Teilnehmer added: ' , teilnehmer);
      this.paginator.lastPage();
      this.loadTeilnehmerPage();
  });
    // this.paginator.length++; // = this.dataSource.getTotal();
    // console.log("added NewTeilnehmer: ", this.paginator.length, ', from Service: ', this.dataSource.getTotal());
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
    this.dataSource.saveAll(this.authService.currentVerein).subscribe(results => {
      console.log('result of SaveAll: ', results);
    });
  }

  getControl(row: number, col: number): FormControl {
    let control = undefined;
    if (col !== 2) {
      control = new FormControl(row + ":", [Validators.minLength(2), Validators.required, Validators.pattern('[a-zA-Z ]*')]);
    } else {
      control = new FormControl(row + ":", [Validators.minLength(4), Validators.required, Validators.pattern('[1,2][0-9]*')]);
    }
    control.valueChanges.subscribe((value) => {
      if (!this.populating) {
        console.log("Emit Event: ", control);
        /*
        const event: IChangeEvent = {
          colIndex: col,
          rowIndex: row,
          dirty: control.dirty,
          error: !! control.errors
        }
        this.status.emit(event);
        */
       //   change(event: any, row: any, rowIndex: any, colIndex: any)
       this.change(undefined, value, row, col);
      }
    });
    return control;
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
        console.log("TeilnehmerTableComponent:: ngOnInit: ", this.anlaesse);
        if (localSubscription2) {
          localSubscription2.unsubscribe();
        }
        let colIndex = 0;
        this.checked = new Array();
        this.anlaesse.forEach((anlass) => {
          this.anlassService
            .getVereinStart(anlass, this.authService.currentVerein)
            .subscribe((result) => {
              // console.log("getVereinStart Result is: ", result);
              this.checked.push(result);
              this.checkForIndex(colIndex++, result);
            });
        });
        this.allDisplayedColumns = this.displayedColumns.map((col) => col);
        this.anlaesse.forEach((anlass) => {
          this.allDisplayedColumns.push(anlass.anlassBezeichnung);
          this.allDisplayedColumns.push(anlass.anlassBezeichnung + "Btn");
        });
        this.allDisplayedColumns.pop();
        this.allDisplayedColumns.push("aktion");
        //     });
        //    this.anlassService.isAnlaesseLoaded().subscribe((result) => {
        //      console.log('Anlässe loadded: ', result);
        //      if (!result) {
        //        return;
        //      }
        // this.myForm = this.formBuilder.group();
        let anzahlControls = this.pageSize;
        for (let i = 0; i <= anzahlControls; i++) {
          const teilnehmerLineControls = new Array<FormControl>();
          teilnehmerLineControls.push(this.getControl(i, 0));
          teilnehmerLineControls.push(this.getControl(i, 1));
          teilnehmerLineControls.push(this.getControl(i, 2));
          this.teilnehmerControls.push(teilnehmerLineControls);

          const lineControls = new Array<FormControl>();
          this.teilnahmenControls.push(lineControls);
          let pos = 0;
          this.anlaesse.forEach((anlass) => {
            if (!this.checked[pos]) {
              const cntr = new FormControl({
                value: this.options[0],
                disabled: this.checked[pos],
              })
            lineControls.push(cntr);
            } else {
              const cntr = new FormControl({
                value: i + ":" + anlass.anlassBezeichnung.slice(0, 5),
                disabled: this.checked[pos],
              })
            lineControls.push(cntr);
            }
            pos++;
          });
        }
        this.loadTeilnehmerPage();
      });
  }

  /*
  get anzahlTeilnehmer(): number {
    return this.dataSource.getTotal();
  }
  */
  private checkForIndex(colIndex: number, check: boolean) {
    // console.log("Clicked: ", colIndex, ", ", check);
    this.checked[colIndex] = check;

    let anzahlControls = this.pageSize;
    for (let i = 0; i <= anzahlControls; i++) {
      if (this.checked[colIndex]) {
        this.teilnahmenControls[i][colIndex].enable();
      } else {
        this.teilnahmenControls[i][colIndex].disable();
        this.teilnahmenControls[i][colIndex].setValue(this.options[0]);
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
    this.anlassService.updateVereinsStart(
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
    this.dataSource.loading$.subscribe( result =>  {
      this.populateTeilnehmer(this.dataSource.loadTeilnehmer());
    });
    /*
    this.dataSource
      .loadTeilnehmer(this.authService.currentVerein, "")
      .subscribe((allTeilnehmer) => {
        console.log("All Teilnehmer: ", allTeilnehmer);
        this.populateTeilnehmer(allTeilnehmer);
        // this.paginator.length = this.dataSource.getTotal();
      });
      */
  }
  populateTeilnehmer(allTeilnehmer: ITeilnehmer[]) {
    let i = 0;
    this.populating = true;
    allTeilnehmer.forEach((teilnehmer) => {
      console.log("populateTeilnehmer");
      this.teilnehmerControls[i][0].setValue(teilnehmer.name);
      this.teilnehmerControls[i][1].setValue(teilnehmer.vorname);
      this.teilnehmerControls[i][2].setValue(teilnehmer.jahrgang);
      /*
      const event: IChangeEvent = {
        colIndex: 0,
        rowIndex: i,
        dirty: false,
        error: false,
      }
      this.status.emit(event);
      */
      i++;
    });
    this.populating = false;
  }
  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // Datasource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
  copy(event: any, row: any, colIndex: any) {
    console.log(
      "Copy clicked: ",
      event,
      " row: ",
      row,
      " ,colIndex: ",
      colIndex
    );
  }
  copyAll(event: any, colIndex: any) {
    console.log("Copy All clicked: ", event, " ,colIndex: ", colIndex);
  }
  vchange(rowIndex: number, colIndex: number, value: any) {
    console.log("Value Change fired: ", value);
  }
  // row, rowIndex, 2
  change(event: any, teilnehmer: boolean, row: any, rowIndex: any, colIndex: any) {
    if (teilnehmer) {
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
    // pageEvent: PageEvent, row: number, col: number, value: any
    this.dataSource.valid = this.teilnehmerControls[rowIndex][colIndex].valid;
    this.dataSource.update(rowIndex, colIndex, this.teilnehmerControls[rowIndex][colIndex].value);
    } else {
    this.dataSource.valid = this.teilnahmenControls[rowIndex][colIndex].valid;
    this.dataSource.update(rowIndex, colIndex, this.teilnahmenControls[rowIndex][colIndex].value);
    }
    this.dataSource.dirty = true;
  }
  delete(event: any, row: any, rowIndex: any) {
    console.log("click fired: ", event, " row: ", row, " rowIndex: ", rowIndex);
  }
}
