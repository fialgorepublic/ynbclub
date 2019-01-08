$(document).ready(function(){
  $('#logout-link').click(function() {
    localStorage.removeItem('saintlbeau_current_user');
  })
});
