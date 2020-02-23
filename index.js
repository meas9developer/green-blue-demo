'use strict';

const greeter = require('./lib/greeter');

process.stdout.write("index hello: ");
exports.lambda_handler = function(event, context) {
    console.log('Event:', JSON.stringify(event));
    
    const greeting = greeter.greet(event.name);
    context.succeed({greeting: greeting});
};
