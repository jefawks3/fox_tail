import { Controller } from '@hotwired/stimulus';
import { twMerge } from 'tailwind-merge';

export default class extends Controller {
    static classes = ['active', 'disabled'];
    static targets = ['active', 'loading'];

    static values = {
        state: {
            type: String,
            default: 'active',
        },
    };

    declare stateValue: string;
    declare readonly activeClasses: string[];
    declare readonly disabledClasses: string[];
    declare readonly activeTargets: HTMLElement[];
    declare readonly loadingTargets: HTMLElement[];

    get isLink(): boolean {
        return this.element.tagName.toLowerCase() === 'a';
    }

    get isButton(): boolean {
        return !this.isLink;
    }

    disable() {
        this.stateValue = 'disabled';
    }

    activate() {
        this.stateValue = 'active';
    }

    loading() {
        this.stateValue = 'loading';
    }

    connect() {
        super.connect();
        this.element.addEventListener('click', this.handleClick.bind(this));
    }

    activeTargetConnected(element: HTMLElement): void {
        this.toggleActiveTargetVisibility(element);
    }

    loadingTargetConnected(element: HTMLElement): void {
        this.toggleLoadingTargetVisibility(element);
    }

    stateValueChanged(): void {
        this.toggleClass();
        this.toggleAriaDisabled();
        this.toggleVisibility();
    }

    private handleClick(event: Event): void {
        if (this.stateValue !== 'active') {
            event.preventDefault();
        }
    }

    private toggleAriaDisabled(): void {
        if (this.isLink) {
            this.element.setAttribute(
                'aria-disabled',
                this.stateValue !== 'active' ? 'true' : 'false',
            );
        } else if (this.stateValue === 'active') {
            this.element.removeAttribute('disabled');
        } else {
            this.element.setAttribute('disabled', 'disabled');
        }
    }

    private toggleClass(): void {
        let classes = this.activeClasses;

        if (this.stateValue !== 'active') {
            classes = [...classes, ...this.disabledClasses];
        }

        this.element.className = twMerge(classes.join(' '));
    }

    private toggleVisibility(): void {
        this.activeTargets.forEach((e) => this.toggleActiveTargetVisibility(e));
        this.loadingTargets.forEach((e) =>
            this.toggleLoadingTargetVisibility(e),
        );
    }

    private toggleActiveTargetVisibility(element: HTMLElement) {
        element.classList.toggle('hidden', this.stateValue === 'loading');
    }

    private toggleLoadingTargetVisibility(element: HTMLElement) {
        element.classList.toggle('hidden', this.stateValue !== 'loading');
    }
}
