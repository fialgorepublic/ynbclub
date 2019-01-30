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
    else {
      for(var checkbox in a) {
        selected_checbox = a[checkbox];
        selected_checbox.attr('checked', false)
      }

      a = []
    }
  });

  $('.add-permissions').change(function(){
    checked = $(this).is(':checked')
    if (checked) { a.push($(this)) };
    $('#change_permissions').removeClass('disabled');
  })
});
