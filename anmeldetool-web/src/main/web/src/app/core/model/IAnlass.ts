import * as moment from "moment";
import { Anzeigestatus, AnzeigeStatusEnum } from "./AnzeigeStatusEnum";
import { IWertungsrichterSlot } from "./IWertungsrichterSlot";
import { KategorieEnum } from "./KategorieEnum";
import { TiTuEnum } from "./TiTuEnum";

export class IAnlass {
  id: string;
  anlassBezeichnung: string;
  ort: string;
  halle: string;
  organisator: string;
  iban: string;
  zuGunsten: string;
  bank: string;
  position?: number;
  abteilungFix?: boolean;
  anlageFix?: boolean;
  startgeraetFix?: boolean;

  getCleaned(): string {
    return this.anlassBezeichnung.replace("%", "");
  }

  set startDatum(startDatum: Date) {
    this.startDatum_ = startDatum;
  }
  get startDatum(): Date {
    return this.startDatum_;
  }
  startDatum_: Date;

  set endDatum(endDatum: Date) {
    this.endDatum_ = endDatum;
    this.updateAnzeigeStatus();
  }
  get endDatum(): Date {
    return this.endDatum_;
  }
  endDatum_: Date;

  // Anmeldung ist eröffnet, es kann alles erfasst werden
  set anmeldungBeginn(anmeldungBeginn: Date) {
    this.anmeldungBeginn_ = anmeldungBeginn;
    this.updateAnzeigeStatus();
  }
  get anmeldungBeginn(): Date {
    return this.anmeldungBeginn_;
  }
  anmeldungBeginn_: Date;

  // Neu Erfassen nicht mehr erlaubt
  set erfassenGeschlossen(erfassenGeschlossen: Date) {
    this.erfassenGeschlossen_ = erfassenGeschlossen;
    this.updateAnzeigeStatus();
  }
  get erfassenGeschlossen(): Date {
    return this.erfassenGeschlossen_;
  }
  erfassenGeschlossen_: Date;

  // Neu Erfassen verlängert
  set erfassenVerlaengert(erfassenVerlaengert: Date) {
    this.erfassenVerlaengert_ = erfassenVerlaengert;
    this.updateAnzeigeStatus();
  }
  get erfassenVerlaengert(): Date {
    return this.erfassenVerlaengert_;
  }
  erfassenVerlaengert_: Date;

  // Cross Kategorie Aenderungen nicht mehr erlaubt
  set crossKategorieAenderungenGeschlossen(
    crossKategorieAenderungenGeschlossen: Date
  ) {
    this.crossKategorieAenderungenGeschlossen_ =
      crossKategorieAenderungenGeschlossen;
    this.updateAnzeigeStatus();
  }
  get crossKategorieAenderungenGeschlossen(): Date {
    return this.crossKategorieAenderungenGeschlossen_;
  }
  crossKategorieAenderungenGeschlossen_: Date;

  // Aenderungen innerhalb Kategorie nicht mehr erlaubt.
  set aenderungenInKategorieGeschlossen(
    aenderungenInKategorieGeschlossen: Date
  ) {
    this.aenderungenInKategorieGeschlossen_ = aenderungenInKategorieGeschlossen;
    this.updateAnzeigeStatus();
  }
  get aenderungenInKategorieGeschlossen(): Date {
    return this.aenderungenInKategorieGeschlossen_;
  }
  aenderungenInKategorieGeschlossen_: Date;

  // Kurz vor Wettkampf, keine Mutationen mehr erlaubt
  set aenderungenNichtMehrErlaubt(aenderungenNichtMehrErlaubt: Date) {
    this.aenderungenNichtMehrErlaubt_ = aenderungenNichtMehrErlaubt;
    this.updateAnzeigeStatus();
  }
  get aenderungenNichtMehrErlaubt(): Date {
    return this.aenderungenNichtMehrErlaubt_;
  }
  aenderungenNichtMehrErlaubt_: Date;

  // Anlass nicht anzeigen oder sperren kein Org
  set published(published: boolean) {
    this.published_ = published;
    // console.log("Published gesetzt: ", published);
    this.updateAnzeigeStatus();
  }
  get published(): boolean {
    return this.published_;
  }
  published_: boolean;

  tiTu: TiTuEnum;
  get tuAnlass(): boolean {
    const key = TiTuEnum[this.tiTu];
    const tuAnlass = key === TiTuEnum.Tu || key === TiTuEnum.Alle;
    return tuAnlass;
  }
  get tiAnlass(): boolean {
    const key = TiTuEnum[this.tiTu];
    const tiAnlass =
      key === TiTuEnum.Ti.toString() || key === TiTuEnum.Alle.toString();
    return tiAnlass;
  }

  get brevet1Anlass(): boolean {
    return this.tiefsteKategorie < KategorieEnum.K5;
  }

  get brevet2Anlass(): boolean {
    const br2 = this.hoechsteKategorie > KategorieEnum.K4;
    return br2;
  }
  tiefsteKategorie: KategorieEnum;
  hoechsteKategorie: KategorieEnum;
  wertungsrichterSlots?: IWertungsrichterSlot[];

  anzeigeStatus?: Anzeigestatus;

