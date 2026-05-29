export enum AnzeigeStatusEnum {
  NOCH_NICHT_OFFEN = 'noch nicht offen',
  ERFASSEN_CLOSED = 'Erfassen geschlossen',
  CROSS_KATEGORIE_CLOSED = 'Cross Kategorie geschlossen',
  IN_KATEGORIE_CLOSED = 'In Kategorie geschlossen',
  ALLE_MUTATIONEN_CLOSED = 'Alle Mutationen geschlossen',
  CLOSED = 'geschlossen',
  PUBLISHED = 'publiziert',
  VERLAENGERT = 'verlängert',
}

export class Anzeigestatus {
  private static readonly FLAG_MAP: Record<AnzeigeStatusEnum, number> = {
    [AnzeigeStatusEnum.NOCH_NICHT_OFFEN]: 1 << 0,
    [AnzeigeStatusEnum.ERFASSEN_CLOSED]: 1 << 1,
    [AnzeigeStatusEnum.CROSS_KATEGORIE_CLOSED]: 1 << 2,
    [AnzeigeStatusEnum.IN_KATEGORIE_CLOSED]: 1 << 3,
    [AnzeigeStatusEnum.ALLE_MUTATIONEN_CLOSED]: 1 << 4,
    [AnzeigeStatusEnum.CLOSED]: 1 << 5,
    [AnzeigeStatusEnum.PUBLISHED]: 1 << 6,
    [AnzeigeStatusEnum.VERLAENGERT]: 1 << 7,
  };

  private status_ = Anzeigestatus.FLAG_MAP[AnzeigeStatusEnum.PUBLISHED];

  constructor() {}

  private isFlagSet(flag: number): boolean {
    return (this.status_ & flag) === flag;
  }

  private setFlag(flag: number): void {
    this.status_ |= flag;
  }

  private clearFlag(flag: number): void {
    this.status_ &= ~flag;
  }

  setStatus(anzeigeStatusEnum: AnzeigeStatusEnum): number {
    const flag = Anzeigestatus.FLAG_MAP[anzeigeStatusEnum];
    this.setFlag(flag);
    return this.status_;
  }

  resetStatus(anzeigeStatusEnum: AnzeigeStatusEnum): number {
    const flag = Anzeigestatus.FLAG_MAP[anzeigeStatusEnum];
    this.clearFlag(flag);
    return this.status_;
  }

  hasStatus(anzeigeStatusEnum: AnzeigeStatusEnum): boolean {
    const flag = Anzeigestatus.FLAG_MAP[anzeigeStatusEnum];
    if (anzeigeStatusEnum === AnzeigeStatusEnum.NOCH_NICHT_OFFEN) {
      return !this.isFlagSet(flag);
    }

    return this.isFlagSet(flag);
  }
}
