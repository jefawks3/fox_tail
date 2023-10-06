import {Controller} from "@hotwired/stimulus";

export default class extends Controller {
    static classes = ["hidden"];

    static values = {
        collapsed: {
            type: Boolean,
            default: false,
        }
    }

    declare readonly collapsedValue: boolean;
    declare readonly hiddenClasses: string[];

    private _isVisible: boolean = false;

    get isVisible(): boolean {
        return this._isVisible;
    }

    connect() {
        super.connect();
        this._isVisible = !this.collapsedValue;

        if (this._isVisible) {
            this.element.classList.remove(...this.hiddenClasses);
        } else {
            this.element.classList.add(...this.hiddenClasses);
        }
    }

    show(): void {
        if (this._isVisible || this.onShow()) {
            return;
        }

        this.element.classList.remove(...this.hiddenClasses);
        this._isVisible = true;
        this.onShown();
    }

    hide(): void {
        if (!this._isVisible || this.onHide()) {
            return;
        }

        this.element.classList.add(...this.hiddenClasses)
        this._isVisible = false;
        this.onHidden();
    }

    toggle(): void {
        if (this._isVisible) {
            this.hide();
        } else {
            this.show();
        }
    }

    protected onHide(): boolean {
        return this.dispatch("hide", {cancelable: true}).defaultPrevented;
    }

    protected onHidden(): void {
        this.dispatch("hidden");
    }

    protected onShow(): boolean {
        return this.dispatch("show", {cancelable: true}).defaultPrevented;
    }

    protected onShown(): void {
        this.dispatch("shown");
    }
}