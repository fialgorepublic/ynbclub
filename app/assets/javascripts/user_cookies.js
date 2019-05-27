$(document).on('turbolinks:load', function () {
  $('#logout-link').click(function() {
    Cookies.remove('saintlbeau_user_email', { domain: 'saintlbeau.com' })
  })
});
