$(document).on('turbolinks:load', function(){
  initGetUsers();

  function initGetUsers() {
    $('#following-tab, #follower-tab').click(function() {
      contentDivId = `#${$(this).attr('id').split('-')[0]}-users`
      $(contentDivId).html('<div class="text-center" id="users-loader"><i class="fa fa-spin fa-circle-o-notch"></i></div>')
      $.ajax({
        url: `${$(this).data('url')}&type=${$(this).data('type')}`,
        dataType: 'script'
      })
    })
  }
});
