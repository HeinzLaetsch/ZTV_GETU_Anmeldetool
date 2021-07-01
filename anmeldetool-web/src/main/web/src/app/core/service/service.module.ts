import { NgModule } from '@angular/core';
import { EventService } from './event/event.service';
import { ToastrService } from './toastr/toastr.service';
import { AuthService } from './auth/auth.service';
import { VereinService } from './verein/verein.service';
import { VerbandService } from './verband/verband.service';

@NgModule({
  declarations: [
  ],
  imports: [
  ],
  providers: [
  	EventService,
  	ToastrService,
    AuthService,
    VereinService,
    VerbandService
]
})
export class ServiceModule { }
