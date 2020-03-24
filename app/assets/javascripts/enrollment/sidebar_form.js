var EnrollmentSidebarForm = function($form, options) {
  this.$form   = $form;
  this.options = options || {};

  this.options =  $.extend({}, this.defaults, this.options);
  this.logger  = new Logger(this.options.loggerContext);
  this.initialize();
}

/* ****************************************************************************************** 
**  Initialization Section
****************************************************************************************** */
EnrollmentSidebarForm.prototype.initialize = function() {
  this.findComponents();
  this.bindEvents();
  this.$jsLocationSelect.trigger('change');
};

/* ****************************************************************************************** 
**  Initialization Section: Finding Components
****************************************************************************************** */
EnrollmentSidebarForm.prototype.findComponents = function() {
  this.$jsLocationSelect       = this.$form.find('.js-location-select');
  this.$jsCourseLevelSelect    = this.$form.find('.js-course-level-select');
  // this.$jsCourseLevelText      = this.$form.find('.js-course-level-text');
  // this.$jsCourseLevelHidden    = this.$form.find('.js-course-level-text-hidden');
  this.$jsCourseBatchSelect    = this.$form.find('.js-course-batch-select');
  this.$courseDetailsContainer = this.$form.find('.js-course-details');
  this.$submitButton           = this.$form.find('.js-course-enroll-btn');
};

/* ****************************************************************************************** 
**  Initialization Section: Binding Events
****************************************************************************************** */
EnrollmentSidebarForm.prototype.bindEvents = function() {
  this.bindLocationChangeEvent();
  this.bindCourseLevelChangeEvent();
  this.bindCourseBatchChangeEvent();
};

EnrollmentSidebarForm.prototype.bindLocationChangeEvent = function() {
  var _this = this;

  this.$jsLocationSelect.change(function() {
    var $this = $(this),
        $nullOption = $this.find('option[value=""]');

    if (!!this.value) {
      $.ajax({
        url: Routes.CourseLevel.fetchFormLocationUrl(this.value),
        type: 'GET',
        dataType: 'json'
      }).done(function(jsonData) {
        $nullOption.remove();
        _this.populateCourseLevels(jsonData);
        // Enable Submit Button
      }).error(function() {
        $nullOption.attr('selected', true);
      });
    }
  });
};

EnrollmentSidebarForm.prototype.bindCourseLevelChangeEvent = function() {
  var _this = this;

  this.$jsCourseLevelSelect.change(function() {
    var $this = $(this),
        $optionField = $this.find('option[value="' + this.value + '"]');
    _this.populateCourseBatches($optionField);
  });
};

EnrollmentSidebarForm.prototype.bindCourseBatchChangeEvent = function() {
  var _this = this;

  this.$jsCourseBatchSelect.change(function() {
    var $this = $(this),
        $optionField = $this.find('option[value="' + this.value + '"]');

    // Fill course details
    _this.populateCourseDetails($optionField);
  });
};

/* ****************************************************************************************** 
**  Populate Page Fields Section
****************************************************************************************** */
EnrollmentSidebarForm.prototype.populateCourseLevels = function(jsonData) {
  // Clear select box
  this.$jsCourseLevelSelect.html('');

  // Populate course levels
  // Add course level json as data attribute `level` for level json.
  for (level in jsonData.course_levels) {
    var levelJson = jsonData.course_levels[level];
    this.$jsCourseLevelSelect.append(
      $('<option>', { value: levelJson.id })
      .html(levelJson.name)
      .data('level', levelJson)
    );
  }
  // Select first level (Trigger change)
  this.$jsCourseLevelSelect.trigger('change');
};

EnrollmentSidebarForm.prototype.populateCourseBatches = function($optionField) {
  var jsonData = $optionField.data('level').course_batches;
  // Clear select box
  this.$jsCourseBatchSelect.html('');

  // Populate course batches
  // Add course batch json as data attribute `batch` for batch json. Also set data attribute `levelField`.
  for (batch in jsonData) {
    var batchJson = jsonData[batch];
    this.$jsCourseBatchSelect.append(
      $('<option>', { value: batchJson.id })
      .html(batchJson.start_date_display + ' - ' + batchJson.end_date_display)
      .data('batch', batchJson)
      .data('levelField', $optionField)
    );
  }

  // Populate course batch for level
  this.$jsCourseBatchSelect.trigger('change');
};

EnrollmentSidebarForm.prototype.populateCourseDetails = function($optionField) {
  var levelJson = $optionField.data('levelField').data('level'),
      batchJson = $optionField.data('batch');

  // Populate course details table
  this.$courseDetailsContainer.find('.js-course-duration').html(levelJson.duration_display);
  this.$courseDetailsContainer.find('.js-course-total-sessions').html(levelJson.sessions);
  this.$courseDetailsContainer.find('.js-course-session-duration').html(levelJson.session_duration_display);
  this.$courseDetailsContainer.find('.js-course-starting-from').html(batchJson.start_date_display);
  this.$courseDetailsContainer.find('.js-course-ends-on').html(batchJson.end_date_display);
  this.$courseDetailsContainer.find('.js-course-price').html(levelJson.price_display);
  this.$courseDetailsContainer.find('.js-course-taxes').html(levelJson.taxes_display);
  this.$courseDetailsContainer.find('.js-course-total-price').html(levelJson.net_amount_display);

};

/* ****************************************************************************************** 
**  Defaults Section
****************************************************************************************** */
EnrollmentSidebarForm.prototype.defaults = {
  loggerContext : 'EnrollmentSidebarForm'
};

/* ****************************************************************************************** 
**  Initialize Page Section
****************************************************************************************** */
$(function() {
  new EnrollmentSidebarForm($('.js-enrollment-sidebar-form'));
});
