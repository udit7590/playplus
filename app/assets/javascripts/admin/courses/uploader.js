var Uploader = function($fileBlock, options) {
  this.$fileBlock   = $fileBlock;

  this.lastUploadRequest = undefined;

  this.options = options || {};
  this.options =  $.extend({}, this.defaults, this.options);
  this.logger  = new Logger(this.options.loggerContext);
  this.loadElements();
};

Uploader.prototype.loadElements = function() {
  this.$fileElement      = this.$fileBlock.find('input[type=file]');
  this.$previewContainer = this.$fileBlock.find(this.options.previewSelector);
  this.$progressBlock    = this.$fileBlock.find(this.options.progressBarSelector);
  this.$cloudinaryBlock  = this.$fileBlock.find(this.options.cloudinarySelector);
  this.$cloudinaryHashId = this.$fileBlock.find(this.options.updateCloudinaryImagePublicIdSelector);
  this.$existingImageId  = this.$fileBlock.find(this.options.existingImageSelector);
  this.$errorBlock       = this.$fileBlock.siblings('.parsley-errors-list.js-cloudinary-error');
};

Uploader.prototype.initialize = function() {
  this.buildCloudinaryUploader();
  this.cacheUploadRequestUsingFileAddEvent();
  if (this.isDragDropMode()) {
    this.buildDropzone();
  }
  this.makeBlockAsFileSelector();
  if (this.isPercentageModeProgress()) {
    this.setProgressIndicator();
  }
  this.bindCompletionEvent();
  this.bindErrorEvent();
  this.bindAlwaysEvent();
  this.addRemoveDropzoneTransparentBackground();
};

Uploader.prototype.showErrorMessage = function(message) {
  if (this.options.showErrorsInFlash) {
    UtilityFunctions.showErrorFlash(message);
  } else {
    this.$errorBlock.removeClass('hide');
    this.$errorBlock.append($('<li>').html(message));
  }
};

Uploader.prototype.hideErrorMessage = function(message) {
  if (this.options.showErrorsInFlash) {
    UtilityFunctions.hideAllFlashImmediately();
  } else {
    this.$errorBlock.html('');
    this.$errorBlock.addClass('hide');
  }
};

Uploader.prototype.initializeImage = function(data) {
  if (!!data.service_unique_id) {
    this.$previewContainer
    .html(this.buildCloudinaryImage(data.service_unique_id, { version: data.service_file_version }));
  }
};

Uploader.prototype.buildCloudinaryUploader = function() {
  var _this = this;

  // NOTE: There seems to be an issue with cloudinary plugin. The passed options are
  // not correctly received in the plugin. We can remove manual code validation once that is fixed.
  // https://github.com/cloudinary/cloudinary_gem/issues/184
  this.$cloudinaryBlock.cloudinary_fileupload({
    autoUpload: false,
    replaceFileInput: false,
    dropZone: _this.$fileBlock,
    maxFileSize: _this.options.maxFileSize,
    acceptFileTypes: _this.options.allowedFileTypes
  });
};

Uploader.prototype.cacheUploadRequestUsingFileAddEvent = function() {
  var _this = this;

  this.$cloudinaryBlock.bind('fileuploadadd', function(e, data) {
    _this.validateFile(data.files[0]).then(function () {
      _this.$fileElement.attr('disabled', true);
      _this.hideErrorMessage();

      if (_this.isLoaderModeProgress()) {
        _this.showLoader();
      } else if (_this.isPercentageModeProgress()) {
        _this.$progressBlock.removeClass('hide');
      }

      $(document).trigger('upload:inProgress', [_this]);
      _this.lastUploadRequest = data.submit();
    })
  });
};

