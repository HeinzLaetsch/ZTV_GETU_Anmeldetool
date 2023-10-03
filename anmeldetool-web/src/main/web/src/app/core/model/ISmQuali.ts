export interface ISmQuali {
  id: string;
  name: string;
  vorname: string;
  jahrgang: number;
  organisation: string;
  organisationid: string;
  durchschnittlichePunktzahl: number;
  wettkampf1Punktzahl: number;
  wettkampf2Punktzahl: number;
  wettkampf3Punktzahl: number;
  kmsPunktzahl: number;
  finalPunktzahl: number;
  ausserKantonal1Punktzahl: number;
  ausserKantonal2Punktzahl: number;
  reckDurchschnitt: number;
  bodenDurchschnitt: number;
  schaukelringeDurchschnitt: number;
  sprungDurchschnitt: number;
  barrenDurchschnitt: number;
}
