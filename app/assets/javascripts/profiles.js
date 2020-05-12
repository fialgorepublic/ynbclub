$(document).on('turbolinks:load', function(){
  initGetUsers();
  initLoader();
  sortByTitle();
  filterByCategory();
  initGetBlogs();
  sortBlogsByTitle();
  sortBlogsByTCategory();
  initGetConversations();
  sortConversationsByTitle();

  function initGetUsers() {
    $('#following-tab, #follower-tab').click(function() {
      tabId = $(this).attr('id').split('-')[0];
      if (tabId == 'follower') { $('#following-users').html(''); }
      else { $('#follower-users').html(''); }
      contentDivId = `#${tabId}-users`

      showLoader(contentDivId)
      $.ajax({
        url: `${$(this).data('url')}&type=${$(this).data('type')}`,
        dataType: 'script'
      })
    })
  }

  function initLoader(){
    $('#your-groups-next, #your-groups-previous').click(function(){
      showLoader($('#your-groups'));
    })

    $('#joined-groups-next, #joined-groups-previous').click(function () {
      showLoader($('#joined-groups'));
    })

    $('#your-blogs-next, #your-blogs-previous').click(function () {
      showLoader($('#your-blogs'));
    })

    $('#liked-blogs-next, #liked-blogs-previous').click(function () {
      showLoader($('#liked-blogs'));
    })

    $('#your-conversations-next, #your-conversations-previous').click(function () {
      showLoader($('#your-conversations'));
    })

    $('#liked-conversations-next, #liked-conversations-previous').click(function () {
      showLoader($('#liked-conversations'));
    })
  }

  function sortByTitle() {
    $('.group-title-sort').on('change', function () {
      sortType = $(this).val();
      showLoader($(`#${$(this).data('type')}`));
      userId = $(this).data('user-id');
      params = `sort_type=${sortType}&type=${$(this).data('type')}`;
      fetchGroups(params, userId);
    });
  }

  function filterByCategory() {
    var options = [];
    $('.group-categories-dashboard a').on('click', function (event) {
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

      dropDownEle = $target.parent().parent()
      type = dropDownEle.data('type');
      showLoader($(`#${type}`));
      params = `category_ids=${options.join(',')}&type=${type}`;
      userId = dropDownEle.data('user-id');
      fetchGroups(params, userId);
    });
  }

  function fetchGroups(params, userId) {
    $.ajax({
      url: `/users/${userId}/groups?${params}`,
      method: 'get',
      dataType: 'script'
    })
  }

  function initGetBlogs(){
    $('#blogs-tab').click(function () {
      showLoader($('#your-blogs'));
      showLoader($('#liked-blogs'));
      $("html, body").animate({ scrollTop: 300 }, 500);
      $.ajax({
        url: `${$(this).data('url')}`,
        dataType: 'script'
      })
    })
  }

  function sortBlogsByTitle(){
    $('.profile-blogs-sort').change(function() {
      type  = $(this).data('type');
      value = $(this).val();
      showLoader($(`#${type}`));
      url = `${$(this).data('url')}?type=${type}&sort=${value}`;
      fetchBlogs(url);
    });
  }

  function sortBlogsByTCategory() {
    $('.profile-blogs-category').change(function () {
      type = $(this).data('type');
      value = $(this).val();
      showLoader($(`#${type}`));
      url = `${$(this).data('url')}?type=${type}&category=${value}`;
      fetchBlogs(url);
    });
  }

  function fetchBlogs(url) {
    $.ajax({
      url: url,
      dataType: 'script'
    })
  }

  function initGetConversations() {
    $('#conversations-tab').click(function () {
      showLoader($('#your-conversations'));
      showLoader($('#liked-conversations'));
      $("html, body").animate({ scrollTop: 300 }, 500);
      fetchConversations($(this).data('url'));
    })
  }

  function sortConversationsByTitle() {
    $('.conversation-title-sort').change(function () {
      type = $(this).data('type');
      url = `${$(this).data('url')}&sort=${$(this).val()}`;
      showLoader($(`#${type}`));
      fetchConversations(url);
    })
  }

  function fetchConversations(url){
    $.ajax({
      url: url,
      dataType: 'script'
    })
  }

  function showLoader(contentDivId) {
    $(contentDivId).html('<div class="text-center" id="users-loader"><i class="fa fa-spin fa-circle-o-notch"></i></div>');
  }

  $("#remove-modal").click(function(){
    $("#new-blog").modal("hide")
    $("#create-blog").html('');
    $(".modal-backdrop").removeClass();
    blogsTab = document.getElementById("blogs-tab")
     if (blogsTab == null) {
    history.pushState({}, null, window.location.href.split("blogs")[0]+"blogs");
    }
    else {
      window.history.replaceState({},'','/dashboard');
    }
  })
});
