import { IAnlass } from "src/app/core/model/IAnlass";
import { AnlassService } from "src/app/core/service/anlass/anlass.service";

export interface IStart {
  anlass: IAnlass;
  start: boolean;
}
