import { type CdkDragDrop, moveItemInArray, transferArrayItem } from '@angular/cdk/drag-drop';
import { DragDropModule } from '@angular/cdk/drag-drop';
import { Component, computed, input, signal, ViewChild } from '@angular/core';
import type { AfterViewInit, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import type { MatTabGroup } from '@angular/material/tabs';
import { MatTabsModule } from '@angular/material/tabs';
import { RouterModule } from '@angular/router';
import { forkJoin } from 'rxjs';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { IAnlassSummary } from 'src/app/core/model/IAnlassSummary';
import type { IUser } from 'src/app/core/model/IUser';
import { WertungsrichterStatusEnum } from 'src/app/core/model/WertungsrichterStatusEnum';
import { AnlassService } from 'src/app/core/service/anlass/anlass.service';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { WertungsrichterService } from 'src/app/core/service/wertungsrichter.service';
import { WertungsrichterChipComponent } from '../wertungsrichter-chip/wertungsrichter-chip.component';

@Component({
  selector: 'lxt-wertungsrichter-selektion',
  templateUrl: './wertungsrichter-selektion.component.html',
  styleUrls: ['./wertungsrichter-selektion.component.css'],
  standalone: true,
  imports: [
    FormsModule,
    RouterModule,
    DragDropModule,
    MatTabsModule,
    MatCheckboxModule,
    MatProgressSpinnerModule,
    WertungsrichterChipComponent,
  ],
})
export class WertungsrichterSelektionComponent implements OnInit, AfterViewInit {
  @ViewChild('tabs') tabGroup: MatTabGroup;

  readonly anlass = input.required<IAnlass>();

  readonly changeAllowed = input.required<boolean>();

  readonly anlassSummary = input.required<IAnlassSummary>();
  // anlassSummary$: Observable<IAnlassSummary>; // TODO REDUX

  readonly useBrevet2 = signal(false);

  readonly assignedWr1s = signal<IUser[]>([]);
  readonly assignedWr2s = signal<IUser[]>([]);
  readonly wr1s = signal<IUser[]>([]);
  readonly wr2s = signal<IUser[]>([]);

  readonly wertungsrichterPflichtBrevet1 = computed(() =>
    this.isBrevet1Anlass() ? this.wertungsrichterService.getWertungsrichterPflichtBrevet1(this.anlassSummary()) : 0,
  );

  readonly wertungsrichterPflichtBrevet2 = computed(() =>
    this.isBrevet2Anlass() ? this.wertungsrichterService.getWertungsrichterPflichtBrevet2(this.anlassSummary()) : 0,
  );

  readonly availableWertungsrichter1 = computed(() =>
    this.useBrevet2() ? [...this.wr1s(), ...this.wr2s()] : this.wr1s(),
  );

  readonly availableWertungsrichter2 = computed(() => this.wr2s());

  readonly statusBr1 = computed(() =>
    this.wertungsrichterService.getStatusWertungsrichterBr(this.assignedWr1s(), this.wertungsrichterPflichtBrevet1()),
  );

  readonly statusBr2 = computed(() =>
    this.wertungsrichterService.getStatusWertungsrichterBr(this.assignedWr2s(), this.wertungsrichterPflichtBrevet2()),
  );

  readonly isWertungsrichter1Ok = computed(() => this.statusBr1() !== WertungsrichterStatusEnum.NOTOK);

  readonly isWertungsrichter2Ok = computed(() => this.statusBr2() !== WertungsrichterStatusEnum.NOTOK);

  private readonly initialized = signal(false);

  constructor(
    public authService: AuthService,
    private anlassService: AnlassService,
    private wertungsrichterService: WertungsrichterService,
  ) {}

  ngOnInit(): void {
    this.wrInit();
  }

  ngAfterViewInit(): void {
    if (this.tabGroup) {
      this.tabGroup.selectedIndex = this.isBrevet1Anlass() ? 0 : 1;
    }
  }

  wrInit(): void {
    forkJoin({
      brevet1: this.wertungsrichterService.getEingeteilteWertungsrichter(this.anlass(), 1),
      brevet2: this.wertungsrichterService.getEingeteilteWertungsrichter(this.anlass(), 2),
      available1: this.anlassService.getVerfuegbareWertungsrichter(this.anlass(), this.authService.currentVerein, 1),
      available2: this.anlassService.getVerfuegbareWertungsrichter(this.anlass(), this.authService.currentVerein, 2),
    }).subscribe(({ brevet1, brevet2, available1, available2 }) => {
      const assignedBrevet1 = [...brevet1];
      const assignedBrevet2 = [...brevet2];

      this.assignedWr1s.set(
        assignedBrevet1.concat(!this.isBrevet2Anlass() && assignedBrevet2.length > 0 ? assignedBrevet2 : []),
      );
      this.assignedWr2s.set(assignedBrevet2);
      this.wr1s.set([...available1].sort((a, b) => a.benutzername.localeCompare(b.benutzername)));
      this.wr2s.set([...available2].sort((a, b) => a.benutzername.localeCompare(b.benutzername)));

      if (!this.isBrevet2Anlass() && assignedBrevet2.length > 0) {
        this.useBrevet2.set(true);
      }
    });
  }

  isBrevet1Anlass(): boolean {
    // console.log("Brevet 1: ", this.anlass.tiefsteKategorie <= KategorieEnum.K4);
    return this.anlass().brevet1Anlass;
  }
  isBrevet2Anlass(): boolean {
    // console.log("Brevet 2: ", this.anlass.hoechsteKategorie > KategorieEnum.K4);
    return this.anlass().brevet2Anlass;
  }
  useBrevet2Clicked(check: boolean): void {
    this.useBrevet2.set(check);
  }

  wertungsrichterUserChange(): void {
    this.assignedWr1s.set([...this.assignedWr1s()]);
  }

  drop(event: CdkDragDrop<string[]>, liste: string): void {
    //console.log("Drop: ", event, ", liste", liste);
    if (event.previousContainer === event.container) {
      console.warn('move Drop: ', event);
      moveItemInArray(event.container.data, event.previousIndex, event.currentIndex);
      return;
    } else {
      //console.log("Transfer Drop: ", event);
      transferArrayItem(event.previousContainer.data, event.container.data, event.previousIndex, event.currentIndex);
      //console.log("Data: ", event.container.data[0]);
    }
    if (liste === '2') {
      this.anlassService
        .addWertungsrichterToAnlass(
          this.anlass(),
          this.authService.currentVerein,
          event.container.data[event.currentIndex] as unknown as IUser,
        )
        .subscribe(() => {
          this.assignedWr1s.set([...this.assignedWr1s()]);
          this.assignedWr2s.set([...this.assignedWr2s()]);

          this.loadWrLink(event.container.data[event.currentIndex] as unknown as IUser);
        });
    } else {
      this.anlassService
        .deleteWertungsrichterFromAnlass(
          this.anlass(),
          this.authService.currentVerein,
          event.container.data[event.currentIndex] as unknown as IUser,
        )
        .subscribe(() => {
          this.assignedWr1s.set([...this.assignedWr1s()]);
          this.assignedWr2s.set([...this.assignedWr2s()]);
        });
    }
  }
  loadWrLink(wertungsrichterUser: IUser): void {
    this.anlassService
      .getWrEinsatz(this.anlass(), this.authService.currentVerein, wertungsrichterUser)
      .subscribe((pal) => {
        wertungsrichterUser.pal = pal;
      });
  }
}
