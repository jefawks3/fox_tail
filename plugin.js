const plugin = require('tailwindcss/plugin');

const FLOATING_ALIGNMENTS = ['start', 'center', 'end'];
const FLOATING_AXIS = {
    y: ['top', 'bottom'],
    x: ['left', 'right']
}

const getFloatingPlacement = function(side, alignment) {
    return alignment === "center" ? side : `${side}-${alignment}`;
}

const getFloatingSelector = function(side, alignment) {
    return `&[data-floating-placement=${getFloatingPlacement(side, alignment)}]`
}

const getGroupFloatingSelector = function(side, alignment) {
    return `:merge(.group)[data-floating-placement=${getFloatingPlacement(side, alignment)}] &`
}

module.exports = plugin(
    function(options) {
        Object.keys(FLOATING_AXIS).forEach(function(axis) {
            options.addVariant(`floating-${axis}`, FLOATING_AXIS[axis].reduce(function(selectors, side) {
                FLOATING_ALIGNMENTS.forEach(function(alignment) {
                    selectors.push(getFloatingSelector(side, alignment));
                });

                return selectors;
            }, []));

            options.addVariant(`group-floating-${axis}`, FLOATING_AXIS[axis].reduce(function(selectors, side) {
                FLOATING_ALIGNMENTS.forEach(function(alignment) {
                    selectors.push(getGroupFloatingSelector(side, alignment));
                });

                return selectors;
            }, []));


            FLOATING_AXIS[axis].forEach(function(side) {
                options.addVariant(`floating-${side}`, FLOATING_ALIGNMENTS.map(function(alignment) {
                    return getFloatingSelector(side, alignment);
                }));

                options.addVariant(`group-floating-${side}`, FLOATING_ALIGNMENTS.map(function(alignment) {
                    return getGroupFloatingSelector(side, alignment);
                }));

                FLOATING_ALIGNMENTS.forEach(function(alignment) {
                    options.addVariant(`floating-${side}-${alignment}`, getFloatingSelector(side, alignment));
                    options.addVariant(`group-floating-${side}-${alignment}`, getGroupFloatingSelector(side, alignment));
                });
            });
        });
    }
);

