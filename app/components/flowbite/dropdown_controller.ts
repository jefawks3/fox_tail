import {Controller} from "@hotwired/stimulus";
import {Dropdown} from "flowbite";

export default class extends Controller {
    static values = {
        dropdown: String,
        placement: String,
        triggerType: String,
        offsetSkidding: Number,
        offsetDistance: Number,
        delay: Number,
        ignoreClickOutsideClass: String
    }

    declare readonly dropdownValue: string;
    declare readonly hasPlacementValue: boolean
    declare readonly placementValue: string;
    declare readonly hasTriggerTypeValue: boolean;
    declare readonly triggerTypeValue: string;
    declare readonly hasOffsetSkiddingValue: boolean;
    declare readonly offsetSkiddingValue: number;
    declare readonly hasOffsetDistanceValue: boolean
    declare readonly offsetDistanceValue: number;
    declare readonly hasDelayValue: boolean;
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
            this.attach();
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

    private attach() {
        const options: any = {
            onHide: this.onHide.bind(this),
            onShow: this.onShow.bind(this),
            onToggle: this.onToggle.bind(this)
        }

        this.hasPlacementValue && (options.placement = this.placementValue);
        this.hasTriggerTypeValue && (options.triggerType = this.triggerTypeValue);
        this.hasOffsetDistanceValue && (options.offsetDistance = this.offsetDistanceValue);
        this.hasOffsetSkiddingValue && (options.offsetSkidding = this.offsetSkiddingValue);
        this.hasDelayValue && (options.delay = this.delayValue);
        this.hasIgnoreClickOutsideClass && (options.ignoreClickOutsideClass = this.ignoreClickOutsideClassValue);
        this._dropdown = new Dropdown(this.dropdownElement, this.element as HTMLElement, options);
    }

    private onToggle(): void {
        const detail = { visible: this.isVisible };
        this.dispatch('toggle', { target: this.dropdownElement, detail })
        this.dispatch('toggle', { detail })
    }

    private onShow(): void {
        this.dispatch('shown', { target: this.dropdownElement })
        this.dispatch('shown')
    }

    private onHide(): void {
        this.dispatch('hidden', { target: this.dropdownElement })
        this.dispatch('hidden')
    }
}