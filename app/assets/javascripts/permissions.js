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

    confirm = confirm(`Are you sure you want to change the permission for this user?`);
    if (confirm){
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
      $('#change_permissions').attr('disabled', false);
    }
    else {
      a.pop();
      if(a.length == 0) { $('#change_permissions').attr('disabled', true) };
    }
  })
});
