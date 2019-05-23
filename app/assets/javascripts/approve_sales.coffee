( ->
  window.ApproveSales or (window.ApproveSales = {})

  ApproveSales.init = ->
    $("#paymentStatus").select2();
    $("#discountStatus").select2();
    $("#user_id").select2();
    $(".dateTime").datepicker format: "yyyy-mm-dd"

  document.addEventListener 'turbolinks:before-cache', ->
    $('#user_id').select2 'destroy'
    $("#paymentStatus").select2 'destroy'
    $("#discountStatus").select2 'destroy'
).call this
