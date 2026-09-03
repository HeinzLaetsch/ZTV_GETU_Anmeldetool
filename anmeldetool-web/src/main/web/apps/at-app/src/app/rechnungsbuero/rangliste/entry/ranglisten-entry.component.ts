import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';
import type { IAnlass } from 'src/app/core/model/IAnlass';
import type { IRanglistenEntry } from 'src/app/core/model/IRanglistenEntry';
import { TiTuEnum } from 'src/app/core/model/TiTuEnum';

@Component({
  selector: 'lxt-ranglisten-entry',
  templateUrl: './ranglisten-entry.component.html',
  styleUrls: ['./ranglisten-entry.component.css'],
  standalone: true,
  imports: [CommonModule],
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
  @Input()
  tiTu: TiTuEnum;
  ngOnDestroy() {}

  get isTu(): boolean {
    // const s1 = this.tiTu.toString();
    // const s2 = TiTuEnum.Tu.toString();
    const res = TiTuEnum.Tu === this.tiTu;
    return res;
  }
}
