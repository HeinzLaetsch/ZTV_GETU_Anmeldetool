import {
	Component,
	type EventEmitter,
	Input,
	type OnInit,
	ViewEncapsulation,
} from "@angular/core";
import { UntypedFormControl } from "@angular/forms";
import { Subject } from "rxjs";
import { AbteilungEnum } from "src/app/core/model/AbteilungEnum";
import { AnlageEnum } from "src/app/core/model/AnlageEnum";
import type { GeraeteEnum } from "src/app/core/model/GeraeteEnum";
import type { IAnlass } from "src/app/core/model/IAnlass";
import type { ITeilnahmeStatistic } from "src/app/core/model/ITeilnahmeStatistic";
import type { ITeilnehmerStart } from "src/app/core/model/ITeilnehmerStart";
import type { KategorieEnum } from "src/app/core/model/KategorieEnum";
import { MeldeStatusEnum } from "src/app/core/model/MeldeStatusEnum";
import { CachingAnlassService } from "src/app/core/service/caching-services/caching.anlass.service";
import { RanglistenService } from "src/app/core/service/rangliste/ranglisten.service";

@Component({
	selector: "lxt-einteilung-startgeraet",
	templateUrl: "./einteilung-startgeraet.component.html",
	styleUrls: ["./einteilung-startgeraet.component.css"],
	encapsulation: ViewEncapsulation.None,
})
export class EinteilungStartgeraetComponent implements OnInit {
	@Input()
	anlass: IAnlass;
	@Input()
	kategorie: KategorieEnum;
	@Input()
	abteilung: AbteilungEnum;
	@Input()
	anlage: AnlageEnum;
	@Input()
	startgeraet: GeraeteEnum;
	@Input()
	refreshEmitter: EventEmitter<string>;
	@Input()
	search: string;
	@Input()
	expanded: boolean;

	loaded$: Subject<boolean>;

	private statisticLoaded = false;
	private startsLoaded = false;

	startende: ITeilnehmerStart[];

	teilnahmeStatistic: ITeilnahmeStatistic;

	displayedColumns: string[] = [
		"name",
		"vorname",
		"verein",
		"tiTu",
		"abteilung",
		"anlage",
		"startgeraet",
		"abmelden",
		"addToStartgeraet",
	];

	startgeraeteControls_ = [] as UntypedFormControl[];
	anlageControls_ = [] as UntypedFormControl[];
	abteilungenControls_ = [] as UntypedFormControl[];

	constructor(
		private anlassService: CachingAnlassService,
		private ranglistenService: RanglistenService,
	) {
		this.loaded$ = new Subject();
		this.startgeraeteControls_ = [];
	}

	ngOnInit(): void {
		this.loadData(this.search);
		this.refreshEmitter.subscribe((search) => {
			console.log(
				"EinteilungStartgeraetComponent, Refresh Kategorie: ",
				search,
			);
			this.search = search;
			this.loadData(search);
		});
	}

	private loadData(search: string): void {
		this.anlassService
			.getTeilnahmeStatistic(
				this.anlass,
				this.kategorie,
				this.abteilung,
				this.anlage,
				this.startgeraet,
				search,
			)
			.subscribe((statistic) => {
				this.teilnahmeStatistic = statistic;
				this.statisticLoaded = true;
				if (this.startsLoaded) {
					this.loaded$.next(true);
				}
			});

		this.anlassService
			.getByStartgeraet(
				this.anlass,
				this.kategorie,
				this.abteilung,
				this.anlage,
				this.startgeraet,
				search,
			)
			.subscribe((startende) => {
				this.startende = startende;
				this.startgeraeteControls_.slice(0, 0);
				if (this.startende) {
					this.startende.forEach((start) => {
						let control = new UntypedFormControl();
						control.setValue(start.startgeraet);
						this.startgeraeteControls_.push(control);
						control = new UntypedFormControl();
						control.setValue(start.anlage);
						this.anlageControls_.push(control);
						control = new UntypedFormControl();
						control.setValue(start.abteilung);
						this.abteilungenControls_.push(control);
					});
				}
				this.startsLoaded = true;
				if (this.statisticLoaded) {
					this.loaded$.next(true);
				}
			});
	}

