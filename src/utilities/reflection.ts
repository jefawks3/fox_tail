/* eslint-disable @typescript-eslint/no-explicit-any, @typescript-eslint/ban-types */

export const noop = () => {};

export const getMethod = (
    object: any,
    name: string,
): (() => Function | undefined) => {
    const method = object[name];
    return typeof method === 'function' ? method : undefined;
};

export const safeGetMethod = (object: any, name: string): Function => {
    return getMethod(object, name) || noop;
};

export const callMethod = (object: any, name: string, ...args: any[]): any => {
    // eslint-disable-next-line @typescript-eslint/ban-types
    return (getMethod(object, name) as Function).call(object, ...args);
};

export const safeCallMethod = (
    object: any,
    name: string,
    ...args: any[]
): any => {
    return safeGetMethod(object, name).call(object, ...args);
};

/* eslint-enable @typescript-eslint/no-explicit-any, @typescript-eslint/ban-types */
