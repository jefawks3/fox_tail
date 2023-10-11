import { describe, expect, test } from '@jest/globals';
import * as Reflection from '../../../src/utilities/reflection';

describe('utilities', () => {
    describe('Reflection', () => {
        describe('.getMethod', () => {
            test('returns undefined', () => {
                const object = { test: () => true };
                const method = Reflection.getMethod(object, 'fooBar');
                expect(method).toBeUndefined();
            });

            test('returns the function', () => {
                const object = { test: () => true };
                const method = Reflection.getMethod(object, 'test');
                expect(method).toEqual(object.test);
            });
        });

        describe('.safeGetMethod', () => {
            test('returns noop', () => {
                const object = { test: () => true };
                const method = Reflection.safeGetMethod(object, 'fooBar');
                expect(method).toEqual(Reflection.noop);
            });

            test('returns the function', () => {
                const object = { test: () => true };
                const method = Reflection.safeGetMethod(object, 'test');
                expect(method).toEqual(object.test);
            });
        });

        describe('.callMethod', () => {
            test('returns noop', () => {
                const object = { test: () => true };
                expect(() =>
                    Reflection.callMethod(object, 'fooBar'),
                ).toThrowError();
            });

            test('returns the value', () => {
                const object = { test: () => true };
                const value = Reflection.callMethod(object, 'test');
                expect(value).toBeTruthy();
            });
        });

        describe('.safeCallMethod', () => {
            test('returns undefined', () => {
                const object = { test: () => true };
                const value = Reflection.safeCallMethod(object, 'fooBar');
                expect(value).toBeUndefined();
            });

            test('returns the value', () => {
                const object = { test: () => true };
                const value = Reflection.safeCallMethod(object, 'test');
                expect(value).toBeTruthy();
            });
        });
    });
});
