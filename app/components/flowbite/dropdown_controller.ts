import {Controller} from "@hotwired/stimulus";
import {Dropdown} from "flowbite";

export default class extends Controller {
    static values = {
        dropdown: String,
        placement: {
            type: String,
            default: "bottom",
        },
        triggerType: {
            type: String,
            default: "click"
        },
        offsetSkidding: {
            type: Number,
            default: 0,
        },
        offsetDistance: {
            type: Number,
            default: 10
        },
        delay: {
            type: Number,
            default: 300,
        },
        ignoreClickOutsideClass: String
    }

    declare readonly dropdownValue: string;
    declare readonly placementValue: string;
    declare readonly triggerTypeValue: string;
    declare readonly offsetSkiddingValue: number;
    declare readonly offsetDistanceValue: number;
    declare readonly delayValue: number;
    declare readonly hasIgnoreClickOutsideClass: boolean;
    declare readonly ignoreClickOutsideClassValue: string;

    declare private _dropdown: Dropdown | undefined;

    get dropdownElement(): HTMLElement | null {
        return document.getElementById(this.dropdownValue);
    }

    get isVisible(): boolean {
        return this._dropdown ? false : this._dropdown.isVisible();
    }

    connect() {
        super.connect();

        if (this.dropdownElement) {
            this._attach();
        }
    }

    show(): void {
        if (this._dropdown) {
            this._dropdown.show();
        }
    }

    hide(): void {
        if (this._dropdown) {
            this._dropdown.hide();
        }
    }

    toggle(): void {
        if (this._dropdown) {
            this._dropdown.toggle();
        }
    }

    private _attach() {
        const options: any = {
            placement: this.placementValue,
            triggerType: this.triggerTypeValue,
            offsetSkidding: this.offsetSkiddingValue,
            offsetDistance: this.offsetDistanceValue,
            delay: this.delayValue,
            ignoreClickOutsideClass: this.hasIgnoreClickOutsideClass ? this.ignoreClickOutsideClassValue : false,
            onHide: this.onHide.bind(this),
            onShow: this.onShow.bind(this),
            onToggle: this.onToggle.bind(this)
        }

        this._dropdown = new Dropdown(this.dropdownElement, this.element as HTMLElement, options);
    }

    private onToggle(): void {
        this.dispatch('toggle', { detail: { visible: this.isVisible } })
    }

    private onShow(): void {
        this.dispatch('shown')
    }

    private onHide(): void {
        this.dispatch('hidden')
    }
}