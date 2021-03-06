$(document).on 'turbolinks:load', ->
  $('#user_commission').focusout ->
    value = parseInt($(this).val())
    if value < 0 || value > 100
      $('#user_commission').parent().append "<span id=commission style=color:red;>Value must be between 0 and 100</span>"
    else
      $('#commission').remove();

  $('.deduct_modal').click ->
    $('#user_id').val($(this).data('id'))
    $('#deduct_points_modal').modal('show')

  $('#deduct_points').click ->
    value = $('#point_value').val()
    id = $('#user_id').val()
    url = $(this).data('url') + '?id='+ id + '&point_value=' + value

    if value == ''
      return $('#value_error').text('Please provide the values')
    else if value.includes('-')
      return $('#value_error').text('Number is not valid, Please give positive number')

    $.ajax
      url: url,
      type: 'get',
      dataType: 'json',
      success: (data) ->
        if data.success
          toastr.success data.message
          window.location.href = '/users/users/ban?deduct_points=true'
        else
          toastr.error data.message
      error: ->
        alert "Something wentwrong"

  $('.ban-user').change ->
    value = $(this).prop('checked')
    string = if value then I18n.t('ban_user_confirmation') else I18n.t('resume_user_confirmation')
    box = confirm(string);
    if box
      $.ajax
        url: $(this).data('url') + '&value=' + value
        type: 'get'
        dataType: 'json'
        success: (data) ->
          if data.success
            toastr.success data.message
          else
            $(this).attr 'checked', false
            toastr.error data.message
          return
    else
      $(this).attr 'checked', false
    return
