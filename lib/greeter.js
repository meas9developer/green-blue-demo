'use strict';

function greet(name) {
    name = name || 'World';
    return `Namaste, ${name}!`;
}

module.exports = {
    greet
};
