import { IAnlass } from "./IAnlass";
import { IAnlassLink } from "./IAnlassLink";

export interface IAnlassLinks {
  dirty: boolean;
  anlass: IAnlass;
  anlassLinks: IAnlassLink[];
}
