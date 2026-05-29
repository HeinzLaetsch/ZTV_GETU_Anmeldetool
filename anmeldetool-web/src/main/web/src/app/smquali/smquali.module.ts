import { NgModule } from '@angular/core';
import { SMQualiRoutingModule } from './smquali.routes';
import { SmQualiViewerComponent } from './smquali-viewer/smquali-viewer.component';

@NgModule({
  imports: [SMQualiRoutingModule, SmQualiViewerComponent],
  providers: [],
})
export class SMQualiModule {}
