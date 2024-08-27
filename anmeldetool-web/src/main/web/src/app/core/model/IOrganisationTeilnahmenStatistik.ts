import { IKategorieStati } from "./IKategorieStati";

export interface IOrganisationTeilnahmenStatistik {
  anlassId: string;
  kategorieStati: IKategorieStati[];
}
