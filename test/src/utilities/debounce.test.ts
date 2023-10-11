import { jest, describe, expect, test, beforeEach } from '@jest/globals';
import debounce from '../../../src/utilities/debounce';

describe('utilities', () => {
    describe('debounce', () => {
        test('only called once', (done) => {
            let count = 0;
            const testFunction = () => count++;
            const debounceTestFunction = debounce(testFunction, 100);

            for (let i = 1; i <= 10; i++) {
                setTimeout(debounceTestFunction, 50 * i);
            }

            setTimeout(() => {
                expect(count).toEqual(1);
                done();
            }, 1000);
        });
    });
});
