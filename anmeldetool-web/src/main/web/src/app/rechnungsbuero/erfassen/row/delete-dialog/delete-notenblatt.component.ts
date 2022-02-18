import { Component, Inject } from "@angular/core";
import { MAT_DIALOG_DATA } from "@angular/material/dialog";
import { ILauflistenEintrag } from "src/app/core/model/ILauflistenEintrag";

@Component({
  selector: "app-delete-notenblatt",
  templateUrl: "./delete-notenblatt.component.html",
  styleUrls: ["./delete-notenblatt.component.css"],
})
export class NotenBlattZurueckZiehen {
  readonly ABBRECHEN = "abbrechen";
  readonly VERLETZT = "verletzt";
  readonly NICHT_ANGETRETEN = "nichtAngetreten";

  constructor(@Inject(MAT_DIALOG_DATA) public eintrag: ILauflistenEintrag) {}
}
