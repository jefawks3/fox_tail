export default (event: Event): Event => {
    const proxy = new CustomEvent(event.type, {
        cancelable: event.cancelable,
        detail: (event as any).detail,
    });

    Object.defineProperty(proxy, 'defaultPrevented', {
        get(): boolean {
            return event.defaultPrevented;
        },
    });

    return Object.assign(proxy, {
        params: (event as any).params,
        preventDefault: () => {
            event.preventDefault();
        },
        stopPropagation: () => {
            event.stopPropagation();
        },
        stopImmediatePropagation: () => {
            event.stopImmediatePropagation();
        },
    });
};
