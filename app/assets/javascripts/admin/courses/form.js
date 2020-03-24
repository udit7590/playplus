//= require admin/courses/uploader.js

$(function() {
  var $form = $('form.courses-form');

  new Uploader($form.find('.file-block')).initialize();

  // Handle upload events to enable/disable submit button
  $(document).on('upload:inProgress', function(event, uploader) {
    $form.find('input[type=submit]').attr('disabled', true);
  });
  $(document).on('upload:always', function(event, uploader) {
    $form.find('input[type=submit]').removeAttr('disabled');
  });

});
