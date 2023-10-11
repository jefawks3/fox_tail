import { jest, describe, expect, test } from '@jest/globals';
import Stack from '../../../src/utilities/stack';

describe('utilities', () => {
    describe('stack', () => {
        describe('constructor', () => {
            test('is empty', () => {
                const stack = new Stack<number>();
                expect((stack as any).stack).toEqual([]);
            });

            test('has values', () => {
                const stack = new Stack<number>([1, 3, 5]);
                expect((stack as any).stack).toEqual([1, 3, 5]);
            });
        });

        test('.forEach', () => {
            const callback = jest.fn();
            const stack = new Stack<number>([1, 3, 5]);
            stack.forEach(callback);
            expect(callback.mock.calls).toEqual([
                [1, 0, [1, 3, 5]],
                [3, 1, [1, 3, 5]],
                [5, 2, [1, 3, 5]],
            ]);
        });

        test('.size', () => {
            const stack = new Stack<number>([1, 3, 5]);
            expect(stack.size()).toEqual(3);
        });

        describe('.peak', () => {
            test('return last element', () => {
                const stack = new Stack<number>([1, 3, 5]);
                expect(stack.peak()).toEqual(5);
                expect((stack as any).stack).toEqual([1, 3, 5]);
            });

            test('return at index', () => {
                const stack = new Stack<number>([1, 3, 5]);
                expect(stack.peak(1)).toEqual(3);
                expect((stack as any).stack).toEqual([1, 3, 5]);
            });

            test('return undefined', () => {
                const stack = new Stack<number>([1, 3, 5]);
                expect(stack.peak(100)).toBeUndefined();
                expect((stack as any).stack).toEqual([1, 3, 5]);
            });
        });

        test('.push', () => {
            const stack = new Stack<number>([1, 3, 5]);
            stack.push(7);
            expect((stack as any).stack).toEqual([1, 3, 5, 7]);
        });

        describe('.pop', () => {
            test('removes last element', () => {
                const stack = new Stack<number>([1, 3, 5]);
                expect(stack.pop()).toEqual(5);
                expect((stack as any).stack).toEqual([1, 3]);
            });

            test('returns undefined', () => {
                const stack = new Stack<number>();
                expect(stack.pop()).toBeUndefined();
            });
        });

        describe('.remove', () => {
            test('removes element', () => {
                const stack = new Stack<number>([1, 3, 5]);
                stack.remove(3);
                expect((stack as any).stack).toEqual([1, 5]);
            });

            test('does nothing', () => {
                const stack = new Stack<number>([1, 3, 5]);
                stack.remove(100);
                expect((stack as any).stack).toEqual([1, 3, 5]);
            });
        });

        describe('.removeAt', () => {
            test('removes element', () => {
                const stack = new Stack<number>([1, 3, 5]);
                stack.removeAt(1);
                expect((stack as any).stack).toEqual([1, 5]);
            });

            test('does nothing', () => {
                const stack = new Stack<number>([1, 3, 5]);
                stack.removeAt(100);
                expect((stack as any).stack).toEqual([1, 3, 5]);
            });
        });

        describe('.has', () => {
            test('returns true', () => {
                const stack = new Stack<number>([1, 3, 5]);
                expect(stack.has(3)).toBeTruthy();
            });

            test('returns false', () => {
                const stack = new Stack<number>([1, 3, 5]);
                expect(stack.has(100)).toBeFalsy();
            });
        });
    });
});
