import Cookies from 'js-cookie';

interface Options {
    domain?: string | undefined;
}

export default class implements Storage {
    private readonly options: Options | undefined;

    constructor(options?: Options) {
        this.options = options;
    }

    [name: string]: any; // eslint-disable-line @typescript-eslint/no-explicit-any

    readonly length: number = -1;

    clear(): void {}

    getItem(key: string): string | null {
        const value = Cookies.get(key);
        return value ? value : null;
    }

    key(): string | null {
        return null;
    }

    removeItem(key: string, options?: Options): void {
        Cookies.remove(key, this.mergeOptions(options));
    }

    setItem(key: string, value: string, options?: Options): void {
        Cookies.set(key, value, this.mergeOptions(options));
    }

    private mergeOptions(options?: Options): Options {
        return Object.assign({}, this.options, options) as Options;
    }
}
