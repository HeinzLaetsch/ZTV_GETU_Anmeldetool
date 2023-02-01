import { Component, EventEmitter, OnInit } from "@angular/core";
import { select, Store } from "@ngrx/store";
import { Observable, Subscription } from "rxjs";
import { IAnlass } from "src/app/core/model/IAnlass";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";
import {
  AnlassActions,
  AnlassState,
  selectAllItems,
} from "src/app/core/redux/anlass";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";

@Component({
  selector: "app-event-list",
  templateUrl: "./event-list.component.html",
  styleUrls: ["./event-list.component.css"],
})
export class EventListComponent implements OnInit {
  anlaesse: ReadonlyArray<IAnlass>;
  public anlaesse$!: Observable<ReadonlyArray<IAnlass>>;
  localAdresseEmitter: EventEmitter<boolean>;
  loaded = false;
  localObs: Observable<boolean>;
  // localObs: BehaviorSubject<boolean>;

  constructor(
    private store: Store<AnlassState>,
    private anlassService: CachingAnlassService
  ) {
    this.localAdresseEmitter = new EventEmitter();
    this.localObs = this.localAdresseEmitter.asObservable();

    // this.localObs = new BehaviorSubject(false);
  }

  ngOnInit() {
    this.store.dispatch(AnlassActions.loadAllAnlaesse());
    this.anlaesse$ = this.store.pipe(select(selectAllItems));
    this.anlaesse$.subscribe((anlaesse) => (this.anlaesse = anlaesse));
    // this.anlaesse = this.anlassService.getAnlaesse(TiTuEnum.Alle);
    this.loaded = true;
  }

  get anlaesseLoaded(): Observable<boolean> {
    if (this.loaded) {
      console.log("Already loaded");
      this.localAdresseEmitter.emit(true);
    }
    return this.localObs;
  }

  handleEventClicked(data) {
    console.log("received :", data);
  }
}
