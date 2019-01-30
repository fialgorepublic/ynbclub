$(document).ready(function(){
  a = []
  $('#change_permissions').click(function(){
    new_permissions = []
    old_permissions = []
    $('.add-permissions:checkbox:checked').each(function() {
      new_permissions.push({ controller: $(this).data('controller'), action: $(this).data('action')});
    });

    $('.add-permissions:checkbox:not(:checked)').each(function() {
      old_permissions.push({ controller: $(this).data('controller'), action: $(this).data('action')});
    });

    if (confirm(`Are you sure you want to change the permission for this user?`)){
      $.ajax({
        url: $(this).data('url'),
        type: 'post',
        dataType: 'json',
        data: { controllers: new_permissions, old_permissions: old_permissions },
        success: function(data) {
          window.location.href = '/permissions'
        },
        error: function(){
          alert("Something wrong with the server.")
        }
      });
    }
  });

  $('.add-permissions').change(function(){
    checked = $(this).is(':checked')
    if (checked) {
      a.push(checked);
      $('#change_permissions').removeClass('disabled');
    }
    else {
      a.pop();
      if(a.length == 0) {
        $('#change_permissions').addClass('disabled');
      };
    }
  })
});
