import { Controller } from '@hotwired/stimulus';

import { safeCallMethod } from '../../../src/utilities/reflection';

const TRIGGER_TYPES: { [key: string]: { [key: string]: string[] } } = {
    hover: {
        show: ['mouseenter', 'focus'],
        hide: ['mouseleave', 'blur'],
    },
    click: {
        show: ['click', 'focus'],
        hide: ['focusout', 'blur'],
    },
};

export default class extends Controller {
    static targets = ['menu', 'button'];
    static classes = ['visible', 'hidden'];

    static values = {
        triggerType: {
            type: String,
            default: 'hover',
        },
    };

    declare readonly triggerTypeValue: string;
    declare readonly menuTarget: HTMLElement;
    declare readonly buttonTarget: HTMLElement;
    declare readonly visibleClasses: string[];
    declare readonly hiddenClasses: string[];

    private _visible = false;

    buttonTargetConnected(element: HTMLElement): void {
        if (this.triggerTypeValue == 'hover') {
            return;
        }

        for (const [method, events] of Object.entries(
            TRIGGER_TYPES[this.triggerTypeValue] || {},
        )) {
            events.forEach((event) => {
                element.addEventListener(event, () =>
                    safeCallMethod(this, method),
                );
            });
        }
    }

    connect() {
        super.connect();

        if (this.triggerTypeValue == 'hover') {
            for (const [method, events] of Object.entries(
                TRIGGER_TYPES.hover,
            )) {
                events.forEach((event) => {
                    this.element.addEventListener(event, () =>
                        safeCallMethod(this, method),
                    );
                });
            }
        }
    }

    toggle(): void {
        if (this._visible) {
            this.hide();
        } else {
            this.show();
        }
    }

    show(): void {
        if (this._visible || this.onShow()) {
            return;
        }

        this.element.classList.remove(...this.hiddenClasses);
        this.element.classList.add(...this.visibleClasses);
        this.buttonTarget.setAttribute('aria-expanded', 'true');

        this._visible = true;
        this.onShown();
    }

    hide(): void {
        if (!this._visible || this.onHide()) {
            return;
        }

        this.element.classList.remove(...this.visibleClasses);
        this.element.classList.add(...this.hiddenClasses);
        this.buttonTarget.setAttribute('aria-expanded', 'false');

        this._visible = false;
        this.onHidden();
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
}
