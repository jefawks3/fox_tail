import { Controller } from '@hotwired/stimulus';

import debounce from '../../../src/utilities/debounce';

export default class extends Controller {
    static values = {
        delay: {
            type: Number,
            default: 0,
        },
    };

    declare readonly delayValue: number;
    private declare handleResize: () => void;

    initialize() {
        super.initialize();
        this.handleResize = debounce(
            this.resizeElement.bind(this),
            this.delayValue,
        );
    }

    connect() {
        super.connect();
        this.resizeElement();
        this.element.addEventListener('scroll', this.handleResize, false);
        this.element.addEventListener('keyup', this.handleResize, false);
        window.addEventListener('resize', this.handleResize);
    }

    disconnect() {
        super.disconnect();
        window.removeEventListener('resize', this.handleResize);
    }

    private resizeElement(): void {
        (this.element as HTMLElement).style.height = '1px';
        this.element.scrollTop = 0;
        (this.element as HTMLElement).style.height = `${
            this.element.scrollHeight -
            this.element.clientHeight +
            this.element.getBoundingClientRect().height
        }px`;
    }
}
