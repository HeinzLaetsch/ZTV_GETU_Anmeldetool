import { Component, Input, OnInit } from "@angular/core";
import { Store } from "@ngrx/store";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IAnlassSummary } from "src/app/core/model/IAnlassSummary";
import { AppState } from "src/app/core/redux/core.state";
import { AnlassService } from "src/app/core/service/anlass/anlass.service";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { OalActions } from "src/app/core/redux/organisation-anlass";
import { AnzeigeStatusEnum } from "src/app/core/model/AnzeigeStatusEnum";

@Component({
  selector: "app-anlass-statistik",
  templateUrl: "./anlass-statistik.component.html",
  styleUrls: ["./anlass-statistik.component.css"],
})
export class AnlassStatistikComponent implements OnInit {
  @Input()
  anlass: IAnlass;

  anlassSummary: IAnlassSummary;

  constructor(
    public authService: AuthService,
    private store: Store<AppState>,
    private anlassService: AnlassService
  ) {}
  ngOnInit() {
    this.anlassService
      .getAnlassOrganisationSummary(this.anlass, this.authService.currentVerein)
      .subscribe((result) => {
        this.anlassSummary = result;
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
}
