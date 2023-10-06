import {Controller} from "@hotwired/stimulus";

import DismissibleController from "./dismissible_controller";

export default class extends Controller {
    static outlets = ["fox-tail--dismissible"];

    declare readonly foxTailDismissibleOutlets: DismissibleController[];

    dismiss(): void {
        this.foxTailDismissibleOutlets.forEach((outlet) => outlet.dismiss());
    }
}
