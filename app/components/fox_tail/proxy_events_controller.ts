import { ActionEvent, Controller } from '@hotwired/stimulus';

import proxyEvent from '../../../src/utilities/proxy_event';

export default class extends Controller {
    static targets = ['listener'];

    static values = {
        query: String,
    };

    declare readonly listenerTargets: HTMLElement[];
    declare readonly hasQueryValue: boolean;
    declare readonly queryValue: string;

    proxy(event: CustomEvent | ActionEvent) {
        this.listenerTargets.forEach((target) =>
            this.proxyEvent(target, event),
        );

        if (this.hasQueryValue) {
            document
                .querySelectorAll(this.queryValue)
                .forEach((target) => this.proxyEvent(target, event));
        }
    }

    private proxyEvent(
        target: Element,
        event: CustomEvent | ActionEvent,
    ): void {
        this.application.logDebugActivity(this.identifier, 'proxyEvent', {
            event,
            listener: target,
        });

        target.dispatchEvent(proxyEvent(event));
    }
}
