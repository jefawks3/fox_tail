// Entry point for the build script in your package.json
import {Application} from "@hotwired/stimulus";
import 'flowbite';

import {registerControllers} from '../../../../src/index'

window.Stimulus = Application.start();
registerControllers(Stimulus);
