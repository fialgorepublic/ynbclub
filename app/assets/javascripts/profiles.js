$(document).on('turbolinks:load', function(){
  initGetUsers();
  initGroupsLoader();
  sortByTitle();
  filterByCategory();

  function initGetUsers() {
    $('#following-tab, #follower-tab').click(function() {
      contentDivId = `#${$(this).attr('id').split('-')[0]}-users`
      showLoader(contentDivId)
      $.ajax({
        url: `${$(this).data('url')}&type=${$(this).data('type')}`,
        dataType: 'script'
      })
    })
  }

  function initGroupsLoader(){
    $('#your-groups-next, #your-groups-previosu').click(function(){
      showLoader($('#your-groups'));
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

  function showLoader(contentDivId){
    $(contentDivId).html('<div class="text-center" id="users-loader"><i class="fa fa-spin fa-circle-o-notch"></i></div>');
  }
});
