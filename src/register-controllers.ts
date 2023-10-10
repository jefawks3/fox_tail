import type { Application } from '@hotwired/stimulus';
import * as Components from '../app/components/fox_tail';

export default (application: Application): void => {
    application.register('fox-tail--accordion', Components.AccordionController);
    application.register('fox-tail--clickable', Components.ClickableController);
    application.register(
        'fox-tail--collapsible',
        Components.CollapsibleController,
    );
    application.register(
        'fox-tail--collapsible-trigger',
        Components.CollapsibleTriggerController,
    );
    application.register(
        'fox-tail--color-theme',
        Components.ColorThemeController,
    );
    application.register(
        'fox-tail--dismissible',
        Components.DismissibleController,
    );
    application.register('fox-tail--drawer', Components.DrawerController);
    application.register(
        'fox-tail--drawer-trigger',
        Components.DrawerTriggerController,
    );
    application.register('fox-tail--dropdown', Components.DropdownController);
    application.register(
        'fox-tail--dropdown-trigger',
        Components.DropdownTriggerController,
    );
    application.register('fox-tail--fab', Components.FABController);
    application.register('fox-tail--modal', Components.ModalController);
    application.register(
        'fox-tail--modal-trigger',
        Components.ModalTriggerController,
    );
    application.register('fox-tail--popover', Components.PopoverController);
    application.register(
        'fox-tail--popover-trigger',
        Components.PopoverTriggerController,
    );
    application.register(
        'fox-tail--progress-bar',
        Components.ProgressBarController,
    );
    application.register('fox-tail--tab', Components.TabController);
    application.register(
        'fox-tail--textarea-auto-resize',
        Components.TextareaAutoResizeController,
    );
    application.register('fox-tail--tooltip', Components.TooltipController);
    application.register(
        'fox-tail--tooltip-trigger',
        Components.TooltipTriggerController,
    );
};
