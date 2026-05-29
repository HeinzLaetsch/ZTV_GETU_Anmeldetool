import { Component, Input, type OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { GeraeteEnum } from 'src/app/core/model/GeraeteEnum';
import type { ILaufliste } from 'src/app/core/model/ILaufliste';
import type { IUser } from 'src/app/core/model/IUser';
import { AuthService } from 'src/app/core/service/auth/auth.service';
import { CachingUserService } from 'src/app/core/service/caching-services/caching.user.service';

@Component({
  selector: 'lxt-erfassen-header',
  templateUrl: './erfassen-header.component.html',
  styleUrls: ['./erfassen-header.component.css'],
  standalone: true,
  imports: [CommonModule],
})
export class ErfassenHeaderComponent implements OnInit {
  @Input()
  laufliste: ILaufliste;

  currentUser: IUser;

  constructor(private authService: AuthService) {}

  ngOnInit() {
    this.currentUser = this.authService.currentUser;
  }
}
