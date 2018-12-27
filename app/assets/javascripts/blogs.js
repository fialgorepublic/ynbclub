$(document).ready(function() {
  $('#sort-blogs').on('change', function(){
    sort_type = $(this).val();

    $('.loader').show()
    $.ajax({
      url: `/blogs?sort=${sort_type}`,
      type: 'GET',
      dataType: 'json',
      success: function(data) {
        $('.loader').hide();
        $('#blogs').html(data.attachmentPartial);
      },
      error: function(data) {
        $('.loader').hide()
        alert('Something Wentwrong!')
      }
    })
  })
});
