import {Controller} from "@hotwired/stimulus";
import {flip, Placement, shift, offset, Middleware, inline} from "@floating-ui/dom";

import useFloatingUI from "../../../src/mixins/use_floating_ui";

export default class extends Controller {
    static classes = ["visible", "hidden"];
    static outlets = ["fox-tail--tooltip-trigger"];

    static values = {
        placement: {
            type: String,
            default: "top",
        },
        offset: {
            type: Number,
            default: 8,
        },
        shift: {
            type: Number,
            default: 0,
        },
        inline: {
            type: Boolean,
            default: false,
        }
    }

    declare readonly foxTailTooltipTriggerOutletElement: Element;
    declare readonly placementValue: string;
    declare readonly offsetValue: number;
    declare readonly shiftValue: number;
    declare readonly inlineValue: boolean;
    declare readonly visibleClasses: string[];
    declare readonly hiddenClasses: string[];

    private _isVisible: boolean = false;
    private attachFloating: () => void = () => {};
    private detachFloating: () => void = () => {};

    connect() {
        super.connect();

        const middleware: Middleware[] = [
            offset({
                mainAxis: this.offsetValue,
                crossAxis: this.shiftValue,
            }),
            flip(),
            shift(),
        ];

        this.inlineValue && middleware.unshift(inline());

        [this.attachFloating, this.detachFloating] = useFloatingUI(this, {
            referenceElement: this.foxTailTooltipTriggerOutletElement,
            strategy: "absolute",
            placement: this.placementValue as Placement,
            middleware
        });
    }

    show(): void {
        if (this._isVisible || this.onShow()) {
            return;
        }

        this.attachFloating();
        this.element.classList.remove(...this.hiddenClasses);
        this.element.classList.add(...this.visibleClasses);
        this.element.removeAttribute("aria-hidden");
        this._isVisible = true;
        this.onShown();
    }

    hide(): void {
        if (!this._isVisible || this.onHide()) {
            return;
        }

        this.detachFloating();
        this.element.classList.remove(...this.visibleClasses);
        this.element.classList.add(...this.hiddenClasses);
        this.element.setAttribute("aria-hidden", "true");
        this._isVisible = false;
        this.onHidden();
    }

    toggle(): void {
        if (this._isVisible) {
            this.hide();
        } else {
            this.show();
        }
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
}
