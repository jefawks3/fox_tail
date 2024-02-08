import { Controller } from '@hotwired/stimulus';

import { safeCallMethod } from '../utilities/reflection';
import useEventListeners from './use_event_listeners';

interface Options {
    element?: Element;
    events?: string[];
}

const DEFAULT_OPTIONS = {
    events: ['click', 'touchend'],
};

export default (controller: Controller, options?: Options) => {
    const { element, events } = Object.assign(
        {},
        DEFAULT_OPTIONS,
        { element: controller.element },
        options,
    );

    const handleClickOutside = (event: Event): void => {
        const outside =
            !element?.contains(event.target as Node) && event.target != element;
        controller.application.logDebugActivity(
            'use-click-outside',
            'handleClickOutside',
            { outside, event },
        );

        if (outside) {
            safeCallMethod(controller, 'onClickOutside', event);
        }
    };

    const [observeEvents, unobserveEvents] = useEventListeners(
        controller,
        window,
        events,
        handleClickOutside,
        true,
    );

    return [observeEvents, unobserveEvents] as const;
};
