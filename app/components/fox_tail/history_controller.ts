import { Controller } from '@hotwired/stimulus';

import useEventListeners from '../../../src/mixins/use_event_listeners';
import { v4 as uuid } from 'uuid';

export default class extends Controller {
    static values = {
        path: String,
        title: String,
    };

    declare readonly pathValue: string;
    declare readonly titleValue: string;
    declare readonly hasTitleValue: boolean;

    private _pushed: boolean = false;
    private _id: string = uuid();
    private _previousTurboRestorationIdentifier: string = null;

    get turbo(): any {
        return (window as any).Turbo;
    }

    connect() {
        super.connect();

        useEventListeners(
            this,
            window,
            'popstate',
            (event: PopStateEvent) => {
                const { turbo, controller, title } = event.state;
                const { restorationIdentifier } = turbo || {};

                if (
                    this._pushed &&
                    (controller == this._id ||
                        (restorationIdentifier &&
                            restorationIdentifier ==
                                this._previousTurboRestorationIdentifier))
                ) {
                    if (title) {
                        document.title = '';
                        document.title = title;
                    }

                    this._previousTurboRestorationIdentifier = null;
                    this._pushed = false;
                    this.onPopped();
                }
            },
            { attached: true },
        );
    }

    disconnect() {
        super.disconnect();

        this.pop();
    }

    push() {
        if (this._pushed || this.onPush()) {
            return;
        }

        if (this.turbo && this.turbo.session.drive) {
            this._previousTurboRestorationIdentifier =
                this.turbo.session.history.restorationIdentifier;

            this.turbo.session.history.push(
                new URL(this.pathValue, document.baseURI),
                this._id,
            );
        } else {
            history.pushState(
                { controller: this._id, title: document.title },
                '',
                this.pathValue,
            );
        }

        if (this.hasTitleValue) {
            document.title = '';
            document.title = this.titleValue;
        }

        this._pushed = true;

        this.onPushed();
    }

    pop() {
        if (!this._pushed || this.onPop()) {
            return;
        }

        history.back();
    }

    protected onPush(): boolean {
        return this.dispatch('pushing', { cancelable: true }).defaultPrevented;
    }

    protected onPushed() {
        this.dispatch('pushed');
    }

    protected onPop(): boolean {
        return this.dispatch('popping', { cancelable: true }).defaultPrevented;
    }

    protected onPopped() {
        return this.dispatch('popped');
    }
}
