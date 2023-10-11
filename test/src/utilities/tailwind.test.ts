import { describe, expect, test } from '@jest/globals';
import * as Tailwind from '../../../src/utilities/tailwind';

describe('utilities', () => {
    describe('tailwind', () => {
        test('addClasses', () => {
            const element = document.createElement('div');
            element.className =
                'p-5 text-gray-900 dark:text-white m-2 border border-gray-100';
            Tailwind.addClasses(
                element,
                'px-2',
                'py-3',
                'text-blue-800',
                'dark:text-blue-600',
            );
            expect(element.className).toEqual(
                'p-5 m-2 border border-gray-100 px-2 py-3 text-blue-800 dark:text-blue-600',
            );
        });

        test('setClasses', () => {
            const element = document.createElement('div');
            element.className =
                'p-5 text-gray-900 dark:text-white m-2 border border-gray-100';
            Tailwind.setClasses(
                element,
                'px-2',
                'py-3',
                'text-blue-800',
                'dark:text-blue-600',
                'px-3',
            );
            expect(element.className).toEqual(
                'py-3 text-blue-800 dark:text-blue-600 px-3',
            );
        });
    });
});
