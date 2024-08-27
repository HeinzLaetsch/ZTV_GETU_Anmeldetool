import { IAnlassLink } from "./IAnlassLink";
import { ITeilnehmer } from "./ITeilnehmer";

export interface ITeilnahmen {
  jahr: number;
  teilnehmer: ITeilnehmer;
  talDTOList?: IAnlassLink[];
}
