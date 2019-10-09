$(document).on('turbolinks:load', function () {
  var blogSearchtimerId = null;

  $('#sort-blogs, #category-dropdown').on('change', function(){
    searchBlogs();
  });

  // $('#search-by-title').click(function(){
  //   if ($('#blog-title-textbox').val() == '') { return false; }
  //   searchBlogs();
  // })

  $('#blog-title-textbox').keyup(function (e) {
    if (e.keyCode == 13) { return; }
    clearTimeout(blogSearchtimerId);
    blogSearchtimerId = setTimeout(searchBlogs.bind(undefined), 500);
  });

  // $('#clear-blog-filters').click(function(){
  //   if ($('#sort-blogs').val() == '0' && $('#blog-title-textbox').val() == '' && $('#category-dropdown').val() == '') { return; }
  //   $('#sort-blogs').val(0);
  //   $('#blog-title-textbox').val('');
  //   $('#category-dropdown').val('')
  //   fetchBlogs('', '', '');
  // })

  function searchBlogs(){
    sort_type     = $('#sort-blogs').val();
    category_type = $('#category-dropdown').val();
    title         = $('#blog-title-textbox').val();
    fetchBlogs(category_type, sort_type, title);
  }

  function fetchBlogs(category_type, sort_type, title) {
    $('.loader').show()
    $.ajax({
      url: `/blogs?sort=${sort_type}&category=${category_type}&title=${title}`,
      type: 'GET',
      dataType: 'script',
      success: function (data) {
      },
      error: function (data) {
        $('.loader').hide()
        alert('Something Wentwrong!')
      }
    })
  }

  $('#sort-blogs-list, #category-dropdown-blog-list, #per-page-blogs-list').on('change', function(){
    $('.loader').show();
    sort_type = $('#sort-blogs-list').val();
    category_type = $('#category-dropdown-blog-list').val();
    per_page = $('#per-page-blogs-list').val();
    // window.location.href = `/blogs/list?sort=${sort_type}&category=${category_type}`;
    $.ajax({
      url: `/blogs/list?sort=${sort_type}&category=${category_type}&per_page=${per_page}`,
      type: 'GET',
      dataType: 'script'
    })
  });

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
    url     = $(this).data('share-url');
    limit_url = $(this).data('limit-url');
    already_shared_blog(blog_id, url);
    sharing_limit_exceed(limit_url);
    if (user_signed_in) {
      if (user_has_shared) { toastr.error('You already have shared this blog'); return false; }
      if (limit_exceeded) { toastr.error('You have exceeded your limit to share blogs on facebook for today'); return false; }
      var url = createFBShareLink(blog_id, type, blog, '164286157812635');

      window.open(url);
    } else {
      hostname = window.location.hostname == 'localhost' ? 'http://localhost:3000?signin=true' : '/?signin=true'
      window.location.href = hostname
    }
  });
    
  function already_shared_blog(blog_id, url) {
    $.ajax({
      url: url,
      method: 'get',
      dataType: 'json',
      async: false,
      success: function (data) {
        user_has_shared = data.shared
      }
    })
  }

  function sharing_limit_exceed(url){
    $.ajax({
      url: url,
      method: 'get',
      dataType: 'json',
      async: false,
      success: function (data) {
        limit_exceeded = data.limit_exceeded
      }
    })
  }

  function createFBShareLink(id, type, blog, fbAppId) {
    var link = window.location.hostname == 'localhost' ? 'http://localhost:3000' : `https://${window.location.hostname}`
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

  $('#blogs-list').dataTable({
    "pagingType": "full_numbers",
    "paging": false,
    "info": false,
    "scrollY": 600,
    'scrollX': true
  });

  $(".publish-switch").change(function(event){
    status = $(this).prop("checked");
    id = event.target.id;
    if (confirm(`Are you sure?`)) {
      $.ajax({
        url: "/change_publish_status.json?id=" + id + "&status=" + status,
        method: "get",
        contentType: "application/json",
        success: function(data){
          if(data.success){
            $("#" + id).prop('checked', status == 'true');
            $("#blog-status-" + id).text(status == 'true' ? 'Published' : 'Unpublished');
          }else{
            toastr.error(data.message);
          }
        }
      })
    }else
      $("#" + id).prop('checked', !(status == 'true'));
  })

});
