import { Component, EventEmitter, Input, OnInit, Output } from "@angular/core";
import { IAnlass } from "src/app/core/model/IAnlass";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";

@Component({
  selector: "app-event-thumbnail",
  templateUrl: "./event-thumbnail.component.html",
  styleUrls: ["./event-thumbnail.component.css"],
})
export class EventThumbnailComponent implements OnInit {
  @Input() anlass: IAnlass;
  @Output() anlassClick = new EventEmitter();

  someProperty: any = "some Text";
  vereinStarted: boolean;
  anzahlTeilnehmer: number;

  constructor(
    public authService: AuthService,
    private anlassService: CachingAnlassService
  ) {}

  ngOnInit() {
    console.log(
      "Anlass: ",
      this.anlass?.id,
      " , ",
      this.anlass?.anlassBezeichnung,
      " , ",
      this.anlass?.startDatum,
      " , ",
      this.anlass?.startDatum
    );
    this.anlassService
      .getVereinStart(this.anlass, this.authService.currentVerein)
      .subscribe((result) => {
        this.vereinStarted = result;
      });
    this.anzahlTeilnehmer = 0;
    this.anlassService
      .loadTeilnahmen(this.anlass, this.authService.currentVerein, true)
      .subscribe((result) => {
        if (result) {
          const links = this.anlassService.getTeilnehmerForAnlass(this.anlass);
          if (links) {
            if (links.anlassLinks)
              this.anzahlTeilnehmer = links.anlassLinks.length;
          }
        }
      });
  }

  getStartedClass() {
    if (!this.vereinStarted) {
      return { redNoMargin: true };
    } else {
      return { greenNoMargin: true };
    }
  }

  getTeilnehmerClass() {
    if (this.anzahlTeilnehmer === 0) {
      return { redNoMargin: true };
    } else {
      return { greenNoMargin: true };
    }
  }
  getWertungsrichterClass() {
    if (this.anzahlTeilnehmer !== 0) {
      return { redNoMargin: true };
    } else {
      return { greenNoMargin: true };
    }
  }
  handleClickMe() {
    this.anlassClick.emit(this.anlass.anlassBezeichnung);
  }

  vereinStartedClicked(event: PointerEvent) {
    console.log(event);
    event.cancelBubble = true;
    this.anlassService
      .updateVereinsStart(
        this.anlass,
        this.authService.currentVerein,
        !this.vereinStarted
      )
      .subscribe((result) => {
        console.log("Clicked: ", result);
      });
  }

  get statusWertungsrichter(): string {
    return "nicht komplett";
  }

  getCleaned(): string {
    return this.anlass.anlassBezeichnung.replace("%", "");
  }

  getStartTimeClass() {
    const isGreen = false; // this.anlass.startDatum === Date.now();
    return { green: isGreen, bold: isGreen };
  }
}
