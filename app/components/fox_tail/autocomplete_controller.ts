import { ActionEvent, Controller } from '@hotwired/stimulus';

import DropdownController from './dropdown_controller';

import debounce from '../../../src/utilities/debounce';
import useEventListeners from '../../../src/mixins/use_event_listeners';
import { safeCallMethod } from '../../../dist/cjs/src/utilities/reflection';

export default class extends Controller {
    static targets = ['input', 'value', 'loader', 'dropdown'];
    static values = {
        url: String,
        param: { type: String, default: 'q' },
        length: { type: Number, default: 1 },
        delay: { type: Number, default: 320 },
    };

    declare readonly urlValue: string;
    declare readonly paramValue: string;
    declare readonly lengthValue: number;
    declare readonly delayValue: number;

    declare readonly inputTarget: HTMLInputElement;
    declare readonly valueTarget: HTMLInputElement;
    declare readonly dropdownTarget: HTMLElement;
    declare readonly loaderTarget: HTMLElement;
    declare readonly hasLoaderTarget: boolean;

    private abortController: AbortController;
    private dropdown: DropdownController;
    private currentText: string;

    get dropdownOutlet(): DropdownController {
        if (!this.dropdown) {
            this.dropdown =
                this.application.getControllerForElementAndIdentifier(
                    this.dropdownTarget,
                    'fox-tail--dropdown',
                ) as DropdownController;
        }

        return this.dropdown;
    }

    connect() {
        this.currentText = this.inputTarget.value;

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

        useEventListeners(
            this,
            this.inputTarget,
            'blur',
            debounce(this.handleBlur.bind(this), 150),
            { attached: true, passive: true },
        );

        useEventListeners(
            this,
            this.inputTarget,
            'keydown',
            this.handleKeyDown.bind(this),
            { attached: true, passive: true },
        );

        this.handleResize();
    }

    search() {
        this.abortSearch();

        if (this.inputTarget.value.length < this.lengthValue) {
            this.dropdownOutlet.hide();
            return;
        }

        this.abortController = new AbortController();
        this.showLoader();

        const url = new URL(this.urlValue, window.location.href);
        const params = new URLSearchParams(url.search);

        params.set(this.paramValue, this.inputTarget.value);
        url.search = params.toString();

        fetch(url)
            .then((response) => response.text())
            .then((body) => {
                this.dropdownTarget.innerHTML = body;
                this.dropdownOutlet.show();
            })
            .catch((error) => {
                this.dropdownOutlet.hide();
                this.application.logDebugActivity(
                    'fox-tail--autocomplete',
                    'search-error',
                    { error },
                );
            })
            .finally(() => this.hideLoader());
    }

    abortSearch() {
        if (this.abortController) {
            this.abortController.abort('cancelled');
            this.abortController = null;
        }
    }

    select(event: ActionEvent) {
        const { value, text } = event.params || {};

        this.application.logDebugActivity('fox-tail--autocomplete', 'select', {
            value,
            text,
        });

        this.valueTarget.value = value;
        this.inputTarget.value = text || value;
        this.currentText = this.inputTarget.value;
        this.dropdownOutlet.hide();
    }

    clear() {
        this.inputTarget.value = '';
        this.valueTarget.value = '';
        this.currentText = '';
        this.inputTarget.blur();
    }

    protected showLoader() {
        this.hasLoaderTarget && this.loaderTarget.classList.remove('hidden');
    }

    protected hideLoader() {
        this.hasLoaderTarget && this.loaderTarget.classList.add('hidden');
    }

    protected handleResize() {
        this.dropdownTarget.style.width = `${
            this.inputTarget.getBoundingClientRect().width
        }px`;
    }

    protected handleBlur() {
        this.dropdownOutlet.hide();
        this.inputTarget.value = this.currentText;
    }

    protected handleKeyDown(event: KeyboardEvent) {
        safeCallMethod(this, `on${event.key}KeyDown`, event);
    }

    protected onEnterKeyDown() {
        this.abortSearch();

        if (this.inputTarget.value.trim() == '') {
            this.clear();
        }

        this.handleBlur();
        this.inputTarget.blur();
    }

    protected onEscapeKeyDown() {
        this.abortSearch();
        this.handleBlur();
        this.inputTarget.blur();
    }
}
