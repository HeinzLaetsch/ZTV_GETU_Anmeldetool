import { IAnlass } from './IAnlass';
import { IAnlassLink } from './IAnlassLink';

export type IAnlassLinks = {
  dirty: boolean;
  anlass: IAnlass;
  anlassLinks: IAnlassLink[];
}
