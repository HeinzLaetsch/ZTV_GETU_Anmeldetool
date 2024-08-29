import { Component, OnInit } from "@angular/core";
import { ActivatedRoute, Router } from "@angular/router";
import { select, Store } from "@ngrx/store";
import { Observable } from "rxjs";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IAnlassSummary } from "src/app/core/model/IAnlassSummary";
import { IOrganisationAnlassLink } from "src/app/core/model/IOrganisationAnlassLink";
import { ITeilnehmer } from "src/app/core/model/ITeilnehmer";
import { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { MeldeStatusEnum } from "src/app/core/model/MeldeStatusEnum";
import { selectAnlassById } from "src/app/core/redux/anlass";
import { AppState } from "src/app/core/redux/core.state";
import { AnlassService } from "src/app/core/service/anlass/anlass.service";
import { AuthService } from "src/app/core/service/auth/auth.service";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { CachingTeilnehmerService } from "src/app/core/service/caching-services/caching.teilnehmer.service";
import { SubscriptionHelper } from "src/app/utils/subscription-helper";

@Component({
  selector: "app-event-start-list",
  templateUrl: "./event-start-list.component.html",
  styleUrls: ["./event-start-list.component.css"],
})
export class EventStartListComponent
  extends SubscriptionHelper
  implements OnInit
{
  anlass: IAnlass;
  anlass$: Observable<IAnlass>;

  organisationAnlassLink: IOrganisationAnlassLink;
  alleTeilnehmer: ITeilnehmer[];

  anlassSummary: IAnlassSummary;

  constructor(
    public authService: AuthService,
    private store: Store<AppState>,

    private anlassService: AnlassService,
    //private anlassService: CachingAnlassService,
    private teilnehmerService: CachingTeilnehmerService,
    private route: ActivatedRoute
  ) {
    super();
  }

  ngOnInit() {
    const anlassId: string = this.route.snapshot.params.id;
    // console.log("url param: ", anlassId);
    this.anlass$ = this.store.pipe(select(selectAnlassById(anlassId)));
    this.registerSubscription(
      this.anlass$.subscribe((data) => {
        this.anlass = data;
        this.loadAnlassRelated();
      })
    );

    // this.anlass = this.anlassService.getAnlassById(anlassId);

    /*
    this.anlassService
      .getVereinStart(this.anlass, this.authService.currentVerein)
      .subscribe((result) => {
        this.organisationAnlassLink = result;
        this.anlass.erfassenVerlaengert = result.verlaengerungsDate;
      });
    */

    this.alleTeilnehmer = this.teilnehmerService.getTeilnehmerForAnlass(
      this.anlass
    );

    this.alleTeilnehmer.forEach((teilnehmer) => {
      if (teilnehmer.teilnahmen && teilnehmer.teilnahmen.anlassLinks[0]) {
        if (!teilnehmer.teilnahmen.anlassLinks[0].meldeStatus) {
          //TODO check
          teilnehmer.teilnahmen.anlassLinks[0].meldeStatus =
            MeldeStatusEnum.STARTET;
        }
      }
    });
  }

  private loadAnlassRelated() {
    this.registerSubscription(
      this.anlassService
        .getAnlassOrganisationSummary(
          this.anlass,
          this.authService.currentVerein
        )
        .subscribe((result) => {
          this.anlassSummary = result;
          console.log("Startet: ", result.startet);
        })
    );
  }

  print() {
    // this.angWindow.print();
    this.anlassService
      .getVereinAnmeldeKontrollePdf(this.anlass, this.authService.currentVerein)
      .subscribe((result) => {});
  }

  get titel(): string {
    return (
      this.anlass.getCleaned() + " - " + this.authService.currentVerein.name
    );
  }
  get vereinStarted(): boolean {
    // return this.organisationAnlassLink?.startet;
    return this.anlassSummary.startet;
  }

  get brevet1Anlass(): boolean {
    return this.anlass.tiefsteKategorie < KategorieEnum.K5;
  }

  get brevet2Anlass(): boolean {
    const br2 = this.anlass.hoechsteKategorie > KategorieEnum.K4;
    return br2;
  }

  get tuAnlass(): boolean {
    return this.anlass.tuAnlass;
  }

  get tiAnlass(): boolean {
    return this.anlass.tiAnlass;
  }

  get anzahlTeilnehmer(): number {
    return this.alleTeilnehmer?.length;
  }

  getTeilnahmenForKategorieK1(): ITeilnehmer[] {
    console.log("getK1 ", this.alleTeilnehmer);
    return this.alleTeilnehmer?.filter((teilnehmer) => {
      return teilnehmer.teilnahmen.anlassLinks[0].kategorie == KategorieEnum.K1;
    });
  }
  getTeilnahmenForKategorieK2(): ITeilnehmer[] {
    return this.alleTeilnehmer?.filter((teilnehmer) => {
      return teilnehmer.teilnahmen.anlassLinks[0].kategorie == KategorieEnum.K2;
    });
  }
  getTeilnahmenForKategorieK3(): ITeilnehmer[] {
    return this.alleTeilnehmer?.filter((teilnehmer) => {
      return teilnehmer.teilnahmen.anlassLinks[0].kategorie == KategorieEnum.K3;
    });
  }
  getTeilnahmenForKategorieK4(): ITeilnehmer[] {
    return this.alleTeilnehmer?.filter((teilnehmer) => {
      return teilnehmer.teilnahmen.anlassLinks[0].kategorie == KategorieEnum.K4;
    });
  }
  getTeilnahmenForKategorieK5(): ITeilnehmer[] {
    return this.alleTeilnehmer?.filter((teilnehmer) => {
      return teilnehmer.teilnahmen.anlassLinks[0].kategorie == KategorieEnum.K5;
    });
  }
  getTeilnahmenForKategorieK5A(): ITeilnehmer[] {
    return this.alleTeilnehmer?.filter((teilnehmer) => {
      return (
        teilnehmer.teilnahmen.anlassLinks[0].kategorie == KategorieEnum.K5A
      );
    });
  }
  getTeilnahmenForKategorieK5B(): ITeilnehmer[] {
    return this.alleTeilnehmer?.filter((teilnehmer) => {
      return (
        teilnehmer.teilnahmen.anlassLinks[0].kategorie == KategorieEnum.K5B
      );
    });
  }
  getTeilnahmenForKategorieK6(): ITeilnehmer[] {
    return this.alleTeilnehmer?.filter((teilnehmer) => {
      return teilnehmer.teilnahmen.anlassLinks[0].kategorie == KategorieEnum.K6;
    });
  }
  getTeilnahmenForKategorieKD(): ITeilnehmer[] {
    return this.alleTeilnehmer?.filter((teilnehmer) => {
      return teilnehmer.teilnahmen.anlassLinks[0].kategorie == KategorieEnum.KD;
    });
  }
  getTeilnahmenForKategorieKH(): ITeilnehmer[] {
    return this.alleTeilnehmer?.filter((teilnehmer) => {
      return teilnehmer.teilnahmen.anlassLinks[0].kategorie == KategorieEnum.KH;
    });
  }
  getTeilnahmenForKategorieK7(): ITeilnehmer[] {
    return this.alleTeilnehmer?.filter((teilnehmer) => {
      return teilnehmer.teilnahmen.anlassLinks[0].kategorie == KategorieEnum.K7;
    });
  }
}
