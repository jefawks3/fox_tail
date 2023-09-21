type Callback = (...args: any[]) => void

export default (callback: Callback, delay: number): Callback => {
    let timeout: number;

    return (...args: any[]) => {
        clearTimeout(timeout);
        timeout = setTimeout(() => callback(...args), delay);
    }
}
