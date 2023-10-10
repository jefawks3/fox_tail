import { Controller } from '@hotwired/stimulus';
import ModalController from './modal_controller';

export default class extends Controller {
    static outlets = ['fox-tail--modal'];

    declare readonly foxTailModalOutlet: ModalController;

    show(): void {
        this.foxTailModalOutlet.show();
    }

    hide(): void {
        this.foxTailModalOutlet.hide();
    }

    toggle(): void {
        this.foxTailModalOutlet.toggle();
    }
}
