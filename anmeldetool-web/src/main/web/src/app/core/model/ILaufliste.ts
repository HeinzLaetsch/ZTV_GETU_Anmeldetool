import { AbteilungEnum } from "./AbteilungEnum";
import { AnlageEnum } from "./AnlageEnum";
import { GeraeteEnum } from "./GeraeteEnum";
import { ILauflistenEintrag } from "./ILauflistenEintrag";

export interface ILaufliste {
  id: string;
  laufliste: string;
  geraet: GeraeteEnum;
  abteilung: AbteilungEnum;
  anlage: AnlageEnum;
  abloesung: number;
  erfasst?: boolean;
  checked?: boolean;
  eintraege: ILauflistenEintrag[];
}
