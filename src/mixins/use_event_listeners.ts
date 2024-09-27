import { Controller } from '@hotwired/stimulus';

interface UseEventListenersOptions extends AddEventListenerOptions {
    attached?: boolean;
}

type EventTarget = Element | Window;
type EventList = string[];
type EventName = EventList | string;
type EventOptions = boolean | UseEventListenersOptions;

export default (
    controller: Controller,
    target: EventTarget | EventTarget[],
    events: EventName,
    callback: EventListenerOrEventListenerObject,
    options?: EventOptions,
) => {
    const eventArray = Array.isArray(events) ? events : [events];
    const targets = Array.isArray(target) ? target : [target];

    const { attached, ...eventOptions } = Object.assign(
        { attached: false },
        typeof options === 'boolean' ? { capture: options } : options,
    );

    const attachListeners = (): void => {
        controller.application.logDebugActivity(
            controller.identifier,
            'attachListeners',
            { targets, events: eventArray, options: eventOptions },
        );

        eventArray.forEach((eventName) =>
            targets.forEach((t) =>
                t.addEventListener(eventName, callback, eventOptions),
            ),
        );
    };

    const detachListeners = (): void => {
        controller.application.logDebugActivity(
            controller.identifier,
            'detachListeners',
            { targets, events: eventArray, options: eventOptions },
        );

        eventArray.forEach((eventName) =>
            targets.forEach((t) =>
                t.removeEventListener(eventName, callback, eventOptions),
            ),
        );
    };

    attached && attachListeners();

    const controllerDisconnect = controller.disconnect.bind(controller);

    Object.assign(controller, {
        disconnect() {
            detachListeners();
            controllerDisconnect();
        },
    });

    return [attachListeners, detachListeners] as const;
};
