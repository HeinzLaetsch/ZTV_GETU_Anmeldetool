export interface ILauflistenEintrag {
  id: string;
  laufliste_id: string;
  startnummer: number;
  verein: string;
  name: string;
  vorname: string;
  note_1?: number;
  note_2?: number;
  tal_id: string;
  checked: boolean;
  erfasst: boolean;
  deleted: boolean;
}
