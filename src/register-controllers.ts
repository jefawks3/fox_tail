import type {Application} from "@hotwired/stimulus";
import * as Components from "../app/components/flowbite";

export default (application: Application): void => {
    application.register("flowbite--clickable", Components.ClickableController);
    application.register("flowbite--dismissible", Components.DismissibleController);
    application.register("flowbite--dropdown", Components.DropdownController);
    application.register("flowbite--dropdown-trigger", Components.DropdownTriggerController);
    application.register("flowbite--tooltip", Components.TooltipController);
    application.register("flowbite--tooltip-trigger", Components.TooltipTriggerController);
}
