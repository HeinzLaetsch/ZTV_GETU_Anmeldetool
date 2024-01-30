import { IAnlassLink } from "./IAnlassLink";
import { IAnlassLinks } from "./IAnlassLinks";
import { ITeilnehmer } from "./ITeilnehmer";

export interface ITeilnahmen {
  teilnehmer: ITeilnehmer;
  teilnahmen?: IAnlassLinks;
  talDTOList?: IAnlassLink[];
}
