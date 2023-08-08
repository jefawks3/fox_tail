
type EventTarget = Element | Window
type EventList = string[]
type EventName = EventList | string
type EventOptions = boolean | AddEventListenerOptions;

export default (target: EventTarget, events: EventName, callback: EventListenerOrEventListenerObject, options?: EventOptions) => {
    const eventArray = typeof events === "string" ? [events] : events;

    const attachListeners = (): void => {
        eventArray.forEach(eventName => target.addEventListener(eventName, callback, options));
    }

    const detachListeners = (): void => {
        eventArray.forEach(eventName => target.removeEventListener(eventName, callback));
    }

    return [attachListeners, detachListeners] as const;
}
