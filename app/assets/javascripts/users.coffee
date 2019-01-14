$(document).ready ->
  $('#user_commission').focusout ->
    value = parseInt($(this).val())
    if value < 0 || value > 100
      $('#user_commission').parent().append "<span id=commission style=color:red;>Value must be between 0 and 100</span>"
    else
      $('#commission').remove();

  $('#deduct_modal').click ->
    $('#user_id').val($(this).data('id'))

  $('#deduct_points').click ->
    value = $('#point_value').val();
    id = $('#user_id').val();
    url = `${$(this).data('url')}?id=${id}&point_value=${value}`

    $.ajax
      url: url,
      type: 'get',
      dataType: 'html'
