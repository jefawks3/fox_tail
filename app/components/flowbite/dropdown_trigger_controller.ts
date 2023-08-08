import {Controller} from "@hotwired/stimulus";
import DropdownController from "./dropdown_controller";

export default class extends Controller {
    static outlets = ["flowbite--dropdown"];

    static values = {
        delay: {
            type: Number,
            default: 300,
        },
    };

    declare readonly flowbiteDropdownOutlet: DropdownController;
    declare readonly flowbiteDropdownOutletElement: Element;
    declare readonly delayValue: number;

    show(): void {
        this.flowbiteDropdownOutlet.show();
    }

    hoverShow(): void {
        setTimeout(() => this.flowbiteDropdownOutlet.hoverShow(), this.delayValue);
    }

    hide(): void {
        this.flowbiteDropdownOutlet.hide();
    }

    hoverHide(): void {
        setTimeout(() =>{
            if (!this.flowbiteDropdownOutletElement.matches(":hover")) {
                this.flowbiteDropdownOutlet.hoverHide();
            }
        }, this.delayValue);
    }

    toggle(): void {
        this.flowbiteDropdownOutlet.toggle();
    }

    toggleWithDelay(): void {
        setTimeout(() => this.toggle(), this.delayValue);
    }
}
