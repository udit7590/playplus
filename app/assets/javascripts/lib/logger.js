var Logger = function(context, options) {
  this.context  = context;

  this.options   = options || {};
  this.options   =  $.extend({}, this.defaults, this.options);
}

// Instance methods
Logger.prototype.debug = function(message) {
  this.log(message, 1);
};

Logger.prototype.info = function(message) {
  this.log(message, 2);
};

Logger.prototype.warn = function(message) {
  this.log(message, 3);
};

Logger.prototype.error = function(message) {
  this.log(message, 4);
};

Logger.prototype.fatal = function(message) {
  this.log(message, 5);
};

Logger.prototype.log = function(message, level) {
  if (Logger.defaults.debug) {
    console.log(Logger.generateMessage(message, level || Logger.level, this.context));
  }
};

Logger.generateMessage = function(message, level, context) {
  var finalMessage = '[' + Logger.levels[level] + '] ' + message;
  if (context.length > 0) {
    finalMessage = '[' + context + ']' + finalMessage
  }
  return finalMessage;
};

// Class definition
Logger.defaults = {
  debug : true,
  level : 2,
}

Logger.levels = {
  1: 'debug',
  2: 'info',
  3: 'warn',
  4: 'error',
  5: 'fatal'
}
