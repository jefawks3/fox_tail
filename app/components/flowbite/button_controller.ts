import {Controller} from "@hotwired/stimulus";
import {twMerge} from "tailwind-merge";

export default class extends Controller {
    static classes = ['active', 'disabled'];
    static targets = ['loadingIcon', 'loadingLabel', 'label', 'icon']

    static values = {
        disabled: {
            type: Boolean,
            default: false
        },
        loading: {
            type: Boolean,
            default: false
        }
    };

    declare disabledValue: boolean;
    declare loadingValue: boolean;
    declare readonly activeClasses: string[];
    declare readonly disabledClasses: string[];
    declare readonly hasLoadingIconTarget: boolean;
    declare readonly loadingIconTarget: HTMLElement;
    declare readonly hasLoadingLabelTarget: boolean;
    declare readonly loadingLabelTarget: HTMLElement;
    declare readonly hasLabelTarget: boolean;
    declare readonly labelTarget: HTMLElement;
    declare readonly iconTargets: HTMLElement[];

    connect() {
        super.connect();
        this.disabledValueChanged();
    }

    loadingIconTargetConnected() {
        this.toggleLoadingIconVisibility();
    }

    iconTargetConnected(element: HTMLElement) {
        this.toggleIconVisibility(element);
    }

    loadingLabelTargetConnected() {
        this.toggleLoadingLabelVisibility();
    }

    labelTargetConnected() {
        this.toggleLabelVisibility();
    }

    disabledValueChanged(): void {
        this.loadingValue = false;

        this.element.setAttribute('disabled', this.disabledValue.toString());
        this.toggleDisabled(this.disabledValue);
    }

    loadingValueChanged(): void {
        this.disabledValue = false;

        this.toggleDisabled(this.loadingValue);
        this.toggleLoadingIconVisibility();
        this.toggleIconsVisibility();
        this.toggleLoadingLabelVisibility();
        this.toggleLabelVisibility();
    }

    private toggleDisabled(disabled: boolean): void {
        this.element.setAttribute('disabled', disabled.toString());

        if (disabled) {
            this.element.setAttribute('disabled', 'disabled');
            this.element.className = twMerge(this.activeClasses.join(' '), this.disabledClasses.join(' '))
        } else {
            this.element.removeAttribute('disabled');
            this.element.className = this.activeClasses.join(' ');
        }
    }

    private toggleLoadingIconVisibility(): void {
        if (this.hasLoadingIconTarget) {
            this.loadingIconTarget.classList.toggle('hidden', !this.loadingValue);
        }
    }

    private toggleIconsVisibility(): void {
        this.iconTargets.forEach((e: HTMLElement) => this.toggleIconVisibility(e))
    }

    private toggleIconVisibility(icon: HTMLElement): void {
        icon.classList.toggle('hidden', this.loadingValue);
    }

    private toggleLoadingLabelVisibility(): void {
        if (this.hasLoadingLabelTarget) {
            this.loadingLabelTarget.classList.toggle('hidden', !this.loadingValue);
        }
    }

    private toggleLabelVisibility(): void {
        if (this.hasLabelTarget) {
            this.labelTarget.classList.toggle('hidden', this.loadingValue);
        }
    }
}

