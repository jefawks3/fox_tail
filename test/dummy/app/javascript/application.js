// Entry point for the build script in your package.json
import { Application } from '@hotwired/stimulus';
import { registerControllers } from '../../../../src/index';

window.Stimulus = Application.start();
Stimulus.debug = true;
registerControllers(Stimulus);
