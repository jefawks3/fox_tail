import { Controller } from "@hotwired/stimulus"

import {
    computePosition,
    autoUpdate,
    flip,
    shift,
    ComputePositionReturn,
    ComputePositionConfig,
    Coords,
} from "@floating-ui/dom"

export type { Placement, Strategy, ComputePositionReturn, InlineOptions} from "@floating-ui/core"

import { safeCallMethod } from "../utilities/reflection";

interface UseFloatingUIOptions extends ComputePositionConfig {
    floatingElement?: Element,
    referenceElement?: Element
}

export interface FloatingEvent {
    reference: Element,
    floating: Element,
}

export interface FloatingPositionEvent extends FloatingEvent {
    position: ComputePositionReturn
}

export interface ArrowPositionEvent {
    element: Element,
    position: ComputePositionReturn,
    data: Coords & { centerOffset: number },
    side: string,
}

const DEFAULT_OPTIONS: UseFloatingUIOptions = {
    placement: "bottom",
    strategy: "absolute",
    middleware: [flip(), shift()]
}

export const STATIC_SIDE: { [key: string]: string } = {
    top: "bottom",
    right: "left",
    bottom: "top",
    left: "right"
};

export default (controller: Controller, options?: UseFloatingUIOptions) => {
    const {
        floatingElement,
        referenceElement,
        ...floatingOptions
    } = Object.assign({}, DEFAULT_OPTIONS, options);

    const floating: HTMLElement = (floatingElement || controller.element) as HTMLElement;

    const updatePlacement = (position: ComputePositionReturn): void => {
        const style = {left: `${position.x}px`, top: `${position.y}px`, position: position.strategy}
        Object.assign(floating.style, style);
        floating.setAttribute("data-floating-placement", position.placement);
    };

    const computeElementPosition = (attached: boolean): void => {
        computePosition(referenceElement as Element, floating, floatingOptions).then((position) => {
            controller.application.logDebugActivity(
                "use-floating-ui",
                "computeElementPosition",
                { reference: referenceElement, floating, position, attached }
            );

            updatePlacement(position);
            const args = { reference: referenceElement, floating, position };
            !attached && safeCallMethod(controller, "onFloatingAttached", args);
            safeCallMethod(controller, "onFloatingPositionChanged", args);
        })
    }

    let unsubscribe: (() => void) | undefined = undefined

    const detach = () => {
        if (unsubscribe) {
            controller.application.logDebugActivity("use-floating-ui", "detach", { floating });
            unsubscribe();
            unsubscribe = undefined;
            safeCallMethod(controller, "onFloatingAttached", { reference: referenceElement, floating });
        }
    }

    const attach = () => {
        detach();
        controller.application.logDebugActivity("use-floating-ui", "attach", { reference: referenceElement, floating });
        computeElementPosition(false);
        unsubscribe = autoUpdate(referenceElement as Element, floating, () => computeElementPosition(true));
        return () => unsubscribe && unsubscribe();
    }

    const controllerDisconnect = controller.disconnect.bind(controller)

    Object.assign(controller, {
        disconnect() {
            detach()
            controllerDisconnect()
        },
    });

    computeElementPosition(true);

    return [attach, detach] as const;
}
