import { Controller } from '@hotwired/stimulus';

import CollapsibleController from './collapsible_controller';
import useForwardedEventListener from '../../../src/mixins/use_forwarded_event_listener';

export default class extends Controller {
    static classes = ['expanded', 'collapsed'];
    static outlets = ['fox-tail--collapsible'];

    static values = {
        collapsed: {
            type: Boolean,
            default: false,
        },
    };

    declare readonly expandedClasses: string[];
    declare readonly collapsedClasses: string[];
    declare readonly foxTailCollapsibleOutlet: CollapsibleController;

    declare _unsubscribeListener: (() => void) | null;

    foxTailCollapsibleOutletConnected(
        _outlet: CollapsibleController,
        element: Element,
    ): void {
        const [observe, unobserve] = useForwardedEventListener(
            this,
            ['show', 'shown', 'hide', 'hidden'],
            element,
            this.element,
            { capture: true, eventPrefix: 'fox-tail--collapsible' },
        );

        this._unsubscribeListener = unobserve;
        observe();
    }

    foxTailCollapsibleOutletDisconnected(): void {
        this._unsubscribeListener && this._unsubscribeListener();
        this._unsubscribeListener = null;
    }

    show(): void {
        this.foxTailCollapsibleOutlet.show();
    }

    hide(): void {
        this.foxTailCollapsibleOutlet.hide();
    }

    toggle(): void {
        this.foxTailCollapsibleOutlet.toggle();
    }

    onForwardEvent(): void {
        this.element.setAttribute(
            'aria-expanded',
            this.foxTailCollapsibleOutlet.isVisible.toString(),
        );

        if (this.foxTailCollapsibleOutlet.isVisible) {
            this.element.classList.remove(...this.collapsedClasses);
            this.element.classList.add(...this.expandedClasses);
        } else {
            this.element.classList.remove(...this.expandedClasses);
            this.element.classList.add(...this.collapsedClasses);
        }
    }
}
