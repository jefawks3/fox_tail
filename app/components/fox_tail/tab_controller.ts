import { Controller } from '@hotwired/stimulus';

import CollapsibleController from './collapsible_controller';
import { setClasses } from '../../../src/utilities/tailwind';

export default class TabController extends Controller {
    static classes = ['active', 'selected'];
    static outlets = ['fox-tail--tab', 'fox-tail--collapsible'];

    static values = {
        selected: {
            type: Boolean,
            default: false,
        },
        panel: String,
    };

    declare readonly selectedValue: boolean;
    declare readonly activeClasses: string[];
    declare readonly selectedClasses: string[];
    declare readonly foxTailTabOutlets: TabController[];
    declare readonly hasFoxTailCollapsibleOutlet: boolean;
    declare readonly foxTailCollapsibleOutlet: CollapsibleController;

    private _selected: boolean = false;

    connect() {
        super.connect();

        this._selected = this.selectedValue;
        this.element.setAttribute('aria-selected', this._selected.toString());

        if (this._selected) {
            setClasses(
                this.element,
                ...this.activeClasses,
                ...this.selectedClasses,
            );
        } else {
            setClasses(this.element, ...this.activeClasses);
        }
    }

    foxTailCollapsibleOutletConnected(outlet: CollapsibleController): void {
        if (this._selected) {
            outlet.show();
        } else {
            outlet.hide();
        }

        if (outlet.element.id && !this.element.hasAttribute('aria-controls')) {
            const id = outlet.element.id.replace(/^#/, '');
            this.element.setAttribute('aria-controls', id);
        }
    }

    select(): void {
        if (this._selected || this.onSelect()) {
            return;
        }

        this._selected = true;
        this.deselectSiblings();
        setClasses(
            this.element,
            ...this.activeClasses,
            ...this.selectedClasses,
        );
        this.element.setAttribute('aria-selected', 'true');
        this.hasFoxTailCollapsibleOutlet &&
            this.foxTailCollapsibleOutlet.show();
        this.onSelected();
    }

    deselect(): void {
        if (!this._selected || this.onDeselect()) {
            return;
        }

        this._selected = false;
        setClasses(this.element, ...this.activeClasses);
        this.element.setAttribute('aria-selected', 'false');
        this.hasFoxTailCollapsibleOutlet &&
            this.foxTailCollapsibleOutlet.hide();
        this.onDeselected();
    }

    protected onSelect(): boolean {
        return this.dispatch('select', { cancelable: true }).defaultPrevented;
    }

    protected onSelected(): void {
        this.dispatch('selected');
    }

    protected onDeselect(): boolean {
        return this.dispatch('deselect', { cancelable: true }).defaultPrevented;
    }

    protected onDeselected(): void {
        this.dispatch('deselected');
    }

    private deselectSiblings(): void {
        this.foxTailTabOutlets.forEach((tab) => {
            tab != this && tab.deselect();
        });
    }
}
