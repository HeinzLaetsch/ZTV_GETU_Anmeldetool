export interface IAnlassSummary {
  anlassId: string;
  organisationsId: string;
  startet: boolean;
  verlaengerungsDate: Date;
  startendeBr1: number;
  startendeBr2: number;
  gemeldeteBr1: number;
  gemeldeteBr2: number;
  br1Ok: boolean;
  br2Ok: boolean;
}
