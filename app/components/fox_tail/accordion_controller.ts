import { Controller } from '@hotwired/stimulus';

import CollapsibleController from './collapsible_controller';

export default class extends Controller {
    static targets = ['collapsible'];

    static values = {
        alwaysOpen: {
            type: Boolean,
            default: false,
        },
    };

    declare readonly alwaysOpenValue: boolean;

    private _collapsibleItems: Map<Element, CollapsibleController | null> =
        new Map();

    initialize() {
        super.initialize();

        this.handleShow = this.handleShow.bind(this);
    }

    collapsibleTargetConnected(element: Element): void {
        this._collapsibleItems.set(element, null);
        element.addEventListener(
            'fox-tail--collapsible:show',
            this.handleShow,
            true,
        );
    }

    collapsibleTargetDisconnected(element: Element): void {
        this._collapsibleItems.delete(element);
        element.removeEventListener(
            'fox-tail--collapsible:show',
            this.handleShow,
            true,
        );
    }

    showAll(event?: Event): void {
        this.getCollapsibleControllers().forEach((collapsible) => {
            if (event && event.target == collapsible.element) {
                return;
            }

            collapsible.show();
        });
    }

    hideAll(event?: Event): void {
        this.getCollapsibleControllers().forEach((collapsible) => {
            if (event && event.target == collapsible.element) {
                return;
            }

            collapsible.hide();
        });
    }

    private getCollapsibleControllers(): CollapsibleController[] {
        const controllers: CollapsibleController[] = [];

        this._collapsibleItems.forEach((controller, element) => {
            if (!controller) {
                controller =
                    this.application.getControllerForElementAndIdentifier(
                        element,
                        'fox-tail--collapsible',
                    ) as CollapsibleController;
                controller && this._collapsibleItems.set(element, controller);
            }

            if (controller) {
                controllers.push(controller);
            } else {
                throw new Error(
                    `Missing collapsible controller for "collapsible" target for host controller "${this.identifier}".`,
                );
            }
        });

        return controllers;
    }

    private handleShow(event: Event): void {
        !this.alwaysOpenValue && this.hideAll(event);
    }
}
