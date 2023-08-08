import {Controller} from "@hotwired/stimulus";
import parseDuration from 'parse-duration'

import {addClasses} from "../../../src/utilities/tailwind";

export default class extends Controller {
    static classes = ["dismissing", "dismissed"];

    static values = {
        remove: {
            type: Boolean,
            default: false
        }
    }

    declare readonly targetValue: string;
    declare readonly removeValue: boolean;
    declare readonly dismissingClasses: string[];
    declare readonly dismissedClasses: string[];

    private _dismissed: boolean = false;

    dismiss(): void {
        if (this._dismissed || this.onDismissing()) {
            return;
        }

        this._dismissed = true;

        addClasses(this.element, ...this.dismissingClasses);
        const duration = this.calculateDuration();

        setTimeout(() => {
            addClasses(this.element, ...this.dismissedClasses);
            this.onDismissed();

            if (this.removeValue) {
                this.element.remove();
            }
        }, duration);
    }

    protected onDismissing(): boolean {
        return this.dispatch('dismissing', { cancelable: true }).defaultPrevented;
    }

    protected onDismissed(): void {
        this.dispatch('dismissed');
    }

    private calculateDuration(): number {
        return parseDuration(getComputedStyle(this.element).transitionDuration.split(",")[0].trim()) as number;
    }
}
