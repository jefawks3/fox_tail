import {Controller} from "@hotwired/stimulus";

import {safeCallMethod} from "../utilities/reflection";

interface Options {
    classes?: string[] | null | undefined;
}

const DEFAULT_CLASSES = "overflow-hidden";

export default (controller: Controller, options: Options = {}) => {
    let scrollPrevented = false;

    const preventScroll = () => {
        if (scrollPrevented) {
            return;
        }

        if (options.classes && options.classes.length > 0) {
            document.body.classList.add(...options.classes);
        } else {
            document.body.classList.add(DEFAULT_CLASSES);
        }

        safeCallMethod(controller, "onBodyScrollingDisabled");
    }

    const enableScroll = () => {
        if (!scrollPrevented) {
            return;
        }

        if (options.classes && options.classes.length > 0) {
            document.body.classList.remove(...options.classes);
        } else {
            document.body.classList.remove(DEFAULT_CLASSES);
        }

        safeCallMethod(controller, "onBodyScrollingEnabled");
    }


    const controllerDisconnect = controller.disconnect.bind(controller);

    Object.assign(controller, {
        disconnect() {
            enableScroll();
            controllerDisconnect();
        },
    });

    return [preventScroll, enableScroll];
}