import { Controller } from '@hotwired/stimulus';

export default class extends Controller<HTMLInputElement> {
    private _visible: boolean = false;

    get isVisible(): boolean {
        return this._visible;
    }

    connect() {
        super.connect();

        this.element.setAttribute('type', 'password');
    }

    show() {
        if (this._visible || this.onShow()) {
            return;
        }

        this.element.type = 'text';
        this.element.focus();
        this._visible = true;
        this.onShown();
    }

    hide() {
        if (!this._visible || this.onHide()) {
            return;
        }

        this.element.type = 'password';
        this.element.focus();
        this._visible = false;
        this.onHidden();
    }

    toggle() {
        if (this._visible) {
            this.hide();
        } else {
            this.show();
        }
    }

    onShow(): boolean {
        return this.dispatch('show', { cancelable: true }).defaultPrevented;
    }

    onShown() {
        this.dispatch('shown', { cancelable: false });
    }

    onHide(): boolean {
        return this.dispatch('hide', { cancelable: true }).defaultPrevented;
    }

    onHidden() {
        this.dispatch('hidden', { cancelable: false });
    }
}
