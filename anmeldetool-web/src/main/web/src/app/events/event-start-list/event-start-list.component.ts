import { Component, type OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { select, Store } from '@ngrx/store';
import moment from 'moment';
import type { Observable } from 'rxjs';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { IAnlassSummary } from 'src/app/core/model/IAnlassSummary';
import type { IOrganisationAnlassLink } from 'src/app/core/model/IOrganisationAnlassLink';
import type { ITeilnahmen } from 'src/app/core/model/ITeilnahmen';
import { KategorieEnum } from 'src/app/core/model/KategorieEnum';
import { selectAnlassById } from 'src/app/core/redux/anlass';
import { selectAnlassSummaryByAnlassId } from 'src/app/core/redux/anlass-summary';
import type { AppState } from 'src/app/core/redux/core.state';
import { selectTeilnahmenByAnlassId, TeilnahmenActions } from 'src/app/core/redux/teilnahmen';
import { AnlassService } from 'src/app/core/service/anlass/anlass.service';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { SubscriptionHelper } from 'src/app/utils/subscription-helper';

@Component({
  selector: 'lxt-event-start-list',
  templateUrl: './event-start-list.component.html',
  styleUrls: ['./event-start-list.component.css'],
  standalone: true,
})
export class EventStartListComponent extends SubscriptionHelper implements OnInit {
  anlass: IAnlass;
  anlass$: Observable<IAnlass>;
  teilnahmen$: Observable<ITeilnahmen[]>;

  organisationAnlassLink: IOrganisationAnlassLink;
  alleTeilnahmen: ITeilnahmen[];

  anlassSummary: IAnlassSummary;

  constructor(
    public authService: AuthService,
    private store: Store<AppState>,

    private anlassService: AnlassService,
    //private anlassService: CachingAnlassService,
    // private teilnehmerService: CachingTeilnehmerService,
    private route: ActivatedRoute,
  ) {
    super();
    this.store.dispatch(TeilnahmenActions.loadAllTeilnahmenInvoked({ payload: moment().year() }));
  }

  ngOnInit() {
    const anlassId: string = this.route.snapshot.params.id;
    // console.log("url param: ", anlassId);
    this.anlass$ = this.store.pipe(select(selectAnlassById(anlassId)));
    this.registerSubscription(
      this.anlass$.subscribe((data) => {
        this.anlass = data;
        this.loadAnlassRelated(anlassId);
      }),
    );

    // Eventuell eine Ebene höher

    // this.anlass = this.anlassService.getAnlassById(anlassId);

    /*
    this.anlassService
      .getVereinStart(this.anlass, this.authService.currentVerein)
      .subscribe((result) => {
        this.organisationAnlassLink = result;
        this.anlass.erfassenVerlaengert = result.verlaengerungsDate;
      });
    */
    this.teilnahmen$ = this.store.pipe(select(selectTeilnahmenByAnlassId(anlassId)));

    this.registerSubscription(
      this.teilnahmen$.subscribe((data) => {
        this.alleTeilnahmen = data;
      }),
    );

    /*
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
    */
  }

  private loadAnlassRelated(anlassId: string) {
    this.registerSubscription(
      this.store.pipe(select(selectAnlassSummaryByAnlassId(anlassId))).subscribe((data) => {
        this.anlassSummary = data;
      }),
      /*
      this.anlassService
        .getAnlassOrganisationSummary(
          this.anlass,
          this.authService.currentVerein
        )
        .subscribe((result) => {
          this.anlassSummary = result;
          console.log("Startet: ", result.startet);
        })
        */
    );
  }

  print() {
    // this.angWindow.print();
    this.anlassService
      .getVereinAnmeldeKontrollePdf(this.anlass, this.authService.currentVerein)
      .subscribe((result) => {});
  }

  get titel(): string {
    return this.anlass.getCleaned() + ' - ' + this.authService.currentVerein.name;
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
    return this.alleTeilnahmen?.length;
  }

  private sortBy(a: ITeilnahmen, b: ITeilnahmen): number {
    if (
      a.talDTOList[0] == null ||
      a.talDTOList[0].abteilung == null ||
      a.talDTOList[0].anlage == null ||
      a.talDTOList[0].startgeraet == null ||
      b.talDTOList[0] == null ||
      b.talDTOList[0].abteilung == null ||
      b.talDTOList[0].anlage == null ||
      b.talDTOList[0].startgeraet == null
    ) {
      return 0;
    }

    const tituComparison = a.teilnehmer.tiTu.localeCompare(b.teilnehmer.tiTu);
    if (tituComparison !== 0) {
      return tituComparison;
    }
    if (a.talDTOList[0].abteilung && b.talDTOList[0].abteilung) {
      const abtComparison = a.talDTOList[0].abteilung.localeCompare(b.talDTOList[0].abteilung);
      if (abtComparison !== 0) {
        return abtComparison;
      }
      const anlComparison = a.talDTOList[0].anlage.localeCompare(b.talDTOList[0].anlage);
      if (anlComparison !== 0) {
        return anlComparison;
      }
      const startComparison = a.talDTOList[0].startgeraet.localeCompare(b.talDTOList[0].startgeraet);
      if (startComparison !== 0) {
        return startComparison;
      }
    }
    return a.teilnehmer.name.localeCompare(b.teilnehmer.name);
  }

  getTeilnahmenForKategorieK1(): ITeilnahmen[] {
    //console.log("getK1 ", this.alleTeilnahmen);
    return this.alleTeilnahmen
      ?.filter((teilnahme) => {
        console.log('filter: ', teilnahme.talDTOList[0].kategorie);
        return teilnahme.talDTOList[0].kategorie == KategorieEnum.K1;
      })
      .sort((a, b) => this.sortBy(a, b));
  }
  getTeilnahmenForKategorieK2(): ITeilnahmen[] {
    return this.alleTeilnahmen
      ?.filter((teilnahme) => {
        return teilnahme.talDTOList[0].kategorie == KategorieEnum.K2;
      })
      .sort((a, b) => this.sortBy(a, b));
  }
  getTeilnahmenForKategorieK3(): ITeilnahmen[] {
    return this.alleTeilnahmen
      ?.filter((teilnahme) => {
        return teilnahme.talDTOList[0].kategorie == KategorieEnum.K3;
      })
      .sort((a, b) => this.sortBy(a, b));
  }
  getTeilnahmenForKategorieK4(): ITeilnahmen[] {
    return this.alleTeilnahmen
      ?.filter((teilnahme) => {
        return teilnahme.talDTOList[0].kategorie == KategorieEnum.K4;
      })
      .sort((a, b) => this.sortBy(a, b));
  }
  getTeilnahmenForKategorieK5(): ITeilnahmen[] {
    return this.alleTeilnahmen
      ?.filter((teilnahme) => {
        return teilnahme.talDTOList[0].kategorie == KategorieEnum.K5;
      })
      .sort((a, b) => this.sortBy(a, b));
  }
  getTeilnahmenForKategorieK5A(): ITeilnahmen[] {
    return this.alleTeilnahmen
      ?.filter((teilnahme) => {
        return teilnahme.talDTOList[0].kategorie == KategorieEnum.K5A;
      })
      .sort((a, b) => this.sortBy(a, b));
  }
  getTeilnahmenForKategorieK5B(): ITeilnahmen[] {
    return this.alleTeilnahmen
      ?.filter((teilnahme) => {
        return teilnahme.talDTOList[0].kategorie == KategorieEnum.K5B;
      })
      .sort((a, b) => this.sortBy(a, b));
  }
  getTeilnahmenForKategorieK6(): ITeilnahmen[] {
    return this.alleTeilnahmen
      ?.filter((teilnahme) => {
        return teilnahme.talDTOList[0].kategorie == KategorieEnum.K6;
      })
      .sort((a, b) => this.sortBy(a, b));
  }
  getTeilnahmenForKategorieKD(): ITeilnahmen[] {
    return this.alleTeilnahmen
      ?.filter((teilnahme) => {
        return teilnahme.talDTOList[0].kategorie == KategorieEnum.KD;
      })
      .sort((a, b) => this.sortBy(a, b));
  }
  getTeilnahmenForKategorieKH(): ITeilnahmen[] {
    return this.alleTeilnahmen
      ?.filter((teilnahme) => {
        return teilnahme.talDTOList[0].kategorie == KategorieEnum.KH;
      })
      .sort((a, b) => this.sortBy(a, b));
  }
  getTeilnahmenForKategorieK7(): ITeilnahmen[] {
    return this.alleTeilnahmen
      ?.filter((teilnahme) => {
        return teilnahme.talDTOList[0].kategorie == KategorieEnum.K7;
      })
      .sort((a, b) => this.sortBy(a, b));
  }
}
