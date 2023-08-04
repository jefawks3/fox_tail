import type {Application} from "@hotwired/stimulus";
import * as Components from "../app/components/flowbite";

const fullControllerName = (namespace: string | null, name: string): string =>
    namespace && namespace.length > 0 ? `${namespace}-${name}` : name

export default (application: Application, namespace: string | null = "flowbite-"): void => {
    application.register(fullControllerName(namespace, 'clickable'), Components.ClickableController);
    application.register(fullControllerName(namespace, 'dismiss'), Components.DismissController);
    application.register(fullControllerName(namespace, 'dropdown'), Components.DropdownController);
}
