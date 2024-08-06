import { Controller } from '@hotwired/stimulus';

export default class extends Controller<HTMLFormElement> {
    static targets = ['listener'];

    declare readonly listenerTargets: HTMLElement[];

    get useTurbo() {
        return (
            typeof (window as any).Turbo !== 'undefined' &&
            (!this.element.hasAttribute('data-turbo') ||
                this.element.dataset.turbo)
        );
    }

    get allListeners(): HTMLElement[] {
        return [this.element, ...this.listenerTargets];
    }

    connect() {
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

    private handleSubmit(event: Event) {
        if (this.onSubmit()) {
            event.preventDefault();
        }
    }

    private handleTurboSubmitStarted(event: any) {
        if (this.onSubmit()) {
            event.detail.formSubmission.stop();
        }
    }

    private handleTurboSubmitEnded(event: any) {
        const { success, fetchResponse, error } = event.detail;

        if (success) {
            this.onFinished(true, fetchResponse.response, null);
        } else {
            this.onFinished(false, null, error);
        }
    }

    private onSubmit(): boolean {
        const targets = this.listenerTargets;

        for (let i = 0; i < targets.length; i++) {
            if (
                this.dispatch('submit', {
                    target: targets[i],
                    cancelable: true,
                }).defaultPrevented
            ) {
                return true;
            }
        }

        return false;
    }

    private onFinished(
        success: boolean,
        response: Response | null,
        error: Error | null,
    ) {
        const targets = this.listenerTargets;

        for (let i = 0; i < targets.length; i++) {
            this.dispatch('finished', {
                target: targets[i],
                detail: { success, response, error },
            });
        }
    }
}
