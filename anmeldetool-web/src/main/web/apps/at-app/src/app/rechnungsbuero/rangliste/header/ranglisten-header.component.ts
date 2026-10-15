import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, Component, input } from '@angular/core';
import { TiTuEnum } from 'src/app/core/model/TiTuEnum';

@Component({
  selector: 'ztv-ranglisten-header',
  templateUrl: './ranglisten-header.component.html',
  styleUrls: ['./ranglisten-header.component.scss'],
  imports: [CommonModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class RanglistenHeaderComponent {
  readonly tiTu = input.required<TiTuEnum>();

  get isTu(): boolean {
    const res = TiTuEnum.Tu === this.tiTu();
    return res;
  }
}
