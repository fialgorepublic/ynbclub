$(document).ready(function(){
  $('#logout-link').click(function() {
    Cookies.remove('saintlbeau_user_email');
  })
});
