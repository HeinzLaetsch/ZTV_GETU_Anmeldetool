export interface IAnlassLink {
  kategorie: string;
  meldeStatus?: string;
  anlassId: string;
  teilnehmerId: string;
  dirty?: boolean;
  startnummer?: number;
  abteilung?: string;
  abteilungFix?: boolean;
  anlage?: string;
  anlageFix?: boolean;
  startgeraet?: string;
  startgeraetFix?: boolean;
}