// NOTE: Manual validation till issue is fixed on cloudinary
// https://github.com/cloudinary/cloudinary_gem/issues/184
Uploader.prototype.validateFile = function(file) {
  var _this               = this;
  var isValid             = true;
  var fileValidationDefer = $.Deferred();

  this.hideErrorMessage();

  if (file.size > this.options.maxFileSize) {
    isValid = false;
    this.showErrorMessage('File size should be at max: ' + (this.options.maxFileSize / (1024 * 1024)) + ' MB');
    fileValidationDefer.reject();
  }
  if (isValid && !this.options.allowedFileMimeTypes.test(file.type)) {
    isValid = false;
    this.showErrorMessage('File type is not supported');
    fileValidationDefer.reject();
  }

  if (isValid && this.options.minimumWidth) {
    this.validateMinimumWidth(file).then(function (isValid) {
      if (isValid) {
        fileValidationDefer.resolve();
      } else {
        _this.showErrorMessage('The minimum width of the file should be ' + _this.options.minimumWidth + 'px.');
        fileValidationDefer.reject();
      }
    })
  } else {
    fileValidationDefer.resolve();
  }

  return fileValidationDefer.promise();
}

Uploader.prototype.validateMinimumWidth = function(file) {
  var widthValidDeferred = $.Deferred();
  var _this              = this;
  var url                = window.URL || window.webkitURL;
  var image              = new Image();

  image.onload = function () {
    if (image.width >= _this.options.minimumWidth) {
      widthValidDeferred.resolve(true);
    } else {
      widthValidDeferred.resolve(false);
    }
  }
  image.src = url.createObjectURL(file);

  return widthValidDeferred.promise();
};

Uploader.prototype.buildDropzone = function() {
  var _this = this;

  $(document).bind('dragover', function (e) {
      var dropZone = _this.$fileBlock,
          timeout = window.dropZoneTimeout;

      if (!timeout) {
        dropZone.addClass('in');
      } else {
        clearTimeout(timeout);
      }

      var found = false,
        node = e.target;
      do {
        if (node === dropZone[0]) {
          found = true;
          break;
        }
        node = node.parentNode;
      } while (node != null);

      if (found) {
        dropZone.addClass('hover');
      } else {
        dropZone.removeClass('hover');
      }

      window.dropZoneTimeout = setTimeout(function () {
        window.dropZoneTimeout = null;
        dropZone.removeClass('in hover');
      }, 100);
  });
};

Uploader.prototype.makeBlockAsFileSelector = function() {
  var _this = this;

  this.$fileElement.hide();

  // This makes sure event is not bubbled up to file-block
  this.$fileElement.click(function(event) {
    event.stopPropagation();
  });

  // This triggers upload file functionality on file-block click
  this.$fileBlock.click(function() {
    _this.$fileElement.click();
  });
};

Uploader.prototype.setProgressIndicator = function() {
  var _this = this;

  this.$cloudinaryBlock.bind('fileuploadprogress', function(e, data) {
    _this.$progressBlock.find('.progress-bar').css('width', Math.round((data.loaded * 100.0) / data.total) + '%');
  });
};

Uploader.prototype.bindCompletionEvent = function() {
  var _this = this;

  this.$cloudinaryBlock.bind('cloudinarydone', function(e, data) {
    _this.$previewContainer
    .html(_this.buildCloudinaryImage(data.result.public_id, { version: data.result.version }));

    _this.$cloudinaryHashId.val(data.result.public_id);
    _this.addRemoveDropzoneTransparentBackground();
    $(document).trigger('upload:done', [_this]);
    return true;
  });
};

Uploader.prototype.bindErrorEvent = function() {
  var _this = this;

  $(this.$fileBlock.find(this.options.cloudinarySelector)).bind('cloudinaryfail', function(e, data) {
    console.log('Something went wrong while uploading. Please try again.');
    $(document).trigger('upload:failed', [_this]);
    // Add some error class to signify error if required
  });
};

Uploader.prototype.bindAlwaysEvent = function() {
  var _this = this;

  this.$cloudinaryBlock.bind('cloudinaryalways', function(e, data) {
    _this.$progressBlock.addClass('hide');
    _this.$fileElement.removeAttr('disabled');
    if (_this.isPercentageModeProgress()) {
      _this.$progressBlock.find('.progress-bar').css('width', '0%');
    } else if (_this.isLoaderModeProgress()) {
      _this.hideLoader();
    }
    $(document).trigger('upload:always', [_this]);
  });
};

