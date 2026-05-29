import { Injectable, type OnDestroy } from "@angular/core";
import type { Unsubscribable } from "rxjs";

@Injectable()
export abstract class SubscriptionHelper implements OnDestroy {
	private subscriptions: Unsubscribable[] = [];

	registerSubscription(subscription: Unsubscribable): void {
		this.subscriptions.push(subscription);
	}

	ngOnDestroy(): void {
		this.subscriptions.forEach((subscription) => {
			subscription.unsubscribe();
		});
	}
}
