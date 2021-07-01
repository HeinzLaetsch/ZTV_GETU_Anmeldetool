import {CommonModule} from '@angular/common';
import {NgModule} from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MaterialModule } from 'src/app/material-module';
import { UserComponent } from './user/user.component';

export const COMPONENTS = [
  UserComponent
]

@NgModule({
  declarations: [
    COMPONENTS
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MaterialModule
  ],
  exports: [
    COMPONENTS
  ]
})
export class SharedComponentsModule { }
