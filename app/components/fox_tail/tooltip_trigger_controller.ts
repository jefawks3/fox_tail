import { Controller } from '@hotwired/stimulus';

import TooltipController from './tooltip_controller';

export default class extends Controller {
    static outlets = ['fox-tail--tooltip'];

    declare readonly foxTailTooltipOutlet: TooltipController;

    show(): void {
        this.foxTailTooltipOutlet.show();
    }

    hide(): void {
        this.foxTailTooltipOutlet.hide();
    }

    toggle(): void {
        this.foxTailTooltipOutlet.toggle();
    }
}