Uploader.prototype.buildCloudinaryImage = function(public_id, options) {
  options = options || {};

  return ($.cloudinary.image(public_id,
      {
        version: options['version'] || this.options.imageOptions.version,
        crop: options['type'] || this.options.imageOptions.displayType,
        width: options['width'] || this.options.imageOptions.width,
        height: options['height'] || this.options.imageOptions.height
      }
    ).addClass(this.options.imageOptions.class)
  );
};

Uploader.prototype.cancelUpload = function() {
  if (this.lastUploadRequest) {
    this.lastUploadRequest.abort();
    this.lastUploadRequest = null;
    console.log("Canceled");
  }
};

// --------------------------------------------------------------------------------------------------------------------
// Section For Utility Methods
// --------------------------------------------------------------------------------------------------------------------
Uploader.prototype.isPercentageModeProgress = function() {
  return this.options.progressMode == 1;
};

Uploader.prototype.isLoaderModeProgress = function() {
  return this.options.progressMode == 0;
};

Uploader.prototype.isDragDropMode = function() {
  return this.options.dragDropMode;
};

Uploader.prototype.showLoader = function() {
  UtilityFunctions.showLoader();
};

Uploader.prototype.hideLoader = function() {
  UtilityFunctions.hideLoader();
};

Uploader.prototype.removeDropzoneBackground = function() {
  this.$fileBlock.addClass(this.options.fileBlockTransparentClass);
};

Uploader.prototype.addDropzoneBackground = function() {
  this.$fileBlock.removeClass(this.options.fileBlockTransparentClass);
};

Uploader.prototype.addRemoveDropzoneTransparentBackground = function() {
  if (this.isImagePresent()) {
    this.removeDropzoneBackground();
  } else {
    this.addDropzoneBackground();
  }
};

Uploader.prototype.isImagePresent = function() {
  var uploadedImageField = $('[name="' + this.$cloudinaryBlock.data('cloudinary-field') + '"]');
  return (this.$cloudinaryHashId.length > 0 && this.$cloudinaryHashId.val().length > 0) ||
         (this.$existingImageId.length > 0 && this.$existingImageId.val().length > 0) ||
         (uploadedImageField.length > 0 && uploadedImageField.val().length > 0);
};

Uploader.prototype.defaults = {
  loggerContext: 'Uploader',
  cloudinarySelector: '.cloudinary-fileupload',
  previewSelector: '.preview',
  progressBarSelector: '.progress',
  updateCloudinaryImagePublicIdSelector: '.image_public_id',
  maxFileSize: (10 * 1024 * 1024),
  allowedFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
  allowedFileMimeTypes: /image\/(gif|jpe?g|png)$/i,
  dragDropMode: true,
  // 0: loader, 1: % completion, 2: none
  progressMode: 1,
  loaderImage: 'assets/default.gif',
  fileBlockTransparentClass: 'transparent-bg',
  existingImageSelector: '.js-existing-image',
  showErrorsInFlash: false,
  minimumWidth: undefined,
  imageOptions: {
    width: 200,
    height: 200,
    displayType: 'limit',
    class: null
  },
};

// Class Functions

// This function finds all the image blocks inside the form and check to see if they have their
// image uploaded. If yes, it enables the form, else disables the form.
Uploader.enableOrDisableFormIfImagesPresent = function($form, imageBlockSelector) {
  var $imageBlocks = $form.find(imageBlockSelector);
  var isValid      = true;

  $.each($imageBlocks, function(index, imageBlock) {
    var uploader = new Uploader($(imageBlock));
    if (!uploader.isImagePresent()) {
      isValid = false;
      return;
    }
  });

  if (isValid) {
    $form.find('input[type=submit]').removeAttr('disabled');
  } else {
    $form.find('input[type=submit]').attr('disabled', true);
  }
};
