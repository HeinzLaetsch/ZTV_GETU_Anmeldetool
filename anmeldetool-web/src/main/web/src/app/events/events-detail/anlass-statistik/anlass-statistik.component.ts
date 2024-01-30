import { Component, Input, OnInit } from "@angular/core";
import { Store } from "@ngrx/store";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IAnlassSummary } from "src/app/core/model/IAnlassSummary";
import { AppState } from "src/app/core/redux/core.state";
import { AnlassService } from "src/app/core/service/anlass/anlass.service";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { AnzeigeStatusEnum } from "src/app/core/model/AnzeigeStatusEnum";
import { Observable } from "rxjs";

@Component({
  selector: "app-anlass-statistik",
  templateUrl: "./anlass-statistik.component.html",
  styleUrls: ["./anlass-statistik.component.css"],
})
export class AnlassStatistikComponent implements OnInit {
  @Input()
  anlass: IAnlass;

  anlassSummary: IAnlassSummary;
  anlassSummary$: Observable<IAnlassSummary>;

  constructor(
    public authService: AuthService,
    private store: Store<AppState>,
    private anlassService: AnlassService
  ) {}
  ngOnInit() {
    this.anlassSummary$ = this.anlassService.getAnlassOrganisationSummary(
      this.anlass,
      this.authService.currentVerein
    );

    this.anlassSummary$.subscribe((result) => {
      this.anlassSummary = result;
      this.anlassSummary.startendeK2 = result.startendeK2;
    });
  }
  isStartedCheckboxDisabled(): boolean {
    if (
      !this.anlass.anzeigeStatus.hasStatus(AnzeigeStatusEnum.NOCH_NICHT_OFFEN)
    ) {
      if (
        !this.anlass.anzeigeStatus.hasStatus(AnzeigeStatusEnum.ERFASSEN_CLOSED)
      ) {
        return false;
      }
    }
    return true;
  }

  vereinStartedClicked(check: boolean) {
    /*
    this.store.dispatch(
      OalActions.updateVereinsStartInvoked({ payload: this.orgAnlassLink })
    );
    */
  }

  isTuAnlass(): boolean {
    return this.anlass.tuAnlass;
  }
  isTiAnlass(): boolean {
    return this.anlass.tiAnlass;
  }
  isBrevet1Anlass(): boolean {
    // console.log("Brevet 1: ", this.anlass.tiefsteKategorie <= KategorieEnum.K4);
    return this.anlass.brevet1Anlass;
  }
  isBrevet2Anlass(): boolean {
    // console.log("Brevet 2: ", this.anlass.hoechsteKategorie > KategorieEnum.K4);
    return this.anlass.brevet2Anlass;
  }
}
