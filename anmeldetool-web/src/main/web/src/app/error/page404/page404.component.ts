import { CommonModule } from "@angular/common";
import { Component, type OnInit } from "@angular/core";
import { RouterModule } from "@angular/router";

@Component({
	selector: "lxt-page404",
	templateUrl: "./page404.component.html",
	styleUrls: ["./page404.component.css"],
	standalone: true,
	imports: [CommonModule, RouterModule],
})
export class Page404Component implements OnInit {
	constructor() {}

	ngOnInit() {}
}
