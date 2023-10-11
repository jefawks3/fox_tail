import { describe, expect, test } from '@jest/globals';
import * as EventHelpers from '../../../src/utilities/event_helpers';

describe('utilities', () => {
    describe('event_helpers', () => {
        describe('getEventNames', () => {
            test('single', () => {
                const names = EventHelpers.getEventNames('fooBar');
                expect(names).toEqual(['fooBar']);
            });

            test('single with prefix', () => {
                const names = EventHelpers.getEventNames('fooBar', 'test');
                expect(names).toEqual(['test:fooBar']);
            });

            test('multiple', () => {
                const names = EventHelpers.getEventNames(['foo', 'bar']);
                expect(names).toEqual(['foo', 'bar']);
            });

            test('multiple with prefix', () => {
                const names = EventHelpers.getEventNames(
                    ['foo', 'bar'],
                    'test',
                );
                expect(names).toEqual(['test:foo', 'test:bar']);
            });
        });

        test('unsubscribeTo', () => {
            const element = document.createElement('div');
            const mockedRemoveEventListener = jest.fn();
            element.removeEventListener = mockedRemoveEventListener;
            EventHelpers.unsubscribeTo(element, ['foo', 'bar'], () => {});
            expect(mockedRemoveEventListener.mock.calls).toHaveLength(2);
        });

        test('subscribeTo', () => {
            const element = document.createElement('div');
            const mockedAddEventListener = jest.fn();
            const mockedRemoveEventListener = jest.fn();
            element.addEventListener = mockedAddEventListener;
            element.removeEventListener = mockedRemoveEventListener;
            const unsubscribe = EventHelpers.subscribeTo(
                element,
                ['foo', 'bar'],
                () => {},
            );
            expect(unsubscribe).toBeInstanceOf(Function);
            expect(mockedAddEventListener.mock.calls).toHaveLength(2);
            expect(mockedRemoveEventListener.mock.calls).toHaveLength(0);
            unsubscribe();
            expect(mockedRemoveEventListener.mock.calls).toHaveLength(2);
        });
    });
});
