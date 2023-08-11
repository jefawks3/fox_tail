import {Controller} from "@hotwired/stimulus";

import CollapsibleController from "./collapsible_controller";
import useForwardedEventListener from "../../../src/mixins/use_forwarded_event_listener";

export default class extends Controller {
    static classes = ["expanded", "collapsed"];
    static outlets = ["flowbite--collapsible"];

    static values = {
        collapsed: {
            type: Boolean,
            default: false,
        }
    }

    declare readonly expandedClasses: string[];
    declare readonly collapsedClasses: string[];
    declare readonly flowbiteCollapsibleOutlet: CollapsibleController;

    declare _unsubscribeListener: (() => void) | null;

    flowbiteCollapsibleOutletConnected(outlet: CollapsibleController, element: Element): void {
        const [observe, unobserve] = useForwardedEventListener(
            this,
            ["show", "shown", "hide", "hidden"],
            element,
            this.element,
            { capture: true, eventPrefix: "flowbite--collapsible" }
        );

        this._unsubscribeListener = unobserve;
        observe();
    }

    flowbiteCollapsibleOutletDisconnected(outlet: CollapsibleController, element: Element): void {
        this._unsubscribeListener && this._unsubscribeListener();
        this._unsubscribeListener = null;
    }

    show(): void {
        this.flowbiteCollapsibleOutlet.show();
    }

    hide(): void {
        this.flowbiteCollapsibleOutlet.hide();
    }

    toggle(): void {
        this.flowbiteCollapsibleOutlet.toggle();
    }

    onForwardEvent(): void {
        this.element.setAttribute("aria-expanded", this.flowbiteCollapsibleOutlet.isVisible.toString());

        if (this.flowbiteCollapsibleOutlet.isVisible) {
            this.element.classList.remove(...this.collapsedClasses);
            this.element.classList.add(...this.expandedClasses);
        } else {
            this.element.classList.remove(...this.expandedClasses);
            this.element.classList.add(...this.collapsedClasses);
        }
    }
}
