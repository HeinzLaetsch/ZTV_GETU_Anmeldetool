import { OnDestroy, Injectable } from "@angular/core";
import { Unsubscribable } from "rxjs";

@Injectable()
export abstract class SubscriptionHelper implements OnDestroy {
  private subscriptions: Array<Unsubscribable> = [];

  registerSubscription(subscription: Unsubscribable) {
    this.subscriptions.push(subscription);
  }

  ngOnDestroy(): void {
    this.subscriptions.forEach((subscription) => subscription.unsubscribe());
  }
}
