import { ChangeDetectionStrategy, Component, input, output } from '@angular/core';
import { FormsModule } from '@angular/forms';
import type { IRolle } from 'src/app/core/model/IRolle';
import { MaterialModule } from 'src/app/shared/material-module';

@Component({
  selector: 'ztv-role-chip',
  templateUrl: './role-chip.component.html',
  styleUrl: './role-chip.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [FormsModule, MaterialModule],
})
export class RoleChipComponent {
  protected readonly isVereinsAnmelder = input(false);
  protected readonly isVereinsVerantwortlicher = input(false);
  protected readonly role = input.required<IRolle>();
  protected readonly isAllRolesList = input(false);
  protected readonly roleChange = output<IRolle>();

  protected onAktivChange(): void {
    this.roleChange.emit(this.role());
  }
}
