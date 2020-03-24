/**----------------------------------------------------------------------------------------------------------
 * This library exposes the common utility functions in a UtilityFunctions scope.
 ----------------------------------------------------------------------------------------------------------*/

UtilityFunctions = {};

/**----------------------------------------------------------------------------------------------------------
 * Below are the functions which can be invoked from anywhere to show or hide loader.
 *
 * It depends on jquery loader library. Kindly locate those files in vendor assets to override.
 ----------------------------------------------------------------------------------------------------------*/
UtilityFunctions.showLoader = function () {
  $.loader({
    className:"blue-with-image-2",
    content:''
  });
}

UtilityFunctions.hideLoader = function () {
  $.loader('close');
}

/**----------------------------------------------------------------------------------------------------------
 * Below are the functions which can be invoked from anywhere to show appropriate success or error messages.
 *
 * Kindly refer /app/views/shared/_js_flash.html.erb for flash structure.
 * That paartial is needed to show flash messages.
 ----------------------------------------------------------------------------------------------------------*/
UtilityFunctions.$successFlash  = $('#js-flash-notice');
UtilityFunctions.$errorFlash    = $('#js-flash-alert');
UtilityFunctions.flashTimeout   = 10000;
UtilityFunctions.flashHideDelay = 1000;

UtilityFunctions.showSuccessFlash = function (message) {
  UtilityFunctions.$errorFlash.addClass('hidden');
  UtilityFunctions.loadMessageInFlash(UtilityFunctions.$successFlash, message);
  UtilityFunctions.$successFlash.removeClass('hidden');
  setTimeout(function () { UtilityFunctions.$successFlash.addClass('hidden', UtilityFunctions.flashHideDelay); }
             , UtilityFunctions.flashTimeout)
}

UtilityFunctions.showErrorFlash = function (message) {
  UtilityFunctions.$successFlash.addClass('hidden');
  UtilityFunctions.loadMessageInFlash(UtilityFunctions.$errorFlash, message);
  UtilityFunctions.$errorFlash.removeClass('hidden');
  setTimeout(function () { UtilityFunctions.$errorFlash.addClass('hidden', UtilityFunctions.flashHideDelay); }
             , UtilityFunctions.flashTimeout)

}

UtilityFunctions.hideSuccessFlashImmediately = function () {
  UtilityFunctions.loadMessageInFlash(UtilityFunctions.$successFlash, '');
  UtilityFunctions.$successFlash.addClass('hidden');
}

UtilityFunctions.hideErrorFlashImmediately = function () {
  UtilityFunctions.loadMessageInFlash(UtilityFunctions.$errorFlash, '');
  UtilityFunctions.$errorFlash.addClass('hidden');
}

UtilityFunctions.hideAllFlashImmediately = function () {
  UtilityFunctions.hideSuccessFlashImmediately();
  UtilityFunctions.hideErrorFlashImmediately();
}

UtilityFunctions.loadMessageInFlash = function ($flash, message) {
  if ($flash && message) {
    var flashTextNodesArray = $flash.contents().filter(function() { return this.nodeType == 3})
    if (flashTextNodesArray.length === 0) {
      $flash.prepend(document.createTextNode(message));
    } else {
      flashTextNodesArray.first().get(0).textContent = message;
    }
  }
}
