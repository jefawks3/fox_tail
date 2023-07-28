import {Controller} from "@hotwired/stimulus";
import {twMerge} from "tailwind-merge";

export default class extends Controller {
    static classes = ['active', 'disabled'];

    static values = {
        disabled: {
            type: Boolean,
            default: false
        }
    };

    declare disabledValue: boolean;
    declare readonly activeClasses: string[];
    declare readonly disabledClasses: string[];

    connect() {
        super.connect();
        this.disabledValueChanged();
        this.element.addEventListener('click', this.handleClick.bind(this));
    }

    disabledValueChanged() {
        this.element.setAttribute('aria-disabled', this.disabledValue.toString());

        if (this.disabledValue) {
            this.element.className = twMerge(this.activeClasses.join(' '), this.disabledClasses.join(' '));
        } else {
            this.element.className = this.activeClasses.join(' ');
        }
    }

    private handleClick(event: Event): void {
        if (this.disabledValue) {
            event.preventDefault();
        }
    }
}

