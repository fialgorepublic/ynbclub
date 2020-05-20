App.order = App.cable.subscriptions.create("UpdatePhoneNoStatusChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
  var value = data['status']
  table_row = $('#'+data['order'])[0]
   if(value == '1'){
      $(table_row).children('td, th').css('background-color', '#e8f4e7');
    }
    else if(value == '2'){
      $(table_row).children('td, th').css('background-color', '#fff5c7');
    }
    else if(value == '3'){
      $(table_row).children('td, th').css('background-color', '#f9dcbe');
    }
    else if(value == '4'){
      $(table_row).children('td, th').css('background-color', '#f0b9a2');
    }
    else if(value == '5'){
      $(table_row).children('td, th').css('background-color', '#fa9b9b');
    }
    if (window.location.href.includes("orders")) {
      toastr.success('Phone Status updated successuflly.');
    }

  }
});