import {Controller} from "@hotwired/stimulus";

import {safeCallMethod} from "../utilities/reflection";

interface Options {
    element?: Element | Window;
    eventName: string[] | string;
    key?: string[] | string;
}

const DEFAULT_OPTIONS: Options = {
    eventName: "keydown",
};

export default (controller: Controller, options: Partial<Options> = {}) => {
    const {element, eventName, key} =
        Object.assign({}, DEFAULT_OPTIONS, options) as Options;

    const listener = element || controller.element;
    const events = Array.isArray(eventName) ? eventName : [eventName];
    const keys = !key || Array.isArray(key) ? key : [key];

    const callback = (event: KeyboardEvent): void => {
        if (!keys || keys.includes(event.key)) {
            controller.application.logDebugActivity('useKeyboardListener', 'callback', {key: event.key, event});
            safeCallMethod(controller, 'onKeyboardEvent', event);
        }
    }

    const attach = () => {
        events.forEach((event) => listener.addEventListener(event, callback as any, true));
    }

    const detach = () => {
        events.forEach((event) => listener.removeEventListener(event, callback as any, true));
    }

    const controllerDisconnect = controller.disconnect.bind(controller);

    Object.assign(controller, {
        disconnect() {
            detach()
            controllerDisconnect()
        },
    });

    return [attach, detach] as const;
}
