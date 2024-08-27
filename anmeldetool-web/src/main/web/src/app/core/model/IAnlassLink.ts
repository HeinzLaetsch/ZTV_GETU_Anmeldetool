import { MeldeStatusEnum } from "./MeldeStatusEnum";

export interface IAnlassLink {
  kategorie: string;
  meldeStatus?: MeldeStatusEnum;
  anlassId: string;
  teilnehmerId: string;
  organisationId: string;
  dirty?: boolean;
  startnummer?: number;
  abteilung?: string;
  startgeraet?: string;
  anlage?: string;
}
