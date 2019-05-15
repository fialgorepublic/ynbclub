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

  $('.share-on-facebook').click(function () {
    blog_id = $(this).data('id');
    type    = $(this).data('type');
    blog    = $(this).data('attributes');
    already_shared_blog(blog_id)
    if (user_signed_in) {
      if (user_has_shared) { toastr.error('You already have shared this blog'); return false; }
      var url = createFBShareLink(blog_id, type, blog, '164286157812635');

      window.open(url);
    } else {
      hostname = window.location.hostname == 'localhost' ? 'http://localhost:3000' : window.location.hostname
      window.location.href = `${hostname}?signin=true`
    }
  });

  function already_shared_blog(blog_id) {
    $.ajax({
      url: `${blog_id}/shared`,
      method: 'get',
      dataType: 'json',
      async: false,
      success: function (data) {
        user_has_shared = data.shared
      }
    })
  }

  function createFBShareLink(id, type, blog, fbAppId) {
    var link = window.location.hostname == 'localhost' ? 'http://localhost:3000' : window.location.hostname
    var url = `http://www.facebook.com/dialog/feed?app_id=${fbAppId}
      &link=https://ambassador.saintlbeau.com/blog_detail?id=${id}
      &picture=${encodeURIComponent(`${blog.file_name}`)}
      &name=${blog.title}
      &caption=SainLBeau blogs
      &description=This is just for testing purpose
      &redirect_uri=${encodeURIComponent(`${link}/share_blog?id=${id}&value=${type}`)}
      &display=popup`;
    return url;
  }
});
