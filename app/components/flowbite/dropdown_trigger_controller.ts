import {Controller} from "@hotwired/stimulus";
import DropdownController from "./dropdown_controller";
import useForwardedEventListener from "../../../src/mixins/use_forwarded_event_listener";

export default class extends Controller {
    static classes = ["open", "closed"]
    static outlets = ["flowbite--dropdown"];

    static values = {
        delay: {
            type: Number,
            default: 300,
        },
    };

    declare readonly delayValue: number;
    declare readonly openClasses: string[];
    declare readonly closedClasses: string[];
    declare readonly flowbiteDropdownOutlet: DropdownController;
    declare readonly flowbiteDropdownOutletElement: Element;

    declare _unsubscribeListener: (() => void) | null;

    flowbiteDropdownOutletConnected(outlet: DropdownController, element: Element): void {
        const [observe, unobserve] = useForwardedEventListener(
            this,
            ["show", "shown", "hide", "hidden"],
            element,
            this.element,
            { capture: true, eventPrefix: "flowbite--dropdown" }
        );

        this._unsubscribeListener = unobserve;
        observe();

        this.updateAttributes();
    }

    flowbiteDropdownOutletDisconnected(outlet: DropdownController, element: Element): void {

    }

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

    onForwardEvent(): void {
        this.updateAttributes();
    }

    private updateAttributes(): void {
        this.element.setAttribute("aria-expanded", this.flowbiteDropdownOutlet.isVisible.toString());

        if (this.flowbiteDropdownOutlet.isVisible) {
            this.element.classList.remove(...this.closedClasses);
            this.element.classList.add(...this.openClasses);
        } else {
            this.element.classList.remove(...this.openClasses);
            this.element.classList.add(...this.closedClasses);
        }
    }
}
