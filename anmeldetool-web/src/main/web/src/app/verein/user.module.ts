import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { UserRoutes } from './user.routes';

@NgModule({
  imports: [
    RouterModule.forChild(UserRoutes),
    // StoreModule.forFeature(userFeature),
    // EffectsModule.forFeature([UserEffects]),
  ],
  providers: [],
})
export class UserModule {}
