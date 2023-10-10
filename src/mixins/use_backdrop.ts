import { Controller } from '@hotwired/stimulus';

import { safeCallMethod } from '../utilities/reflection';

interface Options {
    classes?: string[] | undefined;
}

const DEFAULT_CLASSES =
    'bg-gray-900 bg-opacity-50 dark:bg-opacity-80 fixed inset-0 z-30';

export default (controller: Controller, options: Options = {}) => {
    let backdrop: HTMLElement | undefined = undefined;

    const handleClick = (e: Event) => {
        controller.application.logDebugActivity(
            'useBackdrop',
            'onBackdropClicked',
        );
        safeCallMethod(controller, 'onBackdropClicked', e);
    };

    const show = () => {
        if (backdrop) {
            return;
        }

        backdrop = document.createElement('div');

        if (options.classes && options.classes.length > 0) {
            backdrop.classList.add(...options.classes);
        } else {
            backdrop.className = DEFAULT_CLASSES;
        }

        document.querySelector('body')?.append(backdrop);
        backdrop.addEventListener('click', handleClick);
        safeCallMethod(controller, 'onBackdropShown', { backdrop });
    };

    const hide = () => {
        if (!backdrop) {
            return;
        }

        backdrop.remove();
        backdrop = undefined;
        safeCallMethod(controller, 'onBackdropHidden');
    };

    const controllerDisconnect = controller.disconnect.bind(controller);

    Object.assign(controller, {
        get backdropElement(): HTMLElement | undefined {
            return backdrop;
        },
        disconnect() {
            hide();
            controllerDisconnect();
        },
    });

    return [show, hide];
};
