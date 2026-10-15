import { ChangeDetectionStrategy, Component, computed, inject, input, output, signal } from '@angular/core';
import { toObservable, toSignal } from '@angular/core/rxjs-interop';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MaterialModule } from 'src/app/shared/material-module';
import { distinctUntilChanged, filter, map, switchMap } from 'rxjs';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { IUser } from 'src/app/core/model/IUser';
import type { IWertungsrichterEinsatz } from 'src/app/core/model/IWertungsrichterEinsatz';
import type { IWertungsrichterSlot } from 'src/app/core/model/IWertungsrichterSlot';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { CachingAnlassService } from 'src/app/core/service/caching-services/caching.anlass.service';
import { CachingUserService } from 'src/app/core/service/caching-services/caching.user.service';
import { WertungsrichterSlotComponent } from './wertungsrichter-slot';

@Component({
  selector: 'ztv-wertungsrichter-chip',
  templateUrl: './wertungsrichter-chip.component.html',
  styleUrl: './wertungsrichter-chip.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [MaterialModule, MatProgressSpinnerModule, WertungsrichterSlotComponent],
})
export class WertungsrichterChipComponent {
  readonly isVereinsAnmelder = input<boolean>(false);
  readonly isVereinsVerantwortlicher = input<boolean>(false);
  readonly isAllWertungsrichterList = input<boolean>(false);
  readonly wertungsrichterUser = input.required<IUser>();
  readonly anlass = input.required<IAnlass>();
  readonly useBrevet2 = input<boolean>(false);
  readonly changeAllowed = input<boolean>(false);

  readonly wertungsrichterUserChange = output<IUser>();

  private readonly authservice = inject(AuthService);
  private readonly userService = inject(CachingUserService);
  private readonly anlassService = inject(CachingAnlassService);
  private readonly wertungsrichterId = toObservable(this.wertungsrichterUser).pipe(
    map((user) => user.id),
    distinctUntilChanged(),
  );

  readonly wertungsrichter = toSignal(
    this.wertungsrichterId.pipe(
      filter((id): id is string => !!id),
      switchMap((id) => this.userService.getWertungsrichter(id)),
    ),
    { initialValue: undefined },
  );

  readonly slotsForBrevet = computed(() => {
    const wertungsrichter = this.wertungsrichter();
    if (!wertungsrichter) {
      return [];
    }

    const brevet = this.useBrevet2() ? 1 : wertungsrichter.brevet;
    return this.anlass().wertungsrichterSlots.filter((slot) => slot.brevet === brevet);
  });

  readonly wertungsrichterName = computed(
    () => `${this.wertungsrichterUser().vorname} ${this.wertungsrichterUser().name}`,
  );
  readonly wrAnlassLink = computed(() => this.wertungsrichterUser().pal);
  readonly commentDraft = signal<string | undefined>(undefined);
  readonly kommentar = computed(() => this.commentDraft() ?? this.wertungsrichterUser().pal?.kommentar ?? '');
  readonly hasKommentar = computed(() => this.kommentar().length > 0);
  readonly egalSlot = computed(() => this.slotsForBrevet().find((slot) => slot.egalSlot));

  onWertungsrichterEinsatzChange(): void {
    this.wertungsrichterUserChange.emit(this.wertungsrichterUser());
  }

  onKommentarInput(event: Event): void {
    this.commentDraft.set((event.target as HTMLInputElement).value);
  }

  saveKommentar(): void {
    const user = this.wertungsrichterUser();
    const pal = user.pal;
    if (!pal) {
      return;
    }

    const updatedPal = { ...pal, kommentar: this.kommentar() };
    this.anlassService.updateAnlassLink(updatedPal, this.authservice.currentVerein).subscribe((savedPal) => {
      this.commentDraft.set(undefined);
      this.wertungsrichterUserChange.emit({ ...user, pal: savedPal });
    });
  }

  getEinsatzForSlot(slot: IWertungsrichterSlot): IWertungsrichterEinsatz | undefined {
    return this.wertungsrichterUser().pal?.einsaetze?.find((einsatz) => einsatz.wertungsrichterSlotId === slot.id);
  }
}
