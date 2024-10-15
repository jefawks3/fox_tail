import { Controller } from '@hotwired/stimulus';

import FlexSearch from 'flexsearch';
import { v4 as uuid } from 'uuid';

import debounce from '../../../src/utilities/debounce';
import useEventListeners from '../../../src/mixins/use_event_listeners';

export default class extends Controller {
    static classes = ['visible', 'hidden'];
    static targets = ['input', 'searchable', 'group', 'empty'];

    static values = {
        preset: { type: String, default: 'memory' },
        tokenize: { type: String, default: 'forward' },
        limit: { type: Number, default: 100 },
        length: { type: Number, default: 2 },
        delay: { type: Number, default: 320 },
    };

    declare readonly visibleClasses: string[];
    declare readonly hiddenClasses: string[];
    declare readonly inputTarget: HTMLInputElement;
    declare readonly searchableTargets: HTMLElement[];
    declare readonly groupTargets: HTMLElement[];
    declare readonly emptyTarget: HTMLElement;
    declare readonly presetValue: string;
    declare readonly tokenizeValue: string;
    declare readonly lengthValue: number;
    declare readonly limitValue: number;
    declare readonly delayValue: number;

    private _index: FlexSearch.Index = null;

    searchableTargetConnected(target: HTMLElement) {
        this.addSearchable(target);
    }

    searchableTargetDisconnected(target: HTMLElement) {
        this.removeSearchable(target);
    }

    groupTargetConnected(target: HTMLElement) {
        target.setAttribute('aria-hidden', 'false');
    }

    connect() {
        super.connect();

        this._index = new FlexSearch.Index({
            preset: this.presetValue as FlexSearch.Preset,
            tokenize: this.tokenizeValue as FlexSearch.Tokenizer,
        });

        this.searchableTargets.forEach((element) =>
            this.addSearchable(element),
        );

        useEventListeners(
            this,
            this.inputTarget,
            'input',
            debounce(this.search.bind(this), this.delayValue),
            { attached: true, passive: true },
        );

        useEventListeners(
            this,
            this.inputTarget,
            'search',
            this.clear.bind(this),
            { attached: true, passive: true },
        );
    }

    disconnect() {
        super.disconnect();

        this._index = null;
    }

    clear() {
        this.reset();
        this.inputTarget.value = '';
    }

    private addSearchable(element: HTMLElement) {
        if (!this._index) {
            return;
        }

        if (!element.id) {
            element.id = uuid();
        }

        element.setAttribute('aria-hidden', 'false');

        this._index.add(element.id, element.textContent);
    }

    private removeSearchable(element: HTMLElement) {
        if (!this._index || !element.id) {
            return;
        }

        this._index.remove(element.id);
    }

    private async search() {
        const value = this.inputTarget.value.trimStart();

        if (value.length >= this.lengthValue) {
            const result = await this._index.searchAsync(
                value,
                this.limitValue,
            );

            const hashedIds = result.reduce<any>((h, id) => {
                h[id] = true;
                return h;
            }, {});

            this.searchableTargets.forEach((element) => {
                if (element.id) {
                    this.toggleVisibility(element, hashedIds[element.id]);
                }
            });

            this.groupTargets.forEach((element) => {
                const visible = element.querySelector(
                    `[${this.context.schema.targetAttributeForScope(
                        this.identifier,
                    )}~="searchable"][aria-hidden="false"]`,
                );

                this.toggleVisibility(element, !!visible);
            });

            this.toggleVisibility(this.emptyTarget, result.length === 0);
        } else {
            this.reset();
        }
    }

    private reset() {
        this.searchableTargets.forEach((element) =>
            this.toggleVisibility(element, true),
        );

        this.toggleVisibility(this.emptyTarget, false);
    }

    private toggleVisibility(element: HTMLElement, visible: boolean) {
        if (visible) {
            element.classList.add(...this.visibleClasses);
            element.classList.remove(...this.hiddenClasses);
            element.setAttribute('aria-hidden', 'false');
        } else {
            element.classList.add(...this.hiddenClasses);
            element.classList.remove(...this.visibleClasses);
            element.setAttribute('aria-hidden', 'true');
        }
    }
}
