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
            if(data[5] == 'Yes'){
              $('td', row).css('background-color', 'green');
            }
            else if(data[5] == 'No'){
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
})
