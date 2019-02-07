$(document).ready(function() {
  $('#sort-blogs, #category-dropdown').on('change', function(){
    sort_type = $('#sort-blogs').val();
    category_type = $('#category-dropdown').val();
    $('.loader').show()
    $.ajax({
      url: `/blogs?sort=${sort_type}&category=${category_type}`,
      type: 'GET',
      dataType: 'json',
      success: function(data) {
        $('.loader').hide();
        $('#blogs').html(data.attachmentPartial);
        $('#page').val(data.next_page)
        $('#load-more').show();
        if(data.current_page == data.total_pages) {
          $('#load-more').hide();
        }
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
        if(data.current_page == data.total_pages) {
          $('#load-more').hide();
        }
      },
      error: function(data) {
        $('.loader').hide()
        alert('Something Wentwrong!')
      }
    })
  })

  $(window).scroll(function() {
    if ($(this).scrollTop() >= 50) {        // If page is scrolled more than 50px
      $('#custom-topPage-btn').fadeIn(200);    // Fade in the arrow
    } else {
      $('#custom-topPage-btn').fadeOut(200);   // Else fade out the arrow
    }
  });

  $('#custom-topPage-btn').click(function() {      // When arrow is clicked
    $('body,html').animate({
      scrollTop : 0                       // Scroll to top of body
    }, 500);
  });
});
