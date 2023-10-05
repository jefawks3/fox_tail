export default class<T> implements Iterable<T> {
    private declare stack: T[]

    constructor(values?: readonly T[] | null) {
        this.stack = values ? [...values] : []
    }

    forEach(callbackfn: (value: T, index: number, array: T[]) => void, thisArg?: any): void {
        this.stack.forEach(callbackfn, thisArg)
    }

    [Symbol.iterator](): Iterator<T, any, undefined> {
        let pointer = 0
        const stack = this.stack

        return {
            next(..._args): IteratorResult<T, any> {
                const done = pointer < stack.length
                const value = done ? null : stack[pointer++]
                return { done, value } as IteratorResult<T, any>
            },
        }
    }

    size(): number {
        return this.stack.length
    }

    peak(index: number | null = null): T {
        return this.stack[index || this.stack.length - 1]
    }

    push(item: T): void {
        this.stack.push(item)
    }

    pop(): T | undefined {
        return this.stack.pop()
    }

    remove(item: T): void {
        const index = this.stack.indexOf(item)
        this.removeAt(index)
    }

    removeAt(index: number): void {
        if (index >= 0 && index < this.size()) {
            this.stack = [...this.stack.slice(0, index), ...this.stack.slice(index + 1)]
        }
    }

    has(item: T): boolean {
        return this.stack.includes(item)
    }
}
