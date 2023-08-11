import {Controller} from "@hotwired/stimulus";
import {flip, Placement, shift, offset} from "@floating-ui/dom";

import useFloatingUI from "../../../src/mixins/use_floating_ui";
import useClickOutside from "../../../src/mixins/use_click_outside";

export default class extends Controller {
    static outlets = ["flowbite--dropdown-trigger"]
    static classes = ["visible", "hidden"];

    static values = {
        reference: String,
        placement: {
            type: String,
            default: "bottom",
        },
        shift: {
            type: Number,
            default: 0
        },
        offset: {
            type: Number,
            default: 10,
        },
        ignoreClickOutside: String,
        delay: {
            type: Number,
            default: 300
        }
    }

    declare readonly flowbiteDropdownTriggerOutletElement: Element;
    declare readonly placementValue: string;
    declare readonly shiftValue: number;
    declare readonly offsetValue: number;
    declare readonly hasIgnoreClickOutside: boolean;
    declare readonly ignoreClickOutsideValue: string;
    declare readonly delayValue: number;
    declare readonly visibleClasses: string[];
    declare readonly hiddenClasses: string[];

    private _isVisible: boolean = false;
    private attachFloating: () => void = () => {};
    private detachFloating: () => void = () => {};
    private observeClickOutside: () => void = () => {};
    private unobserveClickOutside: () => void = () => {};

    get isVisible(): boolean {
        return this._isVisible;
    }

    connect() {
        super.connect();

        [this.attachFloating, this.detachFloating] = useFloatingUI(this, {
            referenceElement: this.flowbiteDropdownTriggerOutletElement,
            strategy: "absolute",
            placement: this.placementValue as Placement,
            middleware: [
                offset({
                    mainAxis: this.offsetValue,
                    crossAxis: this.shiftValue,
                }),
                flip(),
                shift()
            ],
        });

        [this.observeClickOutside, this.unobserveClickOutside] = useClickOutside(this);
    }

    show(): void {
        this.showDropdown() && this.observeClickOutside();
    }

    hide(): void {
        this.hideDropdown() && this.unobserveClickOutside();
    }

    toggle(): void {
        if (this._isVisible) {
            this.hide();
        } else {
            this.show();
        }
    }

    hoverShow(): void {
        this.showDropdown();
    }

    hoverHide(): void {
        setTimeout(() => {
            if (!this.flowbiteDropdownTriggerOutletElement.matches(":hover")) {
                this.hideDropdown();
            }
        }, this.delayValue)
    }

    protected onClickOutside({target}: Event): void {
        const outsideTrigger = !this.flowbiteDropdownTriggerOutletElement.contains(target as Node) &&
            this.flowbiteDropdownTriggerOutletElement != target;
        const isIgnored = this.isIgnoredClickOutside(target);

        this.application.logDebugActivity(this.identifier, 'onClickOutside', {outsideTrigger, isIgnored});
        !isIgnored && outsideTrigger && this.hide();
    }

    protected isIgnoredClickOutside(target: EventTarget | null): boolean {
        if (this.hasIgnoreClickOutside) {
            const elements = document.querySelectorAll(this.ignoreClickOutsideValue);

            for(let i = 0; i < elements.length; i++) {
                if (elements[i].contains(target as Element)) {
                    return true;
                }
            }
        }

        return false;
    }

    protected onShow(): boolean {
        return this.dispatch("show", {cancelable: true}).defaultPrevented;
    }

    protected onShown(): void {
        this.dispatch("shown");
    }

    protected onHide(): boolean {
        return this.dispatch("hide", {cancelable: true}).defaultPrevented;
    }

    protected onHidden(): void {
        this.dispatch("hidden");
    }

    private showDropdown(): boolean {
        if (this._isVisible || this.onShow()) {
            return false;
        }

        this.attachFloating();
        this.element.classList.remove(...this.hiddenClasses);
        this.element.classList.add(...this.visibleClasses);
        this.element.removeAttribute("aria-hidden");
        this._isVisible = true;
        this.onShown();

        return true;
    }

    private hideDropdown(): boolean {
        if (!this._isVisible || this.onHide()) {
            return false;
        }

        this.unobserveClickOutside();
        this.detachFloating();
        this.element.classList.remove(...this.visibleClasses);
        this.element.classList.add(...this.hiddenClasses);
        this.element.setAttribute("aria-hidden", "true");
        this._isVisible = false;
        this.onHidden();

        return true;
    }
}