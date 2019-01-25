$(document).ready(function(){
  $('#change_permissions').click(function(){
    controllers = []
    $('.add-permissions:checkbox:checked').each(function() { controllers.push(this.value) });
    confirm = confirm(`Are you sure you want to change the permission for this user?`);
    if (confirm){
      $.ajax({
        url: $(this).data('url'),
        type: 'post',
        dataType: 'json',
        data: { controllers: controllers },
        success: function(data) {
          window.location.href = '/permissions'
        },
        error: function(){
          alert("Something wrong with the server.")
        }
      });
    }
  });
});
