import type {Application} from "@hotwired/stimulus";
import * as Components from "../app/components/flowbite";

export default (application: Application): void => {
    application.register("flowbite--accordion", Components.AccordionController);
    application.register("flowbite--clickable", Components.ClickableController);
    application.register("flowbite--collapsible", Components.CollapsibleController);
    application.register("flowbite--collapsible-trigger", Components.CollapsibleTriggerController);
    application.register("flowbite--color-theme", Components.ColorThemeController);
    application.register("flowbite--dismissible", Components.DismissibleController);
    application.register("flowbite--dropdown", Components.DropdownController);
    application.register("flowbite--dropdown-trigger", Components.DropdownTriggerController);
    application.register("flowbite--popover", Components.PopoverController);
    application.register("flowbite--popover-trigger", Components.PopoverTriggerController);
    application.register("flowbite--tab", Components.TabController);
    application.register("flowbite--textarea-auto-resize", Components.TextareaAutoResizeController);
    application.register("flowbite--tooltip", Components.TooltipController);
    application.register("flowbite--tooltip-trigger", Components.TooltipTriggerController);
}
