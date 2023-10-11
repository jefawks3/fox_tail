// eslint-disable-next-line @typescript-eslint/no-explicit-any
type Callback = (...args: any[]) => void;

export default (callback: Callback, delay: number): Callback => {
    let timeout: NodeJS.Timeout;

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    return (...args: any[]) => {
        clearTimeout(timeout);
        timeout = setTimeout(() => callback(...args), delay);
    };
};
