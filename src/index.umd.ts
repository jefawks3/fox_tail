export * from '../app/components/fox_tail';

import registerControllers from './register-controllers';
import { Application } from '@hotwired/stimulus';

registerControllers((window as any).Stimulus as Application);
