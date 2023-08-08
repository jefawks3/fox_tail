import {Controller} from "@hotwired/stimulus";

import DismissibleController from "./dismissible_controller";

export default class extends Controller {
    static outlets = ["dismissible"];

    declare readonly dismissibleOutlet: DismissibleController;

    dismiss(): void {
        this.dismissibleOutlet.dismiss();
    }
}
