import {Controller} from "@hotwired/stimulus";

import useBackdrop from "../../../src/mixins/use_backdrop";
import usePreventBodyScroll from "../../../src/mixins/use_prevent_body_scroll";
import useKeyboardListener from "../../../src/mixins/use_keyboard_listener";

export default class extends Controller {
    static classes = ["visible", "hidden", "backdrop", "body"]

    static values = {
        backdrop: {
            type: Boolean,
            default: true,
        },
        bodyScrolling: {
            type: Boolean,
            default: true,
        },
        open: {
            type: Boolean,
            default: false,
        }
    }

    declare readonly backdropValue: boolean;
    declare readonly bodyScrollingValue: boolean;
    declare readonly openValue: boolean;
    declare readonly visibleClasses: string[];
    declare readonly hiddenClasses: string[];
    declare readonly backdropClasses: string[];
    declare readonly bodyClasses: string[];

    private _visible = false;
    private _showBackdrop = () => {};
    private _hideBackdrop = () => {};
    private _disableBodyScrolling = () => {};
    private _enableBodyScrolling = () => {};

    get isVisible(): boolean {
        return this._visible;
    }

    connect() {
        super.connect();

        if (this.backdropValue) {
            [this._showBackdrop, this._hideBackdrop] = useBackdrop(this, { classes: this.backdropClasses });
        }

        if (this.bodyScrollingValue) {
            [this._disableBodyScrolling, this._enableBodyScrolling] = usePreventBodyScroll(this, { classes: this.bodyClasses });
        }

        useKeyboardListener(this)[0]();

        if (this.openValue) { this.show() }
    }

    toggle() {
        if (this._visible) {
            this.hide();
        } else {
            this.show();
        }
    }

    show() {
        if (this._visible || this.onShow()) {
            return;
        }

        this.element.classList.remove(...this.hiddenClasses);
        this.element.classList.add(...this.visibleClasses);
        this.element.setAttribute("aria-modal", "true");
        this.element.setAttribute("role", "dialog");
        this.element.removeAttribute("aria-hidden");
        this._disableBodyScrolling();
        this._showBackdrop();
        this._visible = true;
        this.onShown();
    }

    hide() {
        if (!this._visible || this.onHide()) {
            return;
        }

        this.element.classList.remove(...this.visibleClasses);
        this.element.classList.add(...this.hiddenClasses);
        this.element.setAttribute("aria-hidden", "true");
        this.element.removeAttribute("aria-model");
        this.element.removeAttribute("role");
        this._enableBodyScrolling();
        this._hideBackdrop();
        this._visible = false;
        this.onHidden();
    }

    protected onShow(): boolean {
        return this.dispatch('show', {cancelable: true}).defaultPrevented;
    }

    protected onShown(): void {
        this.dispatch('shown');
    }

    protected onHide(): boolean {
        return this.dispatch('hide', {cancelable: true}).defaultPrevented;
    }

    protected onHidden(): void {
        this.dispatch('hidden');
    }

    protected onBackdropClicked() {
        this.hide();
    }

    protected onKeyboardEvent(event: KeyboardEvent) {
        if (event.key === 'Escape') {
            this.hide();
        }
    }
}
