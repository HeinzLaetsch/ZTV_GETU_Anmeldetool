import { IPersonAnlassLink } from "./IPersonAnlassLink";
import { IRolle } from "./IRolle";
import { IWertungsrichter } from "./IWertungsrichter";

export interface IUser {
  id?: string;
  organisationid: string;
  benutzername: string;
  name: string;
  vorname: string;
  email: string;
  handy: string;
  aktiv: boolean;
  password?: string;
  rollen?: IRolle[];
  wr?: IWertungsrichter;
  pal?: IPersonAnlassLink;
}
