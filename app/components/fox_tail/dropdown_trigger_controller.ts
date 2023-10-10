import { Controller } from '@hotwired/stimulus';
import DropdownController from './dropdown_controller';
import useForwardedEventListener from '../../../src/mixins/use_forwarded_event_listener';

export default class extends Controller {
    static classes = ['open', 'closed'];
    static outlets = ['fox-tail--dropdown'];

    static values = {
        delay: {
            type: Number,
            default: 300,
        },
    };

    declare readonly delayValue: number;
    declare readonly openClasses: string[];
    declare readonly closedClasses: string[];
    declare readonly foxTailDropdownOutlet: DropdownController;
    declare readonly foxTailDropdownOutletElement: Element;

    declare _unsubscribeListener: (() => void) | null;

    foxTailDropdownOutletConnected(
        _outlet: DropdownController,
        element: Element,
    ): void {
        const [observe, unobserve] = useForwardedEventListener(
            this,
            ['show', 'shown', 'hide', 'hidden'],
            element,
            this.element,
            { capture: true, eventPrefix: 'fox-tail--dropdown' },
        );

        this._unsubscribeListener = unobserve;
        observe();

        this.updateAttributes();
    }

    show(): void {
        this.foxTailDropdownOutlet.show();
    }

    hoverShow(): void {
        setTimeout(
            () => this.foxTailDropdownOutlet.hoverShow(),
            this.delayValue,
        );
    }

    hide(): void {
        this.foxTailDropdownOutlet.hide();
    }

    hoverHide(): void {
        setTimeout(() => {
            if (!this.foxTailDropdownOutletElement.matches(':hover')) {
                this.foxTailDropdownOutlet.hoverHide();
            }
        }, this.delayValue);
    }

    toggle(): void {
        this.foxTailDropdownOutlet.toggle();
    }

    toggleWithDelay(): void {
        setTimeout(() => this.toggle(), this.delayValue);
    }

    onForwardEvent(): void {
        this.updateAttributes();
    }

    private updateAttributes(): void {
        this.element.setAttribute(
            'aria-expanded',
            this.foxTailDropdownOutlet.isVisible.toString(),
        );

        if (this.foxTailDropdownOutlet.isVisible) {
            this.element.classList.remove(...this.closedClasses);
            this.element.classList.add(...this.openClasses);
        } else {
            this.element.classList.remove(...this.openClasses);
            this.element.classList.add(...this.closedClasses);
        }
    }
}
