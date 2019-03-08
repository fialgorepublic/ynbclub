$(document).ready(function() {
  $('#my-orders').dataTable( {
    "info":        false,
    "scrollX":     true,
    'pagination':  false,
    'paging':      false,
    "scrollY":     600,
    searching:     false,
    "order":       [],
    rowCallback: function(row, data, index){
            string_index = data[5].indexOf('"selected"');
            value = JSON.parse(data[5].substring(string_index, string_index + 20).split(' ')[1].split('=')[1])
            console.log(value);
            if(value == '1'){
              $('td', row).css('background-color', 'green');
            }
            else if(value == '2'){
              $('td', row).css('background-color', 'red');
            }
        }
  });

  $('#referral-sales').dataTable( {
    "pagingType": "full_numbers",
    "order": [[0, "desc"]],
    "paging": false,
    "info": false
  });

  $('.send_to_ghtk').click(function(){
    order_id = $(this).data('order-id');
    $('.loader').show();
    $.ajax({
      url: `/orders/${order_id}/send_to_ghtk`,
      type: 'get',
      contentType: 'json',
      error: function () {
        $('.loader').hide();
        alert('Error');
      }
    });
  });

  $('.edit_address').click(function(){
    order_id = $(this).data('order-id');
    $('#edit_address_modal').modal('show');
    $.ajax({
      url: `/orders/${order_id}/edit_address`,
      type: 'get',
      contentType: 'json',
      error: function () {
        $('.loader').hide();
        alert('Error');
      }
    });
  });

  $('.phone-status').change(function(){
    order_id = $(this).data('order-id');
    status = $(this).val();
    $.ajax({
      url: `/orders/${order_id}/update_phone_status?status=${status}`,
      type: 'get',
      contentType: 'json',
      success: function (data) {
        if(data.result) {
          toastr.success('Phone Status updated successuflly.');
          window.location.href = '/orders';
        }
        else
          toastr.error('Somethng Went wrong.')
      },
      error: function () {
        $('.loader').hide();
        alert('Error');
      }
    });
  });
})
