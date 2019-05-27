(->
  window.Payments or (window.Payments = {})

  Payments.applyFilter = ->
    $('#apply-filter').click ->
      since = $('#since').val()
      to_date = $('#to_date').val()
      user_ids = $('#user_id').val()
      if since == '' and to_date == ''
      else
        if since != ''
          if to_date == ''
            alert 'please select to date first.'
            return false
        if to_date != ''
          if since == ''
            alert 'please select to since first.'
            return false
      window.location.href = '/payments?search[start_date]=' + since + '&search[end_date]=' + to_date + '&search[partner]=' + user_ids

  Payments.searchPerform = ->
    $('#search-user').click ->
      search = $('#searchText').val()
      window.location.href = '/payments?text=' + search
      return

  Payments.addNewPayment = ->
    $('#make-new-payment').click ->
      $('#addPayment').modal 'show'
      $.ajax
        url: '/add_payment'
        type: 'get'
        dataType: 'json'
        processData: false
        success: (data) ->
          $('#new_payment').html data.html
          return
        error: (data) ->
          alert 'Error'
          return

  Payments.init = ->
    $('#user_id').select2()
    $('.dateTime').datepicker format: 'yyyy-mm-dd'
    window.paymentsTable = $("#payments-table").dataTable({
      searching: true,
      "pagingType": "full_numbers",
      "order": [[5, "desc"]],
      "paging": false,
      "info": false,
      scrollY:  600,
      scrollCollapse: true,
      scrollX: true
    })
    $('#searchText').keyup ->
      dInput = @value
      if dInput == ''
        $.ajax url: '/payments/clear_search'
      return

  document.addEventListener 'turbolinks:before-cache', ->
    $('#user_id').select2 'destroy'

).call this
