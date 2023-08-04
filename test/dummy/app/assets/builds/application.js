(() => {
  // node_modules/@hotwired/stimulus/dist/stimulus.js
  var EventListener = class {
    constructor(eventTarget, eventName, eventOptions) {
      this.eventTarget = eventTarget;
      this.eventName = eventName;
      this.eventOptions = eventOptions;
      this.unorderedBindings = /* @__PURE__ */ new Set();
    }
    connect() {
      this.eventTarget.addEventListener(this.eventName, this, this.eventOptions);
    }
    disconnect() {
      this.eventTarget.removeEventListener(this.eventName, this, this.eventOptions);
    }
    bindingConnected(binding) {
      this.unorderedBindings.add(binding);
    }
    bindingDisconnected(binding) {
      this.unorderedBindings.delete(binding);
    }
    handleEvent(event) {
      const extendedEvent = extendEvent(event);
      for (const binding of this.bindings) {
        if (extendedEvent.immediatePropagationStopped) {
          break;
        } else {
          binding.handleEvent(extendedEvent);
        }
      }
    }
    hasBindings() {
      return this.unorderedBindings.size > 0;
    }
    get bindings() {
      return Array.from(this.unorderedBindings).sort((left2, right2) => {
        const leftIndex = left2.index, rightIndex = right2.index;
        return leftIndex < rightIndex ? -1 : leftIndex > rightIndex ? 1 : 0;
      });
    }
  };
  function extendEvent(event) {
    if ("immediatePropagationStopped" in event) {
      return event;
    } else {
      const { stopImmediatePropagation } = event;
      return Object.assign(event, {
        immediatePropagationStopped: false,
        stopImmediatePropagation() {
          this.immediatePropagationStopped = true;
          stopImmediatePropagation.call(this);
        }
      });
    }
  }
  var Dispatcher = class {
    constructor(application) {
      this.application = application;
      this.eventListenerMaps = /* @__PURE__ */ new Map();
      this.started = false;
    }
    start() {
      if (!this.started) {
        this.started = true;
        this.eventListeners.forEach((eventListener) => eventListener.connect());
      }
    }
    stop() {
      if (this.started) {
        this.started = false;
        this.eventListeners.forEach((eventListener) => eventListener.disconnect());
      }
    }
    get eventListeners() {
      return Array.from(this.eventListenerMaps.values()).reduce((listeners, map) => listeners.concat(Array.from(map.values())), []);
    }
    bindingConnected(binding) {
      this.fetchEventListenerForBinding(binding).bindingConnected(binding);
    }
    bindingDisconnected(binding, clearEventListeners = false) {
      this.fetchEventListenerForBinding(binding).bindingDisconnected(binding);
      if (clearEventListeners)
        this.clearEventListenersForBinding(binding);
    }
    handleError(error2, message, detail = {}) {
      this.application.handleError(error2, `Error ${message}`, detail);
    }
    clearEventListenersForBinding(binding) {
      const eventListener = this.fetchEventListenerForBinding(binding);
      if (!eventListener.hasBindings()) {
        eventListener.disconnect();
        this.removeMappedEventListenerFor(binding);
      }
    }
    removeMappedEventListenerFor(binding) {
      const { eventTarget, eventName, eventOptions } = binding;
      const eventListenerMap = this.fetchEventListenerMapForEventTarget(eventTarget);
      const cacheKey = this.cacheKey(eventName, eventOptions);
      eventListenerMap.delete(cacheKey);
      if (eventListenerMap.size == 0)
        this.eventListenerMaps.delete(eventTarget);
    }
    fetchEventListenerForBinding(binding) {
      const { eventTarget, eventName, eventOptions } = binding;
      return this.fetchEventListener(eventTarget, eventName, eventOptions);
    }
    fetchEventListener(eventTarget, eventName, eventOptions) {
      const eventListenerMap = this.fetchEventListenerMapForEventTarget(eventTarget);
      const cacheKey = this.cacheKey(eventName, eventOptions);
      let eventListener = eventListenerMap.get(cacheKey);
      if (!eventListener) {
        eventListener = this.createEventListener(eventTarget, eventName, eventOptions);
        eventListenerMap.set(cacheKey, eventListener);
      }
      return eventListener;
    }
    createEventListener(eventTarget, eventName, eventOptions) {
      const eventListener = new EventListener(eventTarget, eventName, eventOptions);
      if (this.started) {
        eventListener.connect();
      }
      return eventListener;
    }
    fetchEventListenerMapForEventTarget(eventTarget) {
      let eventListenerMap = this.eventListenerMaps.get(eventTarget);
      if (!eventListenerMap) {
        eventListenerMap = /* @__PURE__ */ new Map();
        this.eventListenerMaps.set(eventTarget, eventListenerMap);
      }
      return eventListenerMap;
    }
    cacheKey(eventName, eventOptions) {
      const parts = [eventName];
      Object.keys(eventOptions).sort().forEach((key) => {
        parts.push(`${eventOptions[key] ? "" : "!"}${key}`);
      });
      return parts.join(":");
    }
  };
  var defaultActionDescriptorFilters = {
    stop({ event, value }) {
      if (value)
        event.stopPropagation();
      return true;
    },
    prevent({ event, value }) {
      if (value)
        event.preventDefault();
      return true;
    },
    self({ event, value, element }) {
      if (value) {
        return element === event.target;
      } else {
        return true;
      }
    }
  };
  var descriptorPattern = /^(?:(.+?)(?:\.(.+?))?(?:@(window|document))?->)?(.+?)(?:#([^:]+?))(?::(.+))?$/;
  function parseActionDescriptorString(descriptorString) {
    const source = descriptorString.trim();
    const matches = source.match(descriptorPattern) || [];
    let eventName = matches[1];
    let keyFilter = matches[2];
    if (keyFilter && !["keydown", "keyup", "keypress"].includes(eventName)) {
      eventName += `.${keyFilter}`;
      keyFilter = "";
    }
    return {
      eventTarget: parseEventTarget(matches[3]),
      eventName,
      eventOptions: matches[6] ? parseEventOptions(matches[6]) : {},
      identifier: matches[4],
      methodName: matches[5],
      keyFilter
    };
  }
  function parseEventTarget(eventTargetName) {
    if (eventTargetName == "window") {
      return window;
    } else if (eventTargetName == "document") {
      return document;
    }
  }
  function parseEventOptions(eventOptions) {
    return eventOptions.split(":").reduce((options, token) => Object.assign(options, { [token.replace(/^!/, "")]: !/^!/.test(token) }), {});
  }
  function stringifyEventTarget(eventTarget) {
    if (eventTarget == window) {
      return "window";
    } else if (eventTarget == document) {
      return "document";
    }
  }
  function camelize(value) {
    return value.replace(/(?:[_-])([a-z0-9])/g, (_, char) => char.toUpperCase());
  }
  function namespaceCamelize(value) {
    return camelize(value.replace(/--/g, "-").replace(/__/g, "_"));
  }
  function capitalize(value) {
    return value.charAt(0).toUpperCase() + value.slice(1);
  }
  function dasherize(value) {
    return value.replace(/([A-Z])/g, (_, char) => `-${char.toLowerCase()}`);
  }
  function tokenize(value) {
    return value.match(/[^\s]+/g) || [];
  }
  var Action = class {
    constructor(element, index, descriptor, schema) {
      this.element = element;
      this.index = index;
      this.eventTarget = descriptor.eventTarget || element;
      this.eventName = descriptor.eventName || getDefaultEventNameForElement(element) || error("missing event name");
      this.eventOptions = descriptor.eventOptions || {};
      this.identifier = descriptor.identifier || error("missing identifier");
      this.methodName = descriptor.methodName || error("missing method name");
      this.keyFilter = descriptor.keyFilter || "";
      this.schema = schema;
    }
    static forToken(token, schema) {
      return new this(token.element, token.index, parseActionDescriptorString(token.content), schema);
    }
    toString() {
      const eventFilter = this.keyFilter ? `.${this.keyFilter}` : "";
      const eventTarget = this.eventTargetName ? `@${this.eventTargetName}` : "";
      return `${this.eventName}${eventFilter}${eventTarget}->${this.identifier}#${this.methodName}`;
    }
    isFilterTarget(event) {
      if (!this.keyFilter) {
        return false;
      }
      const filteres = this.keyFilter.split("+");
      const modifiers = ["meta", "ctrl", "alt", "shift"];
      const [meta, ctrl, alt, shift] = modifiers.map((modifier) => filteres.includes(modifier));
      if (event.metaKey !== meta || event.ctrlKey !== ctrl || event.altKey !== alt || event.shiftKey !== shift) {
        return true;
      }
      const standardFilter = filteres.filter((key) => !modifiers.includes(key))[0];
      if (!standardFilter) {
        return false;
      }
      if (!Object.prototype.hasOwnProperty.call(this.keyMappings, standardFilter)) {
        error(`contains unknown key filter: ${this.keyFilter}`);
      }
      return this.keyMappings[standardFilter].toLowerCase() !== event.key.toLowerCase();
    }
    get params() {
      const params = {};
      const pattern = new RegExp(`^data-${this.identifier}-(.+)-param$`, "i");
      for (const { name, value } of Array.from(this.element.attributes)) {
        const match = name.match(pattern);
        const key = match && match[1];
        if (key) {
          params[camelize(key)] = typecast(value);
        }
      }
      return params;
    }
    get eventTargetName() {
      return stringifyEventTarget(this.eventTarget);
    }
    get keyMappings() {
      return this.schema.keyMappings;
    }
  };
  var defaultEventNames = {
    a: () => "click",
    button: () => "click",
    form: () => "submit",
    details: () => "toggle",
    input: (e) => e.getAttribute("type") == "submit" ? "click" : "input",
    select: () => "change",
    textarea: () => "input"
  };
  function getDefaultEventNameForElement(element) {
    const tagName = element.tagName.toLowerCase();
    if (tagName in defaultEventNames) {
      return defaultEventNames[tagName](element);
    }
  }
  function error(message) {
    throw new Error(message);
  }
  function typecast(value) {
    try {
      return JSON.parse(value);
    } catch (o_O) {
      return value;
    }
  }
  var Binding = class {
    constructor(context, action) {
      this.context = context;
      this.action = action;
    }
    get index() {
      return this.action.index;
    }
    get eventTarget() {
      return this.action.eventTarget;
    }
    get eventOptions() {
      return this.action.eventOptions;
    }
    get identifier() {
      return this.context.identifier;
    }
    handleEvent(event) {
      if (this.willBeInvokedByEvent(event) && this.applyEventModifiers(event)) {
        this.invokeWithEvent(event);
      }
    }
    get eventName() {
      return this.action.eventName;
    }
    get method() {
      const method = this.controller[this.methodName];
      if (typeof method == "function") {
        return method;
      }
      throw new Error(`Action "${this.action}" references undefined method "${this.methodName}"`);
    }
    applyEventModifiers(event) {
      const { element } = this.action;
      const { actionDescriptorFilters } = this.context.application;
      let passes = true;
      for (const [name, value] of Object.entries(this.eventOptions)) {
        if (name in actionDescriptorFilters) {
          const filter = actionDescriptorFilters[name];
          passes = passes && filter({ name, value, event, element });
        } else {
          continue;
        }
      }
      return passes;
    }
    invokeWithEvent(event) {
      const { target, currentTarget } = event;
      try {
        const { params } = this.action;
        const actionEvent = Object.assign(event, { params });
        this.method.call(this.controller, actionEvent);
        this.context.logDebugActivity(this.methodName, { event, target, currentTarget, action: this.methodName });
      } catch (error2) {
        const { identifier, controller, element, index } = this;
        const detail = { identifier, controller, element, index, event };
        this.context.handleError(error2, `invoking action "${this.action}"`, detail);
      }
    }
    willBeInvokedByEvent(event) {
      const eventTarget = event.target;
      if (event instanceof KeyboardEvent && this.action.isFilterTarget(event)) {
        return false;
      }
      if (this.element === eventTarget) {
        return true;
      } else if (eventTarget instanceof Element && this.element.contains(eventTarget)) {
        return this.scope.containsElement(eventTarget);
      } else {
        return this.scope.containsElement(this.action.element);
      }
    }
    get controller() {
      return this.context.controller;
    }
    get methodName() {
      return this.action.methodName;
    }
    get element() {
      return this.scope.element;
    }
    get scope() {
      return this.context.scope;
    }
  };
  var ElementObserver = class {
    constructor(element, delegate) {
      this.mutationObserverInit = { attributes: true, childList: true, subtree: true };
      this.element = element;
      this.started = false;
      this.delegate = delegate;
      this.elements = /* @__PURE__ */ new Set();
      this.mutationObserver = new MutationObserver((mutations) => this.processMutations(mutations));
    }
    start() {
      if (!this.started) {
        this.started = true;
        this.mutationObserver.observe(this.element, this.mutationObserverInit);
        this.refresh();
      }
    }
    pause(callback) {
      if (this.started) {
        this.mutationObserver.disconnect();
        this.started = false;
      }
      callback();
      if (!this.started) {
        this.mutationObserver.observe(this.element, this.mutationObserverInit);
        this.started = true;
      }
    }
    stop() {
      if (this.started) {
        this.mutationObserver.takeRecords();
        this.mutationObserver.disconnect();
        this.started = false;
      }
    }
    refresh() {
      if (this.started) {
        const matches = new Set(this.matchElementsInTree());
        for (const element of Array.from(this.elements)) {
          if (!matches.has(element)) {
            this.removeElement(element);
          }
        }
        for (const element of Array.from(matches)) {
          this.addElement(element);
        }
      }
    }
    processMutations(mutations) {
      if (this.started) {
        for (const mutation of mutations) {
          this.processMutation(mutation);
        }
      }
    }
    processMutation(mutation) {
      if (mutation.type == "attributes") {
        this.processAttributeChange(mutation.target, mutation.attributeName);
      } else if (mutation.type == "childList") {
        this.processRemovedNodes(mutation.removedNodes);
        this.processAddedNodes(mutation.addedNodes);
      }
    }
    processAttributeChange(node, attributeName) {
      const element = node;
      if (this.elements.has(element)) {
        if (this.delegate.elementAttributeChanged && this.matchElement(element)) {
          this.delegate.elementAttributeChanged(element, attributeName);
        } else {
          this.removeElement(element);
        }
      } else if (this.matchElement(element)) {
        this.addElement(element);
      }
    }
    processRemovedNodes(nodes) {
      for (const node of Array.from(nodes)) {
        const element = this.elementFromNode(node);
        if (element) {
          this.processTree(element, this.removeElement);
        }
      }
    }
    processAddedNodes(nodes) {
      for (const node of Array.from(nodes)) {
        const element = this.elementFromNode(node);
        if (element && this.elementIsActive(element)) {
          this.processTree(element, this.addElement);
        }
      }
    }
    matchElement(element) {
      return this.delegate.matchElement(element);
    }
    matchElementsInTree(tree = this.element) {
      return this.delegate.matchElementsInTree(tree);
    }
    processTree(tree, processor) {
      for (const element of this.matchElementsInTree(tree)) {
        processor.call(this, element);
      }
    }
    elementFromNode(node) {
      if (node.nodeType == Node.ELEMENT_NODE) {
        return node;
      }
    }
    elementIsActive(element) {
      if (element.isConnected != this.element.isConnected) {
        return false;
      } else {
        return this.element.contains(element);
      }
    }
    addElement(element) {
      if (!this.elements.has(element)) {
        if (this.elementIsActive(element)) {
          this.elements.add(element);
          if (this.delegate.elementMatched) {
            this.delegate.elementMatched(element);
          }
        }
      }
    }
    removeElement(element) {
      if (this.elements.has(element)) {
        this.elements.delete(element);
        if (this.delegate.elementUnmatched) {
          this.delegate.elementUnmatched(element);
        }
      }
    }
  };
  var AttributeObserver = class {
    constructor(element, attributeName, delegate) {
      this.attributeName = attributeName;
      this.delegate = delegate;
      this.elementObserver = new ElementObserver(element, this);
    }
    get element() {
      return this.elementObserver.element;
    }
    get selector() {
      return `[${this.attributeName}]`;
    }
    start() {
      this.elementObserver.start();
    }
    pause(callback) {
      this.elementObserver.pause(callback);
    }
    stop() {
      this.elementObserver.stop();
    }
    refresh() {
      this.elementObserver.refresh();
    }
    get started() {
      return this.elementObserver.started;
    }
    matchElement(element) {
      return element.hasAttribute(this.attributeName);
    }
    matchElementsInTree(tree) {
      const match = this.matchElement(tree) ? [tree] : [];
      const matches = Array.from(tree.querySelectorAll(this.selector));
      return match.concat(matches);
    }
    elementMatched(element) {
      if (this.delegate.elementMatchedAttribute) {
        this.delegate.elementMatchedAttribute(element, this.attributeName);
      }
    }
    elementUnmatched(element) {
      if (this.delegate.elementUnmatchedAttribute) {
        this.delegate.elementUnmatchedAttribute(element, this.attributeName);
      }
    }
    elementAttributeChanged(element, attributeName) {
      if (this.delegate.elementAttributeValueChanged && this.attributeName == attributeName) {
        this.delegate.elementAttributeValueChanged(element, attributeName);
      }
    }
  };
  function add(map, key, value) {
    fetch(map, key).add(value);
  }
  function del(map, key, value) {
    fetch(map, key).delete(value);
    prune(map, key);
  }
  function fetch(map, key) {
    let values = map.get(key);
    if (!values) {
      values = /* @__PURE__ */ new Set();
      map.set(key, values);
    }
    return values;
  }
  function prune(map, key) {
    const values = map.get(key);
    if (values != null && values.size == 0) {
      map.delete(key);
    }
  }
  var Multimap = class {
    constructor() {
      this.valuesByKey = /* @__PURE__ */ new Map();
    }
    get keys() {
      return Array.from(this.valuesByKey.keys());
    }
    get values() {
      const sets = Array.from(this.valuesByKey.values());
      return sets.reduce((values, set) => values.concat(Array.from(set)), []);
    }
    get size() {
      const sets = Array.from(this.valuesByKey.values());
      return sets.reduce((size, set) => size + set.size, 0);
    }
    add(key, value) {
      add(this.valuesByKey, key, value);
    }
    delete(key, value) {
      del(this.valuesByKey, key, value);
    }
    has(key, value) {
      const values = this.valuesByKey.get(key);
      return values != null && values.has(value);
    }
    hasKey(key) {
      return this.valuesByKey.has(key);
    }
    hasValue(value) {
      const sets = Array.from(this.valuesByKey.values());
      return sets.some((set) => set.has(value));
    }
    getValuesForKey(key) {
      const values = this.valuesByKey.get(key);
      return values ? Array.from(values) : [];
    }
    getKeysForValue(value) {
      return Array.from(this.valuesByKey).filter(([_key, values]) => values.has(value)).map(([key, _values]) => key);
    }
  };
  var SelectorObserver = class {
    constructor(element, selector, delegate, details = {}) {
      this.selector = selector;
      this.details = details;
      this.elementObserver = new ElementObserver(element, this);
      this.delegate = delegate;
      this.matchesByElement = new Multimap();
    }
    get started() {
      return this.elementObserver.started;
    }
    start() {
      this.elementObserver.start();
    }
    pause(callback) {
      this.elementObserver.pause(callback);
    }
    stop() {
      this.elementObserver.stop();
    }
    refresh() {
      this.elementObserver.refresh();
    }
    get element() {
      return this.elementObserver.element;
    }
    matchElement(element) {
      const matches = element.matches(this.selector);
      if (this.delegate.selectorMatchElement) {
        return matches && this.delegate.selectorMatchElement(element, this.details);
      }
      return matches;
    }
    matchElementsInTree(tree) {
      const match = this.matchElement(tree) ? [tree] : [];
      const matches = Array.from(tree.querySelectorAll(this.selector)).filter((match2) => this.matchElement(match2));
      return match.concat(matches);
    }
    elementMatched(element) {
      this.selectorMatched(element);
    }
    elementUnmatched(element) {
      this.selectorUnmatched(element);
    }
    elementAttributeChanged(element, _attributeName) {
      const matches = this.matchElement(element);
      const matchedBefore = this.matchesByElement.has(this.selector, element);
      if (!matches && matchedBefore) {
        this.selectorUnmatched(element);
      }
    }
    selectorMatched(element) {
      if (this.delegate.selectorMatched) {
        this.delegate.selectorMatched(element, this.selector, this.details);
        this.matchesByElement.add(this.selector, element);
      }
    }
    selectorUnmatched(element) {
      this.delegate.selectorUnmatched(element, this.selector, this.details);
      this.matchesByElement.delete(this.selector, element);
    }
  };
  var StringMapObserver = class {
    constructor(element, delegate) {
      this.element = element;
      this.delegate = delegate;
      this.started = false;
      this.stringMap = /* @__PURE__ */ new Map();
      this.mutationObserver = new MutationObserver((mutations) => this.processMutations(mutations));
    }
    start() {
      if (!this.started) {
        this.started = true;
        this.mutationObserver.observe(this.element, { attributes: true, attributeOldValue: true });
        this.refresh();
      }
    }
    stop() {
      if (this.started) {
        this.mutationObserver.takeRecords();
        this.mutationObserver.disconnect();
        this.started = false;
      }
    }
    refresh() {
      if (this.started) {
        for (const attributeName of this.knownAttributeNames) {
          this.refreshAttribute(attributeName, null);
        }
      }
    }
    processMutations(mutations) {
      if (this.started) {
        for (const mutation of mutations) {
          this.processMutation(mutation);
        }
      }
    }
    processMutation(mutation) {
      const attributeName = mutation.attributeName;
      if (attributeName) {
        this.refreshAttribute(attributeName, mutation.oldValue);
      }
    }
    refreshAttribute(attributeName, oldValue) {
      const key = this.delegate.getStringMapKeyForAttribute(attributeName);
      if (key != null) {
        if (!this.stringMap.has(attributeName)) {
          this.stringMapKeyAdded(key, attributeName);
        }
        const value = this.element.getAttribute(attributeName);
        if (this.stringMap.get(attributeName) != value) {
          this.stringMapValueChanged(value, key, oldValue);
        }
        if (value == null) {
          const oldValue2 = this.stringMap.get(attributeName);
          this.stringMap.delete(attributeName);
          if (oldValue2)
            this.stringMapKeyRemoved(key, attributeName, oldValue2);
        } else {
          this.stringMap.set(attributeName, value);
        }
      }
    }
    stringMapKeyAdded(key, attributeName) {
      if (this.delegate.stringMapKeyAdded) {
        this.delegate.stringMapKeyAdded(key, attributeName);
      }
    }
    stringMapValueChanged(value, key, oldValue) {
      if (this.delegate.stringMapValueChanged) {
        this.delegate.stringMapValueChanged(value, key, oldValue);
      }
    }
    stringMapKeyRemoved(key, attributeName, oldValue) {
      if (this.delegate.stringMapKeyRemoved) {
        this.delegate.stringMapKeyRemoved(key, attributeName, oldValue);
      }
    }
    get knownAttributeNames() {
      return Array.from(new Set(this.currentAttributeNames.concat(this.recordedAttributeNames)));
    }
    get currentAttributeNames() {
      return Array.from(this.element.attributes).map((attribute) => attribute.name);
    }
    get recordedAttributeNames() {
      return Array.from(this.stringMap.keys());
    }
  };
  var TokenListObserver = class {
    constructor(element, attributeName, delegate) {
      this.attributeObserver = new AttributeObserver(element, attributeName, this);
      this.delegate = delegate;
      this.tokensByElement = new Multimap();
    }
    get started() {
      return this.attributeObserver.started;
    }
    start() {
      this.attributeObserver.start();
    }
    pause(callback) {
      this.attributeObserver.pause(callback);
    }
    stop() {
      this.attributeObserver.stop();
    }
    refresh() {
      this.attributeObserver.refresh();
    }
    get element() {
      return this.attributeObserver.element;
    }
    get attributeName() {
      return this.attributeObserver.attributeName;
    }
    elementMatchedAttribute(element) {
      this.tokensMatched(this.readTokensForElement(element));
    }
    elementAttributeValueChanged(element) {
      const [unmatchedTokens, matchedTokens] = this.refreshTokensForElement(element);
      this.tokensUnmatched(unmatchedTokens);
      this.tokensMatched(matchedTokens);
    }
    elementUnmatchedAttribute(element) {
      this.tokensUnmatched(this.tokensByElement.getValuesForKey(element));
    }
    tokensMatched(tokens) {
      tokens.forEach((token) => this.tokenMatched(token));
    }
    tokensUnmatched(tokens) {
      tokens.forEach((token) => this.tokenUnmatched(token));
    }
    tokenMatched(token) {
      this.delegate.tokenMatched(token);
      this.tokensByElement.add(token.element, token);
    }
    tokenUnmatched(token) {
      this.delegate.tokenUnmatched(token);
      this.tokensByElement.delete(token.element, token);
    }
    refreshTokensForElement(element) {
      const previousTokens = this.tokensByElement.getValuesForKey(element);
      const currentTokens = this.readTokensForElement(element);
      const firstDifferingIndex = zip(previousTokens, currentTokens).findIndex(([previousToken, currentToken]) => !tokensAreEqual(previousToken, currentToken));
      if (firstDifferingIndex == -1) {
        return [[], []];
      } else {
        return [previousTokens.slice(firstDifferingIndex), currentTokens.slice(firstDifferingIndex)];
      }
    }
    readTokensForElement(element) {
      const attributeName = this.attributeName;
      const tokenString = element.getAttribute(attributeName) || "";
      return parseTokenString(tokenString, element, attributeName);
    }
  };
  function parseTokenString(tokenString, element, attributeName) {
    return tokenString.trim().split(/\s+/).filter((content) => content.length).map((content, index) => ({ element, attributeName, content, index }));
  }
  function zip(left2, right2) {
    const length = Math.max(left2.length, right2.length);
    return Array.from({ length }, (_, index) => [left2[index], right2[index]]);
  }
  function tokensAreEqual(left2, right2) {
    return left2 && right2 && left2.index == right2.index && left2.content == right2.content;
  }
  var ValueListObserver = class {
    constructor(element, attributeName, delegate) {
      this.tokenListObserver = new TokenListObserver(element, attributeName, this);
      this.delegate = delegate;
      this.parseResultsByToken = /* @__PURE__ */ new WeakMap();
      this.valuesByTokenByElement = /* @__PURE__ */ new WeakMap();
    }
    get started() {
      return this.tokenListObserver.started;
    }
    start() {
      this.tokenListObserver.start();
    }
    stop() {
      this.tokenListObserver.stop();
    }
    refresh() {
      this.tokenListObserver.refresh();
    }
    get element() {
      return this.tokenListObserver.element;
    }
    get attributeName() {
      return this.tokenListObserver.attributeName;
    }
    tokenMatched(token) {
      const { element } = token;
      const { value } = this.fetchParseResultForToken(token);
      if (value) {
        this.fetchValuesByTokenForElement(element).set(token, value);
        this.delegate.elementMatchedValue(element, value);
      }
    }
    tokenUnmatched(token) {
      const { element } = token;
      const { value } = this.fetchParseResultForToken(token);
      if (value) {
        this.fetchValuesByTokenForElement(element).delete(token);
        this.delegate.elementUnmatchedValue(element, value);
      }
    }
    fetchParseResultForToken(token) {
      let parseResult = this.parseResultsByToken.get(token);
      if (!parseResult) {
        parseResult = this.parseToken(token);
        this.parseResultsByToken.set(token, parseResult);
      }
      return parseResult;
    }
    fetchValuesByTokenForElement(element) {
      let valuesByToken = this.valuesByTokenByElement.get(element);
      if (!valuesByToken) {
        valuesByToken = /* @__PURE__ */ new Map();
        this.valuesByTokenByElement.set(element, valuesByToken);
      }
      return valuesByToken;
    }
    parseToken(token) {
      try {
        const value = this.delegate.parseValueForToken(token);
        return { value };
      } catch (error2) {
        return { error: error2 };
      }
    }
  };
  var BindingObserver = class {
    constructor(context, delegate) {
      this.context = context;
      this.delegate = delegate;
      this.bindingsByAction = /* @__PURE__ */ new Map();
    }
    start() {
      if (!this.valueListObserver) {
        this.valueListObserver = new ValueListObserver(this.element, this.actionAttribute, this);
        this.valueListObserver.start();
      }
    }
    stop() {
      if (this.valueListObserver) {
        this.valueListObserver.stop();
        delete this.valueListObserver;
        this.disconnectAllActions();
      }
    }
    get element() {
      return this.context.element;
    }
    get identifier() {
      return this.context.identifier;
    }
    get actionAttribute() {
      return this.schema.actionAttribute;
    }
    get schema() {
      return this.context.schema;
    }
    get bindings() {
      return Array.from(this.bindingsByAction.values());
    }
    connectAction(action) {
      const binding = new Binding(this.context, action);
      this.bindingsByAction.set(action, binding);
      this.delegate.bindingConnected(binding);
    }
    disconnectAction(action) {
      const binding = this.bindingsByAction.get(action);
      if (binding) {
        this.bindingsByAction.delete(action);
        this.delegate.bindingDisconnected(binding);
      }
    }
    disconnectAllActions() {
      this.bindings.forEach((binding) => this.delegate.bindingDisconnected(binding, true));
      this.bindingsByAction.clear();
    }
    parseValueForToken(token) {
      const action = Action.forToken(token, this.schema);
      if (action.identifier == this.identifier) {
        return action;
      }
    }
    elementMatchedValue(element, action) {
      this.connectAction(action);
    }
    elementUnmatchedValue(element, action) {
      this.disconnectAction(action);
    }
  };
  var ValueObserver = class {
    constructor(context, receiver) {
      this.context = context;
      this.receiver = receiver;
      this.stringMapObserver = new StringMapObserver(this.element, this);
      this.valueDescriptorMap = this.controller.valueDescriptorMap;
    }
    start() {
      this.stringMapObserver.start();
      this.invokeChangedCallbacksForDefaultValues();
    }
    stop() {
      this.stringMapObserver.stop();
    }
    get element() {
      return this.context.element;
    }
    get controller() {
      return this.context.controller;
    }
    getStringMapKeyForAttribute(attributeName) {
      if (attributeName in this.valueDescriptorMap) {
        return this.valueDescriptorMap[attributeName].name;
      }
    }
    stringMapKeyAdded(key, attributeName) {
      const descriptor = this.valueDescriptorMap[attributeName];
      if (!this.hasValue(key)) {
        this.invokeChangedCallback(key, descriptor.writer(this.receiver[key]), descriptor.writer(descriptor.defaultValue));
      }
    }
    stringMapValueChanged(value, name, oldValue) {
      const descriptor = this.valueDescriptorNameMap[name];
      if (value === null)
        return;
      if (oldValue === null) {
        oldValue = descriptor.writer(descriptor.defaultValue);
      }
      this.invokeChangedCallback(name, value, oldValue);
    }
    stringMapKeyRemoved(key, attributeName, oldValue) {
      const descriptor = this.valueDescriptorNameMap[key];
      if (this.hasValue(key)) {
        this.invokeChangedCallback(key, descriptor.writer(this.receiver[key]), oldValue);
      } else {
        this.invokeChangedCallback(key, descriptor.writer(descriptor.defaultValue), oldValue);
      }
    }
    invokeChangedCallbacksForDefaultValues() {
      for (const { key, name, defaultValue, writer } of this.valueDescriptors) {
        if (defaultValue != void 0 && !this.controller.data.has(key)) {
          this.invokeChangedCallback(name, writer(defaultValue), void 0);
        }
      }
    }
    invokeChangedCallback(name, rawValue, rawOldValue) {
      const changedMethodName = `${name}Changed`;
      const changedMethod = this.receiver[changedMethodName];
      if (typeof changedMethod == "function") {
        const descriptor = this.valueDescriptorNameMap[name];
        try {
          const value = descriptor.reader(rawValue);
          let oldValue = rawOldValue;
          if (rawOldValue) {
            oldValue = descriptor.reader(rawOldValue);
          }
          changedMethod.call(this.receiver, value, oldValue);
        } catch (error2) {
          if (error2 instanceof TypeError) {
            error2.message = `Stimulus Value "${this.context.identifier}.${descriptor.name}" - ${error2.message}`;
          }
          throw error2;
        }
      }
    }
    get valueDescriptors() {
      const { valueDescriptorMap } = this;
      return Object.keys(valueDescriptorMap).map((key) => valueDescriptorMap[key]);
    }
    get valueDescriptorNameMap() {
      const descriptors = {};
      Object.keys(this.valueDescriptorMap).forEach((key) => {
        const descriptor = this.valueDescriptorMap[key];
        descriptors[descriptor.name] = descriptor;
      });
      return descriptors;
    }
    hasValue(attributeName) {
      const descriptor = this.valueDescriptorNameMap[attributeName];
      const hasMethodName = `has${capitalize(descriptor.name)}`;
      return this.receiver[hasMethodName];
    }
  };
  var TargetObserver = class {
    constructor(context, delegate) {
      this.context = context;
      this.delegate = delegate;
      this.targetsByName = new Multimap();
    }
    start() {
      if (!this.tokenListObserver) {
        this.tokenListObserver = new TokenListObserver(this.element, this.attributeName, this);
        this.tokenListObserver.start();
      }
    }
    stop() {
      if (this.tokenListObserver) {
        this.disconnectAllTargets();
        this.tokenListObserver.stop();
        delete this.tokenListObserver;
      }
    }
    tokenMatched({ element, content: name }) {
      if (this.scope.containsElement(element)) {
        this.connectTarget(element, name);
      }
    }
    tokenUnmatched({ element, content: name }) {
      this.disconnectTarget(element, name);
    }
    connectTarget(element, name) {
      var _a;
      if (!this.targetsByName.has(name, element)) {
        this.targetsByName.add(name, element);
        (_a = this.tokenListObserver) === null || _a === void 0 ? void 0 : _a.pause(() => this.delegate.targetConnected(element, name));
      }
    }
    disconnectTarget(element, name) {
      var _a;
      if (this.targetsByName.has(name, element)) {
        this.targetsByName.delete(name, element);
        (_a = this.tokenListObserver) === null || _a === void 0 ? void 0 : _a.pause(() => this.delegate.targetDisconnected(element, name));
      }
    }
    disconnectAllTargets() {
      for (const name of this.targetsByName.keys) {
        for (const element of this.targetsByName.getValuesForKey(name)) {
          this.disconnectTarget(element, name);
        }
      }
    }
    get attributeName() {
      return `data-${this.context.identifier}-target`;
    }
    get element() {
      return this.context.element;
    }
    get scope() {
      return this.context.scope;
    }
  };
  function readInheritableStaticArrayValues(constructor, propertyName) {
    const ancestors = getAncestorsForConstructor(constructor);
    return Array.from(ancestors.reduce((values, constructor2) => {
      getOwnStaticArrayValues(constructor2, propertyName).forEach((name) => values.add(name));
      return values;
    }, /* @__PURE__ */ new Set()));
  }
  function readInheritableStaticObjectPairs(constructor, propertyName) {
    const ancestors = getAncestorsForConstructor(constructor);
    return ancestors.reduce((pairs, constructor2) => {
      pairs.push(...getOwnStaticObjectPairs(constructor2, propertyName));
      return pairs;
    }, []);
  }
  function getAncestorsForConstructor(constructor) {
    const ancestors = [];
    while (constructor) {
      ancestors.push(constructor);
      constructor = Object.getPrototypeOf(constructor);
    }
    return ancestors.reverse();
  }
  function getOwnStaticArrayValues(constructor, propertyName) {
    const definition = constructor[propertyName];
    return Array.isArray(definition) ? definition : [];
  }
  function getOwnStaticObjectPairs(constructor, propertyName) {
    const definition = constructor[propertyName];
    return definition ? Object.keys(definition).map((key) => [key, definition[key]]) : [];
  }
  var OutletObserver = class {
    constructor(context, delegate) {
      this.context = context;
      this.delegate = delegate;
      this.outletsByName = new Multimap();
      this.outletElementsByName = new Multimap();
      this.selectorObserverMap = /* @__PURE__ */ new Map();
    }
    start() {
      if (this.selectorObserverMap.size === 0) {
        this.outletDefinitions.forEach((outletName) => {
          const selector = this.selector(outletName);
          const details = { outletName };
          if (selector) {
            this.selectorObserverMap.set(outletName, new SelectorObserver(document.body, selector, this, details));
          }
        });
        this.selectorObserverMap.forEach((observer) => observer.start());
      }
      this.dependentContexts.forEach((context) => context.refresh());
    }
    stop() {
      if (this.selectorObserverMap.size > 0) {
        this.disconnectAllOutlets();
        this.selectorObserverMap.forEach((observer) => observer.stop());
        this.selectorObserverMap.clear();
      }
    }
    refresh() {
      this.selectorObserverMap.forEach((observer) => observer.refresh());
    }
    selectorMatched(element, _selector, { outletName }) {
      const outlet = this.getOutlet(element, outletName);
      if (outlet) {
        this.connectOutlet(outlet, element, outletName);
      }
    }
    selectorUnmatched(element, _selector, { outletName }) {
      const outlet = this.getOutletFromMap(element, outletName);
      if (outlet) {
        this.disconnectOutlet(outlet, element, outletName);
      }
    }
    selectorMatchElement(element, { outletName }) {
      return this.hasOutlet(element, outletName) && element.matches(`[${this.context.application.schema.controllerAttribute}~=${outletName}]`);
    }
    connectOutlet(outlet, element, outletName) {
      var _a;
      if (!this.outletElementsByName.has(outletName, element)) {
        this.outletsByName.add(outletName, outlet);
        this.outletElementsByName.add(outletName, element);
        (_a = this.selectorObserverMap.get(outletName)) === null || _a === void 0 ? void 0 : _a.pause(() => this.delegate.outletConnected(outlet, element, outletName));
      }
    }
    disconnectOutlet(outlet, element, outletName) {
      var _a;
      if (this.outletElementsByName.has(outletName, element)) {
        this.outletsByName.delete(outletName, outlet);
        this.outletElementsByName.delete(outletName, element);
        (_a = this.selectorObserverMap.get(outletName)) === null || _a === void 0 ? void 0 : _a.pause(() => this.delegate.outletDisconnected(outlet, element, outletName));
      }
    }
    disconnectAllOutlets() {
      for (const outletName of this.outletElementsByName.keys) {
        for (const element of this.outletElementsByName.getValuesForKey(outletName)) {
          for (const outlet of this.outletsByName.getValuesForKey(outletName)) {
            this.disconnectOutlet(outlet, element, outletName);
          }
        }
      }
    }
    selector(outletName) {
      return this.scope.outlets.getSelectorForOutletName(outletName);
    }
    get outletDependencies() {
      const dependencies = new Multimap();
      this.router.modules.forEach((module) => {
        const constructor = module.definition.controllerConstructor;
        const outlets = readInheritableStaticArrayValues(constructor, "outlets");
        outlets.forEach((outlet) => dependencies.add(outlet, module.identifier));
      });
      return dependencies;
    }
    get outletDefinitions() {
      return this.outletDependencies.getKeysForValue(this.identifier);
    }
    get dependentControllerIdentifiers() {
      return this.outletDependencies.getValuesForKey(this.identifier);
    }
    get dependentContexts() {
      const identifiers = this.dependentControllerIdentifiers;
      return this.router.contexts.filter((context) => identifiers.includes(context.identifier));
    }
    hasOutlet(element, outletName) {
      return !!this.getOutlet(element, outletName) || !!this.getOutletFromMap(element, outletName);
    }
    getOutlet(element, outletName) {
      return this.application.getControllerForElementAndIdentifier(element, outletName);
    }
    getOutletFromMap(element, outletName) {
      return this.outletsByName.getValuesForKey(outletName).find((outlet) => outlet.element === element);
    }
    get scope() {
      return this.context.scope;
    }
    get identifier() {
      return this.context.identifier;
    }
    get application() {
      return this.context.application;
    }
    get router() {
      return this.application.router;
    }
  };
  var Context = class {
    constructor(module, scope) {
      this.logDebugActivity = (functionName, detail = {}) => {
        const { identifier, controller, element } = this;
        detail = Object.assign({ identifier, controller, element }, detail);
        this.application.logDebugActivity(this.identifier, functionName, detail);
      };
      this.module = module;
      this.scope = scope;
      this.controller = new module.controllerConstructor(this);
      this.bindingObserver = new BindingObserver(this, this.dispatcher);
      this.valueObserver = new ValueObserver(this, this.controller);
      this.targetObserver = new TargetObserver(this, this);
      this.outletObserver = new OutletObserver(this, this);
      try {
        this.controller.initialize();
        this.logDebugActivity("initialize");
      } catch (error2) {
        this.handleError(error2, "initializing controller");
      }
    }
    connect() {
      this.bindingObserver.start();
      this.valueObserver.start();
      this.targetObserver.start();
      this.outletObserver.start();
      try {
        this.controller.connect();
        this.logDebugActivity("connect");
      } catch (error2) {
        this.handleError(error2, "connecting controller");
      }
    }
    refresh() {
      this.outletObserver.refresh();
    }
    disconnect() {
      try {
        this.controller.disconnect();
        this.logDebugActivity("disconnect");
      } catch (error2) {
        this.handleError(error2, "disconnecting controller");
      }
      this.outletObserver.stop();
      this.targetObserver.stop();
      this.valueObserver.stop();
      this.bindingObserver.stop();
    }
    get application() {
      return this.module.application;
    }
    get identifier() {
      return this.module.identifier;
    }
    get schema() {
      return this.application.schema;
    }
    get dispatcher() {
      return this.application.dispatcher;
    }
    get element() {
      return this.scope.element;
    }
    get parentElement() {
      return this.element.parentElement;
    }
    handleError(error2, message, detail = {}) {
      const { identifier, controller, element } = this;
      detail = Object.assign({ identifier, controller, element }, detail);
      this.application.handleError(error2, `Error ${message}`, detail);
    }
    targetConnected(element, name) {
      this.invokeControllerMethod(`${name}TargetConnected`, element);
    }
    targetDisconnected(element, name) {
      this.invokeControllerMethod(`${name}TargetDisconnected`, element);
    }
    outletConnected(outlet, element, name) {
      this.invokeControllerMethod(`${namespaceCamelize(name)}OutletConnected`, outlet, element);
    }
    outletDisconnected(outlet, element, name) {
      this.invokeControllerMethod(`${namespaceCamelize(name)}OutletDisconnected`, outlet, element);
    }
    invokeControllerMethod(methodName, ...args) {
      const controller = this.controller;
      if (typeof controller[methodName] == "function") {
        controller[methodName](...args);
      }
    }
  };
  function bless(constructor) {
    return shadow(constructor, getBlessedProperties(constructor));
  }
  function shadow(constructor, properties) {
    const shadowConstructor = extend(constructor);
    const shadowProperties = getShadowProperties(constructor.prototype, properties);
    Object.defineProperties(shadowConstructor.prototype, shadowProperties);
    return shadowConstructor;
  }
  function getBlessedProperties(constructor) {
    const blessings = readInheritableStaticArrayValues(constructor, "blessings");
    return blessings.reduce((blessedProperties, blessing) => {
      const properties = blessing(constructor);
      for (const key in properties) {
        const descriptor = blessedProperties[key] || {};
        blessedProperties[key] = Object.assign(descriptor, properties[key]);
      }
      return blessedProperties;
    }, {});
  }
  function getShadowProperties(prototype, properties) {
    return getOwnKeys(properties).reduce((shadowProperties, key) => {
      const descriptor = getShadowedDescriptor(prototype, properties, key);
      if (descriptor) {
        Object.assign(shadowProperties, { [key]: descriptor });
      }
      return shadowProperties;
    }, {});
  }
  function getShadowedDescriptor(prototype, properties, key) {
    const shadowingDescriptor = Object.getOwnPropertyDescriptor(prototype, key);
    const shadowedByValue = shadowingDescriptor && "value" in shadowingDescriptor;
    if (!shadowedByValue) {
      const descriptor = Object.getOwnPropertyDescriptor(properties, key).value;
      if (shadowingDescriptor) {
        descriptor.get = shadowingDescriptor.get || descriptor.get;
        descriptor.set = shadowingDescriptor.set || descriptor.set;
      }
      return descriptor;
    }
  }
  var getOwnKeys = (() => {
    if (typeof Object.getOwnPropertySymbols == "function") {
      return (object) => [...Object.getOwnPropertyNames(object), ...Object.getOwnPropertySymbols(object)];
    } else {
      return Object.getOwnPropertyNames;
    }
  })();
  var extend = (() => {
    function extendWithReflect(constructor) {
      function extended() {
        return Reflect.construct(constructor, arguments, new.target);
      }
      extended.prototype = Object.create(constructor.prototype, {
        constructor: { value: extended }
      });
      Reflect.setPrototypeOf(extended, constructor);
      return extended;
    }
    function testReflectExtension() {
      const a = function() {
        this.a.call(this);
      };
      const b = extendWithReflect(a);
      b.prototype.a = function() {
      };
      return new b();
    }
    try {
      testReflectExtension();
      return extendWithReflect;
    } catch (error2) {
      return (constructor) => class extended extends constructor {
      };
    }
  })();
  function blessDefinition(definition) {
    return {
      identifier: definition.identifier,
      controllerConstructor: bless(definition.controllerConstructor)
    };
  }
  var Module = class {
    constructor(application, definition) {
      this.application = application;
      this.definition = blessDefinition(definition);
      this.contextsByScope = /* @__PURE__ */ new WeakMap();
      this.connectedContexts = /* @__PURE__ */ new Set();
    }
    get identifier() {
      return this.definition.identifier;
    }
    get controllerConstructor() {
      return this.definition.controllerConstructor;
    }
    get contexts() {
      return Array.from(this.connectedContexts);
    }
    connectContextForScope(scope) {
      const context = this.fetchContextForScope(scope);
      this.connectedContexts.add(context);
      context.connect();
    }
    disconnectContextForScope(scope) {
      const context = this.contextsByScope.get(scope);
      if (context) {
        this.connectedContexts.delete(context);
        context.disconnect();
      }
    }
    fetchContextForScope(scope) {
      let context = this.contextsByScope.get(scope);
      if (!context) {
        context = new Context(this, scope);
        this.contextsByScope.set(scope, context);
      }
      return context;
    }
  };
  var ClassMap = class {
    constructor(scope) {
      this.scope = scope;
    }
    has(name) {
      return this.data.has(this.getDataKey(name));
    }
    get(name) {
      return this.getAll(name)[0];
    }
    getAll(name) {
      const tokenString = this.data.get(this.getDataKey(name)) || "";
      return tokenize(tokenString);
    }
    getAttributeName(name) {
      return this.data.getAttributeNameForKey(this.getDataKey(name));
    }
    getDataKey(name) {
      return `${name}-class`;
    }
    get data() {
      return this.scope.data;
    }
  };
  var DataMap = class {
    constructor(scope) {
      this.scope = scope;
    }
    get element() {
      return this.scope.element;
    }
    get identifier() {
      return this.scope.identifier;
    }
    get(key) {
      const name = this.getAttributeNameForKey(key);
      return this.element.getAttribute(name);
    }
    set(key, value) {
      const name = this.getAttributeNameForKey(key);
      this.element.setAttribute(name, value);
      return this.get(key);
    }
    has(key) {
      const name = this.getAttributeNameForKey(key);
      return this.element.hasAttribute(name);
    }
    delete(key) {
      if (this.has(key)) {
        const name = this.getAttributeNameForKey(key);
        this.element.removeAttribute(name);
        return true;
      } else {
        return false;
      }
    }
    getAttributeNameForKey(key) {
      return `data-${this.identifier}-${dasherize(key)}`;
    }
  };
  var Guide = class {
    constructor(logger) {
      this.warnedKeysByObject = /* @__PURE__ */ new WeakMap();
      this.logger = logger;
    }
    warn(object, key, message) {
      let warnedKeys = this.warnedKeysByObject.get(object);
      if (!warnedKeys) {
        warnedKeys = /* @__PURE__ */ new Set();
        this.warnedKeysByObject.set(object, warnedKeys);
      }
      if (!warnedKeys.has(key)) {
        warnedKeys.add(key);
        this.logger.warn(message, object);
      }
    }
  };
  function attributeValueContainsToken(attributeName, token) {
    return `[${attributeName}~="${token}"]`;
  }
  var TargetSet = class {
    constructor(scope) {
      this.scope = scope;
    }
    get element() {
      return this.scope.element;
    }
    get identifier() {
      return this.scope.identifier;
    }
    get schema() {
      return this.scope.schema;
    }
    has(targetName) {
      return this.find(targetName) != null;
    }
    find(...targetNames) {
      return targetNames.reduce((target, targetName) => target || this.findTarget(targetName) || this.findLegacyTarget(targetName), void 0);
    }
    findAll(...targetNames) {
      return targetNames.reduce((targets, targetName) => [
        ...targets,
        ...this.findAllTargets(targetName),
        ...this.findAllLegacyTargets(targetName)
      ], []);
    }
    findTarget(targetName) {
      const selector = this.getSelectorForTargetName(targetName);
      return this.scope.findElement(selector);
    }
    findAllTargets(targetName) {
      const selector = this.getSelectorForTargetName(targetName);
      return this.scope.findAllElements(selector);
    }
    getSelectorForTargetName(targetName) {
      const attributeName = this.schema.targetAttributeForScope(this.identifier);
      return attributeValueContainsToken(attributeName, targetName);
    }
    findLegacyTarget(targetName) {
      const selector = this.getLegacySelectorForTargetName(targetName);
      return this.deprecate(this.scope.findElement(selector), targetName);
    }
    findAllLegacyTargets(targetName) {
      const selector = this.getLegacySelectorForTargetName(targetName);
      return this.scope.findAllElements(selector).map((element) => this.deprecate(element, targetName));
    }
    getLegacySelectorForTargetName(targetName) {
      const targetDescriptor = `${this.identifier}.${targetName}`;
      return attributeValueContainsToken(this.schema.targetAttribute, targetDescriptor);
    }
    deprecate(element, targetName) {
      if (element) {
        const { identifier } = this;
        const attributeName = this.schema.targetAttribute;
        const revisedAttributeName = this.schema.targetAttributeForScope(identifier);
        this.guide.warn(element, `target:${targetName}`, `Please replace ${attributeName}="${identifier}.${targetName}" with ${revisedAttributeName}="${targetName}". The ${attributeName} attribute is deprecated and will be removed in a future version of Stimulus.`);
      }
      return element;
    }
    get guide() {
      return this.scope.guide;
    }
  };
  var OutletSet = class {
    constructor(scope, controllerElement) {
      this.scope = scope;
      this.controllerElement = controllerElement;
    }
    get element() {
      return this.scope.element;
    }
    get identifier() {
      return this.scope.identifier;
    }
    get schema() {
      return this.scope.schema;
    }
    has(outletName) {
      return this.find(outletName) != null;
    }
    find(...outletNames) {
      return outletNames.reduce((outlet, outletName) => outlet || this.findOutlet(outletName), void 0);
    }
    findAll(...outletNames) {
      return outletNames.reduce((outlets, outletName) => [...outlets, ...this.findAllOutlets(outletName)], []);
    }
    getSelectorForOutletName(outletName) {
      const attributeName = this.schema.outletAttributeForScope(this.identifier, outletName);
      return this.controllerElement.getAttribute(attributeName);
    }
    findOutlet(outletName) {
      const selector = this.getSelectorForOutletName(outletName);
      if (selector)
        return this.findElement(selector, outletName);
    }
    findAllOutlets(outletName) {
      const selector = this.getSelectorForOutletName(outletName);
      return selector ? this.findAllElements(selector, outletName) : [];
    }
    findElement(selector, outletName) {
      const elements = this.scope.queryElements(selector);
      return elements.filter((element) => this.matchesElement(element, selector, outletName))[0];
    }
    findAllElements(selector, outletName) {
      const elements = this.scope.queryElements(selector);
      return elements.filter((element) => this.matchesElement(element, selector, outletName));
    }
    matchesElement(element, selector, outletName) {
      const controllerAttribute = element.getAttribute(this.scope.schema.controllerAttribute) || "";
      return element.matches(selector) && controllerAttribute.split(" ").includes(outletName);
    }
  };
  var Scope = class _Scope {
    constructor(schema, element, identifier, logger) {
      this.targets = new TargetSet(this);
      this.classes = new ClassMap(this);
      this.data = new DataMap(this);
      this.containsElement = (element2) => {
        return element2.closest(this.controllerSelector) === this.element;
      };
      this.schema = schema;
      this.element = element;
      this.identifier = identifier;
      this.guide = new Guide(logger);
      this.outlets = new OutletSet(this.documentScope, element);
    }
    findElement(selector) {
      return this.element.matches(selector) ? this.element : this.queryElements(selector).find(this.containsElement);
    }
    findAllElements(selector) {
      return [
        ...this.element.matches(selector) ? [this.element] : [],
        ...this.queryElements(selector).filter(this.containsElement)
      ];
    }
    queryElements(selector) {
      return Array.from(this.element.querySelectorAll(selector));
    }
    get controllerSelector() {
      return attributeValueContainsToken(this.schema.controllerAttribute, this.identifier);
    }
    get isDocumentScope() {
      return this.element === document.documentElement;
    }
    get documentScope() {
      return this.isDocumentScope ? this : new _Scope(this.schema, document.documentElement, this.identifier, this.guide.logger);
    }
  };
  var ScopeObserver = class {
    constructor(element, schema, delegate) {
      this.element = element;
      this.schema = schema;
      this.delegate = delegate;
      this.valueListObserver = new ValueListObserver(this.element, this.controllerAttribute, this);
      this.scopesByIdentifierByElement = /* @__PURE__ */ new WeakMap();
      this.scopeReferenceCounts = /* @__PURE__ */ new WeakMap();
    }
    start() {
      this.valueListObserver.start();
    }
    stop() {
      this.valueListObserver.stop();
    }
    get controllerAttribute() {
      return this.schema.controllerAttribute;
    }
    parseValueForToken(token) {
      const { element, content: identifier } = token;
      const scopesByIdentifier = this.fetchScopesByIdentifierForElement(element);
      let scope = scopesByIdentifier.get(identifier);
      if (!scope) {
        scope = this.delegate.createScopeForElementAndIdentifier(element, identifier);
        scopesByIdentifier.set(identifier, scope);
      }
      return scope;
    }
    elementMatchedValue(element, value) {
      const referenceCount = (this.scopeReferenceCounts.get(value) || 0) + 1;
      this.scopeReferenceCounts.set(value, referenceCount);
      if (referenceCount == 1) {
        this.delegate.scopeConnected(value);
      }
    }
    elementUnmatchedValue(element, value) {
      const referenceCount = this.scopeReferenceCounts.get(value);
      if (referenceCount) {
        this.scopeReferenceCounts.set(value, referenceCount - 1);
        if (referenceCount == 1) {
          this.delegate.scopeDisconnected(value);
        }
      }
    }
    fetchScopesByIdentifierForElement(element) {
      let scopesByIdentifier = this.scopesByIdentifierByElement.get(element);
      if (!scopesByIdentifier) {
        scopesByIdentifier = /* @__PURE__ */ new Map();
        this.scopesByIdentifierByElement.set(element, scopesByIdentifier);
      }
      return scopesByIdentifier;
    }
  };
  var Router = class {
    constructor(application) {
      this.application = application;
      this.scopeObserver = new ScopeObserver(this.element, this.schema, this);
      this.scopesByIdentifier = new Multimap();
      this.modulesByIdentifier = /* @__PURE__ */ new Map();
    }
    get element() {
      return this.application.element;
    }
    get schema() {
      return this.application.schema;
    }
    get logger() {
      return this.application.logger;
    }
    get controllerAttribute() {
      return this.schema.controllerAttribute;
    }
    get modules() {
      return Array.from(this.modulesByIdentifier.values());
    }
    get contexts() {
      return this.modules.reduce((contexts, module) => contexts.concat(module.contexts), []);
    }
    start() {
      this.scopeObserver.start();
    }
    stop() {
      this.scopeObserver.stop();
    }
    loadDefinition(definition) {
      this.unloadIdentifier(definition.identifier);
      const module = new Module(this.application, definition);
      this.connectModule(module);
      const afterLoad = definition.controllerConstructor.afterLoad;
      if (afterLoad) {
        afterLoad(definition.identifier, this.application);
      }
    }
    unloadIdentifier(identifier) {
      const module = this.modulesByIdentifier.get(identifier);
      if (module) {
        this.disconnectModule(module);
      }
    }
    getContextForElementAndIdentifier(element, identifier) {
      const module = this.modulesByIdentifier.get(identifier);
      if (module) {
        return module.contexts.find((context) => context.element == element);
      }
    }
    handleError(error2, message, detail) {
      this.application.handleError(error2, message, detail);
    }
    createScopeForElementAndIdentifier(element, identifier) {
      return new Scope(this.schema, element, identifier, this.logger);
    }
    scopeConnected(scope) {
      this.scopesByIdentifier.add(scope.identifier, scope);
      const module = this.modulesByIdentifier.get(scope.identifier);
      if (module) {
        module.connectContextForScope(scope);
      }
    }
    scopeDisconnected(scope) {
      this.scopesByIdentifier.delete(scope.identifier, scope);
      const module = this.modulesByIdentifier.get(scope.identifier);
      if (module) {
        module.disconnectContextForScope(scope);
      }
    }
    connectModule(module) {
      this.modulesByIdentifier.set(module.identifier, module);
      const scopes = this.scopesByIdentifier.getValuesForKey(module.identifier);
      scopes.forEach((scope) => module.connectContextForScope(scope));
    }
    disconnectModule(module) {
      this.modulesByIdentifier.delete(module.identifier);
      const scopes = this.scopesByIdentifier.getValuesForKey(module.identifier);
      scopes.forEach((scope) => module.disconnectContextForScope(scope));
    }
  };
  var defaultSchema = {
    controllerAttribute: "data-controller",
    actionAttribute: "data-action",
    targetAttribute: "data-target",
    targetAttributeForScope: (identifier) => `data-${identifier}-target`,
    outletAttributeForScope: (identifier, outlet) => `data-${identifier}-${outlet}-outlet`,
    keyMappings: Object.assign(Object.assign({ enter: "Enter", tab: "Tab", esc: "Escape", space: " ", up: "ArrowUp", down: "ArrowDown", left: "ArrowLeft", right: "ArrowRight", home: "Home", end: "End" }, objectFromEntries("abcdefghijklmnopqrstuvwxyz".split("").map((c) => [c, c]))), objectFromEntries("0123456789".split("").map((n) => [n, n])))
  };
  function objectFromEntries(array) {
    return array.reduce((memo, [k, v]) => Object.assign(Object.assign({}, memo), { [k]: v }), {});
  }
  var Application = class {
    constructor(element = document.documentElement, schema = defaultSchema) {
      this.logger = console;
      this.debug = false;
      this.logDebugActivity = (identifier, functionName, detail = {}) => {
        if (this.debug) {
          this.logFormattedMessage(identifier, functionName, detail);
        }
      };
      this.element = element;
      this.schema = schema;
      this.dispatcher = new Dispatcher(this);
      this.router = new Router(this);
      this.actionDescriptorFilters = Object.assign({}, defaultActionDescriptorFilters);
    }
    static start(element, schema) {
      const application = new this(element, schema);
      application.start();
      return application;
    }
    async start() {
      await domReady();
      this.logDebugActivity("application", "starting");
      this.dispatcher.start();
      this.router.start();
      this.logDebugActivity("application", "start");
    }
    stop() {
      this.logDebugActivity("application", "stopping");
      this.dispatcher.stop();
      this.router.stop();
      this.logDebugActivity("application", "stop");
    }
    register(identifier, controllerConstructor) {
      this.load({ identifier, controllerConstructor });
    }
    registerActionOption(name, filter) {
      this.actionDescriptorFilters[name] = filter;
    }
    load(head, ...rest) {
      const definitions = Array.isArray(head) ? head : [head, ...rest];
      definitions.forEach((definition) => {
        if (definition.controllerConstructor.shouldLoad) {
          this.router.loadDefinition(definition);
        }
      });
    }
    unload(head, ...rest) {
      const identifiers = Array.isArray(head) ? head : [head, ...rest];
      identifiers.forEach((identifier) => this.router.unloadIdentifier(identifier));
    }
    get controllers() {
      return this.router.contexts.map((context) => context.controller);
    }
    getControllerForElementAndIdentifier(element, identifier) {
      const context = this.router.getContextForElementAndIdentifier(element, identifier);
      return context ? context.controller : null;
    }
    handleError(error2, message, detail) {
      var _a;
      this.logger.error(`%s

%o

%o`, message, error2, detail);
      (_a = window.onerror) === null || _a === void 0 ? void 0 : _a.call(window, message, "", 0, 0, error2);
    }
    logFormattedMessage(identifier, functionName, detail = {}) {
      detail = Object.assign({ application: this }, detail);
      this.logger.groupCollapsed(`${identifier} #${functionName}`);
      this.logger.log("details:", Object.assign({}, detail));
      this.logger.groupEnd();
    }
  };
  function domReady() {
    return new Promise((resolve) => {
      if (document.readyState == "loading") {
        document.addEventListener("DOMContentLoaded", () => resolve());
      } else {
        resolve();
      }
    });
  }
  function ClassPropertiesBlessing(constructor) {
    const classes = readInheritableStaticArrayValues(constructor, "classes");
    return classes.reduce((properties, classDefinition) => {
      return Object.assign(properties, propertiesForClassDefinition(classDefinition));
    }, {});
  }
  function propertiesForClassDefinition(key) {
    return {
      [`${key}Class`]: {
        get() {
          const { classes } = this;
          if (classes.has(key)) {
            return classes.get(key);
          } else {
            const attribute = classes.getAttributeName(key);
            throw new Error(`Missing attribute "${attribute}"`);
          }
        }
      },
      [`${key}Classes`]: {
        get() {
          return this.classes.getAll(key);
        }
      },
      [`has${capitalize(key)}Class`]: {
        get() {
          return this.classes.has(key);
        }
      }
    };
  }
  function OutletPropertiesBlessing(constructor) {
    const outlets = readInheritableStaticArrayValues(constructor, "outlets");
    return outlets.reduce((properties, outletDefinition) => {
      return Object.assign(properties, propertiesForOutletDefinition(outletDefinition));
    }, {});
  }
  function propertiesForOutletDefinition(name) {
    const camelizedName = namespaceCamelize(name);
    return {
      [`${camelizedName}Outlet`]: {
        get() {
          const outlet = this.outlets.find(name);
          if (outlet) {
            const outletController = this.application.getControllerForElementAndIdentifier(outlet, name);
            if (outletController) {
              return outletController;
            } else {
              throw new Error(`Missing "data-controller=${name}" attribute on outlet element for "${this.identifier}" controller`);
            }
          }
          throw new Error(`Missing outlet element "${name}" for "${this.identifier}" controller`);
        }
      },
      [`${camelizedName}Outlets`]: {
        get() {
          const outlets = this.outlets.findAll(name);
          if (outlets.length > 0) {
            return outlets.map((outlet) => {
              const controller = this.application.getControllerForElementAndIdentifier(outlet, name);
              if (controller) {
                return controller;
              } else {
                console.warn(`The provided outlet element is missing the outlet controller "${name}" for "${this.identifier}"`, outlet);
              }
            }).filter((controller) => controller);
          }
          return [];
        }
      },
      [`${camelizedName}OutletElement`]: {
        get() {
          const outlet = this.outlets.find(name);
          if (outlet) {
            return outlet;
          } else {
            throw new Error(`Missing outlet element "${name}" for "${this.identifier}" controller`);
          }
        }
      },
      [`${camelizedName}OutletElements`]: {
        get() {
          return this.outlets.findAll(name);
        }
      },
      [`has${capitalize(camelizedName)}Outlet`]: {
        get() {
          return this.outlets.has(name);
        }
      }
    };
  }
  function TargetPropertiesBlessing(constructor) {
    const targets = readInheritableStaticArrayValues(constructor, "targets");
    return targets.reduce((properties, targetDefinition) => {
      return Object.assign(properties, propertiesForTargetDefinition(targetDefinition));
    }, {});
  }
  function propertiesForTargetDefinition(name) {
    return {
      [`${name}Target`]: {
        get() {
          const target = this.targets.find(name);
          if (target) {
            return target;
          } else {
            throw new Error(`Missing target element "${name}" for "${this.identifier}" controller`);
          }
        }
      },
      [`${name}Targets`]: {
        get() {
          return this.targets.findAll(name);
        }
      },
      [`has${capitalize(name)}Target`]: {
        get() {
          return this.targets.has(name);
        }
      }
    };
  }
  function ValuePropertiesBlessing(constructor) {
    const valueDefinitionPairs = readInheritableStaticObjectPairs(constructor, "values");
    const propertyDescriptorMap = {
      valueDescriptorMap: {
        get() {
          return valueDefinitionPairs.reduce((result, valueDefinitionPair) => {
            const valueDescriptor = parseValueDefinitionPair(valueDefinitionPair, this.identifier);
            const attributeName = this.data.getAttributeNameForKey(valueDescriptor.key);
            return Object.assign(result, { [attributeName]: valueDescriptor });
          }, {});
        }
      }
    };
    return valueDefinitionPairs.reduce((properties, valueDefinitionPair) => {
      return Object.assign(properties, propertiesForValueDefinitionPair(valueDefinitionPair));
    }, propertyDescriptorMap);
  }
  function propertiesForValueDefinitionPair(valueDefinitionPair, controller) {
    const definition = parseValueDefinitionPair(valueDefinitionPair, controller);
    const { key, name, reader: read2, writer: write2 } = definition;
    return {
      [name]: {
        get() {
          const value = this.data.get(key);
          if (value !== null) {
            return read2(value);
          } else {
            return definition.defaultValue;
          }
        },
        set(value) {
          if (value === void 0) {
            this.data.delete(key);
          } else {
            this.data.set(key, write2(value));
          }
        }
      },
      [`has${capitalize(name)}`]: {
        get() {
          return this.data.has(key) || definition.hasCustomDefaultValue;
        }
      }
    };
  }
  function parseValueDefinitionPair([token, typeDefinition], controller) {
    return valueDescriptorForTokenAndTypeDefinition({
      controller,
      token,
      typeDefinition
    });
  }
  function parseValueTypeConstant(constant) {
    switch (constant) {
      case Array:
        return "array";
      case Boolean:
        return "boolean";
      case Number:
        return "number";
      case Object:
        return "object";
      case String:
        return "string";
    }
  }
  function parseValueTypeDefault(defaultValue) {
    switch (typeof defaultValue) {
      case "boolean":
        return "boolean";
      case "number":
        return "number";
      case "string":
        return "string";
    }
    if (Array.isArray(defaultValue))
      return "array";
    if (Object.prototype.toString.call(defaultValue) === "[object Object]")
      return "object";
  }
  function parseValueTypeObject(payload) {
    const typeFromObject = parseValueTypeConstant(payload.typeObject.type);
    if (!typeFromObject)
      return;
    const defaultValueType = parseValueTypeDefault(payload.typeObject.default);
    if (typeFromObject !== defaultValueType) {
      const propertyPath = payload.controller ? `${payload.controller}.${payload.token}` : payload.token;
      throw new Error(`The specified default value for the Stimulus Value "${propertyPath}" must match the defined type "${typeFromObject}". The provided default value of "${payload.typeObject.default}" is of type "${defaultValueType}".`);
    }
    return typeFromObject;
  }
  function parseValueTypeDefinition(payload) {
    const typeFromObject = parseValueTypeObject({
      controller: payload.controller,
      token: payload.token,
      typeObject: payload.typeDefinition
    });
    const typeFromDefaultValue = parseValueTypeDefault(payload.typeDefinition);
    const typeFromConstant = parseValueTypeConstant(payload.typeDefinition);
    const type = typeFromObject || typeFromDefaultValue || typeFromConstant;
    if (type)
      return type;
    const propertyPath = payload.controller ? `${payload.controller}.${payload.typeDefinition}` : payload.token;
    throw new Error(`Unknown value type "${propertyPath}" for "${payload.token}" value`);
  }
  function defaultValueForDefinition(typeDefinition) {
    const constant = parseValueTypeConstant(typeDefinition);
    if (constant)
      return defaultValuesByType[constant];
    const defaultValue = typeDefinition.default;
    if (defaultValue !== void 0)
      return defaultValue;
    return typeDefinition;
  }
  function valueDescriptorForTokenAndTypeDefinition(payload) {
    const key = `${dasherize(payload.token)}-value`;
    const type = parseValueTypeDefinition(payload);
    return {
      type,
      key,
      name: camelize(key),
      get defaultValue() {
        return defaultValueForDefinition(payload.typeDefinition);
      },
      get hasCustomDefaultValue() {
        return parseValueTypeDefault(payload.typeDefinition) !== void 0;
      },
      reader: readers[type],
      writer: writers[type] || writers.default
    };
  }
  var defaultValuesByType = {
    get array() {
      return [];
    },
    boolean: false,
    number: 0,
    get object() {
      return {};
    },
    string: ""
  };
  var readers = {
    array(value) {
      const array = JSON.parse(value);
      if (!Array.isArray(array)) {
        throw new TypeError(`expected value of type "array" but instead got value "${value}" of type "${parseValueTypeDefault(array)}"`);
      }
      return array;
    },
    boolean(value) {
      return !(value == "0" || String(value).toLowerCase() == "false");
    },
    number(value) {
      return Number(value);
    },
    object(value) {
      const object = JSON.parse(value);
      if (object === null || typeof object != "object" || Array.isArray(object)) {
        throw new TypeError(`expected value of type "object" but instead got value "${value}" of type "${parseValueTypeDefault(object)}"`);
      }
      return object;
    },
    string(value) {
      return value;
    }
  };
  var writers = {
    default: writeString,
    array: writeJSON,
    object: writeJSON
  };
  function writeJSON(value) {
    return JSON.stringify(value);
  }
  function writeString(value) {
    return `${value}`;
  }
  var Controller = class {
    constructor(context) {
      this.context = context;
    }
    static get shouldLoad() {
      return true;
    }
    static afterLoad(_identifier, _application) {
      return;
    }
    get application() {
      return this.context.application;
    }
    get scope() {
      return this.context.scope;
    }
    get element() {
      return this.scope.element;
    }
    get identifier() {
      return this.scope.identifier;
    }
    get targets() {
      return this.scope.targets;
    }
    get outlets() {
      return this.scope.outlets;
    }
    get classes() {
      return this.scope.classes;
    }
    get data() {
      return this.scope.data;
    }
    initialize() {
    }
    connect() {
    }
    disconnect() {
    }
    dispatch(eventName, { target = this.element, detail = {}, prefix = this.identifier, bubbles = true, cancelable = true } = {}) {
      const type = prefix ? `${prefix}:${eventName}` : eventName;
      const event = new CustomEvent(type, { detail, bubbles, cancelable });
      target.dispatchEvent(event);
      return event;
    }
  };
  Controller.blessings = [
    ClassPropertiesBlessing,
    TargetPropertiesBlessing,
    ValuePropertiesBlessing,
    OutletPropertiesBlessing
  ];
  Controller.targets = [];
  Controller.outlets = [];
  Controller.values = {};

  // node_modules/flowbite/lib/esm/dom/events.js
  var Events = (
    /** @class */
    function() {
      function Events2(eventType, eventFunctions) {
        if (eventFunctions === void 0) {
          eventFunctions = [];
        }
        this._eventType = eventType;
        this._eventFunctions = eventFunctions;
      }
      Events2.prototype.init = function() {
        var _this = this;
        this._eventFunctions.forEach(function(eventFunction) {
          if (typeof window !== "undefined") {
            window.addEventListener(_this._eventType, eventFunction);
          }
        });
      };
      return Events2;
    }()
  );
  var events_default = Events;

  // node_modules/flowbite/lib/esm/components/accordion/index.js
  var __assign = function() {
    __assign = Object.assign || function(t) {
      for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s)
          if (Object.prototype.hasOwnProperty.call(s, p))
            t[p] = s[p];
      }
      return t;
    };
    return __assign.apply(this, arguments);
  };
  var Default = {
    alwaysOpen: false,
    activeClasses: "bg-gray-100 dark:bg-gray-800 text-gray-900 dark:text-white",
    inactiveClasses: "text-gray-500 dark:text-gray-400",
    onOpen: function() {
    },
    onClose: function() {
    },
    onToggle: function() {
    }
  };
  var Accordion = (
    /** @class */
    function() {
      function Accordion2(items, options) {
        if (items === void 0) {
          items = [];
        }
        if (options === void 0) {
          options = Default;
        }
        this._items = items;
        this._options = __assign(__assign({}, Default), options);
        this._init();
      }
      Accordion2.prototype._init = function() {
        var _this = this;
        if (this._items.length) {
          this._items.map(function(item) {
            if (item.active) {
              _this.open(item.id);
            }
            item.triggerEl.addEventListener("click", function() {
              _this.toggle(item.id);
            });
          });
        }
      };
      Accordion2.prototype.getItem = function(id) {
        return this._items.filter(function(item) {
          return item.id === id;
        })[0];
      };
      Accordion2.prototype.open = function(id) {
        var _a, _b;
        var _this = this;
        var item = this.getItem(id);
        if (!this._options.alwaysOpen) {
          this._items.map(function(i) {
            var _a2, _b2;
            if (i !== item) {
              (_a2 = i.triggerEl.classList).remove.apply(_a2, _this._options.activeClasses.split(" "));
              (_b2 = i.triggerEl.classList).add.apply(_b2, _this._options.inactiveClasses.split(" "));
              i.targetEl.classList.add("hidden");
              i.triggerEl.setAttribute("aria-expanded", "false");
              i.active = false;
              if (i.iconEl) {
                i.iconEl.classList.remove("rotate-180");
              }
            }
          });
        }
        (_a = item.triggerEl.classList).add.apply(_a, this._options.activeClasses.split(" "));
        (_b = item.triggerEl.classList).remove.apply(_b, this._options.inactiveClasses.split(" "));
        item.triggerEl.setAttribute("aria-expanded", "true");
        item.targetEl.classList.remove("hidden");
        item.active = true;
        if (item.iconEl) {
          item.iconEl.classList.add("rotate-180");
        }
        this._options.onOpen(this, item);
      };
      Accordion2.prototype.toggle = function(id) {
        var item = this.getItem(id);
        if (item.active) {
          this.close(id);
        } else {
          this.open(id);
        }
        this._options.onToggle(this, item);
      };
      Accordion2.prototype.close = function(id) {
        var _a, _b;
        var item = this.getItem(id);
        (_a = item.triggerEl.classList).remove.apply(_a, this._options.activeClasses.split(" "));
        (_b = item.triggerEl.classList).add.apply(_b, this._options.inactiveClasses.split(" "));
        item.targetEl.classList.add("hidden");
        item.triggerEl.setAttribute("aria-expanded", "false");
        item.active = false;
        if (item.iconEl) {
          item.iconEl.classList.remove("rotate-180");
        }
        this._options.onClose(this, item);
      };
      return Accordion2;
    }()
  );
  function initAccordions() {
    document.querySelectorAll("[data-accordion]").forEach(function($accordionEl) {
      var alwaysOpen = $accordionEl.getAttribute("data-accordion");
      var activeClasses = $accordionEl.getAttribute("data-active-classes");
      var inactiveClasses = $accordionEl.getAttribute("data-inactive-classes");
      var items = [];
      $accordionEl.querySelectorAll("[data-accordion-target]").forEach(function($triggerEl) {
        if ($triggerEl.closest("[data-accordion]") === $accordionEl) {
          var item = {
            id: $triggerEl.getAttribute("data-accordion-target"),
            triggerEl: $triggerEl,
            targetEl: document.querySelector($triggerEl.getAttribute("data-accordion-target")),
            iconEl: $triggerEl.querySelector("[data-accordion-icon]"),
            active: $triggerEl.getAttribute("aria-expanded") === "true" ? true : false
          };
          items.push(item);
        }
      });
      new Accordion(items, {
        alwaysOpen: alwaysOpen === "open" ? true : false,
        activeClasses: activeClasses ? activeClasses : Default.activeClasses,
        inactiveClasses: inactiveClasses ? inactiveClasses : Default.inactiveClasses
      });
    });
  }
  if (typeof window !== "undefined") {
    window.Accordion = Accordion;
    window.initAccordions = initAccordions;
  }

  // node_modules/flowbite/lib/esm/components/collapse/index.js
  var __assign2 = function() {
    __assign2 = Object.assign || function(t) {
      for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s)
          if (Object.prototype.hasOwnProperty.call(s, p))
            t[p] = s[p];
      }
      return t;
    };
    return __assign2.apply(this, arguments);
  };
  var Default2 = {
    onCollapse: function() {
    },
    onExpand: function() {
    },
    onToggle: function() {
    }
  };
  var Collapse = (
    /** @class */
    function() {
      function Collapse2(targetEl, triggerEl, options) {
        if (targetEl === void 0) {
          targetEl = null;
        }
        if (triggerEl === void 0) {
          triggerEl = null;
        }
        if (options === void 0) {
          options = Default2;
        }
        this._targetEl = targetEl;
        this._triggerEl = triggerEl;
        this._options = __assign2(__assign2({}, Default2), options);
        this._visible = false;
        this._init();
      }
      Collapse2.prototype._init = function() {
        var _this = this;
        if (this._triggerEl) {
          if (this._triggerEl.hasAttribute("aria-expanded")) {
            this._visible = this._triggerEl.getAttribute("aria-expanded") === "true";
          } else {
            this._visible = !this._targetEl.classList.contains("hidden");
          }
          this._triggerEl.addEventListener("click", function() {
            _this.toggle();
          });
        }
      };
      Collapse2.prototype.collapse = function() {
        this._targetEl.classList.add("hidden");
        if (this._triggerEl) {
          this._triggerEl.setAttribute("aria-expanded", "false");
        }
        this._visible = false;
        this._options.onCollapse(this);
      };
      Collapse2.prototype.expand = function() {
        this._targetEl.classList.remove("hidden");
        if (this._triggerEl) {
          this._triggerEl.setAttribute("aria-expanded", "true");
        }
        this._visible = true;
        this._options.onExpand(this);
      };
      Collapse2.prototype.toggle = function() {
        if (this._visible) {
          this.collapse();
        } else {
          this.expand();
        }
        this._options.onToggle(this);
      };
      return Collapse2;
    }()
  );
  function initCollapses() {
    document.querySelectorAll("[data-collapse-toggle]").forEach(function($triggerEl) {
      var targetId = $triggerEl.getAttribute("data-collapse-toggle");
      var $targetEl = document.getElementById(targetId);
      if ($targetEl) {
        new Collapse($targetEl, $triggerEl);
      } else {
        console.error('The target element with id "'.concat(targetId, '" does not exist. Please check the data-collapse-toggle attribute.'));
      }
    });
  }
  if (typeof window !== "undefined") {
    window.Collapse = Collapse;
    window.initCollapses = initCollapses;
  }

  // node_modules/flowbite/lib/esm/components/carousel/index.js
  var __assign3 = function() {
    __assign3 = Object.assign || function(t) {
      for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s)
          if (Object.prototype.hasOwnProperty.call(s, p))
            t[p] = s[p];
      }
      return t;
    };
    return __assign3.apply(this, arguments);
  };
  var Default3 = {
    defaultPosition: 0,
    indicators: {
      items: [],
      activeClasses: "bg-white dark:bg-gray-800",
      inactiveClasses: "bg-white/50 dark:bg-gray-800/50 hover:bg-white dark:hover:bg-gray-800"
    },
    interval: 3e3,
    onNext: function() {
    },
    onPrev: function() {
    },
    onChange: function() {
    }
  };
  var Carousel = (
    /** @class */
    function() {
      function Carousel2(items, options) {
        if (items === void 0) {
          items = [];
        }
        if (options === void 0) {
          options = Default3;
        }
        this._items = items;
        this._options = __assign3(__assign3(__assign3({}, Default3), options), { indicators: __assign3(__assign3({}, Default3.indicators), options.indicators) });
        this._activeItem = this.getItem(this._options.defaultPosition);
        this._indicators = this._options.indicators.items;
        this._intervalDuration = this._options.interval;
        this._intervalInstance = null;
        this._init();
      }
      Carousel2.prototype._init = function() {
        var _this = this;
        this._items.map(function(item) {
          item.el.classList.add("absolute", "inset-0", "transition-transform", "transform");
        });
        if (this._getActiveItem()) {
          this.slideTo(this._getActiveItem().position);
        } else {
          this.slideTo(0);
        }
        this._indicators.map(function(indicator, position) {
          indicator.el.addEventListener("click", function() {
            _this.slideTo(position);
          });
        });
      };
      Carousel2.prototype.getItem = function(position) {
        return this._items[position];
      };
      Carousel2.prototype.slideTo = function(position) {
        var nextItem = this._items[position];
        var rotationItems = {
          left: nextItem.position === 0 ? this._items[this._items.length - 1] : this._items[nextItem.position - 1],
          middle: nextItem,
          right: nextItem.position === this._items.length - 1 ? this._items[0] : this._items[nextItem.position + 1]
        };
        this._rotate(rotationItems);
        this._setActiveItem(nextItem);
        if (this._intervalInstance) {
          this.pause();
          this.cycle();
        }
        this._options.onChange(this);
      };
      Carousel2.prototype.next = function() {
        var activeItem = this._getActiveItem();
        var nextItem = null;
        if (activeItem.position === this._items.length - 1) {
          nextItem = this._items[0];
        } else {
          nextItem = this._items[activeItem.position + 1];
        }
        this.slideTo(nextItem.position);
        this._options.onNext(this);
      };
      Carousel2.prototype.prev = function() {
        var activeItem = this._getActiveItem();
        var prevItem = null;
        if (activeItem.position === 0) {
          prevItem = this._items[this._items.length - 1];
        } else {
          prevItem = this._items[activeItem.position - 1];
        }
        this.slideTo(prevItem.position);
        this._options.onPrev(this);
      };
      Carousel2.prototype._rotate = function(rotationItems) {
        this._items.map(function(item) {
          item.el.classList.add("hidden");
        });
        rotationItems.left.el.classList.remove("-translate-x-full", "translate-x-full", "translate-x-0", "hidden", "z-20");
        rotationItems.left.el.classList.add("-translate-x-full", "z-10");
        rotationItems.middle.el.classList.remove("-translate-x-full", "translate-x-full", "translate-x-0", "hidden", "z-10");
        rotationItems.middle.el.classList.add("translate-x-0", "z-20");
        rotationItems.right.el.classList.remove("-translate-x-full", "translate-x-full", "translate-x-0", "hidden", "z-20");
        rotationItems.right.el.classList.add("translate-x-full", "z-10");
      };
      Carousel2.prototype.cycle = function() {
        var _this = this;
        if (typeof window !== "undefined") {
          this._intervalInstance = window.setInterval(function() {
            _this.next();
          }, this._intervalDuration);
        }
      };
      Carousel2.prototype.pause = function() {
        clearInterval(this._intervalInstance);
      };
      Carousel2.prototype._getActiveItem = function() {
        return this._activeItem;
      };
      Carousel2.prototype._setActiveItem = function(item) {
        var _a, _b;
        var _this = this;
        this._activeItem = item;
        var position = item.position;
        if (this._indicators.length) {
          this._indicators.map(function(indicator) {
            var _a2, _b2;
            indicator.el.setAttribute("aria-current", "false");
            (_a2 = indicator.el.classList).remove.apply(_a2, _this._options.indicators.activeClasses.split(" "));
            (_b2 = indicator.el.classList).add.apply(_b2, _this._options.indicators.inactiveClasses.split(" "));
          });
          (_a = this._indicators[position].el.classList).add.apply(_a, this._options.indicators.activeClasses.split(" "));
          (_b = this._indicators[position].el.classList).remove.apply(_b, this._options.indicators.inactiveClasses.split(" "));
          this._indicators[position].el.setAttribute("aria-current", "true");
        }
      };
      return Carousel2;
    }()
  );
  function initCarousels() {
    document.querySelectorAll("[data-carousel]").forEach(function($carouselEl) {
      var interval = $carouselEl.getAttribute("data-carousel-interval");
      var slide = $carouselEl.getAttribute("data-carousel") === "slide" ? true : false;
      var items = [];
      var defaultPosition = 0;
      if ($carouselEl.querySelectorAll("[data-carousel-item]").length) {
        Array.from($carouselEl.querySelectorAll("[data-carousel-item]")).map(function($carouselItemEl, position) {
          items.push({
            position,
            el: $carouselItemEl
          });
          if ($carouselItemEl.getAttribute("data-carousel-item") === "active") {
            defaultPosition = position;
          }
        });
      }
      var indicators = [];
      if ($carouselEl.querySelectorAll("[data-carousel-slide-to]").length) {
        Array.from($carouselEl.querySelectorAll("[data-carousel-slide-to]")).map(function($indicatorEl) {
          indicators.push({
            position: parseInt($indicatorEl.getAttribute("data-carousel-slide-to")),
            el: $indicatorEl
          });
        });
      }
      var carousel = new Carousel(items, {
        defaultPosition,
        indicators: {
          items: indicators
        },
        interval: interval ? interval : Default3.interval
      });
      if (slide) {
        carousel.cycle();
      }
      var carouselNextEl = $carouselEl.querySelector("[data-carousel-next]");
      var carouselPrevEl = $carouselEl.querySelector("[data-carousel-prev]");
      if (carouselNextEl) {
        carouselNextEl.addEventListener("click", function() {
          carousel.next();
        });
      }
      if (carouselPrevEl) {
        carouselPrevEl.addEventListener("click", function() {
          carousel.prev();
        });
      }
    });
  }
  if (typeof window !== "undefined") {
    window.Carousel = Carousel;
    window.initCarousels = initCarousels;
  }

  // node_modules/flowbite/lib/esm/components/dismiss/index.js
  var __assign4 = function() {
    __assign4 = Object.assign || function(t) {
      for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s)
          if (Object.prototype.hasOwnProperty.call(s, p))
            t[p] = s[p];
      }
      return t;
    };
    return __assign4.apply(this, arguments);
  };
  var Default4 = {
    transition: "transition-opacity",
    duration: 300,
    timing: "ease-out",
    onHide: function() {
    }
  };
  var Dismiss = (
    /** @class */
    function() {
      function Dismiss2(targetEl, triggerEl, options) {
        if (targetEl === void 0) {
          targetEl = null;
        }
        if (triggerEl === void 0) {
          triggerEl = null;
        }
        if (options === void 0) {
          options = Default4;
        }
        this._targetEl = targetEl;
        this._triggerEl = triggerEl;
        this._options = __assign4(__assign4({}, Default4), options);
        this._init();
      }
      Dismiss2.prototype._init = function() {
        var _this = this;
        if (this._triggerEl) {
          this._triggerEl.addEventListener("click", function() {
            _this.hide();
          });
        }
      };
      Dismiss2.prototype.hide = function() {
        var _this = this;
        this._targetEl.classList.add(this._options.transition, "duration-".concat(this._options.duration), this._options.timing, "opacity-0");
        setTimeout(function() {
          _this._targetEl.classList.add("hidden");
        }, this._options.duration);
        this._options.onHide(this, this._targetEl);
      };
      return Dismiss2;
    }()
  );
  function initDismisses() {
    document.querySelectorAll("[data-dismiss-target]").forEach(function($triggerEl) {
      var targetId = $triggerEl.getAttribute("data-dismiss-target");
      var $dismissEl = document.querySelector(targetId);
      if ($dismissEl) {
        new Dismiss($dismissEl, $triggerEl);
      } else {
        console.error('The dismiss element with id "'.concat(targetId, '" does not exist. Please check the data-dismiss-target attribute.'));
      }
    });
  }
  if (typeof window !== "undefined") {
    window.Dismiss = Dismiss;
    window.initDismisses = initDismisses;
  }
  var dismiss_default = Dismiss;

  // node_modules/@popperjs/core/lib/enums.js
  var top = "top";
  var bottom = "bottom";
  var right = "right";
  var left = "left";
  var auto = "auto";
  var basePlacements = [top, bottom, right, left];
  var start = "start";
  var end = "end";
  var clippingParents = "clippingParents";
  var viewport = "viewport";
  var popper = "popper";
  var reference = "reference";
  var variationPlacements = /* @__PURE__ */ basePlacements.reduce(function(acc, placement) {
    return acc.concat([placement + "-" + start, placement + "-" + end]);
  }, []);
  var placements = /* @__PURE__ */ [].concat(basePlacements, [auto]).reduce(function(acc, placement) {
    return acc.concat([placement, placement + "-" + start, placement + "-" + end]);
  }, []);
  var beforeRead = "beforeRead";
  var read = "read";
  var afterRead = "afterRead";
  var beforeMain = "beforeMain";
  var main = "main";
  var afterMain = "afterMain";
  var beforeWrite = "beforeWrite";
  var write = "write";
  var afterWrite = "afterWrite";
  var modifierPhases = [beforeRead, read, afterRead, beforeMain, main, afterMain, beforeWrite, write, afterWrite];

  // node_modules/@popperjs/core/lib/dom-utils/getNodeName.js
  function getNodeName(element) {
    return element ? (element.nodeName || "").toLowerCase() : null;
  }

  // node_modules/@popperjs/core/lib/dom-utils/getWindow.js
  function getWindow(node) {
    if (node == null) {
      return window;
    }
    if (node.toString() !== "[object Window]") {
      var ownerDocument = node.ownerDocument;
      return ownerDocument ? ownerDocument.defaultView || window : window;
    }
    return node;
  }

  // node_modules/@popperjs/core/lib/dom-utils/instanceOf.js
  function isElement(node) {
    var OwnElement = getWindow(node).Element;
    return node instanceof OwnElement || node instanceof Element;
  }
  function isHTMLElement(node) {
    var OwnElement = getWindow(node).HTMLElement;
    return node instanceof OwnElement || node instanceof HTMLElement;
  }
  function isShadowRoot(node) {
    if (typeof ShadowRoot === "undefined") {
      return false;
    }
    var OwnElement = getWindow(node).ShadowRoot;
    return node instanceof OwnElement || node instanceof ShadowRoot;
  }

  // node_modules/@popperjs/core/lib/modifiers/applyStyles.js
  function applyStyles(_ref) {
    var state = _ref.state;
    Object.keys(state.elements).forEach(function(name) {
      var style = state.styles[name] || {};
      var attributes = state.attributes[name] || {};
      var element = state.elements[name];
      if (!isHTMLElement(element) || !getNodeName(element)) {
        return;
      }
      Object.assign(element.style, style);
      Object.keys(attributes).forEach(function(name2) {
        var value = attributes[name2];
        if (value === false) {
          element.removeAttribute(name2);
        } else {
          element.setAttribute(name2, value === true ? "" : value);
        }
      });
    });
  }
  function effect(_ref2) {
    var state = _ref2.state;
    var initialStyles = {
      popper: {
        position: state.options.strategy,
        left: "0",
        top: "0",
        margin: "0"
      },
      arrow: {
        position: "absolute"
      },
      reference: {}
    };
    Object.assign(state.elements.popper.style, initialStyles.popper);
    state.styles = initialStyles;
    if (state.elements.arrow) {
      Object.assign(state.elements.arrow.style, initialStyles.arrow);
    }
    return function() {
      Object.keys(state.elements).forEach(function(name) {
        var element = state.elements[name];
        var attributes = state.attributes[name] || {};
        var styleProperties = Object.keys(state.styles.hasOwnProperty(name) ? state.styles[name] : initialStyles[name]);
        var style = styleProperties.reduce(function(style2, property) {
          style2[property] = "";
          return style2;
        }, {});
        if (!isHTMLElement(element) || !getNodeName(element)) {
          return;
        }
        Object.assign(element.style, style);
        Object.keys(attributes).forEach(function(attribute) {
          element.removeAttribute(attribute);
        });
      });
    };
  }
  var applyStyles_default = {
    name: "applyStyles",
    enabled: true,
    phase: "write",
    fn: applyStyles,
    effect,
    requires: ["computeStyles"]
  };

  // node_modules/@popperjs/core/lib/utils/getBasePlacement.js
  function getBasePlacement(placement) {
    return placement.split("-")[0];
  }

  // node_modules/@popperjs/core/lib/utils/math.js
  var max = Math.max;
  var min = Math.min;
  var round = Math.round;

  // node_modules/@popperjs/core/lib/utils/userAgent.js
  function getUAString() {
    var uaData = navigator.userAgentData;
    if (uaData != null && uaData.brands && Array.isArray(uaData.brands)) {
      return uaData.brands.map(function(item) {
        return item.brand + "/" + item.version;
      }).join(" ");
    }
    return navigator.userAgent;
  }

  // node_modules/@popperjs/core/lib/dom-utils/isLayoutViewport.js
  function isLayoutViewport() {
    return !/^((?!chrome|android).)*safari/i.test(getUAString());
  }

  // node_modules/@popperjs/core/lib/dom-utils/getBoundingClientRect.js
  function getBoundingClientRect(element, includeScale, isFixedStrategy) {
    if (includeScale === void 0) {
      includeScale = false;
    }
    if (isFixedStrategy === void 0) {
      isFixedStrategy = false;
    }
    var clientRect = element.getBoundingClientRect();
    var scaleX = 1;
    var scaleY = 1;
    if (includeScale && isHTMLElement(element)) {
      scaleX = element.offsetWidth > 0 ? round(clientRect.width) / element.offsetWidth || 1 : 1;
      scaleY = element.offsetHeight > 0 ? round(clientRect.height) / element.offsetHeight || 1 : 1;
    }
    var _ref = isElement(element) ? getWindow(element) : window, visualViewport = _ref.visualViewport;
    var addVisualOffsets = !isLayoutViewport() && isFixedStrategy;
    var x = (clientRect.left + (addVisualOffsets && visualViewport ? visualViewport.offsetLeft : 0)) / scaleX;
    var y = (clientRect.top + (addVisualOffsets && visualViewport ? visualViewport.offsetTop : 0)) / scaleY;
    var width = clientRect.width / scaleX;
    var height = clientRect.height / scaleY;
    return {
      width,
      height,
      top: y,
      right: x + width,
      bottom: y + height,
      left: x,
      x,
      y
    };
  }

  // node_modules/@popperjs/core/lib/dom-utils/getLayoutRect.js
  function getLayoutRect(element) {
    var clientRect = getBoundingClientRect(element);
    var width = element.offsetWidth;
    var height = element.offsetHeight;
    if (Math.abs(clientRect.width - width) <= 1) {
      width = clientRect.width;
    }
    if (Math.abs(clientRect.height - height) <= 1) {
      height = clientRect.height;
    }
    return {
      x: element.offsetLeft,
      y: element.offsetTop,
      width,
      height
    };
  }

  // node_modules/@popperjs/core/lib/dom-utils/contains.js
  function contains(parent, child) {
    var rootNode = child.getRootNode && child.getRootNode();
    if (parent.contains(child)) {
      return true;
    } else if (rootNode && isShadowRoot(rootNode)) {
      var next = child;
      do {
        if (next && parent.isSameNode(next)) {
          return true;
        }
        next = next.parentNode || next.host;
      } while (next);
    }
    return false;
  }

  // node_modules/@popperjs/core/lib/dom-utils/getComputedStyle.js
  function getComputedStyle(element) {
    return getWindow(element).getComputedStyle(element);
  }

  // node_modules/@popperjs/core/lib/dom-utils/isTableElement.js
  function isTableElement(element) {
    return ["table", "td", "th"].indexOf(getNodeName(element)) >= 0;
  }

  // node_modules/@popperjs/core/lib/dom-utils/getDocumentElement.js
  function getDocumentElement(element) {
    return ((isElement(element) ? element.ownerDocument : (
      // $FlowFixMe[prop-missing]
      element.document
    )) || window.document).documentElement;
  }

  // node_modules/@popperjs/core/lib/dom-utils/getParentNode.js
  function getParentNode(element) {
    if (getNodeName(element) === "html") {
      return element;
    }
    return (
      // this is a quicker (but less type safe) way to save quite some bytes from the bundle
      // $FlowFixMe[incompatible-return]
      // $FlowFixMe[prop-missing]
      element.assignedSlot || // step into the shadow DOM of the parent of a slotted node
      element.parentNode || // DOM Element detected
      (isShadowRoot(element) ? element.host : null) || // ShadowRoot detected
      // $FlowFixMe[incompatible-call]: HTMLElement is a Node
      getDocumentElement(element)
    );
  }

  // node_modules/@popperjs/core/lib/dom-utils/getOffsetParent.js
  function getTrueOffsetParent(element) {
    if (!isHTMLElement(element) || // https://github.com/popperjs/popper-core/issues/837
    getComputedStyle(element).position === "fixed") {
      return null;
    }
    return element.offsetParent;
  }
  function getContainingBlock(element) {
    var isFirefox = /firefox/i.test(getUAString());
    var isIE = /Trident/i.test(getUAString());
    if (isIE && isHTMLElement(element)) {
      var elementCss = getComputedStyle(element);
      if (elementCss.position === "fixed") {
        return null;
      }
    }
    var currentNode = getParentNode(element);
    if (isShadowRoot(currentNode)) {
      currentNode = currentNode.host;
    }
    while (isHTMLElement(currentNode) && ["html", "body"].indexOf(getNodeName(currentNode)) < 0) {
      var css = getComputedStyle(currentNode);
      if (css.transform !== "none" || css.perspective !== "none" || css.contain === "paint" || ["transform", "perspective"].indexOf(css.willChange) !== -1 || isFirefox && css.willChange === "filter" || isFirefox && css.filter && css.filter !== "none") {
        return currentNode;
      } else {
        currentNode = currentNode.parentNode;
      }
    }
    return null;
  }
  function getOffsetParent(element) {
    var window2 = getWindow(element);
    var offsetParent = getTrueOffsetParent(element);
    while (offsetParent && isTableElement(offsetParent) && getComputedStyle(offsetParent).position === "static") {
      offsetParent = getTrueOffsetParent(offsetParent);
    }
    if (offsetParent && (getNodeName(offsetParent) === "html" || getNodeName(offsetParent) === "body" && getComputedStyle(offsetParent).position === "static")) {
      return window2;
    }
    return offsetParent || getContainingBlock(element) || window2;
  }

  // node_modules/@popperjs/core/lib/utils/getMainAxisFromPlacement.js
  function getMainAxisFromPlacement(placement) {
    return ["top", "bottom"].indexOf(placement) >= 0 ? "x" : "y";
  }

  // node_modules/@popperjs/core/lib/utils/within.js
  function within(min2, value, max2) {
    return max(min2, min(value, max2));
  }
  function withinMaxClamp(min2, value, max2) {
    var v = within(min2, value, max2);
    return v > max2 ? max2 : v;
  }

  // node_modules/@popperjs/core/lib/utils/getFreshSideObject.js
  function getFreshSideObject() {
    return {
      top: 0,
      right: 0,
      bottom: 0,
      left: 0
    };
  }

  // node_modules/@popperjs/core/lib/utils/mergePaddingObject.js
  function mergePaddingObject(paddingObject) {
    return Object.assign({}, getFreshSideObject(), paddingObject);
  }

  // node_modules/@popperjs/core/lib/utils/expandToHashMap.js
  function expandToHashMap(value, keys) {
    return keys.reduce(function(hashMap, key) {
      hashMap[key] = value;
      return hashMap;
    }, {});
  }

  // node_modules/@popperjs/core/lib/modifiers/arrow.js
  var toPaddingObject = function toPaddingObject2(padding, state) {
    padding = typeof padding === "function" ? padding(Object.assign({}, state.rects, {
      placement: state.placement
    })) : padding;
    return mergePaddingObject(typeof padding !== "number" ? padding : expandToHashMap(padding, basePlacements));
  };
  function arrow(_ref) {
    var _state$modifiersData$;
    var state = _ref.state, name = _ref.name, options = _ref.options;
    var arrowElement = state.elements.arrow;
    var popperOffsets2 = state.modifiersData.popperOffsets;
    var basePlacement = getBasePlacement(state.placement);
    var axis = getMainAxisFromPlacement(basePlacement);
    var isVertical = [left, right].indexOf(basePlacement) >= 0;
    var len = isVertical ? "height" : "width";
    if (!arrowElement || !popperOffsets2) {
      return;
    }
    var paddingObject = toPaddingObject(options.padding, state);
    var arrowRect = getLayoutRect(arrowElement);
    var minProp = axis === "y" ? top : left;
    var maxProp = axis === "y" ? bottom : right;
    var endDiff = state.rects.reference[len] + state.rects.reference[axis] - popperOffsets2[axis] - state.rects.popper[len];
    var startDiff = popperOffsets2[axis] - state.rects.reference[axis];
    var arrowOffsetParent = getOffsetParent(arrowElement);
    var clientSize = arrowOffsetParent ? axis === "y" ? arrowOffsetParent.clientHeight || 0 : arrowOffsetParent.clientWidth || 0 : 0;
    var centerToReference = endDiff / 2 - startDiff / 2;
    var min2 = paddingObject[minProp];
    var max2 = clientSize - arrowRect[len] - paddingObject[maxProp];
    var center = clientSize / 2 - arrowRect[len] / 2 + centerToReference;
    var offset2 = within(min2, center, max2);
    var axisProp = axis;
    state.modifiersData[name] = (_state$modifiersData$ = {}, _state$modifiersData$[axisProp] = offset2, _state$modifiersData$.centerOffset = offset2 - center, _state$modifiersData$);
  }
  function effect2(_ref2) {
    var state = _ref2.state, options = _ref2.options;
    var _options$element = options.element, arrowElement = _options$element === void 0 ? "[data-popper-arrow]" : _options$element;
    if (arrowElement == null) {
      return;
    }
    if (typeof arrowElement === "string") {
      arrowElement = state.elements.popper.querySelector(arrowElement);
      if (!arrowElement) {
        return;
      }
    }
    if (!contains(state.elements.popper, arrowElement)) {
      return;
    }
    state.elements.arrow = arrowElement;
  }
  var arrow_default = {
    name: "arrow",
    enabled: true,
    phase: "main",
    fn: arrow,
    effect: effect2,
    requires: ["popperOffsets"],
    requiresIfExists: ["preventOverflow"]
  };

  // node_modules/@popperjs/core/lib/utils/getVariation.js
  function getVariation(placement) {
    return placement.split("-")[1];
  }

  // node_modules/@popperjs/core/lib/modifiers/computeStyles.js
  var unsetSides = {
    top: "auto",
    right: "auto",
    bottom: "auto",
    left: "auto"
  };
  function roundOffsetsByDPR(_ref, win) {
    var x = _ref.x, y = _ref.y;
    var dpr = win.devicePixelRatio || 1;
    return {
      x: round(x * dpr) / dpr || 0,
      y: round(y * dpr) / dpr || 0
    };
  }
  function mapToStyles(_ref2) {
    var _Object$assign2;
    var popper2 = _ref2.popper, popperRect = _ref2.popperRect, placement = _ref2.placement, variation = _ref2.variation, offsets = _ref2.offsets, position = _ref2.position, gpuAcceleration = _ref2.gpuAcceleration, adaptive = _ref2.adaptive, roundOffsets = _ref2.roundOffsets, isFixed = _ref2.isFixed;
    var _offsets$x = offsets.x, x = _offsets$x === void 0 ? 0 : _offsets$x, _offsets$y = offsets.y, y = _offsets$y === void 0 ? 0 : _offsets$y;
    var _ref3 = typeof roundOffsets === "function" ? roundOffsets({
      x,
      y
    }) : {
      x,
      y
    };
    x = _ref3.x;
    y = _ref3.y;
    var hasX = offsets.hasOwnProperty("x");
    var hasY = offsets.hasOwnProperty("y");
    var sideX = left;
    var sideY = top;
    var win = window;
    if (adaptive) {
      var offsetParent = getOffsetParent(popper2);
      var heightProp = "clientHeight";
      var widthProp = "clientWidth";
      if (offsetParent === getWindow(popper2)) {
        offsetParent = getDocumentElement(popper2);
        if (getComputedStyle(offsetParent).position !== "static" && position === "absolute") {
          heightProp = "scrollHeight";
          widthProp = "scrollWidth";
        }
      }
      offsetParent = offsetParent;
      if (placement === top || (placement === left || placement === right) && variation === end) {
        sideY = bottom;
        var offsetY = isFixed && offsetParent === win && win.visualViewport ? win.visualViewport.height : (
          // $FlowFixMe[prop-missing]
          offsetParent[heightProp]
        );
        y -= offsetY - popperRect.height;
        y *= gpuAcceleration ? 1 : -1;
      }
      if (placement === left || (placement === top || placement === bottom) && variation === end) {
        sideX = right;
        var offsetX = isFixed && offsetParent === win && win.visualViewport ? win.visualViewport.width : (
          // $FlowFixMe[prop-missing]
          offsetParent[widthProp]
        );
        x -= offsetX - popperRect.width;
        x *= gpuAcceleration ? 1 : -1;
      }
    }
    var commonStyles = Object.assign({
      position
    }, adaptive && unsetSides);
    var _ref4 = roundOffsets === true ? roundOffsetsByDPR({
      x,
      y
    }, getWindow(popper2)) : {
      x,
      y
    };
    x = _ref4.x;
    y = _ref4.y;
    if (gpuAcceleration) {
      var _Object$assign;
      return Object.assign({}, commonStyles, (_Object$assign = {}, _Object$assign[sideY] = hasY ? "0" : "", _Object$assign[sideX] = hasX ? "0" : "", _Object$assign.transform = (win.devicePixelRatio || 1) <= 1 ? "translate(" + x + "px, " + y + "px)" : "translate3d(" + x + "px, " + y + "px, 0)", _Object$assign));
    }
    return Object.assign({}, commonStyles, (_Object$assign2 = {}, _Object$assign2[sideY] = hasY ? y + "px" : "", _Object$assign2[sideX] = hasX ? x + "px" : "", _Object$assign2.transform = "", _Object$assign2));
  }
  function computeStyles(_ref5) {
    var state = _ref5.state, options = _ref5.options;
    var _options$gpuAccelerat = options.gpuAcceleration, gpuAcceleration = _options$gpuAccelerat === void 0 ? true : _options$gpuAccelerat, _options$adaptive = options.adaptive, adaptive = _options$adaptive === void 0 ? true : _options$adaptive, _options$roundOffsets = options.roundOffsets, roundOffsets = _options$roundOffsets === void 0 ? true : _options$roundOffsets;
    var commonStyles = {
      placement: getBasePlacement(state.placement),
      variation: getVariation(state.placement),
      popper: state.elements.popper,
      popperRect: state.rects.popper,
      gpuAcceleration,
      isFixed: state.options.strategy === "fixed"
    };
    if (state.modifiersData.popperOffsets != null) {
      state.styles.popper = Object.assign({}, state.styles.popper, mapToStyles(Object.assign({}, commonStyles, {
        offsets: state.modifiersData.popperOffsets,
        position: state.options.strategy,
        adaptive,
        roundOffsets
      })));
    }
    if (state.modifiersData.arrow != null) {
      state.styles.arrow = Object.assign({}, state.styles.arrow, mapToStyles(Object.assign({}, commonStyles, {
        offsets: state.modifiersData.arrow,
        position: "absolute",
        adaptive: false,
        roundOffsets
      })));
    }
    state.attributes.popper = Object.assign({}, state.attributes.popper, {
      "data-popper-placement": state.placement
    });
  }
  var computeStyles_default = {
    name: "computeStyles",
    enabled: true,
    phase: "beforeWrite",
    fn: computeStyles,
    data: {}
  };

  // node_modules/@popperjs/core/lib/modifiers/eventListeners.js
  var passive = {
    passive: true
  };
  function effect3(_ref) {
    var state = _ref.state, instance = _ref.instance, options = _ref.options;
    var _options$scroll = options.scroll, scroll = _options$scroll === void 0 ? true : _options$scroll, _options$resize = options.resize, resize = _options$resize === void 0 ? true : _options$resize;
    var window2 = getWindow(state.elements.popper);
    var scrollParents = [].concat(state.scrollParents.reference, state.scrollParents.popper);
    if (scroll) {
      scrollParents.forEach(function(scrollParent) {
        scrollParent.addEventListener("scroll", instance.update, passive);
      });
    }
    if (resize) {
      window2.addEventListener("resize", instance.update, passive);
    }
    return function() {
      if (scroll) {
        scrollParents.forEach(function(scrollParent) {
          scrollParent.removeEventListener("scroll", instance.update, passive);
        });
      }
      if (resize) {
        window2.removeEventListener("resize", instance.update, passive);
      }
    };
  }
  var eventListeners_default = {
    name: "eventListeners",
    enabled: true,
    phase: "write",
    fn: function fn() {
    },
    effect: effect3,
    data: {}
  };

  // node_modules/@popperjs/core/lib/utils/getOppositePlacement.js
  var hash = {
    left: "right",
    right: "left",
    bottom: "top",
    top: "bottom"
  };
  function getOppositePlacement(placement) {
    return placement.replace(/left|right|bottom|top/g, function(matched) {
      return hash[matched];
    });
  }

  // node_modules/@popperjs/core/lib/utils/getOppositeVariationPlacement.js
  var hash2 = {
    start: "end",
    end: "start"
  };
  function getOppositeVariationPlacement(placement) {
    return placement.replace(/start|end/g, function(matched) {
      return hash2[matched];
    });
  }

  // node_modules/@popperjs/core/lib/dom-utils/getWindowScroll.js
  function getWindowScroll(node) {
    var win = getWindow(node);
    var scrollLeft = win.pageXOffset;
    var scrollTop = win.pageYOffset;
    return {
      scrollLeft,
      scrollTop
    };
  }

  // node_modules/@popperjs/core/lib/dom-utils/getWindowScrollBarX.js
  function getWindowScrollBarX(element) {
    return getBoundingClientRect(getDocumentElement(element)).left + getWindowScroll(element).scrollLeft;
  }

  // node_modules/@popperjs/core/lib/dom-utils/getViewportRect.js
  function getViewportRect(element, strategy) {
    var win = getWindow(element);
    var html = getDocumentElement(element);
    var visualViewport = win.visualViewport;
    var width = html.clientWidth;
    var height = html.clientHeight;
    var x = 0;
    var y = 0;
    if (visualViewport) {
      width = visualViewport.width;
      height = visualViewport.height;
      var layoutViewport = isLayoutViewport();
      if (layoutViewport || !layoutViewport && strategy === "fixed") {
        x = visualViewport.offsetLeft;
        y = visualViewport.offsetTop;
      }
    }
    return {
      width,
      height,
      x: x + getWindowScrollBarX(element),
      y
    };
  }

  // node_modules/@popperjs/core/lib/dom-utils/getDocumentRect.js
  function getDocumentRect(element) {
    var _element$ownerDocumen;
    var html = getDocumentElement(element);
    var winScroll = getWindowScroll(element);
    var body = (_element$ownerDocumen = element.ownerDocument) == null ? void 0 : _element$ownerDocumen.body;
    var width = max(html.scrollWidth, html.clientWidth, body ? body.scrollWidth : 0, body ? body.clientWidth : 0);
    var height = max(html.scrollHeight, html.clientHeight, body ? body.scrollHeight : 0, body ? body.clientHeight : 0);
    var x = -winScroll.scrollLeft + getWindowScrollBarX(element);
    var y = -winScroll.scrollTop;
    if (getComputedStyle(body || html).direction === "rtl") {
      x += max(html.clientWidth, body ? body.clientWidth : 0) - width;
    }
    return {
      width,
      height,
      x,
      y
    };
  }

  // node_modules/@popperjs/core/lib/dom-utils/isScrollParent.js
  function isScrollParent(element) {
    var _getComputedStyle = getComputedStyle(element), overflow = _getComputedStyle.overflow, overflowX = _getComputedStyle.overflowX, overflowY = _getComputedStyle.overflowY;
    return /auto|scroll|overlay|hidden/.test(overflow + overflowY + overflowX);
  }

  // node_modules/@popperjs/core/lib/dom-utils/getScrollParent.js
  function getScrollParent(node) {
    if (["html", "body", "#document"].indexOf(getNodeName(node)) >= 0) {
      return node.ownerDocument.body;
    }
    if (isHTMLElement(node) && isScrollParent(node)) {
      return node;
    }
    return getScrollParent(getParentNode(node));
  }

  // node_modules/@popperjs/core/lib/dom-utils/listScrollParents.js
  function listScrollParents(element, list) {
    var _element$ownerDocumen;
    if (list === void 0) {
      list = [];
    }
    var scrollParent = getScrollParent(element);
    var isBody = scrollParent === ((_element$ownerDocumen = element.ownerDocument) == null ? void 0 : _element$ownerDocumen.body);
    var win = getWindow(scrollParent);
    var target = isBody ? [win].concat(win.visualViewport || [], isScrollParent(scrollParent) ? scrollParent : []) : scrollParent;
    var updatedList = list.concat(target);
    return isBody ? updatedList : (
      // $FlowFixMe[incompatible-call]: isBody tells us target will be an HTMLElement here
      updatedList.concat(listScrollParents(getParentNode(target)))
    );
  }

  // node_modules/@popperjs/core/lib/utils/rectToClientRect.js
  function rectToClientRect(rect) {
    return Object.assign({}, rect, {
      left: rect.x,
      top: rect.y,
      right: rect.x + rect.width,
      bottom: rect.y + rect.height
    });
  }

  // node_modules/@popperjs/core/lib/dom-utils/getClippingRect.js
  function getInnerBoundingClientRect(element, strategy) {
    var rect = getBoundingClientRect(element, false, strategy === "fixed");
    rect.top = rect.top + element.clientTop;
    rect.left = rect.left + element.clientLeft;
    rect.bottom = rect.top + element.clientHeight;
    rect.right = rect.left + element.clientWidth;
    rect.width = element.clientWidth;
    rect.height = element.clientHeight;
    rect.x = rect.left;
    rect.y = rect.top;
    return rect;
  }
  function getClientRectFromMixedType(element, clippingParent, strategy) {
    return clippingParent === viewport ? rectToClientRect(getViewportRect(element, strategy)) : isElement(clippingParent) ? getInnerBoundingClientRect(clippingParent, strategy) : rectToClientRect(getDocumentRect(getDocumentElement(element)));
  }
  function getClippingParents(element) {
    var clippingParents2 = listScrollParents(getParentNode(element));
    var canEscapeClipping = ["absolute", "fixed"].indexOf(getComputedStyle(element).position) >= 0;
    var clipperElement = canEscapeClipping && isHTMLElement(element) ? getOffsetParent(element) : element;
    if (!isElement(clipperElement)) {
      return [];
    }
    return clippingParents2.filter(function(clippingParent) {
      return isElement(clippingParent) && contains(clippingParent, clipperElement) && getNodeName(clippingParent) !== "body";
    });
  }
  function getClippingRect(element, boundary, rootBoundary, strategy) {
    var mainClippingParents = boundary === "clippingParents" ? getClippingParents(element) : [].concat(boundary);
    var clippingParents2 = [].concat(mainClippingParents, [rootBoundary]);
    var firstClippingParent = clippingParents2[0];
    var clippingRect = clippingParents2.reduce(function(accRect, clippingParent) {
      var rect = getClientRectFromMixedType(element, clippingParent, strategy);
      accRect.top = max(rect.top, accRect.top);
      accRect.right = min(rect.right, accRect.right);
      accRect.bottom = min(rect.bottom, accRect.bottom);
      accRect.left = max(rect.left, accRect.left);
      return accRect;
    }, getClientRectFromMixedType(element, firstClippingParent, strategy));
    clippingRect.width = clippingRect.right - clippingRect.left;
    clippingRect.height = clippingRect.bottom - clippingRect.top;
    clippingRect.x = clippingRect.left;
    clippingRect.y = clippingRect.top;
    return clippingRect;
  }

  // node_modules/@popperjs/core/lib/utils/computeOffsets.js
  function computeOffsets(_ref) {
    var reference2 = _ref.reference, element = _ref.element, placement = _ref.placement;
    var basePlacement = placement ? getBasePlacement(placement) : null;
    var variation = placement ? getVariation(placement) : null;
    var commonX = reference2.x + reference2.width / 2 - element.width / 2;
    var commonY = reference2.y + reference2.height / 2 - element.height / 2;
    var offsets;
    switch (basePlacement) {
      case top:
        offsets = {
          x: commonX,
          y: reference2.y - element.height
        };
        break;
      case bottom:
        offsets = {
          x: commonX,
          y: reference2.y + reference2.height
        };
        break;
      case right:
        offsets = {
          x: reference2.x + reference2.width,
          y: commonY
        };
        break;
      case left:
        offsets = {
          x: reference2.x - element.width,
          y: commonY
        };
        break;
      default:
        offsets = {
          x: reference2.x,
          y: reference2.y
        };
    }
    var mainAxis = basePlacement ? getMainAxisFromPlacement(basePlacement) : null;
    if (mainAxis != null) {
      var len = mainAxis === "y" ? "height" : "width";
      switch (variation) {
        case start:
          offsets[mainAxis] = offsets[mainAxis] - (reference2[len] / 2 - element[len] / 2);
          break;
        case end:
          offsets[mainAxis] = offsets[mainAxis] + (reference2[len] / 2 - element[len] / 2);
          break;
        default:
      }
    }
    return offsets;
  }

  // node_modules/@popperjs/core/lib/utils/detectOverflow.js
  function detectOverflow(state, options) {
    if (options === void 0) {
      options = {};
    }
    var _options = options, _options$placement = _options.placement, placement = _options$placement === void 0 ? state.placement : _options$placement, _options$strategy = _options.strategy, strategy = _options$strategy === void 0 ? state.strategy : _options$strategy, _options$boundary = _options.boundary, boundary = _options$boundary === void 0 ? clippingParents : _options$boundary, _options$rootBoundary = _options.rootBoundary, rootBoundary = _options$rootBoundary === void 0 ? viewport : _options$rootBoundary, _options$elementConte = _options.elementContext, elementContext = _options$elementConte === void 0 ? popper : _options$elementConte, _options$altBoundary = _options.altBoundary, altBoundary = _options$altBoundary === void 0 ? false : _options$altBoundary, _options$padding = _options.padding, padding = _options$padding === void 0 ? 0 : _options$padding;
    var paddingObject = mergePaddingObject(typeof padding !== "number" ? padding : expandToHashMap(padding, basePlacements));
    var altContext = elementContext === popper ? reference : popper;
    var popperRect = state.rects.popper;
    var element = state.elements[altBoundary ? altContext : elementContext];
    var clippingClientRect = getClippingRect(isElement(element) ? element : element.contextElement || getDocumentElement(state.elements.popper), boundary, rootBoundary, strategy);
    var referenceClientRect = getBoundingClientRect(state.elements.reference);
    var popperOffsets2 = computeOffsets({
      reference: referenceClientRect,
      element: popperRect,
      strategy: "absolute",
      placement
    });
    var popperClientRect = rectToClientRect(Object.assign({}, popperRect, popperOffsets2));
    var elementClientRect = elementContext === popper ? popperClientRect : referenceClientRect;
    var overflowOffsets = {
      top: clippingClientRect.top - elementClientRect.top + paddingObject.top,
      bottom: elementClientRect.bottom - clippingClientRect.bottom + paddingObject.bottom,
      left: clippingClientRect.left - elementClientRect.left + paddingObject.left,
      right: elementClientRect.right - clippingClientRect.right + paddingObject.right
    };
    var offsetData = state.modifiersData.offset;
    if (elementContext === popper && offsetData) {
      var offset2 = offsetData[placement];
      Object.keys(overflowOffsets).forEach(function(key) {
        var multiply = [right, bottom].indexOf(key) >= 0 ? 1 : -1;
        var axis = [top, bottom].indexOf(key) >= 0 ? "y" : "x";
        overflowOffsets[key] += offset2[axis] * multiply;
      });
    }
    return overflowOffsets;
  }

  // node_modules/@popperjs/core/lib/utils/computeAutoPlacement.js
  function computeAutoPlacement(state, options) {
    if (options === void 0) {
      options = {};
    }
    var _options = options, placement = _options.placement, boundary = _options.boundary, rootBoundary = _options.rootBoundary, padding = _options.padding, flipVariations = _options.flipVariations, _options$allowedAutoP = _options.allowedAutoPlacements, allowedAutoPlacements = _options$allowedAutoP === void 0 ? placements : _options$allowedAutoP;
    var variation = getVariation(placement);
    var placements2 = variation ? flipVariations ? variationPlacements : variationPlacements.filter(function(placement2) {
      return getVariation(placement2) === variation;
    }) : basePlacements;
    var allowedPlacements = placements2.filter(function(placement2) {
      return allowedAutoPlacements.indexOf(placement2) >= 0;
    });
    if (allowedPlacements.length === 0) {
      allowedPlacements = placements2;
    }
    var overflows = allowedPlacements.reduce(function(acc, placement2) {
      acc[placement2] = detectOverflow(state, {
        placement: placement2,
        boundary,
        rootBoundary,
        padding
      })[getBasePlacement(placement2)];
      return acc;
    }, {});
    return Object.keys(overflows).sort(function(a, b) {
      return overflows[a] - overflows[b];
    });
  }

  // node_modules/@popperjs/core/lib/modifiers/flip.js
  function getExpandedFallbackPlacements(placement) {
    if (getBasePlacement(placement) === auto) {
      return [];
    }
    var oppositePlacement = getOppositePlacement(placement);
    return [getOppositeVariationPlacement(placement), oppositePlacement, getOppositeVariationPlacement(oppositePlacement)];
  }
  function flip(_ref) {
    var state = _ref.state, options = _ref.options, name = _ref.name;
    if (state.modifiersData[name]._skip) {
      return;
    }
    var _options$mainAxis = options.mainAxis, checkMainAxis = _options$mainAxis === void 0 ? true : _options$mainAxis, _options$altAxis = options.altAxis, checkAltAxis = _options$altAxis === void 0 ? true : _options$altAxis, specifiedFallbackPlacements = options.fallbackPlacements, padding = options.padding, boundary = options.boundary, rootBoundary = options.rootBoundary, altBoundary = options.altBoundary, _options$flipVariatio = options.flipVariations, flipVariations = _options$flipVariatio === void 0 ? true : _options$flipVariatio, allowedAutoPlacements = options.allowedAutoPlacements;
    var preferredPlacement = state.options.placement;
    var basePlacement = getBasePlacement(preferredPlacement);
    var isBasePlacement = basePlacement === preferredPlacement;
    var fallbackPlacements = specifiedFallbackPlacements || (isBasePlacement || !flipVariations ? [getOppositePlacement(preferredPlacement)] : getExpandedFallbackPlacements(preferredPlacement));
    var placements2 = [preferredPlacement].concat(fallbackPlacements).reduce(function(acc, placement2) {
      return acc.concat(getBasePlacement(placement2) === auto ? computeAutoPlacement(state, {
        placement: placement2,
        boundary,
        rootBoundary,
        padding,
        flipVariations,
        allowedAutoPlacements
      }) : placement2);
    }, []);
    var referenceRect = state.rects.reference;
    var popperRect = state.rects.popper;
    var checksMap = /* @__PURE__ */ new Map();
    var makeFallbackChecks = true;
    var firstFittingPlacement = placements2[0];
    for (var i = 0; i < placements2.length; i++) {
      var placement = placements2[i];
      var _basePlacement = getBasePlacement(placement);
      var isStartVariation = getVariation(placement) === start;
      var isVertical = [top, bottom].indexOf(_basePlacement) >= 0;
      var len = isVertical ? "width" : "height";
      var overflow = detectOverflow(state, {
        placement,
        boundary,
        rootBoundary,
        altBoundary,
        padding
      });
      var mainVariationSide = isVertical ? isStartVariation ? right : left : isStartVariation ? bottom : top;
      if (referenceRect[len] > popperRect[len]) {
        mainVariationSide = getOppositePlacement(mainVariationSide);
      }
      var altVariationSide = getOppositePlacement(mainVariationSide);
      var checks = [];
      if (checkMainAxis) {
        checks.push(overflow[_basePlacement] <= 0);
      }
      if (checkAltAxis) {
        checks.push(overflow[mainVariationSide] <= 0, overflow[altVariationSide] <= 0);
      }
      if (checks.every(function(check) {
        return check;
      })) {
        firstFittingPlacement = placement;
        makeFallbackChecks = false;
        break;
      }
      checksMap.set(placement, checks);
    }
    if (makeFallbackChecks) {
      var numberOfChecks = flipVariations ? 3 : 1;
      var _loop = function _loop2(_i2) {
        var fittingPlacement = placements2.find(function(placement2) {
          var checks2 = checksMap.get(placement2);
          if (checks2) {
            return checks2.slice(0, _i2).every(function(check) {
              return check;
            });
          }
        });
        if (fittingPlacement) {
          firstFittingPlacement = fittingPlacement;
          return "break";
        }
      };
      for (var _i = numberOfChecks; _i > 0; _i--) {
        var _ret = _loop(_i);
        if (_ret === "break")
          break;
      }
    }
    if (state.placement !== firstFittingPlacement) {
      state.modifiersData[name]._skip = true;
      state.placement = firstFittingPlacement;
      state.reset = true;
    }
  }
  var flip_default = {
    name: "flip",
    enabled: true,
    phase: "main",
    fn: flip,
    requiresIfExists: ["offset"],
    data: {
      _skip: false
    }
  };

  // node_modules/@popperjs/core/lib/modifiers/hide.js
  function getSideOffsets(overflow, rect, preventedOffsets) {
    if (preventedOffsets === void 0) {
      preventedOffsets = {
        x: 0,
        y: 0
      };
    }
    return {
      top: overflow.top - rect.height - preventedOffsets.y,
      right: overflow.right - rect.width + preventedOffsets.x,
      bottom: overflow.bottom - rect.height + preventedOffsets.y,
      left: overflow.left - rect.width - preventedOffsets.x
    };
  }
  function isAnySideFullyClipped(overflow) {
    return [top, right, bottom, left].some(function(side) {
      return overflow[side] >= 0;
    });
  }
  function hide(_ref) {
    var state = _ref.state, name = _ref.name;
    var referenceRect = state.rects.reference;
    var popperRect = state.rects.popper;
    var preventedOffsets = state.modifiersData.preventOverflow;
    var referenceOverflow = detectOverflow(state, {
      elementContext: "reference"
    });
    var popperAltOverflow = detectOverflow(state, {
      altBoundary: true
    });
    var referenceClippingOffsets = getSideOffsets(referenceOverflow, referenceRect);
    var popperEscapeOffsets = getSideOffsets(popperAltOverflow, popperRect, preventedOffsets);
    var isReferenceHidden = isAnySideFullyClipped(referenceClippingOffsets);
    var hasPopperEscaped = isAnySideFullyClipped(popperEscapeOffsets);
    state.modifiersData[name] = {
      referenceClippingOffsets,
      popperEscapeOffsets,
      isReferenceHidden,
      hasPopperEscaped
    };
    state.attributes.popper = Object.assign({}, state.attributes.popper, {
      "data-popper-reference-hidden": isReferenceHidden,
      "data-popper-escaped": hasPopperEscaped
    });
  }
  var hide_default = {
    name: "hide",
    enabled: true,
    phase: "main",
    requiresIfExists: ["preventOverflow"],
    fn: hide
  };

  // node_modules/@popperjs/core/lib/modifiers/offset.js
  function distanceAndSkiddingToXY(placement, rects, offset2) {
    var basePlacement = getBasePlacement(placement);
    var invertDistance = [left, top].indexOf(basePlacement) >= 0 ? -1 : 1;
    var _ref = typeof offset2 === "function" ? offset2(Object.assign({}, rects, {
      placement
    })) : offset2, skidding = _ref[0], distance = _ref[1];
    skidding = skidding || 0;
    distance = (distance || 0) * invertDistance;
    return [left, right].indexOf(basePlacement) >= 0 ? {
      x: distance,
      y: skidding
    } : {
      x: skidding,
      y: distance
    };
  }
  function offset(_ref2) {
    var state = _ref2.state, options = _ref2.options, name = _ref2.name;
    var _options$offset = options.offset, offset2 = _options$offset === void 0 ? [0, 0] : _options$offset;
    var data = placements.reduce(function(acc, placement) {
      acc[placement] = distanceAndSkiddingToXY(placement, state.rects, offset2);
      return acc;
    }, {});
    var _data$state$placement = data[state.placement], x = _data$state$placement.x, y = _data$state$placement.y;
    if (state.modifiersData.popperOffsets != null) {
      state.modifiersData.popperOffsets.x += x;
      state.modifiersData.popperOffsets.y += y;
    }
    state.modifiersData[name] = data;
  }
  var offset_default = {
    name: "offset",
    enabled: true,
    phase: "main",
    requires: ["popperOffsets"],
    fn: offset
  };

  // node_modules/@popperjs/core/lib/modifiers/popperOffsets.js
  function popperOffsets(_ref) {
    var state = _ref.state, name = _ref.name;
    state.modifiersData[name] = computeOffsets({
      reference: state.rects.reference,
      element: state.rects.popper,
      strategy: "absolute",
      placement: state.placement
    });
  }
  var popperOffsets_default = {
    name: "popperOffsets",
    enabled: true,
    phase: "read",
    fn: popperOffsets,
    data: {}
  };

  // node_modules/@popperjs/core/lib/utils/getAltAxis.js
  function getAltAxis(axis) {
    return axis === "x" ? "y" : "x";
  }

  // node_modules/@popperjs/core/lib/modifiers/preventOverflow.js
  function preventOverflow(_ref) {
    var state = _ref.state, options = _ref.options, name = _ref.name;
    var _options$mainAxis = options.mainAxis, checkMainAxis = _options$mainAxis === void 0 ? true : _options$mainAxis, _options$altAxis = options.altAxis, checkAltAxis = _options$altAxis === void 0 ? false : _options$altAxis, boundary = options.boundary, rootBoundary = options.rootBoundary, altBoundary = options.altBoundary, padding = options.padding, _options$tether = options.tether, tether = _options$tether === void 0 ? true : _options$tether, _options$tetherOffset = options.tetherOffset, tetherOffset = _options$tetherOffset === void 0 ? 0 : _options$tetherOffset;
    var overflow = detectOverflow(state, {
      boundary,
      rootBoundary,
      padding,
      altBoundary
    });
    var basePlacement = getBasePlacement(state.placement);
    var variation = getVariation(state.placement);
    var isBasePlacement = !variation;
    var mainAxis = getMainAxisFromPlacement(basePlacement);
    var altAxis = getAltAxis(mainAxis);
    var popperOffsets2 = state.modifiersData.popperOffsets;
    var referenceRect = state.rects.reference;
    var popperRect = state.rects.popper;
    var tetherOffsetValue = typeof tetherOffset === "function" ? tetherOffset(Object.assign({}, state.rects, {
      placement: state.placement
    })) : tetherOffset;
    var normalizedTetherOffsetValue = typeof tetherOffsetValue === "number" ? {
      mainAxis: tetherOffsetValue,
      altAxis: tetherOffsetValue
    } : Object.assign({
      mainAxis: 0,
      altAxis: 0
    }, tetherOffsetValue);
    var offsetModifierState = state.modifiersData.offset ? state.modifiersData.offset[state.placement] : null;
    var data = {
      x: 0,
      y: 0
    };
    if (!popperOffsets2) {
      return;
    }
    if (checkMainAxis) {
      var _offsetModifierState$;
      var mainSide = mainAxis === "y" ? top : left;
      var altSide = mainAxis === "y" ? bottom : right;
      var len = mainAxis === "y" ? "height" : "width";
      var offset2 = popperOffsets2[mainAxis];
      var min2 = offset2 + overflow[mainSide];
      var max2 = offset2 - overflow[altSide];
      var additive = tether ? -popperRect[len] / 2 : 0;
      var minLen = variation === start ? referenceRect[len] : popperRect[len];
      var maxLen = variation === start ? -popperRect[len] : -referenceRect[len];
      var arrowElement = state.elements.arrow;
      var arrowRect = tether && arrowElement ? getLayoutRect(arrowElement) : {
        width: 0,
        height: 0
      };
      var arrowPaddingObject = state.modifiersData["arrow#persistent"] ? state.modifiersData["arrow#persistent"].padding : getFreshSideObject();
      var arrowPaddingMin = arrowPaddingObject[mainSide];
      var arrowPaddingMax = arrowPaddingObject[altSide];
      var arrowLen = within(0, referenceRect[len], arrowRect[len]);
      var minOffset = isBasePlacement ? referenceRect[len] / 2 - additive - arrowLen - arrowPaddingMin - normalizedTetherOffsetValue.mainAxis : minLen - arrowLen - arrowPaddingMin - normalizedTetherOffsetValue.mainAxis;
      var maxOffset = isBasePlacement ? -referenceRect[len] / 2 + additive + arrowLen + arrowPaddingMax + normalizedTetherOffsetValue.mainAxis : maxLen + arrowLen + arrowPaddingMax + normalizedTetherOffsetValue.mainAxis;
      var arrowOffsetParent = state.elements.arrow && getOffsetParent(state.elements.arrow);
      var clientOffset = arrowOffsetParent ? mainAxis === "y" ? arrowOffsetParent.clientTop || 0 : arrowOffsetParent.clientLeft || 0 : 0;
      var offsetModifierValue = (_offsetModifierState$ = offsetModifierState == null ? void 0 : offsetModifierState[mainAxis]) != null ? _offsetModifierState$ : 0;
      var tetherMin = offset2 + minOffset - offsetModifierValue - clientOffset;
      var tetherMax = offset2 + maxOffset - offsetModifierValue;
      var preventedOffset = within(tether ? min(min2, tetherMin) : min2, offset2, tether ? max(max2, tetherMax) : max2);
      popperOffsets2[mainAxis] = preventedOffset;
      data[mainAxis] = preventedOffset - offset2;
    }
    if (checkAltAxis) {
      var _offsetModifierState$2;
      var _mainSide = mainAxis === "x" ? top : left;
      var _altSide = mainAxis === "x" ? bottom : right;
      var _offset = popperOffsets2[altAxis];
      var _len = altAxis === "y" ? "height" : "width";
      var _min = _offset + overflow[_mainSide];
      var _max = _offset - overflow[_altSide];
      var isOriginSide = [top, left].indexOf(basePlacement) !== -1;
      var _offsetModifierValue = (_offsetModifierState$2 = offsetModifierState == null ? void 0 : offsetModifierState[altAxis]) != null ? _offsetModifierState$2 : 0;
      var _tetherMin = isOriginSide ? _min : _offset - referenceRect[_len] - popperRect[_len] - _offsetModifierValue + normalizedTetherOffsetValue.altAxis;
      var _tetherMax = isOriginSide ? _offset + referenceRect[_len] + popperRect[_len] - _offsetModifierValue - normalizedTetherOffsetValue.altAxis : _max;
      var _preventedOffset = tether && isOriginSide ? withinMaxClamp(_tetherMin, _offset, _tetherMax) : within(tether ? _tetherMin : _min, _offset, tether ? _tetherMax : _max);
      popperOffsets2[altAxis] = _preventedOffset;
      data[altAxis] = _preventedOffset - _offset;
    }
    state.modifiersData[name] = data;
  }
  var preventOverflow_default = {
    name: "preventOverflow",
    enabled: true,
    phase: "main",
    fn: preventOverflow,
    requiresIfExists: ["offset"]
  };

  // node_modules/@popperjs/core/lib/dom-utils/getHTMLElementScroll.js
  function getHTMLElementScroll(element) {
    return {
      scrollLeft: element.scrollLeft,
      scrollTop: element.scrollTop
    };
  }

  // node_modules/@popperjs/core/lib/dom-utils/getNodeScroll.js
  function getNodeScroll(node) {
    if (node === getWindow(node) || !isHTMLElement(node)) {
      return getWindowScroll(node);
    } else {
      return getHTMLElementScroll(node);
    }
  }

  // node_modules/@popperjs/core/lib/dom-utils/getCompositeRect.js
  function isElementScaled(element) {
    var rect = element.getBoundingClientRect();
    var scaleX = round(rect.width) / element.offsetWidth || 1;
    var scaleY = round(rect.height) / element.offsetHeight || 1;
    return scaleX !== 1 || scaleY !== 1;
  }
  function getCompositeRect(elementOrVirtualElement, offsetParent, isFixed) {
    if (isFixed === void 0) {
      isFixed = false;
    }
    var isOffsetParentAnElement = isHTMLElement(offsetParent);
    var offsetParentIsScaled = isHTMLElement(offsetParent) && isElementScaled(offsetParent);
    var documentElement = getDocumentElement(offsetParent);
    var rect = getBoundingClientRect(elementOrVirtualElement, offsetParentIsScaled, isFixed);
    var scroll = {
      scrollLeft: 0,
      scrollTop: 0
    };
    var offsets = {
      x: 0,
      y: 0
    };
    if (isOffsetParentAnElement || !isOffsetParentAnElement && !isFixed) {
      if (getNodeName(offsetParent) !== "body" || // https://github.com/popperjs/popper-core/issues/1078
      isScrollParent(documentElement)) {
        scroll = getNodeScroll(offsetParent);
      }
      if (isHTMLElement(offsetParent)) {
        offsets = getBoundingClientRect(offsetParent, true);
        offsets.x += offsetParent.clientLeft;
        offsets.y += offsetParent.clientTop;
      } else if (documentElement) {
        offsets.x = getWindowScrollBarX(documentElement);
      }
    }
    return {
      x: rect.left + scroll.scrollLeft - offsets.x,
      y: rect.top + scroll.scrollTop - offsets.y,
      width: rect.width,
      height: rect.height
    };
  }

  // node_modules/@popperjs/core/lib/utils/orderModifiers.js
  function order(modifiers) {
    var map = /* @__PURE__ */ new Map();
    var visited = /* @__PURE__ */ new Set();
    var result = [];
    modifiers.forEach(function(modifier) {
      map.set(modifier.name, modifier);
    });
    function sort(modifier) {
      visited.add(modifier.name);
      var requires = [].concat(modifier.requires || [], modifier.requiresIfExists || []);
      requires.forEach(function(dep) {
        if (!visited.has(dep)) {
          var depModifier = map.get(dep);
          if (depModifier) {
            sort(depModifier);
          }
        }
      });
      result.push(modifier);
    }
    modifiers.forEach(function(modifier) {
      if (!visited.has(modifier.name)) {
        sort(modifier);
      }
    });
    return result;
  }
  function orderModifiers(modifiers) {
    var orderedModifiers = order(modifiers);
    return modifierPhases.reduce(function(acc, phase) {
      return acc.concat(orderedModifiers.filter(function(modifier) {
        return modifier.phase === phase;
      }));
    }, []);
  }

  // node_modules/@popperjs/core/lib/utils/debounce.js
  function debounce(fn2) {
    var pending;
    return function() {
      if (!pending) {
        pending = new Promise(function(resolve) {
          Promise.resolve().then(function() {
            pending = void 0;
            resolve(fn2());
          });
        });
      }
      return pending;
    };
  }

  // node_modules/@popperjs/core/lib/utils/mergeByName.js
  function mergeByName(modifiers) {
    var merged = modifiers.reduce(function(merged2, current) {
      var existing = merged2[current.name];
      merged2[current.name] = existing ? Object.assign({}, existing, current, {
        options: Object.assign({}, existing.options, current.options),
        data: Object.assign({}, existing.data, current.data)
      }) : current;
      return merged2;
    }, {});
    return Object.keys(merged).map(function(key) {
      return merged[key];
    });
  }

  // node_modules/@popperjs/core/lib/createPopper.js
  var DEFAULT_OPTIONS = {
    placement: "bottom",
    modifiers: [],
    strategy: "absolute"
  };
  function areValidElements() {
    for (var _len = arguments.length, args = new Array(_len), _key = 0; _key < _len; _key++) {
      args[_key] = arguments[_key];
    }
    return !args.some(function(element) {
      return !(element && typeof element.getBoundingClientRect === "function");
    });
  }
  function popperGenerator(generatorOptions) {
    if (generatorOptions === void 0) {
      generatorOptions = {};
    }
    var _generatorOptions = generatorOptions, _generatorOptions$def = _generatorOptions.defaultModifiers, defaultModifiers2 = _generatorOptions$def === void 0 ? [] : _generatorOptions$def, _generatorOptions$def2 = _generatorOptions.defaultOptions, defaultOptions = _generatorOptions$def2 === void 0 ? DEFAULT_OPTIONS : _generatorOptions$def2;
    return function createPopper2(reference2, popper2, options) {
      if (options === void 0) {
        options = defaultOptions;
      }
      var state = {
        placement: "bottom",
        orderedModifiers: [],
        options: Object.assign({}, DEFAULT_OPTIONS, defaultOptions),
        modifiersData: {},
        elements: {
          reference: reference2,
          popper: popper2
        },
        attributes: {},
        styles: {}
      };
      var effectCleanupFns = [];
      var isDestroyed = false;
      var instance = {
        state,
        setOptions: function setOptions(setOptionsAction) {
          var options2 = typeof setOptionsAction === "function" ? setOptionsAction(state.options) : setOptionsAction;
          cleanupModifierEffects();
          state.options = Object.assign({}, defaultOptions, state.options, options2);
          state.scrollParents = {
            reference: isElement(reference2) ? listScrollParents(reference2) : reference2.contextElement ? listScrollParents(reference2.contextElement) : [],
            popper: listScrollParents(popper2)
          };
          var orderedModifiers = orderModifiers(mergeByName([].concat(defaultModifiers2, state.options.modifiers)));
          state.orderedModifiers = orderedModifiers.filter(function(m) {
            return m.enabled;
          });
          runModifierEffects();
          return instance.update();
        },
        // Sync update – it will always be executed, even if not necessary. This
        // is useful for low frequency updates where sync behavior simplifies the
        // logic.
        // For high frequency updates (e.g. `resize` and `scroll` events), always
        // prefer the async Popper#update method
        forceUpdate: function forceUpdate() {
          if (isDestroyed) {
            return;
          }
          var _state$elements = state.elements, reference3 = _state$elements.reference, popper3 = _state$elements.popper;
          if (!areValidElements(reference3, popper3)) {
            return;
          }
          state.rects = {
            reference: getCompositeRect(reference3, getOffsetParent(popper3), state.options.strategy === "fixed"),
            popper: getLayoutRect(popper3)
          };
          state.reset = false;
          state.placement = state.options.placement;
          state.orderedModifiers.forEach(function(modifier) {
            return state.modifiersData[modifier.name] = Object.assign({}, modifier.data);
          });
          for (var index = 0; index < state.orderedModifiers.length; index++) {
            if (state.reset === true) {
              state.reset = false;
              index = -1;
              continue;
            }
            var _state$orderedModifie = state.orderedModifiers[index], fn2 = _state$orderedModifie.fn, _state$orderedModifie2 = _state$orderedModifie.options, _options = _state$orderedModifie2 === void 0 ? {} : _state$orderedModifie2, name = _state$orderedModifie.name;
            if (typeof fn2 === "function") {
              state = fn2({
                state,
                options: _options,
                name,
                instance
              }) || state;
            }
          }
        },
        // Async and optimistically optimized update – it will not be executed if
        // not necessary (debounced to run at most once-per-tick)
        update: debounce(function() {
          return new Promise(function(resolve) {
            instance.forceUpdate();
            resolve(state);
          });
        }),
        destroy: function destroy() {
          cleanupModifierEffects();
          isDestroyed = true;
        }
      };
      if (!areValidElements(reference2, popper2)) {
        return instance;
      }
      instance.setOptions(options).then(function(state2) {
        if (!isDestroyed && options.onFirstUpdate) {
          options.onFirstUpdate(state2);
        }
      });
      function runModifierEffects() {
        state.orderedModifiers.forEach(function(_ref) {
          var name = _ref.name, _ref$options = _ref.options, options2 = _ref$options === void 0 ? {} : _ref$options, effect4 = _ref.effect;
          if (typeof effect4 === "function") {
            var cleanupFn = effect4({
              state,
              name,
              instance,
              options: options2
            });
            var noopFn = function noopFn2() {
            };
            effectCleanupFns.push(cleanupFn || noopFn);
          }
        });
      }
      function cleanupModifierEffects() {
        effectCleanupFns.forEach(function(fn2) {
          return fn2();
        });
        effectCleanupFns = [];
      }
      return instance;
    };
  }

  // node_modules/@popperjs/core/lib/popper.js
  var defaultModifiers = [eventListeners_default, popperOffsets_default, computeStyles_default, applyStyles_default, offset_default, flip_default, preventOverflow_default, arrow_default, hide_default];
  var createPopper = /* @__PURE__ */ popperGenerator({
    defaultModifiers
  });

  // node_modules/flowbite/lib/esm/components/dropdown/index.js
  var __assign5 = function() {
    __assign5 = Object.assign || function(t) {
      for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s)
          if (Object.prototype.hasOwnProperty.call(s, p))
            t[p] = s[p];
      }
      return t;
    };
    return __assign5.apply(this, arguments);
  };
  var __spreadArray = function(to, from, pack) {
    if (pack || arguments.length === 2)
      for (var i = 0, l = from.length, ar; i < l; i++) {
        if (ar || !(i in from)) {
          if (!ar)
            ar = Array.prototype.slice.call(from, 0, i);
          ar[i] = from[i];
        }
      }
    return to.concat(ar || Array.prototype.slice.call(from));
  };
  var Default5 = {
    placement: "bottom",
    triggerType: "click",
    offsetSkidding: 0,
    offsetDistance: 10,
    delay: 300,
    onShow: function() {
    },
    onHide: function() {
    },
    onToggle: function() {
    }
  };
  var Dropdown = (
    /** @class */
    function() {
      function Dropdown2(targetElement, triggerElement, options) {
        if (targetElement === void 0) {
          targetElement = null;
        }
        if (triggerElement === void 0) {
          triggerElement = null;
        }
        if (options === void 0) {
          options = Default5;
        }
        this._targetEl = targetElement;
        this._triggerEl = triggerElement;
        this._options = __assign5(__assign5({}, Default5), options);
        this._popperInstance = this._createPopperInstance();
        this._visible = false;
        this._init();
      }
      Dropdown2.prototype._init = function() {
        if (this._triggerEl) {
          this._setupEventListeners();
        }
      };
      Dropdown2.prototype._setupEventListeners = function() {
        var _this = this;
        var triggerEvents = this._getTriggerEvents();
        if (this._options.triggerType === "click") {
          triggerEvents.showEvents.forEach(function(ev) {
            _this._triggerEl.addEventListener(ev, function() {
              _this.toggle();
            });
          });
        }
        if (this._options.triggerType === "hover") {
          triggerEvents.showEvents.forEach(function(ev) {
            _this._triggerEl.addEventListener(ev, function() {
              if (ev === "click") {
                _this.toggle();
              } else {
                setTimeout(function() {
                  _this.show();
                }, _this._options.delay);
              }
            });
            _this._targetEl.addEventListener(ev, function() {
              _this.show();
            });
          });
          triggerEvents.hideEvents.forEach(function(ev) {
            _this._triggerEl.addEventListener(ev, function() {
              setTimeout(function() {
                if (!_this._targetEl.matches(":hover")) {
                  _this.hide();
                }
              }, _this._options.delay);
            });
            _this._targetEl.addEventListener(ev, function() {
              setTimeout(function() {
                if (!_this._triggerEl.matches(":hover")) {
                  _this.hide();
                }
              }, _this._options.delay);
            });
          });
        }
      };
      Dropdown2.prototype._createPopperInstance = function() {
        return createPopper(this._triggerEl, this._targetEl, {
          placement: this._options.placement,
          modifiers: [
            {
              name: "offset",
              options: {
                offset: [
                  this._options.offsetSkidding,
                  this._options.offsetDistance
                ]
              }
            }
          ]
        });
      };
      Dropdown2.prototype._setupClickOutsideListener = function() {
        var _this = this;
        this._clickOutsideEventListener = function(ev) {
          _this._handleClickOutside(ev, _this._targetEl);
        };
        document.body.addEventListener("click", this._clickOutsideEventListener, true);
      };
      Dropdown2.prototype._removeClickOutsideListener = function() {
        document.body.removeEventListener("click", this._clickOutsideEventListener, true);
      };
      Dropdown2.prototype._handleClickOutside = function(ev, targetEl) {
        var clickedEl = ev.target;
        if (clickedEl !== targetEl && !targetEl.contains(clickedEl) && !this._triggerEl.contains(clickedEl) && this.isVisible()) {
          this.hide();
        }
      };
      Dropdown2.prototype._getTriggerEvents = function() {
        switch (this._options.triggerType) {
          case "hover":
            return {
              showEvents: ["mouseenter", "click"],
              hideEvents: ["mouseleave"]
            };
          case "click":
            return {
              showEvents: ["click"],
              hideEvents: []
            };
          case "none":
            return {
              showEvents: [],
              hideEvents: []
            };
          default:
            return {
              showEvents: ["click"],
              hideEvents: []
            };
        }
      };
      Dropdown2.prototype.toggle = function() {
        if (this.isVisible()) {
          this.hide();
        } else {
          this.show();
        }
        this._options.onToggle(this);
      };
      Dropdown2.prototype.isVisible = function() {
        return this._visible;
      };
      Dropdown2.prototype.show = function() {
        this._targetEl.classList.remove("hidden");
        this._targetEl.classList.add("block");
        this._popperInstance.setOptions(function(options) {
          return __assign5(__assign5({}, options), { modifiers: __spreadArray(__spreadArray([], options.modifiers, true), [
            { name: "eventListeners", enabled: true }
          ], false) });
        });
        this._setupClickOutsideListener();
        this._popperInstance.update();
        this._visible = true;
        this._options.onShow(this);
      };
      Dropdown2.prototype.hide = function() {
        this._targetEl.classList.remove("block");
        this._targetEl.classList.add("hidden");
        this._popperInstance.setOptions(function(options) {
          return __assign5(__assign5({}, options), { modifiers: __spreadArray(__spreadArray([], options.modifiers, true), [
            { name: "eventListeners", enabled: false }
          ], false) });
        });
        this._visible = false;
        this._removeClickOutsideListener();
        this._options.onHide(this);
      };
      return Dropdown2;
    }()
  );
  function initDropdowns() {
    document.querySelectorAll("[data-dropdown-toggle]").forEach(function($triggerEl) {
      var dropdownId = $triggerEl.getAttribute("data-dropdown-toggle");
      var $dropdownEl = document.getElementById(dropdownId);
      if ($dropdownEl) {
        var placement = $triggerEl.getAttribute("data-dropdown-placement");
        var offsetSkidding = $triggerEl.getAttribute("data-dropdown-offset-skidding");
        var offsetDistance = $triggerEl.getAttribute("data-dropdown-offset-distance");
        var triggerType = $triggerEl.getAttribute("data-dropdown-trigger");
        var delay = $triggerEl.getAttribute("data-dropdown-delay");
        new Dropdown($dropdownEl, $triggerEl, {
          placement: placement ? placement : Default5.placement,
          triggerType: triggerType ? triggerType : Default5.triggerType,
          offsetSkidding: offsetSkidding ? parseInt(offsetSkidding) : Default5.offsetSkidding,
          offsetDistance: offsetDistance ? parseInt(offsetDistance) : Default5.offsetDistance,
          delay: delay ? parseInt(delay) : Default5.delay
        });
      } else {
        console.error('The dropdown element with id "'.concat(dropdownId, '" does not exist. Please check the data-dropdown-toggle attribute.'));
      }
    });
  }
  if (typeof window !== "undefined") {
    window.Dropdown = Dropdown;
    window.initDropdowns = initDropdowns;
  }
  var dropdown_default = Dropdown;

  // node_modules/flowbite/lib/esm/components/modal/index.js
  var __assign6 = function() {
    __assign6 = Object.assign || function(t) {
      for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s)
          if (Object.prototype.hasOwnProperty.call(s, p))
            t[p] = s[p];
      }
      return t;
    };
    return __assign6.apply(this, arguments);
  };
  var Default6 = {
    placement: "center",
    backdropClasses: "bg-gray-900 bg-opacity-50 dark:bg-opacity-80 fixed inset-0 z-40",
    backdrop: "dynamic",
    closable: true,
    onHide: function() {
    },
    onShow: function() {
    },
    onToggle: function() {
    }
  };
  var Modal = (
    /** @class */
    function() {
      function Modal2(targetEl, options) {
        if (targetEl === void 0) {
          targetEl = null;
        }
        if (options === void 0) {
          options = Default6;
        }
        this._targetEl = targetEl;
        this._options = __assign6(__assign6({}, Default6), options);
        this._isHidden = true;
        this._backdropEl = null;
        this._init();
      }
      Modal2.prototype._init = function() {
        var _this = this;
        if (this._targetEl) {
          this._getPlacementClasses().map(function(c) {
            _this._targetEl.classList.add(c);
          });
        }
      };
      Modal2.prototype._createBackdrop = function() {
        var _a;
        if (this._isHidden) {
          var backdropEl = document.createElement("div");
          backdropEl.setAttribute("modal-backdrop", "");
          (_a = backdropEl.classList).add.apply(_a, this._options.backdropClasses.split(" "));
          document.querySelector("body").append(backdropEl);
          this._backdropEl = backdropEl;
        }
      };
      Modal2.prototype._destroyBackdropEl = function() {
        if (!this._isHidden) {
          document.querySelector("[modal-backdrop]").remove();
        }
      };
      Modal2.prototype._setupModalCloseEventListeners = function() {
        var _this = this;
        if (this._options.backdrop === "dynamic") {
          this._clickOutsideEventListener = function(ev) {
            _this._handleOutsideClick(ev.target);
          };
          this._targetEl.addEventListener("click", this._clickOutsideEventListener, true);
        }
        this._keydownEventListener = function(ev) {
          if (ev.key === "Escape") {
            _this.hide();
          }
        };
        document.body.addEventListener("keydown", this._keydownEventListener, true);
      };
      Modal2.prototype._removeModalCloseEventListeners = function() {
        if (this._options.backdrop === "dynamic") {
          this._targetEl.removeEventListener("click", this._clickOutsideEventListener, true);
        }
        document.body.removeEventListener("keydown", this._keydownEventListener, true);
      };
      Modal2.prototype._handleOutsideClick = function(target) {
        if (target === this._targetEl || target === this._backdropEl && this.isVisible()) {
          this.hide();
        }
      };
      Modal2.prototype._getPlacementClasses = function() {
        switch (this._options.placement) {
          case "top-left":
            return ["justify-start", "items-start"];
          case "top-center":
            return ["justify-center", "items-start"];
          case "top-right":
            return ["justify-end", "items-start"];
          case "center-left":
            return ["justify-start", "items-center"];
          case "center":
            return ["justify-center", "items-center"];
          case "center-right":
            return ["justify-end", "items-center"];
          case "bottom-left":
            return ["justify-start", "items-end"];
          case "bottom-center":
            return ["justify-center", "items-end"];
          case "bottom-right":
            return ["justify-end", "items-end"];
          default:
            return ["justify-center", "items-center"];
        }
      };
      Modal2.prototype.toggle = function() {
        if (this._isHidden) {
          this.show();
        } else {
          this.hide();
        }
        this._options.onToggle(this);
      };
      Modal2.prototype.show = function() {
        if (this.isHidden) {
          this._targetEl.classList.add("flex");
          this._targetEl.classList.remove("hidden");
          this._targetEl.setAttribute("aria-modal", "true");
          this._targetEl.setAttribute("role", "dialog");
          this._targetEl.removeAttribute("aria-hidden");
          this._createBackdrop();
          this._isHidden = false;
          document.body.classList.add("overflow-hidden");
          if (this._options.closable) {
            this._setupModalCloseEventListeners();
          }
          this._options.onShow(this);
        }
      };
      Modal2.prototype.hide = function() {
        if (this.isVisible) {
          this._targetEl.classList.add("hidden");
          this._targetEl.classList.remove("flex");
          this._targetEl.setAttribute("aria-hidden", "true");
          this._targetEl.removeAttribute("aria-modal");
          this._targetEl.removeAttribute("role");
          this._destroyBackdropEl();
          this._isHidden = true;
          document.body.classList.remove("overflow-hidden");
          if (this._options.closable) {
            this._removeModalCloseEventListeners();
          }
          this._options.onHide(this);
        }
      };
      Modal2.prototype.isVisible = function() {
        return !this._isHidden;
      };
      Modal2.prototype.isHidden = function() {
        return this._isHidden;
      };
      return Modal2;
    }()
  );
  var getModalInstance = function(id, instances) {
    if (instances.some(function(modalInstance) {
      return modalInstance.id === id;
    })) {
      return instances.find(function(modalInstance) {
        return modalInstance.id === id;
      });
    }
    return null;
  };
  function initModals() {
    var modalInstances = [];
    document.querySelectorAll("[data-modal-target]").forEach(function($triggerEl) {
      var modalId = $triggerEl.getAttribute("data-modal-target");
      var $modalEl = document.getElementById(modalId);
      if ($modalEl) {
        var placement = $modalEl.getAttribute("data-modal-placement");
        var backdrop = $modalEl.getAttribute("data-modal-backdrop");
        if (!getModalInstance(modalId, modalInstances)) {
          modalInstances.push({
            id: modalId,
            object: new Modal($modalEl, {
              placement: placement ? placement : Default6.placement,
              backdrop: backdrop ? backdrop : Default6.backdrop
            })
          });
        }
      } else {
        console.error("Modal with id ".concat(modalId, " does not exist. Are you sure that the data-modal-target attribute points to the correct modal id?."));
      }
    });
    document.querySelectorAll("[data-modal-toggle]").forEach(function($triggerEl) {
      var modalId = $triggerEl.getAttribute("data-modal-toggle");
      var $modalEl = document.getElementById(modalId);
      if ($modalEl) {
        var placement = $modalEl.getAttribute("data-modal-placement");
        var backdrop = $modalEl.getAttribute("data-modal-backdrop");
        var modal_1 = getModalInstance(modalId, modalInstances);
        if (!modal_1) {
          modal_1 = {
            id: modalId,
            object: new Modal($modalEl, {
              placement: placement ? placement : Default6.placement,
              backdrop: backdrop ? backdrop : Default6.backdrop
            })
          };
          modalInstances.push(modal_1);
        }
        $triggerEl.addEventListener("click", function() {
          modal_1.object.toggle();
        });
      } else {
        console.error("Modal with id ".concat(modalId, " does not exist. Are you sure that the data-modal-toggle attribute points to the correct modal id?"));
      }
    });
    document.querySelectorAll("[data-modal-show]").forEach(function($triggerEl) {
      var modalId = $triggerEl.getAttribute("data-modal-show");
      var $modalEl = document.getElementById(modalId);
      if ($modalEl) {
        var modal_2 = getModalInstance(modalId, modalInstances);
        if (modal_2) {
          $triggerEl.addEventListener("click", function() {
            if (modal_2.object.isHidden) {
              modal_2.object.show();
            }
          });
        } else {
          console.error("Modal with id ".concat(modalId, " has not been initialized. Please initialize it using the data-modal-target attribute."));
        }
      } else {
        console.error("Modal with id ".concat(modalId, " does not exist. Are you sure that the data-modal-show attribute points to the correct modal id?"));
      }
    });
    document.querySelectorAll("[data-modal-hide]").forEach(function($triggerEl) {
      var modalId = $triggerEl.getAttribute("data-modal-hide");
      var $modalEl = document.getElementById(modalId);
      if ($modalEl) {
        var modal_3 = getModalInstance(modalId, modalInstances);
        if (modal_3) {
          $triggerEl.addEventListener("click", function() {
            if (modal_3.object.isVisible) {
              modal_3.object.hide();
            }
          });
        } else {
          console.error("Modal with id ".concat(modalId, " has not been initialized. Please initialize it using the data-modal-target attribute."));
        }
      } else {
        console.error("Modal with id ".concat(modalId, " does not exist. Are you sure that the data-modal-hide attribute points to the correct modal id?"));
      }
    });
  }
  if (typeof window !== "undefined") {
    window.Modal = Modal;
    window.initModals = initModals;
  }

  // node_modules/flowbite/lib/esm/components/drawer/index.js
  var __assign7 = function() {
    __assign7 = Object.assign || function(t) {
      for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s)
          if (Object.prototype.hasOwnProperty.call(s, p))
            t[p] = s[p];
      }
      return t;
    };
    return __assign7.apply(this, arguments);
  };
  var Default7 = {
    placement: "left",
    bodyScrolling: false,
    backdrop: true,
    edge: false,
    edgeOffset: "bottom-[60px]",
    backdropClasses: "bg-gray-900 bg-opacity-50 dark:bg-opacity-80 fixed inset-0 z-30",
    onShow: function() {
    },
    onHide: function() {
    },
    onToggle: function() {
    }
  };
  var Drawer = (
    /** @class */
    function() {
      function Drawer2(targetEl, options) {
        if (targetEl === void 0) {
          targetEl = null;
        }
        if (options === void 0) {
          options = Default7;
        }
        this._targetEl = targetEl;
        this._options = __assign7(__assign7({}, Default7), options);
        this._visible = false;
        this._init();
      }
      Drawer2.prototype._init = function() {
        var _this = this;
        if (this._targetEl) {
          this._targetEl.setAttribute("aria-hidden", "true");
          this._targetEl.classList.add("transition-transform");
        }
        this._getPlacementClasses(this._options.placement).base.map(function(c) {
          _this._targetEl.classList.add(c);
        });
        document.addEventListener("keydown", function(event) {
          if (event.key === "Escape") {
            if (_this.isVisible()) {
              _this.hide();
            }
          }
        });
      };
      Drawer2.prototype.hide = function() {
        var _this = this;
        if (this._options.edge) {
          this._getPlacementClasses(this._options.placement + "-edge").active.map(function(c) {
            _this._targetEl.classList.remove(c);
          });
          this._getPlacementClasses(this._options.placement + "-edge").inactive.map(function(c) {
            _this._targetEl.classList.add(c);
          });
        } else {
          this._getPlacementClasses(this._options.placement).active.map(function(c) {
            _this._targetEl.classList.remove(c);
          });
          this._getPlacementClasses(this._options.placement).inactive.map(function(c) {
            _this._targetEl.classList.add(c);
          });
        }
        this._targetEl.setAttribute("aria-hidden", "true");
        this._targetEl.removeAttribute("aria-modal");
        this._targetEl.removeAttribute("role");
        if (!this._options.bodyScrolling) {
          document.body.classList.remove("overflow-hidden");
        }
        if (this._options.backdrop) {
          this._destroyBackdropEl();
        }
        this._visible = false;
        this._options.onHide(this);
      };
      Drawer2.prototype.show = function() {
        var _this = this;
        if (this._options.edge) {
          this._getPlacementClasses(this._options.placement + "-edge").active.map(function(c) {
            _this._targetEl.classList.add(c);
          });
          this._getPlacementClasses(this._options.placement + "-edge").inactive.map(function(c) {
            _this._targetEl.classList.remove(c);
          });
        } else {
          this._getPlacementClasses(this._options.placement).active.map(function(c) {
            _this._targetEl.classList.add(c);
          });
          this._getPlacementClasses(this._options.placement).inactive.map(function(c) {
            _this._targetEl.classList.remove(c);
          });
        }
        this._targetEl.setAttribute("aria-modal", "true");
        this._targetEl.setAttribute("role", "dialog");
        this._targetEl.removeAttribute("aria-hidden");
        if (!this._options.bodyScrolling) {
          document.body.classList.add("overflow-hidden");
        }
        if (this._options.backdrop) {
          this._createBackdrop();
        }
        this._visible = true;
        this._options.onShow(this);
      };
      Drawer2.prototype.toggle = function() {
        if (this.isVisible()) {
          this.hide();
        } else {
          this.show();
        }
      };
      Drawer2.prototype._createBackdrop = function() {
        var _a;
        var _this = this;
        if (!this._visible) {
          var backdropEl = document.createElement("div");
          backdropEl.setAttribute("drawer-backdrop", "");
          (_a = backdropEl.classList).add.apply(_a, this._options.backdropClasses.split(" "));
          document.querySelector("body").append(backdropEl);
          backdropEl.addEventListener("click", function() {
            _this.hide();
          });
        }
      };
      Drawer2.prototype._destroyBackdropEl = function() {
        if (this._visible) {
          document.querySelector("[drawer-backdrop]").remove();
        }
      };
      Drawer2.prototype._getPlacementClasses = function(placement) {
        switch (placement) {
          case "top":
            return {
              base: ["top-0", "left-0", "right-0"],
              active: ["transform-none"],
              inactive: ["-translate-y-full"]
            };
          case "right":
            return {
              base: ["right-0", "top-0"],
              active: ["transform-none"],
              inactive: ["translate-x-full"]
            };
          case "bottom":
            return {
              base: ["bottom-0", "left-0", "right-0"],
              active: ["transform-none"],
              inactive: ["translate-y-full"]
            };
          case "left":
            return {
              base: ["left-0", "top-0"],
              active: ["transform-none"],
              inactive: ["-translate-x-full"]
            };
          case "bottom-edge":
            return {
              base: ["left-0", "top-0"],
              active: ["transform-none"],
              inactive: ["translate-y-full", this._options.edgeOffset]
            };
          default:
            return {
              base: ["left-0", "top-0"],
              active: ["transform-none"],
              inactive: ["-translate-x-full"]
            };
        }
      };
      Drawer2.prototype.isHidden = function() {
        return !this._visible;
      };
      Drawer2.prototype.isVisible = function() {
        return this._visible;
      };
      return Drawer2;
    }()
  );
  var getDrawerInstance = function(id, instances) {
    if (instances.some(function(drawerInstance) {
      return drawerInstance.id === id;
    })) {
      return instances.find(function(drawerInstance) {
        return drawerInstance.id === id;
      });
    }
  };
  function initDrawers() {
    var drawerInstances = [];
    document.querySelectorAll("[data-drawer-target]").forEach(function($triggerEl) {
      var drawerId = $triggerEl.getAttribute("data-drawer-target");
      var $drawerEl = document.getElementById(drawerId);
      if ($drawerEl) {
        var placement = $triggerEl.getAttribute("data-drawer-placement");
        var bodyScrolling = $triggerEl.getAttribute("data-drawer-body-scrolling");
        var backdrop = $triggerEl.getAttribute("data-drawer-backdrop");
        var edge = $triggerEl.getAttribute("data-drawer-edge");
        var edgeOffset = $triggerEl.getAttribute("data-drawer-edge-offset");
        if (!getDrawerInstance(drawerId, drawerInstances)) {
          drawerInstances.push({
            id: drawerId,
            object: new Drawer($drawerEl, {
              placement: placement ? placement : Default7.placement,
              bodyScrolling: bodyScrolling ? bodyScrolling === "true" ? true : false : Default7.bodyScrolling,
              backdrop: backdrop ? backdrop === "true" ? true : false : Default7.backdrop,
              edge: edge ? edge === "true" ? true : false : Default7.edge,
              edgeOffset: edgeOffset ? edgeOffset : Default7.edgeOffset
            })
          });
        }
      } else {
        console.error("Drawer with id ".concat(drawerId, " not found. Are you sure that the data-drawer-target attribute points to the correct drawer id?"));
      }
    });
    document.querySelectorAll("[data-drawer-toggle]").forEach(function($triggerEl) {
      var drawerId = $triggerEl.getAttribute("data-drawer-toggle");
      var $drawerEl = document.getElementById(drawerId);
      if ($drawerEl) {
        var drawer_1 = getDrawerInstance(drawerId, drawerInstances);
        if (drawer_1) {
          $triggerEl.addEventListener("click", function() {
            drawer_1.object.toggle();
          });
        } else {
          console.error("Drawer with id ".concat(drawerId, " has not been initialized. Please initialize it using the data-drawer-target attribute."));
        }
      } else {
        console.error("Drawer with id ".concat(drawerId, " not found. Are you sure that the data-drawer-target attribute points to the correct drawer id?"));
      }
    });
    document.querySelectorAll("[data-drawer-dismiss], [data-drawer-hide]").forEach(function($triggerEl) {
      var drawerId = $triggerEl.getAttribute("data-drawer-dismiss") ? $triggerEl.getAttribute("data-drawer-dismiss") : $triggerEl.getAttribute("data-drawer-hide");
      var $drawerEl = document.getElementById(drawerId);
      if ($drawerEl) {
        var drawer_2 = getDrawerInstance(drawerId, drawerInstances);
        if (drawer_2) {
          $triggerEl.addEventListener("click", function() {
            drawer_2.object.hide();
          });
        } else {
          console.error("Drawer with id ".concat(drawerId, " has not been initialized. Please initialize it using the data-drawer-target attribute."));
        }
      } else {
        console.error("Drawer with id ".concat(drawerId, " not found. Are you sure that the data-drawer-target attribute points to the correct drawer id"));
      }
    });
    document.querySelectorAll("[data-drawer-show]").forEach(function($triggerEl) {
      var drawerId = $triggerEl.getAttribute("data-drawer-show");
      var $drawerEl = document.getElementById(drawerId);
      if ($drawerEl) {
        var drawer_3 = getDrawerInstance(drawerId, drawerInstances);
        if (drawer_3) {
          $triggerEl.addEventListener("click", function() {
            drawer_3.object.show();
          });
        } else {
          console.error("Drawer with id ".concat(drawerId, " has not been initialized. Please initialize it using the data-drawer-target attribute."));
        }
      } else {
        console.error("Drawer with id ".concat(drawerId, " not found. Are you sure that the data-drawer-target attribute points to the correct drawer id?"));
      }
    });
  }
  if (typeof window !== "undefined") {
    window.Drawer = Drawer;
    window.initDrawers = initDrawers;
  }

  // node_modules/flowbite/lib/esm/components/tabs/index.js
  var __assign8 = function() {
    __assign8 = Object.assign || function(t) {
      for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s)
          if (Object.prototype.hasOwnProperty.call(s, p))
            t[p] = s[p];
      }
      return t;
    };
    return __assign8.apply(this, arguments);
  };
  var Default8 = {
    defaultTabId: null,
    activeClasses: "text-blue-600 hover:text-blue-600 dark:text-blue-500 dark:hover:text-blue-500 border-blue-600 dark:border-blue-500",
    inactiveClasses: "dark:border-transparent text-gray-500 hover:text-gray-600 dark:text-gray-400 border-gray-100 hover:border-gray-300 dark:border-gray-700 dark:hover:text-gray-300",
    onShow: function() {
    }
  };
  var Tabs = (
    /** @class */
    function() {
      function Tabs2(items, options) {
        if (items === void 0) {
          items = [];
        }
        if (options === void 0) {
          options = Default8;
        }
        this._items = items;
        this._activeTab = options ? this.getTab(options.defaultTabId) : null;
        this._options = __assign8(__assign8({}, Default8), options);
        this._init();
      }
      Tabs2.prototype._init = function() {
        var _this = this;
        if (this._items.length) {
          if (!this._activeTab) {
            this._setActiveTab(this._items[0]);
          }
          this.show(this._activeTab.id, true);
          this._items.map(function(tab) {
            tab.triggerEl.addEventListener("click", function() {
              _this.show(tab.id);
            });
          });
        }
      };
      Tabs2.prototype.getActiveTab = function() {
        return this._activeTab;
      };
      Tabs2.prototype._setActiveTab = function(tab) {
        this._activeTab = tab;
      };
      Tabs2.prototype.getTab = function(id) {
        return this._items.filter(function(t) {
          return t.id === id;
        })[0];
      };
      Tabs2.prototype.show = function(id, forceShow) {
        var _a, _b;
        var _this = this;
        if (forceShow === void 0) {
          forceShow = false;
        }
        var tab = this.getTab(id);
        if (tab === this._activeTab && !forceShow) {
          return;
        }
        this._items.map(function(t) {
          var _a2, _b2;
          if (t !== tab) {
            (_a2 = t.triggerEl.classList).remove.apply(_a2, _this._options.activeClasses.split(" "));
            (_b2 = t.triggerEl.classList).add.apply(_b2, _this._options.inactiveClasses.split(" "));
            t.targetEl.classList.add("hidden");
            t.triggerEl.setAttribute("aria-selected", "false");
          }
        });
        (_a = tab.triggerEl.classList).add.apply(_a, this._options.activeClasses.split(" "));
        (_b = tab.triggerEl.classList).remove.apply(_b, this._options.inactiveClasses.split(" "));
        tab.triggerEl.setAttribute("aria-selected", "true");
        tab.targetEl.classList.remove("hidden");
        this._setActiveTab(tab);
        this._options.onShow(this, tab);
      };
      return Tabs2;
    }()
  );
  function initTabs() {
    document.querySelectorAll("[data-tabs-toggle]").forEach(function($triggerEl) {
      var tabItems = [];
      var defaultTabId = null;
      $triggerEl.querySelectorAll('[role="tab"]').forEach(function($triggerEl2) {
        var isActive = $triggerEl2.getAttribute("aria-selected") === "true";
        var tab = {
          id: $triggerEl2.getAttribute("data-tabs-target"),
          triggerEl: $triggerEl2,
          targetEl: document.querySelector($triggerEl2.getAttribute("data-tabs-target"))
        };
        tabItems.push(tab);
        if (isActive) {
          defaultTabId = tab.id;
        }
      });
      new Tabs(tabItems, {
        defaultTabId
      });
    });
  }
  if (typeof window !== "undefined") {
    window.Tabs = Tabs;
    window.initTabs = initTabs;
  }

  // node_modules/flowbite/lib/esm/components/tooltip/index.js
  var __assign9 = function() {
    __assign9 = Object.assign || function(t) {
      for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s)
          if (Object.prototype.hasOwnProperty.call(s, p))
            t[p] = s[p];
      }
      return t;
    };
    return __assign9.apply(this, arguments);
  };
  var __spreadArray2 = function(to, from, pack) {
    if (pack || arguments.length === 2)
      for (var i = 0, l = from.length, ar; i < l; i++) {
        if (ar || !(i in from)) {
          if (!ar)
            ar = Array.prototype.slice.call(from, 0, i);
          ar[i] = from[i];
        }
      }
    return to.concat(ar || Array.prototype.slice.call(from));
  };
  var Default9 = {
    placement: "top",
    triggerType: "hover",
    onShow: function() {
    },
    onHide: function() {
    },
    onToggle: function() {
    }
  };
  var Tooltip = (
    /** @class */
    function() {
      function Tooltip2(targetEl, triggerEl, options) {
        if (targetEl === void 0) {
          targetEl = null;
        }
        if (triggerEl === void 0) {
          triggerEl = null;
        }
        if (options === void 0) {
          options = Default9;
        }
        this._targetEl = targetEl;
        this._triggerEl = triggerEl;
        this._options = __assign9(__assign9({}, Default9), options);
        this._popperInstance = this._createPopperInstance();
        this._visible = false;
        this._init();
      }
      Tooltip2.prototype._init = function() {
        if (this._triggerEl) {
          this._setupEventListeners();
        }
      };
      Tooltip2.prototype._setupEventListeners = function() {
        var _this = this;
        var triggerEvents = this._getTriggerEvents();
        triggerEvents.showEvents.forEach(function(ev) {
          _this._triggerEl.addEventListener(ev, function() {
            _this.show();
          });
        });
        triggerEvents.hideEvents.forEach(function(ev) {
          _this._triggerEl.addEventListener(ev, function() {
            _this.hide();
          });
        });
      };
      Tooltip2.prototype._createPopperInstance = function() {
        return createPopper(this._triggerEl, this._targetEl, {
          placement: this._options.placement,
          modifiers: [
            {
              name: "offset",
              options: {
                offset: [0, 8]
              }
            }
          ]
        });
      };
      Tooltip2.prototype._getTriggerEvents = function() {
        switch (this._options.triggerType) {
          case "hover":
            return {
              showEvents: ["mouseenter", "focus"],
              hideEvents: ["mouseleave", "blur"]
            };
          case "click":
            return {
              showEvents: ["click", "focus"],
              hideEvents: ["focusout", "blur"]
            };
          case "none":
            return {
              showEvents: [],
              hideEvents: []
            };
          default:
            return {
              showEvents: ["mouseenter", "focus"],
              hideEvents: ["mouseleave", "blur"]
            };
        }
      };
      Tooltip2.prototype._setupKeydownListener = function() {
        var _this = this;
        this._keydownEventListener = function(ev) {
          if (ev.key === "Escape") {
            _this.hide();
          }
        };
        document.body.addEventListener("keydown", this._keydownEventListener, true);
      };
      Tooltip2.prototype._removeKeydownListener = function() {
        document.body.removeEventListener("keydown", this._keydownEventListener, true);
      };
      Tooltip2.prototype._setupClickOutsideListener = function() {
        var _this = this;
        this._clickOutsideEventListener = function(ev) {
          _this._handleClickOutside(ev, _this._targetEl);
        };
        document.body.addEventListener("click", this._clickOutsideEventListener, true);
      };
      Tooltip2.prototype._removeClickOutsideListener = function() {
        document.body.removeEventListener("click", this._clickOutsideEventListener, true);
      };
      Tooltip2.prototype._handleClickOutside = function(ev, targetEl) {
        var clickedEl = ev.target;
        if (clickedEl !== targetEl && !targetEl.contains(clickedEl) && !this._triggerEl.contains(clickedEl) && this.isVisible()) {
          this.hide();
        }
      };
      Tooltip2.prototype.isVisible = function() {
        return this._visible;
      };
      Tooltip2.prototype.toggle = function() {
        if (this.isVisible()) {
          this.hide();
        } else {
          this.show();
        }
      };
      Tooltip2.prototype.show = function() {
        this._targetEl.classList.remove("opacity-0", "invisible");
        this._targetEl.classList.add("opacity-100", "visible");
        this._popperInstance.setOptions(function(options) {
          return __assign9(__assign9({}, options), { modifiers: __spreadArray2(__spreadArray2([], options.modifiers, true), [
            { name: "eventListeners", enabled: true }
          ], false) });
        });
        this._setupClickOutsideListener();
        this._setupKeydownListener();
        this._popperInstance.update();
        this._visible = true;
        this._options.onShow(this);
      };
      Tooltip2.prototype.hide = function() {
        this._targetEl.classList.remove("opacity-100", "visible");
        this._targetEl.classList.add("opacity-0", "invisible");
        this._popperInstance.setOptions(function(options) {
          return __assign9(__assign9({}, options), { modifiers: __spreadArray2(__spreadArray2([], options.modifiers, true), [
            { name: "eventListeners", enabled: false }
          ], false) });
        });
        this._removeClickOutsideListener();
        this._removeKeydownListener();
        this._visible = false;
        this._options.onHide(this);
      };
      return Tooltip2;
    }()
  );
  function initTooltips() {
    document.querySelectorAll("[data-tooltip-target]").forEach(function($triggerEl) {
      var tooltipId = $triggerEl.getAttribute("data-tooltip-target");
      var $tooltipEl = document.getElementById(tooltipId);
      if ($tooltipEl) {
        var triggerType = $triggerEl.getAttribute("data-tooltip-trigger");
        var placement = $triggerEl.getAttribute("data-tooltip-placement");
        new Tooltip($tooltipEl, $triggerEl, {
          placement: placement ? placement : Default9.placement,
          triggerType: triggerType ? triggerType : Default9.triggerType
        });
      } else {
        console.error('The tooltip element with id "'.concat(tooltipId, '" does not exist. Please check the data-tooltip-target attribute.'));
      }
    });
  }
  if (typeof window !== "undefined") {
    window.Tooltip = Tooltip;
    window.initTooltips = initTooltips;
  }

  // node_modules/flowbite/lib/esm/components/popover/index.js
  var __assign10 = function() {
    __assign10 = Object.assign || function(t) {
      for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s)
          if (Object.prototype.hasOwnProperty.call(s, p))
            t[p] = s[p];
      }
      return t;
    };
    return __assign10.apply(this, arguments);
  };
  var __spreadArray3 = function(to, from, pack) {
    if (pack || arguments.length === 2)
      for (var i = 0, l = from.length, ar; i < l; i++) {
        if (ar || !(i in from)) {
          if (!ar)
            ar = Array.prototype.slice.call(from, 0, i);
          ar[i] = from[i];
        }
      }
    return to.concat(ar || Array.prototype.slice.call(from));
  };
  var Default10 = {
    placement: "top",
    offset: 10,
    triggerType: "hover",
    onShow: function() {
    },
    onHide: function() {
    },
    onToggle: function() {
    }
  };
  var Popover = (
    /** @class */
    function() {
      function Popover2(targetEl, triggerEl, options) {
        if (targetEl === void 0) {
          targetEl = null;
        }
        if (triggerEl === void 0) {
          triggerEl = null;
        }
        if (options === void 0) {
          options = Default10;
        }
        this._targetEl = targetEl;
        this._triggerEl = triggerEl;
        this._options = __assign10(__assign10({}, Default10), options);
        this._popperInstance = this._createPopperInstance();
        this._visible = false;
        this._init();
      }
      Popover2.prototype._init = function() {
        if (this._triggerEl) {
          this._setupEventListeners();
        }
      };
      Popover2.prototype._setupEventListeners = function() {
        var _this = this;
        var triggerEvents = this._getTriggerEvents();
        triggerEvents.showEvents.forEach(function(ev) {
          _this._triggerEl.addEventListener(ev, function() {
            _this.show();
          });
          _this._targetEl.addEventListener(ev, function() {
            _this.show();
          });
        });
        triggerEvents.hideEvents.forEach(function(ev) {
          _this._triggerEl.addEventListener(ev, function() {
            setTimeout(function() {
              if (!_this._targetEl.matches(":hover")) {
                _this.hide();
              }
            }, 100);
          });
          _this._targetEl.addEventListener(ev, function() {
            setTimeout(function() {
              if (!_this._triggerEl.matches(":hover")) {
                _this.hide();
              }
            }, 100);
          });
        });
      };
      Popover2.prototype._createPopperInstance = function() {
        return createPopper(this._triggerEl, this._targetEl, {
          placement: this._options.placement,
          modifiers: [
            {
              name: "offset",
              options: {
                offset: [0, this._options.offset]
              }
            }
          ]
        });
      };
      Popover2.prototype._getTriggerEvents = function() {
        switch (this._options.triggerType) {
          case "hover":
            return {
              showEvents: ["mouseenter", "focus"],
              hideEvents: ["mouseleave", "blur"]
            };
          case "click":
            return {
              showEvents: ["click", "focus"],
              hideEvents: ["focusout", "blur"]
            };
          case "none":
            return {
              showEvents: [],
              hideEvents: []
            };
          default:
            return {
              showEvents: ["mouseenter", "focus"],
              hideEvents: ["mouseleave", "blur"]
            };
        }
      };
      Popover2.prototype._setupKeydownListener = function() {
        var _this = this;
        this._keydownEventListener = function(ev) {
          if (ev.key === "Escape") {
            _this.hide();
          }
        };
        document.body.addEventListener("keydown", this._keydownEventListener, true);
      };
      Popover2.prototype._removeKeydownListener = function() {
        document.body.removeEventListener("keydown", this._keydownEventListener, true);
      };
      Popover2.prototype._setupClickOutsideListener = function() {
        var _this = this;
        this._clickOutsideEventListener = function(ev) {
          _this._handleClickOutside(ev, _this._targetEl);
        };
        document.body.addEventListener("click", this._clickOutsideEventListener, true);
      };
      Popover2.prototype._removeClickOutsideListener = function() {
        document.body.removeEventListener("click", this._clickOutsideEventListener, true);
      };
      Popover2.prototype._handleClickOutside = function(ev, targetEl) {
        var clickedEl = ev.target;
        if (clickedEl !== targetEl && !targetEl.contains(clickedEl) && !this._triggerEl.contains(clickedEl) && this.isVisible()) {
          this.hide();
        }
      };
      Popover2.prototype.isVisible = function() {
        return this._visible;
      };
      Popover2.prototype.toggle = function() {
        if (this.isVisible()) {
          this.hide();
        } else {
          this.show();
        }
        this._options.onToggle(this);
      };
      Popover2.prototype.show = function() {
        this._targetEl.classList.remove("opacity-0", "invisible");
        this._targetEl.classList.add("opacity-100", "visible");
        this._popperInstance.setOptions(function(options) {
          return __assign10(__assign10({}, options), { modifiers: __spreadArray3(__spreadArray3([], options.modifiers, true), [
            { name: "eventListeners", enabled: true }
          ], false) });
        });
        this._setupClickOutsideListener();
        this._setupKeydownListener();
        this._popperInstance.update();
        this._visible = true;
        this._options.onShow(this);
      };
      Popover2.prototype.hide = function() {
        this._targetEl.classList.remove("opacity-100", "visible");
        this._targetEl.classList.add("opacity-0", "invisible");
        this._popperInstance.setOptions(function(options) {
          return __assign10(__assign10({}, options), { modifiers: __spreadArray3(__spreadArray3([], options.modifiers, true), [
            { name: "eventListeners", enabled: false }
          ], false) });
        });
        this._removeClickOutsideListener();
        this._removeKeydownListener();
        this._visible = false;
        this._options.onHide(this);
      };
      return Popover2;
    }()
  );
  function initPopovers() {
    document.querySelectorAll("[data-popover-target]").forEach(function($triggerEl) {
      var popoverID = $triggerEl.getAttribute("data-popover-target");
      var $popoverEl = document.getElementById(popoverID);
      if ($popoverEl) {
        var triggerType = $triggerEl.getAttribute("data-popover-trigger");
        var placement = $triggerEl.getAttribute("data-popover-placement");
        var offset2 = $triggerEl.getAttribute("data-popover-offset");
        new Popover($popoverEl, $triggerEl, {
          placement: placement ? placement : Default10.placement,
          offset: offset2 ? parseInt(offset2) : Default10.offset,
          triggerType: triggerType ? triggerType : Default10.triggerType
        });
      } else {
        console.error('The popover element with id "'.concat(popoverID, '" does not exist. Please check the data-popover-target attribute.'));
      }
    });
  }
  if (typeof window !== "undefined") {
    window.Popover = Popover;
    window.initPopovers = initPopovers;
  }

  // node_modules/flowbite/lib/esm/components/dial/index.js
  var __assign11 = function() {
    __assign11 = Object.assign || function(t) {
      for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s)
          if (Object.prototype.hasOwnProperty.call(s, p))
            t[p] = s[p];
      }
      return t;
    };
    return __assign11.apply(this, arguments);
  };
  var Default11 = {
    triggerType: "hover",
    onShow: function() {
    },
    onHide: function() {
    },
    onToggle: function() {
    }
  };
  var Dial = (
    /** @class */
    function() {
      function Dial2(parentEl, triggerEl, targetEl, options) {
        if (parentEl === void 0) {
          parentEl = null;
        }
        if (triggerEl === void 0) {
          triggerEl = null;
        }
        if (targetEl === void 0) {
          targetEl = null;
        }
        if (options === void 0) {
          options = Default11;
        }
        this._parentEl = parentEl;
        this._triggerEl = triggerEl;
        this._targetEl = targetEl;
        this._options = __assign11(__assign11({}, Default11), options);
        this._visible = false;
        this._init();
      }
      Dial2.prototype._init = function() {
        var _this = this;
        if (this._triggerEl) {
          var triggerEventTypes = this._getTriggerEventTypes(this._options.triggerType);
          triggerEventTypes.showEvents.forEach(function(ev) {
            _this._triggerEl.addEventListener(ev, function() {
              _this.show();
            });
            _this._targetEl.addEventListener(ev, function() {
              _this.show();
            });
          });
          triggerEventTypes.hideEvents.forEach(function(ev) {
            _this._parentEl.addEventListener(ev, function() {
              if (!_this._parentEl.matches(":hover")) {
                _this.hide();
              }
            });
          });
        }
      };
      Dial2.prototype.hide = function() {
        this._targetEl.classList.add("hidden");
        if (this._triggerEl) {
          this._triggerEl.setAttribute("aria-expanded", "false");
        }
        this._visible = false;
        this._options.onHide(this);
      };
      Dial2.prototype.show = function() {
        this._targetEl.classList.remove("hidden");
        if (this._triggerEl) {
          this._triggerEl.setAttribute("aria-expanded", "true");
        }
        this._visible = true;
        this._options.onShow(this);
      };
      Dial2.prototype.toggle = function() {
        if (this._visible) {
          this.hide();
        } else {
          this.show();
        }
      };
      Dial2.prototype.isHidden = function() {
        return !this._visible;
      };
      Dial2.prototype.isVisible = function() {
        return this._visible;
      };
      Dial2.prototype._getTriggerEventTypes = function(triggerType) {
        switch (triggerType) {
          case "hover":
            return {
              showEvents: ["mouseenter", "focus"],
              hideEvents: ["mouseleave", "blur"]
            };
          case "click":
            return {
              showEvents: ["click", "focus"],
              hideEvents: ["focusout", "blur"]
            };
          case "none":
            return {
              showEvents: [],
              hideEvents: []
            };
          default:
            return {
              showEvents: ["mouseenter", "focus"],
              hideEvents: ["mouseleave", "blur"]
            };
        }
      };
      return Dial2;
    }()
  );
  function initDials() {
    document.querySelectorAll("[data-dial-init]").forEach(function($parentEl) {
      var $triggerEl = $parentEl.querySelector("[data-dial-toggle]");
      if ($triggerEl) {
        var dialId = $triggerEl.getAttribute("data-dial-toggle");
        var $dialEl = document.getElementById(dialId);
        if ($dialEl) {
          var triggerType = $triggerEl.getAttribute("data-dial-trigger");
          new Dial($parentEl, $triggerEl, $dialEl, {
            triggerType: triggerType ? triggerType : Default11.triggerType
          });
        } else {
          console.error("Dial with id ".concat(dialId, " does not exist. Are you sure that the data-dial-toggle attribute points to the correct modal id?"));
        }
      } else {
        console.error("Dial with id ".concat($parentEl.id, " does not have a trigger element. Are you sure that the data-dial-toggle attribute exists?"));
      }
    });
  }
  if (typeof window !== "undefined") {
    window.Dial = Dial;
    window.initDials = initDials;
  }

  // node_modules/flowbite/lib/esm/components/index.js
  function initFlowbite() {
    initAccordions();
    initCollapses();
    initCarousels();
    initDismisses();
    initDropdowns();
    initModals();
    initDrawers();
    initTabs();
    initTooltips();
    initPopovers();
    initDials();
  }
  if (typeof window !== "undefined") {
    window.initFlowbite = initFlowbite;
  }

  // node_modules/flowbite/lib/esm/index.js
  var events = new events_default("load", [
    initAccordions,
    initCollapses,
    initCarousels,
    initDismisses,
    initDropdowns,
    initModals,
    initDrawers,
    initTabs,
    initTooltips,
    initPopovers,
    initDials
  ]);
  events.init();

  // node_modules/tailwind-merge/dist/lib/tw-join.mjs
  function twJoin() {
    var index = 0;
    var argument;
    var resolvedValue;
    var string = "";
    while (index < arguments.length) {
      if (argument = arguments[index++]) {
        if (resolvedValue = toValue(argument)) {
          string && (string += " ");
          string += resolvedValue;
        }
      }
    }
    return string;
  }
  function toValue(mix) {
    if (typeof mix === "string") {
      return mix;
    }
    var resolvedValue;
    var string = "";
    for (var k = 0; k < mix.length; k++) {
      if (mix[k]) {
        if (resolvedValue = toValue(mix[k])) {
          string && (string += " ");
          string += resolvedValue;
        }
      }
    }
    return string;
  }

  // node_modules/tailwind-merge/dist/lib/class-utils.mjs
  var CLASS_PART_SEPARATOR = "-";
  function createClassUtils(config) {
    var classMap = createClassMap(config);
    var conflictingClassGroups = config.conflictingClassGroups, _config$conflictingCl = config.conflictingClassGroupModifiers, conflictingClassGroupModifiers = _config$conflictingCl === void 0 ? {} : _config$conflictingCl;
    function getClassGroupId(className) {
      var classParts = className.split(CLASS_PART_SEPARATOR);
      if (classParts[0] === "" && classParts.length !== 1) {
        classParts.shift();
      }
      return getGroupRecursive(classParts, classMap) || getGroupIdForArbitraryProperty(className);
    }
    function getConflictingClassGroupIds(classGroupId, hasPostfixModifier) {
      var conflicts = conflictingClassGroups[classGroupId] || [];
      if (hasPostfixModifier && conflictingClassGroupModifiers[classGroupId]) {
        return [].concat(conflicts, conflictingClassGroupModifiers[classGroupId]);
      }
      return conflicts;
    }
    return {
      getClassGroupId,
      getConflictingClassGroupIds
    };
  }
  function getGroupRecursive(classParts, classPartObject) {
    if (classParts.length === 0) {
      return classPartObject.classGroupId;
    }
    var currentClassPart = classParts[0];
    var nextClassPartObject = classPartObject.nextPart.get(currentClassPart);
    var classGroupFromNextClassPart = nextClassPartObject ? getGroupRecursive(classParts.slice(1), nextClassPartObject) : void 0;
    if (classGroupFromNextClassPart) {
      return classGroupFromNextClassPart;
    }
    if (classPartObject.validators.length === 0) {
      return void 0;
    }
    var classRest = classParts.join(CLASS_PART_SEPARATOR);
    return classPartObject.validators.find(function(_ref) {
      var validator = _ref.validator;
      return validator(classRest);
    })?.classGroupId;
  }
  var arbitraryPropertyRegex = /^\[(.+)\]$/;
  function getGroupIdForArbitraryProperty(className) {
    if (arbitraryPropertyRegex.test(className)) {
      var arbitraryPropertyClassName = arbitraryPropertyRegex.exec(className)[1];
      var property = arbitraryPropertyClassName?.substring(0, arbitraryPropertyClassName.indexOf(":"));
      if (property) {
        return "arbitrary.." + property;
      }
    }
  }
  function createClassMap(config) {
    var theme = config.theme, prefix = config.prefix;
    var classMap = {
      nextPart: /* @__PURE__ */ new Map(),
      validators: []
    };
    var prefixedClassGroupEntries = getPrefixedClassGroupEntries(Object.entries(config.classGroups), prefix);
    prefixedClassGroupEntries.forEach(function(_ref2) {
      var classGroupId = _ref2[0], classGroup = _ref2[1];
      processClassesRecursively(classGroup, classMap, classGroupId, theme);
    });
    return classMap;
  }
  function processClassesRecursively(classGroup, classPartObject, classGroupId, theme) {
    classGroup.forEach(function(classDefinition) {
      if (typeof classDefinition === "string") {
        var classPartObjectToEdit = classDefinition === "" ? classPartObject : getPart(classPartObject, classDefinition);
        classPartObjectToEdit.classGroupId = classGroupId;
        return;
      }
      if (typeof classDefinition === "function") {
        if (isThemeGetter(classDefinition)) {
          processClassesRecursively(classDefinition(theme), classPartObject, classGroupId, theme);
          return;
        }
        classPartObject.validators.push({
          validator: classDefinition,
          classGroupId
        });
        return;
      }
      Object.entries(classDefinition).forEach(function(_ref3) {
        var key = _ref3[0], classGroup2 = _ref3[1];
        processClassesRecursively(classGroup2, getPart(classPartObject, key), classGroupId, theme);
      });
    });
  }
  function getPart(classPartObject, path) {
    var currentClassPartObject = classPartObject;
    path.split(CLASS_PART_SEPARATOR).forEach(function(pathPart) {
      if (!currentClassPartObject.nextPart.has(pathPart)) {
        currentClassPartObject.nextPart.set(pathPart, {
          nextPart: /* @__PURE__ */ new Map(),
          validators: []
        });
      }
      currentClassPartObject = currentClassPartObject.nextPart.get(pathPart);
    });
    return currentClassPartObject;
  }
  function isThemeGetter(func) {
    return func.isThemeGetter;
  }
  function getPrefixedClassGroupEntries(classGroupEntries, prefix) {
    if (!prefix) {
      return classGroupEntries;
    }
    return classGroupEntries.map(function(_ref4) {
      var classGroupId = _ref4[0], classGroup = _ref4[1];
      var prefixedClassGroup = classGroup.map(function(classDefinition) {
        if (typeof classDefinition === "string") {
          return prefix + classDefinition;
        }
        if (typeof classDefinition === "object") {
          return Object.fromEntries(Object.entries(classDefinition).map(function(_ref5) {
            var key = _ref5[0], value = _ref5[1];
            return [prefix + key, value];
          }));
        }
        return classDefinition;
      });
      return [classGroupId, prefixedClassGroup];
    });
  }

  // node_modules/tailwind-merge/dist/lib/lru-cache.mjs
  function createLruCache(maxCacheSize) {
    if (maxCacheSize < 1) {
      return {
        get: function get() {
          return void 0;
        },
        set: function set() {
        }
      };
    }
    var cacheSize = 0;
    var cache = /* @__PURE__ */ new Map();
    var previousCache = /* @__PURE__ */ new Map();
    function update(key, value) {
      cache.set(key, value);
      cacheSize++;
      if (cacheSize > maxCacheSize) {
        cacheSize = 0;
        previousCache = cache;
        cache = /* @__PURE__ */ new Map();
      }
    }
    return {
      get: function get(key) {
        var value = cache.get(key);
        if (value !== void 0) {
          return value;
        }
        if ((value = previousCache.get(key)) !== void 0) {
          update(key, value);
          return value;
        }
      },
      set: function set(key, value) {
        if (cache.has(key)) {
          cache.set(key, value);
        } else {
          update(key, value);
        }
      }
    };
  }

  // node_modules/tailwind-merge/dist/lib/modifier-utils.mjs
  var IMPORTANT_MODIFIER = "!";
  function createSplitModifiers(config) {
    var separator = config.separator || ":";
    var isSeparatorSingleCharacter = separator.length === 1;
    var firstSeparatorCharacter = separator[0];
    var separatorLength = separator.length;
    return function splitModifiers(className) {
      var modifiers = [];
      var bracketDepth = 0;
      var modifierStart = 0;
      var postfixModifierPosition;
      for (var index = 0; index < className.length; index++) {
        var currentCharacter = className[index];
        if (bracketDepth === 0) {
          if (currentCharacter === firstSeparatorCharacter && (isSeparatorSingleCharacter || className.slice(index, index + separatorLength) === separator)) {
            modifiers.push(className.slice(modifierStart, index));
            modifierStart = index + separatorLength;
            continue;
          }
          if (currentCharacter === "/") {
            postfixModifierPosition = index;
            continue;
          }
        }
        if (currentCharacter === "[") {
          bracketDepth++;
        } else if (currentCharacter === "]") {
          bracketDepth--;
        }
      }
      var baseClassNameWithImportantModifier = modifiers.length === 0 ? className : className.substring(modifierStart);
      var hasImportantModifier = baseClassNameWithImportantModifier.startsWith(IMPORTANT_MODIFIER);
      var baseClassName = hasImportantModifier ? baseClassNameWithImportantModifier.substring(1) : baseClassNameWithImportantModifier;
      var maybePostfixModifierPosition = postfixModifierPosition && postfixModifierPosition > modifierStart ? postfixModifierPosition - modifierStart : void 0;
      return {
        modifiers,
        hasImportantModifier,
        baseClassName,
        maybePostfixModifierPosition
      };
    };
  }
  function sortModifiers(modifiers) {
    if (modifiers.length <= 1) {
      return modifiers;
    }
    var sortedModifiers = [];
    var unsortedModifiers = [];
    modifiers.forEach(function(modifier) {
      var isArbitraryVariant = modifier[0] === "[";
      if (isArbitraryVariant) {
        sortedModifiers.push.apply(sortedModifiers, unsortedModifiers.sort().concat([modifier]));
        unsortedModifiers = [];
      } else {
        unsortedModifiers.push(modifier);
      }
    });
    sortedModifiers.push.apply(sortedModifiers, unsortedModifiers.sort());
    return sortedModifiers;
  }

  // node_modules/tailwind-merge/dist/lib/config-utils.mjs
  function createConfigUtils(config) {
    return {
      cache: createLruCache(config.cacheSize),
      splitModifiers: createSplitModifiers(config),
      ...createClassUtils(config)
    };
  }

  // node_modules/tailwind-merge/dist/lib/merge-classlist.mjs
  var SPLIT_CLASSES_REGEX = /\s+/;
  function mergeClassList(classList, configUtils) {
    var splitModifiers = configUtils.splitModifiers, getClassGroupId = configUtils.getClassGroupId, getConflictingClassGroupIds = configUtils.getConflictingClassGroupIds;
    var classGroupsInConflict = /* @__PURE__ */ new Set();
    return classList.trim().split(SPLIT_CLASSES_REGEX).map(function(originalClassName) {
      var _splitModifiers = splitModifiers(originalClassName), modifiers = _splitModifiers.modifiers, hasImportantModifier = _splitModifiers.hasImportantModifier, baseClassName = _splitModifiers.baseClassName, maybePostfixModifierPosition = _splitModifiers.maybePostfixModifierPosition;
      var classGroupId = getClassGroupId(maybePostfixModifierPosition ? baseClassName.substring(0, maybePostfixModifierPosition) : baseClassName);
      var hasPostfixModifier = Boolean(maybePostfixModifierPosition);
      if (!classGroupId) {
        if (!maybePostfixModifierPosition) {
          return {
            isTailwindClass: false,
            originalClassName
          };
        }
        classGroupId = getClassGroupId(baseClassName);
        if (!classGroupId) {
          return {
            isTailwindClass: false,
            originalClassName
          };
        }
        hasPostfixModifier = false;
      }
      var variantModifier = sortModifiers(modifiers).join(":");
      var modifierId = hasImportantModifier ? variantModifier + IMPORTANT_MODIFIER : variantModifier;
      return {
        isTailwindClass: true,
        modifierId,
        classGroupId,
        originalClassName,
        hasPostfixModifier
      };
    }).reverse().filter(function(parsed) {
      if (!parsed.isTailwindClass) {
        return true;
      }
      var modifierId = parsed.modifierId, classGroupId = parsed.classGroupId, hasPostfixModifier = parsed.hasPostfixModifier;
      var classId = modifierId + classGroupId;
      if (classGroupsInConflict.has(classId)) {
        return false;
      }
      classGroupsInConflict.add(classId);
      getConflictingClassGroupIds(classGroupId, hasPostfixModifier).forEach(function(group) {
        return classGroupsInConflict.add(modifierId + group);
      });
      return true;
    }).reverse().map(function(parsed) {
      return parsed.originalClassName;
    }).join(" ");
  }

  // node_modules/tailwind-merge/dist/lib/create-tailwind-merge.mjs
  function createTailwindMerge() {
    for (var _len = arguments.length, createConfig = new Array(_len), _key = 0; _key < _len; _key++) {
      createConfig[_key] = arguments[_key];
    }
    var configUtils;
    var cacheGet;
    var cacheSet;
    var functionToCall = initTailwindMerge;
    function initTailwindMerge(classList) {
      var firstCreateConfig = createConfig[0], restCreateConfig = createConfig.slice(1);
      var config = restCreateConfig.reduce(function(previousConfig, createConfigCurrent) {
        return createConfigCurrent(previousConfig);
      }, firstCreateConfig());
      configUtils = createConfigUtils(config);
      cacheGet = configUtils.cache.get;
      cacheSet = configUtils.cache.set;
      functionToCall = tailwindMerge;
      return tailwindMerge(classList);
    }
    function tailwindMerge(classList) {
      var cachedResult = cacheGet(classList);
      if (cachedResult) {
        return cachedResult;
      }
      var result = mergeClassList(classList, configUtils);
      cacheSet(classList, result);
      return result;
    }
    return function callTailwindMerge() {
      return functionToCall(twJoin.apply(null, arguments));
    };
  }

  // node_modules/tailwind-merge/dist/lib/from-theme.mjs
  function fromTheme(key) {
    var themeGetter = function themeGetter2(theme) {
      return theme[key] || [];
    };
    themeGetter.isThemeGetter = true;
    return themeGetter;
  }

  // node_modules/tailwind-merge/dist/lib/validators.mjs
  var arbitraryValueRegex = /^\[(?:([a-z-]+):)?(.+)\]$/i;
  var fractionRegex = /^\d+\/\d+$/;
  var stringLengths = /* @__PURE__ */ new Set(["px", "full", "screen"]);
  var tshirtUnitRegex = /^(\d+(\.\d+)?)?(xs|sm|md|lg|xl)$/;
  var lengthUnitRegex = /\d+(%|px|r?em|[sdl]?v([hwib]|min|max)|pt|pc|in|cm|mm|cap|ch|ex|r?lh|cq(w|h|i|b|min|max))|\b(calc|min|max|clamp)\(.+\)|^0$/;
  var shadowRegex = /^-?((\d+)?\.?(\d+)[a-z]+|0)_-?((\d+)?\.?(\d+)[a-z]+|0)/;
  function isLength(value) {
    return isNumber(value) || stringLengths.has(value) || fractionRegex.test(value) || isArbitraryLength(value);
  }
  function isArbitraryLength(value) {
    return getIsArbitraryValue(value, "length", isLengthOnly);
  }
  function isArbitrarySize(value) {
    return getIsArbitraryValue(value, "size", isNever);
  }
  function isArbitraryPosition(value) {
    return getIsArbitraryValue(value, "position", isNever);
  }
  function isArbitraryUrl(value) {
    return getIsArbitraryValue(value, "url", isUrl);
  }
  function isArbitraryNumber(value) {
    return getIsArbitraryValue(value, "number", isNumber);
  }
  function isNumber(value) {
    return !Number.isNaN(Number(value));
  }
  function isPercent(value) {
    return value.endsWith("%") && isNumber(value.slice(0, -1));
  }
  function isInteger(value) {
    return isIntegerOnly(value) || getIsArbitraryValue(value, "number", isIntegerOnly);
  }
  function isArbitraryValue(value) {
    return arbitraryValueRegex.test(value);
  }
  function isAny() {
    return true;
  }
  function isTshirtSize(value) {
    return tshirtUnitRegex.test(value);
  }
  function isArbitraryShadow(value) {
    return getIsArbitraryValue(value, "", isShadow);
  }
  function getIsArbitraryValue(value, label, testValue) {
    var result = arbitraryValueRegex.exec(value);
    if (result) {
      if (result[1]) {
        return result[1] === label;
      }
      return testValue(result[2]);
    }
    return false;
  }
  function isLengthOnly(value) {
    return lengthUnitRegex.test(value);
  }
  function isNever() {
    return false;
  }
  function isUrl(value) {
    return value.startsWith("url(");
  }
  function isIntegerOnly(value) {
    return Number.isInteger(Number(value));
  }
  function isShadow(value) {
    return shadowRegex.test(value);
  }

  // node_modules/tailwind-merge/dist/lib/default-config.mjs
  function getDefaultConfig() {
    var colors = fromTheme("colors");
    var spacing = fromTheme("spacing");
    var blur = fromTheme("blur");
    var brightness = fromTheme("brightness");
    var borderColor = fromTheme("borderColor");
    var borderRadius = fromTheme("borderRadius");
    var borderSpacing = fromTheme("borderSpacing");
    var borderWidth = fromTheme("borderWidth");
    var contrast = fromTheme("contrast");
    var grayscale = fromTheme("grayscale");
    var hueRotate = fromTheme("hueRotate");
    var invert = fromTheme("invert");
    var gap = fromTheme("gap");
    var gradientColorStops = fromTheme("gradientColorStops");
    var gradientColorStopPositions = fromTheme("gradientColorStopPositions");
    var inset = fromTheme("inset");
    var margin = fromTheme("margin");
    var opacity = fromTheme("opacity");
    var padding = fromTheme("padding");
    var saturate = fromTheme("saturate");
    var scale = fromTheme("scale");
    var sepia = fromTheme("sepia");
    var skew = fromTheme("skew");
    var space = fromTheme("space");
    var translate = fromTheme("translate");
    var getOverscroll = function getOverscroll2() {
      return ["auto", "contain", "none"];
    };
    var getOverflow = function getOverflow2() {
      return ["auto", "hidden", "clip", "visible", "scroll"];
    };
    var getSpacingWithAutoAndArbitrary = function getSpacingWithAutoAndArbitrary2() {
      return ["auto", isArbitraryValue, spacing];
    };
    var getSpacingWithArbitrary = function getSpacingWithArbitrary2() {
      return [isArbitraryValue, spacing];
    };
    var getLengthWithEmpty = function getLengthWithEmpty2() {
      return ["", isLength];
    };
    var getNumberWithAutoAndArbitrary = function getNumberWithAutoAndArbitrary2() {
      return ["auto", isNumber, isArbitraryValue];
    };
    var getPositions = function getPositions2() {
      return ["bottom", "center", "left", "left-bottom", "left-top", "right", "right-bottom", "right-top", "top"];
    };
    var getLineStyles = function getLineStyles2() {
      return ["solid", "dashed", "dotted", "double", "none"];
    };
    var getBlendModes = function getBlendModes2() {
      return ["normal", "multiply", "screen", "overlay", "darken", "lighten", "color-dodge", "color-burn", "hard-light", "soft-light", "difference", "exclusion", "hue", "saturation", "color", "luminosity", "plus-lighter"];
    };
    var getAlign = function getAlign2() {
      return ["start", "end", "center", "between", "around", "evenly", "stretch"];
    };
    var getZeroAndEmpty = function getZeroAndEmpty2() {
      return ["", "0", isArbitraryValue];
    };
    var getBreaks = function getBreaks2() {
      return ["auto", "avoid", "all", "avoid-page", "page", "left", "right", "column"];
    };
    var getNumber = function getNumber2() {
      return [isNumber, isArbitraryNumber];
    };
    var getNumberAndArbitrary = function getNumberAndArbitrary2() {
      return [isNumber, isArbitraryValue];
    };
    return {
      cacheSize: 500,
      theme: {
        colors: [isAny],
        spacing: [isLength],
        blur: ["none", "", isTshirtSize, isArbitraryValue],
        brightness: getNumber(),
        borderColor: [colors],
        borderRadius: ["none", "", "full", isTshirtSize, isArbitraryValue],
        borderSpacing: getSpacingWithArbitrary(),
        borderWidth: getLengthWithEmpty(),
        contrast: getNumber(),
        grayscale: getZeroAndEmpty(),
        hueRotate: getNumberAndArbitrary(),
        invert: getZeroAndEmpty(),
        gap: getSpacingWithArbitrary(),
        gradientColorStops: [colors],
        gradientColorStopPositions: [isPercent, isArbitraryLength],
        inset: getSpacingWithAutoAndArbitrary(),
        margin: getSpacingWithAutoAndArbitrary(),
        opacity: getNumber(),
        padding: getSpacingWithArbitrary(),
        saturate: getNumber(),
        scale: getNumber(),
        sepia: getZeroAndEmpty(),
        skew: getNumberAndArbitrary(),
        space: getSpacingWithArbitrary(),
        translate: getSpacingWithArbitrary()
      },
      classGroups: {
        // Layout
        /**
         * Aspect Ratio
         * @see https://tailwindcss.com/docs/aspect-ratio
         */
        aspect: [{
          aspect: ["auto", "square", "video", isArbitraryValue]
        }],
        /**
         * Container
         * @see https://tailwindcss.com/docs/container
         */
        container: ["container"],
        /**
         * Columns
         * @see https://tailwindcss.com/docs/columns
         */
        columns: [{
          columns: [isTshirtSize]
        }],
        /**
         * Break After
         * @see https://tailwindcss.com/docs/break-after
         */
        "break-after": [{
          "break-after": getBreaks()
        }],
        /**
         * Break Before
         * @see https://tailwindcss.com/docs/break-before
         */
        "break-before": [{
          "break-before": getBreaks()
        }],
        /**
         * Break Inside
         * @see https://tailwindcss.com/docs/break-inside
         */
        "break-inside": [{
          "break-inside": ["auto", "avoid", "avoid-page", "avoid-column"]
        }],
        /**
         * Box Decoration Break
         * @see https://tailwindcss.com/docs/box-decoration-break
         */
        "box-decoration": [{
          "box-decoration": ["slice", "clone"]
        }],
        /**
         * Box Sizing
         * @see https://tailwindcss.com/docs/box-sizing
         */
        box: [{
          box: ["border", "content"]
        }],
        /**
         * Display
         * @see https://tailwindcss.com/docs/display
         */
        display: ["block", "inline-block", "inline", "flex", "inline-flex", "table", "inline-table", "table-caption", "table-cell", "table-column", "table-column-group", "table-footer-group", "table-header-group", "table-row-group", "table-row", "flow-root", "grid", "inline-grid", "contents", "list-item", "hidden"],
        /**
         * Floats
         * @see https://tailwindcss.com/docs/float
         */
        "float": [{
          "float": ["right", "left", "none"]
        }],
        /**
         * Clear
         * @see https://tailwindcss.com/docs/clear
         */
        clear: [{
          clear: ["left", "right", "both", "none"]
        }],
        /**
         * Isolation
         * @see https://tailwindcss.com/docs/isolation
         */
        isolation: ["isolate", "isolation-auto"],
        /**
         * Object Fit
         * @see https://tailwindcss.com/docs/object-fit
         */
        "object-fit": [{
          object: ["contain", "cover", "fill", "none", "scale-down"]
        }],
        /**
         * Object Position
         * @see https://tailwindcss.com/docs/object-position
         */
        "object-position": [{
          object: [].concat(getPositions(), [isArbitraryValue])
        }],
        /**
         * Overflow
         * @see https://tailwindcss.com/docs/overflow
         */
        overflow: [{
          overflow: getOverflow()
        }],
        /**
         * Overflow X
         * @see https://tailwindcss.com/docs/overflow
         */
        "overflow-x": [{
          "overflow-x": getOverflow()
        }],
        /**
         * Overflow Y
         * @see https://tailwindcss.com/docs/overflow
         */
        "overflow-y": [{
          "overflow-y": getOverflow()
        }],
        /**
         * Overscroll Behavior
         * @see https://tailwindcss.com/docs/overscroll-behavior
         */
        overscroll: [{
          overscroll: getOverscroll()
        }],
        /**
         * Overscroll Behavior X
         * @see https://tailwindcss.com/docs/overscroll-behavior
         */
        "overscroll-x": [{
          "overscroll-x": getOverscroll()
        }],
        /**
         * Overscroll Behavior Y
         * @see https://tailwindcss.com/docs/overscroll-behavior
         */
        "overscroll-y": [{
          "overscroll-y": getOverscroll()
        }],
        /**
         * Position
         * @see https://tailwindcss.com/docs/position
         */
        position: ["static", "fixed", "absolute", "relative", "sticky"],
        /**
         * Top / Right / Bottom / Left
         * @see https://tailwindcss.com/docs/top-right-bottom-left
         */
        inset: [{
          inset: [inset]
        }],
        /**
         * Right / Left
         * @see https://tailwindcss.com/docs/top-right-bottom-left
         */
        "inset-x": [{
          "inset-x": [inset]
        }],
        /**
         * Top / Bottom
         * @see https://tailwindcss.com/docs/top-right-bottom-left
         */
        "inset-y": [{
          "inset-y": [inset]
        }],
        /**
         * Start
         * @see https://tailwindcss.com/docs/top-right-bottom-left
         */
        start: [{
          start: [inset]
        }],
        /**
         * End
         * @see https://tailwindcss.com/docs/top-right-bottom-left
         */
        end: [{
          end: [inset]
        }],
        /**
         * Top
         * @see https://tailwindcss.com/docs/top-right-bottom-left
         */
        top: [{
          top: [inset]
        }],
        /**
         * Right
         * @see https://tailwindcss.com/docs/top-right-bottom-left
         */
        right: [{
          right: [inset]
        }],
        /**
         * Bottom
         * @see https://tailwindcss.com/docs/top-right-bottom-left
         */
        bottom: [{
          bottom: [inset]
        }],
        /**
         * Left
         * @see https://tailwindcss.com/docs/top-right-bottom-left
         */
        left: [{
          left: [inset]
        }],
        /**
         * Visibility
         * @see https://tailwindcss.com/docs/visibility
         */
        visibility: ["visible", "invisible", "collapse"],
        /**
         * Z-Index
         * @see https://tailwindcss.com/docs/z-index
         */
        z: [{
          z: ["auto", isInteger]
        }],
        // Flexbox and Grid
        /**
         * Flex Basis
         * @see https://tailwindcss.com/docs/flex-basis
         */
        basis: [{
          basis: getSpacingWithAutoAndArbitrary()
        }],
        /**
         * Flex Direction
         * @see https://tailwindcss.com/docs/flex-direction
         */
        "flex-direction": [{
          flex: ["row", "row-reverse", "col", "col-reverse"]
        }],
        /**
         * Flex Wrap
         * @see https://tailwindcss.com/docs/flex-wrap
         */
        "flex-wrap": [{
          flex: ["wrap", "wrap-reverse", "nowrap"]
        }],
        /**
         * Flex
         * @see https://tailwindcss.com/docs/flex
         */
        flex: [{
          flex: ["1", "auto", "initial", "none", isArbitraryValue]
        }],
        /**
         * Flex Grow
         * @see https://tailwindcss.com/docs/flex-grow
         */
        grow: [{
          grow: getZeroAndEmpty()
        }],
        /**
         * Flex Shrink
         * @see https://tailwindcss.com/docs/flex-shrink
         */
        shrink: [{
          shrink: getZeroAndEmpty()
        }],
        /**
         * Order
         * @see https://tailwindcss.com/docs/order
         */
        order: [{
          order: ["first", "last", "none", isInteger]
        }],
        /**
         * Grid Template Columns
         * @see https://tailwindcss.com/docs/grid-template-columns
         */
        "grid-cols": [{
          "grid-cols": [isAny]
        }],
        /**
         * Grid Column Start / End
         * @see https://tailwindcss.com/docs/grid-column
         */
        "col-start-end": [{
          col: ["auto", {
            span: ["full", isInteger]
          }, isArbitraryValue]
        }],
        /**
         * Grid Column Start
         * @see https://tailwindcss.com/docs/grid-column
         */
        "col-start": [{
          "col-start": getNumberWithAutoAndArbitrary()
        }],
        /**
         * Grid Column End
         * @see https://tailwindcss.com/docs/grid-column
         */
        "col-end": [{
          "col-end": getNumberWithAutoAndArbitrary()
        }],
        /**
         * Grid Template Rows
         * @see https://tailwindcss.com/docs/grid-template-rows
         */
        "grid-rows": [{
          "grid-rows": [isAny]
        }],
        /**
         * Grid Row Start / End
         * @see https://tailwindcss.com/docs/grid-row
         */
        "row-start-end": [{
          row: ["auto", {
            span: [isInteger]
          }, isArbitraryValue]
        }],
        /**
         * Grid Row Start
         * @see https://tailwindcss.com/docs/grid-row
         */
        "row-start": [{
          "row-start": getNumberWithAutoAndArbitrary()
        }],
        /**
         * Grid Row End
         * @see https://tailwindcss.com/docs/grid-row
         */
        "row-end": [{
          "row-end": getNumberWithAutoAndArbitrary()
        }],
        /**
         * Grid Auto Flow
         * @see https://tailwindcss.com/docs/grid-auto-flow
         */
        "grid-flow": [{
          "grid-flow": ["row", "col", "dense", "row-dense", "col-dense"]
        }],
        /**
         * Grid Auto Columns
         * @see https://tailwindcss.com/docs/grid-auto-columns
         */
        "auto-cols": [{
          "auto-cols": ["auto", "min", "max", "fr", isArbitraryValue]
        }],
        /**
         * Grid Auto Rows
         * @see https://tailwindcss.com/docs/grid-auto-rows
         */
        "auto-rows": [{
          "auto-rows": ["auto", "min", "max", "fr", isArbitraryValue]
        }],
        /**
         * Gap
         * @see https://tailwindcss.com/docs/gap
         */
        gap: [{
          gap: [gap]
        }],
        /**
         * Gap X
         * @see https://tailwindcss.com/docs/gap
         */
        "gap-x": [{
          "gap-x": [gap]
        }],
        /**
         * Gap Y
         * @see https://tailwindcss.com/docs/gap
         */
        "gap-y": [{
          "gap-y": [gap]
        }],
        /**
         * Justify Content
         * @see https://tailwindcss.com/docs/justify-content
         */
        "justify-content": [{
          justify: ["normal"].concat(getAlign())
        }],
        /**
         * Justify Items
         * @see https://tailwindcss.com/docs/justify-items
         */
        "justify-items": [{
          "justify-items": ["start", "end", "center", "stretch"]
        }],
        /**
         * Justify Self
         * @see https://tailwindcss.com/docs/justify-self
         */
        "justify-self": [{
          "justify-self": ["auto", "start", "end", "center", "stretch"]
        }],
        /**
         * Align Content
         * @see https://tailwindcss.com/docs/align-content
         */
        "align-content": [{
          content: ["normal"].concat(getAlign(), ["baseline"])
        }],
        /**
         * Align Items
         * @see https://tailwindcss.com/docs/align-items
         */
        "align-items": [{
          items: ["start", "end", "center", "baseline", "stretch"]
        }],
        /**
         * Align Self
         * @see https://tailwindcss.com/docs/align-self
         */
        "align-self": [{
          self: ["auto", "start", "end", "center", "stretch", "baseline"]
        }],
        /**
         * Place Content
         * @see https://tailwindcss.com/docs/place-content
         */
        "place-content": [{
          "place-content": [].concat(getAlign(), ["baseline"])
        }],
        /**
         * Place Items
         * @see https://tailwindcss.com/docs/place-items
         */
        "place-items": [{
          "place-items": ["start", "end", "center", "baseline", "stretch"]
        }],
        /**
         * Place Self
         * @see https://tailwindcss.com/docs/place-self
         */
        "place-self": [{
          "place-self": ["auto", "start", "end", "center", "stretch"]
        }],
        // Spacing
        /**
         * Padding
         * @see https://tailwindcss.com/docs/padding
         */
        p: [{
          p: [padding]
        }],
        /**
         * Padding X
         * @see https://tailwindcss.com/docs/padding
         */
        px: [{
          px: [padding]
        }],
        /**
         * Padding Y
         * @see https://tailwindcss.com/docs/padding
         */
        py: [{
          py: [padding]
        }],
        /**
         * Padding Start
         * @see https://tailwindcss.com/docs/padding
         */
        ps: [{
          ps: [padding]
        }],
        /**
         * Padding End
         * @see https://tailwindcss.com/docs/padding
         */
        pe: [{
          pe: [padding]
        }],
        /**
         * Padding Top
         * @see https://tailwindcss.com/docs/padding
         */
        pt: [{
          pt: [padding]
        }],
        /**
         * Padding Right
         * @see https://tailwindcss.com/docs/padding
         */
        pr: [{
          pr: [padding]
        }],
        /**
         * Padding Bottom
         * @see https://tailwindcss.com/docs/padding
         */
        pb: [{
          pb: [padding]
        }],
        /**
         * Padding Left
         * @see https://tailwindcss.com/docs/padding
         */
        pl: [{
          pl: [padding]
        }],
        /**
         * Margin
         * @see https://tailwindcss.com/docs/margin
         */
        m: [{
          m: [margin]
        }],
        /**
         * Margin X
         * @see https://tailwindcss.com/docs/margin
         */
        mx: [{
          mx: [margin]
        }],
        /**
         * Margin Y
         * @see https://tailwindcss.com/docs/margin
         */
        my: [{
          my: [margin]
        }],
        /**
         * Margin Start
         * @see https://tailwindcss.com/docs/margin
         */
        ms: [{
          ms: [margin]
        }],
        /**
         * Margin End
         * @see https://tailwindcss.com/docs/margin
         */
        me: [{
          me: [margin]
        }],
        /**
         * Margin Top
         * @see https://tailwindcss.com/docs/margin
         */
        mt: [{
          mt: [margin]
        }],
        /**
         * Margin Right
         * @see https://tailwindcss.com/docs/margin
         */
        mr: [{
          mr: [margin]
        }],
        /**
         * Margin Bottom
         * @see https://tailwindcss.com/docs/margin
         */
        mb: [{
          mb: [margin]
        }],
        /**
         * Margin Left
         * @see https://tailwindcss.com/docs/margin
         */
        ml: [{
          ml: [margin]
        }],
        /**
         * Space Between X
         * @see https://tailwindcss.com/docs/space
         */
        "space-x": [{
          "space-x": [space]
        }],
        /**
         * Space Between X Reverse
         * @see https://tailwindcss.com/docs/space
         */
        "space-x-reverse": ["space-x-reverse"],
        /**
         * Space Between Y
         * @see https://tailwindcss.com/docs/space
         */
        "space-y": [{
          "space-y": [space]
        }],
        /**
         * Space Between Y Reverse
         * @see https://tailwindcss.com/docs/space
         */
        "space-y-reverse": ["space-y-reverse"],
        // Sizing
        /**
         * Width
         * @see https://tailwindcss.com/docs/width
         */
        w: [{
          w: ["auto", "min", "max", "fit", isArbitraryValue, spacing]
        }],
        /**
         * Min-Width
         * @see https://tailwindcss.com/docs/min-width
         */
        "min-w": [{
          "min-w": ["min", "max", "fit", isArbitraryValue, isLength]
        }],
        /**
         * Max-Width
         * @see https://tailwindcss.com/docs/max-width
         */
        "max-w": [{
          "max-w": ["0", "none", "full", "min", "max", "fit", "prose", {
            screen: [isTshirtSize]
          }, isTshirtSize, isArbitraryValue]
        }],
        /**
         * Height
         * @see https://tailwindcss.com/docs/height
         */
        h: [{
          h: [isArbitraryValue, spacing, "auto", "min", "max", "fit"]
        }],
        /**
         * Min-Height
         * @see https://tailwindcss.com/docs/min-height
         */
        "min-h": [{
          "min-h": ["min", "max", "fit", isArbitraryValue, isLength]
        }],
        /**
         * Max-Height
         * @see https://tailwindcss.com/docs/max-height
         */
        "max-h": [{
          "max-h": [isArbitraryValue, spacing, "min", "max", "fit"]
        }],
        // Typography
        /**
         * Font Size
         * @see https://tailwindcss.com/docs/font-size
         */
        "font-size": [{
          text: ["base", isTshirtSize, isArbitraryLength]
        }],
        /**
         * Font Smoothing
         * @see https://tailwindcss.com/docs/font-smoothing
         */
        "font-smoothing": ["antialiased", "subpixel-antialiased"],
        /**
         * Font Style
         * @see https://tailwindcss.com/docs/font-style
         */
        "font-style": ["italic", "not-italic"],
        /**
         * Font Weight
         * @see https://tailwindcss.com/docs/font-weight
         */
        "font-weight": [{
          font: ["thin", "extralight", "light", "normal", "medium", "semibold", "bold", "extrabold", "black", isArbitraryNumber]
        }],
        /**
         * Font Family
         * @see https://tailwindcss.com/docs/font-family
         */
        "font-family": [{
          font: [isAny]
        }],
        /**
         * Font Variant Numeric
         * @see https://tailwindcss.com/docs/font-variant-numeric
         */
        "fvn-normal": ["normal-nums"],
        /**
         * Font Variant Numeric
         * @see https://tailwindcss.com/docs/font-variant-numeric
         */
        "fvn-ordinal": ["ordinal"],
        /**
         * Font Variant Numeric
         * @see https://tailwindcss.com/docs/font-variant-numeric
         */
        "fvn-slashed-zero": ["slashed-zero"],
        /**
         * Font Variant Numeric
         * @see https://tailwindcss.com/docs/font-variant-numeric
         */
        "fvn-figure": ["lining-nums", "oldstyle-nums"],
        /**
         * Font Variant Numeric
         * @see https://tailwindcss.com/docs/font-variant-numeric
         */
        "fvn-spacing": ["proportional-nums", "tabular-nums"],
        /**
         * Font Variant Numeric
         * @see https://tailwindcss.com/docs/font-variant-numeric
         */
        "fvn-fraction": ["diagonal-fractions", "stacked-fractons"],
        /**
         * Letter Spacing
         * @see https://tailwindcss.com/docs/letter-spacing
         */
        tracking: [{
          tracking: ["tighter", "tight", "normal", "wide", "wider", "widest", isArbitraryValue]
        }],
        /**
         * Line Clamp
         * @see https://tailwindcss.com/docs/line-clamp
         */
        "line-clamp": [{
          "line-clamp": ["none", isNumber, isArbitraryNumber]
        }],
        /**
         * Line Height
         * @see https://tailwindcss.com/docs/line-height
         */
        leading: [{
          leading: ["none", "tight", "snug", "normal", "relaxed", "loose", isArbitraryValue, isLength]
        }],
        /**
         * List Style Image
         * @see https://tailwindcss.com/docs/list-style-image
         */
        "list-image": [{
          "list-image": ["none", isArbitraryValue]
        }],
        /**
         * List Style Type
         * @see https://tailwindcss.com/docs/list-style-type
         */
        "list-style-type": [{
          list: ["none", "disc", "decimal", isArbitraryValue]
        }],
        /**
         * List Style Position
         * @see https://tailwindcss.com/docs/list-style-position
         */
        "list-style-position": [{
          list: ["inside", "outside"]
        }],
        /**
         * Placeholder Color
         * @deprecated since Tailwind CSS v3.0.0
         * @see https://tailwindcss.com/docs/placeholder-color
         */
        "placeholder-color": [{
          placeholder: [colors]
        }],
        /**
         * Placeholder Opacity
         * @see https://tailwindcss.com/docs/placeholder-opacity
         */
        "placeholder-opacity": [{
          "placeholder-opacity": [opacity]
        }],
        /**
         * Text Alignment
         * @see https://tailwindcss.com/docs/text-align
         */
        "text-alignment": [{
          text: ["left", "center", "right", "justify", "start", "end"]
        }],
        /**
         * Text Color
         * @see https://tailwindcss.com/docs/text-color
         */
        "text-color": [{
          text: [colors]
        }],
        /**
         * Text Opacity
         * @see https://tailwindcss.com/docs/text-opacity
         */
        "text-opacity": [{
          "text-opacity": [opacity]
        }],
        /**
         * Text Decoration
         * @see https://tailwindcss.com/docs/text-decoration
         */
        "text-decoration": ["underline", "overline", "line-through", "no-underline"],
        /**
         * Text Decoration Style
         * @see https://tailwindcss.com/docs/text-decoration-style
         */
        "text-decoration-style": [{
          decoration: [].concat(getLineStyles(), ["wavy"])
        }],
        /**
         * Text Decoration Thickness
         * @see https://tailwindcss.com/docs/text-decoration-thickness
         */
        "text-decoration-thickness": [{
          decoration: ["auto", "from-font", isLength]
        }],
        /**
         * Text Underline Offset
         * @see https://tailwindcss.com/docs/text-underline-offset
         */
        "underline-offset": [{
          "underline-offset": ["auto", isArbitraryValue, isLength]
        }],
        /**
         * Text Decoration Color
         * @see https://tailwindcss.com/docs/text-decoration-color
         */
        "text-decoration-color": [{
          decoration: [colors]
        }],
        /**
         * Text Transform
         * @see https://tailwindcss.com/docs/text-transform
         */
        "text-transform": ["uppercase", "lowercase", "capitalize", "normal-case"],
        /**
         * Text Overflow
         * @see https://tailwindcss.com/docs/text-overflow
         */
        "text-overflow": ["truncate", "text-ellipsis", "text-clip"],
        /**
         * Text Indent
         * @see https://tailwindcss.com/docs/text-indent
         */
        indent: [{
          indent: getSpacingWithArbitrary()
        }],
        /**
         * Vertical Alignment
         * @see https://tailwindcss.com/docs/vertical-align
         */
        "vertical-align": [{
          align: ["baseline", "top", "middle", "bottom", "text-top", "text-bottom", "sub", "super", isArbitraryValue]
        }],
        /**
         * Whitespace
         * @see https://tailwindcss.com/docs/whitespace
         */
        whitespace: [{
          whitespace: ["normal", "nowrap", "pre", "pre-line", "pre-wrap", "break-spaces"]
        }],
        /**
         * Word Break
         * @see https://tailwindcss.com/docs/word-break
         */
        "break": [{
          "break": ["normal", "words", "all", "keep"]
        }],
        /**
         * Hyphens
         * @see https://tailwindcss.com/docs/hyphens
         */
        hyphens: [{
          hyphens: ["none", "manual", "auto"]
        }],
        /**
         * Content
         * @see https://tailwindcss.com/docs/content
         */
        content: [{
          content: ["none", isArbitraryValue]
        }],
        // Backgrounds
        /**
         * Background Attachment
         * @see https://tailwindcss.com/docs/background-attachment
         */
        "bg-attachment": [{
          bg: ["fixed", "local", "scroll"]
        }],
        /**
         * Background Clip
         * @see https://tailwindcss.com/docs/background-clip
         */
        "bg-clip": [{
          "bg-clip": ["border", "padding", "content", "text"]
        }],
        /**
         * Background Opacity
         * @deprecated since Tailwind CSS v3.0.0
         * @see https://tailwindcss.com/docs/background-opacity
         */
        "bg-opacity": [{
          "bg-opacity": [opacity]
        }],
        /**
         * Background Origin
         * @see https://tailwindcss.com/docs/background-origin
         */
        "bg-origin": [{
          "bg-origin": ["border", "padding", "content"]
        }],
        /**
         * Background Position
         * @see https://tailwindcss.com/docs/background-position
         */
        "bg-position": [{
          bg: [].concat(getPositions(), [isArbitraryPosition])
        }],
        /**
         * Background Repeat
         * @see https://tailwindcss.com/docs/background-repeat
         */
        "bg-repeat": [{
          bg: ["no-repeat", {
            repeat: ["", "x", "y", "round", "space"]
          }]
        }],
        /**
         * Background Size
         * @see https://tailwindcss.com/docs/background-size
         */
        "bg-size": [{
          bg: ["auto", "cover", "contain", isArbitrarySize]
        }],
        /**
         * Background Image
         * @see https://tailwindcss.com/docs/background-image
         */
        "bg-image": [{
          bg: ["none", {
            "gradient-to": ["t", "tr", "r", "br", "b", "bl", "l", "tl"]
          }, isArbitraryUrl]
        }],
        /**
         * Background Color
         * @see https://tailwindcss.com/docs/background-color
         */
        "bg-color": [{
          bg: [colors]
        }],
        /**
         * Gradient Color Stops From Position
         * @see https://tailwindcss.com/docs/gradient-color-stops
         */
        "gradient-from-pos": [{
          from: [gradientColorStopPositions]
        }],
        /**
         * Gradient Color Stops Via Position
         * @see https://tailwindcss.com/docs/gradient-color-stops
         */
        "gradient-via-pos": [{
          via: [gradientColorStopPositions]
        }],
        /**
         * Gradient Color Stops To Position
         * @see https://tailwindcss.com/docs/gradient-color-stops
         */
        "gradient-to-pos": [{
          to: [gradientColorStopPositions]
        }],
        /**
         * Gradient Color Stops From
         * @see https://tailwindcss.com/docs/gradient-color-stops
         */
        "gradient-from": [{
          from: [gradientColorStops]
        }],
        /**
         * Gradient Color Stops Via
         * @see https://tailwindcss.com/docs/gradient-color-stops
         */
        "gradient-via": [{
          via: [gradientColorStops]
        }],
        /**
         * Gradient Color Stops To
         * @see https://tailwindcss.com/docs/gradient-color-stops
         */
        "gradient-to": [{
          to: [gradientColorStops]
        }],
        // Borders
        /**
         * Border Radius
         * @see https://tailwindcss.com/docs/border-radius
         */
        rounded: [{
          rounded: [borderRadius]
        }],
        /**
         * Border Radius Start
         * @see https://tailwindcss.com/docs/border-radius
         */
        "rounded-s": [{
          "rounded-s": [borderRadius]
        }],
        /**
         * Border Radius End
         * @see https://tailwindcss.com/docs/border-radius
         */
        "rounded-e": [{
          "rounded-e": [borderRadius]
        }],
        /**
         * Border Radius Top
         * @see https://tailwindcss.com/docs/border-radius
         */
        "rounded-t": [{
          "rounded-t": [borderRadius]
        }],
        /**
         * Border Radius Right
         * @see https://tailwindcss.com/docs/border-radius
         */
        "rounded-r": [{
          "rounded-r": [borderRadius]
        }],
        /**
         * Border Radius Bottom
         * @see https://tailwindcss.com/docs/border-radius
         */
        "rounded-b": [{
          "rounded-b": [borderRadius]
        }],
        /**
         * Border Radius Left
         * @see https://tailwindcss.com/docs/border-radius
         */
        "rounded-l": [{
          "rounded-l": [borderRadius]
        }],
        /**
         * Border Radius Start Start
         * @see https://tailwindcss.com/docs/border-radius
         */
        "rounded-ss": [{
          "rounded-ss": [borderRadius]
        }],
        /**
         * Border Radius Start End
         * @see https://tailwindcss.com/docs/border-radius
         */
        "rounded-se": [{
          "rounded-se": [borderRadius]
        }],
        /**
         * Border Radius End End
         * @see https://tailwindcss.com/docs/border-radius
         */
        "rounded-ee": [{
          "rounded-ee": [borderRadius]
        }],
        /**
         * Border Radius End Start
         * @see https://tailwindcss.com/docs/border-radius
         */
        "rounded-es": [{
          "rounded-es": [borderRadius]
        }],
        /**
         * Border Radius Top Left
         * @see https://tailwindcss.com/docs/border-radius
         */
        "rounded-tl": [{
          "rounded-tl": [borderRadius]
        }],
        /**
         * Border Radius Top Right
         * @see https://tailwindcss.com/docs/border-radius
         */
        "rounded-tr": [{
          "rounded-tr": [borderRadius]
        }],
        /**
         * Border Radius Bottom Right
         * @see https://tailwindcss.com/docs/border-radius
         */
        "rounded-br": [{
          "rounded-br": [borderRadius]
        }],
        /**
         * Border Radius Bottom Left
         * @see https://tailwindcss.com/docs/border-radius
         */
        "rounded-bl": [{
          "rounded-bl": [borderRadius]
        }],
        /**
         * Border Width
         * @see https://tailwindcss.com/docs/border-width
         */
        "border-w": [{
          border: [borderWidth]
        }],
        /**
         * Border Width X
         * @see https://tailwindcss.com/docs/border-width
         */
        "border-w-x": [{
          "border-x": [borderWidth]
        }],
        /**
         * Border Width Y
         * @see https://tailwindcss.com/docs/border-width
         */
        "border-w-y": [{
          "border-y": [borderWidth]
        }],
        /**
         * Border Width Start
         * @see https://tailwindcss.com/docs/border-width
         */
        "border-w-s": [{
          "border-s": [borderWidth]
        }],
        /**
         * Border Width End
         * @see https://tailwindcss.com/docs/border-width
         */
        "border-w-e": [{
          "border-e": [borderWidth]
        }],
        /**
         * Border Width Top
         * @see https://tailwindcss.com/docs/border-width
         */
        "border-w-t": [{
          "border-t": [borderWidth]
        }],
        /**
         * Border Width Right
         * @see https://tailwindcss.com/docs/border-width
         */
        "border-w-r": [{
          "border-r": [borderWidth]
        }],
        /**
         * Border Width Bottom
         * @see https://tailwindcss.com/docs/border-width
         */
        "border-w-b": [{
          "border-b": [borderWidth]
        }],
        /**
         * Border Width Left
         * @see https://tailwindcss.com/docs/border-width
         */
        "border-w-l": [{
          "border-l": [borderWidth]
        }],
        /**
         * Border Opacity
         * @see https://tailwindcss.com/docs/border-opacity
         */
        "border-opacity": [{
          "border-opacity": [opacity]
        }],
        /**
         * Border Style
         * @see https://tailwindcss.com/docs/border-style
         */
        "border-style": [{
          border: [].concat(getLineStyles(), ["hidden"])
        }],
        /**
         * Divide Width X
         * @see https://tailwindcss.com/docs/divide-width
         */
        "divide-x": [{
          "divide-x": [borderWidth]
        }],
        /**
         * Divide Width X Reverse
         * @see https://tailwindcss.com/docs/divide-width
         */
        "divide-x-reverse": ["divide-x-reverse"],
        /**
         * Divide Width Y
         * @see https://tailwindcss.com/docs/divide-width
         */
        "divide-y": [{
          "divide-y": [borderWidth]
        }],
        /**
         * Divide Width Y Reverse
         * @see https://tailwindcss.com/docs/divide-width
         */
        "divide-y-reverse": ["divide-y-reverse"],
        /**
         * Divide Opacity
         * @see https://tailwindcss.com/docs/divide-opacity
         */
        "divide-opacity": [{
          "divide-opacity": [opacity]
        }],
        /**
         * Divide Style
         * @see https://tailwindcss.com/docs/divide-style
         */
        "divide-style": [{
          divide: getLineStyles()
        }],
        /**
         * Border Color
         * @see https://tailwindcss.com/docs/border-color
         */
        "border-color": [{
          border: [borderColor]
        }],
        /**
         * Border Color X
         * @see https://tailwindcss.com/docs/border-color
         */
        "border-color-x": [{
          "border-x": [borderColor]
        }],
        /**
         * Border Color Y
         * @see https://tailwindcss.com/docs/border-color
         */
        "border-color-y": [{
          "border-y": [borderColor]
        }],
        /**
         * Border Color Top
         * @see https://tailwindcss.com/docs/border-color
         */
        "border-color-t": [{
          "border-t": [borderColor]
        }],
        /**
         * Border Color Right
         * @see https://tailwindcss.com/docs/border-color
         */
        "border-color-r": [{
          "border-r": [borderColor]
        }],
        /**
         * Border Color Bottom
         * @see https://tailwindcss.com/docs/border-color
         */
        "border-color-b": [{
          "border-b": [borderColor]
        }],
        /**
         * Border Color Left
         * @see https://tailwindcss.com/docs/border-color
         */
        "border-color-l": [{
          "border-l": [borderColor]
        }],
        /**
         * Divide Color
         * @see https://tailwindcss.com/docs/divide-color
         */
        "divide-color": [{
          divide: [borderColor]
        }],
        /**
         * Outline Style
         * @see https://tailwindcss.com/docs/outline-style
         */
        "outline-style": [{
          outline: [""].concat(getLineStyles())
        }],
        /**
         * Outline Offset
         * @see https://tailwindcss.com/docs/outline-offset
         */
        "outline-offset": [{
          "outline-offset": [isArbitraryValue, isLength]
        }],
        /**
         * Outline Width
         * @see https://tailwindcss.com/docs/outline-width
         */
        "outline-w": [{
          outline: [isLength]
        }],
        /**
         * Outline Color
         * @see https://tailwindcss.com/docs/outline-color
         */
        "outline-color": [{
          outline: [colors]
        }],
        /**
         * Ring Width
         * @see https://tailwindcss.com/docs/ring-width
         */
        "ring-w": [{
          ring: getLengthWithEmpty()
        }],
        /**
         * Ring Width Inset
         * @see https://tailwindcss.com/docs/ring-width
         */
        "ring-w-inset": ["ring-inset"],
        /**
         * Ring Color
         * @see https://tailwindcss.com/docs/ring-color
         */
        "ring-color": [{
          ring: [colors]
        }],
        /**
         * Ring Opacity
         * @see https://tailwindcss.com/docs/ring-opacity
         */
        "ring-opacity": [{
          "ring-opacity": [opacity]
        }],
        /**
         * Ring Offset Width
         * @see https://tailwindcss.com/docs/ring-offset-width
         */
        "ring-offset-w": [{
          "ring-offset": [isLength]
        }],
        /**
         * Ring Offset Color
         * @see https://tailwindcss.com/docs/ring-offset-color
         */
        "ring-offset-color": [{
          "ring-offset": [colors]
        }],
        // Effects
        /**
         * Box Shadow
         * @see https://tailwindcss.com/docs/box-shadow
         */
        shadow: [{
          shadow: ["", "inner", "none", isTshirtSize, isArbitraryShadow]
        }],
        /**
         * Box Shadow Color
         * @see https://tailwindcss.com/docs/box-shadow-color
         */
        "shadow-color": [{
          shadow: [isAny]
        }],
        /**
         * Opacity
         * @see https://tailwindcss.com/docs/opacity
         */
        opacity: [{
          opacity: [opacity]
        }],
        /**
         * Mix Blend Mode
         * @see https://tailwindcss.com/docs/mix-blend-mode
         */
        "mix-blend": [{
          "mix-blend": getBlendModes()
        }],
        /**
         * Background Blend Mode
         * @see https://tailwindcss.com/docs/background-blend-mode
         */
        "bg-blend": [{
          "bg-blend": getBlendModes()
        }],
        // Filters
        /**
         * Filter
         * @deprecated since Tailwind CSS v3.0.0
         * @see https://tailwindcss.com/docs/filter
         */
        filter: [{
          filter: ["", "none"]
        }],
        /**
         * Blur
         * @see https://tailwindcss.com/docs/blur
         */
        blur: [{
          blur: [blur]
        }],
        /**
         * Brightness
         * @see https://tailwindcss.com/docs/brightness
         */
        brightness: [{
          brightness: [brightness]
        }],
        /**
         * Contrast
         * @see https://tailwindcss.com/docs/contrast
         */
        contrast: [{
          contrast: [contrast]
        }],
        /**
         * Drop Shadow
         * @see https://tailwindcss.com/docs/drop-shadow
         */
        "drop-shadow": [{
          "drop-shadow": ["", "none", isTshirtSize, isArbitraryValue]
        }],
        /**
         * Grayscale
         * @see https://tailwindcss.com/docs/grayscale
         */
        grayscale: [{
          grayscale: [grayscale]
        }],
        /**
         * Hue Rotate
         * @see https://tailwindcss.com/docs/hue-rotate
         */
        "hue-rotate": [{
          "hue-rotate": [hueRotate]
        }],
        /**
         * Invert
         * @see https://tailwindcss.com/docs/invert
         */
        invert: [{
          invert: [invert]
        }],
        /**
         * Saturate
         * @see https://tailwindcss.com/docs/saturate
         */
        saturate: [{
          saturate: [saturate]
        }],
        /**
         * Sepia
         * @see https://tailwindcss.com/docs/sepia
         */
        sepia: [{
          sepia: [sepia]
        }],
        /**
         * Backdrop Filter
         * @deprecated since Tailwind CSS v3.0.0
         * @see https://tailwindcss.com/docs/backdrop-filter
         */
        "backdrop-filter": [{
          "backdrop-filter": ["", "none"]
        }],
        /**
         * Backdrop Blur
         * @see https://tailwindcss.com/docs/backdrop-blur
         */
        "backdrop-blur": [{
          "backdrop-blur": [blur]
        }],
        /**
         * Backdrop Brightness
         * @see https://tailwindcss.com/docs/backdrop-brightness
         */
        "backdrop-brightness": [{
          "backdrop-brightness": [brightness]
        }],
        /**
         * Backdrop Contrast
         * @see https://tailwindcss.com/docs/backdrop-contrast
         */
        "backdrop-contrast": [{
          "backdrop-contrast": [contrast]
        }],
        /**
         * Backdrop Grayscale
         * @see https://tailwindcss.com/docs/backdrop-grayscale
         */
        "backdrop-grayscale": [{
          "backdrop-grayscale": [grayscale]
        }],
        /**
         * Backdrop Hue Rotate
         * @see https://tailwindcss.com/docs/backdrop-hue-rotate
         */
        "backdrop-hue-rotate": [{
          "backdrop-hue-rotate": [hueRotate]
        }],
        /**
         * Backdrop Invert
         * @see https://tailwindcss.com/docs/backdrop-invert
         */
        "backdrop-invert": [{
          "backdrop-invert": [invert]
        }],
        /**
         * Backdrop Opacity
         * @see https://tailwindcss.com/docs/backdrop-opacity
         */
        "backdrop-opacity": [{
          "backdrop-opacity": [opacity]
        }],
        /**
         * Backdrop Saturate
         * @see https://tailwindcss.com/docs/backdrop-saturate
         */
        "backdrop-saturate": [{
          "backdrop-saturate": [saturate]
        }],
        /**
         * Backdrop Sepia
         * @see https://tailwindcss.com/docs/backdrop-sepia
         */
        "backdrop-sepia": [{
          "backdrop-sepia": [sepia]
        }],
        // Tables
        /**
         * Border Collapse
         * @see https://tailwindcss.com/docs/border-collapse
         */
        "border-collapse": [{
          border: ["collapse", "separate"]
        }],
        /**
         * Border Spacing
         * @see https://tailwindcss.com/docs/border-spacing
         */
        "border-spacing": [{
          "border-spacing": [borderSpacing]
        }],
        /**
         * Border Spacing X
         * @see https://tailwindcss.com/docs/border-spacing
         */
        "border-spacing-x": [{
          "border-spacing-x": [borderSpacing]
        }],
        /**
         * Border Spacing Y
         * @see https://tailwindcss.com/docs/border-spacing
         */
        "border-spacing-y": [{
          "border-spacing-y": [borderSpacing]
        }],
        /**
         * Table Layout
         * @see https://tailwindcss.com/docs/table-layout
         */
        "table-layout": [{
          table: ["auto", "fixed"]
        }],
        /**
         * Caption Side
         * @see https://tailwindcss.com/docs/caption-side
         */
        caption: [{
          caption: ["top", "bottom"]
        }],
        // Transitions and Animation
        /**
         * Tranisition Property
         * @see https://tailwindcss.com/docs/transition-property
         */
        transition: [{
          transition: ["none", "all", "", "colors", "opacity", "shadow", "transform", isArbitraryValue]
        }],
        /**
         * Transition Duration
         * @see https://tailwindcss.com/docs/transition-duration
         */
        duration: [{
          duration: getNumberAndArbitrary()
        }],
        /**
         * Transition Timing Function
         * @see https://tailwindcss.com/docs/transition-timing-function
         */
        ease: [{
          ease: ["linear", "in", "out", "in-out", isArbitraryValue]
        }],
        /**
         * Transition Delay
         * @see https://tailwindcss.com/docs/transition-delay
         */
        delay: [{
          delay: getNumberAndArbitrary()
        }],
        /**
         * Animation
         * @see https://tailwindcss.com/docs/animation
         */
        animate: [{
          animate: ["none", "spin", "ping", "pulse", "bounce", isArbitraryValue]
        }],
        // Transforms
        /**
         * Transform
         * @see https://tailwindcss.com/docs/transform
         */
        transform: [{
          transform: ["", "gpu", "none"]
        }],
        /**
         * Scale
         * @see https://tailwindcss.com/docs/scale
         */
        scale: [{
          scale: [scale]
        }],
        /**
         * Scale X
         * @see https://tailwindcss.com/docs/scale
         */
        "scale-x": [{
          "scale-x": [scale]
        }],
        /**
         * Scale Y
         * @see https://tailwindcss.com/docs/scale
         */
        "scale-y": [{
          "scale-y": [scale]
        }],
        /**
         * Rotate
         * @see https://tailwindcss.com/docs/rotate
         */
        rotate: [{
          rotate: [isInteger, isArbitraryValue]
        }],
        /**
         * Translate X
         * @see https://tailwindcss.com/docs/translate
         */
        "translate-x": [{
          "translate-x": [translate]
        }],
        /**
         * Translate Y
         * @see https://tailwindcss.com/docs/translate
         */
        "translate-y": [{
          "translate-y": [translate]
        }],
        /**
         * Skew X
         * @see https://tailwindcss.com/docs/skew
         */
        "skew-x": [{
          "skew-x": [skew]
        }],
        /**
         * Skew Y
         * @see https://tailwindcss.com/docs/skew
         */
        "skew-y": [{
          "skew-y": [skew]
        }],
        /**
         * Transform Origin
         * @see https://tailwindcss.com/docs/transform-origin
         */
        "transform-origin": [{
          origin: ["center", "top", "top-right", "right", "bottom-right", "bottom", "bottom-left", "left", "top-left", isArbitraryValue]
        }],
        // Interactivity
        /**
         * Accent Color
         * @see https://tailwindcss.com/docs/accent-color
         */
        accent: [{
          accent: ["auto", colors]
        }],
        /**
         * Appearance
         * @see https://tailwindcss.com/docs/appearance
         */
        appearance: ["appearance-none"],
        /**
         * Cursor
         * @see https://tailwindcss.com/docs/cursor
         */
        cursor: [{
          cursor: ["auto", "default", "pointer", "wait", "text", "move", "help", "not-allowed", "none", "context-menu", "progress", "cell", "crosshair", "vertical-text", "alias", "copy", "no-drop", "grab", "grabbing", "all-scroll", "col-resize", "row-resize", "n-resize", "e-resize", "s-resize", "w-resize", "ne-resize", "nw-resize", "se-resize", "sw-resize", "ew-resize", "ns-resize", "nesw-resize", "nwse-resize", "zoom-in", "zoom-out", isArbitraryValue]
        }],
        /**
         * Caret Color
         * @see https://tailwindcss.com/docs/just-in-time-mode#caret-color-utilities
         */
        "caret-color": [{
          caret: [colors]
        }],
        /**
         * Pointer Events
         * @see https://tailwindcss.com/docs/pointer-events
         */
        "pointer-events": [{
          "pointer-events": ["none", "auto"]
        }],
        /**
         * Resize
         * @see https://tailwindcss.com/docs/resize
         */
        resize: [{
          resize: ["none", "y", "x", ""]
        }],
        /**
         * Scroll Behavior
         * @see https://tailwindcss.com/docs/scroll-behavior
         */
        "scroll-behavior": [{
          scroll: ["auto", "smooth"]
        }],
        /**
         * Scroll Margin
         * @see https://tailwindcss.com/docs/scroll-margin
         */
        "scroll-m": [{
          "scroll-m": getSpacingWithArbitrary()
        }],
        /**
         * Scroll Margin X
         * @see https://tailwindcss.com/docs/scroll-margin
         */
        "scroll-mx": [{
          "scroll-mx": getSpacingWithArbitrary()
        }],
        /**
         * Scroll Margin Y
         * @see https://tailwindcss.com/docs/scroll-margin
         */
        "scroll-my": [{
          "scroll-my": getSpacingWithArbitrary()
        }],
        /**
         * Scroll Margin Start
         * @see https://tailwindcss.com/docs/scroll-margin
         */
        "scroll-ms": [{
          "scroll-ms": getSpacingWithArbitrary()
        }],
        /**
         * Scroll Margin End
         * @see https://tailwindcss.com/docs/scroll-margin
         */
        "scroll-me": [{
          "scroll-me": getSpacingWithArbitrary()
        }],
        /**
         * Scroll Margin Top
         * @see https://tailwindcss.com/docs/scroll-margin
         */
        "scroll-mt": [{
          "scroll-mt": getSpacingWithArbitrary()
        }],
        /**
         * Scroll Margin Right
         * @see https://tailwindcss.com/docs/scroll-margin
         */
        "scroll-mr": [{
          "scroll-mr": getSpacingWithArbitrary()
        }],
        /**
         * Scroll Margin Bottom
         * @see https://tailwindcss.com/docs/scroll-margin
         */
        "scroll-mb": [{
          "scroll-mb": getSpacingWithArbitrary()
        }],
        /**
         * Scroll Margin Left
         * @see https://tailwindcss.com/docs/scroll-margin
         */
        "scroll-ml": [{
          "scroll-ml": getSpacingWithArbitrary()
        }],
        /**
         * Scroll Padding
         * @see https://tailwindcss.com/docs/scroll-padding
         */
        "scroll-p": [{
          "scroll-p": getSpacingWithArbitrary()
        }],
        /**
         * Scroll Padding X
         * @see https://tailwindcss.com/docs/scroll-padding
         */
        "scroll-px": [{
          "scroll-px": getSpacingWithArbitrary()
        }],
        /**
         * Scroll Padding Y
         * @see https://tailwindcss.com/docs/scroll-padding
         */
        "scroll-py": [{
          "scroll-py": getSpacingWithArbitrary()
        }],
        /**
         * Scroll Padding Start
         * @see https://tailwindcss.com/docs/scroll-padding
         */
        "scroll-ps": [{
          "scroll-ps": getSpacingWithArbitrary()
        }],
        /**
         * Scroll Padding End
         * @see https://tailwindcss.com/docs/scroll-padding
         */
        "scroll-pe": [{
          "scroll-pe": getSpacingWithArbitrary()
        }],
        /**
         * Scroll Padding Top
         * @see https://tailwindcss.com/docs/scroll-padding
         */
        "scroll-pt": [{
          "scroll-pt": getSpacingWithArbitrary()
        }],
        /**
         * Scroll Padding Right
         * @see https://tailwindcss.com/docs/scroll-padding
         */
        "scroll-pr": [{
          "scroll-pr": getSpacingWithArbitrary()
        }],
        /**
         * Scroll Padding Bottom
         * @see https://tailwindcss.com/docs/scroll-padding
         */
        "scroll-pb": [{
          "scroll-pb": getSpacingWithArbitrary()
        }],
        /**
         * Scroll Padding Left
         * @see https://tailwindcss.com/docs/scroll-padding
         */
        "scroll-pl": [{
          "scroll-pl": getSpacingWithArbitrary()
        }],
        /**
         * Scroll Snap Align
         * @see https://tailwindcss.com/docs/scroll-snap-align
         */
        "snap-align": [{
          snap: ["start", "end", "center", "align-none"]
        }],
        /**
         * Scroll Snap Stop
         * @see https://tailwindcss.com/docs/scroll-snap-stop
         */
        "snap-stop": [{
          snap: ["normal", "always"]
        }],
        /**
         * Scroll Snap Type
         * @see https://tailwindcss.com/docs/scroll-snap-type
         */
        "snap-type": [{
          snap: ["none", "x", "y", "both"]
        }],
        /**
         * Scroll Snap Type Strictness
         * @see https://tailwindcss.com/docs/scroll-snap-type
         */
        "snap-strictness": [{
          snap: ["mandatory", "proximity"]
        }],
        /**
         * Touch Action
         * @see https://tailwindcss.com/docs/touch-action
         */
        touch: [{
          touch: ["auto", "none", "pinch-zoom", "manipulation", {
            pan: ["x", "left", "right", "y", "up", "down"]
          }]
        }],
        /**
         * User Select
         * @see https://tailwindcss.com/docs/user-select
         */
        select: [{
          select: ["none", "text", "all", "auto"]
        }],
        /**
         * Will Change
         * @see https://tailwindcss.com/docs/will-change
         */
        "will-change": [{
          "will-change": ["auto", "scroll", "contents", "transform", isArbitraryValue]
        }],
        // SVG
        /**
         * Fill
         * @see https://tailwindcss.com/docs/fill
         */
        fill: [{
          fill: [colors, "none"]
        }],
        /**
         * Stroke Width
         * @see https://tailwindcss.com/docs/stroke-width
         */
        "stroke-w": [{
          stroke: [isLength, isArbitraryNumber]
        }],
        /**
         * Stroke
         * @see https://tailwindcss.com/docs/stroke
         */
        stroke: [{
          stroke: [colors, "none"]
        }],
        // Accessibility
        /**
         * Screen Readers
         * @see https://tailwindcss.com/docs/screen-readers
         */
        sr: ["sr-only", "not-sr-only"]
      },
      conflictingClassGroups: {
        overflow: ["overflow-x", "overflow-y"],
        overscroll: ["overscroll-x", "overscroll-y"],
        inset: ["inset-x", "inset-y", "start", "end", "top", "right", "bottom", "left"],
        "inset-x": ["right", "left"],
        "inset-y": ["top", "bottom"],
        flex: ["basis", "grow", "shrink"],
        gap: ["gap-x", "gap-y"],
        p: ["px", "py", "ps", "pe", "pt", "pr", "pb", "pl"],
        px: ["pr", "pl"],
        py: ["pt", "pb"],
        m: ["mx", "my", "ms", "me", "mt", "mr", "mb", "ml"],
        mx: ["mr", "ml"],
        my: ["mt", "mb"],
        "font-size": ["leading"],
        "fvn-normal": ["fvn-ordinal", "fvn-slashed-zero", "fvn-figure", "fvn-spacing", "fvn-fraction"],
        "fvn-ordinal": ["fvn-normal"],
        "fvn-slashed-zero": ["fvn-normal"],
        "fvn-figure": ["fvn-normal"],
        "fvn-spacing": ["fvn-normal"],
        "fvn-fraction": ["fvn-normal"],
        rounded: ["rounded-s", "rounded-e", "rounded-t", "rounded-r", "rounded-b", "rounded-l", "rounded-ss", "rounded-se", "rounded-ee", "rounded-es", "rounded-tl", "rounded-tr", "rounded-br", "rounded-bl"],
        "rounded-s": ["rounded-ss", "rounded-es"],
        "rounded-e": ["rounded-se", "rounded-ee"],
        "rounded-t": ["rounded-tl", "rounded-tr"],
        "rounded-r": ["rounded-tr", "rounded-br"],
        "rounded-b": ["rounded-br", "rounded-bl"],
        "rounded-l": ["rounded-tl", "rounded-bl"],
        "border-spacing": ["border-spacing-x", "border-spacing-y"],
        "border-w": ["border-w-s", "border-w-e", "border-w-t", "border-w-r", "border-w-b", "border-w-l"],
        "border-w-x": ["border-w-r", "border-w-l"],
        "border-w-y": ["border-w-t", "border-w-b"],
        "border-color": ["border-color-t", "border-color-r", "border-color-b", "border-color-l"],
        "border-color-x": ["border-color-r", "border-color-l"],
        "border-color-y": ["border-color-t", "border-color-b"],
        "scroll-m": ["scroll-mx", "scroll-my", "scroll-ms", "scroll-me", "scroll-mt", "scroll-mr", "scroll-mb", "scroll-ml"],
        "scroll-mx": ["scroll-mr", "scroll-ml"],
        "scroll-my": ["scroll-mt", "scroll-mb"],
        "scroll-p": ["scroll-px", "scroll-py", "scroll-ps", "scroll-pe", "scroll-pt", "scroll-pr", "scroll-pb", "scroll-pl"],
        "scroll-px": ["scroll-pr", "scroll-pl"],
        "scroll-py": ["scroll-pt", "scroll-pb"]
      },
      conflictingClassGroupModifiers: {
        "font-size": ["leading"]
      }
    };
  }

  // node_modules/tailwind-merge/dist/lib/tw-merge.mjs
  var twMerge = /* @__PURE__ */ createTailwindMerge(getDefaultConfig);

  // app/components/flowbite/clickable_controller.ts
  var clickable_controller_default = class extends Controller {
    static classes = ["active", "disabled"];
    static targets = ["active", "loading"];
    static values = {
      state: {
        type: String,
        default: "active"
      }
    };
    get isLink() {
      return this.element.tagName.toLowerCase() === "a";
    }
    get isButton() {
      return !this.isLink;
    }
    connect() {
      super.connect();
      this.element.addEventListener("click", this.handleClick.bind(this));
    }
    activeTargetConnected(element) {
      this.toggleActiveTargetVisibility(element);
    }
    loadingTargetConnected(element) {
      this.toggleLoadingTargetVisibility(element);
    }
    stateValueChanged() {
      this.toggleClass();
      this.toggleAriaDisabled();
      this.toggleVisibility();
    }
    handleClick(event) {
      if (this.stateValue !== "active") {
        event.preventDefault();
      }
    }
    toggleAriaDisabled() {
      if (this.isLink) {
        this.element.setAttribute("aria-disabled", this.stateValue !== "active" ? "true" : "false");
      } else if (this.stateValue === "active") {
        this.element.removeAttribute("disabled");
      } else {
        this.element.setAttribute("disabled", "disabled");
      }
    }
    toggleClass() {
      let classes = this.activeClasses;
      if (this.stateValue !== "active") {
        classes = [...classes, ...this.disabledClasses];
      }
      this.element.className = twMerge(classes.join(" "));
    }
    toggleVisibility() {
      this.activeTargets.forEach((e) => this.toggleActiveTargetVisibility(e));
      this.loadingTargets.forEach((e) => this.toggleLoadingTargetVisibility(e));
    }
    toggleActiveTargetVisibility(element) {
      element.classList.toggle("hidden", this.stateValue === "loading");
    }
    toggleLoadingTargetVisibility(element) {
      element.classList.toggle("hidden", this.stateValue !== "loading");
    }
  };

  // app/components/flowbite/dismiss_controller.ts
  var dismiss_controller_default = class extends Controller {
    static classes = ["transition"];
    static values = {
      target: String,
      duration: Number,
      timing: String
    };
    get targetElement() {
      return document.getElementById(this.targetValue);
    }
    connect() {
      super.connect();
      if (this.targetElement) {
        this.attach();
      }
    }
    hide() {
      this._dismiss && this._dismiss.hide();
    }
    attach() {
      const options = { onHide: this.onHide.bind(this) };
      this.hasTransitionClass && (options.transaction = this.transitionClasses.join(" "));
      this.hasDurationValue && (options.duration = this.durationValue);
      this.hasTimingValue && (options.timing = this.timingValue);
      this._dismiss = new dismiss_default(this.targetElement, this.element, options);
    }
    onHide() {
      this.dispatch("hide", { target: this.targetElement });
      this.dispatch("hide");
    }
  };

  // app/components/flowbite/dropdown_controller.ts
  var dropdown_controller_default = class extends Controller {
    static values = {
      dropdown: String,
      placement: String,
      triggerType: String,
      offsetSkidding: Number,
      offsetDistance: Number,
      delay: Number,
      ignoreClickOutsideClass: String
    };
    get dropdownElement() {
      return document.getElementById(this.dropdownValue);
    }
    get isVisible() {
      return this._dropdown ? false : this._dropdown.isVisible();
    }
    connect() {
      super.connect();
      if (this.dropdownElement) {
        this.attach();
      }
    }
    show() {
      if (this._dropdown) {
        this._dropdown.show();
      }
    }
    hide() {
      if (this._dropdown) {
        this._dropdown.hide();
      }
    }
    toggle() {
      if (this._dropdown) {
        this._dropdown.toggle();
      }
    }
    attach() {
      const options = {
        onHide: this.onHide.bind(this),
        onShow: this.onShow.bind(this),
        onToggle: this.onToggle.bind(this)
      };
      this.hasPlacementValue && (options.placement = this.placementValue);
      this.hasTriggerTypeValue && (options.triggerType = this.triggerTypeValue);
      this.hasOffsetDistanceValue && (options.offsetDistance = this.offsetDistanceValue);
      this.hasOffsetSkiddingValue && (options.offsetSkidding = this.offsetSkiddingValue);
      this.hasDelayValue && (options.delay = this.delayValue);
      this.hasIgnoreClickOutsideClass && (options.ignoreClickOutsideClass = this.ignoreClickOutsideClassValue);
      this._dropdown = new dropdown_default(this.dropdownElement, this.element, options);
    }
    onToggle() {
      const detail = { visible: this.isVisible };
      this.dispatch("toggle", { target: this.dropdownElement, detail });
      this.dispatch("toggle", { detail });
    }
    onShow() {
      this.dispatch("shown", { target: this.dropdownElement });
      this.dispatch("shown");
    }
    onHide() {
      this.dispatch("hidden", { target: this.dropdownElement });
      this.dispatch("hidden");
    }
  };

  // src/registerControllers.ts
  var fullControllerName = (namespace, name) => namespace && namespace.length > 0 ? `${namespace}-${name}` : name;
  var registerControllers_default = (application, namespace = "flowbite-") => {
    application.register(fullControllerName(namespace, "clickable"), clickable_controller_default);
    application.register(fullControllerName(namespace, "dismiss"), dismiss_controller_default);
    application.register(fullControllerName(namespace, "dropdown"), dropdown_controller_default);
  };

  // test/dummy/app/javascript/application.js
  window.Stimulus = Application.start();
  Stimulus.debug = true;
  registerControllers_default(Stimulus);
})();
//# sourceMappingURL=/assets/application.js.map
