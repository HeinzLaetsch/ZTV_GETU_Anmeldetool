import { ChangeDetectionStrategy, Component, input } from '@angular/core';
import { CommonModule } from '@angular/common';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { IRanglistenEntry } from 'src/app/core/model/IRanglistenEntry';
import { TiTuEnum } from 'src/app/core/model/TiTuEnum';

@Component({
  selector: 'ztv-ranglisten-entry',
  templateUrl: './ranglisten-entry.component.html',
  styleUrls: ['./ranglisten-entry.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule],
})
export class RanglistenEntryComponent {
  readonly anlass = input.required<IAnlass>();
  readonly entry = input.required<IRanglistenEntry>();
  readonly highlighted = input.required<boolean>();
  readonly index = input.required<number>();
  readonly tiTu = input.required<TiTuEnum>();

  get isTu(): boolean {
    // const s1 = this.tiTu.toString();
    // const s2 = TiTuEnum.Tu.toString();
    const res = TiTuEnum.Tu === this.tiTu();
    return res;
  }
}
