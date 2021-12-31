import { NgModule } from "@angular/core";
import { AuthService } from "./auth/auth.service";
import { ToastrService } from "./toastr/toastr.service";
import { VerbandService } from "./verband/verband.service";
import { VereinService } from "./verein/verein.service";

@NgModule({
  declarations: [],
  imports: [],
  providers: [ToastrService, AuthService, VereinService, VerbandService],
})
export class ServiceModule {}
