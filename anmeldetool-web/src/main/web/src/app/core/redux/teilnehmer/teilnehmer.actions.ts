import { Action } from "@ngrx/store";
import { ITeilnehmer } from "../../model/ITeilnehmer";
import { TiTuEnum } from "../../model/TiTuEnum";

export enum ActionTypes {
  LoadAllTeilnehmer = "[Teilnehmer] Load Teilnehmer",
  LoadAllTeilnehmerFinished = "[Teilnehmer] Load Teilnehmer Finished",

  AddTeilnehmer = "[Teilnehmer] Add Teilnehmer",
  AddTeilnehmerFinished = "[Teilnehmer] Add Teilnehmer Finished",
}

export class LoadAllTeilnehmerAction implements Action {
  readonly type = ActionTypes.LoadAllTeilnehmer;
}

export class LoadAllTeilnehmerFinishedAction implements Action {
  readonly type = ActionTypes.LoadAllTeilnehmerFinished;
  constructor(public payload: ITeilnehmer[]) {}
}

export class AddTeilnehmerAction implements Action {
  readonly type = ActionTypes.AddTeilnehmer;
  constructor(public payload: TiTuEnum) {}
}

export class AddTeilnehmerFinishedAction implements Action {
  readonly type = ActionTypes.AddTeilnehmerFinished;
  constructor(public payload: ITeilnehmer) {}
}

export type TeilnehmerActions =
  | AddTeilnehmerAction
  | AddTeilnehmerFinishedAction
  | LoadAllTeilnehmerAction
  | LoadAllTeilnehmerFinishedAction;
