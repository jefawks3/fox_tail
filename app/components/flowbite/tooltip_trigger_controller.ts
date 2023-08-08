import {Controller} from "@hotwired/stimulus";

import TooltipController from "./tooltip_controller";

export default class extends Controller {
    static outlets = ["flowbite--tooltip"];

    declare readonly flowbiteTooltipOutlet: TooltipController;

    show(): void {
        this.flowbiteTooltipOutlet.show();
    }

    hide(): void {
        this.flowbiteTooltipOutlet.hide();
    }
}
