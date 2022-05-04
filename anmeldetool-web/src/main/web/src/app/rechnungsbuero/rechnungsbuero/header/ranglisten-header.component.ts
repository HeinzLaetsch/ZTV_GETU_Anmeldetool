import { Component, Input } from "@angular/core";
import { TiTuEnum } from "src/app/core/model/TiTuEnum";

@Component({
  selector: "app-ranglisten-header",
  templateUrl: "./ranglisten-header.component.html",
  styleUrls: ["./ranglisten-header.component.css"],
})
export class RanglistenHeaderComponent {
  @Input()
  tiTu: TiTuEnum;

  get isTu(): boolean {
    const res = TiTuEnum.Tu === this.tiTu;
    return res;
  }
}
