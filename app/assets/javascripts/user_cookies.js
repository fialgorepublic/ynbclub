$(document).ready(function(){
  $('#logout-link').click(function(){
    document.cookie = 'saintlbeau_current_user=-1;';
  })
});
