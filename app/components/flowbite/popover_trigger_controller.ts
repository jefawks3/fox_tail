import {Controller} from "@hotwired/stimulus";

import PopoverController from "./popover_controller";

export default class extends Controller {
    static outlets = ["flowbite--popover"];

    static values = {
        delay: {
            type: Number,
            default: 300,
        },
    };

    declare readonly delayValue: number;

    declare readonly flowbitePopoverOutlet: PopoverController;
    declare readonly flowbitePopoverOutletElement: HTMLElement;

    show(): void {
        this.flowbitePopoverOutlet.show();
    }

    hoverShow(): void {
        setTimeout(() => this.flowbitePopoverOutlet.hoverShow(), this.delayValue);
    }

    hide(): void {
        this.flowbitePopoverOutlet.hide();
    }

    hoverHide(): void {
        setTimeout(() =>{
            if (!this.flowbitePopoverOutletElement.matches(":hover")) {
                this.flowbitePopoverOutlet.hoverHide();
            }
        }, this.delayValue);
    }

    toggle(): void {
        this.flowbitePopoverOutlet.toggle();
    }

    toggleWithDelay(): void {
        setTimeout(() => this.toggle(), this.delayValue);
    }
}
