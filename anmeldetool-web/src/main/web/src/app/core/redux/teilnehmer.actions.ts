import { ITeilnehmer } from "../model/ITeilnehmer";

export class AddTeilnehmer {
  static readonly type = "[Teilnehmer] Add";

  constructor(public payload: ITeilnehmer) {}
}

export class GetTeilnehmer {
  static readonly type = "[Teilnehmer] Get";
}

export class UpdateTeilnehmer {
  static readonly type = "[Teilnehmer] Update";

  constructor(public payload: ITeilnehmer, public id: string) {}
}

export class DeleteTeilnehmer {
  static readonly type = "[Teilnehmer] Delete";

  constructor(public id: string) {}
}
