var TemplateRenderer = function(template, data, $target, options) {
  this.template  = template;
  this.data      = data;
  this.$target   = $target;
  this.options   = options || {};

  this.options   =  $.extend({}, this.defaults, this.options);
  this.logger    = new Logger(this.options.loggerContext);
}

TemplateRenderer.prototype.getHTML = function() {
  var htmlTemplate = Handlebars.compile(this.template),
      html         = htmlTemplate(this.data);

  this.logger.info("HTML generated");
  return html;
};

TemplateRenderer.prototype.render = function() {
  var htmlToRender = this.getHTML(),
      $htmlToRender = $(htmlToRender);

  this.logger.info("HTML rendering with mode: " + this.options.mode);
  switch(this.options.mode) {
    case 0:
      $(this.$target).html($htmlToRender);
      break;
    case 1:
      $(this.$target).append($htmlToRender);
      break;
    case 2:
      $(this.$target).prepend($htmlToRender);
      break;
    case 3:
      $(this.$target).replaceWith($htmlToRender);
      break;
  }
  this.logger.info("HTML rendered");
  return $htmlToRender;
};

TemplateRenderer.prototype.defaults = {
  loggerContext : 'TemplateRenderer',

  // 0: replace inner html, 1: append, 2: prepend, 3: replace complete DOM element
  mode          : 1
};
