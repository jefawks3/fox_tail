import {Controller} from "@hotwired/stimulus";

import {safeCallMethod} from "../utilities/reflection";
import {subscribeTo, SubscribeToOptions} from "../utilities/event_helpers";

export interface ForwardedEvent {
    event: Event;
    element: Element;
    target: Element;
}

export default (controller: Controller, eventName: string[] | string, listenTo: Element, forwardTo: Element, options?: SubscribeToOptions) => {
    const handler = (event: CustomEvent) => {
        const {detail, bubbles, cancelable} = event;
        const newEvent = new CustomEvent(event.type, {detail, bubbles, cancelable});

        safeCallMethod(controller, "onForwardEvent", { element: listenTo, target: forwardTo, event });
        forwardTo.dispatchEvent(newEvent);
        cancelable && newEvent.defaultPrevented && event.preventDefault();
    }

    let unsubscribe: (() => void) | null = null;

    const observe = () => {
        unsubscribe = subscribeTo(listenTo, eventName, handler as any, options);
    }

    const unobserve = () => {
        if (unsubscribe) {
            unsubscribe();
        }

        unsubscribe = null;
    }

    return [observe, unobserve] as const;
}
