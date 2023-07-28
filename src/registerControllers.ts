import type {Application} from "@hotwired/stimulus";

import LinkController from '../app/components/flowbite/link_controller';
import ButtonController from '../app/components/flowbite/button_controller';

const fullControllerName = (namespace: string | null, name: string): string =>
    namespace && namespace.length > 0 ? `${namespace}-${name}` : name

export default (application: Application, namespace: string | null = "flowbite-"): void => {
    application.register(fullControllerName(namespace, 'link'), LinkController);
    application.register(fullControllerName(namespace, 'button'), ButtonController);
}