  constructor() {
    this.anzeigeStatus = new Anzeigestatus();
  }
  getKategorienRaw(): KategorieEnum[] {
    let k5 = Object.keys(KategorieEnum).findIndex(
      (key) => key === KategorieEnum.K5
    );
    const start = Object.keys(KategorieEnum).findIndex(
      (key) => key === this.tiefsteKategorie
    );
    let end = Object.keys(KategorieEnum).findIndex(
      (key) => key === this.hoechsteKategorie
    );
    // Keine Teilnahme
    let filtered = Object.values(KategorieEnum).slice(0, 1);
    if (end > k5) {
      filtered = filtered.concat(Object.values(KategorieEnum).slice(start, k5));
      if (this.tiTu === TiTuEnum.Ti) {
        filtered.push(KategorieEnum.K5A);
        filtered.push(KategorieEnum.K5B);
        filtered.push(KategorieEnum.K6);
        filtered.push(KategorieEnum.KD);
      } else {
        filtered.push(KategorieEnum.K5);
        filtered.push(KategorieEnum.K6);
        filtered.push(KategorieEnum.KH);
      }
      filtered.push(KategorieEnum.K7);
    } else {
      filtered = filtered.concat(
        Object.values(KategorieEnum).slice(start, end + 1)
      );
    }
    return filtered;
  }

  public updateAnzeigeStatus(): void {
    if (this.anmeldungBeginn) {
      const asMoment = moment(this.anmeldungBeginn);
      asMoment.add(1, "days");
      if (asMoment.isBefore()) {
        this.anzeigeStatus.setStatus(AnzeigeStatusEnum.NOCH_NICHT_OFFEN);
      } else {
        this.anzeigeStatus.resetStatus(AnzeigeStatusEnum.NOCH_NICHT_OFFEN);
      }
    } else {
      this.anzeigeStatus.resetStatus(AnzeigeStatusEnum.NOCH_NICHT_OFFEN);
    }
    this.erfassenVerlaengert_;
    this.anzeigeStatus.resetStatus(AnzeigeStatusEnum.ERFASSEN_CLOSED);
    if (this.erfassenGeschlossen) {
      const asMoment = moment(this.erfassenGeschlossen);
      asMoment.add(1, "days");
      if (asMoment.isBefore()) {
        if (this.erfassenVerlaengert) {
          const asMoment2 = moment(this.erfassenVerlaengert);
          asMoment2.add(1, "days");
          if (asMoment2.isBefore()) {
            this.anzeigeStatus.setStatus(AnzeigeStatusEnum.ERFASSEN_CLOSED);
          }
        } else {
          this.anzeigeStatus.setStatus(AnzeigeStatusEnum.ERFASSEN_CLOSED);
        }
      } else {
        this.anzeigeStatus.resetStatus(AnzeigeStatusEnum.ERFASSEN_CLOSED);
      }
    } else {
      this.anzeigeStatus.resetStatus(AnzeigeStatusEnum.ERFASSEN_CLOSED);
    }

    if (this.crossKategorieAenderungenGeschlossen) {
      const asMoment = moment(this.crossKategorieAenderungenGeschlossen);
      asMoment.add(1, "days");
      if (asMoment.isBefore()) {
        this.anzeigeStatus.setStatus(AnzeigeStatusEnum.CROSS_KATEGORIE_CLOSED);
      } else {
        this.anzeigeStatus.resetStatus(
          AnzeigeStatusEnum.CROSS_KATEGORIE_CLOSED
        );
      }
    } else {
      this.anzeigeStatus.resetStatus(AnzeigeStatusEnum.CROSS_KATEGORIE_CLOSED);
    }
    if (this.aenderungenInKategorieGeschlossen) {
      const asMoment = moment(this.aenderungenInKategorieGeschlossen);
      asMoment.add(1, "days");
      if (asMoment.isBefore()) {
        this.anzeigeStatus.setStatus(AnzeigeStatusEnum.IN_KATEGORIE_CLOSED);
      } else {
        this.anzeigeStatus.resetStatus(AnzeigeStatusEnum.IN_KATEGORIE_CLOSED);
      }
    } else {
      this.anzeigeStatus.resetStatus(AnzeigeStatusEnum.IN_KATEGORIE_CLOSED);
    }

    if (this.aenderungenNichtMehrErlaubt) {
      const asMoment = moment(this.aenderungenNichtMehrErlaubt);
      asMoment.add(1, "days");
      if (asMoment.isBefore()) {
        this.anzeigeStatus.setStatus(AnzeigeStatusEnum.ALLE_MUTATIONEN_CLOSED);
      } else {
        this.anzeigeStatus.resetStatus(
          AnzeigeStatusEnum.ALLE_MUTATIONEN_CLOSED
        );
      }
    } else {
      this.anzeigeStatus.resetStatus(AnzeigeStatusEnum.ALLE_MUTATIONEN_CLOSED);
    }

    if (this.endDatum) {
      const asMoment = moment(this.endDatum);
      asMoment.add(1, "days");
      if (asMoment.isBefore()) {
        this.anzeigeStatus.setStatus(AnzeigeStatusEnum.CLOSED);
      } else {
        this.anzeigeStatus.resetStatus(AnzeigeStatusEnum.CLOSED);
      }
    } else {
      this.anzeigeStatus.resetStatus(AnzeigeStatusEnum.CLOSED);
    }

    if (this.published) {
      this.anzeigeStatus.setStatus(AnzeigeStatusEnum.PUBLISHED);
    } else {
      this.anzeigeStatus.resetStatus(AnzeigeStatusEnum.PUBLISHED);
    }

    if (this.erfassenVerlaengert) {
      const asMoment = moment(this.erfassenVerlaengert);
      asMoment.add(1, "days");
      if (!asMoment.isBefore()) {
        this.anzeigeStatus.setStatus(AnzeigeStatusEnum.VERLAENGERT);
      } else {
        this.anzeigeStatus.resetStatus(AnzeigeStatusEnum.VERLAENGERT);
      }
    } else {
      this.anzeigeStatus.resetStatus(AnzeigeStatusEnum.VERLAENGERT);
    }
  }
}
