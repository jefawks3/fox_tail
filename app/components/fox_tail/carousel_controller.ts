import { ActionEvent, Controller } from '@hotwired/stimulus';

interface GoToActionEvent extends ActionEvent {
    params: {
        slide: number;
    };
}

export default class extends Controller {
    static classes = [
        'previousSlide',
        'currentSlide',
        'nextSlide',
        'hiddenSlide',
        'activeIndicator',
        'inactiveIndicator',
    ];

    static targets = ['slide', 'indicator'];

    static values = {
        position: {
            type: Number,
            default: 0,
        },
        interval: {
            type: Number,
            default: 3000,
        },
    };

    declare readonly positionValue: number;
    declare readonly intervalValue: number;

    declare readonly slideTargets: HTMLElement[];
    declare readonly indicatorTargets: HTMLElement[];

    declare readonly previousSlideClasses: string[];
    declare readonly currentSlideClasses: string[];
    declare readonly nextSlideClasses: string[];
    declare readonly hiddenSlideClasses: string[];
    declare readonly activeIndicatorClasses: string[];
    declare readonly inactiveIndicatorClasses: string[];

    private _position: number = -1;
    private _timer: NodeJS.Timeout | undefined;
    private _sliding: boolean = false;

    slideTargetConnected(element: HTMLElement): void {
        element.classList.add(...this.hiddenSlideClasses);
    }

    intervalValueChanged(): void {
        this.stopTimer();
        this.startTimer();
    }

    connect() {
        super.connect();
        this.goTo(this.positionValue);
    }

    disconnect() {
        super.disconnect();
        this.stopTimer();
    }

    goTo(arg: number | GoToActionEvent | undefined): void {
        let slide: number | undefined = undefined;

        if (arg instanceof Event) {
            slide = (arg as GoToActionEvent).params.slide;
        } else if (!isNaN(Number(arg.toString()))) {
            slide = arg as number;
        }

        if (typeof slide === 'undefined') {
            return;
        }

        this.setActiveSlide(slide);
    }

    next(): void {
        this.setActiveSlide(this.getNextPosition());
    }

    previous(): void {
        this.setActiveSlide(this.getPreviousPosition());
    }

    protected onChange(nextPosition: number, currentPosition: number): boolean {
        return this.dispatch('change', {
            cancelable: true,
            detail: { position: currentPosition, nextPosition: nextPosition },
        }).defaultPrevented;
    }

    protected onChanged(
        currentPosition: number,
        previousPosition: number,
    ): void {
        this.dispatch('changed', {
            detail: { position: currentPosition, previousPosition },
        });
    }

    private startTimer(): void {
        if (this.intervalValue > 0 && !this._timer) {
            this._timer = setInterval(() => this.next(), this.intervalValue);
        }
    }

    private stopTimer(): void {
        if (!this._timer) {
            return;
        }

        clearInterval(this._timer);
        this._timer = undefined;
    }

    private getNextPosition(position: number = this._position): number {
        return (position + 1) % this.slideTargets.length;
    }

    private getPreviousPosition(position: number = this._position): number {
        return (position === 0 ? this.slideTargets.length : position) - 1;
    }

    private setActiveSlide(position: number): void {
        if (
            position === this._position ||
            this._sliding ||
            this.onChange(position, this._position)
        ) {
            return;
        }

        this._sliding = true;
        this.stopTimer();
        this.rotateSlides(position);
        this.setActiveIndicator(position);
        const previousPosition = this._position;
        this._position = position;
        this.startTimer();
        this._sliding = false;
        this.onChanged(this._position, previousPosition);
    }

    private rotateSlides(position: number): void {
        const previousPosition = this.getPreviousPosition(position);
        const nextPosition = this.getNextPosition(position);

        this.slideTargets.forEach((element) => {
            element.classList.remove(
                ...this.nextSlideClasses,
                ...this.currentSlideClasses,
                ...this.previousSlideClasses,
            );

            element.classList.add(...this.hiddenSlideClasses);
        });

        if (previousPosition != nextPosition) {
            this.slideTargets[previousPosition].classList.remove(
                ...this.hiddenSlideClasses,
            );
            this.slideTargets[previousPosition].classList.add(
                ...this.previousSlideClasses,
            );
        }

        this.slideTargets[position].classList.remove(
            ...this.hiddenSlideClasses,
        );

        this.slideTargets[position].classList.add(...this.currentSlideClasses);

        if (nextPosition != position) {
            this.slideTargets[nextPosition].classList.remove(
                ...this.hiddenSlideClasses,
            );

            this.slideTargets[nextPosition].classList.add(
                ...this.nextSlideClasses,
            );
        }
    }

    private setActiveIndicator(position: number): void {
        this.indicatorTargets.forEach((element, index) => {
            if (index === position) {
                element.classList.remove(...this.inactiveIndicatorClasses);
                element.classList.add(...this.activeIndicatorClasses);
                element.setAttribute('aria-current', 'true');
            } else {
                element.classList.remove(...this.activeIndicatorClasses);
                element.classList.add(...this.inactiveIndicatorClasses);
                element.setAttribute('aria-current', 'true');
            }
        });
    }
}
