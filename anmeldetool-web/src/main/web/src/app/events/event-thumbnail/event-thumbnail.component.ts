import { Component, OnInit, Input, Output, EventEmitter } from '@angular/core';
import { IAnlass } from 'src/app/core/model/IAnlass';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { CachingAnlassService } from 'src/app/core/service/caching-services/caching.anlass.service';

@Component({
  selector: 'app-event-thumbnail',
  templateUrl: './event-thumbnail.component.html',
  styleUrls: ['./event-thumbnail.component.css']
})
export class EventThumbnailComponent implements OnInit {
  @Input() anlass: IAnlass;
  @Output() anlassClick = new EventEmitter();

  someProperty: any = 'some Text';
  vereinStarted: boolean;

  constructor(public authService: AuthService, private anlassService: CachingAnlassService) { }

  ngOnInit() {
    console.log("Anlass: ", this.anlass?.startDatum, ' , ' , this.anlass?.startDatum);
    this.anlassService
      .getVereinStart(this.anlass, this.authService.currentVerein)
      .subscribe((result) => {
        this.vereinStarted = result;
      });
  }

  handleClickMe() {
    this.anlassClick.emit(this.anlass.anlassBezeichnung);
  }

  vereinStartedClicked(event: PointerEvent) {
    console.log(event);
    event.cancelBubble = true;
    this.anlassService.updateVereinsStart(this.anlass, this.authService.currentVerein, !this.vereinStarted).subscribe(result => {
      console.log('Clicked: ', result);
    } );
  }

  get anzahlTeilnehmer(): number {
    if (this.anlassService.getTeilnehmer(this.anlass) && this.anlassService.getTeilnehmer(this.anlass).anlassLinks) {
      return this.anlassService.getTeilnehmer(this.anlass).anlassLinks.length;
    }
    return 0;
  }

  get statusWertungsrichter(): string {
    return 'nicht komplett';
  }

  getName(): string {
    console.log('From thumbnail :', this.anlass.anlassBezeichnung);
    return this.anlass.anlassBezeichnung;
  }

  getStartTimeClass() {
    const isGreen = false; // this.anlass.startDatum === Date.now();
    return {green: isGreen  , bold: isGreen};
  }
}