	enableAddToStartgeraet(element: ITeilnehmerStart): boolean {
		return this.teilnahmeStatistic.lauflistenGeneriert && !element.laufliste;
	}

	get startgeraeteControls(): UntypedFormControl[] {
		return this.startgeraeteControls_;
	}
	change(rowIndex: any, colIndex: any) {
		console.log("Change ", rowIndex, " ", colIndex);
		switch (colIndex) {
			case 0:
				console.log(" Abteilung: ", this.abteilungenControls_[rowIndex].value);
				this.startende[rowIndex].abteilung =
					this.abteilungenControls_[rowIndex].value.toUpperCase();
				break;
			case 1:
				console.log(" Anlage: ", this.anlageControls_[rowIndex].value);
				this.startende[rowIndex].anlage =
					this.anlageControls_[rowIndex].value.toUpperCase();
				break;
			case 2:
				console.log(
					" Startgeraet: ",
					this.startgeraeteControls_[rowIndex].value,
				);
				this.startende[rowIndex].startgeraet =
					this.startgeraeteControls_[rowIndex].value.toUpperCase();
				break;
		}
		this.anlassService
			.updateStartgeraet(this.anlass, this.startende[rowIndex])
			.subscribe(() => {});
	}

	get alleStartgeraete(): GeraeteEnum[] {
		const startgeraete = this.anlass.getStartgeraete();
		return startgeraete;
	}
	get anlageControls(): UntypedFormControl[] {
		return this.anlageControls_;
	}
	get abteilungenControls(): UntypedFormControl[] {
		return this.abteilungenControls_;
	}
	get alleAnlagen(): AnlageEnum[] {
		const anlagen: AnlageEnum[] = [];
		anlagen.push(AnlageEnum.ANLAGE_1);
		anlagen.push(AnlageEnum.ANLAGE_2);
		anlagen.push(AnlageEnum.ANLAGE_3);
		anlagen.push(AnlageEnum.ANLAGE_4);
		anlagen.push(AnlageEnum.ANLAGE_5);
		anlagen.push(AnlageEnum.ANLAGE_6);
		return anlagen;
	}
	get alleAbteilungen(): AbteilungEnum[] {
		const abteilungen: AbteilungEnum[] = [];
		abteilungen.push(AbteilungEnum.ABTEILUNG_1);
		abteilungen.push(AbteilungEnum.ABTEILUNG_2);
		abteilungen.push(AbteilungEnum.ABTEILUNG_3);
		abteilungen.push(AbteilungEnum.ABTEILUNG_4);
		abteilungen.push(AbteilungEnum.ABTEILUNG_5);
		abteilungen.push(AbteilungEnum.ABTEILUNG_6);
		abteilungen.push(AbteilungEnum.ABTEILUNG_7);
		abteilungen.push(AbteilungEnum.ABTEILUNG_8);
		return abteilungen;
	}
	compareWith(value1, value2) {
		if (value1 && value2 && value1.toUpperCase() === value2.toUpperCase()) {
			return value1;
		} else {
			return "";
		}
	}
	abmelden(rowIndex: number): void {
		console.log("Abmelden von ", this.startende[rowIndex].name);
		//TODO Check
		this.startende[rowIndex].meldeStatus =
			MeldeStatusEnum.ABGEMELDET.toString().toUpperCase();
		if (!this.anlass.aenderungenNichtMehrErlaubt) {
			this.startende[rowIndex].meldeStatus =
				MeldeStatusEnum.ABGEMELDET.toString().toUpperCase();
		}
		this.anlassService
			.updateStartgeraet(this.anlass, this.startende[rowIndex])
			.subscribe(() => {});
	}

	addToStartgeraet(rowIndex: number): void {
		console.log(
			"Nachtraeglich zum Startgeraet hinzufügen von ",
			this.startende[rowIndex].name,
		);
		//TODO Check
		this.startende[rowIndex].meldeStatus =
			MeldeStatusEnum.ABGEMELDET.toString().toUpperCase();
		if (!this.anlass.aenderungenNichtMehrErlaubt) {
			this.startende[rowIndex].meldeStatus =
				MeldeStatusEnum.ABGEMELDET.toString().toUpperCase();
		}
		this.ranglistenService
			.addToStartgeraet(this.anlass, this.startende[rowIndex])
			.subscribe(() => {});
	}
}
