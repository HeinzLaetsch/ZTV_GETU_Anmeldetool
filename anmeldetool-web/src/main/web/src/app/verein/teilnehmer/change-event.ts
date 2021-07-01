import { IAnlass } from "src/app/core/model/IAnlass";

export interface IChangeEvent {
  rowIndex: number;
  colIndex: number;
  dirty: boolean;
  error: boolean;
}
