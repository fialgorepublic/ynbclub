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

  $("#load-more").click(function() {
    page = $('#page').val();

    $('.loader').show();

    $.ajax({
      url: `/blogs?page=${page}`,
      type: 'GET',
      dataType: 'json',
      success: function(data) {
        $('.loader').hide();
        $('#blogs').append(data.attachmentPartial);
        $('#page').val(data.next_page)
        if(data.next_page == data.total_pages) {
          $('#load-more').hide();
        }
      },
      error: function(data) {
        $('.loader').hide()
        alert('Something Wentwrong!')
      }
    })
  })
});
