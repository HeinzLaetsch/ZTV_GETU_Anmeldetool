import { ChangeDetectionStrategy, Component, inject, input, type OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import type { ILaufliste } from 'src/app/core/model/ILaufliste';
import type { IUser } from 'src/app/core/model/IUser';
import { AuthService } from 'src/app/core/service/auth/auth.service';

@Component({
  selector: 'ztv-erfassen-header',
  templateUrl: './erfassen-header.component.html',
  styleUrls: ['./erfassen-header.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  imports: [CommonModule],
})
export class ErfassenHeaderComponent implements OnInit {
  readonly laufliste = input.required<ILaufliste>();

  currentUser: IUser;

  private readonly authService = inject(AuthService);

  ngOnInit(): void {
    this.currentUser = this.authService.currentUser;
  }
}
