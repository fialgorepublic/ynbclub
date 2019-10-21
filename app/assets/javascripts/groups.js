$(document).on('turbolinks:load', function () {
  $('.group-create-btn').click(function (e) {
    console.log('Inside butotn submit');
    return $('#group-from').submit();
  });
  
  function gropuFormValidations(nameError, descriptionError) {
    $('#group-from').validate({
      rules: {
        'resource[name]': {
          required: true
        },
        'resource[description]': {
          required: true
        }
      },
      messages: {
        'resource[name]': {
          required: nameError,
        },
        'resource[description]': {
          required: descriptionError
        }
      }
    });
  }

  if ($(".gambar").attr("src") == '') {
    $(".gambar").attr("src", "/assets/upload-img.jpg");
  }
  else {
    $(".gambar").attr("src", $(".gambar").attr("src"));
  }

  var $uploadCrop,
    tempFilename,
    rawImg,
    imageId;
  function readFile(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $('.upload-demo').addClass('ready');
        $('#cropImagePop').modal('show');
        rawImg = e.target.result;
      }
      reader.readAsDataURL(input.files[0]);
    }
    else {
      swal("Sorry - you're browser doesn't support the FileReader API");
    }
  }

  $uploadCrop = $('#upload-demo').croppie({
    viewport: {
      width: 400,
      height: 400,
    },
    enforceBoundary: false,
    enableExif: true
  });

  $('#cropImagePop').on('shown.bs.modal', function () {
    // alert('Shown pop');
    $uploadCrop.croppie('bind', {
      url: rawImg
    }).then(function () {
      console.log('jQuery bind complete');
    });
  });

  $('.item-img').on('change', function () {
    imageId = $(this).data('id'); tempFilename = $(this).val();
    $('#cancelCropBtn').data('id', imageId); readFile(this);
  });

  $('#cropImageBtn').on('click', function (ev) {
    $uploadCrop.croppie('result', {
      type: 'base64',
      format: 'jpeg',
      size: { width: 200, height: 200 }
    }).then(function (resp) {
      $('#item-img-output').attr('src', resp);
      $('#item-img').val(resp);
      $('#cropImagePop').modal('hide');

    });
  });
});
