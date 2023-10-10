import { twMerge } from 'tailwind-merge';

export const addClasses = (element: Element, ...classes: string[]): void => {
    element.className = twMerge(element.className, classes.join(' '));
};

export const setClasses = (element: Element, ...classes: string[]): void => {
    element.className = twMerge(classes.join(' '));
};
