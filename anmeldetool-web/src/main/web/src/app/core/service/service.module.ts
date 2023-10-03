import { NgModule } from "@angular/core";
import { AuthService } from "./auth/auth.service";
import { VerbandService } from "./verband/verband.service";
import { VereinService } from "./verein/verein.service";
import { SmQualiService } from "./smquali/smquali.service";

@NgModule({
  declarations: [],
  imports: [],
  providers: [AuthService, VereinService, VerbandService, SmQualiService],
})
export class ServiceModule {}
