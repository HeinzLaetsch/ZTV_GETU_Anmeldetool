import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { smQualiRoutes } from './smquali.routes';
import { SmQualiViewerComponent } from './smquali-viewer/smquali-viewer.component';

@NgModule({
  imports: [RouterModule.forChild(smQualiRoutes), SmQualiViewerComponent],
  providers: [],
})
export class SMQualiModule {}
