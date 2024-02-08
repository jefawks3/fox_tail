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
    target: EventTarget,
    events: EventName,
    callback: EventListenerOrEventListenerObject,
    options?: EventOptions,
) => {
    const eventArray = typeof events === 'string' ? [events] : events;
    const { attached, ...eventOptions } = Object.assign(
        { attached: false },
        typeof options === 'boolean' ? { capture: options } : options,
    );

    const attachListeners = (): void => {
        eventArray.forEach((eventName) =>
            target.addEventListener(eventName, callback, eventOptions),
        );
    };

    const detachListeners = (): void => {
        eventArray.forEach((eventName) =>
            target.removeEventListener(eventName, callback),
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
