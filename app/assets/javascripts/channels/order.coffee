window.App.Channels ||= {}
window.App.Channels.Order ||= {}

App.Channels.Order.subscribe = ->
  console.log('Subscribed to order channel')
  App.order = App.cable.subscriptions.create('OrderChannel',
    connected: ->
      toastr.remove()
      console.log('Connected to order channel')
    disconnected: ->
      currentAction = $('body').data('action-name')
      currentController = $('body').data('controller-name')
      if currentController == 'orders' && currentAction == 'index'
        toastr.error 'Connecting to live updates..', 'Please reload the page if it take long time', { timeOut: 0 }
    received: (data) ->
      if data.order_id
        this.updatePhoneStatus data
      else
        this.updateTable data

    updatePhoneStatus: (data) ->
      value = data.status
      table_row = $('#' + data.order_id)[0]
      if value == '0'
        $(table_row).children('td, th').css 'background-color', '#f9f9f9'
      else if value == '1'
        $(table_row).children('td, th').css 'background-color', '#e8f4e7'
      else if value == '2'
        $(table_row).children('td, th').css 'background-color', '#fff5c7'
      else if value == '3'
        $(table_row).children('td, th').css 'background-color', '#f9dcbe'
      else if value == '4'
        $(table_row).children('td, th').css 'background-color', '#f0b9a2'
      else if value == '5'
        $(table_row).children('td, th').css 'background-color', '#fa9b9b'

      $('#order_' + data.order_id).val(value)

    updateTable: (data) ->
      order = $('#tbody')
      order.prepend data.order
      toastr.success 'New Order Placed.'
  )
