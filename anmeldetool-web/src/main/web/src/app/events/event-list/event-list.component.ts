import { Component, EventEmitter, OnInit } from "@angular/core";
import { select, Store } from "@ngrx/store";
import { Observable, Subscription } from "rxjs";
import { IAnlass } from "src/app/core/model/IAnlass";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";
import { AnlassState } from "src/app/core/redux/anlass";
import { anlassFeature } from "src/app/core/redux/anlass/anlass.reducer";
import { AppState } from "src/app/core/redux/core.state";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";

@Component({
  selector: "app-event-list",
  templateUrl: "./event-list.component.html",
  styleUrls: ["./event-list.component.css"],
})
export class EventListComponent implements OnInit {
  anlaesse: IAnlass[];
  public anlaesse$!: Observable<AnlassState>;
  // localAdresseEmitter: EventEmitter<boolean>;
  loaded = false;
  // localObs: Observable<boolean>;
  //// localObs: BehaviorSubject<boolean>;
  subscription: Subscription[] = [];

  constructor(
    private store: Store<AppState> // private anlassService: CachingAnlassService
  ) {
    // this.localAdresseEmitter = new EventEmitter();
    // this.localObs = this.localAdresseEmitter.asObservable();

    // this.localObs = new BehaviorSubject(false);

    this.anlaesse$ = this.store.select(anlassFeature.name);
  }

  ngOnInit() {
    this.subscription.push(
      this.anlaesse$.subscribe((data) => {
        if (data) {
          this.anlaesse = data.items;
        }
      })
    );
  }

  /*
  get anlaesseLoaded(): Observable<boolean> {
    if (this.loaded) {
      console.log("Already loaded");
      this.localAdresseEmitter.emit(true);
    }
    return this.localObs;
  }
  */

  handleEventClicked(data) {
    console.log("received :", data);
  }

  ngOnDestroy(): void {
    this.subscription.forEach((s) => s.unsubscribe());
  }
}
