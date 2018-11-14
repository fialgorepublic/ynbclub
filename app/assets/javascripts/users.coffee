$(document).ready ->
  $('#user_commission').focusout ->
    value = parseInt($(this).val())
    if value < 0 || value > 100
      $('#user_commission').parent().append "<span id=commission style=color:red;>Value must be between 0 and 100</span>"
    else
      $('#commission').remove();
