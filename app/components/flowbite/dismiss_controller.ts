import {Controller} from "@hotwired/stimulus";
import {Dismiss} from "flowbite";

export default class extends Controller {
    static classes = ["transition"]

    static values = {
        target: String,
        duration: Number,
        timing: String,
    }

    declare readonly targetValue: string;
    declare readonly hasDurationValue: boolean;
    declare readonly durationValue: number;
    declare readonly hasTimingValue: boolean;
    declare readonly timingValue: string;
    declare readonly hasTransitionClass: boolean;
    declare readonly transitionClasses: string[];

    declare private _dismiss: Dismiss | undefined;

    get targetElement(): HTMLElement {
        return document.getElementById(this.targetValue);
    }

    connect() {
        super.connect();

        if (this.targetElement) {
            this.attach();
        }
    }

    hide(): void {
        this._dismiss && this._dismiss.hide();
    }

    private attach(): void {
        const options: any = { onHide: this.onHide.bind(this) }
        this.hasTransitionClass && (options.transaction = this.transitionClasses.join(" "));
        this.hasDurationValue && (options.duration = this.durationValue);
        this.hasTimingValue && (options.timing = this.timingValue);
        this._dismiss = new Dismiss(this.targetElement, this.element as HTMLElement, options);
    }

    private onHide(): void {
        this.dispatch('hide', { target: this.targetElement })
        this.dispatch('hide')
    }
}
