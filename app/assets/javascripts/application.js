// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require jquery.slick
//= require best_in_place
//= require best_in_place.jquery-ui
//= require turbolinks
//= require datatables
//= require google_analytics
//= require bootstrap.min.js
//= require jquery.validate.min.js
//= require toastr.js
//= require BootstrapMenu.min.js
//= require apprise.min.js
//= require select2.js
//= require cocoon
//= require orders
//= require payments
//= require blogs
//= require groups
//= require search
//= require profiles
//= require users
//= require approve_sales
//= require buyer_to_ambassador
//= require register
//= require common
//= require i18n
//= require i18n/translations
//= require localization
//= permissions
//= cable
//= conversations
//= shared_url
//= require jquery.lazyload
// user_cookies
//= require js.cookies.min.js
//= require emoji/dist/emojionearea.js
//= require quill.min
//= require quill.global
//= require quil
//= require medium-editor.js
//= require medium-editor-insert-plugin.js
//= require local-time
//= require jquery.easy-autocomplete
//= require warranties
//= require_tree .


$(document).on('turbolinks:load', function () {
  $("img.lazy").lazyload({
    failure_limit : 1000,
    event: "lazyload",
    threshold : 1000,
    effect: "fadeIn",
    skip_invisible: false
    })
  $(window).scroll();

  unsubscribeChannel();
  function unsubscribeChannel(){
    console.log('In unsubscribeChannel method');
    currentController = $('body').data('controller-name');
    currentActionName = $('body').data('action-name');
    if (currentController != 'orders') {
      if (App.order == undefined || App.order.connected.length == 0) { return; }
      console.log('Unsubscribed Channel')
      App.order.unsubscribe();
    }
  }
});
