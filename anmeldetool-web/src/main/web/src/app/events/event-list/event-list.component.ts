import { Component, EventEmitter, OnInit } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { IEvent } from "../shared";
import { EventService } from "src/app/core/service/event/event.service";
import { ToastrService } from "src/app/core/service/toastr/toastr.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { BehaviorSubject, Observable, of, Subscription } from "rxjs";
import { IAnlass } from "src/app/core/model/IAnlass";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";

@Component({
  selector: "app-event-list",
  templateUrl: "./event-list.component.html",
  styleUrls: ["./event-list.component.css"],
})
export class EventListComponent implements OnInit {
  anlaesse: IAnlass[];
  localAdresseEmitter: EventEmitter<boolean>;
  loaded = false;
  localObs: Observable<boolean>;
  // localObs: BehaviorSubject<boolean>;

  constructor(
    private anlassService: CachingAnlassService,
    private toastrService: ToastrService,
    private router: ActivatedRoute
  ) {
    this.localAdresseEmitter = new EventEmitter();
    this.localObs = this.localAdresseEmitter.asObservable();
    // this.localObs = new BehaviorSubject(false);
  }

  ngOnInit() {
    console.log("TeilnehmerTableComponent:: ngOnInit: ", this.anlaesse);
    // this.events = this.router.snapshot.data.events;
    // this.events = this.eventService.getEvents().subscribe(events => {this.events = events; });
    let localSubscription2: Subscription = undefined;
    localSubscription2 = this.anlassService
      .loadAnlaesse()
      .subscribe((result) => {
        if (!result) {
          return;
        }
        this.anlaesse = this.anlassService.getAnlaesse(TiTuEnum.Alle);
        if (localSubscription2) {
          localSubscription2.unsubscribe();
        }
      });
    this.anlassService.isAnlaesseLoaded().subscribe((result) => {
      if (result) {
        console.log("now loaded");
        this.loaded = true;
        this.localAdresseEmitter.emit(true);
      }
    });
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

  handleThumbnailClick(eventName) {
    this.toastrService.success(eventName);
  }
}
