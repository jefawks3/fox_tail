import {Controller} from "@hotwired/stimulus";

import DrawerController from "./drawer_controller";
import useForwardedEventListener from "../../../src/mixins/use_forwarded_event_listener";

export default class extends Controller {
    static classes = ["open", "closed"];
    static outlets = ["flowbite--drawer"];

    declare readonly openClasses: string[];
    declare readonly closedClasses: string[];
    declare readonly flowbiteDrawerOutlet: DrawerController;

    flowbiteDrawerOutletConnected(outlet: DrawerController, element: HTMLElement): void {
        const [observe] = useForwardedEventListener(
            this,
            ["show", "shown", "hide", "hidden"],
            element,
            this.element,
            { capture: true, eventPrefix: "flowbite--drawer" }
        );

        observe();

        this.updateAttributes();
    }

    show(): void {
        this.flowbiteDrawerOutlet.show();
    }

    hide(): void {
        this.flowbiteDrawerOutlet.hide();
    }

    toggle(): void {
        this.flowbiteDrawerOutlet.toggle();
    }

    protected onForwardEvent(): void {
        this.updateAttributes();
    }

    private updateAttributes(): void {
        if (this.flowbiteDrawerOutlet.isVisible) {
            this.element.classList.remove(...this.closedClasses);
            this.element.classList.add(...this.openClasses);
        } else {
            this.element.classList.remove(...this.openClasses);
            this.element.classList.add(...this.closedClasses);
        }
    }
}

