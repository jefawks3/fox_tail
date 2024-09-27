import { Controller } from '@hotwired/stimulus';

import useEventListeners from '../../../src/mixins/use_event_listeners';
import proxyEvent from '../../../src/utilities/proxy_event';

export default class extends Controller {
    static values = {
        query: String,
        events: String,
    };

    declare readonly queryValue: string;
    declare readonly eventsValue: string;

    connect() {
        super.connect();

        const selector = document.querySelectorAll(this.queryValue);
        const targets = Array.from(selector);
        const events = this.eventsValue.split(' ');

        useEventListeners(this, targets, events, this.listenTo.bind(this), {
            attached: true,
        });
    }

    private listenTo(event: CustomEvent) {
        this.application.logDebugActivity(this.identifier, 'listenTo', {
            event,
        });

        this.element.dispatchEvent(proxyEvent(event));
    }
}
