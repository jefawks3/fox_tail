import { Controller } from '@hotwired/stimulus';
import PasswordInputController from './password_input_controller';
import useForwardedEventListener from '../../../src/mixins/use_forwarded_event_listener';

export default class extends Controller {
    static classes = ['hidden', 'visible'];
    static outlets = ['fox-tail--password-input'];

    declare readonly hiddenClasses: string[];
    declare readonly visibleClasses: string[];
    declare readonly foxTailPasswordInputOutlet: PasswordInputController;
    declare readonly foxTailPasswordInputOutletElement: Element;

    private _unsubscribeListener: (() => void) | null = null;

    foxTailPasswordInputOutletConnected(
        _outlet: PasswordInputController,
        element: Element,
    ): void {
        const [observe, unobserve] = useForwardedEventListener(
            this,
            ['show', 'shown', 'hide', 'hidden'],
            element,
            this.element,
            { capture: true, eventPrefix: 'fox-tail--password-input' },
        );

        this._unsubscribeListener = unobserve;
        observe();

        this.updateAttributes();
    }

    foxTailPasswordInputOutletDisconnected() {
        if (this._unsubscribeListener) {
            this._unsubscribeListener();
            this._unsubscribeListener = null;
        }
    }

    disconnect() {
        super.disconnect();

        this.foxTailPasswordInputOutletDisconnected();
    }

    show() {
        this.foxTailPasswordInputOutlet.show();
    }

    hide() {
        this.foxTailPasswordInputOutlet.hide();
    }

    toggle() {
        this.foxTailPasswordInputOutlet.toggle();
    }

    onForwardEvent(): void {
        this.updateAttributes();
    }

    private updateAttributes() {
        this.element.setAttribute(
            'aria-expanded',
            this.foxTailPasswordInputOutlet.isVisible.toString(),
        );

        if (this.foxTailPasswordInputOutlet.isVisible) {
            this.element.classList.remove(...this.hiddenClasses);
            this.element.classList.add(...this.visibleClasses);
        } else {
            this.element.classList.remove(...this.visibleClasses);
            this.element.classList.add(...this.hiddenClasses);
        }
    }
}
