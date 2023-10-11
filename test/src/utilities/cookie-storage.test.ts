import { jest, describe, expect, test, beforeEach } from '@jest/globals';
import Cookies from 'js-cookie';
import CookieStorage from '../../../src/utilities/cookie-storage';

jest.mock('js-cookie');

describe('utilities', () => {
    describe('cookie-storage', () => {
        beforeEach(() => {
            (Cookies.get as any).mockClear();
        });

        test('.length', () => {
            const storage = new CookieStorage();
            expect(storage.length).toBe(-1);
        });

        test('.getItem', () => {
            const storage = new CookieStorage();
            (Cookies.get as any).mockReturnValueOnce('bar');
            const value = storage.getItem('foo');
            expect((Cookies.get as any).mock.calls.length).toBe(1);
            expect(value).toEqual('bar');
        });

        test('.key', () => {
            const storage = new CookieStorage();
            expect(storage.key()).toBeNull();
        });

        test('.removeItem', () => {
            const storage = new CookieStorage();
            (Cookies.remove as any).mockReturnValueOnce();
            storage.removeItem('foo');
            expect((Cookies.remove as any).mock.calls.length).toBe(1);
        });

        test('.setItem', () => {
            const storage = new CookieStorage();
            (Cookies.set as any).mockReturnValueOnce();
            storage.setItem('foo', 'bar');
            expect((Cookies.set as any).mock.calls.length).toBe(1);
        });
    });
});
