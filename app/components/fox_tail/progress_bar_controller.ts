import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    static targets = ['bar'];

    static values = {
        progress: {
            type: Number,
            default: 0,
        },
        updateLabel: {
            type: Boolean,
            default: true,
        },
    };

    declare progressValue: number;
    declare readonly updateLabelValue: boolean;
    declare readonly barTarget: HTMLElement;

    connect() {
        super.connect();
    }

    progressValueChanged() {
        this.updateAriaAttributes();
        this.updateBar();
    }

    updateDirectUploadProgress(event: CustomEvent) {
        this.progressValue = event.detail.loaded / event.detail.total;
    }

    private updateAriaAttributes() {
        this.element.setAttribute(
            'aria-valuenow',
            this.progressValue.toFixed(),
        );
    }

    private updateBar() {
        this.barTarget.style.width = `${this.progressValue}%`;
        if (this.updateLabelValue) {
            this.barTarget.textContent = `${this.progressValue.toFixed()}%`;
        }
    }
}
