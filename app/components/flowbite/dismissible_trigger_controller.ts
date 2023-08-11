import {Controller} from "@hotwired/stimulus";

import DismissibleController from "./dismissible_controller";

export default class extends Controller {
    static outlets = ["dismissible"];

    declare readonly dismissibleOutlets: DismissibleController[];

    dismiss(): void {
        this.dismissibleOutlets.forEach((outlet) => outlet.dismiss());
    }
}
