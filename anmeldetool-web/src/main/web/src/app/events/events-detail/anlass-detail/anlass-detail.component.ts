import { Component, Input, OnInit } from "@angular/core";
import { IAnlass } from "src/app/core/model/IAnlass";

@Component({
  selector: "app-anlass-detail",
  templateUrl: "./anlass-detail.component.html",
  styleUrls: ["./anlass-detail.component.css"],
})
export class AnlassDetailComponent implements OnInit {
  @Input()
  anlass: IAnlass;

  constructor() {}
  ngOnInit() {}
}
