import { IOrganisationAnlassLink } from './IOrganisationAnlassLink';
import { IOrganisationPersonLink } from './IOrganisationPersonLink';
import { IPersonAnlassLink } from './IPersonAnlassLink';
import { IRolle } from './IRolle';
import { IWertungsrichter } from './IWertungsrichter';

export type IUser = {
  id?: string;
  organisationids: string[];
  benutzername: string;
  name: string;
  vorname: string;
  email: string;
  handy: string;
  aktiv: boolean;
  dirty?: boolean;
  userAlreadyExists?: boolean;
  password?: string;
  rollen?: IRolle[];
  wr?: IWertungsrichter;
  pal?: IPersonAnlassLink;
  organisationenLinks?: IOrganisationPersonLink[];
}
