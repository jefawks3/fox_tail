import { Controller } from '@hotwired/stimulus';

import usePreventBodyScroll from '../../../src/mixins/use_prevent_body_scroll';
import useKeyboardListener from '../../../src/mixins/use_keyboard_listener';
import useClickOutside from '../../../src/mixins/use_click_outside';
import Stack from '../../../src/utilities/stack';

const modals = new Stack<ModalController>();

export default class ModalController extends Controller {
    static classes = ['visible', 'hidden', 'body'];
    static targets = ['content'];

    static values = {
        static: {
            type: Boolean,
            default: false,
        },
        closeable: {
            type: Boolean,
            default: true,
        },
        bodyScrolling: {
            type: Boolean,
            default: false,
        },
        open: {
            type: Boolean,
            default: false,
        },
    };

    declare readonly staticValue: boolean;
    declare readonly closeableValue: boolean;
    declare readonly bodyScrolling: boolean;
    declare readonly openValue: boolean;
    declare readonly zIndexValue: number;
    declare readonly visibleClasses: string[];
    declare readonly hiddenClasses: string[];
    declare readonly bodyClasses: string[];
    declare readonly hasContentTarget: boolean;
    declare readonly contentTarget: HTMLElement;

    declare readonly backdropElement: HTMLElement | undefined;

    private _open = false;
    private _visible = false;
    private _attachKeyboard = () => {};
    private _detachKeyboard = () => {};
    private _attachClickOutside = () => {};
    private _detachClickOutside = () => {};
    private _enableBodyScrolling = () => {};
    private _disableBodyScrolling = () => {};

    get isOpen(): boolean {
        return this._open;
    }

    get isVisible(): boolean {
        return this._visible;
    }

    get isActive(): boolean {
        return modals.peak() === this;
    }

    connect() {
        super.connect();

        if (!this.bodyScrolling) {
            [this._disableBodyScrolling, this._enableBodyScrolling] =
                usePreventBodyScroll(this, {
                    classes: this.bodyClasses,
                });
        }

        if (this.closeableValue) {
            [this._attachKeyboard, this._detachKeyboard] = useKeyboardListener(
                this,
                { element: document.body },
            );

            if (!this.staticValue) {
                [this._attachClickOutside, this._detachClickOutside] =
                    useClickOutside(this, {
                        element: this.hasContentTarget
                            ? this.contentTarget
                            : this.element.children[0],
                    });
            }
        }

        if (this.openValue) {
            this.show();
        }
    }

    disconnect() {
        super.disconnect();
        modals.remove(this);
    }

    toggle(): void {
        if (this._visible) {
            this.hide();
        } else {
            this.show();
        }
    }

    show(): void {
        if (this._open || this.onShow()) {
            return;
        }

        this._open = true;
        modals.forEach((modal: ModalController) => modal.moveToBackground());
        modals.push(this);
        this.moveToForeground();
        this.onShown();
    }

    hide(): void {
        if (!this._open || this.onHide()) {
            return;
        }

        this._open = false;
        modals.remove(this);
        this.moveToBackground();
        modals.peak()?.moveToForeground();
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

    protected onKeyboardEvent(event: KeyboardEvent): void {
        if (this.isActive && event.key === 'Escape') {
            this.hide();
        }
    }

    protected onClickOutside(): void {
        this.isActive && this.hide();
    }

    private moveToForeground(): void {
        if (this._visible) {
            return;
        }

        this._visible = true;
        this.element.classList.add(...this.visibleClasses);
        this.element.classList.remove(...this.hiddenClasses);
        this.element.setAttribute('aria-modal', 'true');
        this.element.setAttribute('role', 'dialog');
        this.element.removeAttribute('aria-hidden');
        this._disableBodyScrolling();
        this._attachKeyboard();
        this._attachClickOutside();
    }

    private moveToBackground(): void {
        if (!this._visible) {
            return;
        }

        this._visible = false;
        this.element.classList.add(...this.hiddenClasses);
        this.element.classList.remove(...this.visibleClasses);
        this.element.removeAttribute('aria-modal');
        this.element.removeAttribute('role');
        this.element.setAttribute('aria-hidden', 'true');
        this._enableBodyScrolling();
        this._detachKeyboard();
        this._detachClickOutside();
    }
}
