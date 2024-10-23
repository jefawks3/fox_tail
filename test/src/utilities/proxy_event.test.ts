import { describe, expect, test, afterEach, jest } from '@jest/globals';
import proxy_event from '../../../src/utilities/proxy_event';

describe('utilities', () => {
    describe('proxy_event', () => {
        afterEach(() => {
            jest.clearAllMocks();
        });

        test('uses original event properties', () => {
            const originalEvent = new CustomEvent('test:event', {
                cancelable: true,
                bubbles: true,
                composed: true,
                detail: { foo: 'bar' },
            });

            const proxyEvent = proxy_event(originalEvent);

            expect(proxyEvent.type).toEqual('test:event');
            expect((proxyEvent as any).detail).toEqual({ foo: 'bar' });
            expect(proxyEvent.cancelable).toBeTruthy();
            expect(proxyEvent.bubbles).toBeFalsy();
            expect(proxyEvent.composed).toBeFalsy();
        });

        test('proxies defaultPrevented', () => {
            const originalEvent = new CustomEvent('test:event', {
                cancelable: true,
            });

            const proxyEvent = proxy_event(originalEvent);

            proxyEvent.preventDefault();
            expect(originalEvent.defaultPrevented).toBeTruthy();
            expect(proxyEvent.defaultPrevented).toBeTruthy();
        });

        test('proxies stopPropagation', () => {
            const originalEvent = new CustomEvent('test:event', {
                bubbles: true,
            });

            const proxyEvent = proxy_event(originalEvent);

            jest.spyOn(originalEvent, 'stopPropagation');

            proxyEvent.stopPropagation();

            expect(originalEvent.stopPropagation).toHaveBeenCalled();
        });

        test('proxies stopImmediatePropagation', () => {
            const originalEvent = new CustomEvent('test:event', {
                bubbles: true,
            });

            const proxyEvent = proxy_event(originalEvent);

            jest.spyOn(originalEvent, 'stopImmediatePropagation');

            proxyEvent.stopImmediatePropagation();

            expect(originalEvent.stopImmediatePropagation).toHaveBeenCalled();
        });
    });
});
