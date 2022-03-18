import { Component, Input } from "@angular/core";
import { IAnlass } from "src/app/core/model/IAnlass";
import { IRanglistenEntry } from "src/app/core/model/IRanglistenEntry";

@Component({
  selector: "app-ranglisten-header",
  templateUrl: "./ranglisten-header.component.html",
  styleUrls: ["./ranglisten-header.component.css"],
})
export class RanglistenHeaderComponent {
  @Input()
  isTi: boolean;
}
