import {Controller} from "@hotwired/stimulus";
import ModalController from "./modal_controller";

export default class extends Controller {
    static outlets = ["flowbite--modal"];

    declare readonly flowbiteModalOutlet: ModalController;

    show(): void {
        this.flowbiteModalOutlet.show();
    }

    hide(): void {
        this.flowbiteModalOutlet.hide();
    }

    toggle(): void {
        this.flowbiteModalOutlet.toggle();
    }
}