export interface IAnlassLink {
  kategorie: string;
  meldeStatus?: string;
  anlassId: string;
  teilnehmerId: string;
  dirty?: boolean;
  startnummer?: number;
  abteilung?: string;
  startgeraet?: string;
  anlage?: string;
}
