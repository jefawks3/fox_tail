
type UnsubscribeToCallback = () => void;

export interface SubscribeToOptions extends AddEventListenerOptions {
    eventPrefix?: string;
}

export const getEventNames = (eventName: string | string[], prefix?: string): string[] => {
    const eventNames = Array.isArray(eventName) ? eventName : [eventName];
    return prefix ? eventNames.map((name) => `${prefix}:${name}`) : eventNames;
}

const addEventListeners = (target: Element, eventNames: string[], callback: EventListenerOrEventListenerObject, options: AddEventListenerOptions): void => {
    eventNames.forEach((name) => target.addEventListener(name, callback, options));
}

const removeEventListeners = (target: Element, eventNames: string[], callback: EventListenerOrEventListenerObject, options: AddEventListenerOptions): void => {
    eventNames.forEach((name) => target.removeEventListener(name, callback, options));
}

export const unsubscribeTo = (target: Element, eventName: string | string[], callback: EventListenerOrEventListenerObject, options?: SubscribeToOptions): void => {
    const { eventPrefix, ...eventOptions } = Object.assign({}, options) as SubscribeToOptions;
    const eventNames = getEventNames(eventName, eventPrefix);
    removeEventListeners(target, eventNames, callback, eventOptions);
}

export const subscribeTo = (target: Element, eventName: string | string[], callback: EventListenerOrEventListenerObject, options?: SubscribeToOptions): UnsubscribeToCallback => {
    const { eventPrefix, ...eventOptions } = Object.assign({}, options) as SubscribeToOptions;
    const eventNames = getEventNames(eventName, eventPrefix);
    const unsubscribe = () => removeEventListeners(target, eventNames, callback, eventOptions);

    addEventListeners(target, eventNames, callback, eventOptions);
    return unsubscribe;
}
