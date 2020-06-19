$(document).on('turbolinks:load', function () {
  imageCropper();
  sortByTitle();
  filterByCategory();

  $('.group-create-btn').click(function (e) {
    return $('#group-from').submit();
  });

  $('#upload-btn').click(function () {
    $('#cropImagePop').modal('hide');
    $('.item-img').click();
  })

  $('#groups, .delete-group-link').on("click", function(event) {
    event.preventDefault()
    $('#group-delete-modal').modal('show');
    $('.group-title').text(`Are you sure you want to delete "${$(this).data('name')}"?`);
    $('#delete-modal-group-link').attr('href', $(this).data('url'));
  })

  $('#cancel-delete').click(function () {
    $('#group-delete-modal').modal('hide');
  });

  if ($(".gambar").attr("src") == '') {
    $(".gambar").attr("src", "/assets/upload-img.jpg");
  }
  else {
    $(".gambar").attr("src", $(".gambar").attr("src"));
  }

  function sortByTitle() {
    $('#title-sort').on('change', function () {
      sortType = $(this).val();
      params = `sort_type=${sortType}`;
      fetchGroups(params);
    });
  }

  function filterByCategory() {
    var options = [];
    $('.group-categories a').on('click', function (event) {
      event.preventDefault();
      var $target = $(event.currentTarget),
        val = $target.attr('data-value'),
        $inp = $target.find('input'),
        idx;

      if ((idx = options.indexOf(val)) > -1) {
        options.splice(idx, 1);
        setTimeout(function () { $inp.prop('checked', false) }, 0);
      } else {
        if ($target.attr('data-type') == 'all') {
          options = val.split(',')
          $('input:checkbox').prop('checked', true)
        }
        else {
          options.push(val);
          setTimeout(function () { $inp.prop('checked', true) }, 0);
        }
      }

      params = `category_ids=${options.join(',')}`
      fetchGroups(params);
    });
  }

  function fetchGroups(params) {
    $('.loader').show()
    $.ajax({
      url: `/groups?${params}`,
      method: 'get',
      dataType: 'script'
    })
  }

  function imageCropper() {
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
      imageId = $(this).data('id');
      tempFilename = $(this).val();
      $('#cancelCropBtn').data('id', imageId);
      readFile(this);
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
  }

  $('#group-banner-upload').click(function () {
    $('#groupBannerUploadModal').modal('show');
  })

  $(function(){
    $('.users-pagination a').attr('data-remote', 'true')
  });

});

