import { Controller } from '@hotwired/stimulus';

export default class extends Controller<
    HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement
> {
    private _valid: boolean = true;

    get isValid(): boolean {
        return this.element.checkValidity();
    }

    get disabled(): boolean {
        return this.element.disabled;
    }

    connect() {
        super.connect();

        this._valid = this.element.checkValidity();
    }

    enable() {
        this.element.disabled = false;
    }

    disable() {
        this.element.disabled = true;
    }

    validate() {
        this.updateValidity(this.isValid);
    }

    reportValidation() {
        this.updateValidity(this.element.reportValidity());
    }

    private updateValidity(valid: boolean) {
        if (this._valid == valid) {
            return;
        }

        this._valid = valid;
        this.dispatch(valid ? 'valid' : 'invalid');
    }
}
