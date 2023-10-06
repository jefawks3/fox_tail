import {Controller} from "@hotwired/stimulus";

import PopoverController from "./popover_controller";

export default class extends Controller {
    static outlets = ["fox-tail--popover"];

    static values = {
        delay: {
            type: Number,
            default: 300,
        },
    };

    declare readonly delayValue: number;

    declare readonly foxTailPopoverOutlet: PopoverController;
    declare readonly foxTailPopoverOutletElement: HTMLElement;

    show(): void {
        this.foxTailPopoverOutlet.show();
    }

    hoverShow(): void {
        setTimeout(() => this.foxTailPopoverOutlet.hoverShow(), this.delayValue);
    }

    hide(): void {
        this.foxTailPopoverOutlet.hide();
    }

    hoverHide(): void {
        setTimeout(() =>{
            if (!this.foxTailPopoverOutletElement.matches(":hover")) {
                this.foxTailPopoverOutlet.hoverHide();
            }
        }, this.delayValue);
    }

    toggle(): void {
        this.foxTailPopoverOutlet.toggle();
    }

    toggleWithDelay(): void {
        setTimeout(() => this.toggle(), this.delayValue);
    }
}
