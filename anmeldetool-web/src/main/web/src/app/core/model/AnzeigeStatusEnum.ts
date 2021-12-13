export enum AnzeigeStatusEnum {
  NOCH_NICHT_OFFEN = "noch nicht offen",
  ERFASSEN_CLOSED = "Erfassen geschlossen",
  CROSS_KATEGORIE_CLOSED = "Cross Kategorie geschlossen",
  IN_KATEGORIE_CLOSED = "In Kategorie geschlossen",
  ALLE_MUTATIONEN_CLOSED = "Alle Mutationen geschlossen",
  CLOSED = "geschlossen",
  PUBLISHED = "publiziert",
}

export class Anzeigestatus {
  constructor() {
    this.setStatus(AnzeigeStatusEnum.PUBLISHED);
  }

  private status_: number;

  setStatus(anzeigeStatusEnum: AnzeigeStatusEnum): number {
    switch (anzeigeStatusEnum) {
      case AnzeigeStatusEnum.NOCH_NICHT_OFFEN:
        this.status_ = this.status_ | 1;
        break;
      case AnzeigeStatusEnum.ERFASSEN_CLOSED:
        this.status_ = this.status_ | (1 << 1);
        break;
      case AnzeigeStatusEnum.CROSS_KATEGORIE_CLOSED:
        this.status_ = this.status_ | (1 << 2);
        break;
      case AnzeigeStatusEnum.IN_KATEGORIE_CLOSED:
        this.status_ = this.status_ | (1 << 3);
        break;
      case AnzeigeStatusEnum.ALLE_MUTATIONEN_CLOSED:
        this.status_ = this.status_ | (1 << 4);
        break;
      case AnzeigeStatusEnum.CLOSED:
        this.status_ = this.status_ | (1 << 5);
        break;
      case AnzeigeStatusEnum.PUBLISHED:
        this.status_ = this.status_ | (1 << 6);
        break;
      default:
        break;
    }
    return this.status_;
  }
  resetStatus(anzeigeStatusEnum: AnzeigeStatusEnum): number {
    switch (anzeigeStatusEnum) {
      case AnzeigeStatusEnum.NOCH_NICHT_OFFEN:
        this.status_ = this.status_ & ~1;
        break;
      case AnzeigeStatusEnum.ERFASSEN_CLOSED:
        this.status_ = this.status_ & ~(1 << 1);
        break;
      case AnzeigeStatusEnum.CROSS_KATEGORIE_CLOSED:
        this.status_ = this.status_ & ~(1 << 2);
        break;
      case AnzeigeStatusEnum.IN_KATEGORIE_CLOSED:
        this.status_ = this.status_ & ~(1 << 3);
        break;
      case AnzeigeStatusEnum.ALLE_MUTATIONEN_CLOSED:
        this.status_ = this.status_ & ~(1 << 4);
        break;
      case AnzeigeStatusEnum.CLOSED:
        this.status_ = this.status_ & ~(1 << 5);
        break;
      case AnzeigeStatusEnum.PUBLISHED:
        this.status_ = this.status_ & ~(1 << 6);
        break;
      default:
        break;
    }
    return this.status_;
  }

  hasStatus(anzeigeStatusEnum: AnzeigeStatusEnum): boolean {
    switch (anzeigeStatusEnum) {
      case AnzeigeStatusEnum.NOCH_NICHT_OFFEN:
        return !((this.status_ & 1) > 0);
      case AnzeigeStatusEnum.ERFASSEN_CLOSED:
        return (this.status_ & (1 << 1)) > 0;
      case AnzeigeStatusEnum.CROSS_KATEGORIE_CLOSED:
        return (this.status_ & (1 << 2)) > 0;
      case AnzeigeStatusEnum.IN_KATEGORIE_CLOSED:
        return (this.status_ & (1 << 3)) > 0;
      case AnzeigeStatusEnum.ALLE_MUTATIONEN_CLOSED:
        return (this.status_ & (1 << 4)) > 0;
      case AnzeigeStatusEnum.CLOSED:
        return (this.status_ & (1 << 5)) > 0;
      case AnzeigeStatusEnum.PUBLISHED:
        return (this.status_ & (1 << 6)) > 0;
      default:
        return false;
    }
  }
}
