import { Component, type OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'lxt-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss'],
  standalone: true,
  imports: [CommonModule],
})
export class HeaderComponent implements OnInit {
  headerClass = 'test';

  constructor() {}

  ngOnInit(): void {}
}
