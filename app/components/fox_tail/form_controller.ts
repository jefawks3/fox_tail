import { Controller } from '@hotwired/stimulus';

export default class extends Controller<HTMLFormElement> {
    static values = {
        enabled: {
            type: Boolean,
            default: true,
        },
    };

    declare readonly listenerTargets: HTMLElement[];
    declare enabledValue: boolean;

    private _valid: boolean = true;

    get useTurbo() {
        return (
            typeof (window as any).Turbo !== 'undefined' &&
            (!this.element.hasAttribute('data-turbo') ||
                this.element.dataset.turbo)
        );
    }

    get isValid(): boolean {
        return this._valid;
    }

    connect() {
        this._valid = this.element.checkValidity();

        if (this.useTurbo) {
            this.element.addEventListener(
                'turbo:submit-start',
                this.handleTurboSubmitStarted.bind(this),
            );

            this.element.addEventListener(
                'turbo:submit-end',
                this.handleTurboSubmitEnded.bind(this),
            );
        } else {
            this.element.addEventListener(
                'submit',
                this.handleSubmit.bind(this),
            );
        }
    }

    disconnect() {
        if (this.useTurbo) {
            this.element.removeEventListener(
                'turbo:submit-start',
                this.handleTurboSubmitStarted.bind(this),
            );

            this.element.removeEventListener(
                'turbo:submit-end',
                this.handleTurboSubmitEnded.bind(this),
            );
        } else {
            this.element.removeEventListener(
                'submit',
                this.handleSubmit.bind(this),
            );
        }
    }

    submit() {
        this.element.submit();
    }

    requestSubmit() {
        this.element.requestSubmit();
    }

    enable() {
        this.enabledValue = true;
    }

    disable() {
        this.enabledValue = false;
    }

    validate() {
        this.updateValidity(this.element.checkValidity());
    }

    reportValidity() {
        this.updateValidity(this.element.reportValidity());
    }

    reset() {
        this.element.reset();
        this.dispatch('reset');
    }

    enabledValueChanged() {
        const eventName = this.enabledValue ? 'enabled' : 'disabled';
        this.dispatch(eventName);
    }

    private handleSubmit(event: Event) {
        if (!this.enabledValue || this.onSubmit()) {
            event.preventDefault();
        }
    }

    private handleTurboSubmitStarted(event: any) {
        if (!this.enabledValue || this.onSubmit()) {
            event.detail.formSubmission.stop();
        }
    }

    private handleTurboSubmitEnded(event: any) {
        const { success, fetchResponse, error } = event.detail;

        if (success) {
            this.onSuccess(fetchResponse.response);
            this.onFinished(true, fetchResponse.response, null);
        } else {
            this.onFailed(error);
            this.onFinished(false, null, error);
        }
    }

    private onSubmit(): boolean {
        return this.dispatch('submit', { cancelable: true }).defaultPrevented;
    }

    private onSuccess(response: Response) {
        this.dispatch('success', { detail: { response } });
    }

    private onFailed(error: Error) {
        this.dispatch('failed', { detail: { error } });
    }

    private onFinished(
        success: boolean,
        response: Response | null,
        error: Error | null,
    ) {
        this.dispatch('finished', { detail: { success, response, error } });
    }

    private updateValidity(valid: boolean): void {
        if (this._valid == valid) {
            return;
        }

        this._valid = valid;
        const eventName = valid ? 'valid' : 'invalid';
        this.dispatch(eventName);
    }
}
