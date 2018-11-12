$( document ).ready(function(){
  $("#become-ambassador").click(function(event){
    event.preventDefault();
    apprise('Are You Sure You Want To Be a Brand Ambassador?', { 'verify': true }, function (r) {
      if (r) {
        var url = `/update_user_role?role_id=2`;//`${$(this).data('url')}/${$(this).data('role-id')}`
        $.ajax({
          url: url,
          type: 'GET',
          contentType: "json",
          success: function(data){
            if (data.buyer == "false") {
              $('#add_partner_information').modal('show');
              $('#selectRole').modal('hide');
            }
          }
        });
      } else { return; }
    });
  });
});
