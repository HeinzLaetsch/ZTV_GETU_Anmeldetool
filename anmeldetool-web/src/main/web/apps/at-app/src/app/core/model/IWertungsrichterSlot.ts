export type IWertungsrichterSlot = {
  id: string;
  reihenfolge: number;
  brevet: number;
  tag?: Date;
  startzeit?: Date;
  endzeit?: Date;
  beschreibung: string;
  egalSlot?: boolean;
};

export type CreateWertungsrichterSlot = Pick<IWertungsrichterSlot, 'reihenfolge' | 'brevet' | 'beschreibung'> & {
  tag: string;
  start_zeit: string | null;
  end_zeit: string | null;
};

export type WertungsrichterSlotResponse = Omit<IWertungsrichterSlot, 'tag' | 'startzeit' | 'endzeit'> & {
  tag: string | null;
  start_zeit: string | null;
  end_zeit: string | null;
};
