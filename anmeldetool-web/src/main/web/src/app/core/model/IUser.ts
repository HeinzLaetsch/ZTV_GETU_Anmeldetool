import { IRolle } from './IRolle';

export interface IUser {
    id: string;
    organisationid: string;
    benutzername: string;
    name: string;
    vorname: string;
    email: string;
    handy: string;
    aktiv: boolean;
    password?: string;
    rollen?: IRolle[];
}
