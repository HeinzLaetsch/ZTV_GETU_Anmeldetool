import { Component, Input } from "@angular/core";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IRanglistenEntry } from "src/app/core/model/IRanglistenEntry";

@Component({
  selector: "app-ranglisten-entry",
  templateUrl: "./ranglisten-entry.component.html",
  styleUrls: ["./ranglisten-entry.component.css"],
})
export class RanglistenEntryComponent {
  @Input()
  anlass: IAnlass;
  @Input()
  entry: IRanglistenEntry;
  @Input()
  highlighted: boolean;
  @Input()
  index: number;

  ngOnDestroy() {}
}
