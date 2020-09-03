$(document).on('turbolinks:load', function () {
  var blogSearchtimerId = null;
  $('#sort-blogs, #category-dropdown, #publish-dropdown, #sort-blogs-by-date').on('change', function(){
    if (this.id == "sort-blogs-by-date"){
      $("#sort-blogs").val('')
    }else if (this.id == "sort-blogs") {
      $("#sort-blogs-by-date").val('')
    }
    $('#page').val('1');
    fetchBlogs();
  });

  $('#blog-title-textbox').keyup(function (e) {
    if (e.keyCode == 13) { return; }
    clearTimeout(blogSearchtimerId);
    $('#page').val('1');
    blogSearchtimerId = setTimeout(fetchBlogs.bind(undefined), 500);
  });

  function fetchBlogs() {
    $('.loader').show()
    $('#search-form-button').click();
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

  $('.close_btn_blg_in').click(function(){
    window.history.replaceState({}, '', '/blogs')
  });

  $("#load-more").click(function() {
    nextPage = $('#next_page').val()
    if(nextPage != "") {
      $('#page').val(nextPage);
      fetchBlogs();
    }
  })

  $(document).on('click', '.create-blog-modal #remove-facebook-share-content', function(){
    $('.facebook-share-content').remove()
  })

  $(window).scroll(function() {
    if ($(this).scrollTop() >= 50) {        // If page is scrolled more than 50px
      $('#custom-topPage-btn').fadeIn(200);    // Fade in the arrow
    } else {
      $('#custom-topPage-btn').fadeOut(200);   // Else fade out the arrow
    }

    if (window.location.href.endsWith("blogs") && (($(window).scrollTop() + $(window).height() > $(document).height() - 100) || ($(window).scrollTop() == $(document).height() - $(window).height()) )) {
      $("#load-more").click();
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
    user_signed_in = $(this).data("user-signed-in")
    already_shared_blog(blog_id, url);
    sharing_limit_exceed(limit_url);
    if (user_signed_in) {
      if (user_has_shared) { toastr.error('You already have shared this blog'); return false; }
      if (limit_exceeded) { toastr.error('You have exceeded your limit to share two blogs in an hour'); return false; }
      var url = createFBShareLink(blog_id, type, blog, '1660844573983661');

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
    var root_url = "<%= Rails.env.staging? ? 'https://ambassador-staging.saintlbeau.com' : 'https://ambassador.ynbclub.com' %>"
    var url = `http://www.facebook.com/dialog/feed?app_id=${fbAppId}
      &link=${root_url}/blog_detail?id=${id}
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
      $.ajax({
        url: "/change_publish_status.json?id=" + id + "&status=" + status,
        method: "get",
        contentType: "application/json",
        success: function(data){
          if(data.success){
            $("#" + id).prop('checked', status == 'true');
            $("#blog-status-" + id).text(status == 'true' ? I18n.t('publish_label') : I18n.t('unpublish_label'));
            toastr.success(data.message);
          }else{
            $("#" + id).prop('checked', !(status == 'true'));
            toastr.error(data.message)
          }

        },
        error: function(data){
          $("#" + id).prop('checked', !(status == 'true'));
          toastr.error('You need to change default picture before publishing your blog.')
        }
      })

  })

    $(".reject-switch").change(function(event){
    status = $(this).prop("checked");
    id = event.target.id.split("-")[1];

    $.ajax({
      url: `${id}/reject`,
      method: "get",
      contentType: "application/json",
      success: function(data){
      }
    })
  })

  $(document).on('click', '#myModal #open-edit-blog-modal', function(e) {
    blogId = $(this).find('i').data('blog-id');
    edit_blog(blogId);
  })
});

  function blog_show(id){
    $("#myModal").addClass('dynamic-blog-'+id)
    $.ajax({
      url: '/show_blog/'+id,
      type: 'get',
    })
  }

  function edit_blog(id){
    $(".create-blog-modal").html('');
    $("#myModal").modal('hide')
    $.ajax({
      url: id+"/edit",
      type: 'get',
      data: {edit_blog: 0},
      success: function(data) {
        $('body').addClass('modal-open');
        $('body').removeAttr('style');
        $('#create-blog').html(data);
        history.pushState({}, null, window.location.href + "/edit")
      },
      error: function(data) {
        $('.loader').hide()
        alert('Something Wentwrong!')
      }
    })
  }
