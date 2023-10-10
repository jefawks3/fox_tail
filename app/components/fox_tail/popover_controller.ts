import { Controller } from '@hotwired/stimulus';
import {
    flip,
    Placement,
    shift,
    offset,
    Middleware,
    inline,
} from '@floating-ui/dom';

import useFloatingUI from '../../../src/mixins/use_floating_ui';
import useClickOutside from '../../../src/mixins/use_click_outside';
import useKeyboardListener from '../../../src/mixins/use_keyboard_listener';

export default class extends Controller {
    static classes = ['visible', 'hidden'];
    static outlets = ['fox-tail--popover-trigger'];

    static values = {
        placement: {
            type: String,
            default: 'top',
        },
        offset: {
            type: Number,
            default: 10,
        },
        shift: {
            type: Number,
            default: 0,
        },
        inline: {
            type: Boolean,
            default: false,
        },
        delay: {
            type: Number,
            default: 300,
        },
    };

    declare readonly foxTailPopoverTriggerOutletElement: Element;
    declare readonly placementValue: string;
    declare readonly offsetValue: number;
    declare readonly shiftValue: number;
    declare readonly inlineValue: boolean;
    declare readonly delayValue: number;
    declare readonly visibleClasses: string[];
    declare readonly hiddenClasses: string[];

    private _isVisible: boolean = false;
    private attachFloating: () => void = () => {};
    private detachFloating: () => void = () => {};
    private observeClickOutside: () => void = () => {};
    private unobserveClickOutside: () => void = () => {};
    private observeKeyboard: () => void = () => {};
    private unobserveKeyboard: () => void = () => {};

    connect() {
        super.connect();

        const middleware: Middleware[] = [
            offset({
                mainAxis: this.offsetValue,
                crossAxis: this.shiftValue,
            }),
            flip(),
            shift(),
        ];

        this.inlineValue && middleware.unshift(inline());

        [this.attachFloating, this.detachFloating] = useFloatingUI(this, {
            referenceElement: this.foxTailPopoverTriggerOutletElement,
            strategy: 'absolute',
            placement: this.placementValue as Placement,
            middleware,
        });

        [this.observeClickOutside, this.unobserveClickOutside] =
            useClickOutside(this);

        [this.observeKeyboard, this.unobserveKeyboard] = useKeyboardListener(
            this,
            {
                element: document.body,
                eventName: 'keydown',
                key: 'Escape',
            },
        );
    }

    show(): void {
        if (this.showPopover()) {
            this.observeClickOutside();
            this.observeKeyboard();
        }
    }

    hide(): void {
        if (this.hidePopover()) {
            this.unobserveClickOutside();
            this.unobserveKeyboard();
        }
    }

    toggle(): void {
        if (this._isVisible) {
            this.hide();
        } else {
            this.show();
        }
    }

    hoverShow(): void {
        this.showPopover();
    }

    hoverHide(): void {
        setTimeout(() => {
            if (!this.foxTailPopoverTriggerOutletElement.matches(':hover')) {
                this.hidePopover();
            }
        }, this.delayValue);
    }

    protected onShow(): boolean {
        return this.dispatch('show', { cancelable: true }).defaultPrevented;
    }

    protected onShown(): void {
        this.dispatch('shown');
    }

    protected onHide(): boolean {
        return this.dispatch('hide', { cancelable: true }).defaultPrevented;
    }

    protected onHidden(): void {
        this.dispatch('hidden');
    }

    private showPopover(): boolean {
        if (this._isVisible || this.onShow()) {
            return false;
        }

        this.attachFloating();
        this.element.classList.remove(...this.hiddenClasses);
        this.element.classList.add(...this.visibleClasses);
        this.element.removeAttribute('aria-hidden');
        this._isVisible = true;
        this.onShown();

        return true;
    }

    private hidePopover(): boolean {
        if (!this._isVisible || this.onHide()) {
            return false;
        }

        this.detachFloating();
        this.element.classList.remove(...this.visibleClasses);
        this.element.classList.add(...this.hiddenClasses);
        this.element.setAttribute('aria-hidden', 'true');
        this._isVisible = false;
        this.onHidden();

        return true;
    }

    protected onClickOutside({ target }: Event): void {
        const outsideTrigger =
            !this.foxTailPopoverTriggerOutletElement.contains(target as Node) &&
            this.foxTailPopoverTriggerOutletElement != target;

        this.application.logDebugActivity(this.identifier, 'onClickOutside', {
            outsideTrigger: outsideTrigger,
        });
        outsideTrigger && this.hide();
    }
}
