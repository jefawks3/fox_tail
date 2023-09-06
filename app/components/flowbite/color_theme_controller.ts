import {Controller} from "@hotwired/stimulus";
import CookieStorage from "../../../src/utilities/cookie-storage";

export default class extends Controller {
    static values = {
        key: {
            type: String,
            default: "color-theme",
        },
        storage: {
            type: String,
            default: 'local',
        },
        defaultTheme: {
            type: String,
            default: 'media'
        },
        domain: String,
    }

    declare readonly keyValue: string;
    declare readonly storageValue: string;
    declare readonly defaultThemeValue: string;
    declare readonly hasDomainValue: boolean;
    declare readonly domainValue: string;

    get htmlElement(): Element {
        return document.querySelector("html") as Element;
    }

    toggle() {
        if (this.isDarkMode()) {
            this.setLightMode();
        } else {
            this.setDarkMode();
        }
    }

    setDarkMode() {
        if (this.onThemeChange("dark")) { return; }

        this.htmlElement.classList.add("dark");
        this.getStorage().setItem(this.keyValue, "dark");
        this.onThemeChanged("dark");
    }

    setLightMode() {
        if (this.onThemeChange("light")) { return; }

        this.htmlElement.classList.remove("dark");
        this.getStorage().setItem(this.keyValue, "light");
        this.onThemeChanged("light");
    }

    setPreferred() {
        if (this.onThemeChange("media")) { return; }

        this.getStorage().setItem(this.keyValue, "media");

        if (this.getPreferredTheme() === "dark") {
            this.htmlElement.classList.add("dark");
        } else {
            this.htmlElement.classList.remove("dark");
        }

        this.onThemeChanged("media")
    }

    protected onThemeChange(mode: string): boolean {
        return this.dispatch('change', { detail: {mode}, cancelable: true }).defaultPrevented;
    }

    protected onThemeChanged(mode: string) {
        this.dispatch('changed', { detail: {mode} });
    }

    private getStorage(): Storage {
        if (this.storageValue === 'local') {
            return window.localStorage;
        } else if(this.storageValue === 'session') {
            return window.sessionStorage;
        } else if(this.storageValue === 'cookie') {
            return new CookieStorage({ domain: this.hasDomainValue ? this.domainValue : undefined });
        } else {
            throw `Unknown storage type '${this.storageValue}'`
        }
    }

    private getPreferredTheme(): string {
        return window.matchMedia && window.matchMedia("(prefers-color-scheme:dark)").matches ? "dark" : "light"
    }

    private getCurrentTheme(): string {
        const storage = this.getStorage();
        return storage.getItem(this.keyValue) || this.defaultThemeValue;
    }

    private isDarkMode(): boolean {
        let theme = this.getCurrentTheme();

        if (theme === "media") { theme = this.getPreferredTheme() }

        return theme === "dark";
    }
}

